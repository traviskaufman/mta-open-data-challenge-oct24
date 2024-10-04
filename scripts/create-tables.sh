#!/bin/bash

cat scripts/create-tables.sql | duckdb data/db.duckdb
