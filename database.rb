require 'sqlite3'

class Database

    def initialize 
        @db = SQLite3::Database.new "database.db"
        begin
            @db.execute "CREATE TABLE IF NOT EXISTS users(
                            mail TEXT PRIMARY KEY,
                            url TEXT UNIQUE
                            );"
            @db.execute "PRAGMA foreign_keys = ON;"
            @db.results_as_hash = true
        rescue => error
            puts error
        end
    end

    def addUser(mail, url)
        begin
            @db.execute("INSERT INTO users(mail, url) VALUES(?, ?)", mail, url)
        rescue => error
            puts error
        end
    end

    def getUrl(mail)
        begin
            return @db.execute("SELECT url FROM users WHERE mail = ?", mail)[0]['url']
        rescue => error
            puts error
            return "not registered!"
        end
    end

end