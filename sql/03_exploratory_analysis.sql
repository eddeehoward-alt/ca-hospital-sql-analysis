/*
Project: California Hospital Revenue Cycle and Claims Denial Analysis
File: 03_exploratory_analysis.sql
Purpose: Explores hospital volume, patient characteristics,
department activity, encounter trends, and service utilization.
*/

/*
How many patients received care?
How many encounters occurred?
How many providers treated patients?
How many departments were active?
*/

SELECT
    COUNT(DISTINCT patient_id) AS patients_with_encounters,
    COUNT(*) AS total_encounters,
    COUNT(DISTINCT provider_id) AS active_providers,
    COUNT(DISTINCT department) AS active_departments
FROM encounters;

/*
Encounters by visit type
Introduces CASE
COUNT
GROUP BY
A window function
Percentage Calcs
by standardizing Inpatients in the query without altering original data
*/

SELECT
    CASE
        WHEN visit_type = 'Inpatients' THEN 'Inpatient'
        ELSE visit_type
    END AS visit_type,
    COUNT(*) AS encounter_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_encounters
FROM encounters
GROUP BY
    CASE
        WHEN visit_type = 'Inpatients' THEN 'Inpatient'
        ELSE visit_type
    END
ORDER BY encounter_count DESC;

/* 
Encounter volume by department
comparing volume, patients, and provider coverage
*/

SELECT
    department,
    COUNT(*) AS encounter_count,
    COUNT(DISTINCT patient_id) AS unique_patients,
    COUNT(DISTINCT provider_id) AS active_providers
FROM encounters
GROUP BY department
ORDER BY encounter_count DESC;

SELECT
    department,
    COUNT(DISTINCT provider_id) AS providers_in_provider_table
FROM providers
GROUP BY department
ORDER BY department;

SELECT
    e.department AS encounter_department,
    p.department AS provider_department,
    COUNT(*) AS encounter_count
FROM encounters e
JOIN providers p
    ON e.provider_id = p.provider_id
WHERE e.department <> p.department
GROUP BY
    e.department,
    p.department
ORDER BY encounter_count DESC
LIMIT 20;

/*
Average encounters per provider
Useful activity indicator, but not true workload measure because encounter complexity differs
*/

SELECT
    department,
    COUNT(*) AS encounter_count,
    COUNT(DISTINCT provider_id) AS active_providers,
    ROUND(
        COUNT(*)::NUMERIC
        / NULLIF(COUNT(DISTINCT provider_id), 0),
        2
    ) AS encounters_per_provider
FROM encounters 
GROUP BY department
ORDER BY encounters_per_provider DESC;
/*
daily encounter trend
*/

SELECT
    visit_date,
    COUNT(*) AS encounter_count
FROM encounters
GROUP BY visit_date
ORDER BY visit_date;

/*
Busiest and slowest days
*/

SELECT
    visit_date,
    COUNT(*) AS encounter_count
FROM encounters
GROUP BY visit_date
ORDER BY encounter_count DESC
LIMIT 10;

SELECT
    visit_date,
    COUNT(*) AS encounter_count
FROM encounters
GROUP BY visit_date
ORDER BY encounter_count ASC
LIMIT 10;

/* 
Compare each day with the overall daily average
*/
SELECT
    visit_date,
    COUNT(*) AS encounter_count,
    ROUND(AVG(COUNT(*)) OVER (), 2) AS average_daily_volume,
    ROUND(
        COUNT(*) - AVG(COUNT(*)) OVER (),
        2
    ) AS difference_from_average
FROM encounters
GROUP BY visit_date
ORDER BY encounter_count;

/*
 Calculating average without march 31
 */
SELECT
    ROUND(AVG(daily_encounters), 2) AS average_daily_volume_excluding_outlier
FROM (
    SELECT
        visit_date,
        COUNT(*) AS daily_encounters
    FROM encounters
    WHERE visit_date < DATE '2025-03-31'
    GROUP BY visit_date
) daily_volume;

/*
Monthly encounter trend
*/

SELECT
    DATE_TRUNC('month', visit_date)::DATE AS month,
    COUNT(*) AS encounter_count,
    COUNT(DISTINCT patient_id) AS unique_patients 
FROM encounters
GROUP BY DATE_TRUNC('month', visit_date)
ORDER BY month;

/*
 March encounter volume excluding the March 31 outlier
 */
SELECT
    COUNT(*) AS march_encounters_excluding_march_31
FROM encounters
WHERE visit_date >= DATE '2025-03-01'
  AND visit_date < DATE '2025-03-31';

/* 
Day of week pattern
*/

SELECT
    EXTRACT(ISODOW FROM visit_date) AS weekday_number,
    TO_CHAR(visit_date, 'Day') AS weekday,
    COUNT(*) AS encounter_count
FROM encounters 
GROUP BY
    EXTRACT(ISODOW FROM visit_date),
    TO_CHAR(visit_date, 'Day')
ORDER BY weekday_number;

/*
Readmission status. Note readmitted_flag, is not yet confirmed whether it means the current encounter
was a readmission or whether the patient was readmitted later.
*/

SELECT
    readmitted_flag,
    COUNT(*) AS encounter_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_encounters
FROM encounters
GROUP BY readmitted_flag
ORDER BY encounter_count DESC;

/*
Length of Stay
*/

SELECT
    COUNT(*) AS encounters_with_length_of_stay,
    ROUND(AVG(length_of_stay), 2) AS average_length_of_stay,
    MIN(length_of_stay) AS minimum_length_of_stay,
    MAX(length_of_stay) AS maximum_length_of_stay
FROM encounters
WHERE length_of_stay IS NOT NULL;

/*
Length of stay by department
*/

SELECT
    department,
    COUNT(*) AS inpatient_encounters,
    ROUND(AVG(length_of_stay), 2) AS average_length_of_stay,
    MAX(length_of_stay) AS maximum_length_of_stay
FROM encounters
WHERE length_of_stay IS NOT NULL
GROUP BY department
ORDER BY average_length_of_stay DESC;

