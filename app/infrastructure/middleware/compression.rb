# typed: true
require 'zlib'
require 'stringio'

module Infrastructure
  module Middleware
    class Compression
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)

        # Check if client accepts gzip encoding
        return [status, headers, body] unless accepts_gzip?(env)

        # Don't compress if content is already compressed or if it's too small
        return [status, headers, body] if skip_compression?(headers)

        # Compress the response
        compressed_body = compress_body(body)
        
        # Update headers
        headers['content-encoding'] = 'gzip'
        headers['content-length'] = compressed_body.bytesize.to_s
        headers.delete('content-md5') # Remove MD5 as it's no longer valid

        [status, headers, [compressed_body]]
      end

      private

      def accepts_gzip?(env)
        env['HTTP_ACCEPT_ENCODING']&.include?('gzip')
      end

      def skip_compression?(headers)
        return true if headers['content-encoding']
        return true if headers['content-type']&.start_with?('image/', 'video/', 'audio/')
        
        # Only check content length if it exists
        content_length = headers['content-length']&.to_i
        return true if content_length && content_length < 1024 # Skip if less than 1KB
      end

      def compress_body(body)
        output = StringIO.new
        gz = Zlib::GzipWriter.new(output)
        
        # Handle both string and array bodies
        if body.is_a?(Array)
          body.each { |chunk| gz.write(chunk) }
        else
          gz.write(body)
        end
        
        gz.close
        output.string
      end
    end
  end
end 