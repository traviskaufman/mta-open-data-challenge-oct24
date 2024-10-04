WITH
ss AS (
    SELECT
        "Complex ID",
        Georeference,
        Borough,
        "Stop Name",
        list_reduce(
            list_sort(
                -- The art pieces table does not have "W" so we need to remove
                list_filter(
                    str_split_regex("Daytime Routes", ' '),
                    s -> s != 'W'
                )
            ),
            (s1, s2) -> concat(trim(s1), ' ', trim(s2))
        ) AS station_line,
    FROM
        main.subway_stations
)
, art AS (
    SELECT
        "Station Name",
        "Art Date",
        list_reduce(
        list_sort(
            str_split_regex(Line,
        ',')
        ),
        (s1,
        s2) -> concat(trim(s1),
        ' ',
        trim(s2))
    ) AS art_line,
        COUNT("Art Title") AS num_art_pieces
    FROM
        main.permanent_art_catalog pac
    WHERE
        Agency = 'NYCT'
    GROUP BY
        1,
        2,
        3
)
, data AS (
    SELECT
        ss.*,
        art."Art Date",
        art.art_line,
        COALESCE(art.num_art_pieces, 0) AS num_art_pieces
    FROM ss
    LEFT JOIN
        art ON (ss."Stop Name" = art."Station Name" AND CONTAINS(art.art_line, ss.station_line))
)
, art_data AS (
    SELECT
        data."Complex ID" AS complex_id,
        strptime(CAST(data."Art Date" AS text), '%Y') AS year_first_displayed,
        arbitrary(data."Stop Name") AS stop_name,
        arbitrary(data.Borough) AS borough,
        arbitrary(data.station_line) AS line,
        arbitrary(data.Georeference) AS georeference,
        SUM(data.num_art_pieces) AS num_art_pieces
    FROM
        data
    GROUP BY
        1, 2
)
, ridership_data AS (
    SELECT
        "date",
        station_complex_id,
        ARBITRARY(station_complex),
        ARBITRARY(borough),
        SUM(ridership) AS ridership,
        SUM(transfers) AS transfers
    FROM
        main.ridership_monthly rm
    GROUP BY
        1, 2
)
SELECT
    ridership_data."date" AS "date",
    art_data.complex_id AS complex_id,
    ARBITRARY(art_data.stop_name) AS stop_name,
    ARBITRARY(art_data.line) AS line,
    ARBITRARY(art_data.borough) AS borough,
    ARBITRARY(art_data.georeference) AS georeference,
    SUM(art_data.num_art_pieces) AS num_art_pieces,
    ARBITRARY(ridership_data.ridership) AS ridership
FROM
    ridership_data
JOIN
    art_data ON (
        ridership_data.station_complex_id = CAST(art_data.complex_id AS text)
        AND (art_data.year_first_displayed IS NULL OR ridership_data."date" >= art_data.year_first_displayed)
    )
GROUP BY
    1,2
ORDER BY
  "date" DESC,
  num_art_pieces DESC,
  ridership DESC,
  stop_name ASC,
  line ASC,
  borough ASC
