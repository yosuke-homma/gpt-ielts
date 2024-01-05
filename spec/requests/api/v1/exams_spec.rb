require 'rails_helper'

RSpec.describe 'ExamsController', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, email: 'otheruser@email.com') }
  let(:exam) { FactoryBot.create(:exam) }
  let(:exam_params) { FactoryBot.attributes_for(:exam).except(:review) }

  describe '#index' do
    it '200が返ってくること' do
      get exams_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    context '正常系', openai: true do
      before do
        sign_in user
      end

      it '受験結果の保存に成功し、受験履歴が1つ増えること' do
        expect do
          post api_v1_exams_path, params: { exam: exam_params }
        end.to change(Exam, :count).by(1)
        expect(response).to have_http_status '201'
      end
    end

    context '異常系' do
      context 'ログインしていない場合' do
        it '401が返ってくること' do
          post api_v1_exams_path, params: { exam: exam_params }
          expect(response).to have_http_status '401'
          expect(response.body).to eq('You need to sign in or sign up before continuing.')
        end
      end
    end
  end

  describe '#show' do
    it '200が返ってくること' do
      get api_v1_exam_path exam
      expect(response).to have_http_status '200'
    end

    it 'テストの内容と一致すること' do
      get api_v1_exam_path exam
      parsed_response = JSON.parse(response.body)
      aggregate_failures do
        expect(parsed_response['question']).to include exam.question
        expect(parsed_response['answer']).to include exam.answer
        expect(parsed_response['review']).to include exam.review
      end
    end
  end

  describe '#destroy' do
    context '正常系' do
      before do
        sign_in exam.user
      end

      it '受験履歴の削除に成功し、受験履歴の数が1つ減ること' do
        expect do
          delete api_v1_exam_path exam
        end.to change(Exam, :count).by(-1)
        expect(response).to have_http_status '204'
      end
    end

    context '異常系' do
      context 'ログインしていない場合' do
        it '401が返ってくること' do
          delete api_v1_exam_path exam
          expect(response).to have_http_status '401'
          expect(response.body).to eq('You need to sign in or sign up before continuing.')
        end
      end

      context '他のユーザーの受験履歴を削除しようとした場合' do
        it '404が返ってくること' do
          sign_in other_user
          delete api_v1_exam_path exam
          expect(response).to have_http_status '404'
          expect(JSON.parse(response.body)['message']).to eq('Not Found')
        end
      end
    end
  end

  describe '#users_who_liked' do
    let!(:like) { FactoryBot.create(:like, user:, exam:) }

    context '正常系' do
      it '200が返ってくること' do
        sign_in user
        get users_who_liked_api_v1_exam_path(exam)
        expect(response).to have_http_status '200'
      end
    end

    context '異常系' do
      context 'ログインしていない場合' do
        it '401が返ってくること' do
          get users_who_liked_api_v1_exam_path(exam)
          expect(response).to have_http_status '401'
          expect(response.body).to eq('You need to sign in or sign up before continuing.')
        end
      end
    end
  end
end
