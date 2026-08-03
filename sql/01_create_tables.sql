/*
Project: California Hospital Revenue Cycle and Claims Denial Analysis
File: 01_create_tables.sql
Purpose: Creates the PostgreSQL tables for the CA Hospital Dataset.

Run this script while connected to the ca_hospital database.
*/

DROP TABLE IF EXISTS denials;
DROP TABLE IF EXISTS claims_and_billing;
DROP TABLE IF EXISTS lab_tests;
DROP TABLE IF EXISTS medications;
DROP TABLE IF EXISTS procedures;
DROP TABLE IF EXISTS diagnoses;
DROP TABLE IF EXISTS encounters;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS providers;

CREATE TABLE providers (
    provider_id VARCHAR(8) PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    department VARCHAR(150),
    specialty VARCHAR(150),
    npi VARCHAR(10),
    inhouse VARCHAR(3),
    location CHAR(2),
    years_experience INTEGER,
    contact_info VARCHAR(50),
    email VARCHAR(255)
);

CREATE TABLE patients (
    patient_id VARCHAR(9) PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    dob DATE,
    age INTEGER,
    gender VARCHAR(50),
    ethnicity VARCHAR(100),
    insurance_type VARCHAR(100),
    marital_status VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(100),
    state CHAR(2),
    zip VARCHAR(10),
    phone VARCHAR(50),
    email VARCHAR(255),
    registration_date DATE
);

CREATE TABLE encounters (
    encounter_id VARCHAR(9) PRIMARY KEY,
    patient_id VARCHAR(9),
    provider_id VARCHAR(8),
    visit_date DATE,
    visit_type VARCHAR(100),
    department VARCHAR(150),
    reason_for_visit VARCHAR(255),
    diagnosis_code VARCHAR(50),
    admission_type VARCHAR(100),
    discharge_date DATE,
    length_of_stay INTEGER,
    status VARCHAR(100),
    readmitted_flag VARCHAR(3),
    CONSTRAINT fk_encounters_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),
    CONSTRAINT fk_encounters_provider
        FOREIGN KEY (provider_id)
        REFERENCES providers(provider_id)
);

CREATE TABLE diagnoses (
    diagnosis_row_id BIGSERIAL PRIMARY KEY,
    diagnosis_id VARCHAR(7),
    encounter_id VARCHAR(9),
    diagnosis_code VARCHAR(50),
    diagnosis_description VARCHAR(500),
    primary_flag BOOLEAN,
    chronic_flag BOOLEAN,
    CONSTRAINT fk_diagnoses_encounter
        FOREIGN KEY (encounter_id)
        REFERENCES encounters(encounter_id)
);

CREATE TABLE procedures (
    procedure_row_id BIGSERIAL PRIMARY KEY,
    procedure_id VARCHAR(9),
    encounter_id VARCHAR(9),
    procedure_code VARCHAR(50),
    procedure_description VARCHAR(500),
    procedure_date DATE,
    provider_id VARCHAR(8),
    procedure_cost NUMERIC(12,2),
    CONSTRAINT fk_procedures_encounter
        FOREIGN KEY (encounter_id)
        REFERENCES encounters(encounter_id),
    CONSTRAINT fk_procedures_provider
        FOREIGN KEY (provider_id)
        REFERENCES providers(provider_id)
);

CREATE TABLE medications (
    medication_row_id BIGSERIAL PRIMARY KEY,
    medication_id VARCHAR(8),
    encounter_id VARCHAR(9),
    drug_name VARCHAR(255),
    dosage VARCHAR(100),
    route VARCHAR(100),
    frequency VARCHAR(100),
    duration VARCHAR(100),
    prescribed_date DATE,
    prescriber_id VARCHAR(8),
    cost NUMERIC(12,2),
    CONSTRAINT fk_medications_encounter
        FOREIGN KEY (encounter_id)
        REFERENCES encounters(encounter_id),
    CONSTRAINT fk_medications_prescriber
        FOREIGN KEY (prescriber_id)
        REFERENCES providers(provider_id)
);

CREATE TABLE lab_tests (
    lab_row_id BIGSERIAL PRIMARY KEY,
    lab_id VARCHAR(6),
    encounter_id VARCHAR(9),
    test_name VARCHAR(500),
    test_code VARCHAR(20),
    specimen_type VARCHAR(100),
    test_result VARCHAR(255),
    units VARCHAR(100),
    normal_range VARCHAR(255),
    test_date DATE,
    status VARCHAR(100),
    CONSTRAINT fk_lab_tests_encounter
        FOREIGN KEY (encounter_id)
        REFERENCES encounters(encounter_id)
);

CREATE TABLE claims_and_billing (
    billing_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(9),
    encounter_id VARCHAR(9),
    insurance_provider VARCHAR(100),
    payment_method VARCHAR(100),
    claim_id VARCHAR(9),
    claim_billing_date TIMESTAMP,
    billed_amount NUMERIC(12,2),
    paid_amount NUMERIC(12,2),
    claim_status VARCHAR(100),
    denial_reason VARCHAR(500),
    CONSTRAINT fk_claims_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),
    CONSTRAINT fk_claims_encounter
        FOREIGN KEY (encounter_id)
        REFERENCES encounters(encounter_id)
);

CREATE TABLE denials (
    denial_id VARCHAR(8) PRIMARY KEY,
    claim_id VARCHAR(9),
    denial_reason_code VARCHAR(50),
    denial_reason_description VARCHAR(500),
    denied_amount NUMERIC(12,2),
    denial_date DATE,
    appeal_filed VARCHAR(3),
    appeal_status VARCHAR(100),
    appeal_resolution_date DATE,
    final_outcome VARCHAR(100)
);

CREATE INDEX idx_encounters_patient_id
    ON encounters(patient_id);

CREATE INDEX idx_encounters_provider_id
    ON encounters(provider_id);

CREATE INDEX idx_diagnoses_encounter_id
    ON diagnoses(encounter_id);

CREATE INDEX idx_procedures_encounter_id
    ON procedures(encounter_id);

CREATE INDEX idx_medications_encounter_id
    ON medications(encounter_id);

CREATE INDEX idx_lab_tests_encounter_id
    ON lab_tests(encounter_id);

CREATE INDEX idx_claims_patient_id
    ON claims_and_billing(patient_id);

CREATE INDEX idx_claims_encounter_id
    ON claims_and_billing(encounter_id);

CREATE INDEX idx_claims_claim_id
    ON claims_and_billing(claim_id);

CREATE INDEX idx_denials_claim_id
    ON denials(claim_id);