require './packet_db'

class OFBlooms < Controller
  def start
    @pktdb = PacketDB.new
  end

  def packet_in(datapath_id, message)
    hash = "#{message.macsa}-#{message.macda}"
    @pktdb.poll hash, message
  end
end