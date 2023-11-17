USE EX;

INSERT INTO Members (member_id, first_name, last_name, address, city, state, phone)
VALUES
    (1, 'AAA', 'aaa', 'Add1', 'City1', 'CA', '123-456-7890'),
    (2, 'BBB', 'bbb', 'Add2', 'City2', 'NY', '999-999-9999');

INSERT INTO Committees (committee_id, committee_name)
VALUES
    (1, 'Committee1'),
    (2, 'Committee2');

INSERT INTO Members_Committees (member_id, committee_id)
VALUES
    (1, 2),
    (2, 1),
    (2, 2);

SELECT c.committee_name, m.last_name, m.first_name
FROM Members_Committees mc
JOIN Members m ON mc.member_id = m.member_id
JOIN Committees c ON mc.committee_id = c.committee_id
ORDER BY c.committee_name, m.last_name, m.first_name;
