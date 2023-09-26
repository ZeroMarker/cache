// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var tbl=document.getElementById("tRBAppointment_ListApptByStatus");
var f=document.getElementById("fRBAppointment_ListApptByStatus");
var RescID=f.elements['RescID'].value;
var dt=f.elements['dfrom'].value;
var SessID=f.elements['SessID'].value;
var selectedRowObj=new Array()
var timerenabled=true;

function docLoadHandler() {
	if (self==top) websys_reSizeT();

}

// TP log 32487: added printing selected rows functionality
function PrintSelectedRowsHandler(tblname,lnk,newwin) {
	var found=0;
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
	// HitCount is only required for reports when data is not being refresh automatically due to problems with
	// the Crystal Web Server. See Crystal KnowledgeBase Article c2002771.
	//var HitCount=Math.round(Math.random() * 1000);
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		if (newwin=="TRAK_hidden") {
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="ApptID">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component
					if (!f.elements["ApptIDz"+row]) continue;
					if (f.elements["ApptIDz"+row].value!="") {
						document.writeln('<INPUT NAME="ApptID" VALUE="' + f.elements["ApptIDz"+row].value + '">');
					}
				}
				//Log 63924 - 08.06.2007 - to prevent stack overflow error
				//document.writeln('</FORM><SCR'+'IPT>');
				//document.writeln('window.HFORM.submit();');
				//document.writeln('</SCR'+'IPT></BODY></HTML>');
				//document.close();
							
				document.writeln('</FORM></BODY></HTML>');
				document.close();
				document.HFORM.submit();	
				// End Log 63924 	
			}
		} else {
			// for each row selected
			for (i in aryfound) {
				var row=aryfound[i];
				// check for specific values - these values must be hidden in the component
				if (!f.elements["ApptIDz"+row]) continue;
				if (f.elements["ApptIDz"+row].value!="") {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["ApptIDz"+row].value);
				}
			}
		}

		/*
		// old code
		for (i in aryfound) {
			var row=aryfound[i];
			// check for specific values
			if (!f.elements["ApptIDz"+row]) continue;
			if (f.elements["ApptIDz"+row].value!="") {
				// when the report is not preview i.e. will be inserted in the PrintHistory for the TPS
				if (newwin=="TRAK_hidden") {
					var newlnk=lnk;
					// concatenate specific row parameter values to lnk. this is necessary because the %request
					// variables are lost when the menu is selected. These parameter values will be resolved in
					// the Report Manager definition.
					newlnk=newlnk+"&ApptIDz="+f.elements["ApptIDz"+row].value;
					websys_createWindow(newlnk,"TRAK_hidden");
					// time delaying function to allow proper loading of the TRAK_hidden frame
					CompleteReportLoading();
				} else { 	// when the report is crystal and will be previewed pass these parameters so they can
						// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["ApptIDz"+row].value);
				}
			}
		}
		*/
	}
}

function BodyUnloadHandler(e) {
	if (self == top) {
		var win=window.opener;
		if (win) {
            websys_onunload();
			//win.treload('websys.reload.csp');
		}
	}
}

document.body.onunload=BodyUnloadHandler;
document.body.onload=docLoadHandler;