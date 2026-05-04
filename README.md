# Student Health Risk Index & Behavioral Analysis
**Objective:** Identifying high-risk students in a 50,000-record dataset to drive targeted wellness interventions.

# 1. The Challenge:
Universities often monitor student health using basic metrics like BMI or physical activity (step counts). However, these "lagging indicators" often fail to capture the immediate mental and physical strain that leads to a health crisis. I wanted to build a model that identified not just who is "unhealthy," but who is at immediate risk of collapse

# 2. The Tech Stack
* **SQL Server:** Data cleaning, behavioral grouping, and engineering a custom Risk Index.
* **Tableau:** Interactive storytelling and outlier identification.

# 3. Engineering the "Health Crisis Index"
I realized that 87% of the population was broadly labeled "At-Risk." To find the true outliers, I engineered a Weighted Risk Index in SQL. Instead of treating all data equally, I prioritized the "Mental-Physical Intersection":
* **High Stress** = +3 points
* **Sleep Deprivation (<6h)** = +2 points
* **Vices (Smoking/Alcohol)** = +1 point
* **High BMI (>25)** = +1 point

<img width="588" height="183" alt="image" src="https://github.com/user-attachments/assets/2bd2b0bf-cc83-4098-b09c-d9dbc8ef34a6" />

# 4. Key Insights
* **The "Cost of Stress":** My analysis revealed a perfect inverse correlation between stress and sleep. Moving from a "Fit" to "Unhealthy" status costs a student exactly **3 hours of sleep per night.**
* **The Sleep Paradox:** Surprisingly, BMI was unaffected by sleep duration in the at-risk group. Even more counter-intuitive: students sleeping **over 8 hours** reported **higher stress levels (2.11)** than those sleeping under 5 hours (1.56), suggesting that "over-sleeping" may be a symptom of mental strain rather than a recovery tool.
* **The "Risk Cliff":** While the average student is stable, I discovered a sharp "risk cliff" where the "Unhealthy" population scored **9x higher** on my risk index than "Fit" students.

# 5. The "Triple Threat" (Final Action)
Using the dashboard, I isolated the **0.6% of the population** (approximately 300 students) who fell into the **"Triple Threat"** category:
1. High Stress<
2. 5 Hours of Sleep
3. Sedentary Lifestyle (< 4,000 steps)
**The Result:** Rather than a university trying to help 50,000 students at once, they now have a **targeted list of 300 individuals** for immediate "Wellness Checks" and intervention.

<img width="1308" height="524" alt="image" src="https://github.com/user-attachments/assets/2fb70acf-af20-40c6-b956-d6afc8fcd0c1" />

**[Click Here to View the Dashboard](https://public.tableau.com/app/profile/jonan.doan/viz/StudentHealthCrisisIndexDashboard/HealthCrisisDashboardAnalyzingtheImpactofStressonStudentWellness)**

