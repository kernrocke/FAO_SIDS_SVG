

clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		FAO_macro_003.do
**  Project:      	ICOFAN Presentation
**	Sub-Project:	Eden Augustus Presentation
**  Analyst:		Kern Rocke
**	Date Created:	14/01/2020
**	Date Modified: 	18/01/2020
**  Algorithm Task: Developing Time-Series Plots for Seminar 1 (Food Supply kcal)


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
*Food Supply (kcals)

keep value7 area year

collapse (sum) value7, by(year area)
rename value7 grand_total_

reshape wide grand_total_, i(year) j(area) 

tsset year, yearly
rename grand_total_1 SVG
rename grand_total_2 SIDS

lowess SVG year, gen(SVG_1)nog
lowess SIDS year, gen(SIDS_1)nog

#delimit;
twoway (tsline SVG_1)
	   (tsline SIDS_1)

	   , 
	   
	   name(kcal)
	   title("Food Supply (kcal/capita/day)", size(medium) color(black))
	   ytitle("kcal/capita/day", margin(small))
	   plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
	   graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
	   ylabel(#10, nogrid angle(horizontal))
	   legend(size(small)  cols(1)
				region(fcolor(gs16) lw(vthin) ) 
				order(1 2)
				lab(1 "Saint Vincent and the Grenadines")
				lab(2 "Small Island Developing States")

				)
	   tlabel(1961(6)2018 2018, angle(forty_five))
	  ;
	  
#delimit cr


*Graph Export
graph export "`datapath'/Manuscripts/FAO_ICOFAN_2/Graphs/SVG_SIDS_kcal.png", as(png) replace
