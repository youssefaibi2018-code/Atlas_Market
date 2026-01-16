# 🛒 Atlas Market: Data Quality & CSV Migration Project

## 📖 Scenario
Atlas Market had a major issue with corrupted legacy data stored in **CSV files**. Many records contained NULL names, missing prices, or negative values. 

As a **Junior Oracle DBA**, I was tasked to:
1. Migrate data from raw CSV format into an Oracle 19c Multitenant environment.
2. Cleanse the data during the migration process to ensure 100% data integrity.

## 🛠️ Technical Workflow
- **Data Ingestion:** Processed raw data from CSV files and loaded it into "Staging Tables" (Products_Bad, Customers_Bad, Sales_Bad).
- **Infrastructure:** Created a dedicated PDB `pdb_data_quality` and separated storage into 4 custom tablespaces (`ts_products`, `ts_customers`, `ts_sales`, `ts_backup`) to optimize I/O.
- **Data Cleansing (ETL):** Used SQL filters to migrate only valid rows into "Clean Tables" while enforcing Primary Keys and CHECK constraints.
- **Disaster Recovery:** Configured `ARCHIVELOG` mode and executed a full database backup using **RMAN**.

## 🏗️ Architecture


## 📂 Key Achievements
- **Storage Optimization:** Organized physical data storage for better performance.
- **Data Integrity:** Eliminated 100% of corrupted records from the legacy system.
- **Security:** Implemented RBAC (Role-Based Access Control) for the application user.
