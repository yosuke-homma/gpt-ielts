class ExamsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, except: [:index, :show, :new, :create]

  def index
    @exams = current_user.exams.recent.all.eager_load([:user])
  end

  def show
    @exam = Exam.find(params[:id])
  end

  def new
    @exam = Exam.new
    @exam.question = Openai.new.question
  end

  def create
    @exam = current_user.exams.build(exam_params)
    @exam.review = Openai.new.review(exam_params['question'], exam_params['answer'])
    if @exam.save
      redirect_to exam_path @exam
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    @exam = Exam.find(params[:id])
    @exam.destroy
    flash[:notice] = 'Exam deleted'
    redirect_to root_url, status: :see_other
  end

  private

  def exam_params
    params.require(:exam).permit(:question, :answer)
  end

  def correct_user
    @exam = current_user.exams.find_by(id: params[:id])
    redirect_to root_url if @exam.nil?
  end
end
