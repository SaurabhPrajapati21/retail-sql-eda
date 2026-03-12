-- =====================================================
-- DATABASE SELECTION
-- =====================================================

USE retail_project;

SET SQL_SAFE_UPDATES = 0;

-- =====================================================
-- RETAIL SALES DATA CLEANING SCRIPT
-- =====================================================
-- Objective: Convert raw date and time fields into proper
-- SQL DATE and TIME formats for accurate analysis.

-- =====================================================
-- DATA CLEANING: DATE COLUMN CONVERSION
-- Purpose: Convert string-based Date column to proper DATE format
-- =====================================================

-- Step 1: Add temporary column for converted date
ALTER TABLE retail_transactions
ADD COLUMN proper_date DATE;

-- Step 2: Convert existing string dates to DATE format
UPDATE retail_transactions
SET proper_date = STR_TO_DATE(Date, '%d-%m-%Y');

-- Step 3: Remove old Date column
ALTER TABLE retail_transactions
DROP COLUMN Date;

-- Step 4: Rename cleaned column
ALTER TABLE retail_transactions
CHANGE COLUMN proper_date Date DATE;


-- =====================================================
-- DATA CLEANING: TIME COLUMN CONVERSION
-- Purpose: Convert string-based Time column to proper TIME format
-- =====================================================

-- Step 1: Add temporary column for converted time
ALTER TABLE retail_transactions
ADD COLUMN proper_time TIME;

-- Step 2: Convert string time values
UPDATE retail_transactions
SET proper_time = STR_TO_DATE(Time, '%H:%i');

-- Step 3: Verify conversion
SELECT Time, proper_time
FROM retail_transactions
LIMIT 10;

-- Step 4: Remove original Time column
ALTER TABLE retail_transactions
DROP COLUMN Time;

-- Step 5: Rename cleaned column
ALTER TABLE retail_transactions
CHANGE COLUMN proper_time Time TIME;


-- =====================================================
-- FINAL STRUCTURE VERIFICATION
-- =====================================================

DESCRIBE retail_transactions;