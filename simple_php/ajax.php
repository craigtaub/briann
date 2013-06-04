<?php echo 'hi';

$entry = $_GET['entry'];
$user = $_GET['user'];

try {
  // open connection to MongoDB server
  $conn = new Mongo('localhost');

  // access database
  $db = $conn->ann;

  // access collection
  $collection = $db->user_raw;

//check if empty
  $cursor = $collection->find();
  if($cursor->count() === 0) {
 	//empty..write drama first..
	if($entry != '0011') { //dont set drama twice...0000 is not sent into here
		$item = array(
    			'user' => $user,
    			'entry' => '0011',
    			'datetime' => new MongoDate()
  		);
 	 	$collection->insert($item);
	}
  }

// insert current click
  $item = array(
    'user' => $user,
    'entry' => $entry,
    'datetime' => new MongoDate()
  );
  $collection->insert($item);

/*  
  // iterate through the result set
  // print each document
  echo $cursor->count() . ' document(s) found. <br/>';  
  foreach ($cursor as $obj) {
    echo 'Name: ' . $obj['_id'] . '<br/>';
    echo '<br/>';
  }
*/
  // disconnect from server
  $conn->close();
} catch (MongoConnectionException $e) {
  die('Error connecting to MongoDB server');
} catch (MongoException $e) {
  die('Error: ' . $e->getMessage());
}


echo 'end';
