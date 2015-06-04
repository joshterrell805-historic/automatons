# Step definitions to work with the whole application
if RUBY_PLATFORM == 'java'
   Before do
      @aruba_timeout_seconds = 30
   end
end
