# Version 1.0.0
* Initial Release
  
# Version 1.0.1
* Bugfix for problem with predictions too close to 1 or 0 causing infinite misfit
* Corrected the dependencies for the package

# Version 1.1.0
* "connectors" parameter added to LKT which allows controlling component interactions
  
# Version 1.2.0
* Added automatic KC generation using covariance clustering
* "curvefeats" parameter added to allow other inputs for curvilinear effects
* Added HDIntervals (coefficient credibility intervals)

# Version 1.3.0
* Updated examples
* Large test sample added
* Bugfix for bug in predict function causing random catastrophic failure

# Version 1.5.0
* computeSpacingPredictors speed upgrade using better functions
* buildLKTModel
* LASSOLKTModel
* New examples

# Version 1.6.0
* usefolds input to LKT specifies subset of data to fit and precomputed features for test folds are also created for convenience
* restrict LASSOLKT and buildLKTModel by optionally removing component feature pairs that are known to be unjustified

# Version 1.7.0
* corrected namespace bug
* added predict_lkt function
* update of vignettes
