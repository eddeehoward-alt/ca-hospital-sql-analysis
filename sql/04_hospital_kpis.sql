/*
Project: California Hospital Revenue Cycle and Claims Denial Analysis
File: 04_hospital_kpis.sql
Purpose: Calculates hospital financial, claims, denial, utilization,
and operational performance indicators.
*/


/*
Core financial KPI's
Produces:
Total billing records
Total billed dollars
Tolal paid dollars
Difference between billed and paid amounts
Average billed amount
Paid amount as a percentage of billed amount
payment-to-billed percentage
*/

SELECT
    COUNT(*) AS billing_records,
    ROUND(SUM(billed_amount), 2) AS total_billed_amount,
    ROUND(SUM(paid_amount), 2) AS total_paid_amount,
    ROUND(SUM(billed_amount - paid_amount), 2) AS total_payment_difference,
    ROUND(AVG(billed_amount), 2) AS average_billed_amount,
    ROUND(AVG(paid_amount), 2) AS average_paid_amount,
    ROUND(
        100.0 * SUM(paid_amount)
        / NULLIF(SUM(billed_amount), 0),
        2
    ) AS payment_to_billed_percentage
FROM claims_and_billing;

/*
Claim status KPI's
Measures the number and percentage of billing records by claim status.
volume
percentage
billed dollars
paid dollars
*/
SELECT
    claim_status,
    COUNT(*) AS claim_count,
    ROUND(
        100.0 * COUNT(*)
        / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_claims,
    ROUND(SUM(billed_amount), 2) AS billed_amount,
    ROUND(SUM(paid_amount), 2) AS paid_amount
FROM claims_and_billing
GROUP BY claim_status
ORDER BY claim_count DESC;


/*
Denied dollar KPI
Measures the total financial value associated with denied claims.
*/
SELECT
    COUNT(*) AS denial_records,
    ROUND(SUM(denied_amount), 2) AS total_denied_amount,
    ROUND(AVG(denied_amount), 2) AS average_denied_amount,
    ROUND(MIN(denied_amount), 2) AS minimum_denied_amount,
    ROUND(MAX(denied_amount), 2) AS maximum_denied_amount
FROM denials;


/*
Denied-dollar KPI's
Calculates the overall claim-denial rate.

The denominator includes all billing records because every billing
record has a claim status in this dataset.

expected close to be 5,998 denied / 70,000 total claims 8.57%
*/
SELECT
    COUNT(*) AS total_claims,
    COUNT(*) FILTER (
        WHERE claim_status = 'Denied'
    ) AS denied_claims,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE claim_status = 'Denied'
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS denial_rate_percentage
FROM claims_and_billing;

/*
Denied dollars as a percentage of billed dollars
Compares denied dollars with total billed dollars.

This indicates the share of billed value associated with denials,
not the final amount permanently lost.
*/
SELECT
    ROUND(SUM(d.denied_amount), 2) AS total_denied_amount,
    ROUND(SUM(b.billed_amount), 2) AS total_billed_amount,
    ROUND(
        100.0 * SUM(d.denied_amount)
        / NULLIF(SUM(b.billed_amount), 0),
        2
    ) AS denied_dollars_percentage
FROM denials d
JOIN claims_and_billing b
    ON d.claim_id = b.claim_id;

/*
Compares denied dollars with total billed dollars across all billing
records.
*/
SELECT
    ROUND(
        (SELECT SUM(denied_amount) FROM denials),
        2
    ) AS total_denied_amount,

    ROUND(
        (SELECT SUM(billed_amount) FROM claims_and_billing),
        2
    ) AS total_billed_amount,

    ROUND(
        100.0
        * (SELECT SUM(denied_amount) FROM denials)
        / NULLIF(
            (SELECT SUM(billed_amount) FROM claims_and_billing),
            0
        ),
        2
    ) AS denied_dollars_as_percentage_of_total_billing;

/*
Appeal KPI's
Calculates appeal filing, approval, denial, and pending rates.
*/
SELECT
    COUNT(*) AS total_denials,

    COUNT(*) FILTER (
        WHERE appeal_filed = 'Yes'
    ) AS appeals_filed,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE appeal_filed = 'Yes'
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS appeal_filing_rate,

    COUNT(*) FILTER (
        WHERE appeal_status = 'Approved'
    ) AS approved_appeals,

    COUNT(*) FILTER (
        WHERE appeal_status = 'Denied'
    ) AS denied_appeals,

    COUNT(*) FILTER (
        WHERE appeal_status = 'Pending'
    ) AS pending_appeals
FROM denials;

/*
Appeal approval rate

Calculates the approval rate among appeals with a final decision.

Pending appeals are excluded because they have not yet been resolved.
*/
SELECT
    COUNT(*) FILTER (
        WHERE appeal_status IN ('Approved', 'Denied')
    ) AS resolved_appeals,

    COUNT(*) FILTER (
        WHERE appeal_status = 'Approved'
    ) AS approved_appeals,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE appeal_status = 'Approved'
        )
        / NULLIF(
            COUNT(*) FILTER (
                WHERE appeal_status IN ('Approved', 'Denied')
            ),
            0
        ),
        2
    ) AS appeal_approval_rate
FROM denials;

/*
Recovered, pending, and written-off dollars
Summarizes denied dollars by final outcome.

Paid is treated as recovered.
Written off represents unresolved financial loss.
Reprocessed represents claims still moving through the workflow.
*/
SELECT
    COALESCE(final_outcome, 'No Appeal') AS final_outcome,
    COUNT(*) AS denial_count,
    ROUND(SUM(denied_amount), 2) AS denied_amount,
    ROUND(
        100.0 * SUM(denied_amount)
        / SUM(SUM(denied_amount)) OVER (),
        2
    ) AS percentage_of_denied_dollars
FROM denials
GROUP BY COALESCE(final_outcome, 'No Appeal')
ORDER BY denied_amount DESC;

/*
Average appeal-resolution time
Calculates the average number of days between denial and appeal
resolution for resolved appeals.
*/
SELECT
    COUNT(*) AS resolved_appeals,
    ROUND(
        AVG(appeal_resolution_date - denial_date),
        2
    ) AS average_resolution_days,
    MIN(appeal_resolution_date - denial_date) AS minimum_resolution_days,
    MAX(appeal_resolution_date - denial_date) AS maximum_resolution_days
FROM denials
WHERE appeal_resolution_date IS NOT NULL;