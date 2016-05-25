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
      # if @message.squire_id == 1
      #   client = Twilio::REST::Client.new(ENV["twilio_account_sid"], ENV["twilio_auth_token"])
      #   client.messages.create from: ENV["twilio_phone_number"], to:"+12183162469", body:"This email needs to be added to Squire's mailing list: "+@message.body
      #   redirect_to quests_path, notice: "Thank You, your email has been added to our mailing list"
      # else
        @duke = Duke.where(id: @message.duke_id).first
        client = Twilio::REST::Client.new(ENV["twilio_account_sid"], ENV["twilio_auth_token"])
        client.account.messages.create(from: ENV["twilio_phone_number"], to:@duke.phonenumber, body:@message.body)
        redirect_to edit_quest_path(@message.quest_id), notice: "Your message has been sent"
      # end
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
      client = Twilio::REST::Client.new(ENV["twilio_account_sid"], ENV["twilio_auth_token"])
      client.messages.create from: ENV["twilio_phone_number"], to:@duke.phonenumber, body:@message.body
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
