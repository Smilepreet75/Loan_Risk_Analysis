# Bank Loan Risk Analysis — Lending Club Dataset

## Dataset
- **Source**: Lending Club loan data (Kaggle), 2007–2018
- **Original**: ~1.19 GB, ~151 columns, 890K+ rows
- **Working sample**: 26 core columns + 3 bonus columns, **15,000 rows**
- Each row = one **issued/funded** loan (no rejected applications in this data)

**Why 15,000 rows?** Excel starts lagging well past ~50K rows with this many columns
and pivot tables. 15,000 is large enough to be statistically meaningful while staying
fast to clean. Rows were sampled **randomly** (not just the first N) and verified to be
spread proportionally across all years 2007–2018, using Power BI's Power Query
(Index column + `Number.Random()`, sorted, then `Keep Top Rows`).

## Columns Kept (renamed to full names)

| Column | Original | Description |
|---|---|---|
| `Loan_Status` | loan_status | Target variable |
| `Loan_Amount` | loan_amnt | Amount borrowed |
| `Term` | term | 36 or 60 months |
| `Interest_Rate` | int_rate | Interest rate |
| `Installment` | installment | Monthly payment |
| `Grade` / `Sub_Grade` | grade / sub_grade | LC's risk grade |
| `Purpose` | purpose | Reason for loan |
| `Employment_Length` / `Employment_Length_Years` | emp_length | Years employed (text / derived numeric) |
| `Home_Ownership` | home_ownership | RENT / OWN / MORTGAGE |
| `Annual_Income` | annual_inc | Self-reported income |
| `Verification_Status` | verification_status | Income verified? |
| `Address_State` | addr_state | Borrower's state |
| `Debt_Income_Ratio` | dti | Debt-to-income ratio |
| `Revolving_Balance` / `Revolving_Utilization` | revol_bal / revol_util | Credit usage |
| `Open_Accounts` / `Total_Accounts` | open_acc / total_acc | Account counts |
| `Earliest_Credit_Line` | earliest_cr_line | First credit account date |
| `Delinquencies_2Years` | delinq_2yrs | Late payments, last 2 yrs |
| `Inquiries_Last_6Months` | inq_last_6mths | Credit checks, last 6 mo |
| `Public_Records` / `Public_Records_Bankruptcies` | pub_rec / pub_rec_bankruptcies | Derogatory records |
| `Issue_Date` | issue_d | Loan issue date |
| `Application_Type` | application_type | Individual / Joint |
| `Mortgage_Accounts` | mort_acc | Number of mortgages |

**Bonus columns** (post-loan outcome data — used only for a *separate* recovery
angle, not for upfront risk prediction): `Collection_Recovery_Fee`, `Recoveries`, `Total_Payment`

**Derived columns**:
- `Employment_Length_Years` — text → number ("< 1 year" = 0, ..., "10+ years" = 10, "n/a" = **-1**, kept distinct from 0)
- `Credit_History_Length` — `Issue_Date` − `Earliest_Credit_Line`, in years

**Dropped**: ~120 columns — 100% null fields (`hardship_*`, `settlement_*`, IDs/URLs),
duplicates of kept columns, joint/co-applicant fields (small minority of loans),
after-the-loan fields, and deep credit-bureau variables redundant with simpler kept fields.

## Cleaning Steps (Excel)

1. **Trimmed & sampled** the raw file to 26+3 columns / 15,000 rows in Power BI (see above)
2. **Headers** — confirmed correct; an earlier apparent issue was actually a
   mis-configured visual, not a real header problem
3. **Renamed** all columns to full, consistent `Title_Case` names
4. **Dates** — `Issue_Date` and `Earliest_Credit_Line` reformatted to Short Date (were showing `00:00:00`)
5. **Missing values** — filled based on field type:
   - Count fields (`Mortgage_Accounts`: 320 blanks, `Public_Records_Bankruptcies`: 16 blanks) → filled with **0**
   - Ratio fields (`Debt_Income_Ratio`: 12 blanks) → filled with **median** (17.92)
6. **Outliers**:
   - `Debt_Income_Ratio` — capped at **75** (45 rows, 0.3%). Values up to 999 included
     an exact repeated `999.00` sentinel; since this dataset is *issued* loans only,
     DTI that extreme is inconsistent with real underwriting → treated as data error
   - All other numeric columns (`Loan_Amount`, `Revolving_Utilization`, `Annual_Income`,
     `Total_Accounts`, delinquency/inquiry counts) — checked, found plausible, **no changes**
7. **Categorical values** — standardized inconsistent casing (mixed upper/lower/camel)
   across `Home_Ownership`, `Verification_Status`, `Purpose`, `Grade`, `Loan_Status`, etc.
8. **Duplicates** — checked via Remove Duplicates, none retained
9. **Sanity check** — avg `Interest_Rate` by `Grade` increases smoothly A (7.1%) → G (28.1%);
   `Loan_Status` counts total exactly 15,000 with a realistic distribution

# SQL Analysis — Bank Loan Risk Project

Queries stored in `SQL/` folder. Each answers one business question by calculating
default rate (`Loan_Status = 'Charged Off'`) across buckets/categories, using
`data_for_sql` (cleaned 15,000-row sample).

## Questions & Findings

| # | Question | Finding |
|---|---|---|
| 1 | Overall loan status distribution? | 46% Fully Paid, 41% Current, 12% Charged Off |
| 2 | Total loan volume / avg loan amount? | $226.2M total, $15,081 average |
| 3 | Does Grade (A–G) predict default? | Yes — smooth increase, 3.3% (A) → 41.4% (G) |
| 4 | Does DTI affect default? | Yes — default rises as DTI increases |
| 5 | Does Income affect default? | Yes — 14.6% (Low) → 9.2% (High) |
| 6 | Does Employment Length affect default? | No clear pattern (10.5–13.6% range) |
| 7 | Does Income Verification affect default? | Yes, inverted — Verified (15.2%) > Not Verified (7.7%) |
| 8 | Does Loan Purpose affect default? | Varies 6%–20%+; some categories too small to trust |
| 9 | Does Loan Amount affect default? | No clear pattern (10.3–12.7% range) |
| 10 | Does Term (36 vs 60 mo) affect default? | Yes — 60mo (16.0%) vs 36mo (9.9%) |
| 11 | Does Home Ownership affect default? | Yes — Rent (13.1%) > Own (11.2%) > Mortgage (10.6%) |
| 12 | Does Open_Accounts affect default? | No clear pattern (11.0–12.3% range) |
| 13 | Does Revolving Utilization affect default? | Yes — 8.7% (Low) → 13.8% (High) |
| 14 | Do past Delinquencies affect default? | Yes — 11.3% (0) → 16.2% (3+) |
| 15 | Do recent Inquiries affect default? | Yes, strongly — 9.4% (0) → 23.9% (5+) |
| 16 | Which states have highest/lowest default rate? | WA lowest (6.9%), NC highest (14.6%) among reliable states — map visual recommended |
| 17 | Which states have highest loan volume? | CA ($31.5M) > TX > NY > FL > IL |
| 18 | Does Mortgage_Accounts affect default? | Yes — 0 mortgages (12.8%) > 1–7 mortgages (~10–12%) |
| 19 | Does Credit History Length affect default? | Yes — 13.4% (Low) → 10.1% (High) |
| 20 | Does Interest Rate affect default? | Yes, strongest signal — 6.0% (Low) → 23.6% (High) |
| 21 | (Bonus) How much is actually lost on Charged Off loans? | ~40% net loss ($10.7M of $26.8M) — 60% recovered via payments + collections |

## Dashboard with Power BI (In Progress)

## Summary

**Strong signals**: Grade, Interest Rate, DTI, Income, Term, Home Ownership,
Verification Status, Revolving Utilization, Delinquencies, Inquiries, Credit History
Length, Mortgage Accounts, State (large-sample states)

**Weak / no signal**: Employment Length, Loan Amount, Open Accounts

**Caution — small sample size**: some Purpose categories, Home Ownership (Any/Other),
low-volume states

## Note
This dataset contains only **issued (approved)** loans — no rejected applications —
so the analysis answers *"what predicts default among approved borrowers,"* not
*"what predicts loan approval."*
