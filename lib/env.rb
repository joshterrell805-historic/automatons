def in_separate_environment
   env = ENV.to_h
   result = yield
   ENV.replace env
   result
end
