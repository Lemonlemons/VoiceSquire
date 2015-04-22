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
      redirect_to quests_path, notice: "New Duke saved! Welcome to Squire!"
    else
      render "new"
    end
  end

  def edit
    @duke = Duke.find(params[:id])
  end

  def update
    @duke = Duke.find(params[:id])
    if @duke.update_attributes(duke_params)
      @duke.phonenumber = "+1" + @duke.phonenumber
      @duke.registered = true
      if @duke.save
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
    params.require(:duke).permit(:phonenumber, :firstname, :lastname, :email, :physicaladdress,
    :physicalcity, :physicalstate, :physicalcountry, :physicalzipcode, :preferredproposalmethod, :birthday, :is_landline,
    :is_mailingsameasphysicaladdress, :mailingaddress, :mailingcity, :mailingstate, :mailingcountry, :mailingzipcode,
    :is_female, :rating, :numberofquests, :numberofnotes, :registered, :password, :password_confirmation)
  end
end
