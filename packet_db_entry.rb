class PacketDBEntry
  attr_reader :macsa
  attr_reader :macda
  attr_reader :port_no
  attr_writer :age_max

  def initialize(macsa, macda, port_no, age_max)
    @macsa = macsa
    @macda = macda
    @port_no = port_no
    @age_max = age_max
    @last_update = Time.now
  end

  def aged_out?
    Time.now - @last_update > @age_max
  end
end