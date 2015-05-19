source DB-truncate-clean.sql;

SET FOREIGN_KEY_CHECKS = 0;
truncate table Specialty;
truncate table SProvider;
SET FOREIGN_KEY_CHECKS = 1;
