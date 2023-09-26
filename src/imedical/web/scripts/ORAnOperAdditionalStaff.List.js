// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


var frm = document.forms["fORAnOperAdditionalStaff_List"];

function DocumentLoadHandler(e) {
	var objTable=document.getElementById("tORAnOperAdditionalStaff_List"); 
	var eSrc;
	var newlink=document.getElementById("New1");
	if (newlink) newlink.onclick=NewClickHander;
	if (tsc['New1']) websys_sckeys[tsc['New1']]=NewClickHander;	
	var updateObj=document.getElementById("update1");
	if (updateObj) updateObj.onclick=updateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=updateClickHandler;	
	if (objTable) objTable.onclick=TableClickHandler;

	DoInitStatusValidation();

}

//If the status (StatusId) is "D" or "A", then disable all fields.  This is executed on page load.
function DoInitStatusValidation(){
	var objSId = document.getElementById("StatusId");
	if(objSId && (objSId.value == "D" || objSId.value == "A")){
		makeReadOnly();
	}
}

//This function makes fields disabled.
function makeReadOnly() {
	var el=document.forms["fORAnOperAdditionalStaff_List"].elements;  
	if(!el) {return;}
	
	//disable input fields
	for (var i=0;i<el.length;i++) {
		if (!(el[i].type=="hidden")) {
			el[i].disabled=true;
		}
	}
	//disable image elements (lookup, dates etc. images)
	var arrImgs=document.getElementsByTagName("IMG");
	for (var i=0; i<arrImgs.length; i++) {
		if ((arrImgs[i].id)&&(arrImgs[i].id.charAt(0)=="l")) {
			arrImgs[i].disabled=true;
		}
	}
	//disable links
	var arrLinks=document.getElementsByTagName("A");
	for (var i=0; i<arrLinks.length; i++) {
		if ((arrLinks[i].id)) {
			if(arrLinks[i].id.indexOf("update1") == -1){
				arrLinks[i].disabled=true;
				arrLinks[i].className="clsDisabled";
				arrLinks[i].onclick=LinkDisabled;
				arrLinks[i].style.cursor='default';
			}
		}
	}

}

function LinkDisabled() {
	return false;
}

function updateClickHandler() {
	if (window.name=="frm_list") {
		if (frm.elements['TWKFL'].value!="") frm.elements['TFRAME'].value=window.parent.name;
		}
	return update1_click();
	
}

function TableClickHandler(e) {
	var patid="",epid="",parref="",id="",rowid="";
	var patid=document.getElementById("PatientID");
	if (patid) patid=patid.value;
	var epid=document.getElementById("EpisodeID");
	if (epid) epid=epid.value;
	var parref=document.getElementById("PARREF");
 	if (parref) parref=parref.value;
	var rowid=document.getElementById("OPASRowId");
	if (rowid) rowid=rowid.value
   	var eSrc = websys_getSrcElement(e);
	if (parent.frames["frm_edit"]) {
		if (eSrc.tagName=="IMG") { //tagnames like TD, TH etc...
			eSrc=websys_getParentElement(eSrc)
		}
		if (eSrc.tagName=="A") {
			if (eSrc.id.indexOf("OPASCareProvTypez")==0) { 
				eSrc.target = "frm_edit"; //frame target
				eSrc=websys_getParentElement(eSrc);
				if (selectedRowObj!=eSrc) SelectRow();
				}
			if (eSrc.id.indexOf("delete1z")==0) {
				eSrc.target="_parent"; //frame target
			}
		}
	}
}

function NewClickHander(e) {
	if ((parent)&&(parent.frames)&&(parent.frames["frm_edit"])) {
		var epid="",patid="",parref="";
		var epid=document.getElementById("EpisodeID")
		if (epid) epid=epid.value;
		var patid=document.getElementById("PatientID")
		if (patid) patid=patid.value;
		var parref=document.getElementById("PARREF");
	 	if (parref) parref=parref.value;

		//need to specify the link here, because New1 is a button and doesn't have a target attribute.  Use the websys_createwindow method
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=ORAnOperAdditionalStaff.Edit&" +"&PARREF="+parref+"&PatientID="+patid+"&EpisodeID="+epid;
		websys_createWindow(lnk,"frm_edit",""); //frame name is frm_edit
		return false;
	}
}

	


document.body.onload = DocumentLoadHandler;