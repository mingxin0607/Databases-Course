-- 8
SELECT vendor_name, vendor_contact_last_name, vendor_contact_first_name
FROM vendors;

SELECT vendor_name, vendor_contact_last_name, vendor_contact_first_name
FROM vendors
ORDER BY vendor_contact_last_name, vendor_contact_first_name;

-- 9
SELECT concat(vendor_contact_last_name, ', ', vendor_contact_first_name) as full_name
FROM vendors
WHERE 
    vendor_contact_last_name LIKE 'A%' OR 
    vendor_contact_last_name LIKE 'B%' OR 
    vendor_contact_last_name LIKE 'C%' OR 
    vendor_contact_last_name LIKE 'E%'
ORDER BY vendor_contact_last_name, vendor_contact_first_name;

-- 10
SELECT 
    invoice_due_date AS "Due Date",
    invoice_total AS "Invoice Total",
    0.1 * invoice_total AS "10%",
    invoice_total * 1.1 AS "Plus 10%"
FROM Invoices
WHERE invoice_total >= 500 AND invoice_total <= 1000
ORDER BY invoice_due_date DESC;

-- 11
SELECT 
    invoice_number,
    invoice_total,
    payment_total + credit_total AS payment_credit_total,
    invoice_total - (payment_total + credit_total) AS balance_due
FROM Invoices
WHERE invoice_total - (payment_total + credit_total) > 50
ORDER BY balance_due DESC
LIMIT 5;

-- 12
SELECT invoice_number, invoice_date,
    invoice_total - (payment_total + credit_total) AS balance_due, payment_date
FROM Invoices
WHERE payment_date IS NULL;

-- 13
SELECT DATE_FORMAT(CURRENT_DATE, '%m-%d-%Y') AS 'current_date';

-- 14
SELECT 50000 AS starting_principal, 0.065 * 50000 AS interest,
    50000 + (0.065 * 50000) AS principal_plus_interest;

