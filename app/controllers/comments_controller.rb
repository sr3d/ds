class CommentsController< BaseController
  before_filter :authenticate_user!

  def index
    # load the comments
  end

  def create
    @event = Event.find params[:event_id]
    if current_user.can_view_event? @event
      @comment = @event.comments.new params[:comment]
      @comment.user_id = current_user.id
      @comment.save
    else
      render :text => "You can't view this event.", :status => 404
    end

  end

  def update
    
  end

  def destroy
    
  end

end
