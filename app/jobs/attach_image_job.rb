# frozen_string_literal: true

class AttachImageJob < ApplicationJob
  queue_as :default

  def perform(recipe:, base64_image:)
    puts ">>>>>> Beginning AttachImageJob <<<<<<<<<<<<<<"
    ImageAttacher.new(recipe: recipe, base64_image: base64_image).call
    puts ">>>>>> Finishing AttachImageJob <<<<<<<<<<<<<<"
  end
end
