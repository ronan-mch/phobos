class FeedbackMailer < ActionMailer::Base
  default to: 'romc@kb.dk'



  def send_feedback(email_with_name, system, item, comments)
    mail(:from => email_with_name, :subject => "Feedback vedr. #{system} post #{item}", :body => comments)
  end

end
