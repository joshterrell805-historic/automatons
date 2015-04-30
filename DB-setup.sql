create table SProvider (
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
create table PhoneNumber (
    id int not null auto_increment primary key,
    phone varchar(255) not null,
    unique(phone)
);
create table Address (
    id int not null auto_increment primary key,
    street varchar(255),
    unit varchar(255),
    city varchar(255),
    region varchar(255),
    postcode varchar(255),
    county varchar(255),
    country varchar(255)
    -- "specified key is too long..."
    -- CONSTRAINT uc_Address UNIQUE (street, unit, city, region, postcode, county, country)
);
create table Specialty (
    parentId int,
    id int not null primary key,
    title varchar(255),
    code varchar(255) unique,
    definition varchar(255),
    foreign key (parentId) references Specialty (id),
    CONSTRAINT uc_Specialty UNIQUE (parentid, title)
);
create table CProvider (
    id int not null primary key,
    type enum('Organization', 'Individual') not null,
    name varchar(255),
    phone int,
    billingAddress int,
    mailingAddress int,
    primarySpecialty int,
    secondarySpecialty int,
    foreign key (id) references SProvider (id),
    foreign key (phone) references PhoneNumber (id),
    foreign key (billingAddress) references Address (id),
    foreign key (mailingAddress) references Address (id),
    foreign key (primarySpecialty) references Specialty (id),
    foreign key (secondarySpecialty) references Specialty (id)
);
create table CIndividual (
    id int not null primary key,
    gender char(1),
    dateOfBirth varchar(255),
    isSoleProprietor enum('y', 'n', 'x'),
    foreign key (id) references CProvider (id)
);
create table COrganization (
    id int not null auto_increment primary key,
    foreign key (id) references CProvider (id)
);
create table MProvider (
    id int not null auto_increment primary key,
    type enum('Organization', 'Individual') not null,
    name varchar(255) not null
);
create table MOrganization (
    id int not null primary key,
    foreign key (id) references MProvider(id)
);
create table MIndividual (
    id int not null primary key,
    gender char(1),
    dateOfBirth varchar(255),
    isSoleProprietor enum('y', 'n', 'x'),
    foreign key (id) references MProvider(id)
);
create table MProvider_PhoneNumber (
    mId int not null,
    phone int not null,
    primary key (mId, phone),
    foreign key (mId) references MProvider (id),
    foreign key (phone) references PhoneNumber (id)
);
create table MProvider_SecondarySpecialty (
    mId int not null,
    specialty int not null,
    primary key (mId, specialty),
    foreign key (mId) references MProvider (id),
    foreign key (specialty) references Specialty (id)
);
create table MProvider_PrimarySpecialty (
    mId int not null,
    specialty int not null,
    primary key (mId, specialty),
    foreign key (mId) references MProvider (id),
    foreign key (specialty) references Specialty (id)
);
create table MProvider_MailingAddress (
    mId int not null,
    address int not null,
    primary key (mId, address),
    foreign key (mId) references MProvider (id),
    foreign key (address) references Address (id)
);
create table MProvider_PracticeAddress (
    mId int not null,
    address int not null,
    primary key (mId, address),
    foreign key (mId) references MProvider (id),
    foreign key (address) references Address (id)
);
create table Merge (
    mId int not null,
    sId int not null,
    primary key (mId, sId),
    foreign key (mId) references MProvider (id),
    foreign key (sId) references CProvider (id)
);
create table Audit (
    id int not null auto_increment primary key,
    sId int not null,
    mId int not null,
    -- these fields are provisional;
    -- we haven't developed audit details much
    action varchar(255) not null,
    foreign key (sId, mId) references Merge (sId, mId),
    CONSTRAINT uc_Audit UNIQUE (sId, mId)
);

