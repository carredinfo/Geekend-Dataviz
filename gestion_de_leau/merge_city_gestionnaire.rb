#!/usr/bin/env ruby

require 'csv'

cities = CSV.open('cities.csv', 'r', {:headers => true})
gestionnaires = CSV.open('gestionnaires.csv', 'r', {:headers => true})
prices = CSV.open('prixdeleau31.csv', 'r', {:headers => true})

# Clean cities csv
def clean_cities(cities)
  CSV.open('region_cities.csv', 'wb') do |csv|
    csv << ['NomVille','MAJ','CodePostal','CodeINSEE','CodeRegion','Latitude','Longitude','Eloignement']
    cities.each do |city|
      codePostal = city["CodePostal"].to_i
      if codePostal >= 31000 && codePostal < 32000
        csv << city.to_hash.values
      end
    end
  end
end
# clean_cities(cities)

region_cities = CSV.open('region_cities.csv', 'r', {:headers => true})

CSV.open('map_data.csv', 'wb') do |csv|

  # csv header
  csv << ['city_code', 'city_name', 'population', 'lat', 'lng', 'public_gestion', 'price']

  # build data row for each city
  region_cities.each do |city|

    p city['CodeINSEE']

    # retrieve city gestion data
    city_gestion = nil
    gestionnaires.each do |gestion|
      if city['CodeINSEE'].to_i == gestion['Commune'].to_i
        city_gestion = gestion
      end
      break if city_gestion
    end
    gestionnaires.rewind

    # retrieve price data
    price = 0
    prices.each do |priceItem|
      if city['CodeINSEE'].to_i == priceItem['CodeINSEE'].to_i
        price = priceItem['prix'].to_f
      end
      break if price > 0
    end
    prices.rewind

    if city_gestion
      p city_gestion.first
      csv << [
        city['CodeINSEE'],
        city['NomVille'],
        city_gestion['PopLegaleTotale'],
        city['Latitude'],
        city['Longitude'],
        city_gestion['categ'] =~ /^9.*/ ? 0 : 1,
        price
      ]
    end
  end
end
