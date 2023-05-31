class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :exam

  def create
    current_user.like(@exam)
    redirect_to @exam
  end

  def destroy
    Like.find_by(user: current_user, exam: @exam).destroy
    redirect_to @exam
  end

  private

  def exam
    @exam = Exam.find(params[:id])
  end
end
