WITH ridership AS (
    SELECT
        station_complex_id,
        ARBITRARY(station_complex) AS station_complex,
        ARBITRARY(borough) AS borough,
        AVG(latitude) AS complex_latitude,
        AVG(longitude) AS complex_longitude,
        SUM(ridership) AS ridership,
    FROM
        main.ridership_monthly rm
    WHERE
        YEAR("date") = 2024
    GROUP BY
        1
)
, art AS (
    SELECT
        complex_id,
        COUNT(DISTINCT art_title) AS num_art_pieces
    FROM
        main.art_complex_mappings acm
    GROUP BY
        1
)
SELECT
    ridership.*,
    COALESCE(art.num_art_pieces, 0) AS num_art_pieces
FROM
    ridership
LEFT JOIN
    art ON (ridership.station_complex_id = art.complex_id)
