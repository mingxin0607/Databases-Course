USE EX;

-- Drop tables if they already exist
DROP TABLE IF EXISTS Members_Committees;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Committees;

-- Create Committees table
CREATE TABLE Committees (
    committee_id INT PRIMARY KEY,
    committee_name VARCHAR(255) NOT NULL
);

-- Create Members table
CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    address VARCHAR(255) DEFAULT 'NA',
    city VARCHAR(255) DEFAULT 'NA',
    state VARCHAR(2) DEFAULT 'NA',
    phone VARCHAR(20) DEFAULT 'NA'
);

-- Create Members_Committees table
CREATE TABLE Members_Committees (
    member_id INT,
    committee_id INT,
    PRIMARY KEY (member_id, committee_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (committee_id) REFERENCES Committees(committee_id)
);
