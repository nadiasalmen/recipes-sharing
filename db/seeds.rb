# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
user_1 = User.create(email: "example@gmail.com", password: "password")

Recipe.create(title: "Chicken Parm", description: "A classic Italian dish", ingredients: "Chicken, Parmesan, Tomato Sauce", steps: "Bread chicken, fry chicken, add sauce and cheese, bake", user_id: user_1.id)
Recipe.create(title: "Chicken Alfredo", description: "A classic Italian dish", ingredients: "Chicken, Parmesan, Alfredo Sauce", steps: "Bread chicken, fry chicken, add sauce and cheese, bake", user_id: user_1.id)
Recipe.create(title: "Chicken Marsala", description: "A classic Italian dish", ingredients: "Chicken, Parmesan, Marsala Sauce", steps: "Bread chicken, fry chicken, add sauce and cheese, bake", user_id: user_1.id)
Recipe.create(title: "Chicken Piccata", description: "A classic Italian dish", ingredients: "Chicken, Parmesan, Piccata Sauce", steps: "Bread chicken, fry chicken, add sauce and cheese, bake", user_id: user_1.id)
