require "httparty"

class GoogleCaptchaValidator
  GOOGLE_CAPTCHA_SECRET_KEY = ENV["GOOGLE_CAPTCHA_SECRET_KEY"]

  def self.validate(g_recaptcha_response)
    options = {
      query: {
        secret: GOOGLE_CAPTCHA_SECRET_KEY,
        response: g_recaptcha_response
      }
    }

    result = ::HTTParty.post("https://www.google.com/recaptcha/api/siteverify", options)
    result["success"]
  end
end
