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
