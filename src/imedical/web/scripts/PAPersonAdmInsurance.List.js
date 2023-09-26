// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


var frm = document.forms["fPAPersonAdmInsurance_List"];

function DocumentLoadHandler(e) {
	var objTable=document.getElementById("tPAPersonAdmInsurance_List");
	var eSrc;
	var newlink=document.getElementById("New1");
	if (newlink) newlink.onclick=NewClickHander;
	var updateObj=document.getElementById("update1");
	if (updateObj) updateObj.onclick=updateClickHandler;
	if (objTable) objTable.onclick=InsurClickHandler;
}

function updateClickHandler() {
	if (window.name=="papersonadminsurance_list") {
		if (frm.elements['TWKFL'].value!="") frm.elements['TFRAME'].value=window.parent.name;
		}
	return update1_click();
	
}
function InsurClickHandler(e) {
	var patid="",epid="",parref="",lnk="",TWKFLI="",TWKFL="",id="",rowid="",admtype;
	var patid=document.getElementById("PatientID");
	if (patid) patid=patid.value;
	var epid=document.getElementById("EpisodeID");
	if (epid) epid=epid.value;
	var parref=document.getElementById("PARREF");
 	if (parref) parref=parref.value;
	var rowid=document.getElementById("PAINS_RowId");
	if (rowid) rowid=rowid.value
	var hidlnk=document.getElementById("hiddenLinks");
 	if (hidlnk) hidlnk=hidlnk.value;
	var admtype=document.getElementById("admType");
 	if (admtype) admtype=admtype.value;
	var TWKFL=document.getElementById("TWKFL")
	if (TWKFL) TWKFL=TWKFL.value;
	var TWKFLI=document.getElementById("TWKFLI")
	if (TWKFLI) TWKFLI=TWKFLI.value;
   	var eSrc = websys_getSrcElement(e);
	if (eSrc.tagName=="IMG") {
		eSrc=websys_getParentElement(eSrc)
	}
	if ((parent.frames["papersonadminsurance_edit"])&&(eSrc.id!="")) {
			if (eSrc.tagName=="A") {
			if (eSrc.id.indexOf("edit1z")==0) {
				eSrc.target = "papersonadminsurance_edit";
				var currentlink=eSrc.href.split("?");
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PAPersonAdmInsurance.Edit&" + currentlink[1]+"&admType="+admtype;
				eSrc=websys_getParentElement(eSrc);
				if (selectedRowObj!=eSrc) SelectRow();
				}
			if (eSrc.id.indexOf("delete1z")==0) {
				eSrc.target="_parent"
				//alert("href " + eSrc.href);
				if  (TWKFLI.value=="") { 
					var currentlink=eSrc.href.split("?"); 
					var lnk="papersonadminsurance.csp?PARREF="+parref+"&hiddenLinks="+hidlnk+"&PatientID="+patid+"&ID="+rowid;
					//alert("if: "+lnk)
				} else { 
					var currentlink=eSrc.href.split("&TWKFLI=");
					var twkfli=currentlink[1].split("&ID=")
					var lnk=currentlink[0]+"&ID="+twkfli[1]+"&EpisodeID="+epid+"&PatientID="+patid+"&TWKFLI="+(TWKFLI-1)+"&hiddenLinks="+hidlnk;
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
	if ((parent)&&(parent.frames)&&(parent.frames["papersonadminsurance_edit"])) {
	
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
	//alert(admtype)
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
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PAPersonAdmInsurance.Edit&" +"&EpisodeID="+EpiID+"&PatientID="+PatID+"&PARREF="+parref+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&hiddenLinks="+hidlnk+"&admType="+admtype+"&CONTEXT="+CONTEXT
	//alert(lnk)
	websys_createWindow(lnk,"papersonadminsurance_edit",""); 
	return false;
	}
}

document.body.onload = DocumentLoadHandler;