class PracticeController < ApplicationController

  def index
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
    question = response.dig("choices", 0, "message", "content")
    render html: question
  end

  private

  def generate_writing_question
    <<~EXAM
    Could you please provide me with a Writing Task 2 prompt for the IELTS exam?
    You only need to give me one, that would be perfect. 
    EXAM
  end
end
