class GoogleCaptchaValidator
  include HTTParty
  base_uri "https://www.google.com"

  GOOGLE_CAPTCHA_SECRET_KEY = ENV["GOOGLE_CAPTCHA_SECRET_KEY"]

  def self.validate(g_recaptcha_response)
    options = {
      query: {
        secret: GOOGLE_CAPTCHA_SECRET_KEY,
        response: g_recaptcha_response
      }
    }

    result = post("/recaptcha/api/siteverify", options)
    result["success"]
  end
end
