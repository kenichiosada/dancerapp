#!/bin/bash

sh run_script.sh setup/setup_tables.pl -o new
sh run_script.sh setup/create_user.pl -o testuser -o test123
sh run_script.sh setup/create_dir.pl
