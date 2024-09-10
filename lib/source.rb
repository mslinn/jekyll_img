class Source
  RANKS = %w[webp apng png jpg jpeg jfif pjpeg pjp svg gif tif tiff bmp cur ico].freeze
  RANKS_LENGTH = RANKS.length

  def initialize(path)
    raise Jekyll::ImgError, "The 'src' parameter was not specified" if path.nil?
    raise Jekyll::ImgError, "The 'src' parameter was empty" if path.empty?

    path.strip!
    raise Jekyll::ImgError, "The 'src' parameter only contained whitespace" if path.empty?

    @path = path
  end

  # @return array of source statements for filetypes that exist locally;
  #         return nil if @path points to a remote image
  def generate
    return nil if @path.nil? || @path.start_with?('http')

    result = sorted_files.map do |filename|
      mtype = mimetype filename
      next unless mtype

      <<~END_HTML
        <source srcset="#{filename}" type="#{mtype}">
      END_HTML
    end
    result&.compact&.map(&:strip)
  end

  # Webp is the least desired variant, png is most desired variant.
  # @return URL of external image, otherwise return specified path unless it is a webp;
  #         in which case return most desired image variant that exists.
  def src_fallback
    return @path if @path.start_with? 'http'

    return @path unless @path.end_with? '.webp' # we know @path will be a webp after this

    png = @path.gsub(/\.webp$/, '.png')
    return png if File.exist? png

    files = Dir[globbed_path]
    return files[0] if files.count == 1

    files.each do |filename|
      ext = File.extname filename
      return filename unless ext == '.webp'
    end
    @path
  end

  private

  # Convert absolute paths (which reference the website root) to relative paths for globbing
  def globbed_path
    dir = File.dirname @path
    dir = ".#{dir}" if dir.start_with?('/')
    base = File.basename @path, ".*"
    "#{dir}/#{base}.*"
  end

  def mimetype(path)
    case File.extname(path)
    when '.svg'
      'image/svg'
    when '.webp'
      'image/webp'
    when '.png'
      'image/png'
    when '.apng'
      'image/apng'
    when %w[.jpg .jpeg .jfif .pjpeg .pjp]
      'image/jpeg'
    when '.gif'
      'image/gif'
    when %w[.tif .tiff]
      'image/tiff'
    when '.bmp'
      'image/bmp'
    when %w[cur ico]
      'image/x-icon'
      # else
      # raise Jekyll::ImgError, "#{path} has an unrecognized filetype."
    end
  end

  def sorted_files
    Dir[globbed_path].sort_by do |path|
      ext = File.extname(path).delete_prefix('.')
      index = RANKS.index(ext)
      index || RANKS_LENGTH
    end
  end
end
