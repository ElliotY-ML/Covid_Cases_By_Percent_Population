/* SQL query to combine CDC Covid 19 Cases, Census ACS 5-year Survey Results, 
and ANSI State Codes.  Calculations for 
1. new covid cases as percentage of population for individual states
2. sum of new covid cases on a 14-day basis, as a percentage of population for individual states    

Query was completed on Google Cloud Platform BigQuery.  The tables were named for files as follows:
1. `cdc_covid_cases_Jan_13` AS datasets/United_States_COVID-19_Cases_and_Deaths_by_State_over_Time.csv
2. `acs_5Y_2019` AS datasets/ACSST5Y2019.S0101_2022-01-14T1743264/ACSST5Y2019.S0101_data_with_overlays_2021-12-10T154120.csv
3. `state_abbreviations` AS datasets/state.txt
*/

WITH 
    rolling_cases AS(
        SELECT 
            CAST(REPLACE(submission_date, '/', '-') AS DATE FORMAT 'MM-DD-YYYY') AS submit_date,
            state,
            SUM(CAST(REPLACE(new_case, ',','') AS INT64)) OVER(
                PARTITION BY state 
                ORDER BY CAST(REPLACE(submission_date, '/', '-') AS DATE FORMAT 'MM-DD-YYYY') ASC
                ROWS BETWEEN 13 PRECEDING AND CURRENT ROW
            ) AS sum_cases_last_14_days
        FROM
            `coursera-analytics-class.covid_by_percent.cdc_covid_cases_Jan_13` --Change Dataset Date
        WHERE 
            state='NY'
        ORDER BY 
            submit_date DESC
),

/* SELECT *
FROM rolling_cases */

-- Merge sum_cases_last_14_days into cases data.

    cases_by_state AS(
        SELECT 
            CAST(REPLACE(cdc.submission_date, '/', '-') AS DATE FORMAT 'MM-DD-YYYY') AS submit_date,
#           CAST(REPLACE(created_at, '/', '-') AS DATE FORMAT 'MM-DD-YYYY') AS create_date,
            cdc.state,
            SUM(CAST(REPLACE(cdc.tot_cases, ',','') AS INT64)) total_cases,
            SUM(CAST(REPLACE(cdc.new_case, ',','') AS INT64)) new_cases,
            SUM(CAST(REPLACE(cdc.tot_death, ',','') AS INT64)) total_deaths,
            SUM(CAST(REPLACE(cdc.new_death, ',','') AS INT64)) new_deaths,
#           SUM(rc.tot_cases_last_14_days)
        FROM
            `coursera-analytics-class.covid_by_percent.cdc_covid_cases_Jan_13` as cdc
/*       LEFT JOIN 
           rolling_cases as rc
       ON 
           submit_date=rc.submit_date AND cdc.state=rc.state */
        WHERE 
            cdc.state='NY'
        GROUP BY
            cdc.state, submit_date--, rc.submit_date, rc.state
        ORDER BY 
            submit_date DESC
),

-- Merge State Abbreviations into Census data

    state_population AS(    
        SELECT 
            acs.*, abb.STUSAB as state_abb
        FROM
            `coursera-analytics-class.covid_by_percent.acs_5Y_2019` AS acs
        INNER JOIN 
            `coursera-analytics-class.covid_by_percent.state_abbreviations` as abb
        ON acs.Geographic_Area_Name=abb.STATE_NAME 
)

-- Query for Covid Case information and calculations

SELECT 
    cs.*,
    rc.sum_cases_last_14_days,
    pop.Estimate__Total__Total_population AS state_pop,
    cs.new_cases/pop.Estimate__Total__Total_population AS new_cases_percent,
    rc.sum_cases_last_14_days/pop.Estimate__Total__Total_population AS cases_last_14_pop_percent 
FROM 
    cases_by_state AS cs
INNER JOIN 
    rolling_cases AS rc
ON 
    cs.submit_date=rc.submit_date AND cs.state=rc.state
INNER JOIN 
    state_population AS pop
ON 
    cs.state=pop.state_abb
ORDER BY 
    cs.submit_date DESC 
