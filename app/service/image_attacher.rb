# frozen_string_literal: true

class ImageAttacher
  def initialize(recipe:, base64_image:)
    @recipe = recipe
    @base64_image = base64_image
  end

  def call
    temp_file = create_temp_file
    temp_file = resize_image(temp_file)
    blob = create_and_upload(temp_file)
    attach_image(blob)
    delete_temp_file(temp_file)
  end

  private

  def create_temp_file
    decoded_image = Base64.decode64(@base64_image)
    temp_file = Tempfile.new
    temp_file.binmode
    temp_file.write(decoded_image)
    temp_file.rewind
    temp_file
  end

  def resize_image(temp_file)
    image = MiniMagick::Image.open(temp_file.path)
    image.resize('300x300')
    image.write(temp_file.path)
    temp_file
  end

  def create_and_upload(temp_file)
    ActiveStorage::Blob.create_and_upload!(
      io: temp_file,
      filename: "#{@recipe.title}-#{@recipe.id}.jpeg",
      content_type: 'image/jpeg'
    )
  end

  def attach_image(blob)
    @recipe.image.attach(blob)
  end

  def delete_temp_file(temp_file)
    temp_file.close
    temp_file.unlink
  end
end
