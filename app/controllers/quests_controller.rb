class QuestsController < ApplicationController
  def index
    @quests = Quest.all
    @quests2 = Quest.where(squire_id: nil)
    @dukes = Duke.all
  end

  def show
    @quest = Quest.find(params[:id])
    @quests = Quest.all
    @user = User.where(id: @quest.squire_id).first
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
    @quests2 = Quest.where(squire_id: nil)
    @notes = Note.where(duke_id: @quest.duke_id)
    @dukes = Duke.all
    @duke = Duke.where(id: @quest.duke_id).first
    @messages = Message.where(quest_id: @quest.id)
    @message = Message.new
    capability = Twilio::Util::Capability.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    capability.allow_client_outgoing Rails.application.secrets.twilio_twiml_app_sid
    @token = capability.generate()
  end

  def update
    @quest = Quest.find(params[:id])

    if @quest.update_attributes(quest_params)
      redirect_to edit_quest_path(@quest), notice: "Your quest was saved"
    else
      redirect_to edit_quest_path(@quest), notice: "Something went wrong"
    end
  end

  def destroy
    @quest = Quest.find(params[:id])
    @quest.destroy
    redirect_to quests_path, notice:"Your quest has been deleted"
  end

  def paybill
    @quest = Quest.find(params[:id])
    @duke = Duke.where(id: @quest.duke_id).first

    customer = Stripe::Customer.create(
      :email => @duke.email,
      :card  => params[:stripeToken]
    )

    @quest.stripetoken = customer.id
    @quest.is_proposalaccepted = true
    @quest.save

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to quests_path
  end

  def releasepayment
    @quest = Quest.find(params[:id])
    @user = User.where(id: @job.squire_id).first

    Stripe::Charge.create(
      :customer    => @quest.stripetoken,
      :amount      => @quest.pricetosquire,
      :description => 'Squire Stripe Customer',
      :currency    => 'usd'
    )
    @quest.is_completed = true
    if @quest.save
      redirect_to quest_path(@quest), notice:"success!~"
    else
      redirect_to quest_path(@quest), notice:"There was a problem"
    end

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to edit_job_path(@job)
  end

  def submitproof
    @quest = Quest.find(params[:id])
    @quest.is_proofsubmitted = true
    if @quest.save
      ProposalMailer.proof_email(@quest).deliver_later
      redirect_to edit_quest_path(@quest), notice: "Proof was sent"
    else
      redirect_to edit_quest_path(@quest), notice: "Something went wrong"
    end
  end

  def submitproposal
    @quest = Quest.find(params[:id])
    @quest.is_proposalsent = true
    if @quest.save
      ProposalMailer.proposal_email(@quest).deliver_later
      redirect_to edit_quest_path(@quest), notice: "Proposal was sent"
    else
      redirect_to edit_quest_path(@quest), notice: "Something went wrong"
    end
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
      if @duke = Duke.where(squire_id: nil).first
        @duke.squire_id = @user.id
        @user.activequests = @user.activequests + 1
        capability = Twilio::Util::Capability.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
        capability.allow_client_outgoing Rails.application.secrets.twilio_twiml_app_sid
        @token = capability.generate()
        if (@duke.save && @user.save)
          redirect_to edit_duke_path(@duke), notice: "Help this Duke fill out their registration"
        else
          redirect_to quests_path, notice:"There was a problem"
        end
      else
        if @quest = Quest.where(squire_id: nil).first
           @quest.squire_id = @user.id
           @quest.is_assigned = true
           @user.activequests = @user.activequests + 1
           if (@quest.save && @user.save)
             redirect_to edit_quest_path(@quest), notice: "You hath taken on the Quest"
           else
             redirect_to quests_path, notice:"There was a problem mmmm"
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
    :picture1, :picture2, :picture3, :proof1, :proof2, :proof3)
  end
end
