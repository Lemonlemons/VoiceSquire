class QuestsController < ApplicationController
  def index
    if current_user != nil
      @quests = Quest.where("squire_id = ? AND is_completed = ?", current_user.id , false)
    end
    @quests2 = Quest.where(squire_id: nil)
    @dukes = Duke.all
  end

  def show
    @quest = Quest.find(params[:id])
    @quests = Quest.all
    @user = User.where(id: @quest.squire_id).first
    @duke = Duke.where(id: @quest.duke_id).first
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
    @quests = Quest.where("squire_id = ? AND is_completed = ?", current_user.id , false)
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
    if params[:quest] != nil
      if @quest.update_attributes(quest_params)
        @quest.squirescut = @quest.pricetosquire * 0.04
        @quest.totalprice = (@quest.pricetosquire * 0.04) + @quest.pricetosquire
        @quest.save
        @quest.platformfees = (@quest.totalprice * 0.06) + 0.30
        @quest.save
        @quest.totalprice = @quest.totalprice + @quest.platformfees
        @quest.save
        if @quest.is_revisiontransition == true
          redirect_to edit_quest_path(@quest), notice: "Your quest was saved"
        else
          if @quest.is_revisionrequested == true
            redirect_to revisionthanks_quest_path
          else
            redirect_to edit_quest_path(@quest), notice: "Your quest was saved"
          end
        end
      else
        redirect_to edit_quest_path(@quest), notice: "Something went wrong"
      end
    else
      redirect_to edit_quest_path(@quest), notice: "Nothing new to update"
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
    @duke.customertoken = customer.id
    @quest.save && @duke.save

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to quests_path
  end

  def paycharge
    @quest = Quest.find(params[:id])
    @duke = Duke.where(id: @quest.duke_id).first
    @quest.stripetoken = @duke.customertoken
    @quest.is_proposalaccepted = true
    if @quest.save
      redirect_to paybillreturn_quest_path, notice:"Payment Sent"
    else
      redirect_to paybillreturn_quest_path, notice:"Error"
    end
  end

  def releasepayment
    @quest = Quest.find(params[:id])
    @user = User.where(id: @quest.squire_id).first
    @user.completedquests = @user.completedquests + 1

    Stripe::Charge.create(
      :customer    => @quest.stripetoken,
      :amount      => (@quest.totalprice * 100).to_i,
      :description => 'Squire Stripe Customer',
      :currency    => 'usd',
      :application_fee => (@quest.platformfees * 100).to_i,
      :destination => @user.uid
    )

    @quest.is_completed = true
    if @quest.save && @user.save
      redirect_to quest_path(@quest), notice:"success!~"
    else
      redirect_to quest_path(@quest), notice:"There was a problem"
    end

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to edit_quest_path(@quest)
  end

  def submitproof
    @quest = Quest.find(params[:id])
    @user = User.where(id: @quest.squire_id).first
    @duke = Duke.where(id: @quest.duke_id).first
    @user.activequests = @user.activequests - 1
    @quest.is_proofsubmitted = true
    @duke.activequest_id = nil
    if @quest.save && @user.save && @duke.save
      ProposalMailer.proof_email(@quest).deliver_later
      client = Twilio::REST::Client.new(Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token)
      client.messages.create from: Rails.application.secrets.twilio_phone_number, to:@duke.phonenumber, body:"we've completed the job, come again!"
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

  def submitrevisedproposal
    @quest = Quest.find(params[:id])
    @quest.is_revisedproposalsent = true
    @quest.is_revisionrequested = false
    @quest.is_revisiontransition = false
    if @quest.save
      ProposalMailer.revised_proposal_email(@quest).deliver_later
      redirect_to edit_quest_path(@quest), notice: "Revised Proposal was sent"
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
    :picture1, :picture2, :picture3, :proof1, :proof2, :proof3, :revision, :is_revisiontransition,
    :is_revisedproposalsent, :platformfees)
  end
end
