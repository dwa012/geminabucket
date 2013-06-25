require 'aws/s3'


class Gemins3::RemoteFetcher < Gem::RemoteFetcher

  # Gem::RemoteFetcher#download would need some refactoring to
  # allow dispatching based on the scheme (download_http, download_s3, etc),
  # and to centalize parameter handling.
  #
  def download(spec, source_uri, install_dir = Gem.dir)
    unless URI::Generic === source_uri
      source_uri = URI.parse(URI.const_defined?(:DEFAULT_PARSER) ?
                                 URI::DEFAULT_PARSER.escape(source_uri.to_s) :
                                 URI.escape(source_uri.to_s))
    end

    if source_uri.scheme == 's3'
      download_s3(spec, source_uri, install_dir)
    else
      super
    end
  end

  def download_s3(spec, source_uri, install_dir = Gem.dir)
    cache_dir =
        if Dir.pwd == install_dir then # see fetch_command
          install_dir
        elsif File.writable? install_dir then
          File.join install_dir, "cache"
        else
          File.join Gem.user_dir, "cache"
        end
    gem_file_name = File.basename spec.cache_file
    local_gem_path = File.join cache_dir, gem_file_name

    FileUtils.mkdir_p cache_dir rescue nil unless File.exist? cache_dir

    unless File.exist? local_gem_path then
      begin
        say "Downloading gem #{gem_file_name}" if Gem.configuration.really_verbose
        remote_gem_path = source_uri + "gems/#{gem_file_name}"
        self.cache_update_path remote_gem_path, local_gem_path
      rescue Gem::RemoteFetcher::FetchError
        raise if spec.original_platform == spec.platform
        alternate_name = "#{spec.original_name}.gem"
        say "Failed, downloading gem #{alternate_name}" if Gem.configuration.really_verbose
        remote_gem_path = source_uri + "gems/#{alternate_name}"
        self.cache_update_path remote_gem_path, local_gem_path
      end
    end


    local_gem_path
  end

  #
  # must return the data as a String
  #
  def fetch_s3 uri, last_modified = nil, head = false, depth = 0
    begin
      say "fetching #{uri}" if Gem.configuration.verbose
      bucket, key = bucket_and_key(uri)

      object = s3.buckets[bucket].objects[key]
      raise FetchError.new("This key does not exists", uri.to_s) unless object.exists?

      reporter = ui.download_reporter
      reporter.fetch(File.basename(uri.path), object.content_length)

      data = ''
      downloaded = 0

      object.read do |chunk|
        data << chunk
        downloaded += chunk.length
        reporter.update(downloaded)
      end
      reporter.done
      data
    rescue => e
      raise FetchError.new("#{e.class}: #{e}", uri.to_s)
    end
  end

  # Parse URL and return bucket and key.
  #
  # e.g. s3://bucket/path/to/key => ["bucket", "path/to/key"]
  #      bucket:path/to/key => ["bucket", "path/to/key"]
  def bucket_and_key(url)
    if url.to_s =~ /s3:\/\/([^\/]+)\/?(.*)/
      bucket = $1
      key = $2
    elsif url.to_s =~ /([^:]+):(.*)/
      bucket = $1
      key = $2
    end
    [bucket, key]
  end

  def s3
    @s3 ||= ::AWS::S3.new
  end
end


class Gem::RemoteFetcher

  def self.fetcher=(fetcher)
    @fetcher = fetcher
  end

end