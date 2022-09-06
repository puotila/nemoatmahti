#! /bin/sh

URL='https://ige-meom-opendap.univ-grenoble-alpes.fr/thredds/fileServer/meomopendap/extract/eORCA025.L121/eORCA025.L121-I'
WGET='wget -nc'

${WGET} ${URL}/eORCA025.L121-I/eORCA025_coord_c3.0.nc
${WGET} ${URL}/eORCA025_bathymetry_b0.2.nc
${WGET} ${URL}/eORCA025.L121_domain_cfg_b0.2_c3.0_d1.0.nc
${WGET} ${URL}/eORCA025_runoff_b0.2_v0.0.nc
${WGET} ${URL}/eORCA025.L121_WOA2018_b0.2_c3.0_d1.0_v19812010.5.nc
${WGET} ${URL}/eORCA025_seaice_c3.0_v19802004.0.nc
${WGET} ${URL}/eORCA025_sss_WOA2018_c3.0_v19812010.5.nc
${WGET} ${URL}/eORCA025_calving_b0.2_v2.3.nc
${WGET} ${URL}/ghflux_v2.0.nc
${WGET} ${URL}/eORCA025_ghflux_v2.0_c3.0_weights_bilin.nc
${WGET} ${URL}/eORCA025_ttv_b0.2_v0.0.nc
${WGET} ${URL}/eORCA025_iwm_b0.2_v0.0.nc
${WGET} ${URL}/chlorophyl_v0.0.nc
${WGET} ${URL}/eORCA025_chlorophyl_v0.0_c3.0_weights_bilin.nc
${WGET} ${URL}/eORCA025_shlat2d_v0.0.nc
${WGET} ${URL}/eORCA025_bfr2d_v0.2.nc
${WGET} ${URL}/eORCA025_mskitf_v1.0.nc
${WGET} ${URL}/eORCA025_distcoast_b0.2_v0.0.nc
#${WGET} ${URL}/eORCA025.L121_dmpmask_b0.2_c0.3_d1.0_v0.0.nc

${WGET} ${URL}/eORCA025_JRA55_do_c3.0_weights_bilin.nc
${WGET} ${URL}/eORCA025_JRA55_do_c3.0_weights_bicubic.nc
${WGET} ${URL}/eORCA025_DFS5.2_c3.0_weights_bilin.nc
${WGET} ${URL}/eORCA025_DFS5.2_c3.0_weights_bicubic.nc

