# Superstore Sales Analysis (MySQL + Power BI)

End-to-end retail sales analysis of the Superstore dataset (9,994 order lines, 2014-2017). Data cleaning and all analysis were done in SQL (MySQL), and the results are presented in a 3-page Power BI dashboard.

## Business Questions

1. How do sales and profit trend month by month?
2. Which products make the most profit, and which lose money?
3. Which region and category combinations are weak?
4. How do discounts affect profit?
5. How concentrated is revenue among customers?
6. How does shipping mode affect delivery time?

## Tools

- MySQL 8 (SQL, window functions, CTEs)
- Power BI Desktop (DAX, conditional formatting)
- Python (pandas, SQLAlchemy) for the initial CSV import only

## Approach

1. Imported the CSV into MySQL (9,994 rows verified).
2. Renamed columns to snake_case and converted text dates to DATE type, handling hidden carriage-return characters.
3. Wrote 6 analysis queries (`superstore_sales_analysis.sql`).
4. Built a 3-page Power BI dashboard on top of the MySQL table.

## Key Findings

| Area | Finding |
|---|---|
| Overall | $2.30M sales, $286.4K profit, 12.47% margin, 5,009 orders |
| Trend | Only 2 of 48 months were loss-making (2015-01: -$3,281, 2014-07: -$841) |
| Top products | Top 10 products generated $66.5K (23.2% of total profit); one copier alone contributed $25.2K (8.8%) |
| Bottom products | Bottom 10 products lost $29.5K, erasing 44% of the top 10's profit; two Cubify 3D printer models lost $12.7K combined |
| Category | Furniture is 32% of sales but only 6.4% of profit (2.49% margin) |
| Region | Central Furniture is the only region-category pair operating at a loss (-$2,871, -1.75% margin) |
| Discounts | Order lines discounted above 20% (14% of lines) averaged -$97 each and lost $135K, erasing about a third of the profit earned at lower discounts |
| Customers | Top 20% of customers contribute 48% of revenue; top 40% contribute 72% |
| Shipping | Standard Class handles 60% of order lines at 5.0 days on average vs 2.2 days for First Class |
| November margins | Margins fell from 12-16% (2014-15) to 5-8% (2016-17); discounting and category mix were ruled out, and two loss-making 3D printer models explain the drop |

## Dashboard

| Page | Content |
|---|---|
| Overview | KPI cards, monthly sales vs profit trend, year/region/category slicers |
| Products & Regions | Top 10 and bottom 10 products, region x category margin matrix |
| Discount & Shipping | Profit by discount band, average profit per order line, delivery days by ship mode |

Screenshots are in the `screenshots/` folder.

## Recommendations

- Cap discounts at 20%: orders above that threshold destroy profit.
- Reprice or drop loss-making products (Cubify 3D printers, several conference tables).
- Review Furniture pricing and discounting in the Central region.
- Focus retention efforts on the top customer quintile, which brings in nearly half of revenue.

## Files

- `superstore_sales_analysis.sql`: setup, cleaning, and all analysis queries
- `superstore_dashboard.pbix`: Power BI dashboard
- `screenshots/`: dashboard page screenshots
