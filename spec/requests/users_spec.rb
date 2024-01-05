require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe '#index' do
    context '正常系' do
      it '200が返ってくること' do
        get users_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#show' do
    context '正常系' do
      it '200が返ってくること' do
        get user_path(user)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#following' do
    context '正常系' do
      it '200が返ってくること' do
        get following_user_path(user)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'ログインしていない場合' do
      before do
        sign_out user
      end

      it '401が返ってくること' do
        get following_user_path(user)
        expect(response).to have_http_status '401'
        expect(response.body).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end

  describe '#followers' do
    context '正常系' do
      it '200が返ってくること' do
        get followers_user_path(user)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'ログインしていない場合' do
      before do
        sign_out user
      end

      it '401が返ってくること' do
        get followers_user_path(user)
        expect(response).to have_http_status '401'
        expect(response.body).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end
end
