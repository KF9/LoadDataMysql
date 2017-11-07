<?php
//connect to DB
include("connect.php");
$name=$_POST['name'];
$address=$_POST['address'];
$city=$_POST['city'];
$state=$_POST['state'];
$zip=$_POST['zip'];
$phone=$_POST['phone'];
$email=$_POST['email'];
$gender=$_POST['gender'];

$dcdq=$_POST['dcdq'];
$username=$_POST['username'];
$password=$_POST['password'];
$checkdetails="select p.person_id from Person p where name='$name' and address='$address' and city='$city' and state='$state' and zipcode='$zip' and phone='$phone' and email='$email' and gender='$gender';";
$ifexists = mysql_query($checkdetails);
if($ifexists){
$numexists = mysql_num_rows($ifexists);
}
$checkusername="select a.a_username from Applicant a where a_username='$username';";
$ifhasusername=mysql_query($checkusername);
if($ifhasusername){
$numusername = mysql_num_rows($ifhasusername);
}
if($numexists>0)
{
	echo 'An account already exists with these details.';
}
else
{
	if($numusername>0)
	{
		echo 'This username already exists. Try another username.';
	}
	else
	{
		//fill the person information
		$sql = "insert into Person(name,address,city,state,zipcode,phone,email,gender) values('$name','$address','$city','$state','$zip','$phone','$email','$gender');";
		$result = mysql_query($sql);

		//
		$sql1 = "select p.person_id from Person p where name='$name' and address='$address' and city='$city' and state='$state' and zipcode='$zip' and phone='$phone' and email='$email' and gender='$gender';";
		$result1 = mysql_query($sql1);
		if($result1){
		$numr = mysql_num_rows($result1);
		}
		if($numr>0)
		{
			for($i=0;$i<$numr;$i++)
			{
				$row1=mysql_fetch_array($result1);
				$personid=$row1[0];
			}

			$appinsertsql="insert into Applicant( person_id,DCDQ_member,a_username,a_password) values('$personid','$dcdq','$username','$password');";
			mysql_query($appinsertsql);
			header('Location: ./signupsuccess.html'); 


		exit;
		}
	}
}
?>