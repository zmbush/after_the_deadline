module AfterTheDeadline
  class Metrics
    attr_reader :spell, :grammar, :stats, :style

    def initialize(array)
      unless array.kind_of?(Array) && array.all? {|i| i.kind_of?(Hash) }
        raise "#{self.class} must be initialized with an Array of Hashes"
      end

      self.spell, self.grammar, self.stats, self.style = {}, {}, {}, {}
      array.each do |metric|
        self.send(metric['type'])[metric['key']] = metric['value']
      end
    end

    private
      attr_writer :spell, :grammar, :stats, :style
  end
end