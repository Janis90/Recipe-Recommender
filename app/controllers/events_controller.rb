class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy, :decline_event]
  before_action :set_friends, only: [:new, :edit, :create, :update]

  # GET /events
  # GET /events.json
  def index
    @my_events = Event.where(creator_id: current_user.id)
    @invitations = []
    user_events = UserEvent.where(user_id: current_user.id)

    user_events.each do |user_event|
      @invitations << Event.where("id = ? and creator_id != ?", user_event.event_id, current_user.id).first
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.creator_id = current_user.id
    @event.users = get_invited_friends_from_params

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, alert: 'Event could not be created.' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    @event.creator_id = current_user.id
    @event.users = get_invited_friends_from_params
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def decline_event
    debugger
    user_event = UserEvent.where("event_id = ? and user_id = ?", @event.id, current_user.id).first

    if user_event.destroy
      redirect_to events_url, notice: t('event.reject')
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def set_friends
      @friends = current_user.friends
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :description, :date, :start_time, :end_time)
    end

    def invited_friends_params
      params[:event][:id]
    end

    def get_invited_friends_from_params
      User.where(id: invited_friends_params)
    end
end
