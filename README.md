BRIANN
======
Run with ./run.sh
BBC Real-time Information Artificial Neural Network. 
A creation of Hackathon week May 2013. 
Creates an ANN for user Recommendations panel for iPlayer.

Ruby Setup
==========
gem install ruby-fann
gem install mongo

Mongo DB -> Column Families
===========================

ann -> user_raw
    -> user_data


PHP
=====
Simple procedural pages which write to Mongo->ANN->user_raw and fetch from Mongo->ANN->user_data.
