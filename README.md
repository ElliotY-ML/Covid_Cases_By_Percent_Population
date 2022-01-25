# Overview
This repository contains codes, data, and calculated features for visualizing recent COVID-19 cases in the US.  
The generated data is utilized in Tableau Public for creating dashboards with line graphs, bar charts, and heat maps of COVID-19 cases and deaths.

![Tableau Dashboard](/img/CovidDashScreenShot.JPG)
[Link to Dashboard on Tableau Public](https://public.tableau.com/views/US_Covid19_Cases_Percent_Population/Dash14Day?:language=en-US&publish=yes&:display_count=n&:origin=viz_share_link)

# Introduction  
  
This project presents a different aspect than those seen on New York Times and U.S. CDC analysis by analyzing totals of new Covid-19 cases reported in the past 14 days. 
Estimates of the percentage of each state population that is currently infected with Covid-19 is calculated by normalizing the past 14 day new case totals to their respective state populations.  
The data is presented as a percentage because it may be more intuitively digested by the general population, as opposed to using a basis of per million or per 100,000 people.

The author selected time intervals of 14-days based studies that show that an average period of COVID-19 infectiousness and risk of transmission is between 3 days before and 8 days after symptom onset, 
and COVID-19 RNA usually becomes undetectable from upper respiratory tract samples about 2 weeks after symptom onset[1, 2, 3].


[1]  https://www.cdc.gov/coronavirus/2019-ncov/your-health/quarantine-isolation.html  
[2]  Peeling RW, Heymann DL, Teo Y, Garcia PJ. Diagnostics for COVID-19: moving from pandemic response to control. Lancet. Published online December 20, 2021: https://doi.org/10.1016/S0140-6736(21)02346-1  
[3]  https://www.nytimes.com/interactive/2022/01/22/science/charting-omicron-infection.html


# Data Sources

## CDC US Covid-19 Cases and Deaths By State  
The CDC reports COVID-19 cases and death counts online at this [link](https://data.cdc.gov/Case-Surveillance/United-States-COVID-19-Cases-and-Deaths-by-State-o/9mfq-cb36).  
The data is a collection of the most recent numbers reported by states, territories, and other jurisdictions.

Notes:  
-  The provided Total Cases includes total Confirmed Cases and total Probable Cases, as defined by CSTE [4]. Confirmed cases meet laboratory evidence, but Probable cases meet clinical criteria without laboratory evidence.  
-  Counts for New York City and New York State are shown separately.  This data must be recombined to analyze them as one New York State.


## US Census Data - 2019 American Community Survey 5-year Estimate 
['2019 American Community Survey By State 5-Year Estimate'](https://api.census.gov/data/2019/acs/acs5?get=NAME,B01001_001E&for=state:*)  
['2019 American Community Survey By State 1-Year Estimate']https://api.census.gov/data/2019/acs/acs1?get=NAME,B01001_001E&for=state:*
https://www.census.gov/acs/www/data/data-tables-and-tools/narrative-profiles/2019/report.php?geotype=nation&usVal=us
https://data.census.gov/cedsci/table?g=0100000US,%240400000&tid=ACSST5Y2019.S0101


## American National Standards Institute (ANSI) Codes for States
https://www.census.gov/library/reference/code-lists/ansi/ansi-codes-for-states.html

[4] https://ndc.services.cdc.gov/case-definitions/coronavirus-disease-2019-2021/

# Calculated Features





# SQL



# Tableau

## Refresh Data


# Further Improvements 