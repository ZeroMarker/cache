// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


var frm = document.forms["fPATrafficAccidentContact_List"];

function DocumentLoadHandler(e) {
	var objTable=document.getElementById("tPATrafficAccidentContact_List");
	var eSrc;
	var newlink=document.getElementById("New1");
	if (newlink) newlink.onclick=NewClickHander;
	var updateObj=document.getElementById("update1");
	if (updateObj) updateObj.onclick=updateClickHandler;
	if (objTable) objTable.onclick=ContactClickHandler;
}

function updateClickHandler() {
	if (window.name=="traffic_contact_list") {
		if (frm.elements['TWKFL'].value!="") frm.elements['TFRAME'].value=window.parent.name;
		//if (frm.elements['TWKFL']!="") frm.elements['TFRAME'].value=window.parent.name
	}
	return update1_click();
	
}
function ContactClickHandler(e) {
	
	var patid="",epid="",parref="",lnk="",TWKFLI="",TWKFL="",id="",rowid="";
	var patid=document.getElementById("PatientID");
	if (patid) patid=patid.value;
	var epid=document.getElementById("EpisodeID");
	if (epid) epid=epid.value;
	var parref=document.getElementById("PARREF");
 	if (parref) parref=parref.value;
	var rowid=document.getElementById("CONT_RowId");
 	if (rowid) rowid=rowid.value
	var trafficID=document.getElementById("trafficID");
 	if (trafficID) trafficID=trafficID.value
	var TWKFL=document.getElementById("TWKFL")
	if (TWKFL) TWKFL=TWKFL.value;
	var TWKFLI=document.getElementById("TWKFLI")
	if (TWKFLI) TWKFLI=TWKFLI.value;
	//alert(rowid)
	var eSrc = websys_getSrcElement(e);
	if (parent.frames["traffic_contact_edit"]) {
		if (eSrc.tagName=="IMG") {
			eSrc=websys_getParentElement(eSrc)
		}
		if (eSrc.tagName=="A") {
			if (eSrc.id.indexOf("PCTDescz")==0) {
				eSrc.target = "traffic_contact_edit";
				var currentlink=eSrc.href.split("?");
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PATrafficAccidentContact.Edit&" + currentlink[1];
				eSrc=websys_getParentElement(eSrc);
				if (selectedRowObj!=eSrc) SelectRow();
			}
			if (eSrc.id.indexOf("delete1z")==0) {
				//eSrc=websys_getParentElement(eSrc);
				eSrc.target="_parent"
				if (selectedRowObj!=eSrc) SelectRow();
				if  (TWKFLI.value=="") { 
					var lnk="patrafficaccidentcontact.csp?PARREF="+parref+"&EpisodeID="+epid+"&PatientID="+patid
					//alert("if: "+lnk)
				} else { 
					var currentlink=eSrc.href.split("&TWKFLI=");
					var twkfli=currentlink[1].split("&ID=")
					var lnk=currentlink[0]+"&ID="+twkfli[1]+"&EpisodeID="+epid+"&PatientID="+patid+"&trafficID="+trafficID+"&PARREF="+parref+"&TWKFLI="+(TWKFLI-1);
					//alert("else: "+lnk)
				}	
			}
			eSrc.href=lnk
		}
	}
	//alert(target)
	//return false
}
function NewClickHander() {
  //var eSrc =document.getElementById("New1");
   //alert("eSrc :"+eSrc.href)
	if ((parent)&&(parent.frames)&&(parent.frames["traffic_contact_edit"])) {
	
	var EpiID="",PatID="",PARREF="",TWKFL="",TWKFLI="";
	var EpiID=document.getElementById("EpisodeID")
	if (EpiID) EpiID=EpiID.value;
	var PatID=document.getElementById("PatientID")
	if (PatID) PatID=PatID.value;
	var parref=document.getElementById("PARREF");
 	if (parref) parref=parref.value;
 	var hidlnk=document.getElementById("hiddenLinks");
 	if (hidlnk) hidlnk=hidlnk.value;
	var TWKFL=document.getElementById("TWKFL")
	if (TWKFL) TWKFL=TWKFL.value;
	var TWKFLI=document.getElementById("TWKFLI")
	if (TWKFLI) TWKFLI=TWKFLI.value;
	//eSrc.target = "traffic_contact_edit";
	//var currentlink=eSrc.href.split("?");
	//alert("currentlink :"+currentlink)
	//eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PATrafficAccidentContact.Edit&" + currentlink[1];
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PATrafficAccidentContact.Edit&" +"&EpisodeID="+EpiID+"&PatientID="+PatID+"&PARREF="+parref+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&hiddenLinks="+hidlnk
	websys_createWindow(lnk,"traffic_contact_edit",""); 
	return false;
	}
}

document.body.onload = DocumentLoadHandler;




