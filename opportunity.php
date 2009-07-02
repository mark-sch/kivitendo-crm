<?php
// $Id:  $
	require_once("inc/stdLib.php");
	include("template.inc");
	include("crmLib.php");
	include("UserLib.php");
	$t = new Template($base);
	$jscal ="<style type='text/css'>@import url(../../$ERPNAME/js/jscalendar/calendar-win2k-1.css);</style>\n";
	$jscal.="<script type='text/javascript' src='../../$ERPNAME/js/jscalendar/calendar.js'></script>\n";
    $jscal.="<script type='text/javascript' src='../../$ERPNAME/js/jscalendar/lang/calendar-de.js'></script>\n";
    $jscal.="<script type='text/javascript' src='../../$ERPNAME/js/jscalendar/calendar-setup.js'></script>\n";
    $jscal1="<script type='text/javascript'><!--\nCalendar.setup( {\n";
	$jscal1.="inputField : 'zieldatum',ifFormat :'%d.%m.%Y',align : 'BL', button : 'trigger1'} );\n";
    $jscal1.="//-->\n</script>";
	$stamm="none";
	if ($_GET["Q"] and $_GET["fid"]) {
		$fid=$_GET["fid"];
		if ($_GET["new"]) {
			include_once("inc/FirmenLib.php");
			$daten["firma"]=getName($fid,$_GET["Q"]);
			$daten["fid"]=$fid;
			$daten["tab"]=$_GET["Q"];
		} else {
			$_POST["Quelle"]=$_GET["Q"];
			$_POST["fid"]=$fid;
			$_POST["suchen"]=1;
		}
			$search="visible";
			$save="visible";
			$none="block";
			$stamm="block";
			$block="none";			
	}
	$oppstat=getOpportunityStatus();
	$salesman=getAllUser(array(0=>true,1=>"%"));
	if ($_POST["suchen"]) {
		$data=suchOpportunity($_POST);
		$none="block";
		$block="none";
		if (count($data)>1){
			$t->set_file(array("op" => "opportunityL.tpl"));
			$t->set_block("op","Liste","Block");
			foreach ($data as $row) {
				$t->set_var(array(
					LineCol	=> $bgcol[($i%2+1)],
					id => $row["id"], 
					name => $row["firma".strtolower($row["tab"])], 
					title => $row["title"],
					chance => $row["chance"]*10, 
					betrag => sprintf("%0.2f",$row["betrag"]), 
					status => $row["status"],
					datum => db2date($row["zieldatum"]),
				));
				$t->parse("Block","Liste",true);
				$i++;
			}
			$stamm="block";
	        $t->Lpparse("out",array("op"),$_SESSION["lang"],"work");
			exit;
		} else if (count($data)==0 || !$data){
			if ($_POST["fid"]) {
				include_once("inc/FirmenLib.php");
				$data["name"]=getName($_POST["fid"],$_POST["Quelle"]);
			};
			$msg=".:notfound:.!";
			$daten["fid"]=$_POST["fid"];
			$daten["firma"]=$data["name"];
			$daten["tab"]=$_POST["Quelle"];
			$search="visible";
			$save="visible";
			$none="block";
			$block="none";
			$stamm="none";
		} else {
			$daten=getOneOpportunity($data[0]["id"]);
			$save="visible";
			$search="hidden";
			$none="none";
			$block="block";
			$stamm="block";
		}
	} else if ($_POST["save"]) {
		$rc=saveOpportunity($_POST);
		if (!$rc) { 
			$msg=".:error:. .:save:.";
			$daten=$_POST;
			$daten["zieldatum"]=date2db($daten["zieldatum"]);
			$save="visible";
			$search="hidden";
			$none="block";
			$block="none";
			$stamm="block";
		} else {
			$daten=getOneOpportunity($rc);
			$msg=".:datasave:.";
			$save="visible";
			$search="hidden";
			$none="none";
			$block="block";
			$stamm="block";
		}
	} else if ($_GET["id"]) {
		$daten=getOneOpportunity($_GET["id"]);
		$save="visible";
		$search="hidden";
		$none="none";
		$block="block";
		$stamm="block";
	} else {
		$save="visible";
		$search="visible";
		$none="block";
		$block="none";
	}
	$t->set_file(array("op" => "opportunityS.tpl"));
	$t->set_block("op","status","BlockS");
	if ($oppstat) foreach ($oppstat as $row) {
		$t->set_var(array(
			ssel => ($row["id"]==$daten["status"])?"selected":"",
			sval => $row["id"],
			sname => $row["statusname"]
		));
		$t->parse("BlockS","status",true);
	}
	$t->set_block("op","salesman","BlockV");
	if (!$daten["salesman"]) $daten["salesman"]=$_SESSION["loginCRM"];
	if ($salesman) foreach ($salesman as $row) {
		$t->set_var(array(
			esel => ($row["id"]==$daten["salesman"])?"selected":"",
			evals => $row["id"],
			ename => ($row["name"])?$row["name"]:$row["login"]
		));
		$t->parse("BlockV","salesman",true);
	}
	$t->set_var(array(
		id => $daten["id"],
		Q => $daten["tab"],
		fid => $daten["fid"],
		title => $daten["title"],
		name => ($daten["firma"])?$daten["firma"]:$_POST["firma"],
		zieldatum => ($daten["zieldatum"])?db2date($daten["zieldatum"]):"",
		betrag => ($daten["betrag"])?sprintf("%0.2f",$daten["betrag"]):"",
		next => ($daten["next"])?$daten["next"]:$_POST["next"],
		notxt => ($daten["notiz"])?nl2br($daten["notiz"]):"---",
		notiz => $daten["notiz"],
		ssel.$daten["status"] => "selected",
		csel.$daten["chance"] => "selected",
		save => $save,
		search => $search,
		stamm => $stamm,
		block => $block,
		none => $none,
		button => $button,
		msg => $msg,
		jcal0 => ($jcalendar)?$jscal:"",
		jcal2 => ($jcalendar)?$jscal1:"",
		//jcal1 => ($jcalendar)?"<input type='image' src='image/date.png' title='.:targetdate:. .:search:.' name='zieldatum' align='middle' id='trigger1' value='?'>":""
		jcal1 => ($jcalendar)?"<a href='#' id='trigger1' name='zieldatum' title='.:targetdate:. .:search:.' onClick='false'><img src='image/date.png' border='0' align='middle'></a>":""
	));
	$t->Lpparse("out",array("op"),$_SESSION["lang"],"work");
?>
