<div align="center">

# 🛒 Walmart Sales Data Analytics Project

### From a messy CSV to an interactive dashboard: Python → SQL → Dashboard

![Python](https://img.shields.io/badge/Python-pandas-0071DC?style=for-the-badge&logo=python&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-Window_Functions_&_CTEs-041E42?style=for-the-badge&logo=mysql&logoColor=white)
![Dashboard](https://img.shields.io/badge/Dashboard-HTML_·_Chart.js-FFC220?style=for-the-badge&logoColor=black)
![Built with](https://img.shields.io/badge/Dashboard_built_with-Claude_AI-76C2FF?style=for-the-badge)

**[▶ Open the Dashboard](dashboard/Walmart_Sales_Dashboard.html)** 
&nbsp;·&nbsp; **[SQL Analysis](walmart_querry.sql)**
 
 &nbsp;·&nbsp; **[Notebook](project.ipynb)**

&nbsp;·&nbsp; **[Clean Data](walmart_clean_data.csv)**


![Dashboard preview](dashboard/screenshots/dashboard-light.png)

</div>

---

## 📌 Project at a glance

I took 10,000 raw Walmart transactions, cleaned them with Python, answered 12 business questions in SQL, and turned the findings into an interactive, recruiter-friendly dashboard with trend analysis and a dark mode.

| 🧾 Transactions | 🏬 Branches | 🌆 Cities | 🗂️ Categories | 📅 Period | 💵 Revenue | 💰 Profit |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **9,969** | **100** | **98** | **6** | **2019 – 2023** | **$1.21M** | **$476K** |

---

## 🔄 The pipeline

```mermaid
flowchart LR
    A[📥 Raw Walmart CSV<br/>~10K invoices] --> B[🐍 Python · pandas<br/>clean + transform]
    B --> C[📄 walmart_clean_data.csv<br/>9,969 rows]
    C --> D[🗄️ MySQL<br/>walmart_data table]
    D --> E[🔎 SQL analysis<br/>12 business questions]
    E --> F[📊 Interactive dashboard<br/>built with Claude AI]
    F --> G[💡 Insights & recommendations]
```

| Stage | What happens | Output |
|---|---|---|
| **1 · Python** | Profile, clean and transform the raw file | [`python/data_cleaning.py`](python/data_cleaning.py) · [`notebooks/project.ipynb`](notebooks/project.ipynb) |
| **2 · SQL** | Load into MySQL, solve business problems with window functions and CTEs | [`sql/walmart_querry.sql`](sql/walmart_querry.sql) |
| **3 · Dashboard** | Turn the SQL findings into a filterable, trend-aware dashboard | [`dashboard/Walmart_Sales_Dashboard.html`](dashboard/Walmart_Sales_Dashboard.html) |

---

## 🐍 Stage 1: Data cleaning & transformation (Python)

 **Exploration Notebook:** [`project.ipynb`](project.ipynb)


| Step | Why it matters |
|---|---|
| Profile the data (shape, types, nulls, duplicates) | Know what is broken before fixing it |
| Trim stray spaces in text columns | Prevents fake categories like `"Cash "` vs `"Cash"` |
| Remove duplicate records | Duplicates inflate revenue and counts |
| Strip `$` from `unit_price` and convert to numbers | Prices must be numeric to calculate revenue |
| Validate dates and times | The SQL stage parses them (`STR_TO_DATE`, `HOUR`) |
| Drop rows with missing values | A tiny share of rows, so dropping is safer than guessing |
| Remove impossible values (price/quantity ≤ 0, rating outside 0–10) | Protects every average downstream |
| **Feature engineering:** `total = unit_price × quantity` | Revenue column used in all SQL and dashboard metrics |

**Result:** 9,969 clean rows with 12 columns, no nulls and no duplicates. The script ends with built-in validation checks and can optionally load the data straight into MySQL.

```bash
python python/data_cleaning.py --input data/Walmart.csv --output data/walmart_clean_data.csv
```

---

## 🗄️ Stage 2: Business problem solving (SQL)


**File:** [`walmart_querry.sql`](walmart_querry.sql) · **Data Source:** [`walmart_clean_data.csv`](walmart_clean_data.csv)


| # | Business question | SQL technique |
|:---:|---|---|
| Q1 | Payment methods: how many transactions and units sold? | `GROUP BY`, `COUNT`, `SUM` |
| Q2 | Highest-rated category in each branch | `RANK() OVER (PARTITION BY …)` |
| Q3 | Busiest weekday for each branch | `STR_TO_DATE`, `DATE_FORMAT`, `RANK()` |
| Q4 | Units sold per payment method | Aggregation |
| Q5 | Min / avg / max rating per city and category | Multi-column `GROUP BY` |
| Q6 | Revenue and profit by category | `SUM(total × profit_margin)` |
| Q7 | Preferred payment method per branch | CTE + `RANK()` |
| Q8 | Morning / afternoon / evening sales | `CASE WHEN`, `HOUR()` |
| Q9 | 5 branches with the biggest revenue drop, 2022 → 2023 | Two CTEs + `JOIN` |
| ➕ | When is demand peaking? Monthly traffic and revenue | Date functions, trend by month |
| ➕ | Where does profit come from vs revenue? | Dual `RANK()` on revenue and profit |
| ➕ | What drives low ratings? | `HAVING`, category × payment cuts |

### 🔍 What the SQL revealed

| Finding | Evidence |
|---|---|
| **Credit card is the most used payment method** | 4,256 transactions (43%) and 9,567 units vs Ewallet 3,881 / 8,932 and Cash 1,832 / 4,984 |
| **Two categories carry the business** | Fashion accessories and Home & lifestyle bring ~$489K each, about 81% of revenue |
| **Margins are almost identical everywhere** | All categories sit between 39% and 40%, so volume, not margin, drives profit |
| **Afternoon is the busiest shift** | 4,636 orders (47%) vs evening 3,246 and morning 2,087 |
| **Biggest 2022 → 2023 revenue drops** | WALM045 (−62.6%), WALM047 (−58.6%), WALM098 (−57.9%), WALM033 (−55.6%), WALM081 (−50.7%) |
| **Top profit branches** | WALM009 ($12.3K), WALM030 ($11.7K), WALM003 ($11.5K) |

---


## 📊 Stage 3: Interactive Dashboard

**👉 [Open Interactive Walmart Sales Dashboard](walmart_sales_dashboard%20%281%29.html)**

Or view the live dashboard using GitHub Pages:


[🚀 Launch Live Dashboard](https://pawan-data-insights.github.io/Walmart_sales_test1/Walmart_Sales_Dashboard%20%281%29.html)


Designed with a Walmart-inspired blue and spark-yellow theme and built with **Claude AI** (HTML + Chart.js), using the cleaned data and the SQL questions above as the brief.

| ☀️ Light theme | 🌙 Dark theme |
|:---:|:---:|
| ![Light Theme](dashboard-light.png) | ![Dark Theme](dashboard-dark.png) |


**What is inside**

- **Dynamic filters:** year, category and payment method update every chart, KPI and insight at once
- **6 KPI cards:** revenue, profit, margin, transactions, average rating, average basket, with year-on-year change and sparklines
- **Trend analysis:** monthly trend with a 3-month moving average and linear trend line, prior-year overlay, and a seasonality chart by year
- **Auto-generated insights:** six insight cards that rewrite themselves based on the active filter
- **SQL answers as visuals:** demand heatmap (weekday × hour), top 10 branches by profit, category revenue vs profit, payment mix, rating by category × payment, shift split, top-5 revenue decliners
- **Light / dark theme toggle** that remembers your choice

### 💡 Key insights from the dashboard

1. **Seasonality is the story.** November and December deliver about 41% of annual revenue, every single year. Inventory and staffing should be planned around Q4.
2. **Revenue is flat, not growing.** Full-year revenue moved from $219K (2020) to $232K (2023), roughly +1.9% a year.
3. **Payment method shapes satisfaction.** Ewallet customers rate their experience 6.48 vs 5.42 for cash and credit card, a gap worth investigating (checkout speed?).
4. **Staff for the afternoon.** The demand heatmap shows the heaviest traffic from 3 PM to 8 PM on every weekday, peaking at 3 PM.

> ⚠️ **Data note:** 2019 contains only January–March, so year-on-year comparisons start with 2021 vs 2020, and 2019 is marked as partial in the charts.

---

## 🗂️ Repository structure

```text
walmart-sales-data-analytics/
├── data/
│   └── walmart_clean_data.csv          # cleaned dataset (9,969 rows)
├── python/
│   └── data_cleaning.py                # Stage 1: clean + transform (+ optional MySQL load)
├── notebooks/
│   └── project.ipynb                   # Stage 1: exploration notebook
├── sql/
│   └── walmart_querry.sql              # Stage 2: business problems in SQL
├── dashboard/
│   ├── Walmart_Sales_Dashboard.html    # Stage 3: interactive dashboard
│   └── screenshots/                    # light and dark previews
└── README.md
```

---

## 🚀 Run it yourself

```bash
# 1. Clone
git clone https://github.com/<your-username>/<repo-name>.git
cd <repo-name>

# 2. Install libraries
pip install pandas numpy sqlalchemy mysql-connector-python

# 3. Clean the raw data (download it first, see Data source below)
python python/data_cleaning.py --input data/Walmart.csv --output data/walmart_clean_data.csv

# 4. (Optional) load into MySQL, then run sql/walmart_querry.sql
python python/data_cleaning.py --mysql "mysql+mysqlconnector://user:password@localhost:3306/walmart_db"

# 5. Open the dashboard
#    double-click dashboard/Walmart_Sales_Dashboard.html (internet needed for Chart.js and fonts)
```

---

## 🧰 Tech stack

`Python` · `pandas` · `NumPy` · `SQLAlchemy` · `MySQL` · `Window functions` · `CTEs` · `HTML / CSS / JavaScript` · `Chart.js` · `Claude AI` (dashboard build)

---

## 👤 Author

**Pawan Singh**: MBA graduate, open to Data Analyst and Financial Analyst roles.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Pawan_Singh-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/pawan-singh-3952bb42b/)

If this project helped or interested you, a ⭐ on the repo is appreciated!

---

## 🙏 Credits

- **Data source:** [Walmart 10K Sales Dataset on Kaggle](https://www.kaggle.com/najir0123/walmart-10k-sales-datasets)
- **Dashboard:** designed and built with Claude AI
- Walmart name and logo are trademarks of Walmart Inc., used here for illustrative, educational purposes only. This project is not affiliated with or endorsed by Walmart.
