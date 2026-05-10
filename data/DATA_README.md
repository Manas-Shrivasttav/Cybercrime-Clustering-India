# Data — Cybercrime Clustering Project

## Source

**Open Government Data (OGD) Platform India**  
URL: https://data.gov.in/resource/stateut-and-crime-head-wise-cyber-crimes-under-it-act-cases-during-2019

This is a government-supported open data initiative. The dataset is publicly available and free to download.

## Dataset Description

| Attribute | Detail |
|---|---|
| File name | `cybercrime_data.csv` |
| Coverage | All 36 States and Union Territories of India |
| Year | 2019 |
| Total variables | 50 |
| Observations | 36 (one per state/UT) |

## Variables Covered

The dataset includes cybercrime incident counts across the following categories (under the IT Act and IPC):

**IT Act offences:**
- Tampering with computer source documents
- Hacking / unauthorised access to computer systems
- Cyber terrorism
- Publishing or transmitting obscene/pornographic content
- Interception or monitoring of information
- OTP fraud and identity theft
- Ransomware and malware incidents

**IPC offences using communication devices:**
- Cyberstalking and cyberbullying
- Data theft
- Online fraud and cheating
- Fake news and defamation
- Copyright and IP infringement
- Aiding suicide via online platforms

## How to Access

1. Visit the URL above
2. Download the CSV file
3. Place it in this `data/` folder as `cybercrime_data.csv`
4. Run `pca_analysis.R` followed by `clustering_analysis.R`

## Note on Data Quality

Three rows (rows 30, 38, 39) were removed during preprocessing due to data anomalies identified in exploratory analysis. All preprocessing steps are documented in `analysis/pca_analysis.R`.

## Citation

If using this data in your own research, cite the OGD Platform India:

> Open Government Data (OGD) Platform India. "State/UT and Crime Head-wise Cyber Crimes under IT Act — 2019." data.gov.in, Government of India.

And cite the original paper:

> Shrivastav, M., Supramanian, M., Harsh, T., Subramanian, V., Ajay, A., & Gaha, R. (2023). "Clustering of States and Union Territories in India Based on the Cybercrimes." WeSchool International Conference. ISBN: 978-93-91355-77-7.
