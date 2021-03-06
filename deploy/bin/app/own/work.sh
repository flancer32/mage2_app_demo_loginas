#!/usr/bin/env bash
## *************************************************************************
#   Configure composer.json and install own modules (work mode)
## *************************************************************************

# current directory where from script was launched (to return to in the end)
DIR_CUR="$PWD"
# Root directory (set before or relative to the current shell script)
DIR_ROOT=${DIR_ROOT:=`cd "$( dirname "$0" )/../../../../" && pwd`}



## *************************************************************************
#   Validate deployment mode and load configuration.
## *************************************************************************
MODE=${MODE}
IS_CHAINED="yes"       # 'yes' - this script is launched in chain with other scripts, 'no'- standalone launch;
if [ -z "${MODE}" ]; then
    MODE="work"
    IS_CHAINED="no"
fi

# check configuration file exists and load deployment config (db connection, Magento installation opts, etc.).
FILE_CFG=${DIR_ROOT}/cfg.${MODE}.sh
if [ -f "${FILE_CFG}" ]; then
    if [ "${IS_CHAINED}" = "no" ]; then    # this is standalone launch, load deployment configuration;
        echo "There is deployment configuration in ${FILE_CFG}."
        . ${FILE_CFG}
    # else: deployment configuration should be loaded before
    fi
else
    echo "There is no expected configuration in ${FILE_CFG}. Aborting..."
    cd ${DIR_CUR}
    exit 255
fi



## =========================================================================
#   Working variables and hardcoded configuration.
## =========================================================================

# Folders shortcuts & other vars
DIR_DEPLOY=${DIR_ROOT}/deploy       # folder with deployment templates
DIR_MAGE=${DIR_ROOT}/${MODE}        # root folder for Magento application


echo ""
echo "************************************************************************"
echo "  Custom modules deployment."
echo "************************************************************************"
cd ${DIR_MAGE}

echo "Configure composer.json"
composer config minimum-stability dev


echo ""
echo "Add own modules"
# public module from Packagist
composer require flancer32/mage2_ext_login_as:dev-master


echo ""
echo "************************************************************************"
echo "  Custom modules are deployed."
echo "************************************************************************"
cd ${DIR_CUR}