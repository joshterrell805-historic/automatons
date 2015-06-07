set max_heap_table_size = 1000000000;
create table if not exists SProvider (
    id int not null primary key,
    type varchar(255),
    name varchar(255),
    gender varchar(255),
    dateOfBirth varchar(255),
    isSoleProprietor varchar(255),
    mStreet varchar(255),
    mUnit varchar(255),
    mCity varchar(255),
    mRegion varchar(255),
    mPostCode varchar(255),
    mCounty varchar(255),
    mCountry varchar(255),
    pStreet varchar(255),
    pUnit varchar(255),
    pCity varchar(255),
    pRegion varchar(255),
    pPostCode varchar(255),
    pCounty varchar(255),
    pCountry varchar(255),
    phone varchar(255),
    primarySpecialty varchar(255),
    secondarySpecialty varchar(255)
);
-- ENGINE = MEMORY;
create table if not exists PhoneNumber (
    id int not null auto_increment primary key,
    phone varchar(255) not null,
    unique(phone)
);
-- ENGINE = MEMORY;
create table if not exists Address (
    id int not null auto_increment primary key,
    street varchar(100),
    unit varchar(52), -- max length of unit from source records
    city varchar(100),
    region varchar(20),
    postcode varchar(20),
    county varchar(100),
    country varchar(5),
    CONSTRAINT uc_Address UNIQUE (street, unit, city, region, postcode, county, country)
);
-- ENGINE = MEMORY;
create table if not exists Specialty (
    parentId int,
    id int not null primary key auto_increment,
    title varchar(255),
    code varchar(255) unique,
    definition varchar(255),
    foreign key (parentId) references Specialty (id),
    CONSTRAINT uc_Specialty UNIQUE (parentid, title)
);
-- ENGINE = MEMORY;
create table if not exists CProvider (
    id int not null primary key,
    type enum('Organization', 'Individual') not null,
    name varchar(255),
    phone int,
    practiceAddress int,
    mailingAddress int,
    primarySpecialty int,
    secondarySpecialty int,
    foreign key (id) references SProvider (id),
    foreign key (phone) references PhoneNumber (id),
    foreign key (practiceAddress) references Address (id),
    foreign key (mailingAddress) references Address (id),
    foreign key (primarySpecialty) references Specialty (id),
    foreign key (secondarySpecialty) references Specialty (id)
);
-- ENGINE = MEMORY;
create table if not exists CIndividual (
    id int not null primary key,
    gender char(1),
    dateOfBirth varchar(255),
    isSoleProprietor enum('y', 'n', 'x'),
    foreign key (id) references CProvider (id)
);
-- ENGINE = MEMORY;
create table if not exists COrganization (
    id int not null auto_increment primary key,
    foreign key (id) references CProvider (id)
);
-- ENGINE = MEMORY;
create table if not exists MProvider (
    id int not null auto_increment primary key,
    type enum('Organization', 'Individual') not null,
    name varchar(255) not null
);
-- ENGINE = MEMORY;
create table if not exists MOrganization (
    id int not null primary key,
    foreign key (id) references MProvider(id)
);
-- ENGINE = MEMORY;
create table if not exists MIndividual (
    id int not null primary key,
    gender char(1),
    dateOfBirth varchar(255),
    isSoleProprietor enum('y', 'n', 'x'),
    foreign key (id) references MProvider(id)
);
-- ENGINE = MEMORY;
create table if not exists MProvider_PhoneNumber (
    mId int not null,
    phone int not null,
    primary key (mId, phone),
    foreign key (mId) references MProvider (id),
    foreign key (phone) references PhoneNumber (id)
);
-- ENGINE = MEMORY;
create table if not exists MProvider_SecondarySpecialty (
    mId int not null,
    specialty int not null,
    primary key (mId, specialty),
    foreign key (mId) references MProvider (id),
    foreign key (specialty) references Specialty (id)
);
-- ENGINE = MEMORY;
create table if not exists MProvider_PrimarySpecialty (
    mId int not null,
    specialty int not null,
    primary key (mId, specialty),
    foreign key (mId) references MProvider (id),
    foreign key (specialty) references Specialty (id)
);
-- ENGINE = MEMORY;
create table if not exists MProvider_MailingAddress (
    mId int not null,
    address int not null,
    primary key (mId, address),
    foreign key (mId) references MProvider (id),
    foreign key (address) references Address (id)
);
-- ENGINE = MEMORY;
create table if not exists MProvider_PracticeAddress (
    mId int not null,
    address int not null,
    primary key (mId, address),
    foreign key (mId) references MProvider (id),
    foreign key (address) references Address (id)
);
-- ENGINE = MEMORY;
create table if not exists Merge (
    mId int not null,
    sId int not null,
    primary key (mId, sId),
    foreign key (mId) references MProvider (id),
    foreign key (sId) references CProvider (id)
);
-- ENGINE = MEMORY;
create table if not exists Audit (
    id int not null auto_increment primary key,
    sId int not null,
    mId int not null,
    score int not null, -- This is the score of the winning source record
    -- This is a string describing the rule. For now, it'll take the form of
    -- "[field, field] => value"
    rule varchar(255) not null,
    foreign key (sId, mId) references Merge (sId, mId),
    CONSTRAINT uc_Audit UNIQUE (sId, mId, rule)
);
-- ENGINE = MEMORY;
