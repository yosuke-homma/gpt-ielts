require 'rails_helper'

RSpec.describe 'ExamsController', type: :request do
  describe '#index' do
    it '画面の表示に成功すること' do
      get exams_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#new' do
    let(:user) { FactoryBot.create(:user) }

    it '画面の表示に成功すること', openai: true do
      sign_in user
      get new_exam_path
      expect(response).to have_http_status(:ok)
    end

    it 'ログインしていない場合、ログインページにリダイレクトされること' do
      get new_exam_path
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe '#show' do
    let(:exam) { FactoryBot.create(:exam) }

    it '画面の表示に成功すること' do
      get exam_path exam
      expect(response).to have_http_status(:ok)
    end

    it 'テストの内容と一致すること' do
      get exam_path exam
      expect(response.body).to include exam.question
      expect(response.body).to include exam.answer
      expect(response.body).to include exam.review
    end
  end

  describe '#destroy' do
    let(:exam) { FactoryBot.create(:exam) }

    context '正常系' do
      it '受験履歴の削除に成功し、rootにリダイレクトすること' do
        sign_in exam.user
        delete exam_path exam
        expect(response).to redirect_to root_url
      end

      it '受験履歴の削除に成功し、受験履歴の数が1つ減ること' do
        sign_in exam.user
        expect do
          delete exam_path exam
        end.to change(Exam, :count).by(-1)
      end
    end

    context '異常系' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトすること' do
          delete exam_path exam
          expect(response).to redirect_to new_user_session_path
        end
      end

      context '他のユーザーの受験履歴を削除しようとした場合' do
        let(:other_user) { FactoryBot.create(:user, email: 'otheruser@email.com') }

        it 'rootにリダイレクトすること' do
          sign_in other_user
          delete exam_path exam
          expect(response).to redirect_to root_url
        end
      end
    end
  end
end
