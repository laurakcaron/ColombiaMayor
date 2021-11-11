/*****************************************************************************
Colombia Senior Grants

Cleaning File
Laura Caron
November 6, 2021

This file cleans and merges the GEIH for 2020 and 2021 through August 

*****************************************************************************/
clear 
global main_directory "C:\Users\laura\OneDrive\Desktop\Laura's computer\Documents\My Own Documents\Research\Colombia Senior Grants" 
cd "$main_directory"


**2021 
foreach month in "Abril" "Agosto" "Enero" "Febrero" "Julio" "Junio" "Marzo" "Mayo" {
clear
cd "$main_directory/Raw Data/2021/`month'.dta"

/**********************
Append within-month-section
**********************/
* First append the data from each area
capture use "Resto - Características generales (Personas).dta"
//append using "Cabecera - Características generales (Personas).dta"
//append using "╡rea - Características generales (Personas).dta"
di _rc
if _rc != 0 { 
use "Resto - Caracteristicas generales (Personas).dta"  
}

/**********************
Merge sections within-month
**********************/

* Drop some duplicated observations
cap drop if missing(CLASE)

* Merge with each file in turn	
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Ocupados.dta", gen(_Rocu)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Desocupados.dta", gen(_Rdes)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Fuerza de trabajo.dta", gen(_Rfue)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Inactivos.dta", gen(_Rina)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Otras actividades y ayudas en la semana.dta", gen(_Rotr)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Otros ingresos.dta", gen(_Rotri)
merge m:1 DIRECTORIO SECUENCIA_P using "Resto - Vivienda y Hogares.dta", gen(_Rviv)

//append using "╡rea - Fuerza de trabajo.dta"
//append using "╡rea - Ocupados.dta"

//append using "Cabecera - Fuerza de trabajo.dta"
//append using "Cabecera - Ocupados.dta"

cd "$main_directory"
save "Clean Data/`month'21_m.dta", replace
}


**2020

foreach month in "Abril" "Agosto" "Diciembre" "Enero" "Febrero" "Julio" "Junio" "Marzo" "Mayo" "Noviembre" "Octubre" "Septiembre" {
cd "$main_directory/Raw Data/2020/`month'.dta"

/**********************
Append within-month-section
**********************/
* First append the data from each area
capture use "Resto - Características generales (Personas).dta"
//append using "Cabecera - Características generales (Personas).dta"
//append using "╡rea - Características generales (Personas).dta"
di _rc
if _rc != 0 { 
use "Resto - Caracteristicas generales (Personas).dta"  
}
/**********************
Merge sections within-month
**********************/

* Drop some duplicated observations
cap drop if missing(CLASE)

* Merge with each file in turn	
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Ocupados.dta", gen(_Rocu)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Desocupados.dta", gen(_Rdes)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Fuerza de trabajo.dta", gen(_Rfue)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Inactivos.dta", gen(_Rina)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Otras actividades y ayudas en la semana.dta", gen(_Rotr)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Otros ingresos.dta", gen(_Rotri)
merge m:1 DIRECTORIO SECUENCIA_P using "Resto - Vivienda y Hogares.dta", gen(_Rviv)

//append using "╡rea - Fuerza de trabajo.dta"
//append using "╡rea - Ocupados.dta"

//append using "Cabecera - Fuerza de trabajo.dta"
//append using "Cabecera - Ocupados.dta"

cd "$main_directory"
save "Clean Data/`month'20_m.dta", replace
}

/**********************
Merge months
**********************/
use "Clean Data/Abril21_m.dta", clear
foreach month in "Agosto" "Enero" "Febrero" "Julio" "Junio" "Marzo" "Mayo" {
	append using "Clean Data/`month'21_m.dta"

}
gen year = 2021

foreach month in "Abril" "Agosto" "Diciembre" "Enero" "Febrero" "Julio" "Junio" "Marzo" "Mayo" "Noviembre" "Octubre" "Septiembre" {
	append using "Clean Data/`month'20_m.dta"
}

replace year = 2020 if missing(year)



/**********************
Variable names
**********************/

* Convert to lowercase
foreach var of varlist _all {
  capture rename `var' `=lower("`var'")'
}

* Begin labeling

* Renaming and labeling of personal characteristics variables 
* Manually for important variables

cap program drop relab
program define relab
	args var_old var_new lab
	
rename `var_old' `var_new'
label var `var_new' "`lab'"
end	

relab p6020 sex "Sex"
relab p6030s1 birth_month "Birth month"
relab p6030s3 birth_year "Birth year"
relab p6050 relationship "Relationship to head"
relab p6080 race "Race"
relab p6070 marital "Marital status"
relab p6081s1 father_line "Line number of father"
relab p6083s1 mother_line "Line number of mother"
relab p6071s1 spouse_line "Line number of spouse"

* Covid coping
relab p3147s1 covid_infected "Infected with covid"
relab p3147s2 covid_obtain "Problems obtaining food or cleaning products"
relab p3147s3 covid_afford "Couldn't pay for bills or debt"
relab p3147s4 covid_income "Reduced economic adcitivty and income"
relab p3147s5 covid_work "Couldn't work, look for work, or start a business"
relab p3147s6 covid_payloss "Have had suspended pay from work contract"
relab p3147s7 covid_jobloss "Have lost job or source of income"
relab p3147s8 covid_school "Suspension of in-person classes"
relab p3147s9 covid_stress "Feel alone, stress, worried, or depressed"
relab p3147s10 covid_other "Other difficulty"
relab p3147s11 covid_none "No difficulties"

* Poverty and Health
relab p3246 self_poor "Do you consider yourself poor?"
relab p6090 ss_health "Are you affiliated with, contributor to, or beneficiary of social security for health?"

relab p6125 health_afford "In the last 12 months, did you avoid the doctor or hospital because you couldn't pay for it with the EPS or ARS?"

* Education 
relab p6160 literate "Know how to read and write"
relab p6170 student "Do you currently attend school?"
relab p6175 student_official "Is the school that you attend official?"
relab p6210 education "Highest level of education reached"
relab p6210s1 grade "Highest grad reached"
relab p6220 diploma "Highest diploma reached"

* Survey variables
label var area "Area"
label var mes "Month of survey"

* Labor force
relab p6100 sp_affiliated "Which of the following social security programs are you affiliated with?"
relab p6240 primary_activity "What activity took up most of your time last week?"
relab p6250 also_paid "In addition to the above, did you work for pay for an hour or more last week?"
relab p6270 unpaid_work "Did you work last week for a business without pay?"
relab p6280 look_work "In the last four weeks, did you look for work or look to start a business?"
relab p6300 want_work "Do you want to get a paid job or start a business?"

* Employed
relab p6440 contract "Do you have some type of contract for this job?"
relab p6450 type_contract "Is it verbal or written?"
relab p6460 fixed_contract "Is it indefinite or for a fixed term?"
relab p6424s1 paid_vacation "On your contract, do you have paid vacations?"
relab p6424s3 right_severance "Do you have the right to severance pay?"
relab p6426 tenure "How long have you been owrking here continuously (months)?"
relab p6500 wages "Before deductions, how much did you earn this month in this job?"

relab p6800 hours "How many hours do you normally work in a week?"
relab p6870 firmsize "How many workers does the firm have in total?"
relab p6920 contribute_pension "Do you contribute to a pension?"

relab p6980s1 retire_pension1 "What are you doing for retirement? Contribute to pension mandatory"
relab p6980s2 retire_pension2 "What are you doing for retirement? Contribute to pension voluntary"
relab p6980s3 retire_saving "Saving"
relab p6980s4 retire_invest "Investing"
relab p6980s5 reitre_insure "Paying insurance on your own"
relab p6980s6 retire_children "Preparing your kids to take care of you"
relab p6980s7 retire_other "Other"
relab p6980s8 retire_none "Nothing"

* Unemployed
replace retire_pension1 = p7420s1
replace retire_pension2 = p7420s2
replace retire_saving = p7420s3
replace retire_invest = p7420s4
replace retire_insure = p7420s5
replace retire_children = p7420s6
replace retire_other = p7420s7
replace retire_none = p7420s8

destring retire*, replace

* Other activities
relab p7480s5 childcare "Did you do childcare last week?"
relab p7480s5a1 childcare_hours "How many unpaid hours did you spend caring for children last week?"
relab p7480s6 eldercare "Did you care for the eldery or disabled last week?"
relab p7480s6a1 eldercare_hours "How many unpaid hours did you spend caring for eldery/disabled last week?"

* Other income
relab p7495 other_inc "In the last month, did you receive any rents or pensions?"
relab p7500s2 receive_pension "Did you receive a pension for old age, disability, etc?"
relab p7500s2a1 amt_pension "How much was the pension?"
relab p7510s3 receive_aid "In the last year, did you receive money from institutions in or out of the country?"
relab p1661s3 colombia_mayor "The money was from Colombia mayor"
relab p1661s3a1 colombia_mayor_amt "Amount from Colombia mayor"

* House and household
relab p5210s3 service_internet "Does this household have internet service?"
relab p5220 own_mobile "Does anyone in this house have their own cell phone?"
relab p5220s1 own_mobile_num "How many in this house have their own cell phone?"

relab p6008 hh_size "Number of people in the household"
relab p4030s1 service_electricity "Does this housheold have eletricity service?"

/**********************
Cleaning
**********************/
replace colombia_mayor = 0 if missing(colombia_mayor)
replace retire_children = 0 if missing(retire_children)
replace covid_stress = 0 if missing(covid_stress)
encode mes, gen(month)
gen age = 2020 - birth_year if year == 2020
replace age = 2021 - birth_year if year == 2021

* Save cleaned and combined version 
save "Clean Data/full_clean.dta", replace

/*********************
Descriptives
*********************/
tabstat age if colombia_mayor==1, by(mes) stat(mean min p25 p50 p75 max N)

tabstat retire_children, by(colombia_mayor) stat(mean min p25 p50 p75 max N)
