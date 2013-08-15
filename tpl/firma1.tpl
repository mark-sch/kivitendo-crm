<html>
<head><title>CRM Firma:{Fname1}</title>
{STYLESHEETS}
{CRMCSS}
{JQUERY}
{JQUERYUI}
{THEME}
{JQTABLE}
{JAVASCRIPTS}
<script language="JavaScript" type="text/javascript">
    function showCall() {
        $('#calls tr[group="tc"]').remove();
        $.ajax({
           url: 'jqhelp/firmaserver.php?task=showCalls&firma=1&id={FID}',
           dataType: 'json',
           success: function(data){
                        var content;
                        $.each(data.items, function(i) {
                             content = '';
                             content += '<tr class="verlauf" group="tc" onClick="showItem('+data.items[i].id+');">'
                             content += '<td>' + data.items[i].calldate + '</td>';
                             content += '<td>' + data.items[i].id + '</td>';
                             content += '<td nowrap>' + data.items[i].kontakt;
                             if (data.items[i].inout == 'o') {
                                  content += ' &gt;</td>';
                             } else if (data.items[i].inout == 'i') {
                                  content += ' &lt;</td>';
                             } else {
                                  content += ' -</td>';
                             }
                             if ( data.items[i].new == 1 ) {
                                 content += '<td><b>' + data.items[i].cause + '</b></td>';
                             } else {
                                 content += '<td>' + data.items[i].cause + '</td>';
                             }
                             content += '<td>' + data.items[i].cp_name + '</td></tr>';
                             $('#calls tr:last').after(content);
                        })
                        $("#calls").trigger('update');
                        $("#calls")
                             .tablesorter({widthFixed: true, widgets: ['zebra'], headers: { 2: { sorter: false } } })
                             .tablesorterPager({container: $("#pager"), size: 15, positionFixed: false})
                    }
        });
        return false;
    }
    function dhl() {
        F1=open("dhl.php?Q={Q}&fid={FID}&popup=1","Caller","width=770, height=680, left=100, top=50, scrollbars=yes");
    }
    function showItem(id) {
        F1=open("getCall.php?Q={Q}&fid={FID}&Bezug="+id,"Caller","width=770, height=680, left=100, top=50, scrollbars=yes");
    }
    function anschr(A) {
        $( "#dialogwin" ).dialog( "option", "maxWidth", 400 );
        $( "#dialogwin" ).dialog( "option", "maxHeight", 600 );
        $( "#dialogwin" ).dialog( { title: "Adresse" } );
        $( "#dialogwin" ).dialog( "open" );
        if (A==1) {
            $( "#dialogwin" ).load("showAdr.php?Q={Q}&fid={FID}");
        } else {
            sid = document.getElementById('SID').firstChild.nodeValue;
            if ( sid )
                $( "#dialogwin" ).load("showAdr.php?Q={Q}&sid="+sid);
        }
    }
    function notes() {
            F1=open("showNote.php?fid={FID}","Notes","width=400, height=400, left=100, top=50, scrollbars=yes");
    }
    function doLink() {
        if ( document.getElementById('actionmenu').selectedIndex > 0 ) {
            link = $('#actionmenu option:selected').val();
            if (link.substr(0,7) =='onClick') {
                if ( link.substr(8) == 'invoice' ) {
                    doIr();
                } else if ( link.substr(8) == 'delivery_order'){
                    doDo();  
                }
                else {
                    doOe(link.substr(8));
                }
            } else {
                lnk = document.getElementById('actionmenu').options[document.getElementById('actionmenu').selectedIndex].value;
                if (link.substr(0,4) =='open') {
                    F1=open(link.substr(5),"CRM","width=350, height=400, left=100, top=50, scrollbars=yes");
                } else {
                    window.location.href = lnk;
                }
            }
       }
    }
    function doOe(typ) {
      document.oe.type.value=typ;
      document.oe.submit();
    }
    function doDo() {
      document.oe.action='../do.pl';
      if ( '{Q}' == 'C' ) {      
        document.oe.type.value='sales_delivery_order';
      }
      else{
        document.oe.type.value='purchase_delivery_order';
      }
      document.oe.submit();
    }
    function doIr() {
        if ( '{Q}' == 'C' ) {
            document.oe.action='../is.pl';
        } else {
            document.oe.action='../ir.pl';
        }
        document.oe.type.value='invoice';
        document.oe.submit();
    }
    function doLxCars() {
        uri='lxcars/lxcmain.php?owner={FID}&task=1' 
        window.location.href=uri;
    }
    function KdHelp() {
        link = $('#kdhelp option:selected').val();
        if ( $('#kdhelp').prop("selectedIndex") > 0 ) {
            f1=open("wissen.php?kdhelp="+link,"Wissen","width=750, height=600, left=50, top=50, scrollbars=yes");
            $('#kdhelp option')[0].selected = true;
        }
    }
    var shiptoids = new Array({Sids});
    var sil = shiptoids.length;
    var sid = 0;
    function nextshipto(dir) {
        if ( dir == 'o' ) {
            sid = 0;
        } else {
            if (sil<2) return;
            if (dir=="-") {
                if (sid>0) {
                    sid--;
                } else {
                    sid = (sil - 1);
                }
            } else {
                if (sid < sil - 1) {
                    sid++;
                } else {
                    sid=0;
                }
            }
        }
        $.ajax({
           url: "jqhelp/firmaserver.php?task=showShipadress&id="+shiptoids[sid]+"&Q={Q}",
           dataType: 'json',
           success: function(data){
                        var adr = data.adr;
                        $('#SID').empty().append(adr.shipto_id);
                        $('#shiptoname').empty().append(adr.shiptoname);
                        $('#shiptodepartment_1').empty().append(adr.shiptodepartment_1);
                        $('#shiptodepartment_2').empty().append(adr.shiptodepartment_2);
                        $('#shiptostreet').empty().append(adr.shiptostreet);
                        $('#shiptocountry').empty().append(adr.shiptocountry);
                        $('#shiptobland').empty().append(adr.shiptobland);
                        $('#shiptozipcode').empty().append(adr.shiptozipcode);
                        $('#shiptocity').empty().append(adr.shiptocity);
                        $('#shiptocontact').empty().append(adr.shiptocontact);
                        $('#shiptophone').empty().append(adr.shiptophone);
                        $('#shiptofax').empty().append(adr.shiptofax);
                        $('#shiptoemail').empty().append(data.mail);
                        $('#karte2').attr("href",data.karte);
                    }
        })
    }
    var f1 = null;
    function toolwin(tool) {
        leftpos=Math.floor(screen.width/2);
        f1=open(tool,"Adresse","width=350, height=200, left="+leftpos+", top=50, status=no,toolbar=no,menubar=no,location=no,titlebar=no,scrollbars=yes,fullscreen=no");
    }
    function showOP(was) {
                F1=open("op_.php?Q={Q}&fa={Fname1}&op="+was,"OP","width=950, height=450, left=100, top=50, scrollbars=yes");
        }
    function surfgeo() {
        if ({GEODB}) {
            F1=open("surfgeodb.php?plz={Plz}&ort={Ort}","GEO","width=550, height=350, left=100, top=50, scrollbars=yes");
        } else {
            alert("GEO-Datenbank nicht aktiviert");
        }
    }
    $(document).ready(
        function(){
          
            $( "#main_tabs" ).tabs({
                beforeLoad: function( event, ui ) {
                    ui.jqXHR.error(function() {
                        ui.panel.html(".:Couldn't load this tab.:." );
                    });
                }       
            });
            $("#shipleft").click(function(){ nextshipto('-'); })
            $("#shipright").click(function(){ nextshipto('+'); })
            nextshipto('o'); 
            $('button').button().click( 
            function(event) {
                event.preventDefault();
                name = this.getAttribute('name');
                if ( name == 'ks' ) {
                    var sw = $('#suchwort').val();
                    F1=open("suchKontakt.php?suchwort="+sw+"&Q=C&id={FID}","Suche","width=400, height=400, left=100, top=50, scrollbars=yes");
                } else if ( name == 'reload' ) {
                    showCall();
                } else {
                    document.location.href = name;
                }
            });
            $("#fasubmenu").tabs({ 
                heightStyle: "auto",
                active: {kdviewli}
                });
            //var index = $('#fasubmenu a[href="#{kdviewli}"]').parent().index();
            //$("#fasubmenu").tabs("option", "active",  index);

            $( "#right_tabs" ).tabs({
                cache: true, //helpful?
                active: {kdviewre},
                beforeLoad: function( event, ui ) {
                    ui.jqXHR.error(function() {
                    ui.panel.html(
                        ".:Couldn't load this tab.:." );
                    });
                }
            });
            
            $("#dialogwin").dialog({
                autoOpen: false,
                show: {
                    effect: "blind",
                    duration: 300
                },
                hide: {
                    effect: "explode",
                    duration: 300
                },
            });
            $(".firmabutton").button().click(
            function( event ) {
                if ( this.getAttribute('name') != 'extra' && this.getAttribute('name') != 'karte' && this.getAttribute('name') != 'lxcars') {
                    event.preventDefault();
                };
            });
        }
    );
</script>
</head>
<body onLoad=" showCall(0);">
{PRE_CONTENT}
{START_CONTENT}
<div id="main_tabs">
    <ul>
        <li><a href="#main_tab-1">.:Custombase:.</a></li>
        <li><a href="firma2.php">.:contact:.</a></li>
        <li><a href="firma3.php">.:Sales:.</a></li>
        <li><a href="firma4.php">.:Documents:.</a></li>
    </ul>

 <div id="main_tab-1">
<p class="ui-state-highlight ui-corner-all" style="margin-top: 0.7em; padding: 0.6em;">.:detailview:. {FAART} <span title=".:important note:.">{Cmsg}&nbsp;</span></p>

<div class='menubox1' >
    <form>

    <span style="float:left;">
        <select style="visibility:{chelp}" name="kdhelp" id="kdhelp" onChange="KdHelp()">
<!-- BEGIN kdhelp -->
        <option value="{cid}">{cname}</option>
<!-- END kdhelp -->
        </select>
        <select id="actionmenu" onchange="doLink();" >
            <option>Aktionen</option>
            <option value='firmen3.php?Q={Q}&id={FID}&edit=1'>.:edit:.</option>
            <option value='timetrack.php?tab={Q}&fid={FID}&name={Fname1}'>.:timetrack:.</option>
            <option value='open:extrafelder.php?owner={Q}{FID}'>.:extra data:.</option>
            <option value='vcardexp.php?Q={Q}&fid={FID}'>VCard</option>
            <option value='karte.php?Q={Q}&fid={FID}'>.:register:. .:develop:.</option>
            <option value='onClick:{request}_quotation'>.:quotation:. .:develop:.</option>
            <option value='onClick:{sales}_order'>.:order:. .:develop:.</option>
            <option value='onClick:delivery_order'>.:delivery order:. .:develop:.</option>
            <option value='onClick:invoice'>.:invoice:. .:develop:.</option>
        </select>
    </span>
    
    </form>
</div>
<div class="toolbox">
<span style="float:left;  visibility:{zeige_tools};" >
        <img src="tools/rechner.png" onClick="toolwin('tools/Rechner.html')" title=".:simple calculator:." style="margin-bottom:1.3em;"> &nbsp;
        <img src="tools/notiz.png" onClick="toolwin('postit.php?popup=1')" title=".:postit notes:." style="margin-bottom:1.3em;"> &nbsp;
        <img src="tools/kalender.png" onClick="toolwin('tools/kalender.php?Q={Q}&id={FID}')" title=".:calender:." style="margin-bottom:1.3em;"> &nbsp;
        <a href="javascript:void(s=prompt('.:ask leo:.',''));if(s)leow=open('http://dict.leo.org/?lp=ende&search='+escape(s),'LEODict','width=750,height=550,scrollbars=yes,resizeable=yes');if(leow)leow.focus();"><img src="tools/leo.png" title="LEO .:english/german:." border="0" style="margin-bottom:1.3em;"></a> &nbsp;
    </span>
</div>
<form action="../oe.pl" id="oe" method="post" name="oe">
	<input type="hidden" name="action" value="add">
	<input type="hidden" name="vc" value="{CuVe}">
	<input type="hidden" name="type" value="">
	<input type="hidden" name="action_update" value="Erneuern" id="update_button">
	<input type="hidden" name="{CuVe}_id" value="{FID}">
</form>
<div class="contentbox" >
    <div style="float:left; width:45em; height:37em; text-align:center; border: 1px solid lightgray;" >
        <div class="gross" style="float:left; width:55%; height:25em; text-align:left; border: 0px solid black; padding:0.2em;" >
            <span class="fett">{Fname1}</span><br />
            {Fdepartment_1} {Fdepartment_2}<br />
            {Strasse}<br />
            <span class="mini">&nbsp;<br /></span>
            <span onClick="surfgeo()">{Land}-{Plz} {Ort}</span><br />
            <span class="klein">{Bundesland}</span>
            <span class="mini"><br />&nbsp;<br /></span>
            {Fcontact}
            <span class="mini"><br />&nbsp;<br /></span>
            <font color="#444444"> .:tel:.:</font> {Telefon}<br />
            <font color="#444444"> .:fax:.:</font> {Fax}<br />
            <span class="mini">&nbsp;<br /></span>
            &nbsp;[<a href="mail.php?TO={eMail}&KontaktTO=C{FID}">{eMail}</a>]<br />
            &nbsp;<a href="{Internet}" target="_blank">{Internet}</a>
        </div>
        <div style="float:left; width:43%; height:25em; text-align:right; border: 0px solid black; padding:0.2em;">
            <span valign='top'><span class="fett">{kdnr}</span> <img src="image/kreuzchen.gif" title=".:locked address:." style="visibility:{verstecke};" > {verkaeufer}
            {IMG}<br /></span>
            <br class='mini'>
               {ANGEBOT_BUTTON}
               {AUFTRAG_BUTTON}
               {LIEFER_BUTTON}
               {RECHNUNG_BUTTON}<br />
            <br class='mini'>
               {EXTRA_BUTTON}
               {KARTE_BUTTON}
               {ETIKETT_BUTTON}
            <br />
            <br class='mini'>
               {DHL_BUTTON}
               {LxCars_BUTTON}
            <br /><br />
            <span style="visibility:{zeige_bearbeiter};">.:employee:.: {bearbeiter}</span>
        </div>
        <br />
    </div>
    <div id="fasubmenu" >
        <ul>
            <li><a href="#lie">.:shipto:. </a></li>
            <li><a href="#not">.:notes:. </a></li>
            <li><a href="#var">.:variablen:. </a></li>
            <li><a href="#fin">.:FinanzInfo:.</a></li>
            <li><a href="#inf">.:miscInfo:. </a></li>
        </ul>
        <div id="lie" class="klein">
            <span class="fett" id="shiptoname"></span> &nbsp;&nbsp;&nbsp;&nbsp;
            .:shipto count:.:{Scnt} <img src="image/leftarrow.png" id='shipleft' border="0">
            <span id="SID"></span> <img src="image/rightarrow.png" id='shipright' border="0">&nbsp; &nbsp;
            <a href="#" onCLick="anschr();"><img src="image/brief.png" alt=".:print label:." border="0"/></a>&nbsp; &nbsp;
            <a href="" id='karte2' target="_blank"><img src="image/karte.gif" alt="karte" title=".:city map:." border="0"></a><br />
            <span id="shiptodepartment_1"></span> &nbsp; &nbsp; <span id="shiptodepartment_2"></span> <br />
            <span id="shiptostreet"></span><br />
            <span class="mini">&nbsp;<br /></span>
            <span id="shiptocountry"></span>-<span id="shiptozipcode"></span> <span id="shiptocity"></span><br />
            <span id="shiptobundesland"></span><br />
            <span class="mini">&nbsp;<br /></span>
            <span id="shiptocontact"></span><br />
            .:tel:.: <span id="shiptophone"></span><br />
            .:fax:.: <span id="shiptofax"></span><br />
            <span id="shiptoemail"></span>
        </div>
        <div id="not">
            <table width="100%"><tr><td>
            <span class="labelLe ">.:Catchword:.</span><span class="value">{sw} </span><br />
            <span class="labelLe " valign="top">.:Remarks:.</span><span class="value">{notiz}</span>
            </td></tr></table>
        </div>
        <div id="var" >
            <div class="zeile klein">
            <table width="100%"><tr><td>
<!-- BEGIN vars -->
            <span class="labelLe">{varname}</span><span class="value">{varvalue}</span><br />
<!-- END vars -->
            </td></tr></table>
            </div>
        </div>
        <div id="inf">
            <table width="100%"><tr><td>
            <span class="labelLe">.:Concern:.:</span>
            <span class="value"><a href="firma1.php?Q={Q}&id={konzern}">{konzernname}</a></span>
            <span> &nbsp; <a href="konzern.php?Q={Q}&fid={FID}">{konzernmember}</a></span><br />
            <br />
            <span class="labelLe">.:Industry:. </span> <span class="value">{branche} </span><br />
            <br />
            <span class="labelLe">.:headcount:.:</span> <br /><span class="value">{headcount}</span><br />
            <br />
            <span class="labelLe">.:language:.: </span> <span class="value">{language} </span><br />
            <br />
            <span class="labelLe">.:Init date:.:</span> <span class="value">{erstellt} </span>
            <span class="space"> &nbsp;&nbsp;&nbsp;&nbsp;</span>
            <span class="labelLe">.:update:.: </span> <span class="value">{modify} </span><br />
            </td></tr></table>
            <br />
        </div>
        <div id="fin" >
            <table width="100%"><tr><td>
            <span class="labelLe">.:Source:.:</span> <span class="value">{lead} {leadsrc}</span><br />
            <span class="labelLe">.:Business:.:</span> <span class="value">{kdtyp}</span><br />
            <span class="labelLe">.:taxnumber:.:</span> <span class="value">{Taxnumber}</span><br />
            <span class="labelLe">UStId:</span> <span class="value">{USTID}</span><br />
            <span class="labelLe">.:taxzone:.:</span> <span class="value">{Steuerzone}</span><br />
            <span class="labelLe">.:bankname:.:</span> <span class="value">{bank}</span><br />
            <span class="labelLe">.:directdebit:.:</span> <span class="value">{directdebit}</span><br />
            <span class="labelLe">.:bankcode:.:</span> <span class="value">{blz}</span><br />
            <span class="labelLe">.:bic:.:</span> <span class="value">{bic}</span><br />
            <span class="labelLe">.:account:.:</span> <span class="value">{konto}</span><br />
            <span class="labelLe">.:iban:.:</span> <span class="value">{iban}</span><br />
            </td><td valign="top">
            <span class="labelLe">.:Discount:.:</span> <span class="value">{rabatt}</span><br />
            <span class="labelLe">.:Price group:.:</span> <span class="value">{preisgrp}</span><br />
            <span class="labelLe">.:terms:.:</span> <span class="value">{terms} .:days:.</span><br />
            <span class="labelLe">.:creditlimit:.:</span> <span class="value">{kreditlim}</span><br />
            <span class="space">.:outstanding:. :</span><br />
            <span class="labelLe">- .:items:.:</span>
            <span class="value" onClick="showOP('{apr}');">{op}</span><br />
            <span class="labelLe">- .:orders:.:</span>
            <span class="value" onClick="showOP('oe');">{oa}</span><br />
            </td></tr></table>
        </div>
	</div>

	<div style="float:left; width:45%; height:37em; text-align:left; border: 1px solid lightgrey; border-left:0px;">
    	<div id="right_tabs">
        	<ul>
                <li><a href="#contact">.:contact:.</a></li>
                <li><a href="jqhelp/get_doc.php?Q={Q}&fid={FID}&type=quo">.:Quotation:.</a></li>
                <li><a href="jqhelp/get_doc.php?Q={Q}&fid={FID}&type=ord">.:orders:.</a></li>
                <li><a href="jqhelp/get_doc.php?Q={Q}&fid={FID}&type=inv">.:Invoice:.</a></li>	
            </ul>
    		<div id="contact">
            <table id="calls" class="tablesorter" width="100%" style='margin:0px;'>
    				<thead><tr><th>Datum</th><th>id</th><th class="{ sorter: false }"></th><th>Betreff</th><th>.:contact:.</th></tr></thead>
    				<tbody>
    				<tr onClick="showItem(0)" class='verlauf'><td></td><td>0</td><td></td><td>.:newItem:.</td><td></td></tr>
    				</tbody>
    			</table><br>
    			<div id="pager" class="pager" style='position:absolute;'>
        			<form name="ksearch" onSubmit="false ks();"> &nbsp;
        				<img src="{CRMPATH}jquery-ui/plugin/Table/addons/pager/icons/first.png" class="first">
        				<img src="{CRMPATH}jquery-ui/plugin/Table/addons/pager/icons/prev.png" class="prev">
        				<input type="text" id='suchwort' name="suchwort" size="20"><input type="hidden" name="Q" value="{Q}">
        				<button id='ks' name='ks'>.:search:.</button>
        				<button id='reload' name='reload'>reload</button>
        				<img src="{CRMPATH}jquery-ui/plugin/Table/addons/pager/icons/next.png" class="next">
        				<img src="{CRMPATH}jquery-ui/plugin/Table/addons/pager/icons/last.png" class="last">
        				<select class="pagesize" id='pagesize'>
        					<option value="10">10</option>
        					<option value="15" selected>15</option>
        					<option value="20">20</option>
        					<option value="25">25</option>
        					<option value="30">30</option>
        				</select>
        			</form>
    			</div>
    		</div>
		</div>
	</div>
</div>
</div>
</div>

<div id="dialogwin"></div>
   </div>
   
{END_CONTENT}
</body>
</html>
    
