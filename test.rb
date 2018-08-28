require 'csv'

#create new CSV file
CSV.open('test123.csv', 'wb') << ['Header','Test']

datas = ['One','Two','Three']

#loop through datas and append new row to end of file
datas.each do |row|
    data = [row, (row + 'wowser')]
    puts row, data
    CSV.open('test123.csv', 'ab') << data

end
