module Api
  module V1
    class ExamsController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :correct_user, except: [:index, :show, :create, :users_who_liked]

      def index
        @exams = Exam.recent.all.eager_load([:user])
        render json: @exams
      end

      def show
        @exam = Exam.find(params[:id])
        render json: @exam
      end

      def create
        @exam = current_user.exams.build(exam_params)
        @exam.review = Openai.new.review(exam_params['question'], exam_params['answer'])
        if @exam.save
          render json: @exam, status: :created, location: @exam
        else
          render json: @exam.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @exam = current_user.exams.find(params[:id])
        @exam.destroy
        head :no_content
      end

      def users_who_liked
        @users = Exam.find(params[:id]).liked_users
        render json: @users
      end

      private

      def exam_params
        params.require(:exam).permit(:question, :answer)
      end

      def correct_user
        @exam = current_user.exams.find_by(id: params[:id])
        render json: { message: 'Not Found' }, status: :not_found if @exam.nil?
      end
    end
  end
end
