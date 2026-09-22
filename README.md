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

Final file: 15,000 rows × 31 columns, saved as `.xlsx`.

## Note
This dataset contains only **issued (approved)** loans — no rejected applications —
so the analysis answers *"what predicts default among approved borrowers,"* not
*"what predicts loan approval."*
