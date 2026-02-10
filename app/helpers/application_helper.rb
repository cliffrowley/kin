module ApplicationHelper
  def toast_dismiss_delay
    Rails.env.test? ? 50 : 3000
  end

  def toast_fade_out_duration
    Rails.env.test? ? 10 : 300
  end
end
