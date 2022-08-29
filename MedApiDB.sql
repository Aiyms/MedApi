CREATE TABLE Clients(
	Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	InsertDate Datetime,
	DateOfBirth Datetime,
	Gender BIT,
	IIN NVARCHAR(MAX),
	Phone NVARCHAR(MAX)
)

CREATE TABLE AnalysisList(
	Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	Name NVARCHAR(MAX),
	Price Decimal
)

CREATE TABLE Appoinments (
	Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	UserId UNIQUEIDENTIFIER FOREIGN KEY References Clients(Id),
	AnalysisId UNIQUEIDENTIFIER FOREIGN KEY References AnalysisList(Id),
	Date DateTime,
	InsertDate DateTime
)

CREATE TABLE Results (
	Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	UserId UNIQUEIDENTIFIER FOREIGN KEY References Clients(Id),
	AnalysisId UNIQUEIDENTIFIER FOREIGN KEY References AnalysisList(Id),
	InsertDate DateTime,
	Result NVARCHAR(MAX)
)


CREATE TABLE VisitLogs (
	Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	UserId UNIQUEIDENTIFIER FOREIGN KEY References Clients(Id),
	InsertDate DateTime,
	Result NVARCHAR(MAX),
	AnalysisId UNIQUEIDENTIFIER FOREIGN KEY References AnalysisList(Id)
)
