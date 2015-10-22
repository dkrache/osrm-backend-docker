#!/bin/bash
osrm-extract france-latest.osm.pbf
osrm-prepare france-latest.osrm
osrm-routed france-latest.osrm
