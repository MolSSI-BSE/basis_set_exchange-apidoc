#!/bin/bash

set -u

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOPDIR="$(dirname "${MYDIR}")"
TESTLOGS="${MYDIR}/logs"

echo ""
echo "----------------------------------------------------------"
echo "Running example scripts in ${TOPDIR}"
echo "----------------------------------------------------------"
rm -Rf "${TESTLOGS}"
mkdir -p "${TESTLOGS}"

FAILED=0
TOTAL=0

for TEST in "${TOPDIR}"/examples/python/*.py \
            "${TOPDIR}"/examples/bash/*.sh
do
    TOTAL=$((TOTAL+1))
    FILENAME="$(basename "${TEST}")"
    printf "%20s ..... " "${FILENAME}"
    if [[ ! -x ${TEST} ]]
    then
        printf "NOT EXECUTABLE\n"
        FAILED=$((FAILED+1))
        continue
    fi

    LOGFILE="${TESTLOGS}/${FILENAME}.log"
    $("${TEST}" &> "${LOGFILE}")    
    RESULT=$?
    
    if [[ ${RESULT} == 0 ]]
    then
        printf "OK\n"
    else
        FAILED=$((FAILED+1))
        printf "FAILED\n"
    fi
done

SUCCESS=$((TOTAL-FAILED))
echo "----------------------------------------------------------"
echo "RESULTS: ${SUCCESS}/${TOTAL} succeeded (${FAILED} failures)"
echo "----------------------------------------------------------"
echo ""

if [[ ${FAILED} > 0 ]]
then
    exit 1
else
    exit 0
fi
