require 'rails_helper'

RSpec.describe 'ExamsController', type: :request do
  describe '#index' do
    it '画面の表示に成功すること' do
      get exams_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#new' do
    it '画面の表示に成功すること', openai: true do
      get new_exam_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show' do
    it '画面の表示に成功すること', openai: true do
      exam = create(:exam)
      get exam_path exam
      expect(response).to have_http_status(:ok)
    end

    it 'テストの内容と一致すること', openai: true do
      exam = create(:exam)
      get exam_path exam
      expect(response.body).to include exam.question
      expect(response.body).to include exam.answer
      expect(response.body).to include exam.review
    end
  end
end
