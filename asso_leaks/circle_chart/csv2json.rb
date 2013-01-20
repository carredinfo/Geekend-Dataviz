require 'csv'
require 'json'

children = {}

assos = CSV.open('../asso.csv', 'r', {:headers => true})

assos.each do |asso|
  if asso['annee'].to_i == 2011

    children[asso['domaine']] ||= []
    children[asso['domaine']] << {
      :name => asso['nom'],
      :size => asso['sub_fonctionnelle'].to_i
    }
  end
end

asso_json = {
  :name => "AssoLeaks",
  :children => []
}

children.each do |name, value|
  asso_json[:children] << {:name => name, :children => value}
end

File.open('asso.json', 'w') do |f|
  f.write(asso_json.to_json)
end
