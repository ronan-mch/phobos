class FeedbackMailer < ActionMailer::Base
  default to: 'romc@kb.dk'



  def send_feedback(sender, system, item, comments)
    Rails.logger.debug "args are #{system}, #{sender}, #{item}, #{comments}"
    mail(:from => sender, :subject => "Feedback vedr. #{system} post #{item}", :body => comments)
  end

end
