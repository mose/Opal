FactoryGirl.define do
  factory :plugin_link do |o|
    o.association   :record, :factory => :item
    o.association   :user, :factory => :user
    o.is_approved   "1"
    o.title         "Test Link"
    o.url           "http://localhost"
  end
end