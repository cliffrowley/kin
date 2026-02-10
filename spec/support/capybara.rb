RSpec.configure do |config|
  config.before(:each, type: :system) do
    if driven_by_rack_test?(self)
      driven_by :rack_test
    else
      driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
    end
  end
end

def driven_by_rack_test?(example)
  !example.metadata[:js]
end
