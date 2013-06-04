<?php
//determine if user has item in user_data,,if so use it...else use drama
try {
  // open connection to MongoDB server
  $conn = new Mongo('localhost');

  // access database
  $db = $conn->ann;

  // access collection
  $collection = $db->user_data;

$ua = $_SERVER['HTTP_USER_AGENT'];
$ip = $_SERVER['SERVER_ADDR'];
$user_hash = md5($ua.$ip);

//check if empty
  $query = array('user' => $user_hash);
  $cursor = $collection->find($query);
  if($cursor->count() === 0) {
	$category = '0011';
  } else {
	$category = '';
	foreach ($cursor as $doc) {
		foreach($doc['result'] as $res) {
			$category.= $res;
		}
	}
  }

  $conn->close();
} catch (MongoConnectionException $e) {
  die('Error connecting to MongoDB server');
} catch (MongoException $e) {
  die('Error: ' . $e->getMessage());
}


$cats = array(
'0011'=>'drama',
'0000'=>'drama', //drama as default
'0001'=>'childrens', 
'0010'=>'comedy',
'0100'=>'sport',
'0101' =>'factual' ,
'0110' =>'life' ,
'0111' => 'news' ,
'1000' => 'religion',
'1001' => 'arts',
'1010' => 'music',
'1011' => 'tv',
'1100' => 'learning',
'1101' => 'science',
'1110' => 'health',
'1111' => 'food'

);

foreach ($cats as $key => $value) {
	//cast to string as 1000 and up comes out as int...0111 and less is string ???
	if($category === (string)$key) {
		$link = $value;
	}
}

?>

<a href="/video?page=<?php echo $link;?>">
<img src="/imgs/home_shot.png"/>
</a>

<a href="/video?page=<?php echo $link;?>">
<img src="/imgs/list_<?php echo $link; ?>.jpeg"/>
</a>

<div id="hash"
<!--<?php echo $user_hash; ?>-->
</div>

<?
foreach ($cats as $key => $value) {
	if($key != '0000') {
		echo '<br/><a href="/video?page='.$value.'">'.strtoupper($value).'</a>';
	}
}
