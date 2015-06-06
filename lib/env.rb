def in_separate_environment
   env = ENV.to_hash
   result = yield
   ENV.replace env
   result
end
