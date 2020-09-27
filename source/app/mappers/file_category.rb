# frozen_string_literal: true

class FileCategory
  MAP = {
    '3d': %w[stl],
    image: %w[eps],
    compressed: %w[zip 7z rar gz tar],
    book: %w[mobi epub pdf],
    video: %w[mkv]
  }.freeze

  def self.from(extension)
    new(extension).category
  end

  def initialize(extension)
    @extension = extension.downcase
  end

  def category
    from_map || from_mime || 'misc'
  end

  private

  attr_reader :extension, :mime

  def from_map
    match = MAP.find do |_type, extensions|
      extensions.include? extension
    end

    match&.first&.to_s
  end

  def from_mime
    @mime = Rack::Mime::MIME_TYPES[".#{extension}"]

    return unless mime
    return from_application if application?

    mime.gsub(%r{/.*}, '')
  end

  def from_application
    mime.gsub(%r{.*/}, '')
  end

  def application?
    mime.match(/^application/)
  end
end
