// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var ORIGINAL_TYPE="";
var DateFromReq=DateToReq=TimeFromReq=TimeToReq=0;
var obj=document.getElementById("cDateFrom");
if ((obj)&&(obj.className=="clsRequired")) DateFromReq=1;
var obj=document.getElementById("cDateTo");
if ((obj)&&(obj.className=="clsRequired")) DateToReq=1;
var obj=document.getElementById("cTimeFrom");
if ((obj)&&(obj.className=="clsRequired")) TimeFromReq=1;
var obj=document.getElementById("cTimeTo");
if ((obj)&&(obj.className=="clsRequired")) TimeToReq=1;

function FindClickHandler(e) {
	var objData=document.getElementById("ExtraParams");
	//6-Apr-02: stores ConvertedToInPat^AllCurrentPats^TRANSMDesc^INJUDesc
	var arrData=new Array(23);
	var obj=document.getElementById("ConvertedToInPat");
	if ((obj)&&(obj.checked)) {arrData[0]=1} else {arrData[0]=0}
	var obj=document.getElementById("AllCurrentPats");
	if ((obj)&&(obj.checked)) {arrData[1]=1} else {arrData[1]=0}
	var obj=document.getElementById("TRANSMDesc");
	if (obj) {arrData[2]=obj.value} else {arrData[2]=""}
	var obj=document.getElementById("INJUDesc");
	if (obj) {arrData[3]=obj.value} else {arrData[3]=""}
	var obj=document.getElementById("TempLocIDs");
	if (obj) {arrData[4]=obj.value} else {arrData[4]=""}
	var obj=document.getElementById("PAADMVisitStatus");
	if (obj) {arrData[5]=obj.value} else {arrData[5]=""}
	var obj=document.getElementById("ADSOUDesc");
	if (obj) {arrData[6]=obj.value} else {arrData[6]=""}
	var obj=document.getElementById("ADMETHDesc");
	if (obj) {arrData[7]=obj.value} else {arrData[7]=""}
	var obj=document.getElementById("MediFit");
	if ((obj)&&(obj.checked)) {arrData[8]="Y"} else {arrData[8]="N"}
	var obj=document.getElementById("bedflag");
	if ((obj)&&(obj.checked)) {arrData[9]="Y"} else {arrData[9]="N"}
	var obj=document.getElementById("onLeave");
	if ((obj)&&(obj.checked)) {arrData[10]="Y"} else {arrData[10]="N"}
	var obj=document.getElementById("hospital");
	if (obj) {arrData[11]=obj.value} else {arrData[11]=""}
	var obj=document.getElementById("payor");
	if (obj) {arrData[12]=obj.value} else {arrData[12]=""}
	var obj=document.getElementById("PAADMType");
	if (obj) {arrData[13]=obj.value} else {arrData[13]=""}
	if (arrData[13]=="") {
		var obj=document.getElementById("admType");
		if (obj) {arrData[13]=obj.value} else {arrData[13]=""}
	}
	var obj=document.getElementById("GovCategory");
	if (obj) {arrData[14]=obj.value} else {arrData[14]=""}
	var obj=document.getElementById("MissedDist");
	if ((obj)&&(obj.checked)) {arrData[15]="Y"} else {arrData[15]="N"}
	//md 14.02.2003
	var obj=document.getElementById("DisDateFrom");
	if (obj) {arrData[16]=obj.value} else {arrData[16]=""}
	var obj=document.getElementById("DisDateTo");
	if (obj) {arrData[17]=obj.value} else {arrData[17]=""}
	//md 14.02.2003
	//md 21.02.2003
	var obj=document.getElementById("DisTimeFrom");
	if (obj) {arrData[18]=obj.value} else {arrData[18]=""}
	var obj=document.getElementById("DisTimeTo");
	if (obj) {arrData[19]=obj.value} else {arrData[19]=""}
	var obj=document.getElementById("epspayor");
	if (obj) {arrData[20]=obj.value} else {arrData[20]=""}
	//log49716 TedT
	var obj=document.getElementById("registration");
	if (obj) {arrData[21]=obj.value} else {arrData[21]=""}
	var obj=document.getElementById("notSeen");
	if ((obj)&&(obj.checked)) {arrData[22]="Y"} else {arrData[22]="N"}
	//md 21.02.2003
	objData.value=arrData.join("^");
	//alert(objData.value);
	find1_click();
	return false
}

function AllCurrentPatClickHandler(e) {
	var obj=document.getElementById("AllCurrentPats");
	if ((obj)&&(obj.checked)) {
        DisableField("DateFrom");
        var obj=document.getElementById("DateFrom");
        if (obj) obj.value=" ";
        DisableLookup("ld1143iDateFrom");
		DisableField("DateTo");
        var obj=document.getElementById("DateTo");
        if (obj) obj.value=" ";
        DisableLookup("ld1143iDateTo");
        DisableField("TimeFrom");
        var obj=document.getElementById("TimeFrom");
        if (obj) obj.value=" ";
        DisableField("TimeTo");
        var obj=document.getElementById("TimeTo");
        if (obj) obj.value=" ";
	} else {
		var obj=document.getElementById("DateFrom");
        // ab 23.02.05 - not sure why we were doing this, changed it to revert to the default value
		//if (obj) {obj.disabled=false;obj.className="";obj.value=ResetDate();}
        if (obj) {
            obj.disabled=false;
            obj.className="";
            obj.value=obj.defaultValue;
            // make caption required if it was originally set in the layout
            var objc=document.getElementById("cDateFrom")
            if ((objc)&&(DateFromReq)) objc.className="clsRequired";
            EnableLookup("ld1143iDateFrom");
        }
		var obj=document.getElementById("DateTo");
        if (obj) {
            obj.disabled=false;
            obj.className="";
            obj.value=obj.defaultValue;
            var objc=document.getElementById("cDateTo")
            if ((objc)&&(DateToReq)) objc.className="clsRequired";
            EnableLookup("ld1143iDateTo");
        }
		var obj=document.getElementById("TimeFrom");
        if (obj) {
            obj.disabled=false;
            obj.className="";
            obj.value=obj.defaultValue;
            var objc=document.getElementById("cTimeFrom")
            if ((objc)&&(TimeFromReq)) objc.className="clsRequired";
        }
		var obj=document.getElementById("TimeTo");
        if (obj) {
            obj.disabled=false;
            obj.className="";
            obj.value=obj.defaultValue;
            var objc=document.getElementById("cTimeTo")
            if ((objc)&&(TimeToReq)) objc.className="clsRequired";
        }
	}
}
var obj=document.getElementById("AllCurrentPats");
if (obj) obj.onclick=AllCurrentPatClickHandler;

function ResetDate() {
	var today=new Date();
	return ReWriteDate(today.getDate(),today.getMonth()+1,today.getYear());
}
function ResetTime() {
	var now=new Date();
	return ReWriteTime(now.getHours(),now.getMinutes(),now.getSeconds());
}
function LocationLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById('LocationOfInPat')
	if (obj) obj.value = lu[1]

}

function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	//code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function UpdateTempLocs() {
	//alert("update");
	var arrItems = new Array();
	var lst = document.getElementById("TempLocList");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			arrItems[j] = lst.options[j].value;
		}
		var el = document.getElementById("TempLocIDs");
		if (el) el.value = arrItems.join("|");
		//alert (el);
	}
}


function TempLocDeleteClickHandler() {    
	//Delete items from ALGEntered listbox when a "Delete" button is clicked.
	var obj=document.getElementById("TempLocList")
	if (obj) {
		RemoveFromList(obj);
		UpdateTempLocs();
	}
	return false;
}

function TempLocLookupSelect(txt) {
	//Add an item to TempLocList when an item is selected from
	//the Lookup, then clears the Item text field.	
	var adata=txt.split("^");
	//alert("adata 1="+adata);
	var obj=document.getElementById("TempLocList")

	if (obj) {
		//Need to check if Allergy already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			//if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
			if (obj.options[i].value == adata[1]) {
				alert(t["TempLocSel"]);
				var obj=document.getElementById("temploc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
			alert(t["TempLocSel"]);
				var obj=document.getElementById("temploc")
				if (obj) obj.value="";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("temploc")
	if (obj) obj.value="";
	UpdateTempLocs();
	//alert("adata 2="+adata);
}

function PAADMTypeLookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('admType');
	if (obj) obj.value=lu[2];
}

function PAADMTypeBlurHandler() {
	var obj=document.getElementById('PAADMType');
	var obj2=document.getElementById('admType');
	if ((obj)&&(obj2)&&(obj.value=="")) obj2.value=ORIGINAL_TYPE;
}

function HospBlurHandler() {
	var obj=document.getElementById("hospital");
	var objid=document.getElementById("HospitalID");
	if ((obj)&&(objid)&&(obj.value=="")) objid.value="";
}

function hospitalLookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("HospitalID");
	if (obj) obj.value=lu[1];
}

function BodyLoadHandler() {
	var obj=document.getElementById("find1");
	if (obj) obj.onclick=FindClickHandler;
	obj=document.getElementById('DelTempLoc');
	if (obj) obj.onclick=TempLocDeleteClickHandler;
	obj=document.getElementById('PAADMType');
	if (obj) obj.onblur=PAADMTypeBlurHandler;
	obj=document.getElementById('admType');
	if (obj) ORIGINAL_TYPE=obj.value;
	var obj=document.getElementById("hospital");
	if (obj) obj.onblur=HospBlurHandler;
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;
    AllCurrentPatClickHandler();
}
document.body.onload=BodyLoadHandler;