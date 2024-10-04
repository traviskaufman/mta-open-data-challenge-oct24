-- Run this from root directory of project
CREATE TABLE IF NOT EXISTS permanent_art_catalog AS FROM './data/MTA_Permanent_Art_Catalog__Beginning_1980_20240930.csv';

CREATE TABLE IF NOT EXISTS subway_stations AS FROM './data/MTA_Subway_Stations_20240930.csv';

CREATE TABLE IF NOT EXISTS ridership AS FROM read_csv('./data/MTA_Subway_Hourly_Ridership__Beginning_February_2022.csv', types={'station_complex_id': 'VARCHAR'});

CREATE TABLE IF NOT EXISTS ridership_monthly AS (
	SELECT
		CAST(DATE_TRUNC('month', transit_timestamp) AS DATE) as "date",
		transit_mode ,
		station_complex_id ,
		station_complex ,
		borough ,
		payment_method ,
		fare_class_category ,
		latitude ,
		longitude ,
		Georeference ,
		SUM(ridership) AS ridership,
		SUM(transfers) AS transfers
	FROM
		main.ridership r
	GROUP BY
		1,2,3,4,5,6,7,8,9,10
);
