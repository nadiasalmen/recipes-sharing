# frozen_string_literal: true

class NotifyNewRecipeJob < ApplicationJob
  queue_as :default

  def perform(recipe:)
    puts ">>>>>> Beginning NotifyNewRecipeJob <<<<<<<<<<<<<<"
    Notification.create!(
      user_id: recipe.user_id,
      message: "Have you seen the new recipe? Check it out! #{recipe.title}"
    )
    puts ">>>>>> Finishing NotifyNewRecipeJob <<<<<<<<<<<<<<"
  end
end
