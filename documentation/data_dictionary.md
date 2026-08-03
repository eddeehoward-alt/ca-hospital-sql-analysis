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

| Column | Likely Data Type | Description | Key |
|---|---|---|---|
| provider_id | VARCHAR | Unique identifier assigned to each provider | Primary key |
| name | VARCHAR | Provider’s full name |  |
| department | VARCHAR | Hospital department where the provider works |  |
| specialty | VARCHAR | Provider’s clinical specialty |  |
| npi | VARCHAR | National Provider Identifier | Candidate unique field |
| inhouse | BOOLEAN or VARCHAR | Indicates whether the provider is employed directly by the hospital |  |
| location | VARCHAR | Provider’s assigned hospital or facility location |  |
| years_experience | INTEGER | Number of years of professional experience |  |
| contact_info | VARCHAR | Provider contact information, likely a phone number |  |
| email | VARCHAR | Provider email address | Candidate unique field |


## patients

| Column | Likely Data Type | Description | Key |
|---|---|---|---|
| patient_id | VARCHAR | Unique identifier assigned to each patient | Primary key |
| first_name | VARCHAR | Patient's first name |  |
| last_name | VARCHAR | Patient's last name |  |
| dob | DATE | Patient's date of birth |  |
| age | INTEGER | Patient's age in years |  |
| gender | VARCHAR | Patient's recorded gender |  |
| ethnicity | VARCHAR | Patient's recorded ethnicity |  |
| insurance_type | VARCHAR | Patient's insurance coverage category |  |
| marital_status | VARCHAR | Patient's marital status |  |
| address | VARCHAR | Patient's street address |  |
| city | VARCHAR | Patient's city of residence |  |
| state | CHAR(2) or VARCHAR | Patient's state of residence |  |
| zip | VARCHAR | Patient's ZIP code |  |
| phone | VARCHAR | Patient's phone number |  |
| email | VARCHAR | Patient's email address | Candidate unique field |
| registration_date | DATE | Date the patient was registered in the hospital system |  |

## encounters

| Column | Likely Data Type | Description | Key |
|---|---|---|---|
| encounter_id | VARCHAR | Unique identifier assigned to each hospital encounter | Primary key |
| patient_id | VARCHAR | Identifier for the patient associated with the encounter | Foreign key to patients.patient_id |
| provider_id | VARCHAR | Identifier for the provider responsible for the encounter | Foreign key to providers.provider_id |
| visit_date | DATE or TIMESTAMP | Date or date-time when the encounter began |  |
| visit_type | VARCHAR | Type of visit, such as inpatient, outpatient, or emergency |  |
| department | VARCHAR | Hospital department associated with the encounter |  |
| reason_for_visit | VARCHAR | Primary reason the patient sought care |  |
| diagnosis_code | VARCHAR | Diagnosis code recorded for the encounter |  |
| admission_type | VARCHAR | Classification of the admission, such as emergency or elective |  |
| discharge_date | DATE or TIMESTAMP | Date or date-time when the patient was discharged |  |
| length_of_stay | INTEGER or NUMERIC | Length of the encounter or admission |  |
| status | VARCHAR | Current or final status of the encounter |  |
| readmitted_flag | BOOLEAN or VARCHAR | Indicates whether the patient was readmitted |  |

## diagnoses

| Column | Likely Data Type | Description | Key |
|---|---|---|---|
| diagnosis_id | VARCHAR | Unique identifier assigned to each diagnosis record | Primary key |
| encounter_id | VARCHAR | Identifier for the encounter associated with the diagnosis | Foreign key to encounters.encounter_id |
| diagnosis_code | VARCHAR | Clinical diagnosis code, such as an ICD code |  |
| diagnosis_description | VARCHAR | Text description of the diagnosis |  |
| primary_flag | BOOLEAN or VARCHAR | Indicates whether this was the primary diagnosis for the encounter |  |
| chronic_flag | BOOLEAN or VARCHAR | Indicates whether the diagnosis is considered chronic |  |

## procedures

| Column | Likely Data Type | Description | Key |
|---|---|---|---|
| procedure_id | VARCHAR | Unique identifier assigned to each procedure record | Primary key |
| encounter_id | VARCHAR | Identifier for the encounter associated with the procedure | Foreign key to encounters.encounter_id |
| procedure_code | VARCHAR | Clinical or billing code assigned to the procedure |  |
| procedure_description | VARCHAR | Text description of the procedure performed |  |
| procedure_date | DATE or TIMESTAMP | Date or date-time when the procedure was performed |  |
| provider_id | VARCHAR | Identifier for the provider who performed or ordered the procedure | Foreign key to providers.provider_id |
| procedure_cost | NUMERIC or DECIMAL | Cost associated with the procedure |  |

## medications

| Column | Likely Data Type | Description | Key |
|---|---|---|---|
| medication_id | VARCHAR | Unique identifier assigned to each medication record | Primary key |
| encounter_id | VARCHAR | Identifier for the encounter associated with the medication | Foreign key to encounters.encounter_id |
| drug_name | VARCHAR | Name of the prescribed medication |  |
| dosage | VARCHAR | Prescribed medication strength or dose |  |
| route | VARCHAR | Method used to administer the medication, such as oral or intravenous |  |
| frequency | VARCHAR | How often the medication should be administered |  |
| duration | VARCHAR or INTEGER | Prescribed length of medication therapy |  |
| prescribed_date | DATE or TIMESTAMP | Date or date-time when the medication was prescribed |  |
| prescriber_id | VARCHAR | Identifier for the provider who prescribed the medication | Foreign key to providers.provider_id |
| cost | NUMERIC or DECIMAL | Cost associated with the medication |  |

## lab_tests

| Column | Likely Data Type | Description | Key |
|---|---|---|---|
| lab_id | VARCHAR | Unique identifier assigned to each laboratory test record | Primary key |
| encounter_id | VARCHAR | Identifier for the encounter associated with the laboratory test | Foreign key to encounters.encounter_id |
| test_name | VARCHAR | Name of the laboratory test performed |  |
| test_code | VARCHAR | Code assigned to the laboratory test |  |
| specimen_type | VARCHAR | Type of specimen collected, such as blood or urine |  |
| test_result | VARCHAR or NUMERIC | Recorded laboratory test result |  |
| units | VARCHAR | Unit of measurement associated with the test result |  |
| normal_range | VARCHAR | Reference range used to interpret the test result |  |
| test_date | DATE or TIMESTAMP | Date or date-time when the laboratory test was performed |  |
| status | VARCHAR | Processing or completion status of the laboratory test |  |

## claims_and_billing

| Column | Likely Data Type | Description | Key |
|---|---|---|---|
| billing_id | VARCHAR | Unique identifier assigned to each billing record | Primary key |
| patient_id | VARCHAR | Identifier for the patient associated with the billing record | Foreign key to patients.patient_id |
| encounter_id | VARCHAR | Identifier for the encounter associated with the claim | Foreign key to encounters.encounter_id |
| insurance_provider | VARCHAR | Insurance company or payer responsible for the claim |  |
| payment_method | VARCHAR | Method used to pay the claim or balance |  |
| claim_id | VARCHAR | Unique identifier assigned to the insurance claim | Candidate unique field |
| claim_billing_date | DATE or TIMESTAMP | Date or date-time when the claim was billed or submitted |  |
| billed_amount | NUMERIC or DECIMAL | Total amount billed for the claim |  |
| paid_amount | NUMERIC or DECIMAL | Amount paid toward the claim |  |
| claim_status | VARCHAR | Current or final status of the claim |  |
| denial_reason | VARCHAR | Reason the claim was denied, when applicable |  |

## denials

| Column | Likely Data Type | Description | Key |
|---|---|---|---|
| claim_id | VARCHAR | Identifier for the claim associated with the denial | Foreign key to claims_and_billing.claim_id |
| denial_id | VARCHAR | Unique identifier assigned to each denial record | Primary key |
| denial_reason_code | VARCHAR | Code assigned to the reason for the claim denial |  |
| denial_reason_description | VARCHAR | Text description of the denial reason |  |
| denied_amount | NUMERIC or DECIMAL | Dollar amount associated with the denied claim |  |
| denial_date | DATE or TIMESTAMP | Date or date-time when the denial was recorded |  |
| appeal_filed | BOOLEAN or VARCHAR | Indicates whether an appeal was filed |  |
| appeal_status | VARCHAR | Current or final status of the appeal |  |
| appeal_resolution_date | DATE or TIMESTAMP | Date or date-time when the appeal was resolved |  |
| final_outcome | VARCHAR | Final result of the denial or appeal process |  |