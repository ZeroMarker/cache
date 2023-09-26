// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var frm = document.forms["fPATempAddress_List"];

function DocumentLoadHandler(e) {
	//alert(window.name)
	//alert(window.parent.name)
	var objTable=document.getElementById("tPATempAddress_List");
	var IDObj=document.getElementById("AddrID");
	var eSrc;
	var newlink=document.getElementById("New1");
	if (newlink) newlink.onclick=NewClickHander;
	var updateObj=document.getElementById("update1");
	
	if (updateObj) updateObj.onclick=updateClickHandler;

	if (objTable) objTable.onclick=AddrClickHandler;

	if (objTable) {
		var numRows=objTable.rows.length;
		var currentRow;
		var currentIdObj,currentLink;

		for (i=1;i<numRows;i++) {
			currentRow=objTable.rows[i];
			currentIdObj=document.getElementById("ADDR_RowIdz"+i);
			currentLink=document.getElementById("CTADR_Descz"+i);
			//if (currentIdObj&&IDObj&&(currentIdObj.value==IDObj.value)) {
			if ((currentIdObj)&&(currentIdObj.value==IDObj.value)) {
				//alert(currentIdObj.value);
				currentLink.click();
			}
		}

	} //Row Highlight
}

function updateClickHandler() {
	//alert(frm.elements['TWKFL'].value)	
	if (window.name=="tempAddr_list") {
		if (frm.elements['TWKFL'].value!="") frm.elements['TFRAME'].value=window.parent.name;
		//if (frm.elements['TWKFL']!="") frm.elements['TFRAME'].value=window.parent.name
	}
	return update1_click();
	
}

function AddrClickHandler(e) {
	
	
	var addrDTo=patid=epid=parref=addrid=hidlnk=lnk=TWKFLI=TWKFL=id="";
	var addrDTo=document.getElementById("ADDR_DateTo");
	if (addrDTo) addrDTo=addrDTo.value;
	var patid=document.getElementById("PatientID");
	if (patid) patid=patid.value;
	var epid=document.getElementById("EpisodeID");
	if (epid) epid=epid.value;
	var parref=document.getElementById("PARREF");
 	if (parref) parref=parref.value;
	var addrid=document.getElementById("ADDR_RowId");
 	if (addrid) addrid=addrid.value
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
		if (eSrc) {
			   if (CheckOSIMG(eSrc)=="false") return false;	
			   }
				
	}
	// ab 42928 - check if eSrc.id exists, so we dont do this on the sort arrows
	if ((parent.frames["tempAddr_edit"])&&(eSrc.id!="")) {

		if (eSrc.tagName=="A") {
			if (eSrc.id.indexOf("CTADR_Descz")==0) {
				eSrc.target = "tempAddr_edit";
				var currentlink=eSrc.href.split("?");
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PATempAddress.Edit&" + currentlink[1];
				eSrc=websys_getParentElement(eSrc);
				if (selectedRowObj!=eSrc) SelectRow();
				}
			if (eSrc.id.indexOf("delete1z")==0) {
				eSrc.target="_parent"
				if  (TWKFLI.value=="") { 
					var currentlink=eSrc.href.split("?"); 
					var lnk="patempaddrframe.csp?ADDR_DateTo="+addrDTo+"&PARREF="+parref+"&EpisodeID="+epid+"&hiddenLinks="+hidlnk+"&PatientID="+patid+"&ID="+addrid+"&admType="+admtype;
					//alert("if: "+lnk)
				} else { 
					var currentlink=eSrc.href.split("&TWKFLI=");
					var twkfli=currentlink[1].split("&ID=")
					var lnk=currentlink[0]+"&ID="+twkfli[1]+"&EpisodeID="+epid+"&PatientID="+patid+"&hiddenLinks="+hidlnk+"&TWKFLI="+(TWKFLI-1)+"&admType="+admtype;
					//alert("else: "+lnk)
				}
			}
				
				eSrc.href=lnk
		}
	}
}
function NewClickHander() {

	if ((parent)&&(parent.frames)&&(parent.frames["tempAddr_edit"])) {
	
	var EpiID="",PatID="",PARREF="",TWKFL="",TWKFLI="";
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
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PATempAddress.Edit&" +"&EpisodeID="+EpiID+"&PatientID="+PatID+"&PARREF="+parref+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&hiddenLinks="+hidlnk+"&admType="+admtype+"&CONTEXT="+CONTEXT
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PATempAddress.Edit&" +"&EpisodeID="+EpiID+"&PatientID="+PatID+"&PARREF="+parref+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&hiddenLinks="+hidlnk+"&admType="+admtype+"&CONTEXT="+CONTEXT+"&PUPPatient="+parref
	websys_createWindow(lnk,"tempAddr_edit",""); 
	//var lnk="patempaddrframe.csp?"+"&EpisodeID=" + EpiID.value+"&PatientID=" + PatID.value;
	return false;
	}
}

function CheckOSIMG(eSrc) {
	return true;
		
}

document.body.onload = DocumentLoadHandler;



function SelectRowHandler(evt) {
	
	var eSrc=websys_getSrcElement(evt);
	var rowObj=getRow(eSrc);
	//alert(rowObj.className);
	if (rowObj.tagName != "TH") {
		if (eSrc.tagName != "A") eSrc=websys_getParentElement(eSrc);
		if (CheckOSIMG(eSrc)=="false") return false;
		
		if (eSrc.tagName != "A") return;
		var rowsel=rowObj.rowIndex;
		
		// cjb 05/05/2005 56733 - not sure why the var lnk=... was commented out, but was the lines after were causing an error because lnk wasn't setup.   Commented all out.
		/*
		//var lnk="patempaddrframe.csp?TWKFL="+document.getElementById("TWKFL").value;
		
		el=document.forms['fPATempAddress_Edit'].elements['TWKFLI'];
		if (el) lnk+="&TWKFLI="+el.value;
		el=document.getElementById("PatientID");
		if (el) lnk+="&PatientID="+el.value;
		el=document.getElementById("EpisodeID");
		if (el) lnk+="&EpisodeID="+el.value;
		window.location=lnk;
		*/
		
		return false;
	
	}
} 
