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
tabstat age if colombia_mayor==1, by(mes) stat(mean min p25 p50 p75 max N)

tabstat retire_children, by(colombia_mayor) stat(mean min p25 p50 p75 max N)