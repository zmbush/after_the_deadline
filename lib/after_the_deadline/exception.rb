module AfterTheDeadline
  class Exception < StandardError
    def initialize(msg = "Something went wrong")
      super
    end
  end
end