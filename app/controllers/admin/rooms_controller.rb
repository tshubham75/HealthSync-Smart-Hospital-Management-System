module Admin
  class RoomsController < ApplicationController
    before_action :set_room, only: %i[show edit update destroy]

    # GET /admin/rooms
    def index
      @rooms = Room.all
    end

    # GET /admin/rooms/:id
    def show
    end

    # GET /admin/rooms/new
    def new
      @room = Room.new
    end

    # POST /admin/rooms
    def create
      @room = Room.new(room_params)
      if @room.save
        redirect_to admin_room_path(@room), notice: "Room was successfully created."
      else
        render :new
      end
    end

    # GET /admin/rooms/:id/edit
    def edit
    end

    # PATCH/PUT /admin/rooms/:id
    def update
      if @room.update(room_params)
        redirect_to admin_room_path(@room), notice: "Room was successfully updated."
      else
        render :edit
      end
    end

    # DELETE /admin/rooms/:id
    def destroy
      @room.destroy
      redirect_to admin_rooms_path, notice: "Room was successfully deleted."
    end

    private

    def set_room
      @room = Room.find(params[:id])
    end

    def room_params
      params.require(:room).permit(:department_id, :room_number, :user_id)
    end
  end
end
