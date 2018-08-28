require "sqlite3"
#require 'csv'

db = SQLite3::Database.open ":trades:"


# 1. Provide a Sales Summary:
#         For each Sales Rep, generate Year to Date, Month to Date, Quarter to
#         Date, and Inception to Date summary of cash amounts sold across all
#         funds.

#execute sql query to select sales reps from table
rep_list = db.execute( "SELECT DISTINCT REP FROM Transactions")
puts '********************'
puts 'REPORT ONE'

#iterate through list of sales reps
#set current date variables to use for later querying
#query sales ytd, mtd, qtd, inception for all sales rep_list
#rescue return 0 if sales come up as 0 to not throw errors
#display total amounts and print report to terminal
rep_list.each do |rep|
  current_date = DateTime.now
  current_day = current_date.strftime('%d')
  current_year = current_date.strftime('%Y')
  current_month = current_date.strftime('%m')
  begin
    sales_ytd = db.execute( "SELECT SUM(shares*price) FROM Transactions
    where type = 'SELL' and rep = ? and date >= " + current_year + "-1-1
    group by rep", rep[0])
  rescue  => e
    sales_ytd = 0
  end

  begin
    sales_mtd = db.execute( "SELECT SUM(shares*price) FROM Transactions
    where type = 'SELL' and rep = ? and date >= " + current_year + "-" + current_month + "-1 and
    date <= " + current_year + "-" + current_month + "-" + current_day +
    "group by rep", rep[0])
  rescue => e
    sales_mtd = 0
  end


  if (current_month == "01" || current_month ==  "02" ||  current_month == "03") then current_qmonth = "01"

  elsif (current_month == "04" || current_month ==  "05" || current_month ==  "06") then current_qmonth = "04"

  elsif (current_month == "07" || current_month ==  "08" || current_month ==  "09") then current_qmonth = "07"

  elsif (current_month == "10" || current_month ==  "11" || current_month ==  "12") then current_qmonth = "10"

  end
  begin
    sales_qtd = db.execute( "SELECT SUM(shares*price) FROM Transactions
    where type = 'SELL' and rep = ? and date >= " + current_year + "-" + current_qmonth + "-1 and
    date <= " + current_year + "-" + current_month + "-" + current_day +
    "group by rep", rep[0])
  rescue => e
    sales_qtd = 0
  end

  begin
    sales_inception = db.execute( "SELECT SUM(shares*price) FROM Transactions
    where type = 'SELL' and rep = ?
    group by rep", rep[0])
  rescue => e
    sales_inception = 0

  end
  puts "SALES REP: " + rep[0], "YTD: $ " + sales_ytd[0][0].to_s, "MTD: $ " + sales_mtd[0][0].to_s, "QTD: $ " + sales_qtd[0][0].to_s, "INCEPTION: $ " + sales_inception[0][0].to_s
end



# 2. Provide an Assets Under Management Summary:
#     For each Sales Rep, generate a summary of the net amount held by
#     investors across all funds.

#sql query to select sales reps and investors from transactions table
#iterate through array to select the sum from the transations buy/sell per
#print report to terminal
rep_inv_list = db.execute( "SELECT DISTINCT REP, investor FROM Transactions")
puts '********************'
puts 'REPORT TWO'

rep_inv_list.each do |rep|
  aum_buy = db.execute( "SELECT SUM(shares*price) FROM Transactions
  where type = 'BUY' and rep = ? and investor = ?
  group by rep, investor", rep[0], rep[1])
  aum_sell = db.execute( "SELECT SUM(shares*price) FROM Transactions
  where type = 'SELL' and rep = ? and investor = ?
  group by rep, investor", rep[0], rep[1])
  puts "SALES REP: " + rep[0], "INVESTOR: " + rep[1], "TOTAL AMOUNT HELD: $" + (aum_buy.join.to_f - aum_sell.join.to_f).to_s
end


# 3. Break Report:
#     Assuming the information in the data provided is complete and accurate,
#     generate a report that shows any errors (negative cash balances,
#     negative share balance) by investor.


# 4. Investor Profit:
#     For each Investor and Fund, return net profit or loss on investment.

#sql query to find investor and fund from transactions table
#iterate through fund and investor list
#find sums of buy and sells from fund data 
#print report to terminal
inv_fund_list = db.execute( "SELECT DISTINCT investor, fund FROM Transactions")
puts '********************'

puts 'REPORT FOUR'
inv_fund_list.each do |inv|
  fund_buy = db.execute( "SELECT SUM(shares*price) FROM Transactions
  where type = 'BUY' and investor = ? and fund = ?
  group by rep, investor", inv[0], inv[1])
  fund_sell = db.execute( "SELECT SUM(shares*price) FROM Transactions
  where type = 'SELL' and investor = ? and fund = ?
  group by rep, investor", inv[0], inv[1])
  puts "INVESTOR: " + inv[0], "FUND: " + inv[1], "NET: $" + (fund_sell.join.to_f - fund_buy.join.to_f).to_s
end
