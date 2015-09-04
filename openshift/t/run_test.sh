#!/bin/sh

export DANCER_ENVIRONMENT='sandbox'
export APP_HOME="$(dirname ${PWD})"
export PERL5LIB=${APP_HOME}/lib:${APP_HOME}/t
export DANCER_ENVDIR=${APP_HOME}/environments
export DANCER_CONFDIR=${APP_HOME}

function usage {
  echo "Running single test: sh run_test.sh"
  echo "Running all tests: sh run_test.sh -all"
}

function run_all {
  prove -r 
}

function run_single {
  echo "Enter test name/path: "
  read test_name
  perl $test_name
}

## Check options
for OPT in "$@"
do 
  case "$OPT" in 
    '-help')
      usage
      exit 1
      ;;
    '-all')
      run_all
      exit 1
     ;;
    -*)
      echo "illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2 
      exit 1
      ;;
    *)
      perl $1
      exit 1
      ;; 
  esac
done

run_single

