-- 1
SELECT *
FROM Vendors v
INNER JOIN Invoices i ON v.vendor_id = i.vendor_id;

-- 2
SELECT v.vendor_name, i.invoice_number,
    i.invoice_date,i.invoice_total - (i.payment_total + i.credit_total) AS balance_due
FROM Vendors v
INNER JOIN Invoices i 
ON v.vendor_id = i.vendor_id
WHERE (i.invoice_total - (i.payment_total + i.credit_total)) <> 0;

-- 3
SELECT v.vendor_name, v.default_account_number, g.account_description
FROM Vendors v
JOIN General_Ledger_Accounts g
ON v.default_account_number = g.account_number
ORDER BY g.account_description, v.vendor_name;

-- 4
SELECT v.vendor_name, i.invoice_date, i.invoice_number,
    ili.invoice_sequence li_sequence, ili.line_item_amount li_amount
FROM Vendors v
JOIN Invoices i 
ON v.vendor_id = i.vendor_id
JOIN Invoice_Line_Items ili 
ON i.invoice_id = ili.invoice_id
ORDER BY v.vendor_name, i.invoice_date, i.invoice_number, li_sequence;

-- 5
SELECT v1.vendor_id, v1.vendor_name,
    CONCAT(v1.vendor_contact_first_name, ' ', v1.vendor_contact_last_name) AS contact_name
FROM Vendors v1
JOIN Vendors v2 
ON v1.vendor_id <> v2.vendor_id
AND v1.vendor_contact_last_name = v2.vendor_contact_last_name
ORDER BY v1.vendor_contact_last_name;

-- 6
SELECT g.account_number, g.account_description, invoice_id
FROM General_Ledger_Accounts g
LEFT JOIN Invoice_Line_Items i
ON g.account_number = i.account_number
WHERE i.invoice_id IS NULL
ORDER BY g.account_number;

SELECT g.account_number, g.account_description
FROM General_Ledger_Accounts g
LEFT JOIN Invoice_Line_Items i
ON g.account_number = i.account_number
WHERE i.invoice_id IS NULL
ORDER BY g.account_number;

-- 7

SELECT vendor_name, 'CA' AS vendor_state
FROM Vendors
WHERE vendor_state = 'California'
UNION
SELECT vendor_name, 'Outside CA' AS vendor_state
FROM Vendors
WHERE vendor_state <> 'California'
ORDER BY vendor_name;



