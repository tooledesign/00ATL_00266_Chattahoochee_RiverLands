#!/usr/bin/bash

# Run this script to create a new database on a PostGIS server
# The script guides the user with input pormpts needed to create a database
# Upon successful creation of db it will also do the following:
    # write the query to a create_db.sql file and also write the details to README.md
    # create a SQLTOOLS connection in your .vscode/settings.json
    # add the database to a QGIS connection xml file

MYPATH="$PWD"
# HOST=192.168.XX.227
# DB=
# PROJ_NUM=""
# ANALYST=""
# MANAGER=""
# SRID=""


if [ -z "$PROJ_NUM" ]
then
    read -p "Enter Project Number: " PROJ_NUM
    echo $PROJ_NUM
fi


if [ -z "$ANALYST" ]
then
    read -p "Enter your name or the name of the lead analyst: " ANALYST
    echo $ANALYST
fi

if [ -z "$MANAGER" ]
then
    read -p "Enter Project Manager Name: " MANAGER
    echo $MANAGER
fi

if [ -z "$SRID" ]
then
    read -p "Enter SRID details: " SRID
    echo $SRID
fi

if [ -z "$HOST" ]
then
    read -p "Enter host (hit enter if it is 'localhost'): " HOST
fi

if [ -z "$DB" ]
then
    read -p "Enter database name: " DB
fi


read -p "Enter template (hit enter if it is 'template1'): " TEMPLATE_DB
read -p "Enter database owner (hit enter if it is 'gis'): " OWNER
read -p "Enter database password (hit enter if it is 'gis'): " PASSWORD

if [ -z "$HOST" ]
then
    HOST="localhost"
fi

if [ -z "$TEMPLATE_DB" ]
then
    TEMPLATE_DB="template1"
fi

if [ -z "$OWNER" ]
then
    OWNER="gis"
fi

if [ -z "$PASSWORD" ]
then
    PASSWORD="gis"
fi

SQLTOOLS_JSON_STRING="{
    \"previewLimit\": 50,
    \"server\": \"$HOST\",
    \"port\": 5432,
    \"driver\": \"PostgreSQL\",
    \"name\": \"$DB\",
    \"database\": \"$DB\",
    \"username\": \"$OWNER\",
    \"password\": \"$PASSWORD\"
}"

QGIS_CONNECTION_STRING="<!-- add new connections here -->\
\n\
    <postgis \
database=\"$DB\" \
projectsInDatabase=\"false\" \
service=\"\" \
host=\"$HOST\" \
estimatedMetadata=\"false\" \
port=\"5432\" \
geometryColumnsOnly=\"false\" \
name=\"$DB\" \
dontResolveType=\"false\" \
allowGeometrylessTables=\"true\" \
publicOnly=\"false\" \
saveUsername=\"true\" \
username=\"$OWNER\" \
password=\"$PASSWORD\" \
savePassword=\"true\" \
sslmode=\"SslPrefer\"\/>\
"

# try creating database, if successful write the query to a file, create a SQL tools connection file, update README.md, and create QGIS connection xml file
if psql -h $HOST -U postgres -d postgres -c "CREATE DATABASE \"$DB\" WITH TEMPLATE $TEMPLATE_DB OWNER $OWNER;"
then
    echo "Writing creation query to create_db.sql file\n"
    echo "CREATE DATABASE \"$DB\" WITH TEMPLATE $TEMPLATE_DB OWNER $OWNER;" >> "$MYPATH/create_db.sql"

    DB_COMMENT=""

    echo "Updating README.md with project and database details\n"
    if [ "$MANAGER" ]
    then 
        sed -i "s/\[enter project manager name here\]/\`${MANAGER}\`/g" README.md
        DB_COMMENT+=$'Project Manager: '"$MANAGER"$'\n'
    fi
    if [ "$PROJ_NUM" ]
    then
        sed -i "s/\[enter project number here\]/\`${PROJ_NUM}\`/g" README.md
        DB_COMMENT+=$'Project Number: '"${PROJ_NUM}"$'\n'
    fi
    if [ "$ANALYST" ]
    then
        sed -i "s/\[enter name here\]/\`${ANALYST}\`/g" README.md
        DB_COMMENT+=$'Analyst: '"${ANALYST}"$'\n'
    fi
    if [ "$SRID" ]
    then
        SRID_ESCAPED="${SRID//\//\\/}"
        sed -i "s/\[enter SRID\/CRS, e.g., EPSG:26849\]/\`${SRID_ESCAPED}\`/g" README.md
        DB_COMMENT+=$'SRID: '"${SRID}"$'\n'
    fi

    sed -i "s/\[enter server IP address\]/\`${HOST}\`/g" README.md
    sed -i "s/\[enter database name\]/\`${DB}\`/g" README.md

    # add comments to the database
    echo "Adding comments to database"
    # DB_COMMENT=$'Project: '"${PROJ_NUM}"$'\nPM: '"$MANAGER"$'\nAnalyst: '"${ANALYST}"$'\nCreated on: '"$(date +%Y-%m-%d)"
    if psql -h "$HOST" -U postgres -d postgres -c "COMMENT ON DATABASE \"$DB\" IS '$DB_COMMENT';"
    then
        echo "Comment added to database successfully"
        echo "COMMENT ON DATABASE \"$DB\" IS '$DB_COMMENT';" >> "$MYPATH/create_db.sql"
    else
        echo "Failed to add comment to database"
    fi

    echo "Writing SQLTools connection to .vscode/settings.json"
    # create .vscode folder if it does not exist
    if [ ! -d "$MYPATH/.vscode" ]
    then
        mkdir "$MYPATH/.vscode"
    fi

    SETTINGS_JSON="$MYPATH/.vscode/settings.json"

    if test ! -f "$SETTINGS_JSON"; then
        JSON_STRING="{
            \"sqltools.connections\": [
                $SQLTOOLS_JSON_STRING
            ]
        }"
        echo $JSON_STRING > $SETTINGS_JSON
    else
        # only add a new connection if it isn't already in settings as duplicate connections with the same name are causing issues
        if [ ! -n "$(jq -r ".\"sqltools.connections\"[].name | select(. == \"$DB\")" "$SETTINGS_JSON")" ]; then
            jq --argjson new_connection "$SQLTOOLS_JSON_STRING" '.["sqltools.connections"] |= if . == null then [$new_connection] else . + [$new_connection] end' $SETTINGS_JSON > temp.json && mv temp.json $SETTINGS_JSON
        fi
    fi

    echo "Writing QGIS connection details to qgis_connection.xml"
    # add database to a QGIS connection xml file
    QGIS_CONNECTION_XML="$MYPATH/qgis_connection.xml"

    # create xml file if it does not exist
    if test ! -f "$QGIS_CONNECTION_XML"; then
        echo "<!DOCTYPE connections>" > $QGIS_CONNECTION_XML
        echo "<qgsPgConnections version=\"1.0\">" >> $QGIS_CONNECTION_XML
        echo "    <!-- add new connections here -->" >> $QGIS_CONNECTION_XML
        echo "</qgsPgConnections>" >> $QGIS_CONNECTION_XML
    fi

    sed -i "s/<!-- add new connections here -->/${QGIS_CONNECTION_STRING}/g" $QGIS_CONNECTION_XML
fi