# ampCountR

[![Build Status](https://travis-ci.org/sherrillmix/ampCountR.svg?branch=master)](https://travis-ci.org/sherrillmix/ampCountR)
[![codecov.io](https://codecov.io/github/sherrillmix/ampCountR/coverage.svg?branch=master)](https://codecov.io/github/sherrillmix/ampCountR?branch=master)


Some R functions to count the expected amplifications for genomic regions given a set of primer binding locations for a [multiple displacement amplification](http://en.wikipedia.org/wiki/Multiple_displacement_amplification) reaction. To install directly from github, use the [<code>devtools</code>](https://github.com/hadley/devtools) library and run:
```
devtools::install_github('sherrillmix/ampCountR')
```

The package assumes that forward primer binding sites (primers matching the genomic plus strand) are represented by their leftmost (5'-most in the genomic plus strand) base position and reverse primer binding sites (primers matching the genomic minus strand) are represented by their rightmost (3'-most in the genomic plus strand) base position.

## Functions

The main functions are:
* <code>countAmplifications(x,y)</code> to count the number of amplifications predicted for a region with <code>x</code> upstream and <code>y</code> downstream primers (within range and correctly oriented). For example:

        countAmplifications(10,20)

* <code>enumerateAmplifications()</code> to list the expected amplification products. For example:
    
        forwards<-c(1,11,21)
        reverses<-c(25,35,45)
        enumerateAmplifications(forwards,reverses,maxLength=50)
    
    A simple example of 3 forward primers and 3 reverse primers is:
    
        forwards<-c(10,20,30)
        reverses<-c(50,60,70)
        frags<-enumerateAmplifications(forwards,reverses,maxLength=120)
        plotFrags(frags)
        abline(v=forwards,lty=2,col='#FF000033')
        abline(v=reverses,lty=2,col='#0000FF33')
    
    This generates predicted fragments of:
    ![Predicted fragments from 3 forward, 3 reverse primers](example3x3primers.png)

    This function is bit slow since it uses recursion without dynamic programming but <code>countAmplifications()</code> should easily handle any large sets.

* <code>predictAmplifications()</code> to list the expected amplification products over a genome given primer binding sites on the forward and reverse strand. For example:

        forwards<-c(1,11,21)
        reverses<-c(25,35,45)
        predictAmplifications(forwards,reverses,maxLength=50)


## Example


A longer example (also accessible from <code>example(ampCountR)</code>:
```R
devtools::install_github('sherrillmix/ampCountR')
library(ampCountR)
forwards<-ampCountR:::generateRandomPrimers(100000,1000)
reverses<-ampCountR:::generateRandomPrimers(100000,1000)
amps<-predictAmplifications(forwards,reverses,maxLength=10000)
par(mar=c(3.5,3.5,.2,.2))
plot(1,1,type='n',xlim=c(1,100000),ylim=c(1,max(amps)),
     xlab='Position',ylab='Amplifications',log='y')
segments(amps$start,amps$amplification,amps$end,amps$amplification)
segments(amps$end[-nrow(amps)],amps$amplification[-nrow(amps)],amps$start[-1],amps$amplification[-1])
abline(v=forwards,col='#FF000044',lty=2)
abline(v=reverses,col='#0000FF44',lty=2)
```
This generates an example predicted fold enrichments of:
![Example of fold enrichment predictions](predictedEnrichmentExample.png)
See [generatePlots.R](generatePlots.R) for complete plotting details.

