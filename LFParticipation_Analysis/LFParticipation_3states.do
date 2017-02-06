*****************************************************
*David Gomez Villa 
*Prof. Sandoval
*ECO4934
*****************************************************

**************ASSIGMENT #2***************************

* Dataset:
/* 
  1. Labor force: https://www.bebr.ufl.edu/data/2028/state/12000-state-florida
  2. Unemployment: https://www.bebr.ufl.edu/data/2030/state/12000-state-florida
  3. State wide data: https://www.bls.gov/lau/rdscnp16.htm 
*/


* Change drive command  
cd "C:\Users\davidagv\Downloads"

* Import Excel data 
/* Reading non-Stata data into memory */
import excel L2_statedata.xlsx, sheet("data") firstrow clear


* Browse data
browse 

* Tabulate data
tabulate state, m
tabulate fips, m
/* Federal Information Processing Standard (FIPS) code */

* Drop observation 
drop if fips=="037" | fips=="51000"

tab fips, m

* Constructing labor market indicators 

gen lfprate = lforce/noninst_pop*100
label var lfprate "Labor force participation rate"

gen epratio = employed/noninst_pop*100
label var epratio "Employment-Population ratio"

gen urate = unemployed/lforce*100
label var urate "Unemployment rate"


* Generating a variable for recession
gen recession = 0
replace recession = 1 if year==1970 | year==1974 | year==1980 | year==1982 | /// 
                         year==2001 | year==2008 | year==2009
label var recession "NBER designation of a recession"

tab recession, m

* Creating label for values
label define rec 0 "No recession" 1 "Recession"
label values recession rec

tab recession, m


* Trends in the LFP rate
************************

*LF graph
line lfprate year if (state=="Illinois" & year>=1995) || ///
line lfprate year if (state=="Michigan" & year>=1995) || ///
line lfprate year if (state=="Wisconsin" & year>=1995), ///
xlabel(1995(2)2015) title("Labor Force Participation Rate") ///
legend(label(1 "LFPR Illinois") label(2 "LFPR Michigan") label(3 "LFPR Wisconsin"))

*URate graph
line urate year if (state=="Illinois" & year>=1995) || ///
line urate year if (state=="Michigan" & year>=1995) || ///
line urate year if (state=="Wisconsin" & year>=1995), ///
xlabel(1995(2)2015) title("Unemployment Rate") ///
legend(label(1 "Urate Illinois") label(2 "Urate Michigan") label(3 "Urate Wisconsin"))

* Tables 
*********************

* Descriptive statistics (2 commands)

tabstat lfprate if state=="Illinois" | state=="Michigan" | state=="Wisconsin", stats(n min p25 median p75 max mean sd) by(state) 
tabstat urate if state=="Illinois" | state=="Michigan" | state=="Wisconsin", stats(n min p25 median p75 max mean sd) by(state) 
