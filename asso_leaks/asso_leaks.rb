#encoding: utf-8
require 'csv'
require 'cgi'
require 'rubygems'
require 'net/http'
require 'open-uri'
require 'hpricot'

@uri = "http://subventions.associations.toulouse.fr/presentation/recherche/formulaireAssociations.html"
@response = ""

open(@uri, "User-Agent" => "Carredinfo - Geekend Dataviz",
           "Referer" => "http://www.carredinfo.fr") { |f|
  puts "Fetched document #{f.base_uri}"
  @response = f.read
}

doc = Hpricot(@response)

@years = []
(doc/"//*[@id='formulaire']/form/fieldset[1]/div/select/option").each do |option|
  @years << option.attributes['value']
end

(doc/"//*[@id='formulaire']/form/fieldset[2]/div/select/option").each do |domain|
  @domain = {:label => domain.attributes['label'], :value => domain.attributes['value']}
  puts "#{domain[:label]} :: #{domain[:value]}"

  # Do not scrape "Tous les domaines"
  if domain[:value] != "LTE="

    @years.each do |year|

      @year_response = ""
      @crits = []

      uri = URI(@uri)
      req = Net::HTTP::Post.new(uri.path)
      req.content_type = "application/x-www-form-urlencoded"
      req.set_form_data('nom_assoc' => '',
                        'domaine_activite' => @domain[:value],
                        'annee' => year)

      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req)
      end
      page = Hpricot(res.body)

      puts "Parsing domain"

      (page/"//*[@name='crit']").each do |crit|
        @crits << crit.attributes['value']
      end

      (page/"//*[@name='nav_page_alpha']").each do |nav|

        @nav_response = ""

        open(@uri + "?nav_page_alpha=" + CGI::escape(nav.attributes['value']),
             "User-Agent" => "Carredinfo - Geekend Dataviz", "Referer" => "http://www.carredinfo.fr") { |f|
          #puts "Fetched nav #{f.base_uri}"
          @nav_response = f.read
        }

        nav = Hpricot(@nav_response)
        (nav/"//*[@name='crit']").each do |crit|
          @crits << crit.attributes['value']
        end

      end

      #puts @crits
      @crits.each do |crit|

        @crit_response = ""

        open(@uri + "?crit=" + CGI::escape(crit),
             "User-Agent" => "Carredinfo - Geekend Dataviz", "Referer" => "http://www.carredinfo.fr") { |f|
          puts "Fetched crit #{f.base_uri}"
          @crit_response = f.read
        }

        asso = Hpricot(@crit_response)
        info = {
          :name => "",
          :status => "",
          :adresse => "",
          :code_postal => "",
          :commune => "",
          :sub_fonctionnelle => "",
          :sub_exceptionnelle => "",
          :sub_equipement => ""
        }

        info[:name] = (asso/"center/legend").inner_html.unpack("C*").pack("U*").gsub(/ - #{year}$/, "")

        resultats = (asso/"div.bloc_resultat")
        info[:status] = resultats[0].at("span").inner_html
        info[:adresse] = resultats[2].at("span").inner_html
        info[:code_postal] = resultats[3].at("span").inner_html
        info[:commune] = resultats[4].at("span").inner_html

        subs = (asso/"div.bloc_resultat_euros")
        info[:sub_fonctionnelle] = subs[0].at("span").inner_html.gsub(".","").gsub(/,.*/ ,"")
        info[:sub_exceptionnelle] = subs[1].at("span").inner_html.gsub(".","").gsub(/,.*/ ,"")
        info[:sub_equipement] = subs[2].at("span").inner_html.gsub(".","").gsub(/,.*/ ,"")

        CSV.open("asso.csv", "ab:UTF-8") do |csv|
          csv << [
            crit,
            year,
            domain[:label],
            info[:name].unpack("C*").pack("U*"),
            info[:status].unpack("C*").pack("U*"),
            info[:adresse].unpack("C*").pack("U*"),
            info[:code_postal],
            info[:commune].unpack("C*").pack("U*"),
            info[:sub_fonctionnelle],
            info[:sub_exceptionnelle],
            info[:sub_equipement]
          ]
        end

      end
    end
  end

end
