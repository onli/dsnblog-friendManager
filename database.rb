require 'sqlite3'

class Database

    def initialize 
        @db = SQLite3::Database.new "database.db"
        begin
            @db.execute "CREATE TABLE IF NOT EXISTS users(
                            mail TEXT PRIMARY KEY,
                            url TEXT UNIQUE
                            );"
            @db.execute "CREATE TABLE IF NOT EXISTS subscriptions(
                            id TEXT,
                            subscriber TEXT,
                            UNIQUE(id, subscriber),
                            FOREIGN KEY (id) REFERENCES users(mail) ON DELETE CASCADE,
                            FOREIGN KEY (subscriber) REFERENCES users(mail) ON DELETE CASCADE
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

    def subscribe(id, subscriber)
        begin
            @db.execute("INSERT INTO subscriptions(id, subscriber) VALUES(?, ?)", id, subscriber)
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

    def getSubscribers(id)
        subscribers = []
        begin
            @db.execute("SELECT subscriber FROM subscriptions WHERE id = ?", id) do |row|
                subscribers.push(row["subscriber"])
            end
        rescue => error
            puts error
            return "not registered!"
        end
        return subscribers
    end

end