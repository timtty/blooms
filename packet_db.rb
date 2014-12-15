require './packet_db_entry'
class PacketDB
  DEFAULT_AGE_MAX = 300

  def initialize
    @db = {}
  end

  def poll(hash, message)
    if @db.key? hash
      if @db[hash].aged_out?
        puts "#{Time.now.to_i}|#{message.in_port}|D|#{message.macsa}/#{message.macda}"
      else
        puts "#{Time.now.to_i}|#{message.in_port}|M|#{message.macsa}/#{message.macda}"
      end
    else
      puts "#{Time.now.to_i}|#{message.in_port}|A|#{message.macsa}/#{message.macda}"
      @db[hash] = PacketDBEntry.new(message.macsa, message.macda, message.in_port, DEFAULT_AGE_MAX)
    end
  end
end