# 🗺️ Clustering of Indian States & UTs Based on Cybercrimes

> **Published Research** — Peer-reviewed paper presented at the WeSchool International Conference  
> ISBN: 978-93-91355-77-7
> Link to paper: https://www.ceeol.com/search/chapter-detail?id=1178115

[![Language](https://img.shields.io/badge/Language-R-276DC3?style=flat&logo=r)](https://www.r-project.org/)
[![Domain](https://img.shields.io/badge/Domain-Cybercrime%20Analytics-red?style=flat)]()
[![Method](https://img.shields.io/badge/Methods-K--Means%20%7C%20Hierarchical%20Clustering-blue?style=flat)]()
[![Data](https://img.shields.io/badge/Data-OGD%20Platform%20India-orange?style=flat)](https://data.gov.in/)
[![Published](https://img.shields.io/badge/Published-WeSchool%20Intl.%20Conference-green?style=flat)]()

---

## 📄 About This Research

India has witnessed a rapid rise in cybercrimes across its 28 states and 8 union territories — but the nature, volume, and type of crimes varies drastically by region. Policymakers and law enforcement agencies had no structured, data-driven method to identify which regions share similar cybercrime profiles and where focused intervention was most needed.

This study addresses that gap by applying **unsupervised machine learning clustering techniques** to official government cybercrime data — grouping Indian states and UTs by their cybercrime patterns to enable targeted policy responses.

**Key question:** *Which states share similar cybercrime profiles, and what does this mean for national cyber policy?*

---

## 📊 Dataset

| Attribute | Detail |
|---|---|
| Source | [Open Government Data (OGD) Platform India](https://data.gov.in/resource/stateut-and-crime-head-wise-cyber-crimes-under-it-act-cases-during-2019) |
| Coverage | All 36 States and Union Territories of India |
| Variables | 50 variables covering cybercrime categories |
| Year | 2019 |
| Crime types covered | Ransomware, malware, spam, OTP fraud, identity theft, cyberstalking, cyber terrorism, data theft, social media misuse, IP infringement, and more |

---

## 🔬 Methodology

### Pipeline Overview

```
Raw Data (50 variables)
        │
        ▼
  Data Cleaning & Preprocessing
  (Remove outliers, handle missing values)
        │
        ▼
  PCA — Dimensionality Reduction
  (50 variables → 6 Principal Components)
  [81% variance explained]
        │
        ▼
  Variable Standardisation (Z-score scaling)
        │
        ▼
  ┌─────────────────────────────────┐
  │    Optimal K Selection          │
  │  • Hubert Statistic             │
  │  • DD Hubert Statistic          │
  │  • D Index (Elbow Method)       │
  │  • NbClust (26 criteria)        │
  │  → Consensus: K = 4             │
  └─────────────────────────────────┘
        │
        ▼
  ┌──────────────┐    ┌─────────────────────┐
  │  K-Means     │    │  Hierarchical       │
  │  Clustering  │    │  Clustering         │
  │  (K=4,       │    │  (Average linkage,  │
  │  nstart=25)  │    │  K=4)               │
  └──────────────┘    └─────────────────────┘
        │                      │
        └──────────┬───────────┘
                   ▼
        Model Evaluation
        (Silhouette Width = 0.76)
                   │
                   ▼
        Policy Recommendations
```

### Principal Components (After PCA + Varimax Rotation)

| Component | Description |
|---|---|
| RC1 | Preventing & Responding to Computer Crimes and Cyber Attacks |
| RC2 | Fraud, Cheating, and Offences Involving Communication Devices |
| RC3 | Fake News, Defamation, Cyber Terrorism, and Social Media Misuse |
| RC4 | Cybercrimes Involving Fraud, Identity Theft, and Data Theft |
| RC5 | Identity Theft and Fraud in the Digital Age |
| RC6 | Infringement of Copyrights |

---

## 📈 Results

### Four Distinct Cybercrime Clusters Identified

| Cluster | Name | States / UTs |
|---|---|---|
| **1** | Combating Diverse Cybercrimes: Legal, Ethical & Technological | Uttar Pradesh |
| **2** | Ethical & Legal ICT Use: Preventing Misuse | Arunachal Pradesh, Assam, Bihar, Chhattisgarh, Goa, Gujarat, Haryana, HP, Kerala, Punjab & others (30 states) |
| **3** | Cybercrimes Targeting Communication Devices, Social Media & Personal Information | Andhra Pradesh, Maharashtra, Telangana |
| **4** | Misuse of Social Media, Online Platforms & Intellectual Property | Jammu & Kashmir, Tamil Nadu |

### Model Evaluation

| Metric | Value | Interpretation |
|---|---|---|
| Silhouette Width (overall avg.) | **0.76** | Close to 1 — clusters are well-separated |
| Variance explained by 6 PCs | **81%** | Strong dimensionality reduction |
| Optimal K (consensus) | **4** | Consistent across Hubert, D-Index, NbClust |
| K-Means vs Hierarchical agreement | **High** | Both methods produced similar cluster structures |

### Key Finding
Uttar Pradesh (Cluster 1) stands alone as a high-risk state with significantly elevated rates across **all cybercrime categories** — particularly OTP fraud and identity theft — requiring urgent targeted intervention. In contrast, 30 states in Cluster 2 show relatively lower and stable crime patterns.

---

## 🛠️ Tech Stack

`R` `psych` `NbClust` `cluster` `fpc` `ggplot2` `dplyr` `DataExplorer` `Rtsne` `stats`

---

## 📁 Repository Structure

```
├── analysis/
│   ├── pca_analysis.R          # PCA dimensionality reduction
│   └── clustering_analysis.R   # K-Means + Hierarchical clustering
├── data/
│   └── DATA_README.md          # Dataset description and source
├── paper/
│   └── Cybercrime_Clustering_Paper.pdf   # Published conference paper
└── README.md
```

---

## 🚀 How to Run

### Prerequisites

```r
install.packages(c("psych", "dplyr", "ggplot2", "DataExplorer", 
                   "NbClust", "stats", "fpc", "cluster", "Rtsne"))
```

### Step 1: Run PCA

```r
source("analysis/pca_analysis.R")
# Output: 6 principal components explaining 81% variance
```

### Step 2: Run Clustering

```r
source("analysis/clustering_analysis.R")
# Output: 4 clusters with silhouette width = 0.76
```

### Data Note
Download the original dataset from [OGD Platform India](https://data.gov.in/resource/stateut-and-crime-head-wise-cyber-crimes-under-it-act-cases-during-2019) and place it in the `data/` folder as `cybercrime_data.csv` before running the scripts.

---

## 📋 Policy Implications

| Cluster | Recommended Intervention |
|---|---|
| Cluster 1 (UP) | Enact targeted cybercrime laws, deploy advanced security tech, increase law enforcement capacity |
| Cluster 2 (30 states) | Strengthen existing frameworks, maintain cybersecurity infrastructure, continue public education |
| Cluster 3 (AP, MH, TG) | Focus on social media and mobile device security; invest in AI-based detection tools |
| Cluster 4 (JK, TN) | Implement border-aware security measures; protect against foreign cyber actors |

---

## 👥 Authors

**Manas Shrivastav**, Muthulakshmi Supramanian, Tejaswi Harsh, Vanee Subramanian, Ankit Ajay, Rijan Gaha, Nagendra BV, Joseph Durai Selvam, and Ganesh. L

MBA – Business Analytics, School of Business and Management, **Christ University, Bangalore**

---

## 📰 Publication

> Presented at the **WeSchool International Conference**  
> ISBN: **978-93-91355-77-7**

---

## 📄 License

MIT License — code is open for academic and research use. Please cite the original paper if using methodology or findings.
