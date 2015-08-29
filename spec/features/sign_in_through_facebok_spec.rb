require 'features/features_spec_helper'
 
feature "Signs in with facebook" do
  before do 
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '123545',
      info: {
        email: "mail@ngmail.com",
        first_name: "name",
        last_name: "Name"
        }
    })
  end

  scenario 'user successfully signing in by clicking "facebook" button' do
    visit new_customer_session_path
    click_link("f")
    expect(page).to have_content "Successfully authenticated from Facebook account."
    expect(page).not_to have_content 'Sign up'
    expect(page).to have_content 'Sign out'
  end
end