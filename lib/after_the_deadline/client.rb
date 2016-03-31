module AfterTheDeadline
  class Client
    
    @custom_dictionary = []
    @ignore_types = AfterTheDeadline::DEFAULT_IGNORE_TYPES
    @api_key = nil
    @uri = BASE_URI

    def initialize(uri: nil, api_key: nil, dictionary: nil, ignore_types: nil)
      set_custom_dictionary(dictionary || [])
      set_ignore_types(ignore_types)
      @uri = uri
      @api_key = api_key
    end

    def set_custom_dictionary(dict)
      if dict.kind_of?(Array)
        @custom_dictionary = dict
      elsif dict.kind_of?(String)
        File.open(dict) { |f| @custom_dictionary = f.readlines.map &:strip }
      end
    end

    def set_ignore_types(types)
      @ignore_types = types if types.kind_of?(Array)
    end

    def set_api_key(key)
      @api_key = key
    end

    def set_language(language)
      language.downcase!
      unless AfterTheDeadline::SUPPORTED_LANGUAGES.include? language
        raise AfterTheDeadline::Exception.new ("Unsupported language #{language}. Supported languages are #{AfterTheDeadline::SUPPORTED_LANGUAGES}")
      end

      @uri = 'en'.eql?(language) ? BASE_URI : "http://#{language}.service.afterthedeadline.com"
      # do not return anything (the assignation in this case)
      nil
    end

    # Invoke the checkDocument service with provided text.
    #
    # Returns list of AfterTheDeadline::Error objects.
    def check(data)
      results = Crack::XML.parse(perform('/checkDocument', :data => data))['results']
      return [] if results.nil? # we have no errors in our data

      raise "Server returned an error: #{results['message']}" if results['message']
      errors = if results['error'].kind_of?(Array)
        results['error'].map { |e| AfterTheDeadline::Error.new(e) }
      else
        [AfterTheDeadline::Error.new(results['error'])]
      end

      # Remove any error types we don't care about
      errors.reject! { |e| @ignore_types.include?(e.description) }

      # Remove spelling errors from our custom dictionary
      errors.reject! { |e| e.type == 'spelling' && @custom_dictionary.include?(e.string) }
      return errors
    end
    alias :check_document :check

    # Invoke the stats service with provided text.
    #
    # Returns AfterTheDeadline::Metrics object.
    def metrics(data)
      results = Crack::XML.parse(perform('/stats', :data => data))['scores']
      return if results.nil? # we have no stats about our data
      AfterTheDeadline::Metrics.new results['metric']
    end
    alias :stats :metrics


    private

    def perform(action, params)
      params[:key] = @api_key if @api_key
      response = Net::HTTP.post_form URI.parse("#{@uri}#{action}".gsub("//","/")), params
      raise "Unexpected response code from AtD service: #{response.code} #{response.message}" unless response.is_a? Net::HTTPSuccess
      response.body
    end
  end
end