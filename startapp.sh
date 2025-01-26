#!/bin/sh -f

cd /data
if [ -e /data/infile.sbml ]; then
    /opt/COPASI/4.44.295/bin/CopasiUI /data/infile.sbml
else
    /opt/COPASI/4.44.295/bin/CopasiUI
    echo "Load without initial SBML file"
fi


