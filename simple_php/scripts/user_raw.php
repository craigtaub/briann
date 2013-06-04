<?php
  // open connection to MongoDB server
  $conn = new Mongo('localhost');

  // access database
  $db = $conn->ann;

  // access collection
  $collection = $db->user_raw;
$cursor = $collection->find();

//check if empty
        foreach ($cursor as $doc) {
		print_r($doc);
		
                //foreach($doc['result'] as $res) {
                //}
      }

  $conn->close();

