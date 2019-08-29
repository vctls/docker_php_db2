<?php

const QUERY = 'query';

$host = getenv('DB2_HOST');
$port = getenv('DB2_PORT');
$db = getenv('DB2_DB');
$schema = getenv('DB2_SCHEMA');
$prt = getenv('DB2_PROTOCOL');
$user = getenv('DB2_USER');
$pwd = getenv('DB2_PASSWORD');

$cnx = db2_connect(
    "DRIVER={IBM DB2 ODBC DRIVER};DATABASE=$db;" .
    "HOSTNAME=$host;" .
    "PROTOCOL=$prt;" .
    "UID=$user;" .
    "PWD=$pwd;" .
    "PORT=$port",
    $user,
    $pwd
);

if (array_key_exists(QUERY, $_GET)) {
    $sql = $_GET[QUERY];
} else {
    $sql = 'SELECT current date FROM sysibm.sysdummy1;';
}

$stm = db2_exec($cnx, $sql);
$results = [];
while($result = db2_fetch_assoc($stm)){
    $results[] = $result;
}
$response = json_encode($results, JSON_INVALID_UTF8_IGNORE);
$json_error = json_last_error() . ' ' . json_last_error_msg();

header('Content-Type: application/json');
echo $response;