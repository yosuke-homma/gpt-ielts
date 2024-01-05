require 'rails_helper'

RSpec.describe 'RegisrationsController', type: :request do
  describe '#create' do
    context '正常系' do
      it '新規ユーザー登録に成功すること' do
        user_params = FactoryBot.attributes_for(:user)
        expect do
          post user_registration_path, params: { user: user_params }
        end.to change(User, :count).by(1)
        expect(response).to have_http_status(:success)
      end
    end

    context '異常系' do
      context 'emailが含まれていない場合' do
        it '新規ユーザー登録に失敗すること' do
          user_params = FactoryBot.attributes_for(:user)
          user_params[:email] = ''
          expect do
            post user_registration_path, params: { user: user_params }
          end.not_to change(User, :count)
          expect(response).to have_http_status '422'
        end
      end

      context 'passwordが含まれていない場合' do
        it '新規ユーザー登録に失敗すること' do
          user_params = FactoryBot.attributes_for(:user)
          user_params[:password] = ''
          expect do
            post user_registration_path, params: { user: user_params }
          end.not_to change(User, :count)
          expect(response).to have_http_status '422'
        end
      end
    end
  end

  describe '#update' do
    let(:user) { FactoryBot.create(:user) }

    context '正常系' do
      context '名前を変更する場合' do
        let(:update_params) { { name: 'Updated User' } }

        it 'ユーザー編集に成功すること' do
          sign_in user
          patch user_registration_path, params: { user: update_params }
          expect(user.reload.name).to eq('Updated User')
          expect(response).to have_http_status(:success)
        end
      end

      context 'メールアドレスを変更する場合' do
        let(:update_params) { { email: 'updated_testuser@email.com' } }

        it 'ユーザー編集に成功すること' do
          sign_in user
          patch user_registration_path, params: { user: update_params }
          expect(user.reload.email).to eq('updated_testuser@email.com')
          expect(response).to have_http_status(:success)
        end
      end

      context 'パスワードを変更する場合' do
        let(:update_params) { { password: 'updated_password', password_confirmation: 'updated_password' } }

        it 'ユーザー編集に成功すること' do
          sign_in user
          patch user_registration_path, params: { user: update_params }
          expect(user.reload.password).to eq('updated_password')
          expect(response).to have_http_status(:success)
        end
      end
    end

    context '異常系' do
      let(:update_params) { { name: 'Updated User' } }

      context 'ログインしていない場合' do
        it 'ユーザー編集に失敗すること' do
          patch user_registration_path, params: { user: update_params }
          expect(user.reload.name).to eq('Test User')
          expect(response).to have_http_status '401'
          expect(response.body).to eq('You need to sign in or sign up before continuing.')
        end
      end

      context '確認用のパスワードが一致しない場合' do
        let(:update_params) { { password: 'updated_password' } }

        it 'ユーザー編集に成功すること' do
          sign_in user
          patch user_registration_path, params: { user: update_params }
          expect(response).to have_http_status '422'
        end
      end
    end
  end
end
