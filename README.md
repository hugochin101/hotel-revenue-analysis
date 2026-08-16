# Hotel Revenue & Booking Analysis

**[View the live interactive dashboard →](https://public.tableau.com/app/profile/hugo.chin5971/viz/HotelRevenueBookingAnalysis_17868858873670/HotelRevenueDashboard)**

An end-to-end data analysis project: raw booking data → PostgreSQL database → SQL analysis → Tableau dashboard. Built to practice real analyst workflows — writing production-style SQL, catching data quality issues, and communicating findings visually.

## Data source

[Hotel Revenue Data Project](https://www.kaggle.com/datasets/ferranindata/hotel-revenue-data-project) (Kaggle, by ferranindata) — three years (2018-2020) of real hotel booking records across two hotel types, ~142,000 bookings total, plus lookup tables for meal plan cost and market segment discounts.

## Tech stack

- **PostgreSQL** (via Postgres.app) — database
- **SQL** — joins, aggregations, `CASE` expressions, date/time handling
- **Tableau Public** — dashboard and visualization

## Key findings

**1. Group bookings cancel at nearly double the rate of any other channel.**
Groups cancel 61.8% of the time (16,143 of 26,115 bookings) — compared to 35.9% for Online Travel Agents, the next-highest segment, and just 19.0% for Corporate bookings. This is a real operational risk worth flagging: Groups is a high-volume channel with the least reliable follow-through.

**2. City Hotel consistently outearns Resort Hotel, every year.**
Across 2018-2020, City Hotel revenue exceeded Resort Hotel revenue in every single year, with the gap widening in 2020. Total combined room revenue across the period: **£30,540,724**.

**3. 2019 was the peak year by a wide margin** (~£16M), with both 2018 and 2020 showing partial-year data — a data quality detail confirmed by checking the raw records, not assumed.

## Data quality notes

- A `market_segment` value of "Undefined" (4 bookings, all cancelled) was excluded from the cancellation-rate analysis — at that sample size, a 100% rate is statistical noise, not a real trend.
- 2018 data begins in July, not January — the year-over-year monthly comparison accounts for this rather than treating it as a decline.

## SQL

### Revenue by hotel type and year
```sql
SELECT
    b.hotel,
    b.arrival_date_year,
    COUNT(*) AS total_bookings,
    ROUND(SUM(b.adr * (b.stays_in_weekend_nights + b.stays_in_week_nights))::numeric, 2) AS room_revenue,
    ROUND(AVG(m."Cost")::numeric, 2) AS avg_meal_cost
FROM bookings b
JOIN meal_cost m ON b.meal = m.meal
WHERE b.is_canceled = 0
GROUP BY b.hotel, b.arrival_date_year
ORDER BY b.arrival_date_year, b.hotel;
```

### Cancellation rate by market segment
```sql
SELECT
    ms.market_segment,
    COUNT(*) AS total_bookings,
    SUM(b.is_canceled) AS cancellations,
    ROUND(100.0 * SUM(b.is_canceled) / COUNT(*), 1) AS cancellation_rate_pct
FROM bookings b
JOIN market_segment ms ON b.market_segment = ms.market_segment
GROUP BY ms.market_segment
ORDER BY cancellation_rate_pct DESC;
```

### Monthly seasonality
```sql
SELECT
    b.arrival_date_year,
    b.arrival_date_month,
    COUNT(*) AS total_bookings,
    ROUND(100.0 * SUM(b.is_canceled) / COUNT(*), 1) AS cancellation_rate_pct,
    ROUND(AVG(b.adr)::numeric, 2) AS avg_daily_rate
FROM bookings b
GROUP BY b.arrival_date_year, b.arrival_date_month
ORDER BY b.arrival_date_year,
    CASE b.arrival_date_month
        WHEN 'January' THEN 1 WHEN 'February' THEN 2 WHEN 'March' THEN 3
        WHEN 'April' THEN 4 WHEN 'May' THEN 5 WHEN 'June' THEN 6
        WHEN 'July' THEN 7 WHEN 'August' THEN 8 WHEN 'September' THEN 9
        WHEN 'October' THEN 10 WHEN 'November' THEN 11 WHEN 'December' THEN 12
    END;
```

## Dashboard

Three views combined into one interactive dashboard:
- **Monthly Trend** — booking volume by month, split by year
- **Cancellation by Segment** — cancellation rate across all 7 valid market segments
- **Revenue by Hotel** — room revenue by hotel type, 2018-2020

[View it live on Tableau Public](https://public.tableau.com/app/profile/hugo.chin5971/viz/HotelRevenueBookingAnalysis_17868858873670/HotelRevenueDashboard)
