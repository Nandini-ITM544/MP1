#!/bin/bash

sudo apt-get update 
sudo apt-get install -y apache2 git php5 php5-curl mysql-client curl
sudo curl -sS https://getcomposer.org/installer | php
sudo php composer.phar require aws/aws-sdk-php
sudo git clone https://github.com/Nandini-ITM544/Application-Setup.git 
PM=letmein
export PM

