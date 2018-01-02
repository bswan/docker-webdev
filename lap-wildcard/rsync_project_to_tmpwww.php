<?php

set_time_limit(0);

$resyncVarName = 'tmpfs-resync';

function setFinishedCookie(){
        setcookie("webdevsyncisdone", '1');
}

var_dump('Start auto project sync to webdev /tmpwww/');

//var_dump($_SERVER);
//var_dump($_REQUEST);

$destPath = '/tmpwww/';
$srcPath = '/media/www/';

//check tmpfs folder
if(!file_exists($destPath)){
    var_dump("$destPath destination folder not found!");
    die;
}

//check if tmpfs folder is writable
if(!is_writable($destPath)){
    $processUser = posix_getpwuid(posix_geteuid());
    var_dump("$destPath is not writable by current process owner - " . $processUser['name']);
    die;
}

if(isset( $_SERVER['HTTP_HOST']) && $_SERVER['HTTP_HOST']){
    $docRootName = explode('.tmpfs.webdev', $_SERVER['HTTP_HOST']);
    $docRootName = $docRootName[0];

    $destDocRootPath = $destPath . $docRootName;
    $srcDocRootPath = $srcPath . $docRootName;

    if(!file_exists($srcDocRootPath)){
        var_dump("Source folder {$srcDocRootPath} not found!");
        die;
    }

    $cmd = "rsync -urhtP --info=stats2,name0,progress0 {$srcDocRootPath} {$destPath}";

    $sync_outputs = shell_exec($cmd);
    
    //write outputs to log file
    if(file_exists($destDocRootPath)){
        file_put_contents($destDocRootPath . '/tmpfs-sync.log', $sync_outputs, FILE_APPEND);
    }else{
        echo '<p>Destination folder is not found after sync command. Please check the sync command output.</p>';
        echo '<p>==================</p>';
        echo '<pre>';
        echo $sync_outputs;
        die;
    }
    
    //set cookie and let apache knows it's synced.
    setFinishedCookie();
    
    $uri = $_SERVER['REQUEST_URI'];
    if(stripos($uri, $resyncVarName) !== false){
        //if there is force resync parameter, remove quey string.
        $uri = explode('?', $uri);
        $uri = $uri[0];
    }

    $redirectBack = 'http://' . $_SERVER['HTTP_HOST'] . $uri;
    
    header("Webdev-Tmpfs-Sync-Message: finished");
    
    header('Location: ' . $redirectBack) ;
}else{
    echo '$_SERVER["HTTP_HOST"] not found!';
}
