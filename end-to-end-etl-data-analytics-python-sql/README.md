# End-to-End Data Analytics ETL Project (Python + SQL)

## 📌 Project Overview

This project demonstrates an **end-to-end data analytics pipeline**, where raw sales data is processed, cleaned, and analyzed to generate meaningful business insights.

The project combines **Python for data processing** and **SQL for business analysis**, following real-world Data Engineering practices.


## 🎯 Objectives

* Build a complete **ETL pipeline**
* Clean and transform raw data using Python
* Load processed data into a SQL database
* Perform **business-driven analysis using SQL**
* Generate insights like revenue trends, growth, and performance


## 🛠️ Tech Stack

* **Python** (Pandas, Data Cleaning)
* **SQL (MySQL)** (Data Analysis)
* **Git & GitHub** (Version Control)
* **CSV Files** (Data Source)


## 📂 Project Structure

```
end-to-end-etl-data-analytics-python-sql/
│
├── raw_orders.csv              # Raw dataset
├── clean_orders.csv            # Cleaned dataset (Python output)
├── Project.ipynb               # Data cleaning & transformation
├── project1_data_records.sql   # SQL table + analysis queries
└── README.md                   # Project documentation
```


## 🔄 ETL Process

### 1️⃣ Extract

* Raw data is collected from CSV file (`raw_orders.csv`)

### 2️⃣ Transform (Python)

* Data cleaning using Pandas:

  * Handle missing values
  * Fix data types
  * Remove duplicates
  * Feature engineering

### 3️⃣ Load (SQL)

* Cleaned data loaded into **MySQL database**
* Table: `orders`



## 📊 SQL Business Analysis

### 🔹 Sales Performance

* Top 10 revenue-generating products
* Top 5 products in each region

### 🔹 Growth Analysis

* Year-over-Year revenue comparison (2022 vs 2023)
* Growth percentage calculation

### 🔹 Time-Based Insights

* Best-performing month for each category

### 🔹 Profit Analysis


* Highest growth sub-category

## 📈 Key Insights

* Identified **top-performing products** driving revenue
* Found **regional sales leaders**
* Measured **business growth trends**
* Highlighted **high-growth categories**

## 🚀 How to Run This Project

### Step 1: Clone Repository

```
git clone https://github.com/your-username/Data-Engineering-Projects.git
```

### Step 2: Run Python Script

* Open `Project.ipynb`
* Execute all cells to generate cleaned dataset

### Step 3: Run SQL Queries

* Open MySQL
* Run `project1_data_records.sql`

## 💡 Learning Outcomes

* Hands-on experience with **ETL pipelines**
* Real-world **SQL analytics queries**
* Data cleaning using **Pandas**
* Structuring a **production-like project**


## 📌 Future Improvements

* Add dashboard (Power BI / Tableau)
* Automate pipeline using Airflow
* Store data in cloud (AWS / GCP)
* Add incremental data loading

