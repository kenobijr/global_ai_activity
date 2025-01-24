#!/bin/bash

# setup sqlite3 db file
DB_NAME="ai_activity.db"

# check if sqlite3 is installed
if !command -v sqlite3 &> /dev/null; then
  echo "Error: SQLite3 is not installed. Install it and try again."
  exit 1
fi

# remove existing db if it already exists
if [ -f "$DB_NAME" ]; then
  echo "Removing existing database: $DB_NAME"
  rm "$DB_NAME"
fi

# create database and apply schema
sqlite3 $DB_NAME < schema.sql

# populate db
sqlite3 $DB_NAME < data_importing.sql

echo "Database setup complete: $DB_NAME" 
