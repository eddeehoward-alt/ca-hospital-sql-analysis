## Hospital Activity Snapshot

The dataset contains 70,000 hospital encounters involving 60,000
unique patients, 1,491 active providers, and 21 departments during
Q1 2025.

The difference between patients and encounters indicates that some
patients had more than one encounter during the quarter.

## Encounter Mix

| Visit Type | Encounter Count | Percentage of Encounters |
|---|---:|---:|
| Outpatient | 28,176 | 40.25% |
| Inpatient | 24,345 | 34.78% |
| Emergency | 13,998 | 20.00% |
| Telehealth | 3,481 | 4.97% |

Outpatient visits represented the largest share of activity at 40.25%.
Inpatient encounters accounted for another 34.78%, meaning these two
visit types together represented approximately three-quarters of all
hospital encounters.

Emergency visits accounted for one in five encounters, while
telehealth represented the smallest share at 4.97%.

## Department Activity

| Department | Encounter Count | Unique Patients | Active Providers |
|---|---:|---:|---:|
| Emergency Department | 16,365 | 15,806 | 71 |
| Obstetrics & Gynecology | 9,242 | 8,910 | 71 |
| General Surgery | 2,545 | 2,532 | 71 |
| Radiology / Imaging | 2,428 | 2,417 | 71 |
| Cardiology | 2,426 | 2,414 | 71 |
| Urology | 2,405 | 2,398 | 71 |
| Pulmonology | 2,404 | 2,387 | 71 |
| Gastroenterology | 2,392 | 2,373 | 71 |
| Internal Medicine | 2,372 | 2,363 | 71 |
| ENT (Otolaryngology) | 2,368 | 2,358 | 71 |

The Emergency Department had the highest encounter volume, with
16,365 encounters, followed by Obstetrics & Gynecology with 9,242.

Together, these two departments accounted for a substantial share of
hospital activity, while most other departments recorded approximately
2,000 to 2,500 encounters.

Unique-patient counts were close to encounter counts across most
departments, suggesting that repeated visits within the same department
were limited during the quarter.

### Provider-Count Limitation

Every department showed exactly 71 active providers. This uniform result
is unlikely in a real hospital and may reflect the synthetic design of
the dataset.

Provider counts should therefore be treated as a dataset characteristic
rather than evidence of actual staffing balance across departments.

### Provider Distribution

The provider table contains exactly 71 providers in each of the 21
departments. Validation confirmed that providers were only assigned to
encounters within their listed home department.

This indicates that the equal provider count is an intentional feature
of the synthetic dataset rather than a data-quality or join issue.

Because real hospital departments rarely have identical staffing levels,
provider-count comparisons should be interpreted cautiously.

## Encounters per Provider

| Department | Encounters | Active Providers | Encounters per Provider |
|---|---:|---:|---:|
| Emergency Department | 16,365 | 71 | 230.49 |
| Obstetrics & Gynecology | 9,242 | 71 | 130.17 |
| General Surgery | 2,545 | 71 | 35.85 |
| Radiology / Imaging | 2,428 | 71 | 34.20 |
| Cardiology | 2,426 | 71 | 34.17 |
| Urology | 2,405 | 71 | 33.87 |
| Pulmonology | 2,404 | 71 | 33.86 |
| Gastroenterology | 2,392 | 71 | 33.69 |
| Internal Medicine | 2,372 | 71 | 33.41 |
| ENT (Otolaryngology) | 2,368 | 71 | 33.35 |

The Emergency Department recorded approximately 230 encounters per
active provider during Q1 2025, substantially higher than every other
department.

Obstetrics & Gynecology ranked second at approximately 130 encounters
per provider. Most remaining departments ranged from about 29 to 36
encounters per provider.

Because every department contains exactly 71 providers, this metric
primarily reflects differences in encounter volume rather than actual
differences in staffing structure.

## Daily Encounter Trend

Daily encounter volume was relatively stable throughout Q1 2025,
generally ranging from approximately 700 to 840 encounters per day.

The highest daily volume occurred on February 9, with 840 encounters.
February 18 and February 27 followed with 836 encounters each.

March 31 contained only 97 encounters, substantially below the normal
daily range. Because this is the final date in the dataset, it likely
represents a partial or incomplete reporting day rather than a true
operational decline.

March 31 should therefore be identified as a data limitation and may be
excluded from daily averages or trend comparisons when appropriate.

### Busiest and Slowest Days

The busiest day in the dataset was February 9, 2025, with 840
encounters. Several other high-volume days exceeded 830 encounters.

March 31, 2025, recorded only 97 encounters and was a clear outlier.
Excluding that final-day outlier, the lowest daily volume was 711
encounters on January 19.

The unusually low March 31 volume may reflect the synthetic generation
process or an incomplete final day rather than a true operational
decline.

### Daily Volume Outlier

Average daily encounter volume across the full quarter was 777.78
encounters.

When March 31 was excluded, the average increased to 785.43 encounters
per day.

March 31 recorded only 97 encounters, which was 680.78 below the overall
daily average. This final-day value was substantially lower than the
rest of the quarter and appears more consistent with a partial day or a
synthetic-data distribution artifact than with normal operating volume.

Because of this outlier, daily trend visualizations should either label
March 31 clearly or present an additional average that excludes the
final day.

## Monthly Encounter Trend

| Month | Encounter Count | Unique Patients |
|---|---:|---:|
| January 2025 | 24,252 | 23,022 |
| February 2025 | 22,325 | 21,257 |
| March 2025 | 23,423 | 22,217 |

Encounter volume remained relatively stable across the quarter.

January had the highest activity with 24,252 encounters. February had
the lowest volume with 22,325 encounters, while March increased to
23,423.

March's total includes the unusually low March 31 volume of 97
encounters. Without that outlier, March would have been closer to
January's activity level.

## Day-of-Week Encounter Pattern

| Weekday | Encounter Count |
|---|---:|
| Monday | 9,453 |
| Tuesday | 9,474 |
| Wednesday | 10,166 |
| Thursday | 10,295 |
| Friday | 10,265 |
| Saturday | 10,221 |
| Sunday | 10,126 |

Encounter volume was relatively evenly distributed across the week.

Thursday had the highest volume with 10,295 encounters, followed closely
by Friday and Saturday. Monday had the lowest volume with 9,453
encounters.

The narrow range between weekdays suggests that hospital activity in
the synthetic dataset was not strongly concentrated on traditional
business days.

## Readmission Status

| Readmitted | Encounter Count | Percentage of Encounters |
|---|---:|---:|
| No | 59,003 | 84.29% |
| Yes | 10,997 | 15.71% |

Most encounters were not marked as readmissions. However, 10,997
encounters, or 15.71%, had the readmission flag set to `Yes`.

This indicates that roughly one in six encounters was associated with
a readmission in the synthetic dataset.

### Readmission Field Limitation

The dataset does not define whether `readmitted_flag` means the current
encounter was itself a readmission or whether the patient was readmitted
after the encounter. The field should therefore be interpreted as a
readmission indicator rather than a confirmed 30-day readmission rate.

## Length of Stay

| Metric | Result |
|---|---:|
| Encounters with recorded length of stay | 24,345 |
| Average length of stay | 2.50 days |
| Minimum length of stay | 2 days |
| Maximum length of stay | 3 days |

Length of stay was recorded for 24,345 encounters, which matches the
number of inpatient encounters in the dataset.

The average inpatient stay was 2.5 days, with all recorded stays falling
between 2 and 3 days.

## Length of Stay by Department

Average length of stay was highly consistent across departments,
generally ranging from approximately 2.46 to 2.50 days.

Pathology / Lab Services had the highest visible average at 2.50 days,
while Nephrology had the lowest visible average at 2.46 days. The
maximum recorded stay was 3 days across all displayed departments.

The differences are too small to support meaningful operational
conclusions about department performance.

### Department Length-of-Stay Limitation

The narrow department-level range reflects the simplified synthetic
design of the dataset. Because nearly all averages are close to 2.5 days
and all maximum values are 3 days, length of stay should not be used to
rank departments or infer efficiency differences.