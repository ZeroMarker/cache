// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//var separatorDate="/";
//var formatDate="DMY";
var EXCESSIVEYEAR=1880;
var EXCESSIVEAGE=121;
//alert("First time");
function DocumentLoadHandler() {
	
	
	//UpdateRegistration();
	//alert("First time2");
	var obj;

	obj=document.getElementById('admdate');
	if (obj) obj.onchange=checkAdmDate;

	obj=document.getElementById('admtime');
	if (obj) obj.onchange=checkAdmTime;
	
	obj=document.getElementById('dischdate');
	if (obj) obj.onchange=checkDischDate;

	obj=document.getElementById('dischtime');
	if (obj) obj.onchange=checkDischTime;

	obj=document.getElementById('GP');
	if (obj) obj.onblur=ClearGP;	

	obj=document.getElementById('TGP');
	if (obj) obj.onblur=ClearTGP;	

	obj=document.getElementById('DeleteRego');
	if (obj) obj.onclick=DeleteRegoClickHandler;
	
	obj=document.getElementById('find1');
	if (obj) obj.onclick= FindClickHandler;
	//if (tsc['find1']) websys_sckeys[tsc['find1']]=FindShortcutKeyHandler;

}

//standard change handlers to clear associated fields

function LookUpLocation(str) {
	var lu = str.split("^");
	if (lu[1]!="") {
		var obj1=document.getElementById('Unit')
		if (obj1) obj1.value = lu[1]
			}
}

function ChangeGP(str) {
	var lu=str.split("^");
	var obj=document.getElementById("GPcode");
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('GP');
	if (obj) obj.value=lu[0];
	if ((obj)&&(obj.value!="")) {
		var hiddoc = document.getElementById("hiddoc")
		if (hiddoc) hiddoc.value = obj.value
		}
}
function ChangeTGP(str) {
	var lu=str.split("^");
	var obj=document.getElementById("TGPcode");
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('TGP');
	if (obj) obj.value=lu[0];
	if ((obj)&&(obj.value!="")) {
		var hiddoc = document.getElementById("hiddoc")
		if (hiddoc) hiddoc.value = obj.value
		}	
}

function ClearGP(e) {
	var obj=document.getElementById('GP');
	var objC=document.getElementById("GPcode");
	var hiddoc = document.getElementById("hiddoc")	
	if ((obj)&&(obj.value==""))
	 {
	 if (objC)  { objC.value="";}
	 if (hiddoc) { hiddoc.value="";}
	}

}
function ClearTGP(e) {
	var obj=document.getElementById('TGP');
	var objC=document.getElementById("TGPcode");
	if ((obj)&&(obj.value=="")&&(objC)) { objC.value="";}	
}

function checkAdmDate(e) {
	
	var obj =document.getElementById('admdate')
	if ((obj)&&(obj.value!="")) {
		labelMandatory('admtime')
		DisableField('dischdate')
		DisableField('dischtime')
		var el = document.getElementById("admtype")
		if (el) el.value = "D"
		//alert(el.value)
	}
		                    
	if ((obj)&&(obj.value=="")) {
		labelNormal('admtime')
		EnableField('dischdate')
		EnableField('dischtime')
		}
	admdate_changehandler();
}

function checkAdmTime(e) {
	
	var obj =document.getElementById('admtime')
	if ((obj)&&(obj.value!="")) {
		labelMandatory('admdate')
		DisableField('dischdate')
		DisableField('dischtime')
		var el = document.getElementById("admtype")
		if (el) el.value = "D"
		//alert(el.value)
	                            }
	if ((obj)&&(obj.value=="")) {
		//labelNormal('admdate')
		EnableField('dischdate')
		EnableField('dischtime')	
	}
		admtime_changehandler();
}

function checkDischDate(e) {
	//alert("dateadm")
	var obj =document.getElementById('dischdate')
	if ((obj)&&(obj.value!="")) {
		labelMandatory('dischtime')
		DisableField('admdate')
		DisableField('admtime')
		var el = document.getElementById("admtype")
		if (el) el.value = "A"
		//alert(el.value)
		                    }
	if ((obj)&&(obj.value=="")) {
		labelNormal('dischtime')
		EnableField('admdate')
		EnableField('admtime')
		labelMandatory('admdate')	
	}
	dischdate_changehandler();
}
function checkDischTime(e) {
	
	var obj =document.getElementById('dischtime')
	if ((obj)&&(obj.value!="")) {
		labelMandatory('dischdate')
		DisableField('admdate')
		DisableField('admtime')
		var el = document.getElementById("admtype")
		if (el) el.value = "A"
		//alert(el.value)
		
	                            }
	if ((obj)&&(obj.value=="")) {
		labelNormal('dischdate')
		EnableField('admdate')
		EnableField('admtime')	
		labelMandatory('admdate')
	}
	dischtime_changehandler();
}
//

function UpdateRegistration() {
	//alert("inside update registation")
	var arrItems = new Array();
	var lst = document.getElementById("REGOentered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//MD:21-Jun-2002:need to pass description for reloading when update error occurs
			arrItems[j] =lst.options[j].text;
		}
		var el = document.getElementById("RegoString");
		//alert(j)
		//alert(el.value)
		if (el) el.value = arrItems.join(",");
	}
	//alert(el.value)
	//var aa=el.value
	//alert(aa)
	el.value=el.value.toUpperCase()
	//alert(el.value)
}



function RegoLookupSelect(txt) {
	//Add an item to REGOenetered when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	//alert("adata="+adata);
	var obj=document.getElementById("REGOentered")
	//alert("I am inside")
	
	
	
	if (obj) {
		//Need to check if Rego already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
				
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
			
				alert("Rego has already been selected");
				var obj=document.getElementById("Rego")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
			
				alert("Rego has already been selected")
				var obj=document.getElementById("Rego")
				if (obj) obj.value="";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("Rego")
	websys_setfocus("Rego")
	if (obj) obj.value="";
	//alert("adata="+adata);
}

function RegoReload() {
	var el = document.getElementById("RegoString");
	var lst = document.getElementById("REGOentered");
	
	if ((lst)&&(el.value!="")) {
		//var regovalue=el.value
		
		var arrR=el.value.split(",");
		for (var i=0; i<arrR.length; i++) {	
		AddItemToList(lst,"",arrR[i]);
			}
		}
		
}

function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	var frm=document.fPAAdm_BatchProcess;
	//TDIRTY=document.getElementById("TDIRTY")
	frm.TDIRTY.value=2
	//alert("and now..."+frm.TDIRTY.value);
	code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

function RemoveFromList(obj) {
	var frm=document.fPAAdm_BatchProcess;
	//TDIRTY=document.getElementById("TDIRTY")
	frm.TDIRTY.value=2
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function DeleteRegoClickHandler() {
	//Delete items from  listbox when a "Delete" button is clicked.
	var obj=document.getElementById("REGOentered")
	//alert(obj.value)
	if (obj)
		RemoveFromList(obj);
	return false;
}

//functions used to enable/disable fields and display label as mandatory/non mandatory
//presently called by custom script for Austin, but left here for general use

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
	//	if (lbl) lbl = lbl.className = "clsRequired";
	}
}
function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}
function DisableCheckbox(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.checked = false;
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}
function Disable(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.disabled==true)) {
		fld.value = "";
		fld.disabled = false;
		//fld.className = "";
		//if (lbl) lbl = lbl.className = "";
	}
}

function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl=lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl=lbl.className = "";
	}
}

function FindClickHandler(e) {
	
	if (!CheckMandatoryFields()) { return }
	UpdateRegistration();
	aa=UpdateDateString();
	//alert(aa)
	//alert("I went to update registration")
	return find1_click();
}

function CheckMandatoryFields() {

	var msg="";

	var objAd =document.getElementById('admdate')

	var objAt  =document.getElementById('admtime')
	
	var objAd2 =document.getElementById('dischdate')

	var objAt2  =document.getElementById('dischtime')


	if(((objAd)&&(objAd.value!=""))&&((objAt)&&(objAt.value==""))) {
		
	msg += "\'" + t['admtime'] + "\' " + t['XMISSING'] + "\n";
		
	}

	if(((objAt)&&(objAt.value!=""))&&((objAd)&&(objAd.value==""))) {
		
	msg += "\'" + t['admdate'] + "\' " + t['XMISSING'] + "\n";
		
	}


	


	if(((objAd2)&&(objAd2.value!=""))&&((objAt2)&&(objAt2.value==""))) {
		
	msg += "\'" + t['dischtime'] + "\' " + t['XMISSING'] + "\n";
		
	}

	if(((objAt2)&&(objAt2.value!=""))&&((objAd2)&&(objAd2.value==""))) {
		
	msg += "\'" + t['dischdate'] + "\' " + t['XMISSING'] + "\n";
		
	}


	if (msg != "") {
		alert(msg)
		return false;
	} else {
		return true;
	}
}

function UpdateDateString() {

	var msg="";

	var objAd =document.getElementById('admdate')

	var objAt  =document.getElementById('admtime')
	
	var objAd2 =document.getElementById('dischdate')

	var objAt2  =document.getElementById('dischtime')

	var el = document.getElementById("totD");
		
		

	if(((objAd)&&(objAd.value!=""))&&((objAt)&&(objAt.value!=""))) {
	if (el){ 
	el.value = objAd.value + "," + objAt.value;		
		}	
	}

		


	if(((objAd2)&&(objAd2.value!=""))&&((objAt2)&&(objAt2.value!=""))) {
	if (el) {
	 el.value = objAd2.value + "," + objAt2.value;				
		}
		
	}
	return (el.value)
	
}

function ReloadListBoxes() {

	RegoReload();
}

ReloadListBoxes();

document.body.onload = DocumentLoadHandler;
