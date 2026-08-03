# Data Quality Report

## Overview

This report documents the validation of the CA Hospital Dataset before
performing operational, financial, and claims-denial analysis.

The validation process examined:

- Table row counts
- Primary-key uniqueness
- Source identifier duplication
- Candidate composite keys
- Missing identifiers
- Foreign-key relationships
- Date consistency
- Financial values
- Categorical field consistency

## Row Counts

| Table | Row Count |
|---|---:|
| providers | 1,491 |
| patients | 60,000 |
| encounters | 70,000 |
| diagnoses | 70,000 |
| procedures | 126,021 |
| medications | 94,498 |
| lab_tests | 54,537 |
| claims_and_billing | 70,000 |
| denials | 5,998 |

The database contains 477,545 total records across the nine source
tables.

## Primary-Key Validation

| Table | Total Rows | Unique Key Values | Result |
|---|---:|---:|---|
| providers | 1,491 | 1,491 | Passed |
| patients | 60,000 | 60,000 | Passed |
| encounters | 70,000 | 70,000 | Passed |
| claims_and_billing | 70,000 | 70,000 | Passed |
| denials | 5,998 | 5,998 | Passed |

All designated primary-key fields were complete and unique.

## Source Identifier Duplication

The source identifiers in the diagnoses, procedures, medications, and
laboratory tables are not unique row identifiers.

Repeated values were found in:

- `diagnosis_id`
- `procedure_id`
- `medication_id`
- `lab_id`

These repetitions are expected because the identifiers appear to
represent diagnosis categories, procedure types, medication-order
groups, or laboratory-test types rather than unique database rows.

Generated PostgreSQL row identifiers were therefore used as the primary
keys for these tables.

### Most Frequent Diagnosis IDs

| Diagnosis ID | Occurrences |
|---|---:|
| DIA0050 | 5,483 |
| DIA0042 | 5,455 |
| DIA0041 | 5,427 |
| DIA0043 | 3,201 |
| DIA0039 | 3,061 |
| DIA0062 | 2,980 |

### Most Frequent Procedure IDs

| Procedure ID | Occurrences |
|---|---:|
| PROC00012 | 9,975 |
| PROC00017 | 8,429 |
| PROC00004 | 6,573 |
| PROC00008 | 4,190 |
| PROC00010 | 3,538 |

### Medication Identifier Pattern

Several medication identifiers occurred four times. Review of the
source records showed that one medication order identifier may contain
multiple individual drugs.

This supports using a generated row-level primary key rather than
treating `medication_id` as unique.

## Relationship Validation

All foreign-key relationship checks returned zero unmatched records.

Validated relationships included:

- Encounters to patients
- Encounters to providers
- Diagnoses to encounters
- Procedures to encounters
- Procedures to providers
- Medications to encounters
- Medications to prescribers
- Laboratory tests to encounters
- Billing records to patients
- Billing records to encounters
- Denials to claims

Result: **Passed**

## Date Validation

| Validation Check | Result |
|---|---:|
| Discharge dates before visit dates | 0 |
| Negative lengths of stay | 0 |
| Length-of-stay calculation mismatches | 0 |
| Appeal resolutions before denial dates | 0 |

### Date Ranges

| Activity | Earliest Date | Latest Date |
|---|---|---|
| Hospital encounters | 2025-01-01 | 2025-03-31 |
| Claim billing | 2025-01-16 | 2025-05-10 |
| Claim denials | 2025-02-01 | 2025-06-06 |

The encounter data is limited to Q1 2025. Billing and denial activity
extends beyond March because claim processing continued after the dates
of service.

## Financial Validation

All tested financial fields passed validation.

| Validation Check | Invalid Records |
|---|---:|
| Negative billed amounts | 0 |
| Negative paid amounts | 0 |
| Paid amount greater than billed amount | 0 |
| Negative denied amounts | 0 |
| Denied amount greater than billed amount | 0 |

Result: **Passed**

## Category Validation

### Encounter Types

| Visit Type | Encounter Count |
|---|---:|
| Outpatient | 28,176 |
| Inpatients | 24,345 |
| Emergency | 13,998 |
| Telehealth | 3,481 |

The value `Inpatients` is grammatically inconsistent with the other
singular visit-type labels. It may be standardized to `Inpatient` in an
analysis view while preserving the original source value in the raw
table.

### Claim Status

| Claim Status | Claim Count |
|---|---:|
| Paid | 64,002 |
| Denied | 5,998 |

### Appeal Filing Status

| Appeal Filed | Denial Count |
|---|---:|
| Yes | 5,396 |
| No | 602 |

### Appeal Status

| Appeal Status | Denial Count |
|---|---:|
| Approved | 4,319 |
| Denied | 544 |
| Pending | 533 |
| Blank | 602 |

## Candidate Composite-Key Validation

| Table | Candidate Key | Duplicate Combinations | Result |
|---|---|---:|---|
| diagnoses | diagnosis_id + encounter_id | 0 | Passed |
| procedures | procedure_id + encounter_id | 0 | Passed |
| medications | medication_id + encounter_id + drug_name | 0 | Passed |

The proposed combination of `lab_id` and `encounter_id` was not unique.
The validation query returned 2,972 duplicated combinations.

This indicates that the same type of laboratory test may occur more than
once during a single encounter. PostgreSQL's generated `lab_row_id` is
therefore retained as the table's primary key.

### Laboratory-Test Key Review

The proposed combination of `lab_id` and `encounter_id` was not unique,
with 2,972 repeated combinations.

A broader duplicate check using `lab_id`, `encounter_id`, `test_name`,
`test_code`, `test_date`, and `status` returned no duplicate rows.

This indicates that the repeated source identifiers represent distinct
laboratory records rather than exact duplicate data. The generated
`lab_row_id` remains the appropriate primary key.

### Final Outcome

| Final Outcome | Denial Count |
|---|---:|
| Paid | 4,319 |
| Written off | 544 |
| Reprocessed | 533 |
| Blank | 602 |

The 602 blank appeal statuses and final outcomes correspond to denials
where no appeal was filed. These blanks are therefore structurally
expected rather than missing-data errors.

## Identified Data Considerations

1. Source IDs in the diagnoses, procedures, medications, and lab-tests
   tables are not unique row identifiers.
2. The visit type `Inpatients` should be standardized to `Inpatient`
   in reporting views.
3. Billing and denial dates extend beyond Q1 because revenue-cycle
   activity continued after the encounter period.
4. Blank appeal fields are expected when no appeal was filed.
5. Personally identifiable fields such as names, addresses, phone
   numbers, and emails should not be displayed in public dashboards.
6. The data is synthetic and should not be presented as actual hospital
   performance data.

## Overall Assessment

The dataset passed the primary-key, relationship, date, and financial
validation checks. It is suitable for exploratory analysis and
portfolio development after minor categorical standardization.