require 'rails_helper'

RSpec.describe 'ExamsController', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, email: 'otheruser@email.com') }
  let(:exam) { FactoryBot.create(:exam) }
  let(:exam_params) { FactoryBot.attributes_for(:exam).except(:review) }

  describe '#index' do
    it '画面の表示に成功すること' do
      get exams_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#new' do
    context '正常系', openai: true do
      it '画面の表示に成功すること' do
        sign_in user
        get new_exam_path
        expect(response).to have_http_status(:ok)
      end
    end

    context '異常系' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトすること' do
          get new_exam_path
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe '#create' do
    context '正常系', openai: true do
      before do
        sign_in user
      end

      it '受験結果の保存に成功し、受験結果のページにリダイレクトすること' do
        post exams_path, params: { exam: exam_params }
        expect(response).to redirect_to exam_path(user.exams.last)
      end

      it '受験結果の保存に成功し、受験履歴が1つ増えること' do
        expect do
          post exams_path, params: { exam: exam_params }
        end.to change(Exam, :count).by(1)
      end
    end

    context '異常系' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトすること' do
          post exams_path, params: { exam: exam_params }
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe '#show' do
    it '画面の表示に成功すること' do
      get exam_path exam
      expect(response).to have_http_status(:ok)
    end

    it 'テストの内容と一致すること' do
      get exam_path exam
      aggregate_failures do
        expect(response.body).to include exam.question
        expect(response.body).to include exam.answer
        expect(response.body).to include exam.review
      end
    end
  end

  describe '#destroy' do
    context '正常系' do
      before do
        sign_in exam.user
      end

      it '受験履歴の削除に成功し、rootにリダイレクトすること' do
        delete exam_path exam
        expect(response).to redirect_to root_url
      end

      it '受験履歴の削除に成功し、受験履歴の数が1つ減ること' do
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
        it 'rootにリダイレクトすること' do
          sign_in other_user
          delete exam_path exam
          expect(response).to redirect_to root_url
        end
      end
    end
  end
end
