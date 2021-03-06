/*****************************************************************************
Colombia Senior Grants

Cleaning File
Laura Caron
November 6, 2021

This file cleans and merges the GEIH for 2020 and 2021 through August 

*****************************************************************************/
clear 
global main_directory "C:\Users\laura\OneDrive\Desktop\Laura's computer\Documents\My Own Documents\Research\Colombia Senior Grants\ColombiaMayor" 
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

gen section = "Resto"
capture replace CLASE = clase if !missing(clase)
capture drop clase 
rename *, lower
tempfile Resto 
save `Resto'

clear
capture use "╡rea - Características generales (Personas).dta"
di _rc
if _rc != 0 { 
use "╡rea - Caracteristicas generales (Personas).dta"  
}
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Ocupados.dta", gen(_Aocu)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Desocupados.dta", gen(_Ades)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Fuerza de trabajo.dta", gen(_Afue)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Inactivos.dta", gen(_Aina)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Otras actividades y ayudas en la semana.dta", gen(_Aotr)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Otros ingresos.dta", gen(_Aotri)
	merge m:1 DIRECTORIO SECUENCIA_P using "╡rea - Vivienda y Hogares.dta", gen(_Aviv)

gen section = "Area" 
capture replace CLASE = clase if !missing(clase)
capture drop clase 
rename *, lower
tempfile Area
save `Area'

clear
capture use "Cabecera - Características generales (Personas).dta"
di _rc
if _rc != 0 { 
use "Cabecera - Caracteristicas generales (Personas).dta"
}
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Ocupados.dta", gen(_Cocu)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Desocupados.dta", gen(_Cdes)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Fuerza de trabajo.dta", gen(_Cfue)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Inactivos.dta", gen(_Cina)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Otras actividades y ayudas en la semana.dta", gen(_Cotr)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Otros ingresos.dta", gen(_Cotri)
merge m:1 DIRECTORIO SECUENCIA_P using "Cabecera - Vivienda y Hogares.dta", gen(_Cviv)

gen section = "Cabecera" 
capture replace CLASE = clase if !missing(clase)
capture drop clase 
rename *, lower
append using `Area'
append using `Resto'

compress

rename *, lower

cd "$main_directory"
save "Clean Data/`month'21_m.dta", replace
}


**2020
/**********************
Correct data file errors before merging
**********************/
clear
foreach month in "Abril" "Julio" "Junio" "Marzo" "Mayo"  {
cd "$main_directory/Raw Data/2020/`month'.dta"

	foreach section in "Resto" "╡rea" "Cabecera" {
		foreach file in "`section' - Características generales (Personas)" "`section' - Caracteristicas generales (Personas)" "`section' - Ocupados" "`section' - Desocupados" "`section' - Fuerza de trabajo" "`section' - Inactivos" "`section' - Otras actividades y ayudas en la semana" "`section' - Otros ingresos" "`section' - Vivienda y Hogares" {

		capture use "`file'.dta"
		if _rc == 0{

		rename *, upper
		rename FEX_C_2011 fex_c_2011
		save "Fixed/`file'.dta", replace
			
		}
		clear
		}
	}

}


foreach month in "Abril" "Agosto" "Diciembre" "Enero" "Febrero" "Julio" "Junio" "Marzo" "Mayo" "Noviembre" "Octubre" "Septiembre" {
cd "$main_directory/Raw Data/2020/`month'.dta"

if inlist("`month'", "Abril", "Julio", "Junio", "Marzo", "Mayo") {
	cd "$main_directory/Raw Data/2020/`month'.dta/Fixed"

}

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

* Control case of merging variables if they vary 
global merge_var DIRECTORIO SECUENCIA_P ORDEN

* Merge with each file in turn	
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Ocupados.dta", gen(_Rocu)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Desocupados.dta", gen(_Rdes)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Fuerza de trabajo.dta", gen(_Rfue)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Inactivos.dta", gen(_Rina)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Otras actividades y ayudas en la semana.dta", gen(_Rotr)
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Resto - Otros ingresos.dta", gen(_Rotri)
merge m:1 DIRECTORIO SECUENCIA_P using "Resto - Vivienda y Hogares.dta", gen(_Rviv)

gen section = "Resto"
capture replace CLASE = clase if !missing(clase)
capture drop clase 
rename *, lower

tempfile Resto
save `Resto'

clear
capture use "╡rea - Características generales (Personas).dta"
di _rc
if _rc == 111 {
rename *, lower
use "╡rea - Características generales (Personas).dta"
global merge_var directorio secuencia_p orden
}
if _rc != 0 & _rc != 111 { 
merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Caracteristicas generales (Personas).dta", gen(_Apers)  
}
merge 1:1 $merge_var using "╡rea - Ocupados.dta", gen(_Aocu)
capture merge 1:1 $merge_var using "╡rea - Desocupados.dta", gen(_Ades)
capture merge 1:1 $merge_var using "╡rea - Fuerza de trabajo.dta", gen(_Afue)
if _rc != 0 & _rc != 111 { 
capture merge 1:1 $merge_var using "╡rea- Fuerza de trabajo.dta", gen(_Afue)  
}

capture merge 1:1 $merge_var using "╡rea - Inactivos.dta", gen(_Aina)
capture merge 1:1 $merge_var using "╡rea - Otras actividades y ayudas en la semana.dta", gen(_Aotr)
capture merge 1:1 $merge_var using "╡rea - Otros ingresos.dta", gen(_Aotri)
capture merge m:1 DIRECTORIO SECUENCIA_P using "╡rea - Vivienda y Hogares.dta", gen(_Aviv)
if _rc == 111 {
capture merge 1:1 directorio secuencia_p using "╡rea - Vivienda y Hogares.dta", gen(_Aviv)
}

gen section = "Area" 
capture replace CLASE = clase if !missing(clase)
capture drop clase 
rename *, lower
tempfile Area
save `Area'

clear
capture use "Cabecera - Características generales (Personas).dta"
di _rc
if _rc != 0 { 
use "Cabecera - Caracteristicas generales (Personas).dta"
}
merge 1:1 $merge_var using "Cabecera - Ocupados.dta", gen(_Cocu)
capture merge 1:1 $merge_var using "Cabecera - Desocupados.dta", gen(_Cdes)
merge 1:1 $merge_var using "Cabecera - Fuerza de trabajo.dta", gen(_Cfue)
capture merge 1:1 $merge_var using "Cabecera - Inactivos.dta", gen(_Cina)
capture merge 1:1 $merge_var using "Cabecera - Otras actividades y ayudas en la semana.dta", gen(_Cotr)
capture merge 1:1 $merge_var using "Cabecera - Otros ingresos.dta", gen(_Cotri)
capture merge m:1 DIRECTORIO SECUENCIA_P using "Cabecera - Vivienda y Hogares.dta", gen(_Cviv)
if _rc == 111 {
capture merge 1:1 directorio secuencia_p using "Cabecera - Vivienda y Hogares.dta", gen(_Cviv)
}

gen section = "Cabecera" 
capture replace CLASE = clase if !missing(clase)
capture drop clase 
rename *, lower
append using `Area'
append using `Resto'


rename *, lower
compress

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

save "Clean Data/full_2021.dta", replace

clear
foreach month in "Abril" "Agosto" "Diciembre" "Enero" "Febrero" "Julio" "Junio" "Marzo" "Mayo" "Noviembre" "Octubre" "Septiembre" {
	append using "Clean Data/`month'20_m.dta"
}

gen year = 2020

save "Clean Data/full_2020.dta", replace

/**********************
Variable names
**********************/
global drop_vars p5090s1 p6081-p6083s1 p3147s10a1 p6290s1 p6230 p6240s1 p6310s1 p6410s1 p6430s1 p6480s1 p6780s1 p6810s1 p6830s1 p6880s1 p6915s1 p6980s7a1 p7028s1 p7050s1 p7140s9a1 p7240s1 p7280s1 p7350s1 p7390s1 p7420s7a1 p7450s1 p7458s1

use "Clean Data/full_2020.dta", clear
drop $drop_vars
append using "Clean Data/full_2021.dta"
drop $drop_vars

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
relab p6040 age "Age"
relab p6050 relationship "Relationship to head"
relab p6080 race "Race"
relab p6070 marital "Marital status"

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
relab p6980s5 retire_insure "Paying insurance on your own"
relab p6980s6 retire_children "Preparing your kids to take care of you"
relab p6980s7 retire_other "Other"
relab p6980s8 retire_none "Nothing"

* Unemployed
destring retire_pension1, replace
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
egen hhid = group(directorio secuencia_p section)

egen hh_size_imp = count(hhid), by(hhid)
replace hh_size = hh_size_imp if missing(hh_size)

encode mes, gen(month)

replace colombia_mayor = 0 if missing(colombia_mayor)
replace retire_children = 0 if missing(retire_children)
replace covid_stress = 0 if missing(covid_stress)
/**********************
Income aggregate -- Individual
**********************/
replace p6610s1 = . if p6610s1 == 98
replace p6620s1 = . if p6620s1 == 98

replace p6750 = p6750/p6760

egen labor_income = rowtotal(wages p6590s1 p6600s1 p6610s1 p6620s1 p7070)
replace labor_income = labor_income + p6510s1 if p6510s2 == 2

foreach num of numlist 1(1)4 {
replace p6585s`num'a1 = . if p6585s`num'a1 == 98
replace labor_income = labor_income + p6585s`num'a1 if p6585s`num'a2 == 2	
}


foreach num in "6545" "6580"  {
replace p`num's1 = . if p`num's1 == 98
replace labor_income = labor_income + p`num's1 if p`num's2== 2	
}

foreach num of numlist 1(1)4 {
replace p6630s`num'a1 = . if p6630s`num'a1 == 98
replace labor_income = labor_income + p6630s`num'a1 if !missing(p6630s`num'a1)
}

replace amt_pension = . if amt_pension == 98
replace colombia_mayor_amt = . if colombia_mayor_amt == 98
replace p7500s3a1 = . if p7500s3a1 == 98
replace p7500s1a1 = . if p7500s1a1 == 98
replace p7510s1a1 = . if p7510s1a1 == 98
replace p7510s2a1 = . if p7510s2a1 == 98
replace p7510s3a1 = . if p7510s3a1 == 98
replace p750s2a1 = . if p750s2a1 == 98
replace p750s3a1 = . if p750s3a1 == 98
replace p7510s5a1 = . if p7510s5a1 == 98
replace p7510s6a1 = . if p7510s6a1 == 98
replace p7510s7a1 = . if p7510s7a1 == 98

foreach num of numlist 1 2 {
replace p1661s`num'a1 = . if p1661s`num'a1 == 98
}

replace p1661s4a2 = . if p1661s4a2 == 98


egen other_income = rowtotal(p7500s1a1 amt_pension colombia_mayor_amt p7500s3a1 p7510s1a1 p7510s2a1 p7510s3a1 p750s1a1 p750s2a1 p1661s1a1 p1661s2a1 p1661s4a2 p7510s5a1 p7510s6a1 p7510s7a1)

egen total_income = rowtotal(labor_income other_income)
gen total_income_wo_cm = total_income - colombia_mayor_amt if !missing(colombia_mayor_amt)
	replace total_income_wo_cm = total_income if missing(colombia_mayor_amt)
	
/**********************
Income aggregate -- Household
**********************/
egen hh_inc = total(total_income), by(hhid)
gen hh_inc_pc = hh_inc/hh_size

egen hh_inc_wo_cm = total(total_income_wo_cm), by(hhid)

egen hh_labor_inc = total(labor_income), by(hhid)

gen below_min_wage = hh_labor_inc < 800000
gen below_half_min_wage = hh_labor_inc < 800000/2

gen inc_elig = (below_half_min_wage == 1 & hh_size==1) | (below_min_wage == 1 & hh_size > 1)

//drop inc_elig
//gen inc_elig = (labor_income == 0 & missing(receive_pension) | receive_pension==0)

/**********************
Multidimensional Poverty & Eligibility
**********************/
gen esc15 = esc if age >= 15
egen max_age = max(age), by(hhid)
egen min_age = min(age), by(hhid)
gen only_under15 = (max_age < 15)

* Number of household members over 15
gen temp = 1
replace temp = 0 if age < 15
egen hh_size15 = total(temp), by(hhid)
drop temp

* 1.1 Bajo logro educativo
* Low level of education
egen i1 = mean(esc15), by(hhid)
	
gen d_i1 = (i1 < 9)
	replace d_i1 = 1 if only_under15==1

* 1.2 Analfabetismo
* Illiteracy
replace literate = 0 if literate ==2 
gen literate15 = literate if age >= 15	
egen i2 = total(literate15), by(hhid)
	replace i2 = i2/hh_size15

gen d_i2 = (i2 < 1)
	replace d_i2 = 1 if only_under15==1
	
* 2.1 Inasistencia escolar
* School inattendance
replace student = 0 if student==2 
gen student6_16 = student if age >= 6 & age <= 16

* Number of household members 6-16
gen temp = (age >= 6 & age <= 16)
egen hh_size6_16 = total(temp), by(hhid)
drop temp

egen i3 = total(student6_16), by(hhid)
	replace i3 = i3/hh_size6_16
	
gen d_i3 = (i3 < 1)
	replace d_i3 = 0 if hh_size6_16 == 0

* 2.2 Rezago escolar
* Lack of school

* Number of household members 7-17
gen temp = (age >= 7 & age <= 17)
egen hh_size7_17 = total(temp), by(hhid)
drop temp
gen edu_potential = age-6 if age >=7 & age <=17
gen all_edu = (edu_potential==esc) if age >=7 & age <=17
egen i4 = total(all_edu), by(hhid)
	replace i4 = i4/hh_size7_17

gen d_i4 = (i4 <1)
	replace d_i4 = 0 if hh_size7_17 == 0

* 2.3 Barreras de acceso a servicios para el cuidado de la primera infancia
* Barriers to access to early childhood care services
* We don't have the data for this one 

* 2.4 Trabajo infantil
* Child labor
gen work12_17 = (hours > 0 & !missing(hours)) if age <= 17 & age >= 12
	
* Number of household members 12-17
gen temp = (age >= 12 & age <= 17)
egen hh_size12_17 = total(temp), by(hhid)
drop temp	

egen i5 = total(work12_17), by(hhid)
	replace i5 = i5/hh_size12_17
	
gen d_i5 = (i5 < 1)	
	replace d_i5 = 0 if hh_size12_17 == 0
	
* 3.1 Desempleo de large duracion
* Long-term unemployment
gen unemploy_12m = (p7250 > 12 & !missing(p7250))
gen labor_force = (inlist(primary_activity, 1, 2)) | !missing(contract) | !missing(p7280)

* Number of household members economically active
egen pea = total(labor_force), by(hhid)

* Check if all pensioners
* One case of "Don't know", take to be no pension
replace receive_pension = 0 if receive_pension == 2 | receive_pension == 9
egen total_pensioner = total(receive_pension), by(hhid)
gen all_pensioner = (total_pensioner==hh_size)
	
egen i6 = total(unemploy_12m), by(hhid)
	replace i6 = 1 - i6/pea

gen d_i6 = (i6 < 1)
	replace d_i6 = 1 if (pea == 0 & all_pensioner == 0)

* 3.2 Empleo informal 
replace contribute_pension = 0 if contribute_pension == 2
	replace contribute_pension = 1 if contribute_pension == 3
	
egen i7 = total(contribute_pension), by(hhid)
	replace i7 = i7/pea
	
gen d_i7 = (i7 < 1)
 replace d_i7 = 1 if (pea == 0 & all_pensioner == 0)
	
* 4.1 Sin aseguramiento en salud
* Without health insurance
replace ss_health = 0 if ss_health==2
	replace ss_health = . if ss_health == 9
	
egen i8 = total(ss_health), by(hhid)
	replace i8 = i8/hh_size 

gen d_i8 = (i8 < 1)

* 4.2 Barreras de accesso a serivcios de salud dada una necesidad
* Don't have data for this one

* 5.1 Acceso a fuente de agua mejorada
* Access to improved water source

* There are some missing urban/rural variables, don't use currently
gen urban = (clase == "1")
	replace urban = . if missing(clase)
	replace urban = 0 if section == "Area" //check 
gen i9 = (p4030s5==1) if urban == 1

* Generate whether multidimensional poor or not
* Using cutoff of 3 deprivations
egen total_deprivation = rowtotal(d_i*)
gen multi_poor = (total_deprivation>=3)

pca d_i*
predict index

*Generate education variables
gen no_edu = inlist(education, 1,2)
gen primary = inlist(education, 3)
gen secondary = inlist(education, 4)
gen post_secondary = inlist(education, 5, 6)

* Check performance of index for predicting participation 
reg colombia_mayor index if age > 54
reg colombia_mayor d_i* if age > 54
logit colombia_mayor d_i* i.marital if age > 50 & age < 70

predict predict_treat 
sum predict_treat if colombia_mayor ==1 , det
gen control = (inc_elig & colombia_mayor == 0 & sp_affiliated == 3)
gen treat = (colombia_mayor == 1)
	
* Save cleaned and combined version 
save "Clean Data/full_clean.dta", replace

