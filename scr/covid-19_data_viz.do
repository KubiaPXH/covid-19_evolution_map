****---ECONOMETRICS: STATA TIPS-----***
**HOW TO CREATE A DATA MAP WITH STATA**

**Student: Gozde Mavili, Xuan Huy Pham

/* We gonna show you step by step how to create a data map showing the number of COVID-19 confirmed cases in the world,
and then we also make an animated map showing the evolution of the epidemic from Jan 1 to Nov 18 */
/* The commands that we use to draw the map are spshape2dta and spmap */
* Step 1: Prepare the COVID-19 confirmed cases data
* Step 2: Prepare the geographic map and data
* Step 3: Merge these two data sets
* Step 4: Create Data Maps
* Step 5: Generating an animated map (video) using these created maps


**STEP 1: PREPARE THE CONFIRMED CASES DATA**
**We will use the Oxford COVID-19 Government Response Tracker (OxCGRT)
**source: https://raw.githubusercontent.com/OxCGRT/covid-policy-tracker/master/data/OxCGRT_latest.csv
clear

cd "C:\Users\USER\Dropbox\Paris_1\2020-2021\Econ_Sem\Data_Map"

*import the data from csv file
import delimited ./raw/OxCGRT_latest.csv

*there are country with regions (sub-national) data so we drop the regions:
drop if regionname!=""

keep date countryname confirmedcases

rename countryname country

*modify the date format

tostring date, gen(date2)		// string the data variable

gen year = substr(date2,1,4)	// extract year, month, day
gen month = substr(date2,5,2)
gen day = substr(date2,7,2)

destring year month day, replace
drop date date2

gen date = mdy(month,day,year)
format date %tdDD-Mon-yyyy

drop month day year
order country date
sort country date

*interpolate and extrapolate to deal with missing data
ipolate confirmedcases date, by(country) gen(confirmedcases_polated) epolate
replace confirmedcases_polated = 0 if confirmedcases_polated < 0 

drop confirmedcases
rename confirmedcases_polated confirmedcases

drop if date > 22239	// drop all the latest dates due to missing info (22239 = 20 november)

*save the files
compress
save ./data/COVID_confirmedcases.dta, replace

**STEP 2: PREPARE THE GEOGRAPHIC MAP AND DATA**
**Here, we will use the ArcGIS 2020 world country boundaries file
**source: https://hub.arcgis.com/datasets/UIA::uia-world-countries-boundaries
 
*ssc install spshape2dta  // translate shapefiles to dta.
*get the shapefiles
clear
spshape2dta "./GIS/World_Countries__Generalized_.shp", replace saving(world)

use world_shp, clear

*merge world_shp to world to get the country names
merge m:1 _ID using world 
drop if COUNTRY=="Antarctica" 	// drop the polar regions
drop rec_header- _merge    		// drop all unnecessary variables

*sort world_shp data by country id and save change
sort _ID
save world_shp.dta, replace
 
*the first map
use world, clear  
 ren COUNTRY country
 drop if country=="Antarctica"
 
*ssc install spmap    // for the maps package
spmap using world_shp, id(_ID)
 
**STEP 3: MERGE THE DATA SETS**

*change the name of some countries in world data to make them correspondent with that countries'name in COVID data
replace country="Cote d'Ivoire" if country=="Côte d'Ivoire"
replace country="Kyrgyz Republic" if country=="Kyrgyzstan"
replace country="Slovak Republic" if country=="Slovakia"
replace country="Democratic Republic of Congo" if country=="Congo DRC"
replace country="Russia" if country=="Russian Federation"
replace country="Palestine" if country=="Palestinian Territory"

*merge world data with COVID data
merge 1:m country using ./data/COVID_confirmedcases
tab country if _m==1  				// show the unmerged countries in world.dta
tab country if _m==2 				// show the unmerged countries in COVID data
*see exactly how many countries merged
egen tag = tag(country)  			// tag=1 for each country observation
tab _m if tag==1         			// 174 countries merge perfectly.

keep if _m == 3 					// keep only matched countries
drop _merge tag
sort country date

**STEP 4: CREATE DATA MAPS**
forvalues time = 0(7)322 { 			// the time gap between 2 maps is 7 days
	local temp_date = 21915 + `time' // 21915 == Jan 1
	local tostring_date = string(`temp_date', "%tdd-m-yy")
	spmap confirmedcases using ./data/world_shp.dta if date == `temp_date', 			///
		id(_ID)									///
		clmethod(custom)   						///
		clnumber(8)			                    ///
        clbreaks(0 10 100 1000 10000 100000 1000000 10000000 20000000)     ///
        ocolor(black .) fcolor(Heat) osize(vvthin ..)                      ///
		legend(pos(7) size(*1))	///
        title("Confirmed Cases of COVID-19 in the world on `tostring_date'") ///
		note("Data source: Oxford COVID-19 Tracker. Mercator projection used. Antartica dropped from maps." , size(tiny))
	local week = `time'/7 + 1
	local filenum = string(`week',"%03.0f")
    graph export ./graphs/map_`filenum'.png, replace as(png) width(3840) height(2160)
}

**STEP 5: CREATE THE ANIMATED GRAPH WITH FFMPEG**
** download link: https://www.gyan.dev/ffmpeg/builds/
shell "C:\ffmpeg-4.3.1-2020-11-19-full_build\bin\ffmpeg.exe" -framerate 1/1 -i ./graphs/map_%03d.png -c:v libx264 -r 30 -pix_fmt yuv420p covid19_confirmedcases.mp4