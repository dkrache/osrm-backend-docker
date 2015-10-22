 ####################################################################################
 # Copyright (c) 2015, Project OSRM contributors									#
 # All rights reserved.																#
 # 																					#
 # Redistribution and use in source and binary forms, with or without modification,	#
 # are permitted provided that the following conditions are met:					#
 # 																					#
 # Redistributions of source code must retain the above copyright notice, this list	#
 # of conditions and the following disclaimer.										#
 # Redistributions in binary form must reproduce the above copyright notice, this	#
 # list of conditions and the following disclaimer in the documentation and/or		#
 # other materials provided with the distribution.									#
 # 																					#
 # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND	#
 # ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED	#
 # WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE			#
 # DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR	#
 # ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES	#
 # (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;		#
 # LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON	#
 # ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT			#
 # (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS	#
 # SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.						#
 ####################################################################################
 
FROM debian:jessie

MAINTAINER Djory Krache <dkrache@ebusinessinformation.fr>
MAINTAINER Loic Ortola <lortola@ebusinessinformation.fr>

RUN apt-get update && \
	apt-get install -y build-essential git cmake pkg-config \
		libbz2-dev libstxxl-dev libstxxl1 libxml2-dev \
		libzip-dev libboost-all-dev lua5.1 liblua5.1-0-dev \
		libluabind-dev libluajit-5.1-dev libtbb-dev wget

WORKDIR /home

RUN git clone https://github.com/Project-OSRM/osrm-backend.git

RUN mkdir -p /home/osrm-backend/build

WORKDIR /home/osrm-backend/build

 # Configuration / Generation and build file to build on this platform
RUN cmake ..
 # Create the executable files
RUN make
 # Install the project in /usr/local/bin
RUN make install

WORKDIR /home/osrm-backend

 # This script will start the server
COPY run_server.sh run_server.sh
RUN chmod u+x run_server.sh

 # You could want to remove or modify this line in order to init the server with an other data.
 # or put it in the run_server.sh to be sure that it's always the latest.
 # i download it in the build because it's a 3Go file so i don't want to download it every time.  
RUN wget http://download.geofabrik.de/europe/france-latest.osm.pbf

ENTRYPOINT ./run_server.sh

EXPOSE 5000
