class FeedbackMailer < ActionMailer::Base
  default to: 'romc@kb.dk'



  def send_feedback(sender, item, comments)
    Rails.logger.debug "args are #{sender}, #{item}, #{comments}"
    @comments = comments
    mail(:from => sender, :subject => "Feedback vedr. post #{item}")
  end

end
