module TestNoConnectionModels
  module BaseNoConnectionModel
    def self.included(base)
      base.include InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods
      def id
      end
    end

    module ClassMethods
      def create(*)
        new
      end

      def all
      end
    end
  end

  def users_class
    Class.new do
      include BaseNoConnectionModel

      def posts
        []
      end
    end
  end

  def posts_class
    Class.new do
      include BaseNoConnectionModel

      def document
      end
    end
  end

  def documents_class
    Class.new do
      include BaseNoConnectionModel

      def links
        []
      end
    end
  end

  def links_class
    Class.new do
      include BaseNoConnectionModel
    end
  end
end
