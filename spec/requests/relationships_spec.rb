require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  describe '#create' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }

    context '正常系' do
      it 'ユーザーのフォローに成功すること' do
        sign_in user
        expect do
          post relationships_path, params: { followed_id: other_user.id }
        end.to change(Relationship, :count).by(1)
      end
    end
  end

  describe '#delete' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let!(:relationship) { FactoryBot.create(:relationship, follower_id: user.id, followed_id: other_user.id) }

    context '正常系' do
      it 'ユーザーのフォロー解除に成功すること' do
        sign_in user
        expect do
          delete relationship_path(relationship)
        end.to change(Relationship, :count).by(-1)
      end
    end
  end
end
