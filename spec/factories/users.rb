Factory.sequence :email do |n|
  "user#{Time.now.to_i}.#{n}@dropsocial.com"
end


Factory.define :user, :class => User do |user|
  user.email                    { Factory.next :email }
  user.password                 '123456'
  user.password_confirmation    '123456'
end
