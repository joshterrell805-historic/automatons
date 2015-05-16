# Step definitions to work with the whole application

Given /^the test database configuration$/ do
   Dotenv.load ".env.test"
end
