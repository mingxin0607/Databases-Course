-- 1
SELECT DISTINCT vendor_name
FROM vendors 
WHERE vendor_id IN (
	SELECT vendor_id
    FROM invoices
)
ORDER BY vendor_name;

-- SELECT DISTINCT vendor_name 
-- FROM vendors JOIN invoices 
-- ON vendors.vendor_id= invoices.vendor_id 
-- ORDER BY vendor_name;


-- 2
SELECT invoice_number, invoice_total
FROM Invoices
WHERE payment_total > 0
	AND payment_total > (
	SELECT AVG(payment_total) 
    FROM invoices 
    WHERE payment_total > 0
    )
ORDER BY invoice_total DESC;

-- 3
SELECT account_number, account_description
FROM General_Ledger_Accounts g
WHERE NOT EXISTS (
    SELECT *
    FROM Invoice_Line_Items i
    WHERE i.account_number = g.account_number
)
ORDER BY account_number;

-- 4
SELECT vendor_name, i.invoice_id, invoice_sequence, line_item_amount
FROM vendors v 
JOIN invoices i
  ON v.vendor_id = i.vendor_id
JOIN invoice_line_items li
  ON i.invoice_id = li.invoice_id
WHERE (i.invoice_id) IN (
    SELECT invoice_id
    FROM Invoice_Line_Items
    WHERE invoice_sequence > 1
)
ORDER BY vendor_name, i.invoice_id, invoice_sequence;

-- 5
SELECT vendor_id, MAX(invoice_total) largest_unpaid_invoice
FROM Invoices
WHERE invoice_total - credit_total - payment_total > 0
GROUP BY vendor_id;

SELECT SUM(largest_unpaid_invoice) total_largest_unpaid_invoices
FROM (
	SELECT vendor_id, MAX(invoice_total) largest_unpaid_invoice
	FROM Invoices
	WHERE invoice_total - credit_total - payment_total > 0
	GROUP BY vendor_id
) AS subq;

-- 6
SELECT vendor_name, vendor_city, vendor_state
FROM Vendors
WHERE (vendor_city, vendor_state) IN (
    SELECT vendor_city, vendor_state
    FROM Vendors
    GROUP BY vendor_city, vendor_state
    HAVING COUNT(*) = 1
)
ORDER BY vendor_state, vendor_city;

-- 7
SELECT v.vendor_name, i.invoice_number, i.invoice_date, i.invoice_total
FROM Vendors v
JOIN Invoices i
ON v.vendor_id = i.vendor_id
WHERE invoice_date = (
        SELECT MIN(invoice_date)
        FROM Invoices
        WHERE vendor_id = v.vendor_id
    )
ORDER BY vendor_name;

-- 8
SELECT v.vendor_name, i.invoice_number, i.invoice_date, i.invoice_total
FROM Vendors v
JOIN (
    SELECT vendor_id, invoice_number,
        invoice_date, invoice_total
    FROM Invoices i1
    WHERE invoice_date = (
            SELECT MIN(invoice_date)
            FROM Invoices i2
            WHERE i1.vendor_id = i2.vendor_id
        )
) i ON v.vendor_id = i.vendor_id
ORDER BY vendor_name;

-- 9
WITH subquery AS
(
	SELECT vendor_id, MAX(invoice_total) largest_unpaid_invoice
	FROM Invoices
	WHERE invoice_total - credit_total - payment_total > 0
	GROUP BY vendor_id
)
SELECT SUM(largest_unpaid_invoice) total_largest_unpaid_invoices
FROM subquery;
