clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		FAO_macro_002.do
**  Project:      	ICOFAN Presentation
**	Sub-Project:	Eden Augustus Presentation
**  Analyst:		Kern Rocke
**	Date Created:	14/01/2020
**	Date Modified: 	18/01/2020
**  Algorithm Task: Developing Time-Series Plots for Seminar 1 (Import vs production)


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150


*Setting working directory

*-------------------------------------------------------------------------------
** Dataset to encrypted location

** Set working directories: this is for DATASET and LOG files
local datapath "/Users/kernrocke/OneDrive - The University of the West Indies"

*-------------------------------------------------------------------------------

*Load in data first set of data (1961-2013)
import delimited "`datapath'/Manuscripts/FAO_ICOFAN_2/Data/FAOSTAT_data_1-17-2021 (4).csv", clear

*Save dataset 
save "`datapath'/Manuscripts/FAO_ICOFAN_2/Data/FAO_ICOFAN_1.dta", replace

*Load in data second set of data (2014-2018)
import delimited "`datapath'/Manuscripts/FAO_ICOFAN_2/Data/FAOSTAT_data_1-17-2021 (3).csv", clear

*Save dataset 
save "`datapath'/Manuscripts/FAO_ICOFAN_2/Data/FAO_ICOFAN_2.dta", replace

*Join Datasets together
append using "`datapath'/Manuscripts/FAO_ICOFAN_2/Data/FAO_ICOFAN_1.dta"

encode item, gen(item_1)
drop item
rename item_1 item
tab item
/*
                    Item |      Freq.     Percent        Cum.
-------------------------+-----------------------------------
         Animal Products |        116        2.17        2.17
             Animal fats |        464        8.66       10.83
Cereals - Excluding Beer |        464        8.66       19.49
                    Eggs |        464        8.66       28.16
           Fish, Seafood |        464        8.66       36.82
 Fruits - Excluding Wine |        464        8.66       45.48
             Grand Total |        116        2.17       47.65
                    Meat |        464        8.66       56.31
 Milk - Excluding Butter |        464        8.66       64.97
                  Pulses |        464        8.66       73.64
           Starchy Roots |        464        8.66       82.30
      Sugar & Sweeteners |        464        8.66       90.96
             Sugar Crops |         20        0.37       91.34
              Vegetables |        464        8.66      100.00
-------------------------+-----------------------------------




*/
encode element, gen(element_1)
drop element
rename element_1 element
tab element
/*
        Element |      Freq.     Percent        Cum.
----------------+-----------------------------------
Import Quantity |        377       48.15       48.15
     Production |        406       51.85      100.00
----------------+-----------------------------------
          Total |        783      100.00
		  
		  
/*
                            Element |      Freq.     Percent        Cum.
------------------------------------+-----------------------------------
      Food supply (kcal/capita/day) |      1,513       28.25       28.25
Food supply quantity (kg/capita/yr) |      1,281       23.92       52.17
                    Import Quantity |      1,281       23.92       76.08
                         Production |      1,281       23.92      100.00
------------------------------------+-----------------------------------
                              Total |      5,356      100.00

*/

*/

encode area, gen(area_1)
drop area
rename area_1 area

separate value, by(item)

*-------------------------------------------------------------------------------
*SVG
preserve
*Keep SVG
keep if area == 1
*Keep Import Quantity
keep if element == 3

collapse (sum) value*, by(year)
rename value1 animal_products
rename value2 fats
rename value3 cereals
rename value4 eggs
rename value5 fish
rename value6 fruits
rename value7 grand_total
rename value8 meat
rename value9 milk
rename value10 pulses
rename value11 roots
rename value12 sugar
rename value13 sugar_crops
rename value14 veg

foreach x in eggs fish fruits pulses roots sugar_crops veg milk meat {
 lowess `x' year, gen(`x'_1)nog
 }

tsset year, yearly

#delimit;
twoway (tsline eggs_1)
	   (tsline fish_1)
	   (tsline fruits_1)
	   (tsline pulses_1)
	   (tsline roots_1)
	   (tsline sugar_crops_1)
	   (tsline veg_1)
	   (tsline milk_1)
	   (tsline meat_1)
	   , 
	   
	   name(SVG_import)
	   title("Import Quantity", size(medium) color(black))
	   ytitle("Per 1000 tonnes", margin(small))
	   plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
	   graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
	   ylabel(#10, nogrid angle(horizontal))
	   legend(size(small)  cols(2)
				region(fcolor(gs16) lw(vthin) ) 
				order(1 2 3 4 5 6 7 8 9)
				lab(1 "Eggs")
				lab(2 "Fish, Seafood")
				lab(3 "Fruits")
				lab(4 "Pulses")
				lab(5 "Starchy Roots")
				lab(6 "Sugar Crops")
				lab(7 "Vegetables")
				lab(8 "Milk")
				lab(9 "Meat")
				)
	   tlabel(1961(6)2018 2018, angle(forty_five))
	  ;
	  
#delimit cr
restore
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
preserve
*Keep SVG
keep if area == 1
*Keep Production
keep if element == 4

collapse (sum) value*, by(year)
rename value1 animal_products
rename value2 fats
rename value3 cereals
rename value4 eggs
rename value5 fish
rename value6 fruits
rename value7 grand_total
rename value8 meat
rename value9 milk
rename value10 pulses
rename value11 roots
rename value12 sugar
rename value13 sugar_crops
rename value14 veg

foreach x in eggs fish fruits pulses roots sugar_crops veg milk meat {
 lowess `x' year, gen(`x'_1)nog
 }
tsset year, yearly

#delimit;
twoway (tsline eggs_1)
	   (tsline fish_1)
	   (tsline fruits_1)
	   (tsline pulses_1)
	   (tsline roots_1)
	   (tsline sugar_crops_1)
	   (tsline veg_1)
	   (tsline milk_1)
	   (tsline meat_1)
	   , 
	   
	   name(SVG_production)
	   title("Production", size(medium) color(black))
	   ytitle("Per 1000 tonnes", margin(small))
	   plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
	   graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
	   ylabel(#10, nogrid angle(horizontal))
	   legend(size(small)  cols(2)
				region(fcolor(gs16) lw(vthin) ) 
				order(1 2 3 4 5 6 7 8 9)
				lab(1 "Eggs")
				lab(2 "Fish, Seafood")
				lab(3 "Fruits")
				lab(4 "Pulses")
				lab(5 "Starchy Roots")
				lab(6 "Sugar Crops")
				lab(7 "Vegetables")
				lab(8 "Milk")
				lab(9 "Meat")
				)
	   
	   tlabel(1961(6)2018 2018, angle(forty_five))
	  ;
	  
#delimit cr
restore
*-------------------------------------------------------------------------------

*Combine graphs
#delimit;
graph combine SVG_import SVG_production,
		title("Import Quantity vs Production in" "Saint Vincent and the Grenadines", size(medium) color(black))
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
		name(Import_Pro_SVG, replace)
		
		;
#delimit cr

*Graph Export
graph export "`datapath'/Manuscripts/FAO_ICOFAN_2/Graphs/Import_Production_SVG.png", as(png) replace
*-------------------------------------------------------------------------------
*Remove older graphs
graph drop SVG_import SVG_production

*-------------------------------------------------------------------------------
*SIDS

preserve
*Keep SIDS
keep if area == 2
*Keep Import Quantity
keep if element == 3

collapse (sum) value*, by(year)
rename value1 animal_products
rename value2 fats
rename value3 cereals
rename value4 eggs
rename value5 fish
rename value6 fruits
rename value7 grand_total
rename value8 meat
rename value9 milk
rename value10 pulses
rename value11 roots
rename value12 sugar
rename value13 sugar_crops
rename value14 veg

foreach x in eggs fish fruits pulses roots sugar_crops veg milk meat{
 lowess `x' year, gen(`x'_1)nog
 }

tsset year, yearly

#delimit;
twoway (tsline eggs_1)
	   (tsline fish_1)
	   (tsline fruits_1)
	   (tsline pulses_1)
	   (tsline roots_1)
	   (tsline sugar_crops_1)
	   (tsline veg_1)
	   (tsline milk_1)
	   (tsline meat_1)
	   , 
	   
	   name(SIDS_import)
	   title("Import Quantity", size(medium) color(black))
	   ytitle("Per 1000 tonnes", margin(small))
	   plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
	   graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
	   ylabel(#10, nogrid angle(horizontal))
	   legend(size(small)  cols(2)
				region(fcolor(gs16) lw(vthin) ) 
				order(1 2 3 4 5 6 7 8 9)
				lab(1 "Eggs")
				lab(2 "Fish, Seafood")
				lab(3 "Fruits")
				lab(4 "Pulses")
				lab(5 "Starchy Roots")
				lab(6 "Sugar Crops")
				lab(7 "Vegetables")
				lab(8 "Milk")
				lab(9 "Meat")
				)
	   tlabel(1961(6)2018 2018, angle(forty_five))
	  ;
	  
#delimit cr
restore
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
preserve
*Keep SIDS
keep if area == 2
*Keep IProduction
keep if element == 4

collapse (sum) value*, by(year)
rename value1 animal_products
rename value2 fats
rename value3 cereals
rename value4 eggs
rename value5 fish
rename value6 fruits
rename value7 grand_total
rename value8 meat
rename value9 milk
rename value10 pulses
rename value11 roots
rename value12 sugar
rename value13 sugar_crops
rename value14 veg

foreach x in eggs fish fruits pulses roots sugar_crops veg milk meat {
 lowess `x' year, gen(`x'_1)nog
 }

tsset year, yearly

#delimit;
twoway (tsline eggs_1)
	   (tsline fish_1)
	   (tsline fruits_1)
	   (tsline pulses_1)
	   (tsline roots_1)
	   (tsline sugar_crops_1)
	   (tsline veg_1)
	   (tsline milk_1)
	   (tsline meat_1), 
	   
	   name(SIDS_production)
	   title("Production", size(medium) color(black))
	   ytitle("Per 1000 tonnes", margin(small))
	   plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
	   graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
	   ylabel(#10, nogrid angle(horizontal))
	   legend(size(small)  cols(2)
				region(fcolor(gs16) lw(vthin) ) 
				order(1 2 3 4 5 6 7 8 9)
				lab(1 "Eggs")
				lab(2 "Fish, Seafood")
				lab(3 "Fruits")
				lab(4 "Pulses")
				lab(5 "Starchy Roots")
				lab(6 "Sugar Crops")
				lab(7 "Vegetables")
				lab(8 "Milk")
				lab(9 "Meat")
				)
	   
	   tlabel(1961(6)2018 2018, angle(forty_five))
	  ;
	  
#delimit cr
restore
*-------------------------------------------------------------------------------

*Combine graphs
#delimit;
graph combine SIDS_import SIDS_production,
		title("Import Quantity vs Production in" "Small Island Developing States", size(medium) color(black))
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
		name(Import_Pro_SIDS, replace) 
		
		;
#delimit cr

*Graph Export
graph export "`datapath'/Manuscripts/FAO_ICOFAN_2/Graphs/Import_Production_SIDS.png", as(png) replace
*-------------------------------------------------------------------------------
*Remove older graphs
graph drop SIDS_import SIDS_production

*-------------------------------------------------------------------------------
