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
