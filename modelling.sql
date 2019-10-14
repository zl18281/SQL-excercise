DROP TABLE IF EXISTS ServiceBook;
DROP TABLE IF EXISTS Service;
DROP TABLE IF EXISTS GuestRecord;
DROP TABLE IF EXISTS Room;
DROP TABLE IF EXISTS RoomType;
DROP TABLE IF EXISTS RoomState;

CREATE TABLE RoomState(
    stateId INTEGER NOT NULL AUTO_INCREMENT,
    stateName VARCHAR(10) NOT NULL UNIQUE,
    PRIMARY KEY (stateId),
    CHECK (stateName in ('Empty', 'Booked'))
);

CREATE TABLE RoomType(
    typeId INTEGER NOT NULL AUTO_INCREMENT,
    typeName VARCHAR(20) NOT NULL UNIQUE,
    price REAL NOT NULL,
    PRIMARY KEY (typeId),
    CHECK (price >= 0)
);

CREATE TABLE Room(
    roomId INTEGER NOT NULL AUTO_INCREMENT,
    type INTEGER NOT NULL,
    state INTEGER NOT NULL,
    PRIMARY KEY (roomId),
    FOREIGN KEY (type) REFERENCES RoomType(typeId),
    FOREIGN KEY (state) REFERENCES RoomState(stateId)
);

CREATE TABLE GuestRecord(
    guestId INTEGER NOT NULL AUTO_INCREMENT,
    passport VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    checkInTime DATETIME NOT NULL,
    CheckOutTime DATETIME NOT NULL,
    room INTEGER NOT NULL,
    PRIMARY KEY (guestId),
    FOREIGN KEY (room) REFERENCES Room(roomId)
);

CREATE TABLE Service(
    serviceId INTEGER NOT NULL AUTO_INCREMENT,
    serviceName VARCHAR(100) UNIQUE NOT NULL,
    PRIMARY KEY (serviceId)
);

CREATE TABLE ServiceBook(
    serviceNumber INTEGER NOT NULL AUTO_INCREMENT,
    guest INTEGER NOT NULL,
    service INTEGER NOT NULL,
    PRIMARY KEY (serviceNumber),
    CONSTRAINT g_s_pair UNIQUE (guest, service),
    FOREIGN KEY (guest) REFERENCES GuestRecord(guestId),
    FOREIGN KEY (service) REFERENCES Service(serviceId)
);
