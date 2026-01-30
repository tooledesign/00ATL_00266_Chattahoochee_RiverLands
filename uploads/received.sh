#!/bin/bash

# this is a template for uploading data to postgis db. Update the values below as needed for the project.
HOST="host_ip"
DB="db_name"
PORT=5432
USER="gis"
PW="gis"
SRID="EPSG:xxxx"

PG="host=$HOST port=$PORT dbname=$DB user=$USER password=$PW"

GIS_FOLDER="/mnt/k/path/to/gis/folder"
PROJECT_FOLDER="/mnt/h/path/to/project/folder"

ogr2ogr -f "PostgreSQL" PG:"$PG" \
   "file_path_or_url" \
   -nln received.table \
   -lco GEOMETRY_NAME=geom -lco precision=NO -t_srs $SRID -overwrite -progress --config PG_USE_COPY YES


# helpful optional argumentsfrom:
# https://gdal.org/en/stable/programs/ogr2ogr.html
#  -skipfailures  # can results in problems when rows are skipped
# -nlt CONVERT_TO_LINEAR 
# -nlt PROMOTE_TO_MULTI
# -clipdst [<xmin> <ymin> <xmax> <ymax>] or <datasource>
# -sql "SELECT * FROM automated.fpa_results"
