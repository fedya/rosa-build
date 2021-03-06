require 'spec_helper'

describe Api::V1::ArchesController, type: :controller do

  before { FactoryGirl.create(:arch) }

  context 'for guest' do
    it "should be able to perform index action", :anonymous_access  => true do
      get :index, format: :json
      expect(response).to render_template(:index)
    end

    it 'should be able to perform get_id action', :anonymous_access  => false do
      get :index, format: :json
      expect(response.status).to eq 401
    end
  end

  context 'for simple user' do
    before do
      stub_symlink_methods
      http_login(FactoryGirl.create(:user))
    end

    it "should be able to perform index action" do
      get :index, format: :json
      expect(response).to render_template(:index)
    end
  end
end
