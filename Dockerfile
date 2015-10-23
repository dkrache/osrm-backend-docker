 ####################################################################################
 # Copyright (c) 2015, Project OSRM contributors                                    #
 # All rights reserved.                                                             #
 #                                                                                  #
 # Redistribution and use in source and binary forms, with or without modification, #
 # are permitted provided that the following conditions are met:                    #
 #                                                                                  #
 # Redistributions of source code must retain the above copyright notice, this list #
 # of conditions and the following disclaimer.                                      #
 # Redistributions in binary form must reproduce the above copyright notice, this   #
 # list of conditions and the following disclaimer in the documentation and/or      #
 # other materials provided with the distribution.                                  #
 #                                                                                  #
 # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND  #
 # ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED    #
 # WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE           #
 # DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR #
 # ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES   #
 # (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;     #
 # LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON   #
 # ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT          #
 # (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS    #
 # SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                     #
 ####################################################################################
 
FROM debian:jessie

MAINTAINER Djory Krache <dkrache@ebusinessinformation.fr>
MAINTAINER Loic Ortola <lortola@ebusinessinformation.fr>


 ################## CONFIGURATION ########################
 # we define the data file here. 
 # You should check on http://download.geofabrik.de/europe/ to find the pbf file that you need 
 # take those value as examples...
ENV ARCHIVE_URL="http://download.geofabrik.de/europe/france/ile-de-france-latest.osm.pbf"
ENV DOWNLOADED_FILE="ile-de-france-latest"
ENV BUILD_TYPE="Release"
ENV BUILD_CORE="4"

 ################## TOOLS INSTALLATION ########################
RUN apt-get update -y
RUN	apt-get install -y build-essential 
RUN	apt-get install -y git 
RUN	apt-get install -y cmake
RUN	apt-get install -y pkg-config
RUN	apt-get install -y libbz2-dev
RUN	apt-get install -y libstxxl-dev
RUN	apt-get install -y libstxxl1
RUN	apt-get install -y libxml2-dev
RUN	apt-get install -y libzip-dev
RUN	apt-get install -y libboost-all-dev 
RUN	apt-get install -y lua5.1
RUN	apt-get install -y liblua5.1-0-dev
RUN	apt-get install -y libluabind-dev
RUN	apt-get install -y libluajit-5.1-dev
RUN	apt-get install -y libtbb-dev wget


 ################## SERVER INSTALLATION ########################

WORKDIR /home
RUN git clone https://github.com/Project-OSRM/osrm-backend.git
RUN mkdir -p /home/osrm-backend/build

WORKDIR /home/osrm-backend/build
 # Configuration / Generation and build file to build on this platform
RUN cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE ..
 # Create the executable files
RUN make -j $BUILD_CORE
 # Install the project in /usr/local/bin
RUN make install

 # This script will be used to start the server at runtime
COPY run_server.sh run_server.sh
RUN chmod u+x run_server.sh
ENTRYPOINT ./run_server.sh

EXPOSE 5000
