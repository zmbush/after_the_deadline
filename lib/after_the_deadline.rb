require 'crack'
require 'net/http'
require 'uri'

require 'after_the_deadline/constants'
require 'after_the_deadline/exception'
require 'after_the_deadline/error'
require 'after_the_deadline/metrics'
require 'after_the_deadline/client'

module AfterTheDeadline
  
  class << self
    def client(uri: BASE_URI, api_key: nil, dictionary: nil, ignore_types: DEFAULT_IGNORE_TYPES)
      AfterTheDeadline::Client.new(uri: uri, api_key: api_key, dictionary: dictionary, ignore_types: ignore_types)
    end
  end

end

