


cd "/home/basilou/git/TopicsMacroIIIUPF/pb-set-I/Question2"

use firms_in_catland_stata910, clear



xtset id year


generate lnoutput= ln(output)
recode lnoutput .=0
generate lncapital= ln(capital)
recode lncapital .=0
generate lnlabor= ln(labor)
recode lnlabor .=0
generate lninv=ln(inv)
recode lninv .=0


*OLS regression of capital and labor on output (in log)
regress lnoutput lncapital lnlabor 


*Estimation controlling for the simulataneity and the selection bias as in Olley and Pakes (1996)
opreg  lnoutput  exit(exit) state(lncapital) proxy(lninv) free(lnlabor) 
