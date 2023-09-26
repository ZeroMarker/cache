// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//log 56840

function WardLookupSelect(txt) {
	//alert(txt);
	var adata=txt.split("^");
	var desc=adata[0];
	var id=adata[2];
	window.focus();
	AddItemToList(id,desc,"WardList");
	var obj=document.getElementById("WARDDesc");
	if (obj) {
		obj.value="";
		websys_setfocus('WARDDesc');
	}
}

function AssignTaskToLookupSelect(txt) {
	//alert(txt);
	var adata=txt.split("^");
	var desc=adata[0];
	var id=adata[1];
	window.focus();
	AddItemToList(id,desc,"AssignedTo");
	var obj=document.getElementById("AssignTaskTo");
	if (obj) {
		obj.value="";
		websys_setfocus('AssignTaskTo');
	}
}

function AddPatientClickHandler() {
	var adata="";
	var obj=document.getElementById("RegistrationNo");
	if (obj) adata=obj.value
	window.focus();
	AddItemToList(adata,adata,"PatientList");
	var RegistrationNoobj=document.getElementById("RegistrationNo");
	if (RegistrationNoobj) {
		RegistrationNoobj.value="";
		websys_setfocus('RegistrationNo');
	}
}

function AddItemToList(id,desc,list) {
	//alert (id+"\n"+desc+"\n"+list);
	var lst=document.getElementById(list);
	lst.options[lst.length] = new Option(unescape(desc),id);
	lst.options[lst.length-1].id=id;
	lst.options[lst.length-1].selected=true;
}

function DeleteClickHandler() {
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var lst=document.getElementById(mPiece(eSrc.id,"Delete",0));
	for (var i=(lst.length-1); i>=0; i--){
		if (lst.options[i].selected) lst.options[i]=null;
	}
}

function AddTaskClickHandler() {
	var AssignedTo=GetListItems("AssignedTo");
	var Patients=GetListItems("PatientList");
	var Wards=GetListItems("WardList");
	var obj=document.getElementById("AssignedUsers");
	if (obj) obj.value=AssignedTo;
	var obj=document.getElementById("Patients");
	if (obj) obj.value=Patients;
	var obj=document.getElementById("Wards");
	if (obj) obj.value=Wards;
	//alert (AssignedTo+"\n"+Patients+"\n"+Wards);
	//self.location.reload();
	return AddTask_click();
}

function CloseClickHandler() {
	var parwin=window.opener;
	self.close();
	if(parwin) parwin.treload("websys.reload.csp");
}

function GetListItems(list) {
	var ItemIDs="";
	var lst=document.getElementById(list);
	if (lst){
		for (i=0;i<lst.length ;i++ ) {
			ItemIDs=ItemIDs+"^"+lst.options[i].id;
		}
	}
	return ItemIDs
}

function mPiece(s1,sep,n) {
	delimArray = s1.split(sep);
	if ((n <= delimArray.length-1) && (n >= 0)) return delimArray[n];
}

var WardDeleteObj=document.getElementById("WardListDelete");
if (WardDeleteObj) WardDeleteObj.onclick=DeleteClickHandler; 
var AssignedToDeleteObj=document.getElementById("AssignedToDelete");
if (AssignedToDeleteObj) AssignedToDeleteObj.onclick=DeleteClickHandler;  
var PatientListDeleteObj=document.getElementById("PatientListDelete");
if (PatientListDeleteObj) PatientListDeleteObj.onclick=DeleteClickHandler;
var AddPatientObj=document.getElementById("AddPatient");
if (AddPatientObj) AddPatientObj.onclick=AddPatientClickHandler;
var AddTaskObj=document.getElementById("AddTask");
if (AddTaskObj) AddTaskObj.onclick=AddTaskClickHandler;
var CloseObj=document.getElementById("close1");
if (CloseObj) CloseObj.onclick=CloseClickHandler;