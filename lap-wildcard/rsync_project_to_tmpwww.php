<?php

set_time_limit(0);

function setFinishedCookie(){
        setcookie("webdevsyncisdone", '1');
}

var_dump('Start auto project sync to webdev /tmpwww/');

var_dump($_SERVER);
//var_dump($_REQUEST);

$destPath = '/tmpwww/';
$srcPath = '/media/www/';

if(!file_exists($destPath)){
        var_dump('/tmpwww/ destination folder not found!');
        die;
}

if(isset( $_SERVER['HTTP_HOST']) && $_SERVER['HTTP_HOST']){
        $docRootName = explode('.tmpfs.webdev', $_SERVER['HTTP_HOST']);
        $docRootName = $docRootName[0];

        $destDocRootPath = $destPath . $docRootName;
        $srcDocRootPath = $srcPath . $docRootName;

        if(file_exists($destDocRootPath)){
                if(!file_exists($srcDocRootPath)){
                        var_dump("Source folder {$srcDocRootPath} not found!");
                        die;
                }

                $cmd = "rsync -urhtP --info=stats2,name0,progress0 {$srcDocRootPath} {$destPath}";

                $last_line = system($cmd, $retval);

                var_dump($retval);
        }
        setFinishedCookie();

        $redirectBack = 'http://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];
        header( 'Location: ' . $redirectBack ) ;
}else{
        echo '$_SERVER["HTTP_HOST"] not found!';
}
