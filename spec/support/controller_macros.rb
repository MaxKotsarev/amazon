module ControllerMacros
 def login_customer
   before(:each) do
     @request.env["devise.mapping"] = Devise.mappings[:customer]
     user = FactoryGirl.create(:customer)
     sign_in customer
   end
 end
end