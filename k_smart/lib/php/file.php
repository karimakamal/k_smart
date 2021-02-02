<?php
	$host = "localhost";		         // host = localhost because database hosted on the same server where PHP files are hosted
	$dbname = "id13790539_karimesp";              // Database name
	$username = "id13790539_karim";		// Database username
	$password = "Kupo_55050500";	        // Database password

	try {
		$conn = new mysqli($host, $username, $password, $dbname);
	} catch (Exception $e) {
		echo $e->getMessage();
	}
	error_reporting(E_ALL ^ E_NOTICE);  
	$userid = $_POST['userid'];
	$usersno = $_POST['usersno'];
	$pass = $_POST['pass'];
	$type = (int)$_POST['type'];

	
	if($type == 1) {
		try {
			$sql = "SELECT * FROM users WHERE NAME = '$userid'"; 
			$result = $conn->query($sql);
			
			$row = mysqli_fetch_row($result);
			$exist = $row[0];

			if ($exist == 0)
			{
				$pass = sha1($pass);
				$sql = "INSERT INTO users (NAME, PASS, USERSno) VALUES ('$userid', '$pass', '$usersno')";
				$result = $conn->query($sql);
				$msg['status'] = "registeration succeeded";
				$msg['val'] = 1;
			} else {
				$msg['status'] = "username has already taken";
				$msg['val'] = 0;
			}	
		} catch (Exception $e) {
			$msg["status"] = "Registeration error";
		}
	} else {
		try {
			$pass = sha1($pass);
			$sql = "SELECT * FROM users WHERE NAME = '$userid' AND PASS = '$pass' "; 
			$result = $conn->query($sql);
			$row = mysqli_fetch_row($result);
			$exist = mysqli_num_rows($result);

			if ($exist == 1)
			{
				$msg['status'] = "login succeeded";
				$msg['val'] = 1;
				$msg['info'] = [
					"username"=>$row[1],
					"usersno"=>$row[3]
					] ; 
			} else {
				$msg['status'] = "username or password is incorrect";
				$msg['val'] = 0;
			}	
		} catch (Exception $e) {
			$msg["status"] = "Registeration error";
		}
		}
	
	echo json_encode($msg);
	
?>