DROP TABLE Logins;
DROP TABLE GameLog;
DROP TABLE GamePlayers;
DROP TABLE Games;
DROP TABLE Users;

/* Original schema: */

CREATE TABLE Users(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(32) NOT NULL UNIQUE,
    passwd BINARY(20) NOT NULL,
    isValid INT(1) NOT NULL,
	email VARCHAR(255) NOT NULL,
    createTime DATETIME,
    validationCode VARCHAR(36));
    
CREATE TABLE Games(
    id INT PRIMARY KEY AUTO_INCREMENT,
    startData TEXT NOT NULL,
    startTime DATETIME,
	endTime DATETIME,
	spiesWin INT(1));
        
CREATE TABLE GamePlayers(
    gameId INT NOT NULL REFERENCES Games(id) ON DELETE CASCADE,
    seat TINYINT NOT NULL,
	playerId INT NOT NULL REFERENCES Users(id),
    isSpy INT NOT NULL,
    CONSTRAINT pk_gameplayers PRIMARY KEY (gameId, seat),
	CONSTRAINT uniquePlayer UNIQUE (playerId, gameId));
    
CREATE TABLE GameLog(
    gameId INT NOT NULL REFERENCES Games(id) ON DELETE CASCADE,
    id INT NOT NULL,
	playerId INT NOT NULL REFERENCES Users(id),
    action TEXT NOT NULL,
    time DATETIME NOT NULL,
    CONSTRAINT pk_gamelog PRIMARY KEY (gameId, id));

CREATE TABLE Logins(
	playerId INT NOT NULL REFERENCES Users(id),
	time DATETIME,
	ip BINARY(4) NOT NULL);

CREATE INDEX idx_logins ON Logins(playerId, time);

CREATE TRIGGER t1 BEFORE INSERT ON Users
	FOR EACH ROW SET NEW.createTime = IFNULL(NEW.createTime, NOW());
CREATE TRIGGER t2 BEFORE INSERT ON Games
	FOR EACH ROW SET NEW.startTime = IFNULL(NEW.startTime, NOW());
CREATE TRIGGER t3 BEFORE INSERT ON GameLog
        FOR EACH ROW SET NEW.time = IFNULL(NEW.time, NOW());
CREATE TRIGGER t4 BEFORE INSERT ON Logins
        FOR EACH ROW SET NEW.time = IFNULL(NEW.time, NOW());




SET @botpass = UNHEX(SHA1('password'));

INSERT Users(name, passwd, isValid, email) VALUES ('test', @botpass, 1, 'test@example.com');
INSERT Users(name, passwd, isValid, email) VALUES ('<Alpha>', @botpass, 1, 'alpha@example.com');
INSERT Users(name, passwd, isValid, email) VALUES ('<Bravo>', @botpass, 1, 'bravo@example.com');
INSERT Users(name, passwd, isValid, email) VALUES ('<Charlie>', @botpass, 1, 'charlie@example.com');
INSERT Users(name, passwd, isValid, email) VALUES ('<Delta>', @botpass, 1, 'delta@example.com');
INSERT Users(name, passwd, isValid, email) VALUES ('<Echo>', @botpass, 1, 'echo@example.com');
INSERT Users(name, passwd, isValid, email) VALUES ('<Foxtrot>', @botpass, 1, 'foxtrot@example.com');
INSERT Users(name, passwd, isValid, email) VALUES ('<Golf>', @botpass, 1, 'golf@example.com');
INSERT Users(name, passwd, isValid, email) VALUES ('<Hotel>', @botpass, 1, 'hotel@example.com');
INSERT Users(name, passwd, isValid, email) VALUES ('<India>', @botpass, 1, 'india@example.com');
INSERT Users(name, passwd, isValid, email) VALUES ('<Juliet>', @botpass, 1, 'juliet@example.com');

/* Schema change: Games.gameType added */
ALTER TABLE Games ADD gameType TINYINT NOT NULL DEFAULT 1
