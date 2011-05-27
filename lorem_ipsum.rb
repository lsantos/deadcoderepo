require 'rubygems'
require 'faker'


p " 10 paraghraphs -> #{Faker::Lorem.paragraphs(10).join}"
p " 5 paraghraphs -> #{Faker::Lorem.paragraphs(5).join}"
p "names -> #{Faker::Lorem.words(5).join(" ")}"