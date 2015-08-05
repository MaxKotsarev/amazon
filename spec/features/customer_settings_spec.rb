require 'features/features_spec_helper'

=begin
feature "Settings - Addresses" do
  scenario "customer send data to create action (hasn't address which form he submits)"
    scenario "customer submit BA form"
      +1. scenario "SA?"
        creates BA
      +2. scenario "!SA?"
        creates BA and SA = BA
    scenario "customer submit SA form"
      checked
        -3(controlled by view) scenario "BA?"
          set SA = BA
        -4(controlled by view) scenario "!BA?"
          redirect back with message "you can't use billing address before fill in an save it"
      +5. unchecked
        creates SA

  scenario "customer send data to update action (has address which form he submits)"
    scenario "customer submit BA form"
      +6. updates BA
    scenario "customer submit SA form"
      checked
        -7(controlled by view). BA == SA 
          redirect back with message "you already use billing address as shipping"
        BA !== SA
          +8. BA?
            destroy SA
            set SA = BA
          +9. !BA?
            redirect back with message "you can't use billing address before fill in an save it" 
      unchecked
        BA !== SA
          +10. updates SA
        BA == SA
          11. create SA
=end

