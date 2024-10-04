#!/bin/bash

cat scripts/select-num-art-pieces.sql | duckdb data/db.duckdb -csv
