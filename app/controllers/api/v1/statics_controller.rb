module Api
  module V1
    class StaticsController < ApplicationController
      def index
        render json: {  message: 'Welcome to my api.' }
      end
    end
  end
end
