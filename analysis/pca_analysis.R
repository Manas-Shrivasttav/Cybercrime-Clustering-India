# =============================================================================
# CYBERCRIME CLUSTERING — INDIA STATES & UTs
# Script 1: Principal Component Analysis (PCA)
# =============================================================================
# Authors: Manas Shrivastav et al.
# Published: WeSchool International Conference | ISBN: 978-93-91355-77-7
# Data: OGD Platform India — Cybercrime 2019
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Load Libraries
# -----------------------------------------------------------------------------
library(psych)
library(dplyr)
library(ggplot2)
library(DataExplorer)

# -----------------------------------------------------------------------------
# 2. Load Data
# -----------------------------------------------------------------------------
# Download dataset from:
# https://data.gov.in/resource/stateut-and-crime-head-wise-cyber-crimes-under-it-act-cases-during-2019
# Save as 'cybercrime_data.csv' in the data/ folder

C_data <- read.csv("data/cybercrime_data.csv", stringsAsFactors = FALSE)

str(C_data)

# -----------------------------------------------------------------------------
# 3. Data Cleaning
# -----------------------------------------------------------------------------
# Remove rows with anomalies (rows 30, 38, 39 identified during EDA)
C_data_new <- C_data %>%
  filter(!row_number() %in% c(30, 38, 39))

# -----------------------------------------------------------------------------
# 4. Exploratory Visualisation
# -----------------------------------------------------------------------------
# Bar plot of total cybercrime by state (vr51 = total crimes column)
df <- C_data_new[order(C_data_new$vr51, decreasing = TRUE), ]
barplot(df$vr51,
        names.arg = df$vr2,
        col = "steelblue",
        las = 2,
        main = "Total Cybercrimes by State/UT (2019)",
        ylab = "Number of Cases",
        cex.names = 0.6)

# -----------------------------------------------------------------------------
# 5. Feature Selection — Remove Non-Numeric / Redundant Columns
# -----------------------------------------------------------------------------
# Removing ID, name, total, and other non-feature columns
C_data_new2 <- C_data_new[ -c(1, 2, 21, 24, 40, 44, 48, 51) ]

# -----------------------------------------------------------------------------
# 6. Correlation Matrix
# -----------------------------------------------------------------------------
cor_data <- cor(C_data_new2)

# -----------------------------------------------------------------------------
# 7. Eigenvalue Analysis
# -----------------------------------------------------------------------------
# Eigenvalues > 1 determine number of dimensions to retain
eigen_values <- eigen(cor_data)
eigen_values$values   # 9 values > 1; 6 chosen (81% cumulative variance)

cov_data1 <- cov(C_data_new2)

# -----------------------------------------------------------------------------
# 8. Initial PCA — All Components
# -----------------------------------------------------------------------------
pca_data1 <- principal(C_data_new2, nfactors = 43, rotate = "none")
pca_data1

# Scree Plot — identify elbow
plot(pca_data1$values,
     type = "b",
     ylab = "Eigenvalues",
     xlab = "Component",
     main = "Scree Plot — All Principal Components",
     pch = 19,
     col = "steelblue")
abline(h = 1, col = "red", lty = 2)   # Kaiser criterion: eigenvalue > 1

# -----------------------------------------------------------------------------
# 9. Final PCA — 6 Components (81% Variance Explained)
# -----------------------------------------------------------------------------
pca_data2 <- principal(C_data_new2, nfactors = 6, rotate = "none")
pca_data2
pca_data2$scores

# -----------------------------------------------------------------------------
# 10. Varimax Rotation — Improve Interpretability
# -----------------------------------------------------------------------------
pca_data1_rotation <- principal(C_data_new2,
                                 nfactors = 6,
                                 rotate = "varimax",
                                 scores = TRUE)

# View factor loadings — identify which variables drive each component
pca_data1_rotation$loadings

# -----------------------------------------------------------------------------
# 11. Extract Rotated Scores
# -----------------------------------------------------------------------------
pca_data1_rotation_scores <- data.frame(pca_data1_rotation$scores)

# Bind state names back to scores for interpretability
PCA_data <- cbind(C_data_new$vr2, pca_data1_rotation_scores)
colnames(PCA_data)[1] <- "State_UT"

# View final PCA output
head(PCA_data)

# -----------------------------------------------------------------------------
# 12. Rotated Component Interpretation
# -----------------------------------------------------------------------------
# RC1: Preventing & Responding to Computer Crimes (Legal, Ethical, Technological)
# RC2: Fraud, Cheating, Offences Involving Communication Devices
# RC3: Fake News, Defamation, Cyber Terrorism, Social Media Misuse
# RC4: Cybercrimes Involving Fraud, Identity Theft, Data Theft
# RC5: Identity Theft and Fraud in the Digital Age
# RC6: Infringement of Copyrights

# Save PCA scores for use in clustering script
write.csv(PCA_data, "data/pca_scores.csv", row.names = FALSE)
cat("✓ PCA complete. Scores saved to data/pca_scores.csv\n")
cat("✓ Cumulative variance explained by 6 PCs: 81%\n")
