#!/bin/bash
DATABASE_NAME="aaquestions.db"
rm ./$DATABASE_NAME
cat "data/import_db.sql" | sqlite3 $DATABASE_NAME