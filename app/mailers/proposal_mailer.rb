class ProposalMailer < ApplicationMailer
  def proof_email(quest)
    @quest = quest
    mail(to: "moeandrew@hotmail.com", subject: 'Proof from Squire')
  end
  def proposal_email(quest)
    @duke = Duke.where(id: quest.duke_id).first
    @quest = quest
    mail(to: @duke.email, subject: 'Proposal from Squire')
  end
  def welcome_email(duke)
    @duke = duke
    mail(to: @duke.email, subject: "Welcome to Squire")
  end
end
