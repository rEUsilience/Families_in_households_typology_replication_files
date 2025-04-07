*******************************************************
*** 	European Quality of Life Survey (EQLS) 		***
*******************************************************



/*		
		Author: 		Alzbeta Bartova
						Research Group on Social Policy, Social Work, Public Opinion and Population Dynamics (ReSPOND)
						Center for Sociological Research (CESO)
						KU Leuven, Belgium
		
		Contact: 		alzbeta.bartova@kuleuven.be
		
		Description: 	This code creates household typology based on familial relations (FHT)
						using data from EQLS. 
		
		License: 		
		
		
		Data: 			EQLS Integrated Trend Data File, 2003-2016
						DOI: 10.5255/UKDA-SN-7348-3

		
		Link: 			https://www.eurofound.europa.eu/en/surveys/european-quality-life-surveys-eqls
						Data is available through UKDA (https://ukdataservice.ac.uk/find-data/)
		

		All respondents are 18 years or older.

*/

global DATA "/Users/alzbeta/Documents/Data/EQLS/stata/stata11"
global CODE "/Users/alzbeta/Library/CloudStorage/Box-Box/WORK/_PAPERS/rEUsilience publications/REU_WP2_research note/Families_in_households_typology_replication_files/EQLS"

use "$DATA/eqls_integrated_trend_2003-2016.dta", clear

** generate codebook
/* quietly {
    log using EQLS.txt, text replace
    noisily codebook, compact
    log close
}
*/

*** Data preparation
run "$CODE/FHT_EQLS_dataprep"

*** Identifying relationships
run "$CODE/FHT_EQLS_relationships"

*** FHT
run "$CODE/FHT_EQLS_typology"



save "$DATA/EQLS_2003-2016_FHT", replace






