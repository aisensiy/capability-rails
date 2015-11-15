FactoryGirl.define do
  factory :employee, class: Member do
    name "memberTwo"
    password "123"
    role "employee"
  end

  factory :admin, class: Member do
    name "admin"
    password "123"
    role :admin
  end

  factory :system, class: Member do
    name "system"
    password "123"
    role :system
  end
end