module TestSequelModels
  def users_class
    @users_class ||= begin
      posts = posts_class
      result = Class.new(Sequel::Model(:users)) do
        def self.name
          'User'
        end

        one_to_many :posts, class: posts
      end

      use_current_db(result)
    end
  end

  def posts_class
    @posts_class ||= begin
      documents = documents_class
      result = Class.new(Sequel::Model(:posts)) do
        def self.name
          'Post'
        end

        one_to_one :document, class: documents
      end

      use_current_db(result)
    end
  end

  def documents_class
    @documents_class ||= begin
      links = links_class
      result = Class.new(Sequel::Model(:documents)) do
        def self.name
          'Document'
        end

        one_to_many :links, class: links
      end

      use_current_db(result)
    end
  end

  def links_class
    @links_class ||= begin
      result = Class.new(Sequel::Model(:links)) do
        def self.name
          'Link'
        end
      end

      use_current_db(result)
    end
  end

  private

  def use_current_db(sequel_model)
    sequel_model.db = Sequel::Model.db
    sequel_model
  end
end
