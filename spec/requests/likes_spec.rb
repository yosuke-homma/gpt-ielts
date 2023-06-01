require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_users_exam) { FactoryBot.create(:exam) }

  before do
    sign_in user
  end

  describe '#create' do
    context '正常系' do
      it '受験履歴へのいいねが成功すること' do
        expect do
          post likes_path, params: { id: other_users_exam.id }
        end.to change(Like, :count).by(1)
      end
    end

    context '異常系' do
      context 'ログインしていない場合' do
        before do
          sign_out user
        end

        it 'ログインページにリダイレクトすること' do
          post likes_path, params: { id: other_users_exam.id }
          expect(response).to redirect_to new_user_session_path
        end
      end

      context '既にいいねしている投稿にいいねしようとした場合' do
        let!(:like) { FactoryBot.create(:like, user_id: user.id, exam_id: other_users_exam.id) }

        it 'いいねできないこと' do
          expect do
            post likes_path, params: { id: other_users_exam.id }
          end.not_to change(Like, :count)
        end
      end

      context '自分の投稿にいいねしようとした場合' do
        let(:exam) { FactoryBot.create(:exam, user:) }

        it 'いいねできないこと' do
          expect do
            post likes_path, params: { id: exam.id }
          end.not_to change(Like, :count)
        end
      end
    end
  end

  describe '#destroy' do
    let!(:like) { FactoryBot.create(:like, user_id: user.id, exam_id: other_users_exam.id) }

    context '正常系' do
      it 'いいねの解除が成功すること' do
        expect do
          delete like_path(other_users_exam)
        end.to change(Like, :count).by(-1)
      end
    end

    context '異常系' do
      context 'ログインしていない場合' do
        before do
          sign_out user
        end

        it 'ログインページにリダイレクトすること' do
          delete like_path(other_users_exam)
          expect(response).to redirect_to new_user_session_path
        end
      end

      context 'いいねしていない投稿のいいねを解除しようとした場合' do
        it 'いいねの解除に失敗する' do
          expect do
            delete like_path(other_users_exam.id + 1)
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
