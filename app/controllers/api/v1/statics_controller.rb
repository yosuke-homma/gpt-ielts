module Api
  module V1
    class StaticsController < ApplicationController
      def index
        render json: { message: 'Welcome to my API' }
      end
    end
  end
end
