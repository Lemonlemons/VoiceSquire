require "twilio-ruby"

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def voice
    fromnumber = params['From']
    call_sid = params['CallSid']
    if @duke = Duke.where(phonenumber: fromnumber).first
      if @duke.activequest_id == nil
        @duke.callsid = call_sid
        if @user = User.where(is_active: true).first
          @duke.save
          response = Twilio::TwiML::Response.new do |r|
            # Should be your Twilio Number or a verified Caller ID
            r.Say "Connecting you to a Squire now."
            r.Dial :callerId => Rails.application.secrets.twilio_phone_number, :record => "true", :action => "/twilio/squire_record" do |d|
              # d.Client @user.id.to_s
              d.Queue "Squire Queue", url:"/twilio/duke_connect"
            end
          end
        else
          @duke.is_active = true
          @duke.save
          response = Twilio::TwiML::Response.new do |r|
            r.Enqueue "Duke Queue", waitUrl:"/twilio/duke_queue", action:"/twilio/duke_hungup"
          end
        end
      else
        response = Twilio::TwiML::Response.new do |r|
          r.Say 'Hello Master, we can only do one quest for you at a time', :voice => 'alice'
          # r.Record action:"/twilio/record", method:"post"
        end
      end
    else
      response = Twilio::TwiML::Response.new do |r|
        r.Say 'Hello and Welcome to Squire, to sign up to use Squire plese go to use Squire.com', :voice => 'alice'
        # r.Record action:"/twilio/record", method:"post"
      end
    end

    render_twiml response
  end

  def squirevoice
    fromnumber = params['From']
    call_sid = params['CallSid']
    if @user = User.where(phonenumber: fromnumber).first
      if @user.activequests < 3
        if duke = Duke.where(is_active: true).first
          @user.callsid = call_sid
          @user.save
          response = Twilio::TwiML::Response.new do |r|
            # Should be your Twilio Number or a verified Caller ID
            r.Say "Connecting you to the Duke in waiting"
            r.Dial :callerId => Rails.application.secrets.twilio_phone_number, :record => "true", :action => "/twilio/duke_record" do |d|
              # d.Client @user.id.to_s
              d.Queue "Duke Queue", url:"/twilio/squire_connect"
            end
          end
        else
          @user.callsid = call_sid
          @user.is_active = true
          @user.save
          response = Twilio::TwiML::Response.new do |r|
            # Should be your Twilio Number or a verified Caller ID
            r.Enqueue "Squire Queue", waitUrl:"/twilio/squire_queue", action:"/twilio/squire_hungup"
          end
        end
      else
        response = Twilio::TwiML::Response.new do |r|
          # Should be your Twilio Number or a verified Caller ID
          r.Say "You can only have three quests active at a time."
        end
      end
    else
      response = Twilio::TwiML::Response.new do |r|
        # Should be your Twilio Number or a verified Caller ID
        r.Say "Hello, and welcome to Squire. Please go to our website joinSquire.com to sign up to become a squire. Have a nice day!", :voice => 'alice'
      end
    end
    render_twiml response
  end

  def duke_connect
    call_sid = params['CallSid']
    dequeue_sid = params['DequeingCallSid']
    duke = Duke.where(callsid: dequeue_sid).first
    user = User.where(callsid: call_sid).first
    quest = Quest.new(duke_id: duke.id, squire_id: user.id, typeofquest: 1)
    quest.save
    user.activequests = user.activequests + 1
    user.is_active = false
    user.save
    # duke.activequest_id = quest.id
    duke.callsid = nil
    duke.save
    response = Twilio::TwiML::Response.new do |r|
      r.Say "Connecting you to the duke now."
    end

    render_twiml response
  end

  def squire_connect
    call_sid = params['CallSid']
    dequeue_sid = params['DequeingCallSid']
    duke = Duke.where(callsid: call_sid).first
    user = User.where(callsid: dequeue_sid).first
    quest = Quest.new(duke_id: duke.id, squire_id: user.id, typeofquest: 1)
    quest.save
    user.activequests = user.activequests + 1
    user.callsid = nil
    user.save
    # duke.activequest_id = quest.id
    duke.is_active = false
    duke.save
    response = Twilio::TwiML::Response.new do |r|
      r.Say "Connecting you to the squire now."
    end

    render_twiml response
  end

  def squire_queue
    squirenumber = params['From']
    position = params['QueuePosition']
    response = Twilio::TwiML::Response.new do |r|
      r.Say "Welcome Squire. Adding you to the queue now."
      r.Say "you are number "+ position +" in line"
      r.Play "http://216.227.134.162/ost/the-legend-of-zelda-skyward-sword-expanded/kopimkmxrl/1-14-groose-s-theme.mp3"
    end
    render_twiml response
  end

  def duke_queue
    dukenumber = params['From']
    position = params['QueuePosition']
    response = Twilio::TwiML::Response.new do |r|
      r.Say "Hello, all Squires are busy at the moment so I'll add you to the queue.", :voice => 'alice'
      r.Say "You are number "+ position +" in line"
      r.Play "http://216.227.134.162/ost/the-legend-of-zelda-skyward-sword-expanded/kopimkmxrl/1-14-groose-s-theme.mp3"
    end
    render_twiml response
  end

  def squire_hungup
    call_sid = params['CallSid']
    user = User.where(callsid: call_sid).first
    user.is_active = false
    user.callsid = nil
    user.save

    render_twiml Twilio::TwiML::Response.new
  end

  def duke_hungup
    call_sid = params['CallSid']
    duke = Duke.where(callsid: call_sid).first
    duke.is_active = false
    duke.callsid = nil
    duke.save

    render_twiml Twilio::TwiML::Response.new
  end

  def squire_record
    dukenumber = params['From']
    recordingUrl = params['RecordingUrl']
    duke = Duke.where(phonenumber:dukenumber).first
    quest = Quest.where("duke_id = ? AND is_proofsubmitted = ?", duke.id, false).first
    quest.audiolink = recordingUrl
    quest.save

    render_twiml Twilio::TwiML::Response.new
  end

  def duke_record
    squirenumber = params['From']
    recordingUrl = params['RecordingUrl']
    user = User.where(phonenumber:squirenumber).first
    quest = Quest.where("squire_id = ? AND is_assigned = ?", user.id, false).first
    quest.audiolink = recordingUrl
    quest.save

    render_twiml Twilio::TwiML::Response.new
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
      if @duke.activequest_id != nil
        textmessage = Message.new(duke_id: @duke.id, quest_id: @duke.activequest_id, is_text: true, sentby_duke: true, body: messageBody)
        textmessage.save
      else
        if @user = User.where(is_text_active: true).first
          @quest = Quest.new(duke_id:@duke.id, squire_id:@user.id, textlink:messageBody, typeofquest:2)
          @quest.save
          @user.activequests = @user.activequests + 1
          @user.is_text_active = false
          @user.save
          @duke.activequest_id = quest.id
          @duke.numberofquests = @duke.numberofquests + 1
          @duke.save
          textmessage = Message.new(duke_id: @duke.id, quest_id: @duke.activequest_id, is_text: true, sentby_duke: true, body: messageBody)
          textmessage.save
          client.messages.create from: Rails.application.secrets.twilio_phone_number, to: @user.phonenumber, body:"You've received the following text quest: "+messageBody
        else
          quest = Quest.new(duke_id:@duke.id, textlink:messageBody, typeofquest:2)
          quest.save
          client.messages.create from: Rails.application.secrets.twilio_phone_number, to: messageFrom, body:'A Squire will text you soon to confirm your request.'
          @duke.activequest_id = quest.id
          @duke.numberofquests = @duke.numberofquests + 1
          @duke.save
        end
      end
    else
        client.messages.create from: Rails.application.secrets.twilio_phone_number, to: messageFrom, body:'Please go to www.joinSquire.com to sign up to use Squire.'
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
