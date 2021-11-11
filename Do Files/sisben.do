/*****************************************************************************
SISBEN

Laura Caron
November 2021

*****************************************************************************/
clear 
global main_directory "C:\Users\laura\OneDrive\Desktop\Laura's computer\Documents\My Own Documents\Research\Colombia Senior Grants\ColombiaMayor" 
cd "$main_directory"

* Merge all levels of the data
use "Raw Data\SISBEN\SISBEN_PERS_SIV_2021"

merge m:1 llave hogar cod_mpio using "Raw Data\SISBEN\SISBEN_HOG_SIV_2021", gen(_mHog)
merge m:1 zona llave corte cod_mpio using "Raw Data\SISBEN\SISBEN_VIV_SIV_2021", gen(mViv)

