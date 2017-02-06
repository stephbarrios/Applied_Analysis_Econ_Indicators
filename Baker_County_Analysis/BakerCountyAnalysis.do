************************************************** 
* January 10, 2017.
* ECO 4934 Applied Analysis of Economic Indicators
************************************************** 

* Dataset:
/* 
  1. Population: https://www.bebr.ufl.edu/data/9085/state/12000-state-florida
  2. Births: https://www.bebr.ufl.edu/data/71/state/12000-state-florida
  3. Deaths: https://www.bebr.ufl.edu/data/156/state/12000-state-florida
*/


* Import delimited data (e.g. CSV format)
/* Reading non-Stata data into memory */
import delimited "\\Client\C$\Users\Stephanie\Desktop\School Stuff\L1_tpopfl.csv", clear

* Browse data
browse 

* Describe data in memory or in file
describe 

* Keep variables
keep series_9085_bebr_population_esti st12000_florida co12003_baker
* Rename variable and label variables
rename st12000_florida Florida
label var Florida "Florida population"
rename co12003_baker Baker
label var Baker "Baker County population"


* Convert string variables to numeric variables
destring Florida Baker, replace

* Generating the variable 'year'
gen year = _n + 1969

/* The _n is built-in Stata variable, and it's Stata notation for the current observation number.
   That is, _n is 1 in the first observation, 2 in the second, 3 in the third, and so on.  */

* Drop variables 
drop series_9085_bebr_population_esti

* Generating the percentage of population
gen sh_Baker = Baker/Florida*100


* Line charts
line sh_Baker year, title("% of Florida's population in Baker Co.")


gen gr_Florida = (Florida - Florida[_n-1])/Florida[_n-1]*100

gen gr_Baker = (Baker - Baker[_n-1])/Baker[_n-1]*100

* Keep variables
keep year Baker gr_Baker 

* Sort data
/* Sort arranges the observations of the current data into ascending order based on the values */
sort year

* Save Stata dataset
save "\\Client\C$\Users\Stephanie\Desktop\School Stuff\temp2.dta", replace


**************************************************
*-> Birth data

import delimited "\\Client\C$\Users\Stephanie\Desktop\School Stuff\L1_births.csv", clear 
keep series_71_births__total co12003_baker
rename co12003_baker Baker_births
gen year = _n + 1988

keep year Baker_births
sort year

* Merge datasets
merge 1:1 year using "\\Client\C$\Users\Stephanie\Desktop\School Stuff\temp2.dta"

/* merge joins corresponding observations from the dataset currently in memory (called the master
   dataset) with those from filename.dta (called the using dataset), matching on one or more key
   variables. */

drop _merge   
sort year 
save "\\Client\C$\Users\Stephanie\Desktop\School Stuff\temp2.dta", replace


**************************************************
*-> Death data

import delimited "\\Client\C$\Users\Stephanie\Desktop\School Stuff\L1_deaths.csv", clear 
keep series_156_deaths__total co12003_baker 
rename co12003_baker Baker_deaths
gen year = _n + 1988

keep year Baker_deaths
sort year

* Merge datasets
merge 1:1 year using "\\Client\C$\Users\Stephanie\Desktop\School Stuff\temp2.dta"

/* merge joins corresponding observations from the dataset currently in memory (called the master
   dataset) with those from filename.dta (called the using dataset), matching on one or more key
   variables. */

drop _merge
sort year 
save "\\Client\C$\Users\Stephanie\Desktop\School Stuff\Florida2.dta", replace


* Generating the population at time t and t+1
rename Baker Bakerpop_t 

gen Bakerpop_t1 = Bakerpop_t[_n+1] 
gen Natural = Baker_births - Baker_deaths
gen Migration = (Bakerpop_t1 - Bakerpop_t) - Natural 

* Decomposing the change in the population
gen Change = Bakerpop_t1 - Bakerpop_t

gen sh_nat = Natural/Change
gen sh_mig = Migration/Change

* Bar charts
graph bar Natural Migration if year>2004, over(year) title("Population Dynamics")





