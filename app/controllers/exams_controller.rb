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
    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo", # Required.
        messages: [{ 
          role: "user", 
          content: evaluate_writing(exam_params["question"], exam_params["answer"])
          }], # Required.
          temperature: 0.7,
          })
    @exam = Exam.new(exam_params)
    @exam.review = response.dig("choices", 0, "message", "content")
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

  def generate_writing_question
    <<~EXAM
    Could you provide me with a Writing Task 2 prompt for the IELTS exam?
    You only need to give me one, that would be perfect. 
    EXAM
  end

  def evaluate_writing(question, answer)
    <<~REVIEW
    Could you evaluate this essay for me based on the Writing Task 2 prompt 
    for the IELTS exam, and let me know the score on a scale of 0 (the lowest) to 9 (the highest)?

    Question:
    #{question}

    Answer:
    #{answer}

    Please make sure your response follows the same format as the one provided below.

    Task response: from 0 to 9
    Please write the details here

    Coherence and cohesion: from 0 to 9
    Please write the details here

    Lexical resource: from 0 to 9
    Please write the details here

    Grammatical range and accuracy: from 0 to 9
    Please write the details here
    REVIEW
  end
end
