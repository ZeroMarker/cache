// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//T68
function Init() {
	BuildHiddenFields();

	var winHeight = document.getElementById("Height");
	if (winHeight && winHeight.value=="") {
		winHeight.value=350;
	}
	var winWidth = document.getElementById("Width");
	if (winWidth && winWidth.value=="") {
		winWidth.value=600;
	}

	var objcreate=document.getElementById('CreateGraph');
	if (objcreate) objcreate.onclick=SubmitGraph;
	var objgraph=document.getElementById('Graph');
	if (objgraph) {
		objgraph.onchange=GraphChangeHandler;
		if (objgraph.value!="") SubmitGraph();
	}
	var objedit=document.getElementById('EditGraph');
	if (objedit) {objedit.onclick=EditGraphHandler;}
	// Log 44734 - AI - 07-10-2004 : Disable the link if required.
	var obj1=document.getElementById('GraphAvailableForUser');
	if ((obj1)&&(objgraph)) {
		if ((obj1.value==0)&&(objgraph.value!="")) {
			if (objedit) objedit.disabled=true;
		}
	}
	var objprint=document.getElementById('PrintGraph');
	if (objprint) objprint.onclick=ChartFXPrint;

	var objGraphType = document.getElementById('GRPHGraphType');
	var objNoIntFld = document.getElementById('NoOfIntervals');
	if (objGraphType) {
		if (objGraphType.value == "DC") {
			DisableTimeDate();
			var objGraphInt = document.getElementById('IntervalType');
			if(objGraphInt) DisableField(objGraphInt);
		}
		else if (objGraphType.value == "PG") {
			DisablePartogramFields();
			var objNoInt = document.getElementById('cNoOfIntervals');
			if(objNoInt) objNoInt.className="clsRequired";
		}
		else {
			if(objNoIntFld) {
				objNoIntFld.disabled=true;
				objNoIntFld.className="DisabledField";
			}
		}
		
		objGraphType.onchange=GraphChangeHandler;
	}
	else {
		if(objNoIntFld) {
			objNoIntFld.disabled=true;
			objNoIntFld.className="DisabledField";
		}
	}
}

function DisablePartogramFields(){
	var objWidth=document.getElementById('Width');
	//var objDateFrom=document.getElementById('DateFrom');
	//var objDateFromLU=document.getElementById('ld467iDateFrom');
	//var objTimeFrom=document.getElementById('TimeFrom');
	var objDateTo=document.getElementById('DateTo');
	var objDateToLU=document.getElementById('ld467iDateTo');
	var objTimeTo=document.getElementById('TimeTo');
	var objInc=document.getElementById('Increment');
	var objIncU=document.getElementById('IncrementUnit');
	var objIncULU=document.getElementById('ld467iIncrementUnit');

	if (objWidth) DisableField(objWidth);
	//if (objDateFrom) DisableField(objDateFrom);
	//objDateFromLU.disabled=true;
	//if (objTimeFrom) DisableField(objTimeFrom);
	if (objDateTo) DisableField(objDateTo);
	objDateToLU.disabled=true;
	if (objTimeTo) DisableField(objTimeTo);
	if (objInc) DisableField(objInc);
	if (objIncU) DisableField(objIncU);
	objIncULU.disabled=true;
}

function DisableTimeDate() {
	var objDateFrom = document.getElementById('DateFrom');
	var objTimeFrom = document.getElementById('TimeFrom');
	var objDateTo = document.getElementById('DateTo');
	var objTimeTo = document.getElementById('TimeTo');
	var objPatDob = document.getElementById('PatientDOB');
	var dob;
	if (objPatDob) dob = objPatDob.value.split("^");
	if (objDateFrom) {
		if (dob[0]) objDateFrom.value=dob[0];
		DisableField(objDateFrom);
	}
	if (objTimeFrom) {
		objTimeFrom.value="00:00";
		DisableField(objTimeFrom);
	}
	if (objDateTo) {
		if (dob[1]) objDateTo.value=dob[1];
	}
	if (objTimeTo) {
		objTimeTo.value="23:59";
	}
}

function EnableTimeDate() {
	var objDateFrom = document.getElementById('DateFrom');
	if (objDateFrom) {
		EnableField(objDateFrom);
	}
	var objTimeFrom = document.getElementById('TimeFrom');
	if (objTimeFrom) {
		EnableField(objTimeFrom);
	}
}

function SubmitGraph() {
	var winf = "";
	var NumberSelected = 0;
	if ((parent)&&(parent.frames)&&(parent.frames['TestItemsFrame'])) {
		winf = parent.frames['TestItemsFrame'];
	}
	var Selected = "";
	var SelectedDesc = "";
	if (winf) {
		var tbl=winf.document.getElementById("tChartFX_Select_List");
		if (tbl) {
			for (var i=1;i<tbl.rows.length;i++) {
				var datarow = winf.document.getElementById("Selectz" + i);
				if (datarow && datarow.checked && !datarow.disabled) {
					var testitem = winf.document.getElementById("ItemCodez" + i);
					var testdesc = winf.document.getElementById("ItemDescz" + i);
					if ((testitem)&&(testdesc)) {
						Selected  = Selected + testitem.value + "^";
						SelectedDesc  = SelectedDesc + testdesc.value + "^";
						NumberSelected = NumberSelected + 1;
					}
				}
			}
		}
	}
	var objSelected = document.getElementById("Selected");
	if (objSelected) {
		objSelected.value = Selected;
	}
	var objNumberSelected = document.getElementById("NumberSelected");
	if (objNumberSelected) {
		objNumberSelected.value = NumberSelected;
	}
	var objSelectedDesc = document.getElementById("SelectedDesc");
	if (objSelectedDesc) {
		objSelectedDesc.value = SelectedDesc;
	}

	// Log 46461 YC - check date to ensure dateTo is not greater than 50 days for dancis
	var objGraphType = document.getElementById('GRPHGraphType');
	if(objGraphType) {
		var objDateFrom = document.getElementById('DateFrom');
		var objDateTo = document.getElementById('DateTo');
		if(objDateTo && objDateFrom && objGraphType.value=="DC") {
			if (objDateTo.value && objDateFrom.value) {
				dateArr = objDateTo.value.split("/");
				dateArr2 = objDateFrom.value.split("/");
				var dateTo = new Date(dateArr[1]+"/"+dateArr[0]+"/"+dateArr[2]);
				var dateFrom = new Date(dateArr2[1]+"/"+dateArr2[0]+"/"+dateArr2[2]);
				// greater than to 50 days difference
				if (((dateTo-dateFrom)/(1000*60*60*24)) > 50)	{
					alert(t['LESSTHAN50DAYS']);
					return false;
				}
			}
		}
		if(objDateTo && objDateFrom && objGraphType.value=="PG") {
			var objTimeFrom = document.getElementById('TimeFrom');
			var objTimeTo = document.getElementById('TimeTo');
			var objXInc=document.getElementById('Increment');
			var objXIncUCode=document.getElementById('IncrementUnitCode');
			var objIntervals=document.getElementById('NoOfIntervals');
			if(objIntervals) {
				if(objIntervals.value=="") {
					alert(t['NoOfIntervals']+" "+t['XMISSING']);
					objIntervals.className="clsInvalid";
					return false;
				} 
				if(objIntervals.value!="" && isNaN(parseInt(objIntervals.value))) {
					alert(t['NoOfIntervals']+" "+t['XNUMBER']);
					objIntervals.className="clsInvalid";
					return false;
				}
			} 
			if ( objXInc && objXIncUCode ){
				if ( objXInc.value!="" && objXIncUCode.value!="" ) {
					if (objDateFrom.value) {
						var increments="";
						dateArr = objDateFrom.value.split("/");
						timeArr = objTimeFrom.value.split(":");
						var dateTo = new Date();
						var dateFrom = new Date(dateArr[1]+"/"+dateArr[0]+"/"+dateArr[2]+" "+timeArr[0]+":"+timeArr[1]);
						if(objXIncUCode.value=="M") increments=objXInc.value;
						if(objXIncUCode.value=="H") increments=60*objXInc.value;
						if(objXIncUCode.value=="D") increments=24*60*objXInc.value;
						if(objXIncUCode.value=="W") increments=7*24*60*objXInc.value;
						if(increments!="" && objIntervals && objIntervals.value!="") {
							increments=increments*objIntervals.value;
							increments=increments*60*1000;  //Convert to milliseconds
							var timeInMils=dateFrom.getTime();
							dateTo.setTime(increments+timeInMils);
							var day = dateTo.getDate();
							if(day<10) day="0"+day;
							var month = dateTo.getMonth()+1;
							if(month<10) month="0"+month;
							var year = dateTo.getFullYear();
							var hour = dateTo.getHours();
							if(hour<10) hour="0"+hour;
							var min = dateTo.getMinutes();
							if(min<10) min="0"+min;
							objDateTo.value=day+"/"+month+"/"+year;
							if(objTimeTo) objTimeTo.value=hour+":"+min;
						}
					}
				} else{
					objXInc.value="";
					objXIncUCode.value=""
				}
			}
		}
	}

	// the original window size is 620 high and 670 wide
	// the original GRAPH size is 350 high and 600 wide
	// calculate the differences, and expand the screen...
	var winHeight = document.getElementById("Height");
	var winWidth = document.getElementById("Width");
	if ((winHeight)&&(winWidth)) {
		//var newwidth = ((OrigWinWidth - OrigGraphWidth) + parseInt(winWidth.value));
		// width is graph width + 80
		var newwidth = 80;
		if(!isNaN(parseInt(winWidth.value))) { newwidth = (newwidth + parseInt(winWidth.value)); }
		if (newwidth< 500) {newwidth=500;}

		if(objGraphType) {
			if(objGraphType.value=="PG") {
				newwidth = window.screen.Width - (window.screenLeft-10); //newwidth+=120;
				var objIntervals=document.getElementById('NoOfIntervals');
				if(objIntervals) {
					if(objIntervals.value!="" && !isNaN(parseInt(objIntervals.value))) {
						winWidth.value=objIntervals.value*40+90;
					}
				}
			}
		}

		// Log 52341 YC - window is bigger than width of screen, then make the window go to the edge of the screen
		if (window.screen.Width < (window.screenLeft + newwidth))
			newwidth = window.screen.Width - (window.screenLeft-10);

		//var newheight = (OrigWinHeight - OrigGraphHeight + parseInt(winHeight.value));
		var newheight = (300 + 150 + parseInt(winHeight.value));
		if (newheight< 500) {newheight=500;}
		// Log 52341 YC - window is bigger than height of screen, then make the window go to the edge of the screen
		if (window.screen.Height < (window.screenTop + newheight))
			newheight = window.screen.Height - (window.screenTop);
		window.parent.resizeTo(newwidth, newheight);
	}

	var frm = document.forms["fChartFX_Link"];
	frm.target = "graphcomponent";
	var chartserver=""
	var server = document.getElementById("ChartFXServer");
	if (server) chartserver=server.value;
	if (chartserver!="") chartserver=chartserver+"/"
	// Log 54821 YC - Get custom stylesheet and pass to graph
	for (var i=0; i<document.styleSheets.length; i++) {
		if(document.styleSheets[i].href.indexOf("websys.css")==-1)
			var stylesheet=document.styleSheets[i].href;
	}

	// Log 64950 - DH
	var iframeurl=window.location.href.split("websys.default.csp?");

	//frm.action = chartserver+"epr.emrgraph.asp";
	frm.action = chartserver+"epr.emrgraph.asp?stylesheet="+encodeURIComponent(stylesheet)+"&path="+encodeURIComponent(iframeurl[0]);


	// Log 53370 YC - frm.submit() is sufficient, no need to _click then undisable etc which sometimes doesn't undisable properly
	if (fChartFX_Link_submit()) {
		websys_setfocus('CreateGraph');
		frm.submit();
	}
	


	//var retval =  CreateGraph_click();
	// CreateGraph_click disables the link - so I'm gonna re-enable it...
	//var obj=document.getElementById('CreateGraph');
	//if (obj) {obj.disabled=false;obj.onclick=SubmitGraph};
	//alert("1");
	//if (window.print) print();
	//alert("2");

	//return retval;
	return false;
}

function ChartFXPrint() {
	if ((parent.graphcomponent)&&(parent.graphcomponent.document.getElementsByTagName("IMG").length>0)) {
		var objbanner=document.getElementById("dPAPerson_Banner");
		// if patient banner on screen - copy banner and grpah into hidden frame and print
		// otherwise just print from graph screen
		if (objbanner) {
			var winhidden=window.open("","Popup_TRAK_hidden");
			winhidden.document.writeln("<HTML><HEAD>");
			for (var i=0; i<document.styleSheets.length; i++) {
				winhidden.document.writeln("<LINK REL='stylesheet' TYPE='text/css' HREF='"+document.styleSheets[i].href+"'></LINK>");
			}
			winhidden.document.writeln("<SCRIPT>function DoPrint() {window.print();}</SCRIPT>");
			winhidden.document.writeln("</HEAD><BODY></BODY></HTML>");
			winhidden.document.close();
			if (document.all) { //IE
				winhidden.document.body.insertAdjacentHTML('beforeEnd',parent.graphcomponent.document.body.innerHTML);
				winhidden.document.getElementById('eprPatientBannerSlot').insertAdjacentHTML('beforeEnd',objbanner.outerHTML);
			} else { //N7 - untested
				var objprintdoc=parent.graphcomponent.document.body.cloneNode(true);
				if (objprintdoc) objprintdoc=winhidden.document.body.appendChild(objprintdoc);
				var objprintdocbanner=objbanner.cloneNode(true);
				if (objprintdocbanner) objprintdocbanner=winhidden.document.getElementById('eprPatientBannerSlot').appendChild(objprintdocbanner);
			}
			setTimeout("PrintNow();",220);
		} else {
			parent.graphcomponent.focus();
			parent.graphcomponent.print();
		}
	} else {
		//need to translate
		alert('no graph to print');
	}
	//document.focus();
	return false;
}
function PrintNow() {
			var winhidden=window.open("","Popup_TRAK_hidden");
			winhidden.focus();
			//winhidden.print();
			winhidden.DoPrint();
}

// Log 44734 - AI - 07-10-2004 : Enable the link if required. Assume if 'Graph' has a value, the LUHandler will take care of it.
function GraphChangeHandler() {
	var objgraph=document.getElementById('Graph');
	var objedit=document.getElementById('EditGraph');
	var objGraphType = document.getElementById('GRPHGraphType');
	var objGraphInt = document.getElementById('IntervalType');
	if ((objgraph)&&(objgraph.value=="")) {
		if (objedit) objedit.disabled=false;
		var obj=document.getElementById("GRPHCode");
		if (obj) obj.value="";
		if (objGraphType) objGraphType.value="";
	}
	if (objGraphType) {
		if(objGraphType.value=="DC") DisableTimeDate();
		else {EnableTimeDate();}
		if (objGraphInt) {
			if(objGraphType.value=="DC") DisableField(objGraphInt);
			else EnableField(objGraphInt);
		}
	}
}

function EditGraphHandler() {
	// Log 44734 - AI - 05-10-2004 : Firstly ensure the link is enabled.
	var obj=document.getElementById('EditGraph');
	if (obj) {
		if (obj.disabled==true) return false;
	}
	// end Log 44734

	var obj=document.getElementById('Graph');
	var obj1=document.getElementById("GRPHCode");
	var obj2=document.getElementById("SystemGraph");
	var obj3=document.getElementById("GRPHGraphType");
	if (obj) {
		var Graph=obj.value;
		if (obj1) var GraphCode=obj1.value;
		else var GraphCode="";
		if (obj2) var SystemGraph=obj2.value;
		else var SystemGraph="";
		if (obj3) var GraphType=obj3.value;
		else var GraphType="";
		// Log 44734 - AI - 30-09-2004 : Add '&SystemFlag=N'. This is not a System Graph - we come from the EPR.
		websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=epr.CTGraph.Edit&GRPHDesc='+Graph+'&DontInitialise=1'+'&SystemFlag=N&GRPHCode='+GraphCode+'&SystemGraph='+SystemGraph,'ChartFX', 'top=100,left=200,width=800,height=500,scrollbars=yes,resizable=yes');
		return false;
	}
}

// Log 44734 - AI - 05-10-2004 : Function to take the checkbox value and disable the link if applicable.
function GraphLUHandler(str) {
	var lu;
	if (str!="") lu=str.split("^");

	// Log 53369 YC - Commented as we are refreshing the page so this is no longer needed
	/*
	var obj=document.getElementById("EditGraph");
	if (lu[3]!="N") {
		if (obj) obj.disabled=true;
		var obj1=document.getElementById('GraphAvailableForUser');
		if (obj1) {
			obj1.value=0;
		}
	}
	if (lu[3]=="N") {
		if (obj) obj.disabled=false;
		var obj1=document.getElementById('GraphAvailableForUser');
		if (obj1) {
			obj1.value=1;
		}
	}
	var obj=document.getElementById("GRPHCode");
	if (obj) obj.value=lu[1]
	var obj=document.getElementById("SystemGraph");
	if (obj) obj.value=lu[4]

	var objGraphType = document.getElementById('GRPHGraphType');
	if (objGraphType) objGraphType.value=lu[5];

	var objGraphInt = document.getElementById('IntervalType');
	if (lu[5]=="DC") {
		DisableTimeDate();
		if (objGraphInt)
			DisableField(objGraphInt);
	}
	else
	{
		EnableTimeDate();
		if (objGraphInt)
			EnableField(objGraphInt);
	}
	*/


	// Log 53369 YC - Refresh the page if we're changing graphs
	if(lu[0]!="") {
		var PatientID="";
		var EpisodeID="";
		var mradm="";
		var mradmlist="";

		var objPatientID=document.getElementById("PatientID");
		if(objPatientID) PatientID = objPatientID.value;

		var objEpisodeID=document.getElementById("EpisodeID");
		if(objEpisodeID) EpisodeID = objEpisodeID.value;

		var objmradm=document.getElementById("mradm");
		if(objmradm) mradm = objmradm.value;

		var objmradmlist=document.getElementById("mradmlist");
		if(objmradmlist) mradmlist = objmradmlist.value;

		var url="epr.displaygraph.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm+"&mradmlist="+mradmlist+"&Graph="+escape(lu[0]);
		if (parent.name=="TRAK_main") {
		} else {
			parent.top.location=url;
		}
	}

}
// end Log 44734

// Log 46460 - AI - 01-12-2004 : function to store the MedTrak Value of the LookUp for the asp to use.
function IncrementUnitLookUp(str) {
	var lu = str.split("^");
	// Use the StandardType's StoredValue (lu[2])
	var obj=document.getElementById("IncrementUnitCode");
	if ((obj)&&(lu[2]!="")) {
		obj.value=lu[2];
	}
}
// end Log 46460

// 58659 YC - Takes t messages and puts them into hidden fields (for the request space)
function BuildHiddenFields() {
	var el;
	var frm=document.fChartFX_Link

	for ( msgname in t ) {
    el=document.createElement("INPUT");
    el.id = "T"+msgname; el.name = "T"+msgname;
    el.value=t[msgname];
    el.type = "HIDDEN";
    frm.appendChild(el);
	}
}

function DisableField(obj)
{
	if(obj) {
		obj.style.color = "gray";
		obj.className = "clsReadOnly";
		obj.ondragstart=DoNotAllow;
		obj.onselectstart=DoNotAllow;
		obj.oncontextmenu=DoNotAllow;
		obj.onkeydown=DoNotAllow;
	}
}

function EnableField(obj)
{
	if(obj) {
		obj.style.color = "";
		obj.className = "";
		obj.ondragstart="";
		obj.onselectstart="";
		obj.oncontextmenu="";
		obj.onkeydown="";
	}
}

function DoNotAllow() {
	return false;
}

document.body.onload=Init;
