Use z1746608;

DROP TABLE IF EXISTS IS_RELATED_TO;
DROP TABLE IF EXISTS WORKS_ON;
DROP TABLE IF EXISTS FEED_IS_FED_TO_ANIMAL;
DROP TABLE IF EXISTS IMMUNIZATION;
DROP TABLE IF EXISTS HEALTH_RECORD;
DROP TABLE IF EXISTS REPAIR_MAINTENANCE;
DROP TABLE IF EXISTS HARVEST;
DROP TABLE IF EXISTS PLANTING;
DROP TABLE IF EXISTS ANIMAL;
DROP TABLE IF EXISTS MACHINERY;
DROP TABLE IF EXISTS LAND_PARCEL;
DROP TABLE IF EXISTS CROP;
DROP TABLE IF EXISTS BENEFIT;
DROP TABLE IF EXISTS FEED;
DROP TABLE IF EXISTS FARM;
DROP TABLE IF EXISTS PAY_PERIOD;
DROP TABLE IF EXISTS SKILLS;
DROP TABLE IF EXISTS EMPLOYEE;


CREATE TABLE EMPLOYEE (
Emp_ID int not null,
EmpFName varchar(20) not null,
EmpLName varchar(20) not null,
EmpBirthdate date,
EmpStreetAddress varchar(50) not null,
EmpCity varchar(20) not null,
EmpState varchar(20) not null,
EmpZip int not null,
EmpPhone varchar(20) not null,
Type varchar(20) not null,
NumberDependents int,
PRIMARY KEY (Emp_ID)
)ENGINE=INNODB;

CREATE TABLE SKILLS (
Emp_ID int not null,
Skills varchar(50) not null,
PRIMARY KEY(Emp_ID, Skills),
FOREIGN KEY (Emp_ID) REFERENCES EMPLOYEE (Emp_ID)
)ENGINE=INNODB;

CREATE TABLE PAY_PERIOD (
PayDate date,
Emp_ID int,
PayRate int not null,
NumberRegHoursWorked int not null,
NumberOvertimeHoursWorked int not null,
PaymentAmount decimal(10,2) not null,
FederalDeduction int not null,
StateDeduction int not null,
SocialSecurityDeduction int not null,
PRIMARY KEY(PayDate, Emp_ID),
FOREIGN KEY (Emp_ID) REFERENCES EMPLOYEE (Emp_ID)
)ENGINE=INNODB;

CREATE TABLE FARM (
FarmID int not null,
Emp_ID int,
FarmName varchar(20) not null,
FarmStreetAddr varchar(40) not null,
FarmCity varchar(20) not null,
FarmState varchar(20) not null,
FarmZip int not null,
FarmPhone varchar(20) not null,
FarmSpeciality varchar(20) not null,
PRIMARY KEY(FarmID),
FOREIGN KEY (Emp_ID) REFERENCES EMPLOYEE (Emp_ID)
)ENGINE=INNODB;

CREATE TABLE FEED (
FeedLotNumber int not null,
FeedName varchar(20) not null,
FeedManufacturer varchar(20) not null,
PRIMARY KEY(FeedLotNumber)
)ENGINE=INNODB;

CREATE TABLE BENEFIT (
BenefitID int not null,
Emp_ID int,
BenefitDescription varchar(40) not null,
BenefitAmount decimal(10,2) not null,
PRIMARY KEY(BenefitID, Emp_ID),
FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEE(Emp_ID)
)ENGINE=INNODB;

CREATE TABLE CROP (
CropID int not null,
CropName varchar(20) not null,
CropDescription varchar(40) not null,
CropOptimalPlantingDate date not null,
CropOptimalHarvestDate date not null,
CropOptimalPlantingWeather varchar (20) not null,
PRIMARY KEY(CropID)
)ENGINE=INNODB;

CREATE TABLE LAND_PARCEL (
LandParcelNumber int not null,
LandDescription varchar(50) not null,
LandPlatAddress varchar(50) not null,
FarmID int,
PRIMARY KEY(LandParcelNumber),
FOREIGN KEY (FarmID) REFERENCES FARM(FarmID)
)ENGINE=INNODB;

CREATE TABLE MACHINERY (
MachID int not null,
MachName varchar(20) not null,
MachVechicleID int not null,
MachPurchaseDate date not null,
MachPurchasePrice decimal(10,2) not null,
MachPurchaseVendor varchar(20) not null,
MachManufacturer varchar(20) not null,
FarmID int,
PRIMARY KEY(MachID),
FOREIGN KEY (FarmID) REFERENCES FARM(FarmID)
)ENGINE=INNODB;

CREATE TABLE ANIMAL (
AnimalID int not null,
AnimalType varchar(20) not null,
AnimalSelling varchar(20) not null,
AnimalBreeding varchar(20) not null,
AnimalBirthdate date not null,
AnimalGender varchar(20) not null,
FarmID int,
PRIMARY KEY(AnimalID),
FOREIGN KEY (FarmID) REFERENCES FARM(FarmID)
) ENGINE=INNODB;

CREATE TABLE PLANTING (
PlantingBeginDate date not null ,
CropID int,
LandParcelNumber int,
PlantingEndDate date not null,
PlantingAmountSeeds decimal(10,2) not null,
PlantingFertilizerTypeUsed varchar(20) not null,
PlantingtFertilizerAmounUsed int not null,
PlantingWeather varchar(20) not null,
PlantingEstimatedBushels int not null,
PRIMARY KEY(PlantingBeginDate, CropID, LandParcelNumber),
FOREIGN KEY (CropID) REFERENCES CROP(CropID),
FOREIGN KEY (LandParcelNumber) REFERENCES LAND_PARCEL(LandParcelNumber)
)ENGINE=INNODB;

CREATE TABLE HARVEST (
HarvestBeginDate date not null,
PlantingBeginDate date,
CropID int,
LandParcelNumber int, 
HarvestEndDate date not null,
HarvestBushelsReaped int not null,
HarvestWeather varchar(20) not null,
PRIMARY KEY(HarvestBeginDate, PlantingBeginDate, CropID, LandParcelNumber),
FOREIGN KEY (PlantingBeginDate) REFERENCES PLANTING (PlantingBeginDate),
FOREIGN KEY (CropID) REFERENCES CROP (CropID),
FOREIGN KEY (LandParcelNumber) REFERENCES LAND_PARCEL (LandParcelNumber)
)ENGINE=INNODB;

CREATE TABLE REPAIR_MAINTENANCE (
RepairDate date not null,
MachID int,
RepairDescription varchar(20) not null,
RepairCost int not null,
RepairOutsideVendor varchar(20) not null,
Emp_ID int not null,
PRIMARY KEY(RepairDate, MachID),
FOREIGN KEY (MachID) REFERENCES MACHINERY(MachID)
)ENGINE=INNODB;

CREATE TABLE HEALTH_RECORD (
HealthDate date not null,
AnimalID int,
HealthVetName varchar(20) not null,
HealthDiagnosis varchar(50) not null,
PRIMARY KEY(HealthDate,AnimalID),
FOREIGN KEY (AnimalID) REFERENCES ANIMAL(AnimalID)
)ENGINE=INNODB;

CREATE TABLE IMMUNIZATION (
ImmunizationID int not null,
AnimalID int,
ImmunDate date not null,
ImmunDescription varchar(50) not null,
ImmunDosage int not null,
ImmunReaction varchar(50) not null,
PRIMARY KEY(ImmunizationID, AnimalID),
FOREIGN KEY (AnimalID) REFERENCES ANIMAL(AnimalID)
) ENGINE=INNODB;


CREATE TABLE FEED_IS_FED_TO_ANIMAL (
AnimalID int,
FeedLotNumber int,
DateFed date not null,
PRIMARY KEY( AnimalID, FeedLotNumber),
FOREIGN KEY (AnimalID) REFERENCES ANIMAL(AnimalID),
FOREIGN KEY (FeedLotNumber) REFERENCES FEED(FeedLotNumber)
) ENGINE=INNODB;

CREATE TABLE WORKS_ON (
Emp_ID int,
FarmID int,
EmpStartDate varchar(12)not null,
EmpEndDate varchar(12),
PRIMARY KEY(Emp_ID, FarmID,EmpStartDate),
FOREIGN KEY (Emp_ID) REFERENCES EMPLOYEE (Emp_ID),
FOREIGN KEY (FarmID) REFERENCES FARM(FarmID)
) ENGINE=INNODB;

CREATE TABLE IS_RELATED_TO (
AnimalID int,
Related_AnimalID int not null,
PRIMARY KEY( AnimalID,Related_AnimalID),
FOREIGN KEY (AnimalID) REFERENCES ANIMAL(AnimalID),
FOREIGN KEY (Related_AnimalID) REFERENCES ANIMAL(AnimalID)
) ENGINE=INNODB;

