# Name

Sample Dancer Application

# Description

Sample web application built with Perl Dancer.  
Purpose of this sample application is to show examples of:
  * Using DBIx::Class within Dancer  
  * Writing Plugins for Dancer  
  * Writing tests for Dancer application  
  * Deploying application on [OpenShift PaaS](https://www.openshift.com/)  

# Demo

[Sample Dancer Application](http://sample-dancerapp.rhcloud.com)  

Demo is running with Openshift's default Perl cartridge with MySQL.  
  * Perl 5.10  
  * Apache 2.2  
  * MySQL 5.5  

It is recommended to use versions above or higher for development. 

# Deployment

Create MySQL database 

    CREATE DATABASE sample CHARACTER SET utf8 CLLATE utf8_general_ci;

Run setup script

    cd openshift/bin
    sh setup.sh  

This will create new tables, test user account, and extra directories needed for the application.  

## For local environment

In order to run the application on your local environement, you'll need to set up a config file for your environement.  

    cd openshift/lib/Conf
    cp production.conf development.conf

Please edit the new config file accordingly.  

The sample application is running from Apache with Plack, but you can also run it with plackup.  

    cd openshift/bin
    plackup app.pl --enable-ssl --ssl-key-file=server.key --ssl-cert-file=server.crt

Create self signed SSL certificate for test.  

You can also run it with Carton if you're using Carton for dependency management.  

    carton install
    cd openshift/bin
    carton exec plackup app.pl --enable-ssl --ssl-key-file=server.key --ssl-cert-file=server.crt

# Testing

First off, create MySQL database for test.  

    CREATE DATABASE sandbox CHARACTER SET utf8 CLLATE utf8_general_ci;

You'll need to setup a config file for test environment.  

    cd openshift/lib/Conf
    cp production.conf sandbox.conf

Please edit the new config file accordingly.  

You can process a single test file or all tests at once.  

    cd t
    sh test.sh
    Enter test name/path: 

# Author 

Copyright (C) 2015, Kenichi Osada  

This program is free software; you can redistribute it and/or modify it under the same terms as Perl 5.  


