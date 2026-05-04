--https://www.kaggle.com/code/lalit7881/college-student-health-behavior-eda

WITH StudentScoring AS (
    SELECT 
        health_condition,
        gender,
        sleep_duration,
        step_count,
        bmi,
        CAST(smoking_alcohol AS INT) AS vices,
        CASE 
            WHEN stress_level = 'High' THEN 3.0 
            WHEN stress_level = 'Medium' THEN 2.0 
            WHEN stress_level = 'Low' THEN 1.0 
            ELSE 0 
        END AS stress_num
    FROM [student_health_dataset_50k]
)

SELECT 
    health_condition,
    gender,
    COUNT(*) AS total_students,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS percent_overall,
    AVG(CAST(sleep_duration AS FLOAT)) AS avg_sleep,
    AVG(CAST(step_count AS FLOAT)) AS avg_steps,
    AVG(CAST(bmi AS FLOAT)) AS avg_bmi,
    AVG(stress_num) AS avg_stress_score,
    CAST(AVG(vices * 100.0) AS DECIMAL(5,2)) AS vice_percentage

FROM StudentScoring
GROUP BY health_condition, gender
ORDER BY health_condition, avg_stress_score DESC;

/*
noticed that out of health condition at-risk has the highest population average with the overall percentage of 87%

There is a linear correlation with stress level and health condition as stress is moving perfectly in sync with the health condition. 

Physical lifestyle doesn't appear to make that much of a difference when it comes to health condition but stress and sleep makes the most impact when it comes to health.

Fit: 8.17 hours
At-Risk: 7.09 hours
Unhealthy: 5.12 hours
The Insight: You can actually see the "Cost of Stress." Going from Fit to Unhealthy costs a student 3 hours of sleep per night.


Gender doesn't seem to play a role in student's health since it has minor differences accros the 
different physical lifestyle. (Example: Sleep having a difference of only 1 minute of sleep)

*/

WITH StudentScoring AS (
    SELECT 
        health_condition,
        gender,
        sleep_duration,
        step_count,
        bmi,
        CAST(smoking_alcohol AS INT) AS vices,
        CASE 
            WHEN stress_level = 'High' THEN 3.0 
            WHEN stress_level = 'Medium' THEN 2.0 
            WHEN stress_level = 'Low' THEN 1.0 
            ELSE 0 
        END AS stress_num
    FROM [student_health_dataset_50k]
)
SELECT 
    CASE 
        WHEN sleep_duration < 5 THEN 'Short Sleep (Under 5h)'
        WHEN sleep_duration > 8 THEN 'Long Sleep (Over 8h)'
        ELSE 'Normal Sleep (5-8h)'
    END AS sleep_category,
    AVG(bmi) AS avg_bmi,
    AVG(stress_num) AS avg_stress
FROM StudentScoring
WHERE health_condition = 'at-risk'
GROUP BY     CASE 
        WHEN sleep_duration < 5 THEN 'Short Sleep (Under 5h)'
        WHEN sleep_duration > 8 THEN 'Long Sleep (Over 8h)'
        ELSE 'Normal Sleep (5-8h)'
    END;

/*
Surprisingly, within the At-Risk group, we found that sleep duration had no impact on BMI. Furthermore, we discovered a counter-intuitive trend: students sleeping over 8 hours actually reported higher stress levels (2.11) than those sleeping under 5 hours (1.56).
*/

--High-Risk Outlier:

SELECT        
        health_condition,
        gender,
        sleep_duration,
        step_count,
        bmi,
        CAST(smoking_alcohol AS INT) AS vices,
        stress_level
FROM [student_health_dataset_50k]
WHERE sleep_duration < 5
     AND stress_level = 'High'
     AND step_count < 4000
ORDER BY BMI DESC;
/*
About 0.6% of the total population fell into the "Triple Threat" result.
These patients should be advised for an immediate "Wellness Check" or intervention from the university.
*/


WITH StudentRiskScore AS (
    SELECT 
        health_condition,
        (CASE WHEN stress_level = 'High' THEN 3 ELSE 0 END)+
        (CASE WHEN sleep_duration < 6 THEN 2 ELSE 0 END)+
        (CASE WHEN smoking_alcohol = 1 THEN 1 ELSE 0 END)+
        (CASE WHEN BMI >25 then 1 ELSE 0 END) as individual_risk_score
    FROM [student_health_dataset_50k]
)

SELECT 
    health_condition,
    COUNT(*) as student_count,
    CAST(AVG(individual_risk_score) AS DECIMAL(5,2)) AS avg_health_index,
    MAX(individual_risk_score) AS max_risk_found
FROM StudentRiskScore
GROUP BY health_condition
ORDER BY avg_health_index DESC;

/*
overall story:

Using SQL Server, I engineered a Health Crisis Index to quantify student wellness across 50,000 records. 
While 87% of students were labeled 'At-Risk,' my analysis revealed a sharp 'risk cliff' where the Unhealthy 
population scored 9x higher on the risk index than the Fit population, driven primarily by the intersection 
of high stress and sleep deprivation rather than physical BMI.
*/