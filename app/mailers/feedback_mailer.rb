class FeedbackMailer < ActionMailer::Base
  default to: 'romc@kb.dk'



  def send_feedback(sender, system, item, comments)
    Rails.logger.debug "args are #{system}, #{sender}, #{item}, #{comments}"
    @comments = comments
    mail(:from => sender, :subject => "Feedback vedr. #{system} post #{item}")
  end

end
