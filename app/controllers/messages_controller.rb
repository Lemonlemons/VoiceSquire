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
      @duke = Duke.where(id: @message.duke_id).first
      client = Twilio::REST::Client.new(Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token)
      client.messages.create from: Rails.application.secrets.twilio_phone_number, to:@duke.phonenumber, body:@message.body
      redirect_to edit_quest_path(@message.quest_id), notice: "Your message has been sent"
    else
      redirect_to edit_quest_path(@message.quest_id), notice: "Something went wrong"
    end
  end

  def edit
    @message = Message.find(params[:id])
    @messages = Message.all
  end

  def update
    @message = Message.find(params[:id])

    if @message.update_attributes(message_params)
      @duke = Duke.where(id: @message.duke_id).first
      client = Twilio::REST::Client.new(Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token)
      client.messages.create from: Rails.application.secrets.twilio_phone_number, to:@duke.phonenumber, body:@message.body
      redirect_to edit_quest_path(@message.quest_id), notice: "Your message has been sent"
    else
      redirect_to edit_quest_path(@message.quest_id), notice: "Something went wrong"
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to quests_path, notice:"Your message has been deleted"
  end

  def message_params
    params.require(:message).permit(:title, :body, :is_email, :is_text, :squire_id, :duke_id, :sentby_squire, :sentby_duke, :quest_id)
  end
end
