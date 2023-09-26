// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var mandatcomnts=""
var frm = document.forms["fPAAdm_FAActionEdit"];
//if (document.getElementById("RESUSEntered")) {document.getElementById("RESUSEntered").tkItemPopulate=1;}
if (parent.frames["paadmfaex_edit"]) {
frm.elements['TFRAME'].value=window.parent.name;
	}

function Init() {
	var obj;

	obj=document.getElementById('deleteAction');
	if (obj) obj.onclick=ActionDeleteClickHandler;

	
	
	obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateAll;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateAll;

	obj=document.getElementById('Uclose');
	if (obj) obj.onclick=UpdateAll1;
	if (tsc['Uclose']) websys_sckeys[tsc['Uclose']]=UpdateAll1;
	
}

function setBoldLinks(el,state) {
	obj=document.getElementById(el);
	if (obj) {
		if (state==1) {obj.style.fontWeight="bold";}
		else {obj.style.fontWeight="normal";}
	}
}


function DisableFldObj(fld) {
	if (fld) {
		fld.disabled = true;
		fld.className = "clsDisabled";
	}
}

function DisableGreyFldObj(fld) {
	if (fld) {
		fld.disabled = true;
		fld.className = "disabledField";
	}
}


function DisableLink(obj){
	obj.disabled=true;
	obj.className="clsDisabled";
	obj.onclick=LinkDisabled;
	obj.style.cursor='default';

}


function LinkDisabled() {
	return false;
}

function UpdateAll() {
	UpdateAction();
	if (!CheckForMandatoryCommnets()) return false;
	var obj=document.getElementById('Updated');
	if (obj){
		if(obj.value == "0") obj.value = "1";
	}
	var frm = document.forms["fPAAdm_FAActionEdit"]
	var obj=frm.elements['TWKFLI'];
	if (obj.value!="") obj.value-=1;
	var obj=document.getElementById('update1');
	if (obj) return update1_click();
	var obj=document.getElementById('update');
	if (obj) return update_click();
	
}

function UpdateAll1() {
	UpdateAction();
	if (!CheckForMandatoryCommnets()) return false;
	var obj=document.getElementById('Updated');
	if (obj){
		if(obj.value == "0") obj.value = "1";
	}
	var frm = document.forms["fPAAdm_FAActionEdit"]
	var obj=document.getElementById('Uclose');
	if (obj) return Uclose_click();
	
	
}

function CheckForMandatoryCommnets() {

    var obj=document.getElementById('PAADM2FreqAttendComments');
    if ((mandatcomnts==1)&&(obj)&&(obj.value=="")) 
    {
    alert(t['PAADM2FreqAttendComments']+ "\' " + t['XMISSING'] + "\n");
    return false;
    }
    return true;


}
	


function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "";
	}
}

//checks that mandatory fields are filled in
function checkMandatoryFields(){
	var valid = checkMandatoryListBoxes();
	if (valid)
		valid = checkDelivPlace();
		
	return valid;
}

//PAPrDelBabyDelMthd List
function UpdateAction() {
	var arrItems = new Array();
	var lst = document.getElementById("FAActionsEntrd");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("FAActionString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}


function CheckmandatoryAction() {
	var arrItems = new Array();
	mandatcomnts=0;
	var lst = document.getElementById("FAActionsEntrd");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			var codet=lst.options[j].text;
			var chmandat=tkMakeServerCall("web.PACFreqAttendActions","CheckIfMandatory",codet);
			if (chmandat=="Y") 
			{
			mandatcomnts=1;
			labelMandatory('PAADM2FreqAttendComments');
			}
			
			
		}
		if (mandatcomnts==0) { labelNormal('PAADM2FreqAttendComments'); }
		
	}
}

function ActionDeleteClickHandler() {
	//Delete items from DelMthBEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("FAActionsEntrd")
	if (obj)
		RemoveFromList(obj);
		CheckmandatoryAction();
	return false;
}


function FAActionSelect(txt) {
	//Add an item to PAPrDelBabyDelMthd list when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("FAActionsEntrd")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("FA Action has already been selected");
				var obj=document.getElementById("FAAction")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("FA Action has already been selected");
				var obj=document.getElementById("FAAction")
				if (obj) obj.value="";
				return;
			}
		}
	}
	
	
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("FAAction")
	if (obj) obj.value="";
	CheckmandatoryAction();
	//(adata[3]);
	if (adata[3]=="Y")  {
	mandatcomnts=1;
	labelMandatory('PAADM2FreqAttendComments');
	}
}

function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

function AddItemToList_Reload(list,code,desc) {
	//Add an item to a listbox
	list.options[list.options.length] = new Option(desc,code);
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
		obj.options[i]=null;
	}

}

function RemoveAllFromList(obj){
	for (var i=(obj.length-1); i>=0; i--) {
		obj.options[i]=null;
	}

}

//TN: reload listboxes with values in hidded fields.
//this is due to page being refreshed upon error message (such as invalid pin)
function ReloadListBoxes() {
	ListboxReload("FAActionString","FAActionsEntrd");
	

}

function ListboxReload(strName, lstName) {
	var el = document.getElementById(strName);
	var lst = document.getElementById(lstName);
	var updated = document.getElementById("Updated");
	//don't execute this when page loads for the first time b/c first time values come from db, 
	//execute for subsequent reloads (such as on error condition).
	if ((lst) && (el) && (updated.value == "1")) {
		//alert("before remove");
		RemoveAllFromList(lst);
		//alert("after remove");
		if(el.value != ""){
			var arrITEM=el.value.split(String.fromCharCode(1));
			for (var i=0; i<arrITEM.length; i++) {
				var arrITEMVAL=arrITEM[i].split(String.fromCharCode(2));
				AddItemToList_Reload(lst,arrITEMVAL[0]+String.fromCharCode(2)+arrITEMVAL[1],arrITEMVAL[2]);
			}
		}
	}
	
}


//TN: call this outside onload call so it can be called straight away, and not wait till everything has loaded.
ReloadListBoxes();

document.body.onload=Init;
