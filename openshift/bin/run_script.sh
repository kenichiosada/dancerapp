#!/bin/bash

# Set env variables
if [ -z "$OPENSHIFT_APP_NAME" ]; then
  # dev
  export APP_HOME=${PWD%/*/*}/
  LIB_DIR=${APP_HOME}openshift/lib/
  if [ -z "$PERL5LIB" ]; then
    export PERL5LIB="$LIB_DIR"
  else 
    export PERL5LIB="$LIB_DIR:$PERL5LIB"
  fi
  export OPENSHIFT_TMP_DIR="/tmp"
  export OPENSHIFT_LOG_DIR=${APP_HOME}/logs/
  export DANCER_ENVIRONMENT='development'
  export DANCER_ENVDIR=${APP_HOME}environments
  export DANCER_CONFDIR=${APP_HOME}openshift
else 
  # prod
  export APP_HOME=${OPENSHIFT_REPO_DIR}
  export PERL5LIB=${APP_HOME}openshift/lib/:$PERL5LIB
  export DANCER_ENVIRONMENT='production'
  export DANCER_ENVDIR=${APP_HOME}openshift/environments
  export DANCER_CONFDIR=${APP_HOME}openshift
fi

function usage {
  echo "Call example: sh run_script.sh script_name -option"
}

# Lock file
# ref: http://qiita.com/KurokoSin/items/0eddf05818b89b627102 
function checkDuplicate()
{
    local RET=0
    local base=${0##*/}
    local pidfile="$OPENSHIFT_TMP_DIR/${base}.pid"

    while true; do
        if ln -s $$ ${pidfile} 2> /dev/null
        then
            RET=0 && break
        else
            p=$(ls -l ${pidfile} | sed 's@.* @@g')
            if [ -z "${p//[0-9]/}" -a -d "/proc/$p" ]; then
                local mypid=""
                for mypid in $(pgrep -f ${base})
                do
                    [ ${p} -eq ${mypid} ] && RET=1 && break
                done;
            fi

            [ ${RET} -ne 0 ] && break
        fi

        rm -f ${pidfile}
    done

    if [ ${RET} -eq 0 ]; then
        trap "rm -f ${pidfile}; exit 0" EXIT
        trap "rm -f ${pidfile}; exit 1" 1 2 3 15
    fi

    return ${RET}
}


## Check options
for OPT in "$@"
do 
  case "$OPT" in 
    '-help')
      usage
      exit 1
      ;;
    '-o')
     PARAM="$PARAM $2" 
     shift 2 
     ;;
    -*)
      echo "illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2 
      exit 1
      ;;
    *)
      if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
        if [ !$TARGET ]; then
          TARGET=$1
          shift 1
        fi
      else 
        if [ -z "$TARGET" ]; then
        echo "No script to run is specified" 1>&2
        exit 1
        fi
      fi
      ;; 
  esac
done

if [ $TARGET ] && [ ! -f $TARGET ]; then
  echo "$TARGET does not exist" 1>&2
else
  checkDuplicate
  if [ 0 -ne $? ]; then
    echo "Script already running"
    exit 1
  else
    if [ "$PARAM" ]; then 
      ./$TARGET $PARAM 
    else 
      ./$TARGET
    fi
  fi
fi  


