require 'bundler'
Bundler.require
require 'mechanize'
require 'sqlite3'

db = SQLite3::Database.new("users.sqlite3")
for i in 1..167800
  events_path = "http://peatix.com/event/#{i}/view"
  begin
    agent = Mechanize.new
    page = agent.get("#{events_path}")
    users_dom = page.at('.tix-organizer-name a')
    url = users_dom.get_attribute(:href)
    p "#{url}|#{i}"
    records = db.execute("select * from users where url = '#{url}'")
    if records.length > 0
      records.each do |row|
        appear = row[1] + 1
        sql = "update users set appear = ? where url = '#{url}'"
        db.execute(sql, appear)
      end
    else
      sql = "insert into users values (?, ?)"
      db.execute(sql, url, 1)
    end
    sleep(5)
  rescue => e
      p e
  end
end
#end
