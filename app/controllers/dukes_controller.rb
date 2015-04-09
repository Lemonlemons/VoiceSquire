class DukesController < ApplicationController
  def index
    @dukes = Duke.all
  end

  def show
    @duke = Duke.find(params[:id])
    @dukes = Duke.all
  end

  def new
    @duke = Duke.new
  end

  def create
    @duke = Duke.new(duke_params)

    if @duke.save
      redirect_to quests_path, notice: "Duke was saved"
    else
      render "new"
    end
  end

  def edit
    @duke = Duke.find(params[:id])
    @dukes = Duke.all
    @quests = Quest.all
    @quests2 = Quest.where(squire_id: nil)
    capability = Twilio::Util::Capability.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    capability.allow_client_outgoing Rails.application.secrets.twilio_twiml_app_sid
    @token = capability.generate()
  end

  def update
    @duke = Duke.find(params[:id])
    @user = User.where(id: @duke.squire_id).first
    if @duke.update_attributes(duke_params)
      @duke.registered = true
      @user.activequests = @user.activequests - 1
      if @duke.save && @user.save
        ProposalMailer.welcome_email(@duke).deliver_later
        redirect_to quests_path, notice: "this duke has been added to the program"
      else
        redirect_to edit_duke_path(@duke), notice: "Save went down"
      end
    else
      redirect_to edit_duke_path(@duke), notice: "Something went wrong"
    end
  end

  def destroy
    @duke = Duke.find(params[:id])
    @duke.destroy
    redirect_to quests_path, notice:"Your duke has been deleted"
  end

  def duke_params
    params.require(:duke).permit(:phonenumber, :firstname, :lastname, :email, :mailingaddress,
    :city, :state, :country, :zipcode, :preferredproposalmethod, :birthday, :is_landline,
    :is_mailingsameasphysicaladdress, :physicaladdress, :is_female, :rating, :numberofquests,
    :numberofnotes, :registered)
  end
end
