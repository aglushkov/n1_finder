module N1Helpers
  def populate_database
    users = create_new_users
    posts = create_new_posts(users)
    documents = create_new_documents(posts)
    create_new_links(documents)
  end

  def n_1_heavy_block
    proc do
      users = users_class.all.to_a               # 1 query
      posts = users.map(&:posts).to_a.flatten    # 2 queries, N+1 should be detected
      documents = posts.map(&:document).to_a     # 4 queries, N+1 should be detected
      documents.map(&:links).map(&:to_a).flatten # 4 queries, N+1 should be detected
    end
  end

  private

  def create_new_users
    [
      users_class.create,
      users_class.create
    ]
  end

  def create_new_posts(users)
    user_1, user_2 = users
    [
      posts_class.create(user_id: user_1.id),
      posts_class.create(user_id: user_1.id),
      posts_class.create(user_id: user_2.id),
      posts_class.create(user_id: user_2.id)
    ]
  end

  def create_new_documents(posts)
    post_1_user_1, post_2_user_1, post_1_user_2, post_2_user_2 = posts
    [
      documents_class.create(post_id: post_1_user_1.id),
      documents_class.create(post_id: post_2_user_1.id),
      documents_class.create(post_id: post_1_user_2.id),
      documents_class.create(post_id: post_2_user_2.id)
    ]
  end

  def create_new_links(documents)
    document_1, document_2, document_3, document_4 = documents
    [
      links_class.create(document_id: document_1.id),
      links_class.create(document_id: document_2.id),
      links_class.create(document_id: document_3.id),
      links_class.create(document_id: document_4.id)
    ]
  end
end
