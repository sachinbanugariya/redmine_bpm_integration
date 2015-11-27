class BpmController < ApplicationController
  unloadable

  before_filter :authorize_global

  def handle_sucess(msg_code)
    redirect_to :back, notice: l(msg_code)
  end

  def handle_error(msg_code, error = nil)
    logger.error self.class
    logger.error response.code
    logger.error response.body
    if error
      logger.error error.msg
      error.backtrace.each { |line| logger.error line }
    end
    redirect_to :back, flash: {error: l(msg_code)}
  end

end
