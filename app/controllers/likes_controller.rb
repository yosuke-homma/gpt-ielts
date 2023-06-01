class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :exam

  def create
    @like = current_user.likes.build(exam: @exam)
    if @like.save
      redirect_to @exam
    else
      redirect_to @exam, alert: @like.errors.full_messages.join(', ')
    end
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
