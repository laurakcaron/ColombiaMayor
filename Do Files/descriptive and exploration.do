/*****************************************************************************
Colombia Senior Grants

Cleaning File
Laura Caron
November 2021

This file begins exploring the data. 

*****************************************************************************/
clear 
global main_directory "C:\Users\laura\OneDrive\Desktop\Laura's computer\Documents\My Own Documents\Research\Colombia Senior Grants\ColombiaMayor" 
cd "$main_directory"

use "Clean Data/full_clean.dta"

/*********************
Descriptives
*********************/
foreach var in age no_edu primary secondary post_secondary{
	
reg `var' colombia_mayor if age > 50 & age < 70 & (control|treat), robust
}


/*********************
Treatment assignment
*********************/
gen treat_age = age - 59 if sex == 1
	replace treat_age = age - 54 if sex ==2 
	
gen retire_age = age - 62 if sex == 1
	replace retire_age = age - 57 if sex ==2 	

twoway scatter colombia_mayor treat_age if (control|treat) & treat_age >=0 & inrange(treat_age, -20, 20), mcolor("pink%01") || ///
 scatter colombia_mayor treat_age if (control|treat) & treat_age < 0 & inrange(treat_age, -20, 20), mcolor("blue%01") || ///
lpolyci colombia_mayor treat_age if (control|treat) & treat_age >= 0 & inrange(treat_age, -20, 20), clcolor("pink") level(95) kernel(triangle) degree(1) || ///
lpolyci colombia_mayor treat_age if (control|treat) & treat_age < 0 & inrange(treat_age, -20, 20), clcolor("blue") level(95) kernel(triangle) degree(1) ///
legend(off) ytitle("Participation in Colombia Mayor") scheme(s1mono) xtick(-20(5)20) xtitle("Years away from Colombia Mayor eligibility") || ///
qfit colombia_mayor treat_age if (control|treat) & treat_age >= 0 & inrange(treat_age, -20, 20), lcolor("pink") lpattern(dash) || ///
qfit colombia_mayor treat_age if (control|treat) & treat_age < 0 & inrange(treat_age, -20, 20), lcolor("blue") lpattern(dash) ///
note("Graph shows local linear (solid) and quadratic (dashed) fits above and below the Colombia Mayor age" "threshold (59 for men and 54 for women) for the group identified as low-income in this sample." "95% confidence intervals in gray")

twoway scatter colombia_mayor treat_age if (control|treat) & retire_age >=0 & inrange(retire_age, -20, 20), mcolor("pink%01") || ///
 scatter colombia_mayor treat_age if (control|treat) & retire_age < 0 & inrange(retire_age, -20, 20), mcolor("blue%01") || ///
lpolyci colombia_mayor treat_age if (control|treat) & retire_age >= 0 & inrange(retire_age, -20, 20), clcolor("pink") level(95) kernel(triangle) degree(1) || ///
lpolyci colombia_mayor treat_age if (control|treat) & retire_age < 0 & inrange(retire_age, -20, 20), clcolor("blue") level(95) kernel(triangle) degree(1) ///
legend(off) ytitle("Participation in Colombia Mayor") scheme(s1mono) xtick(-20(5)20) xtitle("Years away from retirement") || ///
qfit colombia_mayor treat_age if (control|treat) & retire_age >= 0 & inrange(retire_age, -20, 20), lcolor("pink") lpattern(dash) || ///
qfit colombia_mayor treat_age if (control|treat) & retire_age < 0 & inrange(retire_age, -20, 20), lcolor("blue") lpattern(dash) ///
note("Graph shows local linear (solid) and quadratic (dashed) fits above and below the retirement age" "threshold (62 for men and 57 for women) for the group identified as low-income in this sample." "95% confidence intervals in gray")

twoway lpolyci colombia_mayor treat_age if (control|treat) & retire_age >= 0 & inrange(retire_age, -20, 20), clcolor("pink") level(95) kernel(triangle) degree(1) || ///
lpolyci colombia_mayor treat_age if (control|treat) & retire_age < 0 & inrange(retire_age, -20, 20), clcolor("blue") level(95) kernel(triangle) degree(1) ///
legend(off) ytitle("Participation in Colombia Mayor") scheme(s1mono) xtick(-20(5)20) xtitle("Years away from retirement") || ///
qfit colombia_mayor treat_age if (control|treat) & retire_age >= 0 & inrange(retire_age, -20, 20), lcolor("pink") lpattern(dash) || ///
qfit colombia_mayor treat_age if (control|treat) & retire_age < 0 & inrange(retire_age, -20, 20), lcolor("blue") lpattern(dash) ///
note("Graph shows local linear (solid) and quadratic (dashed) fits above and below the retirement age" "threshold (62 for men and 57 for women) for the group identified as low-income in this sample." "95% confidence intervals in gray")


/*********************
Balance of characteristics
*********************/
cap program drop 
program define balance_plot

twoway lpolyci `1' treat_age if (control|treat) & treat_age >= 0 & inrange(treat_age, -20, 20), clcolor("pink") level(95) kernel(triangle) degree(1) || ///
lpolyci `1' treat_age if (control|treat) & treat_age < 0 & inrange(treat_age, -20, 20), clcolor("blue") level(95) kernel(triangle) degree(1) ///
legend(off) ytitle("`2'") scheme(s1mono) xtick(-20(5)20) xtitle("Years away from Colombia Mayor eligibility") 

end

balance_plot hh_size "Household size"
balance_plot esc "Years of education"


/*********************
Outcome analysis
*********************/

replace covid_afford = 0 if missing(covid_afford)

twoway lpolyci covid_afford treat_age if (control|treat) & treat_age >=0 & inrange(treat_age, -20, 20), lcolor("pink") || ///
 lpolyci covid_afford treat_age if (control|treat) & treat_age <0 & inrange(treat_age, -20, 20), lcolor("blue") legend(off) ytitle("Participation in Colombia Mayor") scheme(s1mono)

gen treat_age_d = (treat_age >= 0)

reg covid_afford c.treat_age##c.treat_age_d, robust
