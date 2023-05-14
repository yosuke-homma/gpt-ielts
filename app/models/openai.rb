class Openai
  OPENAI_MODEL = 'gpt-3.5-turbo'

  def initialize
    @client = OpenAI::Client.new
  end

  def question
    chat(parameters(messages: generate_writing_question))
  end

  def review(question, answer)
    chat(parameters(messages: evaluate_essay(question, answer)))
  end

  private

  def chat(parameters)
    response = @client.chat(parameters:)
    response.dig('choices', 0, 'message', 'content')
  end

  def parameters(messages:)
    {
      model: OPENAI_MODEL,
      messages:,
      temperature: 0.7
    }
  end

  def generate_writing_question
    content = <<~EXAM
      Could you provide me with a Writing Task 2 prompt for the IELTS exam?
      You only need to give me one, that would be perfect.
    EXAM

    generate_message(content)
  end

  def evaluate_essay(question, answer)
    content = <<~REVIEW
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

    generate_message(content)
  end

  def generate_message(content)
    [{ role: 'user', content: }]
  end
end
