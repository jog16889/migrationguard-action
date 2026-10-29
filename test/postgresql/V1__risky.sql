-- Fixture for the CLI smoke workflow: one Free critical risk and one Pro risk.
DROP TABLE legacy_invoices;
ALTER TABLE orders ALTER COLUMN billing_ref SET NOT NULL;
