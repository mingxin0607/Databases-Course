USE EX;

ALTER TABLE Members
ADD COLUMN annual_dues DECIMAL(5,2) DEFAULT 52.50,
ADD COLUMN payment_date DATE;
