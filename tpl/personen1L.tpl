<!-- $Id$ -->
<html>
	<head><title></title>
    <link type="text/css" REL="stylesheet" HREF="../css/{ERPCSS}"></link>
    <link type="text/css" REL="stylesheet" HREF="css/{ERPCSS}"></link>
	<script language="JavaScript">
	<!--
	function showK (id,tbl) {
		{no}
		Frame=eval("parent.main_window");
		uri="firma2.php?Q="+tbl+"&id=" + id;
		Frame.location.href=uri;
	}
	function showK__ (id) {
		{no}
		Frame=eval("parent.main_window");
		uri="kontakt.php?id=" + id;
		Frame.location.href=uri;
	}
	function chngSerial(site) {
		etikett.document.location.href = site + ".php?src=P";
	}
	//-->
	</script>
<body>
<p class="listtop">.:search result:. .:Contacts:.</p>
<table width="100%" border="0"><tr><td valign="top">
<!-- Beginn Code ------------------------------------------->
<form name="personen" action="firma2.php" method="post">
<input type="hidden" name="fid" value="{FID}">
<input type="hidden" name="Q" value="{Q}">
<table border="0"><tr><td class="mini">
<!-- BEGIN Liste -->
	<tr class="mini" onMouseover="this.bgColor='#FF0000';" onMouseout="this.bgColor='{LineCol}';" bgcolor="{LineCol}" onClick='{js}'>
		<td>{Name}</td><td>&nbsp;{Plz} {Ort}</td><td>&nbsp;{Telefon}</td><td>&nbsp;{eMail}</td><td>&nbsp;{Firma}</td><td>&nbsp;{insk}</td></tr>
<!-- END Liste -->
	<tr><td class="re" colspan="6">{snd}</td></tr>
</table>
</td><td class="mini">
<form>
    <input type="button" name="etikett" value="Etiketten" onClick="chngSerial('etiketten');">&nbsp;
    <a href="sermail.php"><input type="button" name="email" value="Serienmail"></a>&nbsp;
    <input type="button" name="brief" value="Serienbrief" onClick="chngSerial('serdoc');">
    <input type="button" name="vcard" value=".:servcard:." onClick="chngSerial('servcard');">
</form>
	<iframe src="etiketten.php" name="etikett" width="380" height="380" marginheight="0" marginwidth="0" align="left">
		<p>Ihr Browser kann leider keine eingebetteten Frames anzeigen</p>
	</iframe>
</td></tr>
<!-- Hier endet die Karte ------------------------------------------->
</td></tr></table>
</body>
</html>
