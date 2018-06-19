# frozen_string_literal: true

require './lib/response/base.rb'

module Response
  class Error < Response::Base
    DEFAULT_ERROR_MESSAGE = 'Something went wrong!'

    def success?
      false
    end

    def error_message
      @details[:error_message] || DEFAULT_ERROR_MESSAGE
    end
  end
end
