require "sqlite3"
require 'csv'
require 'date'


db = SQLite3::Database.new ":trades:"

  db.execute "CREATE TABLE IF NOT EXISTS Transactions(Id INTEGER PRIMARY KEY, Date TEXT, Type TEXT, Shares REAL,
  Price REAL, Fund TEXT, Investor TEXT, Rep TEXT)"


 CSV.foreach("Data.csv", headers: true) do |row|
   trade_date = Date.strptime(row[0], '%m/%d/%y')
   formatted_date = trade_date.strftime('%F')
   db.execute "INSERT or REPLACE INTO Transactions (Date, Type, Shares, Price, Fund, Investor, Rep)
   values ( ?, ?, ?, ?, ?, ?, ? )", [formatted_date, row['TXN_TYPE'], row['TXN_SHARES'], row['TXN_PRICE'].delete('$ ,'), row['FUND'], row['INVESTOR'], row['SALES_REP']]
 end


 #TXN_DATE,TXN_TYPE,TXN_SHARES,TXN_PRICE,FUND,INVESTOR,SALES_REP
