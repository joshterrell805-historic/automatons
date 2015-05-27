# DataMaster
This is the MDM system built by the Automatons for Cal Poly's CPE 366 class in
the spring of 2015. What follows are directions on how to get started and
explanations of the basic function of this code.

## Getting Started
You'll need MySQL and Ruby installed in order to run this system. You'll also
need a number of gems and their dependent libraries.

Begin by cloning this repository locally so you'll be able to run the programs
in it. Create two databases in MySQL: one for testing and one for processing
your actual data. To use these databases, the application will need to know
their credentials. It uses the credentials stored in the following environment
variables:
* mysql_host
* mysql_password
* mysql_user
* mysql_database

Generally, you will want to set systemwide environment variables to the correct
values for production, and then set the testing values in the file ".env.test"
which is in the repo. The file ".env" may be used to store production values if
it is not feasible to set them globally.

The data we are working with is available in the Providers.tsv
and Specialties.tsv files.

Once you've created a database and set the environment variables appropriately,
you'll want to run `rake`. This will create the database tables needed and
insert all the data into them. Once this completes, you will be able to use
`./bin/app` to run the MDM application.

There are many tests available for DataMaster. To run them, run `rake test`.
This will run both the Cucumber acceptance tests and the RSpec unit tests. For
code coverage information, run `rake coverage`.

To generate documentation, run `yard` in the top-level directory of the project.
For advice on documentation quality, run `inch` in the top-level directory of
the project.
