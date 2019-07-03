#!/bin/bash

echo "Running"

source /home/ec2-user/.rvm/scripts/rvm
rvm use 2.4
ruby --version
sudo gem install bundler --no-ri --no-rdoc -v '1.17.3'
sudo /usr/local/bin/bundle install --system

echo "Complete"
