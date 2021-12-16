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

capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Ocupados.dta", gen(_Aocu)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Desocupados.dta", gen(_Ades)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Fuerza de trabajo.dta", gen(_Afue)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Inactivos.dta", gen(_Aina)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Otras actividades y ayudas en la semana.dta", gen(_Aotr)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Otros ingresos.dta", gen(_Aotri)
capture merge m:1 DIRECTORIO SECUENCIA_P using "╡rea - Vivienda y Hogares.dta", gen(_Aviv)

replace section = "Area" if missing(section)

capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Ocupados.dta", gen(_Cocu)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Desocupados.dta", gen(_Cdes)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Fuerza de trabajo.dta", gen(_Cfue)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Inactivos.dta", gen(_Cina)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Otras actividades y ayudas en la semana.dta", gen(_Cotr)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Otros ingresos.dta", gen(_Cotri)
capture merge m:1 DIRECTORIO SECUENCIA_P using "Cabecera - Vivienda y Hogares.dta", gen(_Cviv)

replace section = "Cabecera" if missing(section)

compress

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

gen section = "Resto"

capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Ocupados.dta", gen(_Aocu)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Desocupados.dta", gen(_Ades)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Fuerza de trabajo.dta", gen(_Afue)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Inactivos.dta", gen(_Aina)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Otras actividades y ayudas en la semana.dta", gen(_Aotr)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "╡rea - Otros ingresos.dta", gen(_Aotri)
capture merge m:1 DIRECTORIO SECUENCIA_P using "╡rea - Vivienda y Hogares.dta", gen(_Aviv)

replace section = "Area" if missing(section)

capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Ocupados.dta", gen(_Cocu)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Desocupados.dta", gen(_Cdes)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Fuerza de trabajo.dta", gen(_Cfue)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Inactivos.dta", gen(_Cina)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Otras actividades y ayudas en la semana.dta", gen(_Cotr)
capture merge 1:1 DIRECTORIO SECUENCIA_P ORDEN using "Cabecera - Otros ingresos.dta", gen(_Cotri)
capture merge m:1 DIRECTORIO SECUENCIA_P using "Cabecera - Vivienda y Hogares.dta", gen(_Cviv)

replace section = "Cabecera" if missing(section)

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
global drop_vars P5090S1 P6081-P6083S1 P3147S10A1 P6290S1 P6230 P6240S1 P6310S1 P6410S1 P6430S1 P6480S1 P6780S1 P6810S1 P6830S1 P6880S1 P6915S1 P6980S7A1 P7028S1 P7050S1 P7140S9A1 P7240S1 P7280S1 P7350S1 P7390S1 P7420S7A1 P7450S1 P7458S1

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
encode mes, gen(month)
* Generate individual income
 

* Generate household income


replace colombia_mayor = 0 if missing(colombia_mayor)
replace retire_children = 0 if missing(retire_children)
replace covid_stress = 0 if missing(covid_stress)

/**********************
Multidimensional Poverty & Eligibility
**********************/
egen hhid = group(directorio secuencia_p)
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
replace clase = CLASE if missing(clase)
gen urban = (clase == "1")
	replace urban = . if missing(clase)
	replace urban = 0 if section == "Area" //check 
gen i9 = (p4030s5==1) if urban == 1

* Generate whether multidimensional poor or not
* Using cutoff of 3 deprivations
egen total_deprivation = rowtotal(d_i*)
gen multi_poor = (total_deprivation>3)
	
* Save cleaned and combined version 
save "Clean Data/full_clean.dta", replace

