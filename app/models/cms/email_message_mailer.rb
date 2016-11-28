module Cms
  class EmailMessageMailer < ActionMailer::Base

    def email_message(message)
      @body = message.body
      email = {
        to: message.recipients,
        from: message.sender,
        subject: message.subject
      }
      email[:content_type]  = message.content_type if message.content_type
      mail email
    end

  end
end