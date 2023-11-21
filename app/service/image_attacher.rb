# frozen_string_literal: true

class ImageAttacher
  def initialize(recipe:, base64_image:)
    @recipe = recipe
    @base64_image = base64_image
  end

  def call
    decoded_image = Base64.decode64(@base64_image)
    temp_file = Tempfile.new
    temp_file.binmode
    temp_file.write(decoded_image)
    temp_file.rewind
    blob = ActiveStorage::Blob.create_and_upload!(
      io: temp_file,
      filename: 'your_image_name.jpg',
      content_type: 'image/jpeg'
    )
    @recipe.image.attach(blob)
    temp_file.close
    temp_file.unlink

    @recipe
  end
end
