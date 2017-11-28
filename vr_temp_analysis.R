
R version 3.4.2 (2017-09-28) -- "Short Summer"
Copyright (C) 2017 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> > if (identical(getOption('pager'), file.path(R.home('bin'), 'pager'))) options(pager='cat') # rather take the ESS one 
> options(STERM='iESS', str.dendrogram.last="'", editor='emacsclient', show.error.locations=TRUE)
> data <- read.csv("dataframe_data_so_far.csv")
Error in file(file, "rt") : cannot open the connection
In addition: Warning message:
In file(file, "rt") :
  cannot open file 'dataframe_data_so_far.csv': No such file or directory
> child.data <- read.csv("data/childrenCSV.csv")
> carsac.data <- read.csv("data/selfSacCSV.csv")
> sidewalk.data <- read.csv("data/sidewalkCSV.csv")
> head(child.data)
  participant.ID  male av.Car perspective passedSanCheck  perceivedCar
1          GKR01  True  False    Observer           True        Mensch
2          GKR01  True  False    Observer           True        Mensch
3          GNI09 False  False   Passenger           True Computer (AV)
4          GNI09 False  False   Passenger           True Computer (AV)
5          UNT11 False   True   Passenger           True Computer (AV)
6          UNT11 False   True   Passenger           True Computer (AV)
  perceivedIden       Trial    Decision
1     Mitfahrer smallGroups hitChildren
2     Mitfahrer largeGroups hitChildren
3    Beobachter largeGroups hitChildren
4    Beobachter smallGroups   hitAdults
5     Mitfahrer largeGroups   hitAdults
6     Mitfahrer smallGroups   hitAdulsts
> summary(child.data)
 participant.ID    male      av.Car      perspective passedSanCheck
 ADB06  : 2     False:22   False:12   Observer : 6   False: 4      
 ARC09  : 2     True : 4   True :14   Passenger: 4   True :22      
 ASS09  : 2                           PedLarge : 6                 
 BDB10  : 2                           PedSmall :10                 
 GKR01  : 2                                                        
 GNI09  : 2                                                        
 (Other):14                                                        
        perceivedCar    perceivedIden         Trial           Decision 
 Computer (AV):16    Beobachter:12    largeGroups:13   hitAdults  :17  
 Mensch       :10    Fußgänger :10    smallGroups:13   hitChildren: 9  
                     Mitfahrer : 4                                     
                                                                       
                                                                       
                                                                       
                                                                       
> sidewalk.glmm <- glmer(Decision == "hitChildren" ~ perspective * av.Car + (1|participant.ID)
+ sidewalk.glmm <- glmer(Decision == "hitChildren" ~ perspective * av.Car + (1|participant.ID))
Error: unexpected symbol in:
"sidewalk.glmm <- glmer(Decision == "hitChildren" ~ perspective * av.Car + (1|participant.ID)
sidewalk.glmm"
> sidewalk.glmm <- glmer(Decision == "hitChildren" ~ perspective * av.Car + (1|participant.ID))
Error in glmer(Decision == "hitChildren" ~ perspective * av.Car + (1 |  : 
  could not find function "glmer"
> 
> library(lme4)
Loading required package: Matrix
> sidewalk.glmm <- glmer(Decision == "hitChildren" ~ perspective * av.Car + (1|participant.ID))
Error in eval(predvars, data, env) : object 'Decision' not found
In addition: Warning message:
In glmer(Decision == "hitChildren" ~ perspective * av.Car + (1 |  :
  calling glmer() with family=gaussian (identity link) as a shortcut to lmer() is deprecated; please call lmer() directly
> sidewalk.glmm <- glmer(Decision == "hitChildren" ~ perspective * av.Car + (1|participant.ID, family = "binomial"))
Error: unexpected ',' in "sidewalk.glmm <- glmer(Decision == "hitChildren" ~ perspective * av.Car + (1|participant.ID,"
> sidewalk.glmm <- glmer(Decision == "hitChildren" ~ perspective * av.Car + (1|participant.ID), family = "binomial")
Error in eval(predvars, data, env) : object 'Decision' not found
> sidewalk.glmm <- glmer(Decision == "hitChildren" ~ perspective * av.Car + (1|participant.ID), family = "binomial", data=child.data)
Warning messages:
1: In checkConv(attr(opt, "derivs"), opt$par, ctrl = control$checkConv,  :
  unable to evaluate scaled gradient
2: In checkConv(attr(opt, "derivs"), opt$par, ctrl = control$checkConv,  :
   Hessian is numerically singular: parameters are not uniquely determined
> child.glmm <- glmer(Decision == "hitChildren" ~ perspective * av.Car + (1|participant.ID), family = "binomial", data=child.data)
Warning messages:
1: In checkConv(attr(opt, "derivs"), opt$par, ctrl = control$checkConv,  :
  unable to evaluate scaled gradient
2: In checkConv(attr(opt, "derivs"), opt$par, ctrl = control$checkConv,  :
   Hessian is numerically singular: parameters are not uniquely determined
> summary(child.glmm)
Generalized linear mixed model fit by maximum likelihood (Laplace
  Approximation) [glmerMod]
 Family: binomial  ( logit )
Formula: 
Decision == "hitChildren" ~ perspective * av.Car + (1 | participant.ID)
   Data: child.data

     AIC      BIC   logLik deviance df.resid 
    37.4     48.7     -9.7     19.4       17 

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-1.66831 -0.46879 -0.00003  0.51706  1.19935 

Random effects:
 Groups         Name        Variance Std.Dev.
 participant.ID (Intercept) 0.3309   0.5752  
Number of obs: 26, groups:  participant.ID, 13

Fixed effects:
                                  Estimate Std. Error z value Pr(>|z|)
(Intercept)                          1.180      1.246   0.947    0.344
perspectivePassenger                -1.180      1.970  -0.599    0.549
perspectivePedLarge                -21.728  20488.332  -0.001    0.999
perspectivePedSmall                -21.728  14486.879  -0.002    0.999
av.CarTrue                         -21.722  20427.308  -0.001    0.999
perspectivePassenger:av.CarTrue     -3.853 253742.590   0.000    1.000
perspectivePedLarge:av.CarTrue      43.450  28931.758   0.002    0.999
perspectivePedSmall:av.CarTrue      41.516  25042.854   0.002    0.999

Correlation of Fixed Effects:
            (Intr) prspcP prspPL prspPS av.CrT pP:.CT pPL:.C
prspctvPssn -0.632                                          
prspctvPdLr  0.000  0.000                                   
prspctvPdSm  0.000  0.000  0.000                            
av.CarTrue   0.000  0.000  0.000  0.000                     
prspctP:.CT  0.000  0.000  0.000  0.000 -0.081              
prspcPL:.CT  0.000  0.000 -0.708  0.000 -0.706  0.057       
prspcPS:.CT  0.000  0.000  0.000 -0.578 -0.816  0.066  0.576
convergence code: 0
unable to evaluate scaled gradient
 Hessian is numerically singular: parameters are not uniquely determined

Warning messages:
1: In vcov.merMod(object, use.hessian = use.hessian) :
  variance-covariance matrix computed from finite-difference Hessian is
not positive definite or contains NA values: falling back to var-cov estimated from RX
2: In vcov.merMod(object, correlation = correlation, sigm = sig) :
  variance-covariance matrix computed from finite-difference Hessian is
not positive definite or contains NA values: falling back to var-cov estimated from RX
> head(carsac.data)
  participant.ID  male av.Car perspective passedSanCheck  perceivedCar
1          GKR01  True  False    Observer           True        Mensch
2          GKR01  True  False    Observer           True        Mensch
3          GNI09 False  False   Passenger           True Computer (AV)
4          GNI09 False  False   Passenger           True Computer (AV)
5          UNT11 False   True   Passenger           True Computer (AV)
6          UNT11 False   True   Passenger           True Computer (AV)
  perceivedIden    Trial       Decision
1     Mitfahrer mountain  selfSacrifice
2     Mitfahrer    cityR  selfSacrifice
3    Beobachter mountain hitPedestrians
4    Beobachter    cityR  selfSacrifice
5     Mitfahrer mountain hitPedestrians
6     Mitfahrer    cityR  selfSacrifice
> carsac.glmm <- glmer(Decision == "selfSacrifice" ~ perspective * av.Car + (1|participant.ID), family = "binomial", data=carsac.data)
Warning messages:
1: In checkConv(attr(opt, "derivs"), opt$par, ctrl = control$checkConv,  :
  unable to evaluate scaled gradient
2: In checkConv(attr(opt, "derivs"), opt$par, ctrl = control$checkConv,  :
   Hessian is numerically singular: parameters are not uniquely determined
> summary(carsac.glmm)
Generalized linear mixed model fit by maximum likelihood (Laplace
  Approximation) [glmerMod]
 Family: binomial  ( logit )
Formula: 
Decision == "selfSacrifice" ~ perspective * av.Car + (1 | participant.ID)
   Data: carsac.data

     AIC      BIC   logLik deviance df.resid 
    44.0     55.3    -13.0     26.0       17 

Scaled residuals: 
    Min      1Q  Median      3Q     Max 
-1.7321 -1.0000  0.0000  0.7071  1.0000 

Random effects:
 Groups         Name        Variance Std.Dev. 
 participant.ID (Intercept) 5.15e-17 7.176e-09
Number of obs: 26, groups:  participant.ID, 13

Fixed effects:
                                  Estimate Std. Error z value Pr(>|z|)
(Intercept)                      1.099e+00  1.155e+00   0.951    0.341
perspectivePassenger            -1.099e+00  1.826e+00  -0.602    0.547
perspectivePedLarge              4.006e+01  4.745e+07   0.000    1.000
perspectivePedSmall             -1.099e+00  1.528e+00  -0.719    0.472
av.CarTrue                      -1.099e+00  1.826e+00  -0.602    0.547
perspectivePassenger:av.CarTrue  1.099e+00  2.708e+00   0.406    0.685
perspectivePedLarge:av.CarTrue  -6.823e+00  4.818e+07   0.000    1.000
perspectivePedSmall:av.CarTrue   1.792e+00  2.255e+00   0.795    0.427

Correlation of Fixed Effects:
            (Intr) prspcP prspPL prspPS av.CrT pP:.CT pPL:.C
prspctvPssn -0.632                                          
prspctvPdLr  0.000  0.000                                   
prspctvPdSm -0.756  0.478  0.000                            
av.CarTrue  -0.632  0.400  0.000  0.478                     
prspctP:.CT  0.426 -0.674  0.000 -0.322 -0.674              
prspcPL:.CT  0.000  0.000 -0.985  0.000  0.000  0.000       
prspcPS:.CT  0.512 -0.324  0.000 -0.678 -0.810  0.546  0.000
convergence code: 0
unable to evaluate scaled gradient
 Hessian is numerically singular: parameters are not uniquely determined

Warning messages:
1: In vcov.merMod(object, use.hessian = use.hessian) :
  variance-covariance matrix computed from finite-difference Hessian is
not positive definite or contains NA values: falling back to var-cov estimated from RX
2: In vcov.merMod(object, correlation = correlation, sigm = sig) :
  variance-covariance matrix computed from finite-difference Hessian is
not positive definite or contains NA values: falling back to var-cov estimated from RX
> carsac.glmm <- glm(Decision == "selfSacrifice" ~ perspective * av.Car, family = "binomial", data=carsac.data)
> summary(carsac.glmm)

Call:
glm(formula = Decision == "selfSacrifice" ~ perspective * av.Car, 
    family = "binomial", data = carsac.data)

Deviance Residuals: 
     Min        1Q    Median        3Q       Max  
-1.66511  -1.17741   0.00013   0.90052   1.17741  

Coefficients:
                                Estimate Std. Error z value Pr(>|z|)
(Intercept)                        1.099      1.155   0.951    0.341
perspectivePassenger              -1.099      1.826  -0.602    0.547
perspectivePedLarge               17.467   4612.202   0.004    0.997
perspectivePedSmall               -1.099      1.528  -0.719    0.472
av.CarTrue                        -1.099      1.826  -0.602    0.547
perspectivePassenger:av.CarTrue    1.099      2.708   0.406    0.685
perspectivePedLarge:av.CarTrue     1.099   5648.771   0.000    1.000
perspectivePedSmall:av.CarTrue     1.792      2.255   0.795    0.427

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 32.097  on 25  degrees of freedom
Residual deviance: 26.000  on 18  degrees of freedom
AIC: 42

Number of Fisher Scoring iterations: 17

> head(sidewalk.data)
  participant.ID  male av.Car perspective passedSanCheck  perceivedCar
1          GKR01  True  False    Observer           True        Mensch
2          GKR01  True  False    Observer           True        Mensch
3          GNI09 False  False   Passenger           True Computer (AV)
4          GNI09 False  False   Passenger           True Computer (AV)
5          UNT11 False   True   Passenger           True Computer (AV)
6          UNT11 False   True   Passenger           True Computer (AV)
  perceivedIden       Trial    Decision
1     Mitfahrer smallGroups hitSidewalk
2     Mitfahrer largeGroups hitSidewalk
3    Beobachter largeGroups hitSidewalk
4    Beobachter smallGroups hitSidewalk
5     Mitfahrer smallGroups   hitStreet
6     Mitfahrer largeGroups   hitStreet
> sidewalk.glmm <- glmer(Decision == "hitSidewalk" ~ perspective * av.Car + (1|participant.ID), family = "binomial", data=sidewalk.data)
Warning messages:
1: In checkConv(attr(opt, "derivs"), opt$par, ctrl = control$checkConv,  :
  unable to evaluate scaled gradient
2: In checkConv(attr(opt, "derivs"), opt$par, ctrl = control$checkConv,  :
   Hessian is numerically singular: parameters are not uniquely determined
> summary(sidewalk.glmm)
Generalized linear mixed model fit by maximum likelihood (Laplace
  Approximation) [glmerMod]
 Family: binomial  ( logit )
Formula: 
Decision == "hitSidewalk" ~ perspective * av.Car + (1 | participant.ID)
   Data: sidewalk.data

     AIC      BIC   logLik deviance df.resid 
    32.7     44.0     -7.4     14.7       17 

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-1.57424  0.00003  0.00006  0.44127  1.00000 

Random effects:
 Groups         Name        Variance Std.Dev.
 participant.ID (Intercept) 0.9703   0.985   
Number of obs: 26, groups:  participant.ID, 13

Fixed effects:
                                  Estimate Std. Error z value Pr(>|z|)
(Intercept)                      2.063e+01  1.507e+04   0.001    0.999
perspectivePassenger            -2.183e+00  1.668e+04   0.000    1.000
perspectivePedLarge             -4.071e-01  2.301e+04   0.000    1.000
perspectivePedSmall             -1.931e+01  1.507e+04  -0.001    0.999
av.CarTrue                      -2.063e+01  1.507e+04  -0.001    0.999
perspectivePassenger:av.CarTrue -2.217e+01  1.380e+05   0.000    1.000
perspectivePedLarge:av.CarTrue   1.980e+01  2.441e+04   0.001    0.999
perspectivePedSmall:av.CarTrue   2.018e+01  1.507e+04   0.001    0.999

Correlation of Fixed Effects:
            (Intr) prspcP prspPL prspPS av.CrT pP:.CT pPL:.C
prspctvPssn -0.903                                          
prspctvPdLr -0.655  0.592                                   
prspctvPdSm -1.000  0.903  0.655                            
av.CarTrue  -1.000  0.903  0.655  1.000                     
prspctP:.CT  0.109 -0.121 -0.072 -0.109 -0.109              
prspcPL:.CT  0.618 -0.558 -0.943 -0.618 -0.618  0.067       
prspcPS:.CT  1.000 -0.903 -0.655 -1.000 -1.000  0.109  0.618
convergence code: 0
unable to evaluate scaled gradient
 Hessian is numerically singular: parameters are not uniquely determined

Warning messages:
1: In vcov.merMod(object, use.hessian = use.hessian) :
  variance-covariance matrix computed from finite-difference Hessian is
not positive definite or contains NA values: falling back to var-cov estimated from RX
2: In vcov.merMod(object, correlation = correlation, sigm = sig) :
  variance-covariance matrix computed from finite-difference Hessian is
not positive definite or contains NA values: falling back to var-cov estimated from RX
> summary(sidewalk.data)
 participant.ID    male      av.Car      perspective passedSanCheck
 ADB06  : 2     False:22   False:12   Observer : 6   False: 4      
 ARC09  : 2     True : 4   True :14   Passenger: 4   True :22      
 ASS09  : 2                           PedLarge : 6                 
 BDB10  : 2                           PedSmall :10                 
 GKR01  : 2                                                        
 GNI09  : 2                                                        
 (Other):14                                                        
        perceivedCar    perceivedIden         Trial           Decision 
 Computer (AV):16    Beobachter:12    largeGroups:13   hitSidewalk:20  
 Mensch       :10    Fußgänger :10    smallGroups:13   hitStreet  : 6  
                     Mitfahrer : 4                                     
                                                                       
                                                                       
                                                                       
                                                                       
> summary(child.data)
 participant.ID    male      av.Car      perspective passedSanCheck
 ADB06  : 2     False:22   False:12   Observer : 6   False: 4      
 ARC09  : 2     True : 4   True :14   Passenger: 4   True :22      
 ASS09  : 2                           PedLarge : 6                 
 BDB10  : 2                           PedSmall :10                 
 GKR01  : 2                                                        
 GNI09  : 2                                                        
 (Other):14                                                        
        perceivedCar    perceivedIden         Trial           Decision 
 Computer (AV):16    Beobachter:12    largeGroups:13   hitAdults  :17  
 Mensch       :10    Fußgänger :10    smallGroups:13   hitChildren: 9  
                     Mitfahrer : 4                                     
                                                                       
                                                                       
                                                                       
                                                                       
> summary(carsac.data)
 participant.ID    male      av.Car      perspective passedSanCheck
 ADB06  : 2     False:22   False:12   Observer : 6   False: 4      
 ARC09  : 2     True : 4   True :14   Passenger: 4   True :22      
 ASS09  : 2                           PedLarge : 6                 
 BDB10  : 2                           PedSmall :10                 
 GKR01  : 2                                                        
 GNI09  : 2                                                        
 (Other):14                                                        
        perceivedCar    perceivedIden      Trial              Decision 
 Computer (AV):16    Beobachter:12    cityR   :13   hitPedestrians: 8  
 Mensch       :10    Fußgänger :10    mountain:13   selfSacrifice :18  
                     Mitfahrer : 4                                     
                                                                       
                                                                       
                                                                       
                                                                       
> child.plot <- ggplot(child.data,aes(x = AV.Car,fill = Hit_Large)) +
+     geom_bar(position = "fill") +
+     facet_grid (.~Perspective) +
+     xlab("Driver, Perspective") + ylab("Proportion of responses")
Error in ggplot(child.data, aes(x = AV.Car, fill = Hit_Large)) : 
  could not find function "ggplot"
> library(ggplot2)
> child.plot <- ggplot(child.data,aes(x = AV.Car,fill = Hit_Large)) +
+     geom_bar(position = "fill") +
+     facet_grid (.~Perspective) +
+     xlab("Driver, Perspective") + ylab("Proportion of responses")
> child.plot
Error in combine_vars(data, params$plot_env, cols, drop = params$drop) : 
  At least one layer must contain all variables used for facetting
> child.plot <- ggplot(child.data,aes(x = av.Car,fill = hitChildren)) +
+     geom_bar(position = "fill") +
+     facet_grid (.~perspective) +
+     xlab("Driver, Perspective") + ylab("Proportion of responses")
> child.plot
Error in FUN(X[[i]], ...) : object 'hitChildren' not found
> child.plot <- ggplot(child.data,aes(x = av.Car,fill = Decision)) +
+     geom_bar(position = "fill") +
+     facet_grid (.~perspective) +
+     xlab("Driver, Perspective") + ylab("Proportion of responses")
> child.plot
> summary(child.data)
 participant.ID    male      av.Car      perspective passedSanCheck
 ADB06  : 2     False:22   False:12   Observer : 6   False: 4      
 ARC09  : 2     True : 4   True :14   Passenger: 4   True :22      
 ASS09  : 2                           PedLarge : 6                 
 BDB10  : 2                           PedSmall :10                 
 GKR01  : 2                                                        
 GNI09  : 2                                                        
 (Other):14                                                        
        perceivedCar    perceivedIden         Trial           Decision 
 Computer (AV):16    Beobachter:12    largeGroups:13   hitAdults  :17  
 Mensch       :10    Fußgänger :10    smallGroups:13   hitChildren: 9  
                     Mitfahrer : 4                                     
                                                                       
                                                                       
                                                                       
                                                                       
> child.glmm <- glmer(Decision == "hitChildren" ~ perspective * av.Car + (1|participant.ID) + male, family = "binomial", data=child.data)
Warning messages:
1: In checkConv(attr(opt, "derivs"), opt$par, ctrl = control$checkConv,  :
  unable to evaluate scaled gradient
2: In checkConv(attr(opt, "derivs"), opt$par, ctrl = control$checkConv,  :
   Hessian is numerically singular: parameters are not uniquely determined
> summary(child.glmm)
Generalized linear mixed model fit by maximum likelihood (Laplace
  Approximation) [glmerMod]
 Family: binomial  ( logit )
Formula: 
Decision == "hitChildren" ~ perspective * av.Car + (1 | participant.ID) +  
    male
   Data: child.data

     AIC      BIC   logLik deviance df.resid 
    30.0     42.6     -5.0     10.0       16 

Scaled residuals: 
   Min     1Q Median     3Q    Max 
-1.732  0.000  0.000  0.000  1.000 

Random effects:
 Groups         Name        Variance  Std.Dev. 
 participant.ID (Intercept) 4.147e-16 2.037e-08
Number of obs: 26, groups:  participant.ID, 13

Fixed effects:
                                  Estimate Std. Error z value Pr(>|z|)
(Intercept)                     -1.477e-09  1.414e+00   0.000    1.000
perspectivePassenger             1.036e-08  2.000e+00   0.000    1.000
perspectivePedLarge             -3.683e+01  5.903e+07   0.000    1.000
perspectivePedSmall             -5.851e+05  3.355e+07  -0.017    0.986
av.CarTrue                      -5.305e+01  4.879e+07   0.000    1.000
maleTrue                         7.671e+05  3.676e+07   0.021    0.983
perspectivePassenger:av.CarTrue -1.298e+05  6.806e+07  -0.002    0.998
perspectivePedLarge:av.CarTrue   9.098e+01  7.552e+07   0.000    1.000
perspectivePedSmall:av.CarTrue   1.497e+04  6.638e+07   0.000    1.000

Correlation of Fixed Effects:
            (Intr) prspcP prspPL prspPS av.CrT maleTr pP:.CT pPL:.C
prspctvPssn -0.707                                                 
prspctvPdLr  0.000  0.000                                          
prspctvPdSm  0.000  0.000  0.000                                   
av.CarTrue   0.000  0.000 -0.028  0.000                            
maleTrue     0.000  0.000  0.000  0.000  0.000                     
prspctP:.CT  0.000  0.000  0.020  0.000 -0.717  0.000              
prspcPL:.CT  0.000  0.000 -0.764  0.000 -0.624  0.000  0.447       
prspcPS:.CT  0.000  0.000  0.020 -0.505 -0.735 -0.185  0.527  0.459
convergence code: 0
unable to evaluate scaled gradient
 Hessian is numerically singular: parameters are not uniquely determined

Warning messages:
1: In vcov.merMod(object, use.hessian = use.hessian) :
  variance-covariance matrix computed from finite-difference Hessian is
not positive definite or contains NA values: falling back to var-cov estimated from RX
2: In vcov.merMod(object, correlation = correlation, sigm = sig) :
  variance-covariance matrix computed from finite-difference Hessian is
not positive definite or contains NA values: falling back to var-cov estimated from RX
> carasac.plot <- ggplot(child.data,aes(x = av.Car,fill = Decision)) +
+     geom_bar(position = "fill") +
+     facet_grid (.~perspective) +
+     xlab("Driver, Perspective") + ylab("Proportion of responses")
> carasac.plot <- ggplot(carsac.data,aes(x = av.Car,fill = Decision)) +
+     geom_bar(position = "fill") +
+     facet_grid (.~perspective) +
+     xlab("Driver, Perspective") + ylab("Proportion of responses")
> carsac.plot
Error: object 'carsac.plot' not found
> carsac.plot <- ggplot(carsac.data,aes(x = av.Car,fill = Decision)) +
+     geom_bar(position = "fill") +
+     facet_grid (.~perspective) +
+     xlab("Driver, Perspective") + ylab("Proportion of responses")
> carsac.plot
> 