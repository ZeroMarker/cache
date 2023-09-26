// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var frm = document.forms["fPANok_List"];

var obj="",TWKFLI="",TWKFL="",admtype="",hidlnk="",CONTEXT="";
obj=document.getElementById("TWKFL")
if (obj) TWKFL=obj.value;
obj=document.getElementById("TWKFLI")
if (obj) TWKFLI=obj.value;
obj=document.getElementById("admType");
if (obj) admtype=obj.value;
obj=document.getElementById("hiddenLinks");
if (obj) hidlnk=obj.value;
		var CONTEXT=document.getElementById("CONTEXT")
		if (CONTEXT) CONTEXT=CONTEXT.value;



function DocumentLoadHandler(e) {
	
	// PAAdm.Tree load handler
	if (window.name=="panok_list") {
		try {
			BodyLoadHandler();
		} catch(e) {}
	}
	
	//log 61054 TedT
	var selectall=document.getElementById("selectall");
	if(selectall) selectall.onclick=SelectClickHandler;
	var unselect=document.getElementById("unselect");
	if(unselect) unselect.onclick=SelectClickHandler;
	
	var objTable=document.getElementById("tPANok_List");
	var eSrc;
	var newlink=document.getElementById("New1");
	if (newlink) newlink.onclick=NewClickHander;
	var updateObj=document.getElementById("update1");
	if (updateObj) updateObj.onclick=updateClickHandler;
	// cjb 06/03/2006 56793 - now uses assignClickHandler rather than ContactClickHandler
	//if (objTable) objTable.onclick=ContactClickHandler;
	assignClickHandler();
}

//log61054 TedT
function SelectClickHandler() {
	var id=this.id;
	var check = true;
	if(id=="unselect") check=false;
	var tbl=document.getElementById("tPANok_List");
	for (var i=1;i<tbl.rows.length;i++) {
		var select=document.getElementById("selectz"+i);
		if(select) select.checked=check;
	}
	return false;
}

function updateClickHandler() {
	if (window.name=="panok_list") {
		if (frm.elements['TWKFL'].value!="") frm.elements['TFRAME'].value=window.parent.name;
	}
	return update1_click();
}


function assignClickHandler() {
	var tbl=document.getElementById("tPANok_List");
	for (var i=1;i<tbl.rows.length;i++) {
		obj=document.getElementById("CONTTP_Descz"+i)
		if (obj) obj.onclick=ContactClickHandler;
		obj=document.getElementById("delete1z"+i)
		if (obj) obj.onclick=DeleteClickHandler;
		//Log 60322 6-10-2006 BoC: set CopyClickHandler for "Copy1"
		obj=document.getElementById("Copy1z"+i);
		if (obj) obj.onclick=CopyClickHandler;
	}
	return;
}

function ContactClickHandler(e) {
	var EpiID="",PatID="",PARREF="",admtype="";
	var EpiID=document.getElementById("EpisodeID")
	if (EpiID) EpiID=EpiID.value;
	var PatID=document.getElementById("PatientID")
	if (PatID) PatID=PatID.value;
	var parref=document.getElementById("PARREF");
	if (parref) parref=parref.value;
	var eSrc=websys_getSrcElement(e);
	if ((eSrc)&&(eSrc.tagName=="IMG")) eSrc=websys_getParentElement(eSrc);
	if (eSrc) {
		var rowid=eSrc.id;
		var rowAry=rowid.split("z");
		var row=rowAry[1]
		var nokid=document.getElementById("NOK_RowIdz"+row);
		if (nokid) nokid=nokid.value;
		//if (window.name=="panok_list") eSrc.target = "panok_edit";
		if (window.name=="panok_list") eSrc.target = "_self";
		//var currentlink=eSrc.href.split("?");
		//eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PANok.Edit&" + currentlink[1]+"&admType="+admtype;
		//var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PANok.Edit&" + currentlink[1]+"&admType="+admtype;
		var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PANok.Edit&" +"&ID="+nokid+"&EpisodeID="+EpiID+"&PatientID="+PatID+"&PARREF="+parref+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&hiddenLinks="+hidlnk+"&admType="+admtype+"&CONTEXT="+CONTEXT;
		if (window.name!="panok_list") {
			lnk=lnk+"&PatientBanner=1";
		}
		websys_createWindow(lnk,"panok_edit","top=50,left=50,width=700,height=500,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes"); 
		//eSrc=websys_getParentElement(eSrc);
	}
}

function DeleteClickHandler(e) {
	var eSrc=websys_getSrcElement(e);
	if ((eSrc)&&(eSrc.tagName=="IMG")) eSrc=websys_getParentElement(eSrc);
	if (eSrc) {
		var rowid=eSrc.id;
		var rowAry=rowid.split("z");
		var row=rowAry[1]
		
		eSrc.target="_parent"
		if  (TWKFLI=="") { 
			var currentlink=eSrc.href.split("?"); 
			var lnk=""
			//var lnk="panokframe.csp?PARREF="+parref+"&hiddenLinks="+hidlnk+"&PatientID="+patid+"&ID="+rowid+"&admType="+admtype;
			//alert("if: "+lnk)
		} else { 
			var currentlink=eSrc.href.split("&TWKFLI=");
			var twkfli=currentlink[1].split("&TRELOADID=")
			//var lnk=currentlink[0]+"&ID="+twkfli[1]+"&EpisodeID="+epid+"&PatientID="+patid+"&TWKFLI="+(TWKFLI-1)+"&hiddenLinks="+hidlnk+"&admType="+admtype;
			var lnk=currentlink[0]+"&TWKFLI="+(TWKFLI-1)+"&TRELOADID="+twkfli[1]+"&hiddenLinks="+hidlnk+"&admType="+admtype;
			//alert("else: "+lnk)
		}
		if (lnk!="") eSrc.href=lnk
	}
}





// cjb 22/02/2006 56793 - pass NokID to the menu, so you can bypass PAPerson.Find/List (if w/flow configured) and default the fields into PAPerson.Edit
function SelectRowHandler() {
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var objTblSel=getTable(eSrc);
	
	if (objTblSel.id!="tPANok_List") return;
	
	var objRowSel=getRow(eSrc);
	
	var patid=NokID="";
	if (objRowSel.className=='clsRowSelected') {
		var arrfld=objRowSel.getElementsByTagName('INPUT');
		for (var j=0; j<arrfld.length; j++) {
			if (arrfld[j].id.indexOf("PatientIDz")==0) {
				patid=arrfld[j].value;
			}
			if (arrfld[j].id.indexOf("NOK_RowId")==0) {
				NokID=arrfld[j].value;
			}
		}
	}
	
	if ((window.top)&&(window.top.frames["eprmenu"])) {
		window.top.MainClearEpisodeDetails()
		window.top.SetSingleField("PatientID",patid);
		window.top.SetSingleField("NokID",NokID);
	}
}




function NewClickHander() {
	//alert(parent.frames+"^"+parent.frames["panok_edit"]);
	//if ((parent)&&(parent.frames)&&(parent.frames["panok_edit"])) {
	if ((parent)&&(parent.frames)) {
		var EpiID="",PatID="",PARREF="",TWKFL="",TWKFLI="",admtype="";
		var EpiID=document.getElementById("EpisodeID")
		if (EpiID) EpiID=EpiID.value;
		var PatID=document.getElementById("PatientID")
		if (PatID) PatID=PatID.value;
		var parref=document.getElementById("PARREF");
		if (parref) parref=parref.value;
		var hidlnk=document.getElementById("hiddenLinks");
		if (hidlnk) hidlnk=hidlnk.value;
		var admtype=document.getElementById("admType");
		if (admtype) admtype=admtype.value;
		var TWKFL=document.getElementById("TWKFL")
		if (TWKFL) TWKFL=TWKFL.value;
		var TWKFLI=document.getElementById("TWKFLI")
		if (TWKFLI) TWKFLI=TWKFLI.value;
		var CONTEXT=document.getElementById("CONTEXT")
		if (CONTEXT) CONTEXT=CONTEXT.value;
		//eSrc.target = "traffic_contact_edit";
		//var currentlink=eSrc.href.split("?");
		//alert("currentlink :"+currentlink)
		//eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PATrafficAccidentContact.Edit&" + currentlink[1];
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PANok.Edit&" +"&EpisodeID="+EpiID+"&PatientID="+PatID+"&PARREF="+parref+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&hiddenLinks="+hidlnk+"&admType="+admtype+"&CONTEXT="+CONTEXT;
		if (window.name!="panok_list") {
			lnk=lnk+"&PatientBanner=1";
		}
		//alert(lnk)
		websys_createWindow(lnk,"panok_edit","top=50,left=50,width=700,height=500,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes"); 
		return false;
	}
}

//Log 60322 6-10-2006 BoC: add CopyClickHandler to copy a NOK and get new RowId
function CopyClickHandler(e) {
	var EpiID="",PatID="",PARREF="",admtype="";
	var EpiID=document.getElementById("EpisodeID")
	if (EpiID) EpiID=EpiID.value;
	var PatID=document.getElementById("PatientID")
	if (PatID) PatID=PatID.value;
	var parref=document.getElementById("PARREF");
	if (parref) parref=parref.value;
	var eSrc=websys_getSrcElement(e);
	if ((eSrc)&&(eSrc.tagName=="IMG")) eSrc=websys_getParentElement(eSrc);
	if (eSrc) {
		var rowid=eSrc.id;
		var rowAry=rowid.split("z");
		var row=rowAry[1]
		var nokid=document.getElementById("NOK_RowIdz"+row);
		if (nokid) nokid=nokid.value;
		//if (window.name=="panok_list") eSrc.target = "panok_edit";
		if (window.name=="panok_list") eSrc.target = "_self";
		//var currentlink=eSrc.href.split("?");
		//eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PANok.Edit&" + currentlink[1]+"&admType="+admtype;
		//var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PANok.Edit&" + currentlink[1]+"&admType="+admtype;
		var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PANok.Edit&" +"&ID="+nokid+"&EpisodeID="+EpiID+"&PatientID="+PatID+"&PARREF="+parref+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&hiddenLinks="+hidlnk+"&admType="+admtype+"&CONTEXT="+CONTEXT+"&CopyFlag=Y";
		if (window.name!="panok_list") {
			lnk=lnk+"&PatientBanner=1";
		}
		websys_createWindow(lnk,"panok_edit","top=50,left=50,width=700,height=500,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes"); 
		//eSrc=websys_getParentElement(eSrc);
	}
}

//log61054 TedT
function UpdatePatDetailClick(lnk) {
	var tbl=document.getElementById("tPANok_List");
	var nok="";
	for (var i=1;i<tbl.rows.length;i++) {
		var select=document.getElementById("selectz"+i);
		if(select && select.checked) {
			var parref=document.getElementById("NOK_PAPMI_ParRefz"+i);
			var child=document.getElementById("NOK_ChildSubz"+i);
			if(parref && child) nok+=parref.value+"||"+child.value+"^";
		}
	}
	if (nok=="") {
		alert(t['NO_SELECT']);
		return false;
	}
	
	lnk+="&PANokIDs="+nok;
	var patientID=document.getElementById("PatientID");
	if(patientID) lnk+="&PatientID="+patientID.value;
	
	websys_createWindow(lnk,"panok_detail","top=50,left=50,width=700,height=500,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes"); 
	return false;
}

document.body.onload = DocumentLoadHandler;