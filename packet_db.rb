require './packet_db_entry'
class PacketDB
  DEFAULT_AGE_MAX = 300

  def initialize
    @db = {}
  end

  def poll(hash, message)
    if message.udp?
      type = 'udp'
    elsif message.ipv4?
      type = 'tcpip'
    elsif message.icmpv4?
      type = 'icmp'
    elsif message.icmpv4_dst_unreach?
      type = 'err'
    elsif message.icmpv4_echo_reply?
      type = 'icmp'
    elsif message.icmpv4_echo_request?
      type = 'icmp'
    elsif message.icmpv4_redirect?
      type = 'icmp'
    elsif message.igmp?
      type = 'igmp'
    elsif message.igmp_membership_query?
      type = 'igmp'
    elsif message.lldp?
      type = 'lldp'
    elsif message.rarp?
      type = 'rarp'
    elsif message.rarp_reply?
      type = 'rarp'
    elsif message.rarp_request?
      type = 'rarp'
    elsif message.arp?
      type = 'arp'
    elsif message.arp_reply?
      type = 'arp'
    elsif message.arp_request?
      type = 'arp'
    end

    if @db.key? hash
      if @db[hash].aged_out?
        puts "#{Time.now.to_i}|#{message.in_port}|D|#{message.macsa}/#{message.macda}.#{type}"
      else
        puts "#{Time.now.to_i}|#{message.in_port}|M|#{message.macsa}/#{message.macda}.#{type}"
      end
    else
      puts "#{Time.now.to_i}|#{message.in_port}|A|#{message.macsa}/#{message.macda}.#{type}"
      @db[hash] = PacketDBEntry.new(message.macsa, message.macda, message.in_port, DEFAULT_AGE_MAX)
    end
  end
end