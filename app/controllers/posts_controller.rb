class PostsController < ApplicationController
  include CableReady::Broadcaster
  before_action :authenticate_user!, only: [:create]

  def index
    @posts = Post.all.order(created_at: :desc)
    @post = Post.new
  end

  def profile
    @posts = Post.all.where(:user_id => current_user.id).order(created_at: :desc)
  end

  def create
    post = Post.create(post_params)
    if post.save
    cable_ready["feed"].insert_adjacent_html(
        selector: "#feed",
        position: "afterbegin",
        html: render_to_string(partial: "post", locals: {post: post}))
    cable_ready.broadcast
    redirect_to posts_path
    else
      redirect_to posts_path(notice: 'Post has not been added.')
    end
  end

  private
  def post_params
    params.require(:post).permit(:body, :user_id)
  end
end
