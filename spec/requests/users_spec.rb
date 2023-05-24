require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe '#index' do
    context '正常系' do
      it '画面の表示に成功すること' do
        get users_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#show' do
    context '正常系' do
      it '画面の表示に成功すること' do
        get user_path(user)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#following' do
    context '正常系' do
      it '画面の表示に成功すること' do
        get following_user_path(user)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'ログインしていない場合' do
      before do
        sign_out user
      end

      it 'ログインページにリダイレクトする' do
        get following_user_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#followers' do
    context '正常系' do
      it '画面の表示に成功すること' do
        get followers_user_path(user)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'ログインしていない場合' do
      before do
        sign_out user
      end

      it 'ログインページにリダイレクトする' do
        get followers_user_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
