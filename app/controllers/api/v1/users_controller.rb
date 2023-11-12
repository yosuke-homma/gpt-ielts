module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]

      def index
        @users = User.recent.all
        render json: @users
      end

      def show
        @user = User.find(params[:id])
        @exams = @user.exams.recent.all.eager_load([:user])
        render json: { user: @user, exams: @exams }
      end

      def following
        @title = 'Following'
        @user = User.find(params[:id])
        @users = @user.following
        render 'show_follow'
      end

      def followers
        @title = 'Followers'
        @user = User.find(params[:id])
        @users = @user.followers
        render 'show_follow'
      end
    end
  end
end
