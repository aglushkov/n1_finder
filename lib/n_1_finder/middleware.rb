##
# Middleware that can be used in any rake application to find N+1 queries
#
class N1Finder::Middleware
  def initialize(app)
    @app = app
  end

  # Wrap app call to `N1Finder.find` method
  def call(env)
    N1Finder.find { @app.call(env) }
  end
end
