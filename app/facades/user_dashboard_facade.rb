class UserDashboardFacade
  attr_reader :github_service,
              :youtube_service,
              :user

  def initialize(user)
    @user = user
    @key = key
    @github_service = GithubService.new(@key)
    @youtube_service = YoutubeService.new
  end

  def key
    if @user
      if @user.token
        @key = "token #{@user.token}"
      end
    end
  end

  def videos
    @user.bookmarks
  end

  def following
    github_service.following.map do |following|
      Following.new(following)
    end
  end

  def followers
    github_service.followers.map do |follower|
      Follower.new(follower)
    end
  end

  def repos(quantity)
    repos_array = github_service.repos.map do |repo|
      Repo.new(repo)
    end
    return repos_array[0...quantity]
  end

  def friends
    @ids = Friendship.where(user_id: @user.id).pluck(:friend_id)
    User.where(id: @ids)
  end
end
