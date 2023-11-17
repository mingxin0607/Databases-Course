USE EX;

ALTER TABLE Committees
ADD CONSTRAINT unique_committee_name UNIQUE (committee_name);

INSERT INTO Committees (committee_id, committee_name)
VALUES (3, 'Committee1'); 