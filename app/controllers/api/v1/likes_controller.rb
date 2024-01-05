module Api
  module V1
    class LikesController < ApplicationController
      before_action :authenticate_user!
      before_action :exam

      def create
        @like = current_user.likes.build(exam: @exam)
        if @like.save
          render json: @like, status: :created, location: @like
        else
          render json: @like.errors.full_messages.join(', '), status: :unprocessable_entity
        end
      end

      def destroy
        Like.find_by(user: current_user, exam: @exam).destroy
        head :no_content
      end

      private

      def exam
        @exam = Exam.find(params[:id])
      end
    end
  end
end
