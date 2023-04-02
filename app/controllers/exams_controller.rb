class ExamsController < ApplicationController

  def index
  end

  def new
    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
          model: "gpt-3.5-turbo", # Required.
          messages: [{ 
            role: "user", 
            content: generate_writing_question
            }], # Required.
          temperature: 0.7,
      })
    @question = response.dig("choices", 0, "message", "content")
    @exam = Exam.new
  end

  def create
    @exam = Exam.new(exam_params)
    @exam.save
  end

  private

  def generate_writing_question
    <<~EXAM
    Could you please provide me with a Writing Task 2 prompt for the IELTS exam?
    You only need to give me one, that would be perfect. 
    EXAM
  end

  def exam_params
    params.require(:exam).permit(:question, :answer)
  end
end
