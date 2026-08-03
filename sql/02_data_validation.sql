/*
Project; CA Hospital Revenue cycle and claims denial analysis
File: 02_data_validation.sql
Purpose: validates row counts, key uniqueness, missing values, foreign-key relationships, dats, and financial fields.
*/

-- =========================================================
-- 1. ROW COUNTS
-- =========================================================

SELECT 'providers' AS table_name, COUNT(*) AS row_count
FROM providers

UNION ALL 

SELECT 'patients', COUNT(*)
FROM patients

UNION ALL

SELECT 'encounters', COUNT(*)
FROM encounters

UNION ALL

SELECT 'diagnoses', COUNT(*)
FROM diagnoses

UNION ALL

SELECT 'procedures', COUNT(*)
FROM procedures

UNION ALL

SELECT 'medications', COUNT(*)
FROM medications

UNION ALL

SELECT 'lab_tests', COUNT(*)
FROM lab_tests

UNION ALL


SELECT 'claims_and_billing', COUNT(*)
FROM claims_and_billing

UNION ALL


SELECT 'denials', COUNT(*)
FROM denials

ORDER BY table_name;

-- =========================================================
-- 2. PRIMARY KEY UNIQUENESS
-- =========================================================

SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT provider_id) AS unique_provider_ids
FROM providers;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT patient_id) AS unique_patient_ids
FROM patients;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT encounter_id) AS unique_encounter_ids
FROM encounters;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT billing_id) AS unique_billing_ids
FROM claims_and_billing;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT denial_id) AS unique_denial_ids
FROM denials;

-- =========================================================
-- 3. SOURCE ID DUPLICATION CHECKS
-- =========================================================

SELECT 
    diagnosis_id,
    COUNT(*) AS occurence_count
FROM diagnosis
GROUP BY diagnosis_id
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC 
LIMIT 20;

SELECT
    procedure_id,
    COUNT(*) AS occurrence_count
FROM procedures
GROUP BY procedure_id
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC
LIMIT 20;

SELECT
    medication_id,
    COUNT(*) AS occurrence_count
FROM medications
GROUP BY medication_id
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC
LIMIT 20;

SELECT
    lab_id,
    COUNT(*) AS occurrence_count
FROM lab_tests
GROUP BY lab_id
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC
LIMIT 20;


-- =========================================================
-- 4. CANDIDATE COMPOSITE KEY CHECKS
-- =========================================================

SELECT
    diagnosis_id,
    encounter_id
    COUNT(*) AS row_count
FROM diagnosis
GROUP BY diagnosis_id, encounter_id
HAVING COUNT(*) > 1;

ELECT
    procedure_id,
    encounter_id,
    COUNT(*) AS row_count
FROM procedures
GROUP BY procedure_id, encounter_id
HAVING COUNT(*) > 1;

SELECT
    medication_id,
    encounter_id,
    drug_name,
    COUNT(*) AS row_count
FROM medications
GROUP BY medication_id, encounter_id, drug_name
HAVING COUNT(*) > 1;

SELECT
    lab_id,
    encounter_id,
    COUNT(*) AS row_count
FROM lab_tests
GROUP BY lab_id, encounter_id
HAVING COUNT(*) > 1;


-- =========================================================
-- 5. MISSING IDENTIFIERS
-- =========================================================

SELECT COUNT(*) AS missing_provider_ids
FROM providers
WHERE provider_id IS NULL;

SELECT COUNT(*) AS missing_patient_ids
FROM patients
WHERE patient_id IS NULL;

SELECT COUNT(*) AS missing_encounter_ids
FROM encounters
WHERE encounter_id IS NULL;

SELECT COUNT(*) AS missing_billing_ids
FROM claims_and_billing
WHERE billing_id IS NULL;

SELECT COUNT(*) AS missing_denial_ids
FROM denials
WHERE denial_id IS NULL;


-- =========================================================
-- 6. FOREIGN-KEY RELATIONSHIP CHECKS
-- =========================================================

SELECT COUNT(*) AS encounters_without_matching_patient
FROM encounters e
LEFT JOIN patients p
    ON e.patient_id = p.patient_id
WHERE p.patient_id IS NULL;

SELECT COUNT(*) AS encounters_without_matching_provider
FROM encounters e
LEFT JOIN providers p
    ON e.provider_id = p.provider_id
WHERE p.provider_id IS NULL;

SELECT COUNT(*) AS diagnoses_without_matching_encounter
FROM diagnoses d
LEFT JOIN encounters e
    ON d.encounter_id = e.encounter_id
WHERE e.encounter_id IS NULL;

SELECT COUNT(*) AS procedures_without_matching_encounter
FROM procedures p
LEFT JOIN encounters e
    ON p.encounter_id = e.encounter_id
WHERE e.encounter_id IS NULL;

SELECT COUNT(*) AS procedures_without_matching_provider
FROM procedures pr
LEFT JOIN providers p
    ON pr.provider_id = p.provider_id
WHERE p.provider_id IS NULL;

SELECT COUNT(*) AS medications_without_matching_encounter
FROM medications m
LEFT JOIN encounters e
    ON m.encounter_id = e.encounter_id
WHERE e.encounter_id IS NULL;

SELECT COUNT(*) AS medications_without_matching_prescriber
FROM medications m
LEFT JOIN providers p
    ON m.prescriber_id = p.provider_id
WHERE p.provider_id IS NULL;

SELECT COUNT(*) AS lab_tests_without_matching_encounter
FROM lab_tests l
LEFT JOIN encounters e
    ON l.encounter_id = e.encounter_id
WHERE e.encounter_id IS NULL;

SELECT COUNT(*) AS billing_without_matching_patient
FROM claims_and_billing b
LEFT JOIN patients p
    ON b.patient_id = p.patient_id
WHERE p.patient_id IS NULL;

SELECT COUNT(*) AS billing_without_matching_encounter
FROM claims_and_billing b
LEFT JOIN encounters e
    ON b.encounter_id = e.encounter_id
WHERE e.encounter_id IS NULL;

SELECT COUNT(*) AS denials_without_matching_claim
FROM denials d
LEFT JOIN claims_and_billing b
    ON d.claim_id = b.claim_id
WHERE b.claim_id IS NULL;


-- =========================================================
-- 7. DATE VALIDATION
-- =========================================================

SELECT COUNT(*) AS discharge_before_visit
FROM encounters
WHERE discharge_date < visit_date;

SELECT COUNT(*) AS negative_length_of_stay
FROM encounters
WHERE length_of_stay < 0;

SELECT COUNT(*) AS incorrect_length_of_stay
FROM encounters
WHERE discharge_date IS NOT NULL
  AND length_of_stay IS NOT NULL
  AND discharge_date - visit_date <> length_of_stay;

SELECT
    MIN(visit_date) AS earliest_visit,
    MAX(visit_date) AS latest_visit
FROM encounters;

SELECT
    MIN(claim_billing_date) AS earliest_billing_date,
    MAX(claim_billing_date) AS latest_billing_date
FROM claims_and_billing;

SELECT
    MIN(denial_date) AS earliest_denial_date,
    MAX(denial_date) AS latest_denial_date
FROM denials;

SELECT COUNT(*) AS appeal_resolution_before_denial
FROM denials
WHERE appeal_resolution_date < denial_date;


-- =========================================================
-- 8. FINANCIAL VALIDATION
-- =========================================================

SELECT COUNT(*) AS negative_billed_amounts
FROM claims_and_billing
WHERE billed_amount < 0;

SELECT COUNT(*) AS negative_paid_amounts
FROM claims_and_billing
WHERE paid_amount < 0;

SELECT COUNT(*) AS paid_greater_than_billed
FROM claims_and_billing
WHERE paid_amount > billed_amount;

SELECT COUNT(*) AS negative_denied_amounts
FROM denials
WHERE denied_amount < 0;

SELECT COUNT(*) AS denied_amount_greater_than_billed
FROM denials d
JOIN claims_and_billing b
    ON d.claim_id = b.claim_id
WHERE d.denied_amount > b.billed_amount;


-- =========================================================
-- 9. CATEGORY INSPECTION
-- =========================================================

SELECT
    visit_type,
    COUNT(*) AS encounter_count
FROM encounters
GROUP BY visit_type
ORDER BY encounter_count DESC;

SELECT
    claim_status,
    COUNT(*) AS claim_count
FROM claims_and_billing
GROUP BY claim_status
ORDER BY claim_count DESC;

SELECT
    appeal_filed,
    COUNT(*) AS denial_count
FROM denials
GROUP BY appeal_filed
ORDER BY denial_count DESC;

SELECT
    appeal_status,
    COUNT(*) AS denial_count
FROM denials
GROUP BY appeal_status
ORDER BY denial_count DESC;

SELECT
    final_outcome,
    COUNT(*) AS denial_count
FROM denials
GROUP BY final_outcome
ORDER BY denial_count DESC;