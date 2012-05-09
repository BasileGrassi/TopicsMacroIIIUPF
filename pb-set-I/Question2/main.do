
clear
cd "/home/basilou/TopicsMacroIIIUPF/pb-set-I/Question2"
set memory 500m

use firms_in_catland_stata910, clear


*Declarration of panel data
xtset id year

*Takes the log
generate lnoutput= ln(output)
recode lnoutput .=0
generate lncapital= ln(capital)
recode lncapital .=0
generate lnlabor= ln(labor)
recode lnlabor .=0
generate lninv=ln(inv)
recode lninv .=0

*QUESTION 2b
*OLS regression of capital and labor on output (in log)
regress lnoutput lncapital lnlabor 

*QUESTION 2c
*Estimation controlling for the simulataneity and the selection bias as in Olley and Pakes (1996)
opreg  lnoutput,  exit(exit) state(lncapital) proxy(lninv) free(lnlabor) vce(bootstrap, reps(10))

*QUESTION 2d
*Compute TFP in level
predict lntfp, tfp
generate tfp = (1-exit)*exp(lntfp)

*Correlation of tfp and size
 correlate tfp output
 
 *QUESTION 2e
 *Compute tfp growth rate at firm level
  generate gtfp=(1-exit)*d.tfp/l.tfp
 
 *Summary statistics on TFP gronth rate distribution
 summarize gtfp, detail
 
 *QUESTION 2f
 *Compute Output share
 egen sum_output=sum(output), by(year)
 generate output_share=output/sum_output
  
 *Compute aggregate productivity
 egen agg_tfp= sum(output_share*tfp), by(year) 
 ta year agg_tfp
 
 
 *QUESTION 2g
 *Compute the unweighted average of tfp
egen tfpbar= mean(tfp), by(year)
egen sharebar= mean(output_share), by(year)

*Compute the covariance between pdty and output
generate Dshare=   output_share - sharebar
generate Dtfp= tfp-tfpbar
egen covtfpout = sum(Dshare*Dtfp*(1-exit)), by(year)

*Compute the correlation between capital and tfp
*Warning, this will install the egenmore package which extend the egen function
ssc install egenmore
sort year
egen corr_capital_tfp = corr(tfp capital), by(year)
sort id year
