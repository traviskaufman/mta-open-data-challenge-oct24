#!/bin/bash

cat scripts/prep-data.sql | duckdb data/db.duckdb -csv
