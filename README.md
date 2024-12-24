# Layoffs Analysis Project

## Overview
This project provides a detailed analysis of layoffs across industries, companies, and regions using a cleaned dataset. It features a Tableau dashboard that visualizes key trends and insights. The primary goals are to explore the factors contributing to layoffs, identify trends over time, and present actionable insights through an interactive dashboard.

## Dataset
### **Source:**
The dataset, `layoffs.csv`, contains information on layoffs, including company details, industry, location, and funding stages. It was further cleaned and analyzed using SQL and Tableau.

### **Structure:**
- **Columns:**
  - `company`: Name of the company.
  - `location`: Location of the company.
  - `industry`: Industry category.
  - `total_laid_off`: Total number of employees laid off.
  - `percentage_laid_off`: Percentage of the workforce affected.
  - `date`: Date of the layoffs.
  - `stage`: Funding stage (e.g., "Series B," "Post-IPO").
  - `funds_raised_millions`: Total funds raised by the company (in millions).

## Data Cleaning
The cleaning process was implemented using `Data Cleaning.sql`, which includes:
1. **Duplicate Removal:** Identifying and removing duplicate entries using row numbering.
2. **Standardization:** Formatting columns such as `industry` and `location` for consistency.
3. **Handling Missing Data:**
   - Populating missing `industry` values based on company data.
   - Removing rows with insufficient data for layoffs analysis.
4. **Date Conversion:** Ensuring proper `DATE` format for temporal analysis.

## Exploratory Data Analysis (EDA)
The `EDA.sql` script provides insights into:
1. **Layoffs by Time:** Identifying peaks and trends in layoffs over months and years.
2. **Top Contributors:** Highlighting companies, industries, and regions with the highest layoffs.
3. **Funding vs. Layoffs:** Exploring the correlation between funds raised and layoffs.
4. **Percentage Impact:** Ranking companies by the percentage of workforce laid off.

## Tableau Dashboard
### **Features:**
- **Monthly Layoff Trends:** Line chart showing layoffs over time, with filters for industry and location.
- **Top Industries:** Bar chart visualizing industries with the most layoffs.
- **Geographical Insights:** Map showcasing layoffs by country.
- **Funding vs. Layoffs:** Scatter plot examining the relationship between funding raised and layoffs.
- **Workforce Impact:** Bar chart of companies ranked by the percentage of workforce laid off.

### **Interactivity:**
- Filters for `industry`, `country`, `stage`, and `date` allow dynamic exploration.
- Clickable elements enable cross-chart filtering.

### **File:**
The Tableau dashboard is available as `Layoffs.twbx`. Open it in Tableau Desktop or Tableau Public for interaction.

## Setup Instructions
### **Prerequisites:**
- MySQL Server
- Tableau Public
- MS Excel

### **Steps:**
1. Load the dataset into MySQL.
2. Execute `Data Cleaning.sql` and `EDA.sql` to clean and analyze the data.
3. Export the cleaned data to a CSV or connect Tableau directly to the database.
4. Open the Tableau workbook (`Layoffs.twbx`) to explore the visualizations.

## Key Features
- Comprehensive data cleaning and transformation pipeline.
- Interactive and visually compelling Tableau dashboard.
- Insights into layoffs trends, industry impacts, and funding correlations.

## Technologies Used
- **SQL:** Data cleaning and EDA.
- **Tableau:** Dashboard creation and visualization.
- **Excel:** CSV inspection and preliminary analysis.

## Usage
This project can be used for:
- Understanding layoff trends and their driving factors.
- Comparing industries and regions in terms of workforce impact.
- Assessing the influence of funding stages on layoffs.
