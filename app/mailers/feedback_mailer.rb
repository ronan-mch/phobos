class FeedbackMailer < ActionMailer::Base
  default to: 'romc@kb.dk'



  def send_feedback(name, email, system, item, comments)
    mail(:from => name, :reply_to => email, :subject => "Feedback vedr. #{system} post #{item}", :body => comments)
  end

end
