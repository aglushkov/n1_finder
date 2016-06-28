class TestSequelMigration
  class << self
    def up
      create_users
      create_posts
      create_documents
      create_links
    end

    private

    def create_users
      Sequel::Model.db.create_table? :users do
        primary_key :id
      end
    end

    def create_posts
      Sequel::Model.db.create_table? :posts do
        primary_key :id
        Integer :user_id
      end
    end

    def create_documents
      Sequel::Model.db.create_table? :documents do
        primary_key :id
        Integer :post_id
      end
    end

    def create_links
      Sequel::Model.db.create_table? :links do
        primary_key :id
        Integer :document_id
      end
    end
  end
end
