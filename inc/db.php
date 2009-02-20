<?
if (! @include_once('DB.php') ) {
	echo "Konnte das Modul DB nicht laden!<br>";
	echo "Pr&uuml;fen Sie Ihre Installation:<br>";
	echo "pear list | grep DB<br>";
	echo "Variable '\$include_path' in der php.ini<br>"; 
	echo "aktueller Wert: ".ini_get('include_path');
	echo "<br><br><a href='inc/install.php?check=1'>Installations - Check durchf&uuml;hren</a><br>";
	exit (1);
};

class myDB extends DB {

 var $db = false;
 var $rc = false;
 var $showErr = false; // Browserausgabe
 var $debug = false; // 1 = SQL-Ausgabe, 2 = zusätzlich Ergebnis
 var $log = true;  // Alle Abfragen mitloggen
 var $errfile = "tmp/lxcrm.err";
 var $logfile = "tmp/lxcrm.log";
 var $lfh = false;
 
	function dbFehler($sql,$err) {
		$efh=fopen($this->errfile,"a");
		fputs($efh,date("Y-m-d H:i:s \n"));
		fputs($efh,'SQL:'.$sql."\n");
		fputs($efh,'Msg:'.$err."\n");
		fputs($efh,print_r($this->rc->backtrace[0],true)."\n");
		$cnt=count($this->rc->backtrace);
		for ($i=0; $i<$cnt; $i++) {
			fputs($efh,$this->rc->backtrace[$i]['line'].':'.$this->rc->backtrace[$i]['file']."\n");
		}
		fputs($efh,"--------------------------------------------- \n");
		fputs($efh,"\n");
		fclose($efh);
		if ($this->showErr)
			echo "</td></tr></table><font color='red'>$sql : $err</font><br>";
	}

	function showDebug($sql) {
		echo $sql."<br>";
		if ($this->debug==2) {
			echo "<pre>";
			print_r($this->rc);
			echo "</pre>";
		};
	}

	function writeLog($txt) {
		if ($this->lfh===false)
			$this->lfh=fopen($this->logfile,"a");
		fputs($this->lfh,date("Y-m-d H:i:s ->"));
		fputs($this->lfh,$txt."\n");
		if (!empty($this->rc->backtrace[0])) {
			fputs($this->lfh,'Fehler: '."\n");
			fputs($this->lfh,print_r($this->rc->backtrace[0],true)."\n");
			$cnt=count($this->rc->backtrace);
			fputs($this->lfh,$this->rc->backtrace[$cnt]['line'].':'.$this->rc->backtrace[$cnt]['file']."\n");
		} else {
			fputs($this->lfh,print_r($this->rc,true));
		}
		fputs($this->lfh,"\n");
	}

	function closeLogfile() {
		fclose($this->lfh);
	}
	
	function myDB($host,$user,$pwd,$db,$port,$showErr=false) {
		$dsn = array(
                    'phptype'  => 'pgsql',
                    'username' => $user,
                    'password' => $pwd,
                    'hostspec' => $host,
                    'database' => $db,
                    'port'     => $port
                );
		$this->showErr=$showErr;
		$this->db=DB::connect($dsn);
		if (!$this->db || DB::isError($this->db)) {
			if ($this->log) $this->writeLog("Connect $dns");
			$this->dbFehler("Connect ".print_r($dsn,true),$this->db->getMessage()); 
			die ($this->db->getMessage());
		}
		if ($this->log) $this->writeLog("Connect: ok ");
		return $this->db;
	}

	function query($sql) {
		$this->rc=@$this->db->query($sql);
		if ($this->debug) $this->showDebug($sql);
		if ($this->log) $this->writeLog($sql);
		if(DB::isError($this->rc)) {
			$this->dbFehler($sql,$this->rc->getMessage());
			$this->rollback();
			return false;
		} else {
			return $this->rc;
		}
	}

	function begin() {
		return $this->query("BEGIN");
	}
	function commit() {
		return $this->query("COMMIT");
	}
	function rollback() {
		return $this->query("ROLLBACK");
	}

	function getAll($sql) {
		$this->rc=$this->db->getAll($sql,DB_FETCHMODE_ASSOC);
		if ($this->debug) $this->showDebug($sql);
		if ($this->log) $this->writeLog($sql);
		if(DB::isError($this->rc)) {
			$this->dbFehler($sql,$this->rc->getMessage());
			return false;
		} else {
			return $this->rc;
		}
	}

	function getOne($sql) {
		$rs = $this->getAll($sql);
		if ($rs) {
			return $rs[0];
		} else {
			return false;
		}
	}
	function saveData($txt) {
		if (get_magic_quotes_gpc()) { 	
			return $txt;
		} else {
			return DB::quoteSmart($string); 
		}
	}

	/****************************************************
	* uudecode
	* in: string
	* out: string
	* dekodiert Perl-UU-kodierte Passwort-Strings
	* http://de3.php.net/base64_decode (bug #171)
	*****************************************************/
	function uudecode($encode) {
		$encode=stripslashes($encode);
		$b64chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
		$encode = preg_replace("/^./m","",$encode);
		$encode = preg_replace("/\n/m","",$encode);
		for($i=0; $i<strlen($encode); $i++) {
			if ($encode[$i] == '') $encode[$i] = ' ';
			$encode[$i] = $b64chars[ord($encode[$i])-32];
		}
		while(strlen($encode) % 4) $encode .= "=";
		return base64_decode($encode);
	}
}
?>
