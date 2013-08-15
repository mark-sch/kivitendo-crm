<?php
    require_once('inc/stdLib.php');
    include('inc/crmLib.php');
    include('inc/template.inc');
    include('inc/grafik1.php');
    include('inc/FirmenLib.php');
    $Q = ( isset($_GET['Q']) )?$_GET['Q']:$_POST['Q'];
    $fid = $_GET['fid'];
    $monat = $jahr = $re = $reM = $top = false;
    $t   = new Template($base);
    $fa  = getFirmenStamm($fid,true,$Q);
    if ( isset($_GET['linlog']) ) { $linlog = '&linlog=0'; $ll = true; }
    else { $linlog = '&linlog=1'; $ll = false; }
    //$link1 = "firma1.php?Q=$Q&id=$fid";
    //$link2 = "firma2.php?Q=$Q&fid=$fid";
    //$link3 = "firma3.php?Q=$Q&fid=$fid".$linlog;
    //$link4 = "firma4.php?Q=$Q&fid=$fid";
    $name  = $fa['name'];
    $plz   = $fa['zipcode'];
    $ort   = $fa['city'];
    $jahr = ( isset($_GET['jahr']) )?$_GET['jahr']:date('Y'); 
    if ( $jahr==date('Y') )  {
        $JahrV = '';
    } else {
        $link3 .= '&jahr='.$jahr;
        $JahrV = $jahr+1;
    }
    $JahrZ = $jahr-1;
    if ( isset($_GET['monat']) ) {
        if ( substr($_GET['monat'],-4)=='Jahr' ) {
            $reM = getReMonat($_GET['fid'],$jahr,'00',($Q=='V')?true:false);
        } else {
            $reM = getReMonat($_GET['fid'],substr($_GET['monat'],3,4),substr($_GET['monat'],0,2),($Q=='V')?true:false);
        }
        $t->set_file(array('fa1' => 'firma3a.tpl'));
        $IMG = '';
    } else {
        $top   = getTopParts($fid);
        $re    = getReJahr($fid,$jahr,($Q=='V')?true:false);
        $an    = getAngebJahr($fid,$jahr,($Q=='V')?true:false);
        $t->set_file(array('fa1' => 'firma3.tpl'));
        $IMG   = getLastYearPlot($re,$an,$ll);
        $monat = '';
    }
    doHeader($t);
    $t->set_var(array(
            'Q'             => $Q,
            'FAART'         => ($Q=='C')?'.:Customer:.':'.:Vendor:.',       //"Kunde":"Lieferant",
            'FID'           => $fid,
            'kdnr'          => $fa['nummer'],
            //'Link1'       => $link1,
            //'Link2'   => $link2,
            //'Link3'   => $link3,
            //'Link4'   => $link4,
            'Name'          => $name,
            'Fdepartment_1' => $fa['department_1'],
            'Plz'           => $plz,
            'Ort'           => $ort,
            'IMG'           => $IMG,
            'JAHR'          => $jahr,
            'JAHRV'         => $JahrV,
            'JAHRZ'         => $JahrZ,
            'JAHRVTXT'      => ($JahrV>0)?'.:later:.':'',
            'Monat'         => $monat
            ));
    if ($re) {
        $t->set_block('fa1','Liste','Block');
        $i = 0;
        $monate = array_keys($re);
        for ($i=0; $i<13; $i++) {
            $colr = array_shift($re);
            $cola = array_shift($an);
            $val  = array(
                'Month'  => substr($monate[$i],4,2).'/'.substr($monate[$i],0,4),
                'Rcount' => $colr['count'],
                'RSumme' => sprintf('%01.2f',$colr['summe']),
                'ASumme' => sprintf('%01.2f',$cola['summe']),
                'Curr'   => $colr['curr']
            );
            $t->set_var($val);
            $t->parse('Block','Liste',true);
        }
    }
    if ( $top ) {
        $t->set_block('fa1','TopListe','BlockTP');
        foreach ( $top as $row ) {
            $t->set_var(array(
                'transdate'   => db2date($row['transdate']),
                'description' => $row['description'],
                'qty'         => $row['qty'],
                'unit'        => $row['unit'],
                'rabatt'      => ($row['discount'])?$row['discount']*100:'',
                'sellprice'   => sprintf('%0.2f',$row['sellprice']),
                'summe'       => sprintf('%0.2f',$row['summe'])
            ));
            $t->parse('BlockTP','TopListe',true);
        }
    }
    if ( $reM ) {
        $t->set_block('fa1','Liste','Block');
        $i = 0;
        if ( $reM ) foreach( $reM as $col ){
            if ( array_key_exists('invnumber',$col) ){
                $typ = 'R';
                $renr  = $col['invnumber'];
                $offen = ( $col['amount']==$col['paid'] )?'+':'-';
            } else {
                if ( $col['quotation']=='f' ) {
                    $typ   = 'L';
                    $renr  = $col['ordnumber'];
                    $offen = ($col['closes']=='t')?'c':'o';
                    //$offen="+";
                } else {
                    $typ   = 'A';
                    $renr  = $col['quonumber'];
                    $offen = ($col['closes']=='t')?'c':'o';
                }
            }
            $t->set_var(array(
                'LineCol'  => ($i%2+1),
                'Datum'    => db2date($col['transdate']),
                'RNr'      => $renr,
                'RNid'     => $col["id"],
                'RSumme'   => sprintf('%01.2f',$col['netamount']),
                'RBrutto'  => sprintf('%01.2f',$col['amount']),
                'Curr'     => $col['curr'],
                'Typ'      => $typ,
                'offen'    => $offen
                ));
            $t->parse('Block','Liste',true);
            $i++;
        }
    }
    if ( $monat and !$reM ) {
        $t->set_block('"fa1','Liste','Block');
            $i = 0;
            $t->set_var(array(
                'LineCol' => '',
                'Datum'   => '',
                'RNr'     => 'Keine ',
                'RSumme'  => 'Ums&auml;tze',
                'Curr'    => ''
                ));
            $t->parse('Block','Liste',true);
    }
    $t->Lpparse('out',array('fa1'),$_SESSION['lang'],'firma');

?>
