-- 1
INSERT INTO Terms (terms_id, terms_description, terms_due_days)
VALUES (6, 'Net due 120 days', 120);

-- 2
UPDATE Terms
SET terms_description = 'Net due 125 days', terms_due_days = 125
WHERE terms_id = 6;

-- 3
DELETE FROM Terms
WHERE terms_id = 6;

-- 4
INSERT INTO Invoices
VALUES (DEFAULT, 32, 'AX-014-027', '2018-08-01', 434.58, 0.00, 0.00, 2, '2018-08-31', null);

-- 5
INSERT INTO Invoice_Line_Items (invoice_sequence, account_number, line_item_amount, line_item_description, invoice_id)
VALUES 
    (1, 160, 180.23, 'Hard drive', 115),
    (2, 527, 254.35, 'Exchange Server update', 115);

-- 6
UPDATE Invoices
SET credit_total = 0.1 * invoice_total, payment_total = invoice_total - (0.1 * invoice_total)
WHERE invoice_id = 115;

-- 7
UPDATE Vendors
SET default_account_number = 403
WHERE vendor_id = 44;

-- 8
UPDATE Invoices
SET terms_id = 2
WHERE vendor_id IN 
	(SELECT vendor_id 
    FROM Vendors 
    WHERE default_terms_id = 2
    );
    

-- 9
DELETE FROM Invoice_Line_Items
WHERE invoice_id = 115;

DELETE FROM Invoices
WHERE invoice_id = 115;
