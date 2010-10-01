#!/bin/bash

dropdb grotspot;
createdb grotspot;
psql grotspot < sql/*.sql
