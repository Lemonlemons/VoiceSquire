class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end

  def show
    @message = Message.find(params[:id])
    @messages = Message.all
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      redirect_to quests_path, notice: "review was saved"
    else
      render "new"
    end
  end

  def edit
    @message = Message.find(params[:id])
    @messages = Message.all
  end

  def update
    @message = Message.find(params[:id])

    if @message.update_attributes(message_params)
      redirect_to edit_message_path(@message), notice: "Your message has been updated"
    else
      redirect_to edit_message_path(@message), notice: "Something went wrong"
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to quests_path, notice:"Your message has been deleted"
  end

  def message_params
    params.require(:message).permit(:title, :body, :is_email, :is_text, :squire_id, :duke_id, :quest_id)
  end
end
