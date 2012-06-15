# override that BigDecimal will be converted to JSON number
class BigDecimal
  def as_json(options = nil) self end
  def encode_json(encoder) to_s end #:nodoc:
end
