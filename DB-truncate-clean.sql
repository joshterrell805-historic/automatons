source DB-truncate-merge.sql;

SET FOREIGN_KEY_CHECKS = 0;
truncate table COrganization;
truncate table CIndividual;
truncate table CProvider;
truncate table Address;
truncate table PhoneNumber;
SET FOREIGN_KEY_CHECKS = 1;
