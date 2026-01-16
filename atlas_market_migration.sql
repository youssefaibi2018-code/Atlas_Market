-- ==========================================================
-- PROJECT: ATLAS MARKET - DATA QUALITY & MIGRATION
-- DBA: YOUSSEF AIBI
-- DESCRIPTION: Cleaning Legacy CSV Data & Oracle 19c Migration
-- ==========================================================

-- 🔹 STEP 1: Check System Status
SELECT status FROM v$instance;
SELECT name, open_mode FROM v$database;

-- 🔹 STEP 2: Infrastructure - Create Dedicated PDB
CREATE PLUGGABLE DATABASE pdb_atlas_market
ADMIN USER atlas_admin IDENTIFIED BY Admin123
FILE_NAME_CONVERT = ('/pdbseed/', '/pdb_atlas_market/');

ALTER PLUGGABLE DATABASE pdb_atlas_market OPEN;
ALTER PLUGGABLE DATABASE pdb_atlas_market SAVE STATE;

-- 🔹 STEP 3: Connect to the Project Container
ALTER SESSION SET CONTAINER = pdb_atlas_market;

-- 🔹 STEP 4: Storage Strategy - Dedicated Tablespaces
CREATE TABLESPACE ts_products DATAFILE 'ts_products01.dbf' SIZE 100M AUTOEXTEND ON;
CREATE TABLESPACE ts_customers DATAFILE 'ts_customers01.dbf' SIZE 100M AUTOEXTEND ON;
CREATE TABLESPACE ts_sales     DATAFILE 'ts_sales01.dbf'     SIZE 150M AUTOEXTEND ON;
CREATE TABLESPACE ts_backup    DATAFILE 'ts_backup01.dbf'    SIZE 200M AUTOEXTEND ON;

-- 🔹 STEP 5: Security - Application User & Quotas
CREATE USER app_user IDENTIFIED BY App123 
DEFAULT TABLESPACE ts_products;

ALTER USER app_user QUOTA UNLIMITED ON ts_products;
ALTER USER app_user QUOTA UNLIMITED ON ts_customers;
ALTER USER app_user QUOTA UNLIMITED ON ts_sales;

GRANT CREATE SESSION, CREATE TABLE TO app_user;

-- 🔹 STEP 6: Staging Area - Source Tables (Simulating CSV Import)
CREATE TABLE products_bad (
  product_id NUMBER, product_name VARCHAR2(100), price NUMBER
) TABLESPACE ts_products;

INSERT INTO products_bad VALUES (1,'Laptop',1200);
INSERT INTO products_bad VALUES (5,'Printer',NULL); -- BAD DATA
INSERT INTO products_bad VALUES (6,NULL,150);      -- BAD DATA
INSERT INTO products_bad VALUES (7,'Tablet',-200); -- BAD DATA
-- ... (Zid baqi l-inserts hna)
COMMIT;

-- 🔹 STEP 7: Target Area - Clean Tables with Constraints
CREATE TABLE products_clean (
  product_id NUMBER PRIMARY KEY,
  product_name VARCHAR2(100) NOT NULL,
  price NUMBER NOT NULL CHECK (price > 0)
) TABLESPACE ts_products;

-- 🔹 STEP 8: The Migration & Cleansing Logic (ETL)
INSERT INTO products_clean
SELECT product_id, product_name, price
FROM products_bad
WHERE product_id IS NOT NULL 
  AND product_name IS NOT NULL 
  AND price > 0;

-- (Repeter nfs l-logic l Customers o Sales)
COMMIT;

-- 🔹 STEP 9: Disaster Recovery Configuration
-- Switch to Root to enable Archivelog if needed
ALTER SESSION SET CONTAINER = CDB$ROOT;
ARCHIVE LOG LIST;

-- 🔹 STEP 10: RMAN Backup Strategy (Simulation)
-- EXIT;
-- rman target /
-- BACKUP DATABASE PLUS ARCHIVELOG;
