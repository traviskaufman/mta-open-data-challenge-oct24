WITH
ss AS (
    SELECT
        "Complex ID",
        Borough,
        AVG("GTFS Latitude") AS complex_latitude,
        AVG("GTFS Longitude") AS complex_longitude,
        ARRAY_DISTINCT(ARRAY_AGG("Stop Name")) AS stop_names,
        ARRAY_DISTINCT(FLATTEN(ARRAY_AGG(str_split_regex("Daytime Routes", ' ')))) AS lines
    FROM
        main.subway_stations
    GROUP BY
        1, 2
)
, art AS (
    SELECT
        "Station Name",
        str_split_regex(Line, ',') AS lines,
        "Art Title"
    FROM
        main.permanent_art_catalog pac
    WHERE
        Agency = 'NYCT'
)
, art_complexes AS (
    SELECT
        ss.*,
        art."Art Title"
    FROM ss
    LEFT JOIN
        art ON (ARRAY_CONTAINS(ss.stop_names, art."Station Name") AND ARRAY_HAS_ANY(ss.lines, art.lines))
)
, art_2024 AS (
    SELECT
        "Complex ID" AS complex_id,
        ARBITRARY("Borough") AS borough,
        ARBITRARY(complex_latitude) AS complex_latitude,
        ARBITRARY(complex_longitude) AS complex_longitude,
        COUNT(DISTINCT "Art Title") AS num_art_pieces
    FROM
        art_complexes
    GROUP BY
        1
)
, ridership_2024 AS (
    SELECT
        station_complex_id,
        ARBITRARY(station_complex) AS station_complex,
        ARBITRARY(borough) AS borough,
        SUM(ridership) AS ridership
    FROM
        main.ridership_monthly rm
    WHERE
        YEAR("date") = 2024
    GROUP BY
        1
)
SELECT
    a.complex_id,
    r.station_complex,
    r.borough,
    a.complex_latitude,
    a.complex_longitude,
    r.ridership,
    a.num_art_pieces
FROM
    art_2024 a
JOIN
    ridership_2024 r ON (CAST(a.complex_id AS VARCHAR) = r.station_complex_id)
