module TestActiveRecordModels
  def users_class
    @users_class ||= begin
      posts = posts_class
      Class.new(ActiveRecord::Base) do
        self.table_name = 'users'

        def self.name
          'User'
        end

        has_many :posts, anonymous_class: posts
      end
    end
  end

  def posts_class
    @posts_class ||= begin
      documents = documents_class
      Class.new(ActiveRecord::Base) do
        self.table_name = 'posts'

        def self.name
          'Post'
        end

        has_one :document, anonymous_class: documents
      end
    end
  end

  def documents_class
    @documents_class ||= begin
      links = links_class
      Class.new(ActiveRecord::Base) do
        self.table_name = 'documents'

        def self.name
          'Document'
        end

        has_many :links, anonymous_class: links
      end
    end
  end

  def links_class
    @links_class ||= Class.new(ActiveRecord::Base) do
      self.table_name = 'links'

      def self.name
        'Link'
      end
    end
  end
end
