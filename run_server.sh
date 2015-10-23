#!/bin/bash

if ! ( test -f "${DOWNLOADED_FILE}.osm.pbf" )
then 
	# No archive. get ENV variable and download
	wget $ARCHIVE_URL
	ln -s /home/osrm-backend/profiles/car.lua profile.lua
	ln -s /home/osrm-backend/profiles/lib/
	osrm-extract "${DOWNLOADED_FILE}.osm.pbf"
	osrm-prepare "${DOWNLOADED_FILE}.osrm"
fi
	
osrm-routed ${DOWNLOADED_FILE}.osrm
