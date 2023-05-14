class Openai
  OPENAI_MODEL = 'gpt-3.5-turbo'

  def initialize
    @client = OpenAI::Client.new
  end

  def question
    @client.chat(
      parameters: {
        model: OPENAI_MODEL,
        messages:
        [{
          role: 'user',
          content: generate_writing_question
        }],
        temperature: 0.7,
      }
    ).dig('choices', 0, 'message', 'content')
  end

  def review(question, answer)
    @client.chat(
      parameters: {
        model: OPENAI_MODEL,
        messages:
        [{
          role: 'user',
          content: evaluate_essay(question, answer)
        }],
        temperature: 0.7,
      }
    ).dig('choices', 0, 'message', 'content')
  end

  private

  def generate_writing_question
    <<~EXAM
      Could you provide me with a Writing Task 2 prompt for the IELTS exam?
      You only need to give me one, that would be perfect.
    EXAM
  end

  def evaluate_essay(question, answer)
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
