class FeedbackController < ApplicationController
  # To change this template use File | Settings | File Templates.
  def show

  end


  def send_message
    Rails.logger.debug "params are #{params.inspect}"
    FeedbackMailer.send_feedback(params[:from], params[:system], params[:id], params[:comments]).deliver
  end

end