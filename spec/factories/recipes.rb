FactoryBot.define do
  factory :recipe do
    title { "Chicken Parm" }
    description { "A classic Italian dish" }
    ingredients { "Chicken, Parmesan, Tomato Sauce" }
    steps { "Bread chicken, fry chicken, add sauce and cheese, bake" }
    user_id { 1 }
  end
end
