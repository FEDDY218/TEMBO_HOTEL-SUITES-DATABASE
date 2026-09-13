# Tembo Hotel Suites — SQL Data Analysis Project

## Project Overview

This project focuses on cleaning, transforming, modelling, and analysing hotel booking data for Tembo Hotel Suites using PostgreSQL.

The dataset initially contained inconsistent formats, missing values, inconsistent casing, and different representations of dates, phone numbers, room types, payment methods, and monetary values.

## Project Objectives

- Clean and standardize the raw hotel data
- Design a structured relational database
- Transform the cleaned data into appropriate data types
- Analyse hotel revenue, occupancy, guests, staff performance, trends, and cancellations
- Generate business insights that can support hotel management decisions

## Database Structure

The project uses the following schemas:

- `staging` — stores the original dirty data
- `hotel` — stores guests, rooms, and bookings
- `finance` — stores payment information
- `staffs` — stores staff information
- `services` — stores hotel services

## SQL Project Sections

1. `01_database_and_staging_setup.sql` — Database, schemas, and staging table setup
2. `02_data_cleaning.sql` — Data quality checks and cleaning
3. `03_database_design.sql` — Relational database design, primary keys, and foreign keys
4. `04_loading_clean_data.sql` — Loading cleaned data into the structured tables
5. `05_business_analysis.sql` — Business analysis queries and performance analysis

## Business Analysis

The analysis covers:

- Monthly revenue
- Room type performance
- Payment methods
- Occupancy and bookings
- Guest locations
- Guest ratings
- Staff performance
- Department revenue
- Monthly revenue trends
- Cancellations

## Tools Used

- PostgreSQL
- DBeaver
- SQL
- GitHub

## Project Outcome

The project transforms raw hotel booking data into a structured relational database and uses SQL analysis to identify patterns and insights that can help Tembo Hotel Suites make better operational and business decisions.
