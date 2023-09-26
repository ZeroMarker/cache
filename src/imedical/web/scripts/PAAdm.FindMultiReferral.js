// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function DocumentLoadHandler() {
	// Moved to onblur handler
	//obj=document.getElementById('weeksWaiting')
	//if (obj) obj.onchange= ClearDateHandler;
	obj=document.getElementById('PAADMRefDocListDR')
	if (obj) obj.onblur= ClearRefDocHandler;
	obj=document.getElementById('find1');
	if (obj) obj.onclick= FindClickHandler;
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;
	//LOG 31220 BC 7-2-2003 Status list for the search
	obj=document.getElementById('DeleteReferralStatus');
	if (obj) obj.onclick=StatusDeleteClickHandler;
	obj=document.getElementById('PAADMRefStatDR');
	obj2=document.getElementById('RSTEntered');
	if ((obj)&& !(obj2)) obj.onblur = RSTTextBlurHandler;
	obj=document.getElementById('weeksWaiting');
	if (obj) obj.onblur = weeksTextBlurHandler;
	obj=document.getElementById('Days');
	if (obj) obj.onblur = daysTextBlurHandler;
	//LOG 31220 BC 7-2-2003 End
	var obj=document.getElementById("HOSPDesc");
	if (obj) obj.onblur=HospBlurHandler;
	var obj=document.getElementById("CTPCPDesc");
	if (obj) obj.onblur=CareProvBlurHandler;
}
document.body.onload = DocumentLoadHandler;

function HospBlurHandler() {
	var obj=document.getElementById("HOSPDesc");
	var objid=document.getElementById("HospitalID");
	if ((obj)&&(objid)&&(obj.value=="")) objid.value="";
}

function HOSPDescLookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("HospitalID");
	if (obj) obj.value=lu[1];
}

function CareProvLookup(str) {
	var lu = str.split("^");
	var obj=document.getElementById("HCADesc");
	if (obj) obj.value=lu[2];
    var obj=document.getElementById("CareProvID");
	if (obj) obj.value=lu[8];
}

function CareProvBlurHandler() {
	var obj=document.getElementById("CTPCPDesc");
	var objid=document.getElementById("CareProvID");
	if ((obj)&&(objid)&&(obj.value=="")) objid.value="";
}

function ClearDateHandler() {
	var eSrc = websys_getSrcElement(e);
	if (eSrc.value!="") {
		obj=document.getElementById("FromDate")
		obj.value=""
		obj=document.getElementById("ToDate")
		obj.value=""
	}
}

function ClearRefDocHandler() {
	var eSrc = websys_getSrcElement(e);
	if (eSrc.value=="") {
		obj=document.getElementById("PAADMRefDocListID")
		obj.value=""
	}
}
function ViewDoctorLookUp(str) {
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("PAADMRefDocListID");
	if (obj) obj.value = lu[4];
	obj=document.getElementById("PAADMRefDocListDR");
	if (obj) obj.value = lu[30];
}

function FindClickHandler(e) {
	var RefStatDR="";
	var exrefdoc="";
	var reftype="";
	var days="";
	var depgroup="";
    var careprov="";
	
	var objRefStatDR=document.getElementById("RSTDescString");
	var objexrefdoc=document.getElementById("PAADMRefDocListID");
	var objreftype=document.getElementById("PAADMReferralType");
	var objdays=document.getElementById("Days");
	var objDG=document.getElementById("DEPDesc");
    var objCP=document.getElementById("CareProvID");

	if ((objRefStatDR)&&(objRefStatDR.value!="")) RefStatDR=String.fromCharCode(1)+objRefStatDR.value+String.fromCharCode(1);
	if (objexrefdoc) exrefdoc=objexrefdoc.value;
	if (objreftype) reftype=objreftype.value;
	if (objdays) days=objdays.value;
	if (objDG) depgroup=objDG.value;
    if (objCP) careprov=objCP.value;

	var objFindParam=document.getElementById("HiddenFindParameters");
	if (objFindParam) objFindParam.value=RefStatDR+"^"+exrefdoc+"^"+reftype+"^"+days+"^"+depgroup+"^"+careprov;
	
	return find1_click();
}

function SelectRowHandler() {
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var row=rowObj.rowIndex;
	if (eSrcAry.length>0) {
		//alert(eSrcAry[0])
		//JW: opens in new window - should not go through workflow
		if (eSrcAry[0]=="refNo") {
			var currentlink=eSrc.href.split("?");
			//alert(currentlink)
			var temp1=currentlink[1].split("&TWKFL")
			var temp2=currentlink[1].split("&ID")
			var url = "paadm.edit.csp" + "?" + temp1[0] + "&ID" + temp2[1];
			//var url = "paadm.edit.csp" + "?" + currentlink[1];
			websys_lu(url,false,"width=700,height=700,left=10,top=10")
			return false;
		}
	}
}

function getRow(eSrc) {
	while(eSrc.tagName != "TR") {
		if (eSrc.tagName == "TH") break;
		eSrc=eSrc.parentElement;
	}
	return eSrc;
}

function setRowClass(rowObj) {
	if (rowObj.rowIndex!=selectedRowObj.rowIndex) {
		rowObj.className='clsRowSelected';
		if (selectedRowObj.rowIndex%2==0 && selectedRowObj.rowIndex>0) {cName="RowEven";} else {cName="RowOdd";}
		selectedRowObj.className=cName;
		selectedRowObj=rowObj;
	}
}

//LOG 31220 BC 7-2-2003 Status list for the search
function StatusDeleteClickHandler() {
	//Delete items from RSTEntered listbox when a "Delete" button is clicked.
	var obj=document.getElementById("RSTEntered")
	if (obj) {
		RemoveFromList(obj);
		UpdateStatus();
	}
	return false;
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

function UpdateStatus() {
	var arrItems = new Array();
	var lst = document.getElementById("RSTEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			var code=lst.options[j].value.split(String.fromCharCode(2));
			//arrItems[j] = lst.options[j].value;
			arrItems[j] = code[1];
			//alert(code[1]);
		}
		var el = document.getElementById("RSTDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
		//alert (el.value);
	}
}

function StatusLookupSelect(txt) {
	//alert("StatusLookupSelect");
	//Add an item to RSTEntered when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	//alert("adata 1="+adata);
	var hobj=document.getElementById("RSTEntered");

	if (hobj) {
		//Need to check if Service already exists in the List and alert the user
		for (var i=0; i<hobj.options.length; i++) {
			if (hobj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Status has already been selected");
				var obj=document.getElementById("PAADMRefStatDR")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (hobj.options[i].text == adata[0])) {
				alert("Status has already been selected");
				var obj=document.getElementById("PAADMRefStatDR")
				if (obj) obj.value="";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	}
	//if (obj) {alert("Object found");}
	if (hobj) AddItemToList(hobj,adata[1],adata[0]);

	var obj=document.getElementById("PAADMRefStatDR");
	if ((obj)&&(hobj)) obj.value="";
	if (hobj) {
		UpdateStatus();
	}else {
		var obj=document.getElementById("RSTDescString");
		if (obj) obj.value=adata[1];
	}
	//var obj=document.getElementById("RSTDescString"); alert(obj.value);
}

function ClearStatusList(){
	//alert("ClearStatusList");
	var el = document.getElementById("PAADMRefStatDR");
	if (el) el.value = "";
	var el = document.getElementById("RSTDescString");
	if (el) el.value = "";
	var obj=document.getElementById("RSTEntered");
	if (obj) {
		for (var i=(obj.length-1); i>=0; i--) {
				obj.options[i]=null;
		}
	}
}

function RSTTextBlurHandler(e) {
	//alert("RSTTextBlurHandler");
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('RSTDescString');
		if (obj) obj.value=""
		//alert("RSTTextBlurHandler2");
	}

}

function weeksTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	/* SB 20/10/03 (39666): Don't clear date fields when entering weeks/days waiting
	if (eSrc.value!="") {
		obj=document.getElementById("FromDate")
		obj.value=""
		obj=document.getElementById("ToDate")
		obj.value=""
	}
	*/
	obj=document.getElementById('Days');
	if (obj) {
		if (eSrc && eSrc.value!="") {
			obj.value=""
			obj.disabled=true
			obj.className="disabledField"
		}else {
			obj.disabled=false
			obj.className=""
		}
	}
}

function daysTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	/* SB 20/10/03 (39666): Don't clear date fields when entering weeks/days waiting
	if (eSrc.value!="") {
		obj=document.getElementById("FromDate")
		obj.value=""
		obj=document.getElementById("ToDate")
		obj.value=""
	}
	*/
	obj=document.getElementById('weeksWaiting');
	if (obj) {
		if (eSrc && eSrc.value!="") {
			obj.value=""
			obj.disabled=true
			obj.className="disabledField"
		}else {
			obj.disabled=false
			obj.className=""
		}
	}
}


//LOG 31220 BC 7-2-2003 End


var frm=document.forms["fPAAdm_ListMultiReferral"];
var tbl=document.getElementById("tPAAdm_ListMultiReferral");

try {if (tbl) tbl.onclick=SelectRowAdm;} catch(e) {}
try {if (tbl) tbl.onKeyPress=SelectRowAdm;} catch(e) {}