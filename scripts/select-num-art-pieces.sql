SELECT
	data."Complex ID" AS complex_id,
	arbitrary(data."Stop Name") AS stop_name,
	arbitrary(data.Georeference) AS georeference,
	arbitrary(data.Borough) AS borough,
	SUM(data.num_art_pieces) AS num_art_pieces
FROM (
	SELECT
		ss.*,
		COALESCE(art.num_art_pieces, 0) AS num_art_pieces
	FROM (
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
	) ss
	LEFT JOIN (
		SELECT
			"Station Name",
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
			2
	) art ON
		(ss."Stop Name" = art."Station Name" AND CONTAINS(art.art_line, ss.station_line))
) data
GROUP BY
	1
ORDER BY
	num_art_pieces DESC,
	stop_name ASC,
	borough ASC
