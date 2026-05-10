# =============================================================================
# CYBERCRIME CLUSTERING — INDIA STATES & UTs
# Script 2: K-Means & Hierarchical Clustering
# =============================================================================
# Authors: Manas Shrivastav et al.
# Published: WeSchool International Conference | ISBN: 978-93-91355-77-7
# Data: OGD Platform India — Cybercrime 2019
# Run pca_analysis.R first to generate pca_scores.csv
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Load Libraries
# -----------------------------------------------------------------------------
library(NbClust)
library(stats)
library(fpc)
library(ggplot2)
library(cluster)
library(dplyr)
library(DataExplorer)
library(Rtsne)

# -----------------------------------------------------------------------------
# 2. Load & Prepare Data
# -----------------------------------------------------------------------------
C_data <- read.csv("data/cybercrime_data.csv", stringsAsFactors = FALSE)

# Remove rows with anomalies
clean_data <- na.omit(C_data)

# Remove non-numeric columns (state name, ID, etc.)
C_data_new2 <- clean_data[ -c(1) ]

# Standardise all variables (critical for distance-based clustering)
C_data_scaled <- scale(C_data_new2)
C_data_scaled_df <- data.frame(C_data_scaled)

cat("✓ Data scaled. Dimensions:", dim(C_data_scaled), "\n")

# =============================================================================
# SECTION A: OPTIMAL NUMBER OF CLUSTERS
# =============================================================================

# -----------------------------------------------------------------------------
# 3. NbClust — 26 Criteria for Optimal K (K-Means)
# -----------------------------------------------------------------------------
set.seed(123)
nc_Csps <- NbClust(C_data_scaled_df,
                   min.nc   = 2,
                   max.nc   = 15,
                   method   = "kmeans",
                   distance = "euclidean")

# Summarise votes across 26 criteria
table(nc_Csps$Best.n[1,])

# Visualise — majority vote for K
barplot(table(nc_Csps$Best.n[1,]),
        xlab  = "No. of Clusters",
        ylab  = "Number of Criteria",
        main  = "Optimal K — Votes Across 26 NbClust Criteria (K-Means)",
        col   = "steelblue")
# Result: K = 4 most chosen

# -----------------------------------------------------------------------------
# 4. Elbow Method — Within-Cluster Sum of Squares
# -----------------------------------------------------------------------------
set.seed(123)
k.max <- 15
wss <- sapply(1:k.max, function(k) {
  kmeans(C_data_scaled, k, nstart = 50, iter.max = 15)$tot.withinss
})

plot(1:k.max, wss,
     type = "b",
     pch  = 19,
     frame = FALSE,
     col  = "steelblue",
     xlab = "Number of Clusters K",
     ylab = "Total Within-Cluster Sum of Squares",
     main = "Elbow Method — Optimal K")
# Result: Elbow at K = 4

# =============================================================================
# SECTION B: K-MEANS CLUSTERING
# =============================================================================

# -----------------------------------------------------------------------------
# 5. Fit K-Means Model (K=4, nstart=25 for stability)
# -----------------------------------------------------------------------------
set.seed(123)
fit.km.Csps <- kmeans(C_data_scaled, centers = 4, nstart = 25)

# Cluster sizes
cat("\n--- K-Means Cluster Sizes ---\n")
print(fit.km.Csps$size)

# Cluster centroids
cat("\n--- Cluster Centroids ---\n")
print(fit.km.Csps$centers)

cluster1 <- fit.km.Csps$cluster

# -----------------------------------------------------------------------------
# 6. Visualise K-Means Clusters
# -----------------------------------------------------------------------------
clusplot(C_data_new2,
         cluster1,
         color = TRUE,
         shade = TRUE,
         labels = 2,
         lines  = 0,
         main   = "K-Means Clustering — 4 Cluster Solution")
# Note: Two components explain 70.57% of point variability

# Aggregate median values by cluster
newdata_Csp <- data.frame(C_data_scaled, cluster1)
agg <- aggregate(C_data_scaled,
                 by  = list(cluster = cluster1),
                 FUN = median)

# Bind state names to cluster assignments
newdata_Csp <- cbind(clean_data$States, newdata_Csp)
colnames(newdata_Csp)[1] <- "State_UT"

cat("\n--- State/UT Cluster Assignments (K-Means) ---\n")
print(newdata_Csp[ , c("State_UT", "cluster1")])

# -----------------------------------------------------------------------------
# 7. Silhouette Width — Cluster Quality Evaluation
# -----------------------------------------------------------------------------
dis_crime  <- dist(C_data_scaled)^2
sil_width  <- silhouette(cluster1, dis_crime)
sil_sum    <- summary(sil_width)

cat("\n--- Silhouette Width per Cluster ---\n")
print(sil_sum$clus.avg.widths)   # Values closer to 1 = better separation

cat("\n--- Overall Average Silhouette Width ---\n")
cat(sil_sum$avg.width, "\n")     # 0.76 — clusters well-separated

# Horizontal bar chart of per-cluster silhouette widths
barplot(sil_sum$clus.avg.widths,
        horiz  = TRUE,
        col    = c("steelblue", "coral", "seagreen", "goldenrod"),
        xlab   = "Silhouette Width",
        main   = "Silhouette Width per Cluster (K-Means)",
        names.arg = c("Cluster 1", "Cluster 2", "Cluster 3", "Cluster 4"))
abline(v = 0.76, col = "red", lty = 2)
legend("bottomright", legend = "Overall avg = 0.76", col = "red", lty = 2)

# =============================================================================
# SECTION C: HIERARCHICAL CLUSTERING
# =============================================================================

# -----------------------------------------------------------------------------
# 8. Compute Distance Matrix
# -----------------------------------------------------------------------------
distance <- dist(C_data_scaled)

# -----------------------------------------------------------------------------
# 9. Hierarchical Clustering — Average Linkage
# -----------------------------------------------------------------------------
average_Hcrime <- hclust(distance, method = "average")

# NbClust for hierarchical
clusterNumber <- NbClust(C_data_scaled,
                          distance = "euclidean",
                          min.nc   = 2,
                          max.nc   = 15,
                          method   = "average")

# Summarise
table(clusterNumber$Best.n[1,])
barplot(table(clusterNumber$Best.n[1,]),
        xlab  = "No. of Clusters",
        ylab  = "Number of Criteria",
        main  = "Optimal K — NbClust Criteria (Hierarchical)",
        col   = "coral")
# Result: K = 4 most chosen

# -----------------------------------------------------------------------------
# 10. Cut Tree at K=4
# -----------------------------------------------------------------------------
H_clusterData <- cutree(average_Hcrime, k = 4)
table(H_clusterData)

# Aggregate median by hierarchical cluster
aggregate(C_data_new2,
          by  = list(cluster = H_clusterData),
          FUN = median)

# Cluster plot
clusplot(C_data_new2,
         H_clusterData,
         color  = TRUE,
         shade  = TRUE,
         labels = 2,
         lines  = 0,
         main   = "Hierarchical Clustering — 4 Cluster Solution")

# -----------------------------------------------------------------------------
# 11. Dendrogram
# -----------------------------------------------------------------------------
plot(average_Hcrime,
     hang = -1,
     cex  = 0.8,
     main = "Average Linkage Clustering — 4 Cluster Dendrogram",
     xlab = "States / Union Territories",
     sub  = "")
rect.hclust(average_Hcrime, k = 4, border = c("steelblue","coral","seagreen","goldenrod"))

# =============================================================================
# SECTION D: CLUSTER STABILITY (BOOTSTRAP)
# =============================================================================

# -----------------------------------------------------------------------------
# 12. Bootstrap Cluster Stability (fpc)
# -----------------------------------------------------------------------------
set.seed(123)
clusterBoot <- clusterboot(distance,
                            clustermethod = kmeansCBI,
                            k             = 4,
                            bootmethod    = "boot",
                            seed          = 15554)

cat("\n--- Bootstrap Mean Stability (> 0.6 = stable) ---\n")
print(clusterBoot$bootmean)

cat("\n--- Bootstrap Dissolution Count (lower = more stable) ---\n")
print(clusterBoot$bootbrd)

# =============================================================================
# SECTION E: FINAL CLUSTER INTERPRETATION
# =============================================================================

cat("\n")
cat("=======================================================\n")
cat("FINAL CLUSTER RESULTS — K-MEANS (K=4)\n")
cat("=======================================================\n")
cat("Cluster 1: Combating Diverse Cybercrimes (Legal, Ethical, Technological)\n")
cat("           → Uttar Pradesh\n\n")
cat("Cluster 2: Ethical & Legal ICT Use — Preventing Misuse\n")
cat("           → 30 States/UTs (relatively low cybercrime rates)\n\n")
cat("Cluster 3: Cybercrimes Targeting Communication Devices & Social Media\n")
cat("           → Andhra Pradesh, Maharashtra, Telangana\n\n")
cat("Cluster 4: Misuse of Social Media, Online Platforms & IP\n")
cat("           → Jammu & Kashmir, Tamil Nadu\n")
cat("=======================================================\n")
cat("Overall Silhouette Width: 0.76 (well-separated clusters)\n")
cat("Variance explained by 6 PCs: 81%\n")
cat("=======================================================\n")
