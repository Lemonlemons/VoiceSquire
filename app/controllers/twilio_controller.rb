require "twilio-ruby"

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def voice
    fromnumber = params['From']
    if @duke = Duke.where(phonenumber: fromnumber).first
      if @duke.email != nil
        if @duke.activequest_id != nil
          response = Twilio::TwiML::Response.new do |r|
            r.Say 'Hello Master, we can only do one quest for you at a time', :voice => 'alice'
          end
        else
          response = Twilio::TwiML::Response.new do |r|
            r.Say 'Welcome master, what can I do for you?', :voice => 'alice'
            r.Record action:"/twilio/record", method:"post"
          end
        end
      else
        response = Twilio::TwiML::Response.new do |r|
          r.Say 'Thank you for contacting us but we will contact you soon to help set up your account', :voice => 'alice'
        end
      end
    else
      @duke = Duke.new(phonenumber: fromnumber)
      if @duke.save
        response = Twilio::TwiML::Response.new do |r|
          r.Say "Hello, and welcome to Squire. A squire will connect with you shortly to help fill out your new user registration.", :voice => 'alice'
        end
      else
        response = Twilio::TwiML::Response.new do |r|
          r.Say "Something went wrong, please try again."
        end
      end
    end

    render_twiml response
  end

  def record
    dukenumber = params['From']
    recordingUrl = params['RecordingUrl']
    recordingDuration = params['RecordingDuration']
    duke = Duke.where(phonenumber:dukenumber).first
    quest = Quest.new(duke_id: duke.id, audiolink: recordingUrl, typeofquest:1)
    if quest.save
      duke.activequest_id = quest.id
      duke.save
      response = Twilio::TwiML::Response.new do |r|
        r.Say "It will be done."
      end
    else
      response = Twilio::TwiML::Response.new do |r|
        r.Say "There was a problem"
      end
    end
    render_twiml response
  end

  def message
    messageBody = params['Body']
    messageFrom = params['From']
    client = Twilio::REST::Client.new(Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token)
    if @duke = Duke.where(phonenumber: messageFrom).first
      if @duke.email != nil
        if @duke.activequest_id != nil
          textmessage = Message.new(duke_id: @duke.id, quest_id: @duke.activequest_id, is_text: true, sentby_duke: true, body: messageBody)
          textmessage.save
        else
          client.messages.create from: Rails.application.secrets.twilio_phone_number, to:@duke.phonenumber, body:'It will be done.'
          quest = Quest.new(duke_id:@duke.id, textlink:messageBody, typeofquest:2)
          quest.save
          @duke.activequest_id = quest.id
          @duke.save
        end
      else
        client.messages.create from: Rails.application.secrets.twilio_phone_number, to:@duke.phonenumber, body:'A Squire will contact you shortly'
      end
    else
      @duke = Duke.new(phonenumber: messageFrom)
      if @duke.save
        client.messages.create from: Rails.application.secrets.twilio_phone_number, to:@duke.phonenumber, body:'A Squire will contact you shortly to complete your registration.'
      else
        client.messages.create from: Rails.application.secrets.twilio_phone_number, to:@duke.phonenumber, body:'There was a problem'
      end
    end

    render_twiml Twilio::TwiML::Response.new
  end

  def status
    # the status can be found in params['MessageStatus']

    # send back an empty response

    render_twiml Twilio::TwiML::Response.new

  end

  def notify
    client = Twilio::REST::Client.new(Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token)
    message = client.messages.create from:'+12183166108', to:'+12183162469', body:'Learning to send SMS you are.'
  end

  def connect_customer
   # accessing mocked customers db
   customer = params[:id]
   response = Twilio::TwiML::Response.new do |r|
     r.Say 'Hello. Connecting you to the customer now.', :voice => 'alice'
     r.Dial :callerId => Rails.application.secrets.twilio_phone_number do |d|
       d.Number customer
     end
   end

   render_twiml response
  end

end
