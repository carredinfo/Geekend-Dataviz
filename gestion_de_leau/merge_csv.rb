#!/usr/bin/env ruby

require 'csv'

keys = [ :name, :id, :text1, :text2 ]

unless ARGV.length == 2
  puts "Merges file-1.csv and file-2.csv, combining columns for duplicate keys"
  puts "Usage: #{File.basename $0} <file-1.csv> <file-2.csv>"
  exit 1
end

a = CSV.open(ARGV[0],'r').to_a.find_all { |z| z.size == keys.length }.inject({}) { |h,z| h[z[keys.index(:id)]] = (z.delete_at(keys.index(:id)); z); h }
b = CSV.open(ARGV[1],'r').to_a.find_all { |z| z.size == keys.length }.inject({}) { |h,z| h[z[keys.index(:id)]] = (z.delete_at(keys.index(:id)); z); h }

ids = a.keys | b.keys 

merged = ids.inject([]) do |list,id| 
  merge_rows = [ a[id] || b[id].collect{nil}, b[id] || a[id].collect{nil} ]
  columns = []
  merge_rows[0].each_index do |i|
    columns << ( merge_rows[0][i].to_s + ' ' + merge_rows[1][i].to_s).strip
  end
  columns.insert(keys.index(:id), id)
  list << CSV.generate_line(columns)
  list
end

puts merged.join("\n")