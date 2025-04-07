******************
*** HBS LABELS ***
******************


*** Household level

lab var HA04 "Household ID"

lab var HA09 "Population density level"
lab def HA09_l 1 "Densely populated (at least 500 inhabitants/km2)" ///
2 "Intermediate (between 100 and 499 inhabitants/km2)" ///
3 "Sparsely populated (less than 100 inhabitants/km2)" 9 "Not specified"
lab val HA09 HA09_l

lab var EUR_HH012 "Income in kind from employment (wages and salaries in kind)"

lab var EUR_HH023 "Income in kind from nonsalaried activities"

lab var EUR_HH032 "Imputed rent"

lab var EUR_HH095 "Monetary net income (total monetary income from all sources minus income taxes)"

lab var EUR_HH099 "Net income (total income from all sources including nonmonetary components minus income taxes)"

lab var HI11 "Main source of income"
lab def HI11_l 1 "wages or salary" 2 "income from self-employment" 3 "property income" ///
4 "pensions, retirement benefits" 5 "unemployment benefit" 6 "other current benefits and other income" 7 "Not specified"
lab val HI11 HI11_l

lab var HI12 "Main source of income (primary/secondary)"
lab def HI12_l 1 "primary (HI11=1,2,3)" 2 "secondary (HI11=4,5,6)" 9 "not specified"
lab val HI12 HI12_l

lab var EUR_HE00 "Total consumption expenditure"

lab var HB05 "Household size"

lab var HB051 "Number of persons aged less than or equal to 4"

lab var HB052 "Number of persons aged from 5 to 13"

lab var HB053 "Number of persons aged from 14 to 15"

lab var HB054 "Total number of persons aged from 16 to 24"

lab var HB055 "Number of persons aged from 16 to 24 who are students"

lab var HB056 "Number of persons aged from 25 to 64"

lab var HB057 "Number of persons aged more than or equal to 65"

lab var HB061 "Equivalent size (OECD scale)"

lab var HB062 "Equivalent size (modified OECD scale)"

lab var HB074 "Type of Household 1 - Age limit for children set at 16 years of age)"
lab def HB074_l 1 "one adult" 2 "two adults" 3 "more than 2 adults" 4 "one adult with dependent children" 5 "two adults with dependant children" ///
6 "more than 2 adults with dependant children" 9 "other"
lab val HB074 HB074_l


lab var HB075 "Type of household – 2"
lab def HB075_l 10 "one person household" 21 "lone parent with children less than 25" 22 "Couple without child(ren) aged less than 25" ///
23 "Couple with child(ren) aged less than 25" 24 "Couple or lone parent with child(ren) aged less than 25 and other persons living in the household" ///
99 "other type of household"
lab val HB075 HB075_l

lab var HB0761 "Number of persons aged 16-64 in household who are at work"

lab var HB0762 "Number of persons aged 16-64 in household who are unemployed or are economically inactive"

lab var HC23 "Socio-economic situation of the reference person"
lab def HC23_l 1 "private sector - manual worker except agriculture" 2 "private sector - non manual worker except agriculture" ///
3 "public sector - manual worker except agriculture" 4 "public sector - non manual worker except agriculture" ///
5 "self employed person except agriculture" 6 "farmer or agricultural worker" 7 "unemployed" 8 "retired" 9 "student or in national service" /// 
10 "housewife or person engaged in a non economic activity" 11 "unable to work" 88 "not applicable (legal age to work unattained)" 99 "not specified"
lab val HC23 HC23_l

lab var HC24 "Socio-economic situation of reference person"
lab def HC24_l 1 "manual worker except agriculture (HC23=01, 03)" 2 "non-manual worker except agriculture (HC23=02, 04)" ///
3 "self-employed person and farmer or agricultural worker (HC23=05,06)" 4 "unemployed (HC23=07)" 5 "retired (HC23=08)" ///
6 "other inactive (HC23=09, 10, 11)" 88 "not applicable (legal age to work not attained)" 99 "not specified"
lab val HC24 HC24_l

lab var HD20 "Number of members economnically active"
lab def HD20_l 5 "5 or more"
lab val HD20 HD20_l





