CREATE TABLE Caregivers (
    Username varchar(255),
    Salt BINARY(16),
    Hash BINARY(16),
    PRIMARY KEY (Username)
);

CREATE TABLE Availabilities (
    Time date,
    Username varchar(255) REFERENCES Caregivers,
    PRIMARY KEY (Time, Username)
);

CREATE TABLE Vaccines (
    Name varchar(255),
    Doses int,
    PRIMARY KEY (Name)
);

CREATE TABLE Patients (
    Username varchar(255),
    Salt BINARY(16),
    Hash BINARY(16),
    PRIMARY KEY (Username)
);

CREATE TABLE Appointments (
    appointmentId varchar(50),
    Time date,
    cUsername varchar(255) REFERENCES Caregivers,
    pUsername varchar(255) REFERENCES Patients,
    Name varchar(255) REFERENCES Vaccines, 
    PRIMARY KEY (appointmentId, cUsername, pUsername, Name)
);
