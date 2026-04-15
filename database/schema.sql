-- Users (central hub table)
CREATE TABLE Users (
    UserID      SERIAL PRIMARY KEY,
    Email       VARCHAR(255) NOT NULL UNIQUE,
    Password_Hash VARCHAR(255) NOT NULL,
    Date_Created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Last_Login  TIMESTAMP
);

-- Profile (extended user info)
CREATE TABLE Profile (
    ProfileID   SERIAL PRIMARY KEY,
    UserID      INT NOT NULL REFERENCES Users(UserID) ON DELETE CASCADE,
    First_Name  VARCHAR(100),
    Age         INT,
    Sex         VARCHAR(50),
    Height      DECIMAL(5,2),
    Weight      DECIMAL(5,2),
    BirthDate   DATE,
    JoinDate    DATE DEFAULT CURRENT_DATE
);

-- IdealSleep (personalized sleep need calculation)
CREATE TABLE IdealSleep (
    IdealSleepID  SERIAL PRIMARY KEY,
    UserID        INT NOT NULL REFERENCES Users(UserID) ON DELETE CASCADE,
    Recommended_Hours DECIMAL(4,2),
    Medical_Status VARCHAR(255),
    Pregnancy     BOOLEAN DEFAULT FALSE
);

-- SleepDebt (tracks accumulated sleep debt)
CREATE TABLE SleepDebt (
    SleepDebtID   SERIAL PRIMARY KEY,
    UserID        INT NOT NULL REFERENCES Users(UserID) ON DELETE CASCADE,
    Tracked_Sleep DECIMAL(5,2),
    Debt_Hours    DECIMAL(5,2)
);

-- SleepSchedule (bedtime/wake plans per day)
CREATE TABLE SleepSchedule (
    ScheduleID    SERIAL PRIMARY KEY,
    UserID        INT NOT NULL REFERENCES Users(UserID) ON DELETE CASCADE,
    Day_Of_Week   VARCHAR(10),
    Bedtime       TIME,
    Wake_Time     TIME,
    Activity_Level VARCHAR(50),
    Is_Active     BOOLEAN DEFAULT TRUE
);

-- Sleep_Log (actual recorded sleep entries)
CREATE TABLE Sleep_Log (
    LogID         SERIAL PRIMARY KEY,
    UserID        INT NOT NULL REFERENCES Users(UserID) ON DELETE CASCADE,
    Log_Date      DATE,
    Bedtime       TIME,
    Wake_Time     TIME,
    Duration_Hours DECIMAL(4,2),
    Quality_Score INT CHECK (Quality_Score BETWEEN 1 AND 10),
    Notes         TEXT
);

-- Sounds (alarm sound options)
CREATE TABLE Sounds (
    SoundID       SERIAL PRIMARY KEY,
    Sound_Name    VARCHAR(100),
    Color_Noise   VARCHAR(50),
    Ambiance      VARCHAR(100)
);

-- Alarm
CREATE TABLE Alarm (
    AlarmID       SERIAL PRIMARY KEY,
    UserID        INT NOT NULL REFERENCES Users(UserID) ON DELETE CASCADE,
    SoundID       INT REFERENCES Sounds(SoundID),
    Alarm_Time    TIME,
    Is_Active     BOOLEAN DEFAULT TRUE,
    Snooze_Duration INT DEFAULT 5
);

-- Badges
CREATE TABLE Badge (
    BadgeID       SERIAL PRIMARY KEY,
    Badge_Name    VARCHAR(100),
    Description   TEXT,
    Requirement   VARCHAR(255)
);

-- User_Badges (junction: which badges a user has earned)
CREATE TABLE User_Badges (
    UserBadgeID   SERIAL PRIMARY KEY,
    UserID        INT NOT NULL REFERENCES Users(UserID) ON DELETE CASCADE,
    BadgeID       INT NOT NULL REFERENCES Badge(BadgeID),
    Earned_At     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);