SELECT *
FROM airline_delays;

-- 1.Total Flights, Delays, Cancellations per Airline
CREATE VIEW vw_carrier_summary AS
SELECT *,
  ROUND(delayed_flights / NULLIF(total_flights, 0) * 100, 2) AS delay_pct,
  ROUND(cancelled_flights / NULLIF(total_flights, 0) * 100, 2) AS cancelled_pct
FROM (
  SELECT 
    carrier_name,
    COUNT(*) AS records,
    SUM(arr_flights) AS total_flights,
    SUM(arr_del15) AS delayed_flights,
    SUM(arr_cancelled) AS cancelled_flights
  FROM airline_delays
  GROUP BY carrier_name
) AS summary
ORDER BY delay_pct DESC;

-- 2.Average Delay by Cause per Airline
CREATE VIEW vw_avg_delay_cause AS
SELECT 
  carrier_name,
  ROUND(AVG(carrier_delay), 2) AS avg_carrier_delay,
  ROUND(AVG(weather_delay), 2) AS avg_weather_delay,
  ROUND(AVG(nas_delay), 2) AS avg_nas_delay,
  ROUND(AVG(security_delay), 2) AS avg_security_delay,
  ROUND(AVG(late_aircraft_delay), 2) AS avg_late_aircraft_delay
FROM airline_delays
GROUP BY carrier_name
ORDER BY avg_carrier_delay DESC;

-- 3.Monthly Trends: Total Flights & Average Delay
CREATE OR REPLACE VIEW vw_monthly_trend AS
SELECT
 year,
 month,
 SUM(arr_flights) AS total_flights,
 ROUND(AVG(arr_delay),2) AS avg_arrival_delay
 FROM airline_delays
 GROUP BY year,month
 ORDER BY year,month;
 
-- 4.Delays by Airport
CREATE OR REPLACE VIEW vw_airport_delay_summary AS
SELECT 
	airport_name,
	ROUND(SUM(arr_del15)/ NULLIF(SUM(arr_flights), 0) * 100, 2) AS delay_pct,
	ROUND(SUM(arr_cancelled)/ NULLIF(SUM(arr_flights), 0) * 100, 2) AS cancelled_pct
FROM airline_delays
GROUP BY airport_name
ORDER BY delay_pct DESC;


