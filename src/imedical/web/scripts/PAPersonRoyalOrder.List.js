// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 11.11.04

var frm = document.forms["fPAPersonRoyalOrder_List"];

function NewClickHander() {
	if ((parent)&&(parent.frames)) {
		var PatID="",PARREF="",TWKFL="",TWKFLI="";
		var PatID=document.getElementById("PatientID");
		if (PatID) PatID=PatID.value;
		var parref=document.getElementById("PARREF");
		if (parref) parref=parref.value;
		var TWKFL=document.getElementById("TWKFL");
		if (TWKFL) TWKFL=TWKFL.value;
		var TWKFLI=document.getElementById("TWKFLI");
		if (TWKFLI) TWKFLI=TWKFLI.value;
		var CONTEXT=document.getElementById("CONTEXT");
		if (CONTEXT) CONTEXT=CONTEXT.value;
		var admType=document.getElementById("admType");
		if (admType) admType=admType.value;
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PAPersonRoyalOrder.Edit&"+"&PatientID="+PatID+"&PARREF="+parref+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+CONTEXT+"&admType="+admType;
		websys_createWindow(lnk,"PAPersonRoyalOrder_Edit","top=50,left=50,width=700,height=500,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes"); 
		return false;
	}
}

function TableClickHandler(e) {
    var eSrc = websys_getSrcElement(e);
	var patid="",parref="",lnk="",TWKFLI="",TWKFL="",id="",rowid="";
	var patid=document.getElementById("PatientID");
	if (patid) patid=patid.value;
	var parref=document.getElementById("PARREF");
 	if (parref) parref=parref.value;
    var rowObj=getRow(eSrc);
    if (rowObj) row=rowObj.rowIndex;
	var rowid=document.getElementById("IDz"+row);
	if (rowid) rowid=rowid.value;
	var TWKFL=document.getElementById("TWKFL");
	if (TWKFL) TWKFL=TWKFL.value;
	var TWKFLI=document.getElementById("TWKFLI");
	if (TWKFLI) TWKFLI=TWKFLI.value;
	var CONTEXT=document.getElementById("CONTEXT");
	if (CONTEXT) CONTEXT=CONTEXT.value;
	var admType=document.getElementById("admType");
	if (admType) admType=admType.value;
    
   	var eSrc = websys_getSrcElement(e);
	if (eSrc.tagName=="IMG") {
		eSrc=websys_getParentElement(eSrc);
	}

    // open in new window if outside of frames
    /*
    if (!parent.frames["PAPersonRoyalOrder_Edit"]) {
			if (eSrc.id.indexOf("ROYALNumberz")==0) {
				var currentlink=eSrc.href.split("?");
				lnk = "paperson.royalframe.csp?"+currentlink[1];
				websys_createWindow(lnk,"PAPersonRoyalOrder_Frame","top=50,left=50,width=700,height=500,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes"); 
				if (selectedRowObj!=eSrc) SelectRow();
                return false;
			}
    }
    */
    
	if ((parent.frames["PAPersonRoyalOrder_Edit"])&&(eSrc.id!="")) {
    	if (eSrc.tagName=="A") {
			if (eSrc.id.indexOf("ROYALNumberz")==0) {
				eSrc.target = "PAPersonRoyalOrder_Edit";
				var currentlink=eSrc.href.split("?");
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PAPersonRoyalOrder.Edit&"+currentlink[1];
				eSrc=websys_getParentElement(eSrc);
                eSrc.href=lnk
			}
			if (eSrc.id.indexOf("deletez")==0) {
				eSrc.target="_parent"
				if  (TWKFLI.value=="") { 
					var currentlink=eSrc.href.split("?"); 
					var lnk="paperson.royalorder.csp?PARREF="+parref+"&PatientID="+patid+"&ID="+rowid;
                    eSrc.href=lnk
				} else { 
					var currentlink=eSrc.href.split("&TWKFLI=");
					var twkfli=currentlink[1].split("&ID=")
					var lnk=currentlink[0]+"&ID="+twkfli[1]+"&PatientID="+patid+"&TWKFLI="+(TWKFLI-1)+"&CONTEXT="+CONTEXT;
                    eSrc.href=lnk
				}	
			}
		}
	}
    

    if (selectedRowObj!=eSrc) {
        SelectRow();
    }
    var obj=document.getElementById("RoyalID");
    if ((obj)&&(rowObj.tagName!="TH")) {
        if (rowObj.className=="clsRowSelected") obj.value=rowid;
        if (rowObj.className!="clsRowSelected") obj.value="";
    }
    //alert(obj.value);
}

function UpdateClickHandler() {
	if (window.name=="PAPersonRoyalOrder_List") {
		if (frm.elements['TWKFL'].value!="") frm.elements['TFRAME'].value=window.parent.name;
	}
    var obj=document.getElementById("TWKFLI");
    if (obj) obj.value=obj.value-1;
	return update1_click();
	
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) { 
		return false;
	}
	return true;
}

function getRow(eSrc) {
	while(eSrc.tagName != "TR") {
		if (eSrc.tagName == "TH") break;
		eSrc=eSrc.parentElement;
	}
	return eSrc;
}

function DocumentLoadHandler() {
	var newlink=document.getElementById("new1");
	if (newlink) newlink.onclick=NewClickHander;
    
    var updlink=document.getElementById("update1");
	if (updlink) updlink.onclick=UpdateClickHandler;
    
    // if outside of frames, disable new link and simply continue on update
    if ((parent.frames)&&(!parent.frames["PAPersonRoyalOrder_Edit"])) {
        if (newlink) {
            newlink.disabled=true;
            newlink.onclick=LinkDisable;
        }
        if (updlink) {
            updlink.onclick=update1_click;
        }
    }
	
	var objTable=document.getElementById("tPAPersonRoyalOrder_List");
	if (objTable) objTable.onclick=TableClickHandler;
}

document.body.onload=DocumentLoadHandler;