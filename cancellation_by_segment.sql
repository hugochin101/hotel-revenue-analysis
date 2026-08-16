SELECT
    ms.market_segment,
    COUNT(*) AS total_bookings,
    SUM(b.is_canceled) AS cancellations,
    ROUND(100.0 * SUM(b.is_canceled) / COUNT(*), 1) AS cancellation_rate_pct
FROM bookings b
JOIN market_segment ms ON b.market_segment = ms.market_segment
GROUP BY ms.market_segment
ORDER BY cancellation_rate_pct DESC;
