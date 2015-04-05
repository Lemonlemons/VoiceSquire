require "twilio-ruby"

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def voice
    fromnumber = params['From']
    if @duke = Duke.where(phonenumber: fromnumber).first
      response = Twilio::TwiML::Response.new do |r|
        r.Say 'Welcome master, what can I do for you?', :voice => 'alice'
        r.Record action:"/twilio/record", method:"post"
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
      quest = Quest.new(duke_id: duke.id, audiolink: recordingUrl)
      quest.save
      response = Twilio::TwiML::Response.new do |r|
        r.Say "It will be done."
      end
      render_twiml response
  end

  def message
    messageBody = params['Body']
    messageFrom = params['From']
    duke = Duke.where(phonenumber: fromnumber).first
    quest = Quest.new(duke_id:duke.id, textlink:messageBody)
    quest.save
    render_twiml Twilio::TwiML::Response.new
  end

  def status
    # the status can be found in params['MessageStatus']

    # send back an empty response

    render_twiml Twilio::TwiML::Response.new

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
