Factory.sequence :invite_email do |n|
  "invite#{Time.now.to_i}.#{n}@dropsocial.com"
end


Factory.define :invite, :class => Invite do |f|
  f.email                    { Factory.next :email }
end