class FeedbackController < ApplicationController
  @generate_url_with_host = false

  # To change this template use File | Settings | File Templates.
  def show

  end


  def send_message
    email_with_name = "#{params[:name]} <#{params[:email]}>"
    FeedbackMailer.send_feedback(email_with_name, params[:system], params[:id], params[:comments]).deliver
  end

end