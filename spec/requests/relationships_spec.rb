require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe '#create' do
    context '正常系' do
      it 'ユーザーのフォローに成功すること' do
        expect do
          post relationships_path, params: { followed_id: other_user.id }
        end.to change(Relationship, :count).by(1)
      end
    end

    context '異常系' do
      context 'ログインしていない場合' do
        before do
          sign_out user
        end

        it 'ログインページにリダイレクトすること' do
          post relationships_path, params: { followed_id: other_user.id }
          expect(response).to redirect_to new_user_session_path
        end
      end

      context '既にフォローしているユーザーをフォローしようとした場合' do
        let!(:relationship) { FactoryBot.create(:relationship, follower_id: user.id, followed_id: other_user.id) }

        it 'ActiveRecord::RecordNotUniqueエラーが生じてフォローできないこと' do
          expect do
            post relationships_path, params: { followed_id: other_user.id }
          end.to raise_error(ActiveRecord::RecordNotUnique)
        end
      end
    end
  end

  describe '#delete' do
    let!(:relationship) { FactoryBot.create(:relationship, follower_id: user.id, followed_id: other_user.id) }

    context '正常系' do
      it 'ユーザーのフォロー解除に成功すること' do
        expect do
          delete relationship_path(relationship)
        end.to change(Relationship, :count).by(-1)
      end
    end

    context '異常系' do
      context 'ログインしていない場合' do
        before do
          sign_out user
        end

        it 'ログインページにリダイレクトすること' do
          delete relationship_path(relationship)
          expect(response).to redirect_to new_user_session_path
        end
      end

      context 'フォローしていないユーザーのフォロー解除を試みた場合' do
        it 'エラーが生じてフォロー解除できないこと' do
          expect do
            delete relationship_path(relationship.id + 1)
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
