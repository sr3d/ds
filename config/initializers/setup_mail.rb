if Rails.env.development?
  class DevelopmentMailInterceptor  
    def self.delivering_email(message)  
      message.subject = "[#{message.to}] #{message.subject}"  
      message.to = ENV['development_test_email_address']
    end  
  end  
  ActionMailer::Base.register_interceptor DevelopmentMailInterceptor
end