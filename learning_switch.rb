# encoding: utf-8
$LOAD_PATH.unshift File.expand_path(File.join File.dirname(__FILE__), 'lib')

require 'fdb'

# An OpenFlow controller that emulates a layer-2 switch.
class LearningSwitch < Controller
  add_timer_event :age_fdb, 5, :periodic

  def start
    @fdb = FDB.new
  end

  def packet_in(datapath_id, message)
    return if message.macda.reserved?
    return if message.udp? and message.total_len < 128

    puts @fdb.learn message
    port_no = @fdb.lookup(message.macda)
    if port_no
      flow_mod datapath_id, message, port_no
      packet_out datapath_id, message, port_no
    else
      flood datapath_id, message
    end
  end

  def age_fdb
    @fdb.age
  end

  private

  def flow_mod(datapath_id, message, port_no)
    send_flow_mod_add(
      datapath_id,
      match: ExactMatch.from(message),
      actions: ActionOutput.new(port_no)
    )
  end

  def packet_out(datapath_id, message, port_no)
    send_packet_out(
      datapath_id,
      in_port: message.in_port,
      buffer_id: 0xffffffff,
      data: message.data,
      actions: ActionOutput.new(port_no)
    )
  end

  def flood(datapath_id, message)
    packet_out datapath_id, message, OFPP_FLOOD
  end
end
