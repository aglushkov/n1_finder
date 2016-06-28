class TestActiveRecordMigration < ActiveRecord::Migration
  class << self
    def up
      create_users
      create_posts
      create_documents
      create_links
    end

    private

    def create_users
      without_exists_error { create_table :users }
    end

    def create_posts
      without_exists_error do
        create_table :posts do |t|
          t.integer :user_id
        end
      end
    end

    def create_documents
      without_exists_error do
        create_table :documents do |t|
          t.integer :post_id
        end
      end
    end

    def create_links
      without_exists_error do
        create_table :links do |t|
          t.integer :document_id
        end
      end
    end

    def without_exists_error
      yield
    rescue ActiveRecord::StatementInvalid => error
      raise error unless error.message.include?('already exists')
    end
  end
end
