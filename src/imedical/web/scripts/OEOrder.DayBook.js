// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var SpecimenCount=1;

/*
function UpdateClick_Handler() {

	//alert("here");
	//return Update_click();
}
*/

function ClickHandler() {
return false;
}

function BodyUnLoadHandler() {	//If there is any mandatory field left unfilled, alert the user and delete the order item from the list.
	var par_win = window.opener;
	if (OrderWindow!="") par_win=window.open('',OrderWindow); //par_win=par_win.top.frames[1];
	var WarnMsg="";
	WarnMsg=CheckForAllMendatoryFields();
	//if (WarnMsg!="") {
	if ((WarnMsg!="")&&(OrderWindow!="")&&(par_win)&&(par_win.document.fOEOrder_Custom)) {
		alert(WarnMsg+"\n"+t['WillDeleteOrder']);
		try{
			var delID="";
			var idobj=document.getElementById("ID");
			if (idobj) {
				delID=idobj.value;
				if ((delID!="")&&(par_win)) {
					//alert("deleted id:"+delID);
					par_win.DeleteOrderByID(delID);
				}
			}
		}catch(e){}
	}
	if (OrderWindow!="") {
		par_win=window.open('',OrderWindow); 
		if ((OrderWindow=="order_entry")&&(par_win)) par_win.DisableUpdateButton(0);	// LOG 38509 RC 3/12/03 Disable Update Button on Order Entry Screen
	}	

	//Go to the details page of the next order item
	if ((par_win)&&(par_win.document.fOEOrder_Custom)) par_win.OrderDetailsShowing(par_win.document.fOEOrder_Custom);

	// JD refresh order list with new values 54852
	if (OrderWindow=="oeorder_entry") {
		try {
			var detailFrame=window.open("","oeorder_entry");
			if (detailFrame) detailFrame.RefreshSessionList();
		} catch(e) {
			//log58506 TedT kill blank window
			detailFrame.close();
		}
	}
	if (document.getElementById('ID')) {var ID=document.getElementById('ID').value;} else {var ID="";}
	var serverupdate=tkMakeServerCall("web.OEOrdItem","LockClear",ID);
}

function CheckForAllMendatoryFields() {
	var AllGetValue="";
	for (var i=0;i<document.fOEOrder_DayBook.elements.length;i++) {
		if (document.fOEOrder_DayBook.elements[i].id!="") {
			var elemid="c"+document.fOEOrder_DayBook.elements[i].id;
			var elemc=document.getElementById(elemid);
			var elem=document.getElementById(document.fOEOrder_DayBook.elements[i].id);
			if ((elemc) && (elemc.className=="clsRequired")) {
				if ((elem)&&(elem.value=="")) AllGetValue=AllGetValue+elemc.innerText+":  "+t['XMISSING']+"\n";
			}
		}
	}
	var dbobj=document.getElementById("AccessionNumber");
	if((dbobj)&&(dbobj.className=='clsInvalid')) {

		AllGetValue=AllGetValue+t['AccessionNumber']+":  "+t['XINVALID']+"\n";
		
	}
	return AllGetValue;
}

function getSelectedListItems(listBox)
{
	var selArr = new Array();
	var count = 0;
	for (var i = 0; i < listBox.length; i++) {
		if (listBox.options[i].selected) {
			//selArr[count] = listBox.options[i].value;
			selArr[count] = listBox.options[i].value;
			//alert(listBox.options[i].value)
			count++;
		}
	}
	return selArr;
}

function getSelectedListItemsDesc(listBox)
{
	var selArr = new Array();
	var count = 0;
	for (var i = 0; i < listBox.length; i++) {
		if (listBox.options[i].selected) {
			//selArr[count] = listBox.options[i].value;
			selArr[count] = listBox.options[i].text;
			//alert(listBox.options[i].value)
			count++;
		}
	}
	return selArr;
}

function LabChangeHandler(){
	var DBobj=document.getElementById("DayBook");
	if (DBobj){
		DBobj.selectedIndex=-1;
	}
	var lst=document.getElementById("SpecimenSelected");
	if (lst) {
		DBobj.selectedIndex=-1;
		SpecimenCount=1;
	}
}

function SpecimenAdd(e) {
	var lst=document.getElementById("SpecimenSelected");
	var DBobj=document.getElementById("DayBook");
	var SpecArray = getSelectedListItemsDesc(DBobj);
	var SpecArrayCode = getSelectedListItems(DBobj);
	for(i=0;i<SpecArray.length;i++)
	{
		var desc=""+SpecimenCount+"."+SpecArray[i];
		//var val=""+SpecimenCount+String.fromCharCode(28)+SpecArray[i];
		//var val=""+SpecimenCount+"|"+SpecArray[i];
		var val=""+SpecimenCount+"|"+SpecArrayCode[i];
		SpecimenCount++;
		if (lst) {
			var k=lst.options.length;
			lst.options[k] = new Option(desc);
			lst.options[k].value=val;
		}
	}
	return false;
}

function DBSiteAdd(site) {
	var lst=document.getElementById("SpecimenSelected");
	if(site) {
	var SpecArray =site.split(String.fromCharCode(8));
	for(i=0;i<SpecArray.length;i++)
	{
		if(SpecArray[i]=="") return false;
		var siteCode=SpecArray[i];
		siteCode=""+SpecimenCount+"|"+siteCode;
		var siteDesc=GetSiteDescFromCode(SpecArray[i]);
		if (siteDesc=="") return false;
		var desc=""+SpecimenCount+"."+siteDesc;
		SpecimenCount++;
		//alert(desc+"*"+siteCode)
		var k=lst.options.length;
		lst.options[k] = new Option(desc);
		lst.options[k].value=siteCode;
	}
	}
	return false;
}

function ReconTestSetCode(str) {
	var lst=document.getElementById("TestSetCode");
	if (lst) {
		while (lst.options.length) lst.options[0] = null;
	}
	lst.options[lst.options.length] = new Option(str);
	lst.options[0].selected=true;
	//alert("Val" + lst.options[0].text);
}

function SpecimenDeleteHandler() {
	var lst=document.getElementById("SpecimenSelected");
	if (lst) {
		for (var i=0;i<lst.length;i++) {
			if (lst.options[i].selected){
				lst.options[i]=null;
				SpecimenCount--;
			}
		}
	}

	for (var i=0;i<lst.length;i++) {
		lst.options[i].text=(i+1) + "." + TrimSpecimen(lst.options[i].text);
	}

	return false;
}

function DisableField(fldName,icN) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.disabled = true;
	}
	if (icN) {
		var objIcon=document.getElementById(icN);
		if (objIcon) objIcon.style.visibility = "hidden";
	}

}

function DisableDBEPRElement() {
	DisableField("DBLaboratory","ld1634iDBLaboratory");
	DisableField("TestSetCode","ld1634iTestSetCode");
	DisableField("DayBook","ld1634iDayBook");
	DisableField("SpecimenSelected","ld1634iSpecimenSelected");
	DisableField("AccessionNumber","ld1634iAccessionNumber");
}

function DisableDBElement() {

DisableField("CareProvider","ld1632iCareProvider");
DisableField("OEORIDate","ld1632iOEORIDate");
DisableField("Delete","ld1632iDelete");
DisableField("CareProvList","ld1632iCareProvList");
DisableField("Doctor","ld1632iDoctor");
DisableField("PortableEquiptRequired","ld1632iPortableEquiptRequired");
DisableField("CTPCPDesc","ld1632iCTPCPDesc");
DisableField("OECPRDesc","ld1632iOECPRDesc");
DisableField("CTLOCDesc","ld1632iCTLOCDesc");
DisableField("OEORIRefDocDR","ld1632iOEORIRefDocDR");
DisableField("TestSetCode","ld1632iTestSetCode");
DisableField("OEORISttDat","ld1632iOEORISttDat");
DisableField("OEORISttTim","ld1632iOEORISttTim");
DisableField("OSTATDesc","ld1632iOSTATDesc");
DisableField("CoveredByMainInsur","ld1632iCoveredByMainInsur");
DisableField("OEORIVarianceReasonDR","ld1632iOEORIVarianceReasonDR");
DisableField("AccessionNumber","ld1634iAccessionNumber");
DisableField("SpecimenAdd","ld1634iSpecimenAdd");
DisableField("ColDate","ld1634iColDate");
DisableField("ColTime","ld1634iColTime");
DisableField("DayBook","ld1634iDayBook");
DisableField("SpecimenSelected","ld1634iSpecimenSelected");
DisableField("SpecimenDelete","ld1634iSpecimenDelete");
DisableField("DBLaboratory","ld1634iDBLaboratory");
DisableField("PatientLoc","ld1634iPatientLoc");
DisableField("TestSetCode","ld1634iTestSetCode");
DisableField("Update","ld1634iUpdate");
}

function TrimSpecimen(str) {
	var pos=str.indexOf(".")
	var len=str.length
	var result=""
	if (pos>=0) result=str.substr((pos+1),len);		
	return result;
}


var obj=document.getElementById("SpecimenAdd");
if (obj) obj.onclick=SpecimenAdd;

var dobj=document.getElementById("SpecimenDelete");
if (dobj) dobj.onclick=SpecimenDeleteHandler;

document.body.onunload = BodyUnLoadHandler;  //log 30710

//var uobj=document.getElementById("Update");
//if (uobj) uobj.onclick=UpdateClick_Handler;