require 'rails_helper'

RSpec.describe 'RegisrationsController', type: :request do
  describe '#new' do
    it '画面の表示に成功すること' do
      get new_user_session_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    it '新規ユーザー登録に成功すること' do
      user_params = FactoryBot.attributes_for(:user)
      expect do
        post user_registration_path, params: { user: user_params }
      end.to change(User, :count).by(1)
    end
  end

  describe '#edit' do
    let(:user) { FactoryBot.create(:user) }

    it '画面の表示に成功すること' do
      sign_in user
      get edit_user_registration_path
      expect(response).to have_http_status(:ok)
    end

    it 'ログインしていない場合、ログインページにリダイレクトされること' do
      get edit_user_registration_path
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe '#update' do
    let(:user) { FactoryBot.create(:user) }
    let(:update_params) { { name: 'Updated User', current_password: user.password } }

    it 'ユーザー編集に成功すること' do
      sign_in user
      patch user_registration_path, params: { user: update_params }
      expect(user.reload.name).to eq('Updated User')
    end

    it 'ログインしていない場合、ログインページにリダイレクトされること' do
      patch user_registration_path
      expect(response).to redirect_to new_user_session_path
    end
  end
end
