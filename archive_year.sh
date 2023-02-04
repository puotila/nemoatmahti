#!/usr/bin/bash -x

export OS_PROJECT_NAME=project_2004927
export OS_PASSWORD=N0WgR1IQWNSv
module load allas
# allas-conf -k project_2004927
source /appl/opt/csc-tools/allas-cli-utils/allas_conf -f -k $OS_PROJECT_NAME

#YEAR=2001
YEAR=$1
RSTTIME=`printf "%08d" $(( 365*24*3*(${YEAR}-1978) ))`

CONF=eORCA025.L75
BUCKET=nemo4.0.7.${CONF}.EXP01

tar -cvf ${BUCKET}_${RSTTIME}_restart.tar ${CONF}_${RSTTIME}_restart_????.nc 
a-put -b ${BUCKET} ${BUCKET}_${RSTTIME}_restart.tar 
rm ${BUCKET}_${RSTTIME}_restart.tar

tar -cvf ${BUCKET}_1m_${YEAR}.tar ${CONF}_1m_${YEAR}0101_${YEAR}1231_*.nc
a-put -b ${BUCKET} ${BUCKET}_1m_${YEAR}.tar 
rm ${BUCKET}_1m_${YEAR}.tar 

unset OS_PASSWORD

OLDRSTTIME=`printf "%08d" $(( 365*24*3*(${YEAR}-1978-1) ))`
rm ${CONF}_${OLDRSTTIME}_restart_????.nc 
