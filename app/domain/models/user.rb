# typed: true

module Domain
  module Models
    class User
      attr_reader :id, :email, :password_hash, :created_at, :updated_at

      def initialize(id:, email:, password_hash:, created_at: Time.now, updated_at: Time.now)
        @id = id
        @email = email
        @password_hash = password_hash
        @created_at = created_at
        @updated_at = updated_at
      end

      def to_h
        {
          id: id,
          email: email,
          created_at: created_at,
          updated_at: updated_at
        }
      end
    end
  end
end 