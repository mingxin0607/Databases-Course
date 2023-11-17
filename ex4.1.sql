-- 1

SELECT vendor_id, SUM(invoice_total) AS total_invoice_amount
FROM Invoices
GROUP BY vendor_id;

-- 2
SELECT Vendors.vendor_name, SUM(Invoices.payment_total) AS total_payment_amount
FROM Vendors
JOIN Invoices ON Vendors.vendor_id = Invoices.vendor_id
GROUP BY Vendors.vendor_name
ORDER BY total_payment_amount DESC;

-- 3
SELECT vendor_name, COUNT(i.invoice_id) AS invoice_count, SUM(invoice_total) AS total_invoice_amount
FROM Vendors v
LEFT JOIN Invoices  i
ON v.vendor_id = i.vendor_id
GROUP BY v.vendor_name
ORDER BY invoice_count DESC;

-- 4
SELECT g.account_description, COUNT(i.invoice_id) AS item_count,
    SUM(i.line_item_amount) AS total_line_item_amount
FROM General_Ledger_Accounts g
JOIN Invoice_Line_Items i 
ON g.account_number = i.account_number
GROUP BY g.account_description
HAVING item_count > 1
ORDER BY total_line_item_amount DESC;

-- 5
SELECT g.account_description, COUNT(i.invoice_id) AS item_count,
    SUM(i.line_item_amount) AS total_line_item_amount
FROM General_Ledger_Accounts g
JOIN Invoice_Line_Items i 
ON g.account_number = i.account_number
JOIN Invoices i2
ON i.invoice_id = i2.invoice_id
WHERE i2.invoice_date BETWEEN '2018-04-01' AND '2018-06-30'
GROUP BY g.account_description
HAVING item_count > 1
ORDER BY total_line_item_amount DESC;

-- 6
SELECT account_number, SUM(line_item_amount) AS total_amount
FROM Invoice_Line_Items
GROUP BY account_number WITH ROLLUP;

-- 7
SELECT v.vendor_name, COUNT(DISTINCT il.account_number) AS num_accounts
FROM Vendors v
JOIN Invoices i 
ON v.vendor_id = i.vendor_id
JOIN Invoice_Line_Items il
ON i.invoice_id = il.invoice_id
GROUP BY v.vendor_name
HAVING num_accounts > 1;

-- 8
SELECT
    IF(GROUPING(terms_id) = 1, 'Grand Total', terms_id) AS terms_id,
    IF(GROUPING(vendor_id) = 1, 'Vendors', vendor_id) AS vendor_id,
    MAX(payment_date) AS last_payment_date,
    SUM(invoice_total - credit_total - payment_total) AS total_amount_due
FROM Invoices
GROUP BY terms_id, vendor_id WITH ROLLUP;

SELECT
    IF(GROUPING(terms_id) = 1, 'Grand Total', terms_id) AS terms_id,
    IF(GROUPING(vendor_id) = 1, 'Vendors', vendor_id) AS vendor_id,
    MAX(payment_date) AS last_payment_date,
    SUM(invoice_total - credit_total - payment_total) AS total_amount_due
FROM Invoices
WHERE payment_date IS NOT NULL 
GROUP BY terms_id, vendor_id WITH ROLLUP;

-- 9
SELECT
    vendor_id, invoice_id, balance_due,
    SUM(balance_due) OVER (ORDER BY vendor_id, invoice_id) AS cumulative_total,
    SUM(balance_due) OVER () AS total_due_for_all_vendors
FROM (
    SELECT vendor_id, invoice_id, (invoice_total - payment_total - credit_total) AS balance_due
    FROM Invoices
    WHERE invoice_total - payment_total - credit_total > 0
) AS sub;

-- 10
SELECT
    vendor_id, invoice_id, balance_due,
    SUM(balance_due) OVER (ORDER BY vendor_id, invoice_id) AS cumulative_total,
    SUM(balance_due) OVER w1 AS total_due_for_all_vendors,
    AVG(balance_due) OVER w2 AS cumulative_average
FROM (
    SELECT vendor_id, invoice_id, invoice_total - payment_total - credit_total AS balance_due
    FROM Invoices
    WHERE invoice_total - payment_total - credit_total > 0
) AS subquery
WINDOW
	w1 AS (),
    w2 AS (PARTITION BY vendor_id ORDER BY invoice_id);

-- 11
SELECT DATE_FORMAT(invoice_date, '%Y-%m') AS month_of_invoice,
    SUM(invoice_total) AS total_invoice,
    AVG(SUM(invoice_total)) OVER (ORDER BY DATE_FORMAT(invoice_date, '%Y-%m') ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS moving_average
FROM Invoices
GROUP BY DATE_FORMAT(invoice_date, '%Y-%m');
