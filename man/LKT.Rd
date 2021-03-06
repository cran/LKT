% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LKTfunctions.R
\name{LKT}
\alias{LKT}
\title{LKT}
\usage{
LKT(
  data,
  components,
  features,
  fixedpars = NA,
  seedpars = NA,
  covariates = NA,
  curvefeats = NA,
  dualfit = FALSE,
  interc = FALSE,
  cv = FALSE,
  elastic = FALSE,
  verbose = TRUE,
  epsilon = 1e-04,
  cost = 512,
  lowb = 1e-05,
  highb = 0.99999,
  type = 0,
  maketimes = FALSE,
  bias = 0,
  maxitv = 100,
  autoKC = rep(0, length(components)),
  autoKCcont = rep("NA", length(components)),
  connectors = rep("+", length(components) - 1)
)
}
\arguments{
\item{data}{A dataset with Anon.Student.Id and CF..ansbin.}

\item{components}{A vector of factors that can be used to compute each features for each subject.}

\item{features}{a vector methods to use to compute a feature for the component.}

\item{fixedpars}{a vector of parameters for all features+components.}

\item{seedpars}{a vector of parameters for all features+components to seed non-linear parameter search.}

\item{covariates}{A list of components that interacts with component by feature in the main specification.}

\item{curvefeats}{vector of columns to use with "diff" functions}

\item{dualfit}{TRUE or FALSE, fit a simple latency using logit. Requires Duration..sec. column in data.}

\item{interc}{TRUE or FALSE, include a global intercept.}

\item{cv}{TRUE or FALSE, if TRUE runs N-fold cv. Requires premade column named 'fold' with integers denoting the N folds}

\item{elastic}{glmnet, cv.glmnet, cva.glmnet or FALSE.}

\item{verbose}{provides more output in some cases.}

\item{epsilon}{passed to LiblineaR}

\item{cost}{passed to LiblineaR}

\item{lowb}{lower bound for non-linear optimizations}

\item{highb}{upper bound for non-linear optimizations}

\item{type}{passed to LiblineaR}

\item{maketimes}{Boolean indicating whether to create time based features (or may be precomputed)}

\item{bias}{passed to LiblineaR}

\item{maxitv}{passed to nonlinear optimization a maxit control}

\item{autoKC}{a vector to indicate whether to use autoKC for the component (0) or the k for the numebr of clusters}

\item{autoKCcont}{a vector of text strings set to "rand" for component to make autoKC assignment to cluster is randomized (for comaprison)}

\item{connectors}{a vector if linear equation R operators including +, * and :}
}
\value{
list of values "model", "coefs", "r2", "prediction", "nullmodel", "latencymodel", "optimizedpars","subjectrmse", "newdata", and "automat"
}
\description{
Compute a logistic regression model of learning for input data.
}
\examples{
temp <- samplelkt
temp$CF..ansbin.<-ifelse(temp$Outcome=="CORRECT",1,ifelse(temp$Outcome=="INCORRECT",0,-1))
temp <- data.table::setDT(temp)
temp <- computeSpacingPredictors(temp, "KC..Default.")
temp <- temp[temp$CF..ansbin==0 | temp$CF..ansbin.==1,]
temp$KC..Default.<-substr(temp$KC..Default.,1,10)
modelob <- LKT(
  data = temp, interc=TRUE,
  components = c("Anon.Student.Id", "KC..Default.", "KC..Default."),
  features = c("logitdec", "logitdec", "lineafm"),
  fixedpars = c(.9, .85)
)
print(modelob$coefs)
print(modelob$loglik)

modelob <- LKT(
  data = temp, interc=TRUE,
  components = c("Anon.Student.Id", "KC..Default.", "KC..Default."),
  features = c("logitdec", "logitdec", "lineafm"),
  seedpars = c(.9, .85)
)
print(modelob$coefs)
print(modelob$loglik)

modelob <- LKT(
  data = temp, interc=TRUE,
  connectors = c("+","*","+"),
  components = c("Anon.Student.Id", "KC..Default.", "KC..Default."),
  features = c("intercept", "logitdec", "lineafm"),
  fixedpars = c(.9, .85)
)
print(modelob$coefs)
print(modelob$loglik)

modelob <- LKT(
  data = temp, interc=TRUE,
  components = c("Anon.Student.Id", "KC..Default.", "KC..Default."),
  features = c("logitdec", "logitdec$", "lineafm$"),
  fixedpars = c(.9, .85)
)
print(modelob$coefs)
print(modelob$loglik)

# this example illustrates how mean fit is worse for CV
# compared to the first example above. In this case,
# this is mainly do to the small dataset allowing overgeneralization
# despite the model only having 4 coefficients
temp <- samplelkt
unq <- sample(unique(temp$Anon.Student.Id))
sfold <- rep(1:5,length.out=length(unq))
temp$fold <- rep(0,length(temp[,1]))
for(i in 1:5){temp$fold[which(temp$Anon.Student.Id \%in\% unq[which(sfold==i)])]=i}
modelob <- LKT(
     data = temp, interc=TRUE,
      components = c("Anon.Student.Id", "KC..Default.", "KC..Default."),
      features = c("logitdec", "logitdec", "lineafm"),
      fixedpars = c(.9, .85),cv=TRUE
  )
print(modelob$cv_res)
print(mean(modelob$cv_res$rmse))
print(mean(modelob$cv_res$mcfad))

# this example illustrates the limitation of CV when data does not contain
# sufficient examples of each predictor
#modelob <- LKT(
#  data = temp, interc=TRUE,
#  components = c("Anon.Student.Id", "KC..Default.", "KC..Default."),
#  features = c("logitdec", "logitdec$", "lineafm$"),
#  fixedpars = c(.9, .85),cv=TRUE
#)
#print(modelob$cv_res)

}
