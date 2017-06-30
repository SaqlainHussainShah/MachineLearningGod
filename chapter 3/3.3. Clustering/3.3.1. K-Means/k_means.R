library(flexclust)

k_means <- function(x, K) {
  # pick K random data points as initial centroids
  initial_centroids <- sample(1:nrow(x), K, replace = FALSE)
  
  centroids <- x[initial_centroids,]
  centroids_old <- matrix(rep(0, K * ncol(x)), ncol = ncol(x))
  
  cluster_assignments <- rep(0, nrow(x))
  while (!identical(centroids_old, centroids)) {
    centroids_old <- centroids
    
    # compute distances between data points and centroids
    dist_matrix <- dist2(x, centroids, method = "euclidean", p = 2)
    
    for (i in 1:nrow(x)) {
      # find closest centroid
      closest_centroid <- which.min(dist_matrix[i,])
      
      # associate data point with closest centroid
      cluster_assignments[i] <- closest_centroid
    }
    
    # recompute centroids
    for (k in 1:K) {
      centroids[k,] <- colMeans(x[cluster_assignments == k,])
    }
  }
  
  return(list(centroids, cluster_assignments))
}
