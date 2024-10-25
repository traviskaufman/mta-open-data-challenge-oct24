# MTA Open Data Challenge

This repository contains code and resources for our contribution to the [October'24 MTA Open Data Challenge](https://new.mta.info/article/mta-open-data-challenge). It contains data attributions as well as instructions for reproducing the results for yourself. We analyze the relationship between artwork and ridership in the NYCT subway system, identifying opportunities to show more art to more people as they move through the subway system.

Note that the scripts and infrastructure in this repo can be reused for mapping other information in relation to ridership. For example, artwork can be swapped out for accessibility data in order to visualize a map of accessibility vs. ridership throughout the subway system.

We are grateful to the MTA for providing Open and Transparent access to their dataset and facilitating such a cool competition!

## Data Attribution

We use the following datasets in our analysis:

- [MTA Subway Stations](https://data.ny.gov/Transportation/MTA-Subway-Stations/39hk-dx4f/about_data)
- [MTA Hourly Ridership: Beginning February 2022](https://dev.socrata.com/foundry/data.ny.gov/wujg-7c2s)
- [MTA Permanent Art Catalog: Beginning 1980](https://data.ny.gov/Transportation/MTA-Permanent-Art-Catalog-Beginning-1980/4y8j-9pkd/about_data)

To aid in rendering our map, we use the following GeoJSON from NYC OpenData:

- [Borough Boundaries](https://data.cityofnewyork.us/City-Government/Borough-Boundaries/tqmj-j8zm)
- [Subway Lines](https://data.cityofnewyork.us/Transportation/Subway-Lines/3qz8-muuu)

All data was retrieved on September 30th, 2024, and goes until Sep 1st, 2024.

Furthermore, we custom-curated a mapping between each piece of art and the subway complex it is located in. This is available for view at: https://docs.google.com/spreadsheets/d/1IEqPQyu5o2yMcwpfOMNf-xj3ND0kjNEjm8WQ2J4qLG0/edit?usp=sharing

## Installation

> You will need a recent version of [NodeJS](https://nodejs.org) to run the app

```
git clone https://github.com/traviskaufman/mta-open-data-challenge-oct24.git
cd mta-open-data-challenge-oct24
npm install
```

## Running the app

Simply run:

```
npm start
```

Which will start a [Vite](https://vite.dev/) production server where you can view the page.

You can also run `npm run dev` to start a development server in case you would like to make changes.

## Recreating the data

> **NOTE**: All prepared data is available at https://gist.github.com/traviskaufman/e33677d3dd62d16f9f4c8c08dd290f20 for inspection

There are scripts checked into the `scripts/` directory in case you would like to recreate the data used within this analysis. These scripts assume you are using [DuckDB](https://duckdb.org/), but each contains an accompanying SQL file that should be easily adaptable to your own engine.

1. `mkdir -p data/`
1. Copy the Google Sheet linked above to `data/art_stations_to_complex_ids.csv - prod.csv`
1. Copy the CSV for MTA Permanent Art Catalog to `data/MTA_Permanent_Art_Catalog__Beginning_1980_20240930.csv`
1. Copy the CSV for MTA Subway Hourly Ridership to `data/MTA_Subway_Hourly_Ridership__Beginning_February_2022.csv`
1. Copy the CSV for MTA Subway Stations to `data/data/MTA_Subway_Stations_20240930.csv`
1. Run `./scripts/create-tables.sh`, which should create a database under `data/db.duckdb`
1. Run `./scripts/prep-data.sh` to create `data-prepped/data-prepped.csv`

Upload `data-prepped/data-prepped.csv` to a publicly accessible URL. Once done:

- In `viz/map.vg.json`, look for the object within the `data` array whose `name` is `art_ridership`. Replace the `url` string with your URL.
- Perform the same action for `viz/insights.vg.json` and `viz/insights2.vg.json`

Note that we use [Vega](https://vega.github.io/vega/) for rendering all of our visualizations, and therefore these JSON files represent vega specifications.

You should now be able to see the map and insights graphs populate with your data. Note that you can also replace the borough boundaries and subway lines data by uploading the respective GeoJSON files to a publicly accessible URL, and replacing the URL values for those data sets in the vega specs.
