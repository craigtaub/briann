<?php
  // open connection to MongoDB server
  $conn = new Mongo('localhost');

  // access database
  $db = $conn->ann;

  // access collection
  $collection = $db->user_raw;
$collection->remove();
$collection2 = $db->user_data;
$collection2->remove();

echo 'EMPTY';
