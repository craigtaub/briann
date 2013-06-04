<?php echo 'Video Category: '.strtoupper($_GET['page']);?> <br/>
<a href="/">BACK</a>
<img src="/imgs/video.png"/>

<?php 
$cat = '1111';
$vid = $_GET['page'];

$cats = array(
'0011'=>'drama',
//'0000'=>'drama', //drama as default
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


$ua = $_SERVER['HTTP_USER_AGENT'];
$ip = $_SERVER['SERVER_ADDR'];
$user_hash = md5($ua.$ip);

foreach ($cats as $key => $value) {
        if($vid === $value) {
                $cat = $key;
        }
}
?>
<script>
var xhReq = new XMLHttpRequest();
 xhReq.open("GET", "ajax?entry=<?php echo $cat;?>&user=<?php echo $user_hash;?>", false);
 xhReq.send(null);
</script>
