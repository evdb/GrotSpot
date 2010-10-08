#!/bin/bash

dropdb grotspot;
createdb grotspot;

for SQL in sql/*.sql; do
    psql grotspot < $SQL;
done
