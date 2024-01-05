module Api
  module V1
    class UsersController < ApplicationController
      # before_action :authenticate_user!, except: [:index, :show]

      def index
        @users = User.recent.all
        render json: { users: @users }
      end

      def show
        @user = User.find(params[:id])
        @exams = @user.exams.recent.all.eager_load([:user])
        render json: { user: @user, exam: @exam }
      end

      def following
        @user = User.find(params[:id])
        @users = @user.following
        render json: { user: @user, following: @users }
      end

      def followers
        @user = User.find(params[:id])
        @users = @user.followers
        render json: { user: @user, followers: @users }
      end
    end
  end
end
