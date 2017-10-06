#!/bin/ksh
export saveLang=$LANG
typeset thisOS=$(uname -s)

#export myPath="$(cd $(dirname $0); pwd)"
export myPath=/ITM
export CANDLEHOME="/tools/tivoli/ITM"
export UnzipPath="/tools/tivoli/"
hs=`hostname | awk -F"." '{print $1;}'`

    # check for selinux
    if [[ "$thisOS" != "Linux" ]]; then
        print "Exiting Install only valid for Linux\n"
        exit 0
    fi


    if [ ! -f "${myPath}/ITM.tar.gz" ]; then
        echo Error: there should be an ITM with this script
        exit 0
    fi

    mkdir -p "$UnzipPath"
    cd $UnzipPath


    printf "Inflating compressed image\n"
    cd $UnzipPath
    tar -pxf ${myPath}/ITM.tar.gz
    if [ $? -ne 0 ]; then                                                                                                                 
        printf  "could not extract source files from image \"$CANDLEHOME/ITM.tar.gz\"\n"                                                  
        exit 0                                                                                                                            
    fi                                                                                                                                    
    rm -f ${CANDLEHOME}/logs/*
    echo "FIELDSEP=|" > ${CANDLEHOME}/config/.ConfigData/RunInfo
    echo "" > ${CANDLEHOME}/config/.ConfigData/RunInfo_Description
    #Get Old hostname
    oldhost=`grep RUNNINGHOSTNAME ${CANDLEHOME}/config/.ConfigData/klzenv | grep -v default | cut -d'|' -f3`
    newhost=`${CANDLEHOME}/bin//ITMhostName`
    if [ -f "${CANDLEHOME}/config/${oldhost}_lo.cfg" ]; then
        mv ${CANDLEHOME}/config/${oldhost}_lo.cfg ${CANDLEHOME}/config/${newhost}_lo.cfg
    fi

    if [ -f "${CANDLEHOME}/config/${oldhost}_0g.cfg" ]; then
        mv ${CANDLEHOME}/config/${oldhost}_0g.cfg ${CANDLEHOME}/config/${newhost}_0g.cfg
    fi

    if [ -f "${CANDLEHOME}/config/${oldhost}_Lin_Syslog.cfg" ]; then
        mv ${CANDLEHOME}/config/${oldhost}_Lin_Syslog.cfg ${CANDLEHOME}/config/${newhost}_Lin_Syslog.cfg
    fi

    sed -i "s/${oldhost}/${newhost}/g" ${CANDLEHOME}/config/*.ini  ${CANDLEHOME}/config/.*.ini ${CANDLEHOME}/config/*.config ${CANDLEHOME}/config/*.shl ${CANDLEHOME}/config/.ConfigData/*env

    ${CANDLEHOME}/bin/SetPerm -a
    ${CANDLEHOME}/bin/UpdateAutoRun.sh


    cat /dev/null > /tmp/itmagnt
    ${CANDLEHOME}/bin/itmcmd config -A -p /tmp/itmagnt lz
    ${CANDLEHOME}/bin/itmcmd config -A -p /tmp/itmagnt 0g
    ${CANDLEHOME}/bin/itmcmd config -A -p /tmp/itmagnt -o Lin_Syslog lo

    ${CANDLEHOME}/bin/itmcmd agent start lz
    ${CANDLEHOME}/bin/itmcmd agent start 0g
    ${CANDLEHOME}/bin/itmcmd agent -o Lin_Syslog start lo
