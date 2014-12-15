# encoding: utf-8

require 'forwarding_entry'

# A database that keeps pairs of a MAC address and a port number
class FDB
  DEFAULT_AGE_MAX = 300

  def initialize
    @db = {}
  end

  def lookup(mac)
    entry = @db[mac]
    entry && entry.port_no
  end

  def learn(message)
    mac = "#{message.macsa}-#{message.macda}"
    port_no = message.in_port

    entry = @db[mac]
    if entry
      entry.update port_no

      "#{Time.now.to_i}|#{port_no}|M|#{mac}"
    else
      @db[mac] = ForwardingEntry.new(mac, port_no, DEFAULT_AGE_MAX)

      "#{Time.now.to_i}|#{port_no}|A|#{mac}"
    end
  end

  def age
    @db.delete_if do |_mac, entry|
      if entry.aged_out?
        "#{Time.now.to_i}|#{entry.port_no}|D|#{_mac}"
      end
      entry.aged_out?
    end
  end
end
