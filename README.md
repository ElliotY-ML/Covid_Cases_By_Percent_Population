# Overview
This repository contains source code, data, and calculated features for visualizing recent COVID-19 cases in the U.S.  
The transformed data is uploaded to Tableau Public for creating interactive dashboards with line graphs, bar charts, and heat maps of COVID-19 cases and deaths.

![Tableau Dashboard](/img/TableauScreenShot.JPG)
[Link to Dashboard on Tableau Public](https://public.tableau.com/views/US_Covid19_Cases_Percent_Population/Dash14Day?:language=en-US&:display_count=n&:origin=viz_share_link)

***NEW 11/2022*** The transformed data is visualized in an interactive Plotly Dash dashboard. The dashboard script `src/covid_dashboard.py` can be deployed on a local server or on a cloud service such as Heroku and Google Cloud Platform.
![Created using Dash](/img/PlotlyDashScreenShot.JPG)
[Link to Dash dashboard deployed on Google Cloud Platform](https://covid-dash-374301.ue.r.appspot.com/)

# Table of Contents
- [Introduction](#introduction)
- [Data Sources](#data-sources)
- [Calculated Features](#calculated-features)
- [SQL](#sql)
- [Tableau](#tableau)
- [Plotly Dash Dashboard](#dash-app)
- [Future Improvements](#future-improvements)


# Introduction  
  
This project presents a different aspect than those seen on New York Times [1] and U.S. CDC analysis [2] by analyzing totals of new COVID-19 cases reported in the past 14 days.  

Estimates of the percentage of each state population that is currently infected with COVID-19 is calculated by normalizing the past 14 day new case totals to their respective state populations. 
The data is presented as a percentage because it may be more intuitively digested by the general population, as opposed to using a basis of per million or per 100,000 people.

The author selected time intervals of 14-days based on studies that show that an average period of COVID-19 infectiousness and risk of transmission is between 3 days before and 8 days after symptom onset, 
and COVID-19 RNA usually becomes undetectable from upper respiratory tract samples about 2 weeks after symptom onset[3, 4, 5].

[1]  https://www.nytimes.com/interactive/2021/us/covid-cases.html  
[2]  https://covid.cdc.gov/covid-data-tracker/#datatracker-home  
[3]  https://www.cdc.gov/coronavirus/2019-ncov/your-health/quarantine-isolation.html  
[4]  Peeling RW, Heymann DL, Teo Y, Garcia PJ. Diagnostics for COVID-19: moving from pandemic response to control. Lancet. Published online December 20, 2021: https://doi.org/10.1016/S0140-6736(21)02346-1  
[5]  https://www.nytimes.com/interactive/2022/01/22/science/charting-omicron-infection.html


# Data Sources

## CDC U.S. COVID-19 Cases and Deaths By State  
U.S. CDC reports COVID-19 cases and death counts online at this [link](https://data.cdc.gov/Case-Surveillance/United-States-COVID-19-Cases-and-Deaths-by-State-o/9mfq-cb36).  
The data is a collection of the most recent numbers reported by states, territories, and other jurisdictions to the CDC.

**Notes**:  
-  This dataset includes Confirmed Cases and Probable Cases, as defined by CSTE [6]. Confirmed cases meet molecular laboratory testing evidence, while Probable cases meet clinical criteria without laboratory evidence. 
Many jurisdictions include both their confirmed and probable cases ("pnew_case") into reported "Total Cases" and "New Case" counts.
-  Counts for New York City and New York State are provided separately.  This data must be recombined to analyze them as one New York state.



## U.S. Census Bureau - 2019 American Community Survey 5-year Estimate 
The population of each state is obtained from the most recent U.S. Census Bureau American Community Survey 5-Year Estimate 2015-2019 [7].  Detailed descriptions about this data can be found through this [link](https://www.census.gov/acs/www/data/data-tables-and-tools/narrative-profiles/2019/report.php?geotype=nation&usVal=us)   
 
This data can be viewed and exported interactively on the U.S. Census Bureau [website](https://data.census.gov/cedsci/table?g=0100000U.S.,%240400000&tid=ACSST5Y2019.S0101)  




## American National Standards Institute (ANSI) Codes for States
The conversion from state names to state abbreviations is needed to combine the U.S. CDC COVID-19 and the U.S. Census ACS datasets. 
 
This information can be found on the U.S. Census Bureau reference library: https://www.census.gov/library/reference/code-lists/ansi/ansi-codes-for-states.html  
Download the "National FIPS and GNIS Codes File" from the reference library.


[6]  https://ndc.services.cdc.gov/case-definitions/coronavirus-disease-2019-2021/  
[7]  https://data.census.gov/cedsci/table?g=0100000U.S.&d=ACS%205-Year%20Estimates%20Subject%20Tables


# Calculated Features
The following 3 features are calculated from the datasets:
1.  `Daily New Cases as Percent of State Population = New Cases/State Population`
2.  `New Cases in Last 14 Days = Sum(New Cases) Between Submit Date and Previous 13 Dates`
3.  `New Cases in Last 14 Days as Percent of State Population = Cases Last 14 Days/State Population`



# SQL
Use SQL to execute a query for extracting, joining, and performing calculations on the three datasets and create 
a table with calculated features appended to the original CDC COVID-19 Cases and Deaths data. This new dataset will be uploaded to the Tableau Public Viz.

Method 1: Use **Google Cloud Platform BigQuery** to generate a CSV file with current U.S. CDC COVID-19 data:
1.  Download "CDC U.S. COVID-19 Cases and Deaths By State", "U.S. Census Bureau - 2019 American Community Survey 5-year Estimate", and "ANSI Codes for States" datasets.
2.  Create a project database in your GCP BigQuery SQL workspace.  
3.  In the project database, Create a Dataset.
4.  In the new Dataset, Create individual Tables for each dataset. Copy and paste `src/import_CDC_data_schema.sql` to set up the Schema for CDC COVID-19 Cases data, importing all columns as string type.  
5.  Create a New Query. Copy and paste the `covid19_ETL.sql` into the blank query.  
6.  Run the Query. Save output as `datasets/Generated/US_MMM_DD.csv` where MMM is month as a string and DD is the current date.

Method 2: Use **Python (w/ SQLite and Requests libraries)** to generate a CSV file with current U.S. CDC COVID-19 data:
1. Set up your Anaconda environment.  
2. Clone `https://github.com/ElliotY-ML/Covid_Cases_By_Percent_Population.git` GitHub repo to your local machine.
3. Create and activate a new environment, named `covid_data` with Python 3.8+. Be sure to run the command from the project root directory since the environment.yml and pkgs.txt files are there. 
If prompted to proceed with the install `(Proceed [y]/n)` type y.
	```
	conda env create -f environment.yml
	conda activate covid_data
	```
4. Open a conda terminal and cd into the project root folder. 
5. Execute `src/build_dataset.py`.  This script will retreive current U.S. CDC COVID-19 data and generate an output dataset to `datasets/Generated/US_MMM_DD.csv`. 
This dataset is the same as one that is obtained following Method 1.


# Tableau
The SQL query result dataset is visualized with charts, heat maps, and interactive dashboards on Tableau Public.

Direct link to author's Tableau Public Viz: https://public.tableau.com/app/profile/ellioty.ml/viz/US_Covid19_Cases_Percent_Population/Dash14Day

### Refresh Data
To refresh the Tableau Viz with the lastest CDC COVID-19 Cases data:
1. Follow the SQL section to generate a CSV file with the most recent CDC data.  
2. Replace existing Tableau visualization data source with `datasets/Generated/US_MMM_DD.csv`.

# <a name="dash-app"></a>Plotly Dash Dashboard
The SQL query result dataset is also visualized with charts and heat maps on an interactive dashboard created with Plotly Dash. 
This dashboard is deployed on Google Cloud Platform (App Engine).

To learn more, please visit the repo: https://github.com/ElliotY-ML/covid-dashboard-on-gcp

# Future Improvements 
✅ Add scripting to automate refresh of U.S. CDC COVID-19 data.  ***Completed*** `src/build_dataset.py` on Mar-17-2022  
✅ Interactive analysis using Jupyter Notebook. ***Completed*** Plotly Dash dashboard in `src/covid_dashboard.py` on Nov-21-2022  
✅ Interactive dashboard application. ***Completed*** Deployed Plotly Dash dashboard to Heroku on Nov-21-2022. ***Updated*** Deployed Plotly Dash dashboard to GCP App Engine on Jan-31-2023.

# License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md)