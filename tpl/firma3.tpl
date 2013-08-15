	<script language="JavaScript">
	<!--
	function showM (month) {
		uri="firma3.php?Q={Q}&jahr={JAHR}&monat=" + month + "&fid=" + {FID};
		location.href=uri;
	}
    $(function(){
         $('button')
          .button()
          .click( function(event) { event.preventDefault();  document.location.href=this.getAttribute('name'); });
    });
	//-->
	</script>
    <script>
    $(document).ready(
        function(){
            $("#ums").tablesorter({widthFixed: true, widgets: ['zebra'], headers: { 
                0: { sorter: false }, 1: { sorter: false }, 2: { sorter: false }, 3: { sorter: false }, 4: { sorter: false } } 
            });
            $("#topparts").tablesorter({widthFixed: true, widgets: ['zebra'], headers: { 
                0: { sorter: false }, 1: { sorter: false }, 2: { sorter: false }, 3: { sorter: false }, 4: { sorter: false }, 5: { sorter: false },6: { sorter: false }} 
            });
        })
	</script>

<p class="ui-state-highlight ui-corner-all" style="margin-top: 0.7em; padding: 0.6em;">.:detailview:. {FAART}</p>

<span class='contentbox' >
<!-- Hier beginnt die Karte  ------------------------------------------->
<div style="position:absolute; left:0px; width:35em; border:1px solid lightgray">
	<span class="fett" >
            &nbsp;{Name} &nbsp; &nbsp; .:KdNr:.: {kdnr}<br />
            &nbsp;{Fdepartment_1}<br />
            &nbsp;{Plz} {Ort} </span>
</div>
<span style="position:absolute; left:38em; top:2.1em;">[<a href="opportunity.php?Q={Q}&fid={FID}">.:Opportunitys:.</a>]</span>
<div style="position:absolute; left:1em; top:5em; text-align:center;" class="normal">
	<div style="float:left; width:23em; text-align:left; " >
		<table id="ums" class="tablesorter" style="width:100%;">
			<thead><tr>
				<th >.:Month:.</th>
				<th></th><th>.:Sales:.</th>
				<th>.:Quotation:.</th><th></th>
			</tr></thead><tbody>
<!-- BEGIN Liste -->
			<tr onClick="showM('{Month}');">
				<td >{Month}</td>
				<td >{Rcount}</td><td >{RSumme}</td>
				<td >{ASumme}</td><td >&nbsp;{Curr}</td>
			</tr>
<!-- END Liste -->
		</tbody></table>
	</div> &nbsp; 
	<div style="float:left; text-align:right; width:40em; " class="fett">
	<center>.:Netto sales over 12 Month:. 
	[<a href='firma3.php?Q={Q}&fid={FID}&jahr={JAHRZ}'>.:earlier:.</a>] [<a href='firma3.php?Q={Q}&fid={FID}&jahr={JAHRV}'>{JAHRVTXT}</a>]</center>
		<img src="{IMG}" width="520" height="320" title="Netto sales over 12 Month"><br /><br />
	</div>
    <div><br>
    <table id='topparts' class="tablesorter">
        <thead><tr>
			<th >.:date:.</th>
			<th>.:part:.</th><th>.:qty:.</th>
			<th>.:unit:.</th><th>%</th><th></th><th>.:Sales:.</th>
		</tr></thead><tbody>
<!-- BEGIN TopListe -->
           <tr><td>{transdate}</td><td>{description}</td><td align='right'>{qty}</td><td>{unit}</td><td align='right'>{rabatt}</td><td align='right'>{sellprice}</td><td align='right'>{summe}</td></tr>
<!-- END TopListe -->
    </tbody></table>
    </div>
</div>
<!-- Hier endet die Karte ------------------------------------------->
</span>
