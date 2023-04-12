class ExamsController < ApplicationController

  def index
    @exams = Exam.all
  end

  def new
    @exam = Exam.new
    @exam.question = Openai.new.question
  end
  
  def create
    @exam = Exam.new(exam_params)
    @exam.review = Openai.new.review(exam_params["question"], exam_params["answer"])
    if @exam.save
      redirect_to exam_path @exam
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    @exam = Exam.find(params[:id])
  end

  private

  def exam_params
    params.require(:exam).permit(:question, :answer)
  end
end
