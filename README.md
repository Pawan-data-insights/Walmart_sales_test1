# Walmart_sales_test1
<div align="center">

# 🛒 Walmart Sales Data Analysis

### An end-to-end SQL & Python analysis of retail transactions to uncover revenue, profit, customer and operational insights

![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Python](https://img.shields.io/badge/Python-Pandas-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-F37626?style=for-the-badge&logo=jupyter&logoColor=white)
![Status](https://img.shields.io/badge/Dashboard-Coming%20Soon-0071CE?style=for-the-badge)

</div>

---

## 📑 Table of Contents

1. [Project Overview](#-project-overview)
2. [Business Objectives](#-business-objectives)
3. [Dataset Description](#-dataset-description)
4. [Tools & Technologies](#-tools--technologies)
5. [Project Workflow](#-project-workflow)
6. [Business Questions Solved](#-business-questions-solved)
7. [Key Insights](#-key-insights)
8. [Recommendations](#-recommendations)
9. [Dashboard](#-dashboard)
10. [Repository Structure](#-repository-structure)
11. [How to Run](#-how-to-run)
12. [Author](#-author)

---

## 🎯 Project Overview

This project analyses **9,969 Walmart retail transactions** across **100 branches** and **98 cities** from **January 2019 to December 2023**. The data is cleaned in Python and then queried in MySQL using advanced SQL (CTEs, window functions, conditional logic and date functions) to answer practical business questions on sales performance, profitability, customer satisfaction and store operations.

The objective is to translate raw transactional data into **clear, decision-ready insights** that a retail business can act upon.

---

## 💼 Business Objectives

- Understand **revenue and profit** drivers by branch, category and payment method
- Identify **peak trading hours and busiest days** to support staffing decisions
- Evaluate **customer satisfaction** through category, branch and city-level ratings
- Detect **branches with declining revenue** year over year
- Separate **high-revenue** performers from truly **high-profit** performers

---

## 📊 Dataset Description

| Attribute | Detail |
|---|---|
| **Records** | 9,969 transactions (after cleaning) |
| **Time Span** | 01 Jan 2019 – 31 Dec 2023 |
| **Branches / Cities** | 100 / 98 |
| **Categories** | 6 |
| **Payment Methods** | Cash, Credit Card, E-wallet |

| Column | Type | Description |
|---|---|---|
| `invoice_id` | Integer | Unique transaction identifier |
| `Branch` | String | Branch code (e.g., WALM009) |
| `City` | String | City of the branch |
| `category` | String | Product category |
| `unit_price` | Float | Price per unit |
| `quantity` | Float | Units sold |
| `date` | String | Transaction date (`dd/mm/yy`) |
| `time` | String | Transaction time |
| `payment_method` | String | Mode of payment |
| `rating` | Float | Customer rating (3–10) |
| `profit_margin` | Float | Profit margin of the item (0.18–0.57) |
| `total` | Float | Transaction value (`unit_price × quantity`) |

> **Derived metric:** `Profit = total × profit_margin`

---

## 🛠 Tools & Technologies

| Purpose | Tools |
|---|---|
| Data cleaning & preparation | Python, Pandas, Jupyter Notebook |
| Data storage & analysis | MySQL |
| SQL techniques | CTEs, Window Functions (`RANK`), Subqueries, `CASE`, Date Functions, Aggregations |
| Dashboarding *(upcoming)* | To be added |

---

## 🔄 Project Workflow

```mermaid
flowchart LR
    A[Raw Data] --> B[Cleaning in Python]
    B --> C[Load into MySQL]
    C --> D[SQL Analysis]
    D --> E[Insights & Recommendations]
    E --> F[Dashboard - Upcoming]
```

1. **Data Cleaning** – removal of duplicates and null values, type corrections, standardised column names
2. **Data Loading** – cleaned dataset loaded into a MySQL table (`walmart_data`)
3. **Exploratory Analysis** – row counts, distinct branches, payment mix, quantity range
4. **Business Analysis** – nine core business problems plus three deep-dive analyses
5. **Reporting** – insights, recommendations and dashboard

---

## ❓ Business Questions Solved

| # | Business Question | SQL Concepts |
|---|---|---|
| 1 | Payment methods with number of transactions and quantity sold | `GROUP BY`, aggregation |
| 2 | Highest-rated category in each branch | `RANK() OVER (PARTITION BY)` |
| 3 | Busiest day of the week for each branch | `STR_TO_DATE`, `DATE_FORMAT`, window function |
| 4 | Total quantity sold per payment method | Aggregation |
| 5 | Average, minimum and maximum rating per category in each city | Multi-level grouping |
| 6 | Total revenue and profit per category | Calculated metrics |
| 7 | Most preferred payment method for each branch | CTE + `RANK()` |
| 8 | Sales split into Morning / Afternoon / Evening shifts | `CASE`, time functions |
| 9 | Top 5 branches with the highest revenue decline (2022 → 2023) | Multiple CTEs, year-over-year ratio |

**Additional deep-dive analyses**

- 📈 **Demand pattern** – monthly transactions and revenue trend
- 💰 **Profit vs. revenue** – branch and category ranking by revenue *and* profit, with margin %
- ⭐ **Customer satisfaction** – weakest-rated category/payment combinations and lowest-rated branches

---

## 🔍 Key Insights

| Metric | Value |
|---|---|
| **Total Revenue** | ≈ $1.21 M |
| **Total Profit** | ≈ $0.48 M |
| **Overall Profit Margin** | ≈ 39.4 % |
| **Average Transaction Value** | ≈ $121 |
| **Average Customer Rating** | 5.83 / 10 |

**1. Revenue is highly concentrated.**
*Fashion Accessories* and *Home & Lifestyle* together contribute roughly **81 %** of total revenue and profit, while the remaining four categories contribute under 7 % each.

**2. Customer satisfaction moves inversely to sales volume.**
The best-rated categories are *Food & Beverages* (7.11) and *Health & Beauty* (7.00), whereas the two largest revenue categories are the lowest-rated (≈ 5.7–5.8).

**3. Digital payments dominate.**
Credit card (≈ 40 %) and E-wallet (≈ 38 %) account for nearly four-fifths of revenue; cash contributes about 22 %.

**4. Trading peaks sharply from 3 PM to 8 PM.**
Roughly **64 %** of all transactions occur in this window, with a clear step-up at 3 PM compared with the morning and early-afternoon hours.

**5. Branch revenue is widely distributed.**
The top branch (WALM009) generates ≈ $25.7 K, only marginally ahead of the next two, indicating no single-branch dependency.

> 📝 *Figures are derived from the cleaned dataset and can be reproduced with the queries in `walmart_querry.sql`.*

---

## 💡 Recommendations

- **Align staffing with demand** – schedule additional staff and open more checkout lanes between 3 PM and 8 PM.
- **Protect core categories, improve their experience** – investigate the low ratings in Fashion Accessories and Home & Lifestyle, as they drive most of the profit.
- **Grow high-satisfaction categories** – promote Food & Beverages and Health & Beauty, which delight customers but under-contribute to revenue.
- **Strengthen digital payment infrastructure** – prioritise reliability of card and e-wallet systems given their share of revenue.
- **Monitor declining branches** – use the year-over-year decline analysis to trigger targeted reviews of under-performing stores.

---

## 📺 Dashboard

<div align="center">

### 🚧 Interactive Dashboard — Coming Soon

<!-- Replace the placeholder below with your dashboard screenshot -->
<!-- ![Dashboard Preview](images/dashboard.png) -->

| | |
|---|---|
| **Tool** | *To be announced* |
| **Planned views** | Revenue & profit KPIs · Branch performance · Category mix · Hourly demand · Ratings analysis |
| **Live link** | *Will be added upon publishing* |

</div>

---

## 📁 Repository Structure

```
walmart-sales-analysis/
│
├── 📄 README.md                 # Project documentation
├── 📓 project.ipynb             # Data cleaning & preparation (Python)
├── 🗃️ walmart_querry.sql        # SQL queries – business analysis
├── 📊 walmart_clean_data.csv    # Cleaned dataset
└── 🖼️ images/                   # Dashboard screenshots (to be added)
```

---

## ▶️ How to Run

1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/walmart-sales-analysis.git
   cd walmart-sales-analysis
   ```
2. **Create the table** in MySQL and import `walmart_clean_data.csv` as `walmart_data`
   (the SQL script references the date column as `walmart_date` — rename `date` accordingly during import).
3. **Run** the queries in `walmart_querry.sql` sequentially.
4. **Open** `project.ipynb` in Jupyter to review the cleaning steps.

---

## 👤 Author

**Pawan Singh**
MBA Graduate | Aspiring Data Analyst & Financial Analyst

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/your-profile)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/your-username)

---

<div align="center">

⭐ *If you found this project useful, consider giving it a star.*

</div>
