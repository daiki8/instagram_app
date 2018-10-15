class PostsController < ApplicationController
    before_action :logged_in_user, only: [:index, :create]

    def index
        @posts = Post.paginate(page: params[:page], :per_page => 18)
        @post = current_user.posts.build
    end

    def create
        @post = current_user.posts.build(post_params)
        if @post.save
          flash[:success] = "Post created!"
          redirect_to posts_path
        else
          @posts = Post.paginate(page: params[:page], :per_page => 18)  # postsがnilになるのを防ぐための一時的な対策
          render 'posts/index'
        end
      end


      private

      def post_params
        params.require(:post).permit(:title, :picture)
      end
end
