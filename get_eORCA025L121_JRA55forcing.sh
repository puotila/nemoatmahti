#! /bin/sh

URL='https://ige-meom-opendap.univ-grenoble-alpes.fr/thredds/fileServer/meomopendap/extract/eORCA025.L121/eORCA025.L121-BLD/FORCING'
WGET='wget -nc'

#${WGET} ${URL}/eORCA025_JRA55_do_c3.0_weights_bilin.nc
#${WGET} ${URL}/eORCA025_JRA55_do_c3.0_weights_bilin.nc

URL='https://ige-meom-opendap.univ-grenoble-alpes.fr/thredds/fileServer/meomopendap/extract/eORCA025.L121/eORCA025.L121-OPM026/forcing'
${WGET} ${URL}/drowned_uas_JRA55_y1958.nc
${WGET} ${URL}/drowned_vas_JRA55_y1958.nc
${WGET} ${URL}/drowned_rsds_JRA55_y1958.nc
${WGET} ${URL}/drowned_rlds_JRA55_y1958.nc
${WGET} ${URL}/drowned_tas_JRA55_y1958.nc
${WGET} ${URL}/drowned_huss_JRA55_y1958.nc
${WGET} ${URL}/drowned_tprecip_JRA55_y1958.nc
${WGET} ${URL}/drowned_prsn_JRA55_y1958.nc
${WGET} ${URL}/drowned_psl_JRA55_y1958.nc
