# frozen_string_literal: true

require './lib/response/base.rb'

module Response
  class Success < Response::Base
    def success?
      true
    end
  end
end
