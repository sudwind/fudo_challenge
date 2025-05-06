# typed: true
require 'json'

module Services
  class ParseUtils
    UUID_PATTERN = %r{^/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$}

    def self.parse_json(body)
      JSON.parse(body)
    rescue JSON::ParserError
      raise ArgumentError, 'Invalid JSON format'
    end

    def self.parse_rack_input(env)
      parse_json(env['rack.input'].read)
    end

    def self.validate_required_fields(data, fields)
      missing_fields = fields.select { |field| data[field].nil? || data[field].empty? }
      raise ArgumentError, "Missing required fields: #{missing_fields.join(', ')}" unless missing_fields.empty?
    end

    def self.validate_login_request(request_body)
      validate_required_fields(request_body, ['email', 'password'])
    end

    def self.parse_query_string(query_string)
      return nil if query_string.nil? || query_string.empty?
      query_string.split('=').last
    end

    def self.extract_id_from_path(path)
      id = path.split('/').last
      raise ArgumentError, 'Invalid ID format' unless id.match?(UUID_PATTERN)
      id
    end

    def self.is_uuid_path?(path)
      path.match?(UUID_PATTERN)
    end
  end
end 