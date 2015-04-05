class QuestsController < ApplicationController
  def index
    @quests = Quest.all
  end

  def show
    @quest = Quest.find(params[:id])
    @quests = Quest.all
  end

  def new
    @quest = Quest.new
  end

  def create
    @quest = Quest.new(quest_params)

    if @quest.save
      redirect_to quests_path, notice: "Your quest was saved"
    else
      render "new"
    end
  end

  def edit
    @quest = Quest.find(params[:id])
    @quests = Quest.all
    capability = Twilio::Util::Capability.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    capability.allow_client_outgoing Rails.application.secrets.twilio_twiml_app_sid
    @token = capability.generate()
  end

  def update
    @quest = Quest.find(params[:id])

    if @quest.update_attributes(quest_params)
      redirect_to edit_quest_path(@quest), notice: "Your quest has been updated"
    else
      redirect_to edit_quest_path(@quest), notice: "Something went wrong"
    end
  end

  def destroy
    @quest = Quest.find(params[:id])
    @quest.destroy
    redirect_to quests_path, notice:"Your quest has been deleted"
  end

  def dotraining
    @user = User.find(params[:id])
    @user.trainingcomplete = true
    @user.save
    redirect_to quests_path, notice:"Thank you for completing training"
  end

  def getmeaquest
    @user = User.find(params[:id])
    if (@user.activequests < 4)
      if @duke = Duke.where(email: nil).first
        capability = Twilio::Util::Capability.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
        capability.allow_client_outgoing Rails.application.secrets.twilio_twiml_app_sid
        @token = capability.generate()
        redirect_to edit_duke_path(@duke), notice: "Help this Duke fill out their registration"
      else
        if @quest = Quest.where(squire_id: nil).first
           @quest.squire_id = @user.id
           @user.activequests = @user.activequests + 1
           if (@quest.save && @user.save)
             redirect_to edit_quest_path(@quest), notice: "You hath taken on the Quest"
           else
             redirect_to quests_path, notice:"There was a problem"
           end
        else
          redirect_to quests_path, notice:"No available quests"
        end
      end
    else
      redirect_to quests_path, notice:"You may only have 3 active quests at a time"
    end
  end

  def quest_params
    params.require(:quest).permit(:typeofquest, :audiolink, :textlink, :squire_id, :duke_id,
    :is_assigned, :is_proposalsent, :is_revisionrequested, :is_proposalaccepted, :is_proofsubmitted,
    :is_completed, :timesflagged, :title, :description, :pricetosquire, :totalprice, :squirescut,
    :picture1, :picture2, :picture3)
  end
end
