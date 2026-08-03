# Data Dictionary

This document describes the tables, columns, keys, and relationships
in the CA Hospital Dataset – Q1 2025.

## Table Summary

| Table | Purpose | Primary Key | Important Foreign Keys |
|---|---|---|---|
| providers | Stores provider identity, department, specialty, experience, and contact information | provider_id | None identified |
| patients | Stores patient demographic, insurance, contact, and registration information | patient_id | None identified |
| encounters | Stores hospital visits, admission details, diagnoses, discharge information, and readmission status | encounter_id | patient_id → patients.patient_id; provider_id → providers.provider_id |
| diagnoses | Stores diagnoses associated with individual hospital encounters | diagnosis_id | encounter_id → encounters.encounter_id |
| procedures | Stores procedures performed during hospital encounters, including provider and cost information | procedure_id | encounter_id → encounters.encounter_id; provider_id → providers.provider_id |
| medications | Stores medications prescribed during hospital encounters, including dosage, route, duration, prescriber, and cost | medication_id | encounter_id → encounters.encounter_id; prescriber_id → providers.provider_id |
| lab_tests | Stores laboratory tests and results associated with hospital encounters | lab_id | encounter_id → encounters.encounter_id |
| claims_and_billing | Stores insurance claims, billed amounts, payments, claim status, and billing information | billing_id | patient_id → patients.patient_id; encounter_id → encounters.encounter_id |
| denials | Stores claim denial reasons, denied amounts, appeals, and final outcomes | denial_id | claim_id → claims_and_billing.claim_id |

## providers

## providers

| Column | Data Type | Description | Key |
|---|---|---|---|
| provider_id | VARCHAR(8) | Unique identifier assigned to each provider | Primary key |
| name | VARCHAR | Provider's full name |  |
| department | VARCHAR | Hospital department where the provider works |  |
| specialty | VARCHAR | Provider's clinical specialty |  |
| npi | VARCHAR(10) | National Provider Identifier | Candidate unique field |
| inhouse | VARCHAR(3) | Indicates whether the provider is employed directly by the hospital |  |
| location | CHAR(2) | Provider's assigned state or location code |  |
| years_experience | INTEGER | Number of years of professional experience |  |
| contact_info | VARCHAR | Provider contact phone number |  |
| email | VARCHAR | Provider email address | Candidate unique field |


## patients

| Column | Data Type | Description | Key |
|---|---|---|---|
| patient_id | VARCHAR(9) | Unique identifier assigned to each patient | Primary key |
| first_name | VARCHAR | Patient's first name |  |
| last_name | VARCHAR | Patient's last name |  |
| dob | DATE | Patient's date of birth, stored in day-month-year format |  |
| age | INTEGER | Patient's age in years |  |
| gender | VARCHAR | Patient's recorded gender |  |
| ethnicity | VARCHAR | Patient's recorded ethnicity |  |
| insurance_type | VARCHAR | Patient's insurance coverage category |  |
| marital_status | VARCHAR | Patient's marital status |  |
| address | VARCHAR | Patient's street address |  |
| city | VARCHAR | Patient's city of residence |  |
| state | CHAR(2) | Patient's two-letter state code |  |
| zip | VARCHAR(5) | Patient's ZIP code |  |
| phone | VARCHAR | Patient's phone number |  |
| email | VARCHAR | Patient's email address | Candidate unique field |
| registration_date | DATE | Date the patient was registered, stored in day-month-year format |  |

## encounters

| Column | Data Type | Description | Key |
|---|---|---|---|
| encounter_id | VARCHAR(9) | Unique identifier assigned to each hospital encounter | Primary key |
| patient_id | VARCHAR(9) | Identifier for the patient associated with the encounter | Foreign key to patients.patient_id |
| provider_id | VARCHAR(8) | Identifier for the provider responsible for the encounter | Foreign key to providers.provider_id |
| visit_date | DATE | Date when the encounter began, stored in day-month-year format |  |
| visit_type | VARCHAR | Type of visit, such as outpatient, inpatient, telehealth, or emergency |  |
| department | VARCHAR | Hospital department associated with the encounter |  |
| reason_for_visit | VARCHAR | Primary reason the patient sought care |  |
| diagnosis_code | VARCHAR | Diagnosis code recorded for the encounter |  |
| admission_type | VARCHAR | Classification of the admission, such as emergency or elective |  |
| discharge_date | DATE | Date when the patient was discharged, stored in day-month-year format |  |
| length_of_stay | INTEGER | Number of days associated with the admission |  |
| status | VARCHAR | Current or final status of the encounter |  |
| readmitted_flag | VARCHAR(3) | Indicates whether the patient was readmitted, stored as Yes or No |  |

## diagnoses

| Column | Data Type | Description | Key |
|---|---|---|---|
| diagnosis_id | VARCHAR(7) | Identifier representing the diagnosis record or diagnosis category | Part of candidate composite key |
| encounter_id | VARCHAR(9) | Identifier for the encounter associated with the diagnosis | Foreign key to encounters.encounter_id; part of candidate composite key |
| diagnosis_code | VARCHAR | Clinical diagnosis code, such as an ICD-10 code |  |
| diagnosis_description | VARCHAR | Text description of the diagnosis |  |
| primary_flag | BOOLEAN | Indicates whether the diagnosis is the primary diagnosis for the encounter |  |
| chronic_flag | BOOLEAN | Indicates whether the diagnosis is considered chronic |  |

## procedures

| Column | Data Type | Description | Key |
|---|---|---|---|
| procedure_id | VARCHAR(9) | Identifier representing a procedure type or procedure record | Part of candidate composite key |
| encounter_id | VARCHAR(9) | Identifier for the encounter associated with the procedure | Foreign key to encounters.encounter_id; part of candidate composite key |
| procedure_code | VARCHAR | Clinical or billing code assigned to the procedure |  |
| procedure_description | VARCHAR | Text description of the procedure performed |  |
| procedure_date | DATE | Date when the procedure was performed, stored in day-month-year format |  |
| provider_id | VARCHAR(8) | Identifier for the provider who performed or documented the procedure | Foreign key to providers.provider_id |
| procedure_cost | NUMERIC(10,2) | Cost associated with the procedure |  |

## medications

| Column | Data Type | Description | Key |
|---|---|---|---|
| medication_id | VARCHAR(8) | Identifier representing a medication order group or medication record | Part of candidate composite key |
| encounter_id | VARCHAR(9) | Identifier for the encounter associated with the medication | Foreign key to encounters.encounter_id; part of candidate composite key |
| drug_name | VARCHAR | Name of the prescribed medication | Part of candidate composite key |
| dosage | VARCHAR | Prescribed medication strength or dose |  |
| route | VARCHAR | Method used to administer the medication |  |
| frequency | VARCHAR | How often the medication should be administered |  |
| duration | VARCHAR | Prescribed length of medication therapy |  |
| prescribed_date | DATE | Date when the medication was prescribed, stored in day-month-year format |  |
| prescriber_id | VARCHAR(8) | Identifier for the provider who prescribed the medication | Foreign key to providers.provider_id |
| cost | NUMERIC(10,2) | Cost associated with the medication |  |

## lab_tests

| Column | Data Type | Description | Key |
|---|---|---|---|
| lab_id | VARCHAR(6) | Identifier representing a laboratory test type or test record | Part of candidate composite key |
| encounter_id | VARCHAR(9) | Identifier for the encounter associated with the laboratory test | Foreign key to encounters.encounter_id; part of candidate composite key |
| test_name | VARCHAR | Name of the laboratory test or diagnostic study performed |  |
| test_code | VARCHAR(7) | Code assigned to the laboratory test |  |
| specimen_type | VARCHAR | Type of specimen or test medium, such as blood, imaging, or unknown |  |
| test_result | VARCHAR | Recorded result or interpretation of the test |  |
| units | VARCHAR | Unit of measurement associated with the result |  |
| normal_range | VARCHAR | Reference range used to interpret the test result |  |
| test_date | DATE | Date when the test was performed, stored in day-month-year format |  |
| status | VARCHAR | Processing or completion status of the test |  |

## claims_and_billing

| Column | Data Type | Description | Key |
|---|---|---|---|
| billing_id | VARCHAR(10) | Unique identifier assigned to each billing record | Primary key |
| patient_id | VARCHAR(9) | Identifier for the patient associated with the billing record | Foreign key to patients.patient_id |
| encounter_id | VARCHAR(9) | Identifier for the encounter associated with the claim or payment | Foreign key to encounters.encounter_id |
| insurance_provider | VARCHAR | Insurance company or payer associated with the billing record |  |
| payment_method | VARCHAR | Method used to pay the claim or patient balance |  |
| claim_id | VARCHAR(9) | Identifier assigned to an insurance claim when applicable | Candidate unique field; may be null |
| claim_billing_date | TIMESTAMP | Date and time when the claim was billed, submitted, or recorded |  |
| billed_amount | NUMERIC(12,2) | Total amount billed for the encounter or claim |  |
| paid_amount | NUMERIC(12,2) | Amount paid toward the billed balance |  |
| claim_status | VARCHAR | Current or final status of the claim or billing record |  |
| denial_reason | VARCHAR | Reason the claim was denied, when applicable |  |

## denials

| Column | Data Type | Description | Key |
|---|---|---|---|
| claim_id | VARCHAR(9) | Identifier for the claim associated with the denial | Foreign key to claims_and_billing.claim_id |
| denial_id | VARCHAR(8) | Unique identifier assigned to each denial record | Primary key |
| denial_reason_code | VARCHAR | Standardized code assigned to the denial reason |  |
| denial_reason_description | VARCHAR | Text description of the denial reason |  |
| denied_amount | NUMERIC(12,2) | Dollar amount associated with the denied claim |  |
| denial_date | DATE | Date when the denial was recorded, stored in day-month-year format |  |
| appeal_filed | VARCHAR(3) | Indicates whether an appeal was filed, stored as Yes or No |  |
| appeal_status | VARCHAR | Current or final status of the appeal |  |
| appeal_resolution_date | DATE | Date when the appeal was resolved, stored in day-month-year format |  |
| final_outcome | VARCHAR | Final financial or administrative outcome of the denial |  |