class EventsController < BaseController
  before_filter :authenticate_user!

  def index
    @active_events = current_user.events_attending
    today = Date.today
    @upcoming_events = current_user.events_attending_between(today,14.days.from_now)
    @pending_event_invites = current_user.attendants.pending.all
  end
  
  
  # GET social_calendar.html
  # the calendar's ajax month switch
  def social_calendar
    @date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    @active_events = current_user.events_attending(@date)
    render :layout => false
  end
  
  
  def show
    @event = Event.find params[:id]
    if current_user.can_view_event? @event
      @attendants = @event.attendants
      @attendants = [@event.user] + @attendants
    else
      render :text => "You can't view this event.", :status => 404
    end
  end
  
  
  def summary
    if current_user.can_view_event?(@event = Event.find(params[:id]))
      @attendants = @event.attendants
      @attendants = [@event.user] + @attendants
      render :layout => false
    else
      render :text => "You can't view this event.", :status => 404
    end
  end
  

  def export_to_calendar
    @event = Event.find params[:id]
    if current_user.can_view_event? @event
      @calendar = Icalendar::Calendar.new
      event = Icalendar::Event.new
      start = @event.when.strftime("%Y%m%dT") #
      start << @event.start_time.strftime('%H%M%S') if @event.start_time
      event.start = start
      
      event.summary = @event.name
      event.description = @event.description
      event.location = @event.venue
      @calendar.add event
      @calendar.publish
      headers['Content-Type'] = "text/calendar; charset=UTF-8"
      render :text => @calendar.to_ical
    end
  end

  def new
    @event = Event.new( :when => Date.today )
    # get all the attendants and create the mapping to lookup
    @attendants = []
    @attendant_user_ids = @attendants.map(&:user_id)
    @attendant_invite_ids = @attendants.map(&:invite_id)
  end

  def create
    @event = Event.new params[:event]
    @event.user_id = current_user.id
    if @event.save
      new_invites = current_user.invite(params[:contact_list].split(/,/)) if params[:contact_list]
      event_attendants = (params[:attendant_ids] || []) + (new_invites || [])
      @event.invite event_attendants
      redirect_to :action => "show", :id => @event.id
    else
      @attendant_user_ids = []
      @attendant_invite_ids = []
      @attendants = []
      (params[:attendant_ids] || []).each do |attendant|
        if attendant =~ /user/
          @attendant_user_ids << attendant.to_i 
        elsif attendant =~ /invite/
          @attendant_invite_ids << attendant.to_i
        else
          @attendants << Attendant.find(attendant)
        end
      end
      render :action => :new
    end
  end

  def edit
    @event = current_user.events.find params[:id]
    # @all_friends_and_pending_invites = current_user.all_friends_and_pending_invites
    # get all the attendants and create the mapping to lookup
    @attendants = @event.attendants.all
    @attendant_user_ids = @attendants.map(&:user_id)
    @attendant_invite_ids = @attendants.map(&:invite_id)
  end

  def update
    @event = current_user.events.find params[:id]
    if @event.update_attributes(params[:event])
      new_invites = current_user.invite(params[:contact_list].split(/,/)) if params[:contact_list]
      event_attendants = (params[:attendant_ids] || []) + (new_invites || [])
      @event.invite event_attendants
      redirect_to :action => "show", :id => @event.id
    else
      render :action => :edit
    end
  end
  
  # POST /events/:id/update_rsvp
  def update_rsvp
    @event = Event.find params[:id]
    if current_user.can_view_event? @event
      @attendant = current_user.attendants.find params[:attendant_id]
      @attendant.update_rsvp_status! params[:rsvp_status]
    else
      render :text => 'invalid permission', :status => 404
    end
  end

  def destroy
  end

end
