module AfterTheDeadline
  class Error
    attr_reader :string, :description, :precontext, :type, :suggestions, :url

    def initialize(hash)
      raise "#{self.class} must be initialized with a Hash" unless hash.kind_of?(Hash)
      [:string, :description, :precontext, :type, :url].each do |attribute|
        self.send("#{attribute}=", hash[attribute.to_s])
      end
      self.suggestions = hash['suggestions'].nil? ? [] : [*hash['suggestions']['option']]
    end

    def info(theme = nil)
      return unless self.url
      uri = URI.parse self.url
      uri.query = (uri.query || '') + "&theme=#{theme}"
      Net::HTTP.get(uri).strip
    end

    def to_s
      "#{self.string} (#{self.description})"
    end

    def eql?(other)
      self.class.equal?(other.class) &&
        string == other.string &&
        description == other.description &&
        type == other.type
    end
    alias_method :==, :eql?

    def hash
      string.hash ^ description.hash ^ type.hash
    end

    private
      attr_writer :string, :description, :precontext, :type, :suggestions, :url
  end
end

