// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var frm = document.forms["fPATempAddress_Edit"];

function DocumentLoadHandler(e) {

	var obj;

	obj=document.getElementById('ADDRDateFrom');
	if (obj) obj.onchange=AddrDateFromChangeHandler;

	obj=document.getElementById('ADDRDateTo');
	if (obj) obj.onchange=AddrDateToChangeHandler;

	//KK 28-Feb-2002 Log:23140 To hide the Address1 Lookup
	var obj=document.getElementById('ld367iADDRStreet');
	if (obj) obj.style.visibility = "hidden";
		
	if ((window.opener)&&(window.opener.opener)) {
		var doc=window.opener.opener.document;
		var objLeave=document.getElementById("PAAdmLeaveDR");
		var objID=doc.getElementById("ID");
		if ((objLeave)&&(objID)) {
			objLeave.value=objID.value;
		}
	}
	
	// cjb 10/08/2006 60478 - nasty hack to increment TWKFLI after an error message (UpdateClickHandler decreases by 1 if in workflow, so the page refreshes.  If you hit update after an error message, ends up decreased twice so you go back to the previous w/flow item...)
	var obj=frm.elements['TDIRTY'];
	if ((obj) && (obj.value==2)) {
		var obj=frm.elements['TWKFLI'];
		if (obj.value!="") obj.value++;
	}
	
	obj=document.getElementById('update1')
	if (obj) obj.onclick = UpdateHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;
}



function UpdateHandler() {
	// set the variable on PAAdmLeave to link the temp address for new leave
	/*if ((window.opener)&&(window.opener.opener)) {
		var objID=window.opener.opener.document.getElementById("ID");
		var obj=window.opener.opener.document.getElementById("NewTempAddr");
		if ((objID)&&(objID.value=="")&&(obj)) obj.value=1;
	}*/	
	if (parent.frames["tempAddr_edit"]) {
		
		//if (frm.elements['TWKFL'].value!="") frm.elements['TFRAME'].value="window.parent.name";
		frm.elements['TFRAME'].value=window.parent.name;
		
		}
	
		var obj=document.forms['fPATempAddress_Edit'].elements['TWKFLI'];
		if (!(fPATempAddress_Edit_submit())) return false
		if (obj.value!="") obj.value-=1;
				
		return update1_click();
}

function DeleteClickHandler(e) {

	//var lnk=document.getElementById("delete1")
	//if (parent.frames["tempAddr_edit"]) {
	//	var frm = document.forms["fPATempAddress_Edit"];
		//parent.frames['tempAddr_list'].location.reload();
		//parent.frames['tempAddr_edit'].location.reload();
		//lnk.target = "_parent"
	//}
	//return delete1_click();
	if ((parent)&&(parent.frames)&&(parent.frames["tempAddr_edit"])) {
		var frm = document.forms["fPATempAddress_Edit"];
		frm.target = "_parent";
	}
	return delete1_click();
}

function CityLookupSelect(str) {
 	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("CTZIPCode")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[1];
	obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[2];
 }

function CityAreaLookupSelect(str) {
 	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("CTZIPCode")
	if (obj) obj.value = lu[1];
 	obj=document.getElementById("CITAREADesc")
	if (obj) obj.value = lu[2];
 	obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[3];

}

function ZipLookupSelect(str) {
 	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("CTZIPCode")
	if (obj) obj.value = lu[0]; 
 	obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[1];
	obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[2];
}


function AddrDateToChangeHandler(e) {
		ADDRDateTo_changehandler(e) 
		var from=document.getElementById('ADDRDateFrom')
		var to=document.getElementById('ADDRDateTo')
		var fromdt=DateStringToArray(from.value)
		var todt=DateStringToArray(to.value)
		var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
		var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
		if ((to)&&(from)) {
			if (dtto< dtfrom) {
			alert("\'" + t['ADDRDateTo'] + "\' " + t['XINVALID'] + "\n");
			to.value=""
			}
		}
	
}


function AddrDateFromChangeHandler(e) {
		ADDRDateFrom_changehandler(e)
		var to=document.getElementById('ADDRDateTo')
		var from=document.getElementById('ADDRDateFrom')
		var fromdt=DateStringToArray(from.value)
		var todt=DateStringToArray(to.value)
		var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
		var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
		if ((to)&&(from)) {
			if (dtto< dtfrom) {
			alert("\'" + t['ADDRDateFrom'] + "\' " + t['XINVALID'] + "\n");
			from.value=""
			}
		}
	
}


window.onload = DocumentLoadHandler;




