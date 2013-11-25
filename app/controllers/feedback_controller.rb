class FeedbackController < ApplicationController
  # To change this template use File | Settings | File Templates.
  def show

  end


  def send_message
    FeedbackMailer.send_feedback(params[:name], params[:email], params[:system], params[:id], params[:comments]).deliver
  end

end