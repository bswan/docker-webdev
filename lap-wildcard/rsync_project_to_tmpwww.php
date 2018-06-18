<?php

set_time_limit(0);

$resyncVarName = 'tmpfs-resync';

$redirectBackAfterSync = true;

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
    if(stripos($_SERVER['HTTP_HOST'], '.webdev') !== false){
        $docRootName = explode('.tmpfs.webdev', $_SERVER['HTTP_HOST']);
    }else{
        $docRootName = explode('.tmpfs.local', $_SERVER['HTTP_HOST']);
    }

    $docRootName = $docRootName[0];

    $destDocRootPath = $destPath . $docRootName;
    $srcDocRootPath = $srcPath . $docRootName;

    if(!file_exists($srcDocRootPath)){
        var_dump("Source folder {$srcDocRootPath} not found!");
        die;
    }
    
    //sync specific files from .file.changes.log if the log file isn't empty.
    $syncFromListCMD = '';
    $logFilename = '.file.changes.log';
    $logFilePath = $srcDocRootPath . '/' . $logFilename;
    if(file_exists($logFilePath) && filesize($logFilePath)){
        $syncFromListCMD = "--files-from={$logFilePath}";
    }

    if($syncFromListCMD){
        //sync from a files list
        $cmd = "rsync -urhtP $syncFromListCMD --exclude '.git' --exclude 'pub/media/*' --exclude 'var' --exclude 'silverstripe-cache' --info=stats2,name0,progress0 {$srcDocRootPath} {$destPath}/{$docRootName}";
    }else{
        $cmd = "rsync -urhtP --exclude '.git' --exclude 'pub/media/*' --exclude 'var' --exclude 'silverstripe-cache' --info=stats2,name0,progress0 {$srcDocRootPath} {$destPath}";
    }

    $sync_outputs = shell_exec($cmd);
    
    //delete .file.changes.log after sync
    if(file_exists($logFilePath)){
        unlink($logFilePath);
    }
    
    //write outputs to log file
    $logContent = $_SERVER['REQUEST_URI'] . "\n" . "command : {$cmd}" . "\n" . $sync_outputs;
    if(file_exists($destDocRootPath)){
        file_put_contents(
            $destDocRootPath . '/tmpfs-sync.log', 
            $logContent, 
            FILE_APPEND
        );
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
    
    //check redirect var
    if(isset( $_GET['webdev-no-redirect']) && $_GET['webdev-no-redirect']){
        $redirectBackAfterSync = false;
    }

    if($redirectBackAfterSync){
        //redirect back to normal website address after sync.
        $redirectBack = 'http://' . $_SERVER['HTTP_HOST'] . $uri;
        
        header("Webdev-Tmpfs-Sync-Message: finished");
        
        header('Location: ' . $redirectBack) ;
    }else{
        //no redirect. display sync summary on screen.
        echo '<pre>';
        echo $logContent;
        die;
    }
}else{
    echo '$_SERVER["HTTP_HOST"] not found!';
}
