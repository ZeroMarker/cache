//not used any more, field order may change!!!!
var updated=0;
var DataFields;
var SelectedSpecimens = new Array();
var SelectedSites = new Array();
var SpecDelim = String.fromCharCode(7);
var SiteDelim = String.fromCharCode(8);
var SitesDelim = String.fromCharCode(9);
//var SpecDelim = "@";
//var SiteDelim = "#";
//var SitesDelim = "$";
var Gparam5="";
var Gsdcheckval="Y";
var bSiteDisabled=false;
//var ordwin=window.open("","oeorder_entry");		// LOG 38509 RC 3/12/03 Disable Update Button on Order Entry Screen

//this is to refresh the parent window after modifying, but only if parent screen is not order entry
//if ((document.forms['fOEOrder_Lab'].elements['ID'].value!="")&&(window.opener)&&(!window.opener.document.forms['fOEOrder_Custom'])) {
//	document.forms['fOEOrder_Lab'].elements['refresh'].value=1;
//}

// JPD LOG 52132 26-07-05
function ClinCondLookUp(str) {
	var lu=str.split("^");
	var Code=document.getElementById('ClinCondDR');
	if (Code) Code.value=lu[1];
	var Desc=document.getElementById('ClinCond');
	if (Desc) Desc.value=lu[0];
	return;
}

/*
function LookUpPatOrderSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("PatientOrders")
	if (obj) obj.value = lu[2];
	var obj=document.getElementById("LinkedItmID")
	if (obj) obj.value = lu[3];

}
*/
function UserNameSelectHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("UserName")
	if (obj) obj.innerText = lu[1];

}

function UserCode_changehandler(encmeth) {	//have to have for broker only!!!
	var obj=document.getElementById('UserCode');
	var p1='';
	if (obj) p1=obj.value;
	var obj=document.getElementById('UserCode');
	if (cspRunServerMethod(encmeth,'','UserNameSelectHandler',p1)=='0') {
		obj.className='clsInvalid';  ///generic name to check all fields.
		obj.focus();
		return websys_cancel();
	} else {
		obj.className='';
	}
}

function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
	//return "";
}

function VerifyColRecDateTime() {
	//log63282 TedT if status is Discontinue, dont check
	var stat=document.getElementById("OrdStatCode");
	if (stat && stat.value=="D") return true;
	
	var cd="";
	var ct="";
	var rd="";
	var rt="";


	var cdobj=document.getElementById("ColDate");
	if(cdobj) cd=cdobj.value;

	var ctobj=document.getElementById("ColTime");
	if(ctobj) ct=ctobj.value;

	var rdobj=document.getElementById("ReceivedDate");
	if(rdobj) rd=rdobj.value;

	var rtobj=document.getElementById("ReceivedTime");
	if(rtobj) rt=rtobj.value;

	var CDate ="";
	var RDate ="";

	if(rd=="" && rt!=""){
		alert(t['RECEIVE_DATETIME']);
		return false;
	}

	if(rd!=""){

		if(cd=="" || ct=="" || rt=="")
		{
			alert(t['RECEIVE_DATETIME']);
			return false;
		}

		else{
			var CdateArr = cd.split(dtseparator);
			var RdateArr = rd.split(dtseparator);
			var CtimeArr = ct.split(":");
			var RtimeArr = rt.split(":");

			if(dtformat=="YMD")
			{
				CDate = new Date(CdateArr[0],CdateArr[1],CdateArr[2],CtimeArr[0],CtimeArr[1]);
				RDate = new Date(RdateArr[0],RdateArr[1],RdateArr[2],RtimeArr[0],RtimeArr[1]);
			}

			else if(dtformat=="MDY")
			{
				CDate = new Date(CdateArr[2],CdateArr[0],CdateArr[1],CtimeArr[0],CtimeArr[1]);
				RDate = new Date(RdateArr[2],RdateArr[0],RdateArr[1],RtimeArr[0],RtimeArr[1]);
			}

			else
			{
				CDate = new Date(CdateArr[2],CdateArr[1],CdateArr[0],CtimeArr[0],CtimeArr[1]);
				RDate = new Date(RdateArr[2],RdateArr[1],RdateArr[0],RtimeArr[0],RtimeArr[1]);
			}


		}

		if (CDate>RDate){
			alert(t['INVALID_COLDATE']);
			return false;
		}

	}
}

function UpdateFromOrderEntry() { //new order
	var par_win = window.opener;
	//if ((par_win.name=="TRAK_hidden")&&(window.opener)) par_win=window.opener.parent.frames['TRAK_main'].websys_windows['frmOSList'];

	var f = document.forms['fOEOrder_Lab'];
	if (par_win) {
		//var strData1 = par_win.TransferDataMain(f);
		//var strData2 = par_win.TransferDataSub(f);
		var strData1 = TransferDataMain(f);
		var strData2 = TransferDataSub(f);
		//strData2="%01"+strData2;
		var strData=strData1 + strData2;
		//alert(strData);
		//par_win.CollectedFields(escape(strData));
		//log59415 tedt dont need to escape strData again here, was already escaped in TransferData fn
		par_win.CollectedFields(strData);
	}

	window.close();
	return Update_click();
}

/*
function UpdateFromOrderEntry() {
	var par_win = window.opener;
	if (par_win.name=="TRAK_hidden") {
		par_win=window.opener.parent.frames['TRAK_main'].websys_windows['frmOSList'];
		if (par_win==null) par_win=window.opener.parent.frames['TRAK_main'];
	}

	var f = document.forms['fOEOrder_Lab'];
	//var strData1 = par_win.TransferDataMain(f);
	//var strData2 = par_win.TransferDataSub(f);
	var strData1 = TransferDataMain(f);
	var strData2 = TransferDataSub(f);
	//strData2="%01"+strData2;
	var strData=strData1 + strData2;
	//alert((strData));
	try { par_win.CollectedFields(strData);}
	catch(e) {};
	window.close();
	return Update_click();
}*/

function getSelectedListItems(listBox)
{
	var selArr = new Array();
	var count = 0;
	for (var i = 0; i < listBox.length; i++) {
		//if ((listBox.options[i].selected)||((listBox.disabled==true)&&(listBox.options[i].style.backgroundColor=="black"))) {
		if (listBox.options[i].selected) {
			selArr[count] = listBox.options[i].value;
			count++;
		}
	}
	return selArr;
}

function getSelectedListItemsValText(listBox)
{
	var selArr = new Array();
	var count = 0;
	for (var i = 0; i < listBox.length; i++) {
		//if ((listBox.options[i].selected)||((listBox.disabled==true)&&(listBox.options[i].style.backgroundColor=="black"))) {
		if (listBox.options[i].selected) {
			selArr[count] = listBox.options[i].value+String.fromCharCode(1)+"Y"+String.fromCharCode(1)+listBox.options[i].text+String.fromCharCode(2);
			count++;
		}
	}
	return selArr;
}

function getSelectedListItemsValue(listBox)
{
	var selArr = new Array();
	var count = 0;
	for (var i = 0; i < listBox.length; i++) {
		//if ((listBox.options[i].selected)||((listBox.disabled==true)&&(listBox.options[i].style.backgroundColor=="black"))) {
		if (listBox.options[i].selected) {
			selArr[count] = listBox.options[i].value;
			count++;
		}
	}
	return selArr;
}
function InvalidFields() {
	var invalid=false;
	//common fields
	if(!isInvalid("PatientLoc")&&(!invalid)) {
		alert(t['PatientLoc']+":  "+t['XINVALID']);
		invalid=true;
	}


	if(!isInvalid("OECPRDesc")&&(!invalid)) {
		alert(t['OECPRDesc']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("OSTATDesc")&&(!invalid)) {
		alert(t['OSTATDesc']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("CTLOCDesc")&&(!invalid)) {
		alert(t['CTLOCDesc']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("Doctor")&&(!invalid)) {
		alert(t['Doctor']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("OEORIRefDocDR")&&(!invalid)) {
		alert(t['OEORIRefDocDR']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("OEORIVarianceReasonDR")&&(!invalid)) {
		alert(t['OEORIVarianceReasonDR']+":  "+t['XINVALID']);
		invalid=true;
	}
	//end of common fields

	if(!isInvalid("OEORILabEpisodeNo")&&(!invalid)) {
		alert(t['OEORILabEpisodeNo']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("PHCFRDesc1")&&(!invalid)) {
		alert(t['PHCFRDesc1']+":  "+t['XINVALID']);
		invalid=true;
	}

	if(!isInvalid("PHCDUDesc1")&&(!invalid)) {
		alert(t['PHCDUDesc1']+":  "+t['XINVALID']);
		invalid=true;
	}

	var Nobj=document.getElementById("NotifyClinician");
	var Pobj=document.getElementById("PrefConMethod");

	if((Nobj)&&(Nobj.checked)&&(Pobj)&&(Pobj.value=="")) {
		alert(t['SELECT_CONMETHD']);
		invalid=true;
	}

	return invalid;
}
function PriorityCheck(){  // log 37530 RC Add functionality from 33403
}
/*
// NO LONGER NEEDED 56496
function PriorityFill(str) {
	var lu=str.split("^");
	 var PriorityObj=document.getElementById("OECPRCode");
	if (PriorityObj) { PriorityObj.value=lu[2]; }
}
*/
function ValidDateTimeForDischargeEpis() {
		var sobj=document.getElementById("OEORISttDat");
		var AOOERobj=document.getElementById("AllowOrderOutEpisRange");
		var IDobj=document.getElementById("ID");
 		if (sobj && (sobj.value!="")) {
			var dobj=document.getElementById("DischDate");
			var aobj=document.getElementById("AdmDate");
			var atime,dtime,stime=""
			var atobj=document.getElementById("AdmTime");
			if ((atobj)&&(atobj.value!="")) atime=atobj.value;
			var dtobj=document.getElementById("DischTime");
			if ((dtobj)&&(dtobj.value!="")) dtime=dtobj.value;
			var stobj=document.getElementById("OEORISttTim");
			if ((stobj)&&(stobj.value!="")) stime=stobj.value;
			if ((!stobj)||((stobj)&&(stobj.value==""))) {
				var htobj=document.getElementById("hidCurrTime");
				if ((htobj)&&(htobj.value!="")) stime=htobj.value;
			}

			if (dobj && (dobj.value!="") && aobj && (aobj.value!="")){
                               	var enteredDate = new Date();
				var enteredDate1 = new Date();
				var enteredDate2 = new Date();
				var enteredDate = VerifyDateformat(dobj,dtime);
				var enteredDate1 = VerifyDateformat(sobj,stime);
				var enteredDate2 = VerifyDateformat(aobj,atime);
				//alert(enteredDate1+" - "+enteredDate);
				if ((enteredDate1>enteredDate) && (AOOERobj) && (AOOERobj.value!="Y")) {
					alert(t['STARTDATE_OUT']+" "+aobj.value+" to " + dobj.value);
					sobj.value=""
					if(stobj) stobj.value="";
					return false;
				}
				else if((enteredDate1<enteredDate2) && (AOOERobj) && (AOOERobj.value!="Y")) {
					alert(t['STARTDATE_OUT']+" "+aobj.value+" to " + dobj.value);
					sobj.value=""
					if(stobj) stobj.value="";
					return false;
				}
				Updated=1; //log
				if((IDobj)&&(IDobj.value=="")) UpdateFromEPR(); //UpdateFromOrderEntry();
				else {checkDateForEPR();}
			}

			else{
				var enteredDate1 = new Date();
				var enteredDate2 = new Date();
				var enteredDate1 = VerifyDateformat(sobj,stime);
				var enteredDate2 = VerifyDateformat(aobj,atime);

				if ((enteredDate1<enteredDate2) && (AOOERobj) && (AOOERobj.value!="Y")) {
					alert(t['STARTDATE_EXCEED']+" "+aobj.value);
					sobj.value=""
					return false;
				}
				Updated=1;
				if((IDobj)&&(IDobj.value=="")) UpdateFromEPR(); //UpdateFromOrderEntry();
				else {checkDateForEPR();}
			}

		}
		//UpdateFromOrderEntry();
}
function UpdateSaveDefaultsClickHandler() {
	//alert("savedef");
	var SaveDefObj=document.getElementById("SaveDefaults");
	if (SaveDefObj) SaveDefObj.value="Y";
	//if (SaveDefObj) alert(SaveDefObj.value);
	UpdateClickHandler();
	//return Update_click();

}

function UpdateClickHandler() {
	if (InvalidFields()==true) {
		return false;
	}

	var WarnMsg="";
	WarnMsg=CheckForAllMendatoryFields();
	if (WarnMsg!="") {
		alert(WarnMsg);
		return false;
	}

	//Log 58325 BoC, check pregnant and breastfeeding, required functions are in OEOrder.Common.js
	PregnBrFdCheck();
	
	//log63282 TedT if status is Discontinue, dont check
	var stat=document.getElementById("OrdStatCode");
	if (stat) stat=(stat.value!="D");
	
	var Qobj=document.getElementById("OEORIQty");
	if((Qobj)&&(Qobj.value!="")) {
		var DQobj=document.getElementById("defQtyRange");
		if (!CheckQtyRange(Qobj)) {
			return false;
		}
	}

	if(!UpdateStatusCheck()) return false;
	var check=VerifyColRecDateTime();
	if (check==false) return false;
	var ssobj=document.getElementById("SpecSites");
	var Siteobj=document.getElementById("Site");
	var setselOBJ=document.getElementById("specSel");
	var Specimenobj=document.getElementById("TestSetCode");
	if (CreateOneOrderPerSpecFlag=="Y") {

	}

	PriorityCheck(); //LOG 37530 RC Add functionality from 33403
	var par_win = window.opener;
	if (OrderWindow!="") {
		par_win=window.open('',OrderWindow); 
		if ((OrderWindow=="order_entry")&&(par_win)) par_win.DisableUpdateButton(0);	// LOG 38509 RC 3/12/03 Disable Update Button on Order Entry Screen
	}	
	if(Specimenobj && Siteobj && ssobj &&setselOBJ)
	{
		//get the selected specimens
		var SpecArray = getSelectedListItems(Specimenobj);
		//alert("Specimen length: "+SpecArray.length);
		if ((CreateOneOrderPerSpecFlag=="Y")&&(SpecArray.length>1) && stat) {
			alert(t['Select_OneSpecimen']);
			return;
		}
		if (SpecArray.length<1 && stat) {
			alert(t['NoSpecimen_Selected']);
			return;
		}

		if (Specimenobj.disabled!=true) {
		ssobj.value=""; setselOBJ.value="";
		if (SpecArray.length > 1){
			var tsel="";
			var SpecArray1 = getSelectedListItems(Specimenobj);
			for(i=0; i<SpecArray1.length; i++)
			{
				ssobj.value = ssobj.value+ SpecArray[i] + SpecDelim + SitesDelim;
				//ssobj.value = ssobj.value+ SpecArray[i] + String.fromCharCode(4);
			}
		}
		else{
			if(SpecArray.length == 1){
				//alert("only one specimen");
				//get the selected sites
				//denise
				//alert("Siteobj: "+Siteobj.value);
				var SiteArray = getSelectedListItemsValue(Siteobj);
				ssobj.value = ssobj.value + SpecArray[0] + SpecDelim;
				if (SiteArray.length > 0){
					for(i=0; i<SiteArray.length; i++)
					{
						//PeterC took out .value from SiteArray[i].value because it was causing an undefined error
						ssobj.value = ssobj.value + SiteArray[i] + SiteDelim;
					}
				}

				ssobj.value = ssobj.value + SitesDelim;
			}
		}
		}
	}
	ValidDateTimeForDischargeEpis();
	//Log 46424 Add Order Group Number 
	var ID="";
	var objID=document.getElementById("ID");
	if (objID) ID=objID.value;
	var OrderGroupNumber="";
	var objOrderGroupNumber=document.getElementById("OEORIItemGroup");
	if (objOrderGroupNumber) {
		OrderGroupNumber=ID+"^"+objOrderGroupNumber.value;
		try {
			if (par_win) par_win.ChangeOrderGroupNumber(OrderGroupNumber);
		}catch(e){}
	}
	
	//log 63282 TedT commented out the timeout because it stops epr page from refreshing, moved the function call to button
	//setTimeout ("refreshParent()",500);
	
	Updated=1;
	if (OrderWindow=="ORDERFAVPANEL") {
		//alert("orderfav");
		UpdateFromEPR();

	}
	var win=window.opener.parent.frames[1];
	if (win) {
		var formICP=win.document.forms['fMRClinicalPathways_ItemList'];
		var formICP2=win.document.forms['fMRClinicalPathways_CarePlanItemList'];
		if (formICP||formICP2) {
			//alert();
			UpdateFromOrderEntry();
		}
	}
	//log 63282 TedT
	refreshParent();
}

function refreshParent() {
	if ((window.opener.parent.document.forms['fOEOrdItem_LabSpecimenCollection'])||(window.opener.parent.document.forms['fEPVisitNumber_ListNonExecutedOrders'])) {
		window.opener.treload('websys.csp');
	} else if (window.opener) { //JPD changed 56447
		//should be from epr chart csp page
		var formCust=window.opener.document.forms['fOEOrder_Custom'];
		var formICP=window.opener.document.forms['fMRClinicalPathways_ItemList'];
		var formOSL=window.opener.document.forms['fOEOrder_OSItemList'];
		var formICP2=window.opener.document.forms['fMRClinicalPathways_CarePlanItemList'];
		//if(!formCust && !formOSL && !formICP && !formICP2) window.opener.history.go(0); //log 63299 refresh done in websys.close
		if (formOSL) {
			var FormArray=formOSL.RebuiltString.value.split("^");
			for (var i=0; i<FormArray.length; i++) {
				var FormStr=FormArray[i];
				var SetOrdIDArr=FormStr.split("*");
				var SetOrdID=SetOrdIDArr[1];
				var OrdID=document.getElementById("ID").value;
				if (OrdID==SetOrdID) {
					var Qty1=document.getElementById("OEORIQty");
					if (Qty1) {
						if (Qty1.value=="") Qty1.value="1";
						if (formOSL.document.getElementById("Quantityz"+(i+1))) formOSL.document.getElementById("Quantityz"+(i+1)).value=Qty1.value;
					}
				}
			}
		}
	}
//	} else {
//		if (window.opener) {
//			//should be from epr chart csp page
//			window.opener.history.go(0);
//		}
//	}
}
function DisableElement(el) {
	//Log 60455 Bo 07-08-2006: if the field is "readOnly=true" already, don't set it to be "disabled=true" again.
	if (el.readOnly==false) el.disabled = true;
}
function SpecimenChangeHandler(){
	var total = 0;
	var Specimenobj=document.getElementById("TestSetCode");
	var Siteobj=document.getElementById("Site");
	if(Specimenobj){
		for (var i = 0; i < Specimenobj.length; i++) {
			if (Specimenobj.options[i].selected) {
				total = total + 1;
			}
		}
	}
	if(total != 1 && Siteobj)
	{
		//JPD 52931
		//Siteobj.disabled=true;
		for (var i = 0; i < Siteobj.length; i++) {
			if (Siteobj.options[i].selected) {
				Siteobj.options[i].selected = false;
			}
		}
	}
	else
		//Log 46074
		if ((Siteobj)&&(!bSiteDisabled)) Siteobj.disabled=false;

	//JPD 54225
	GetLTSitesBySpec(); //commented out for patching 09/11/05
	return false;
}

function SiteChangeHandler(){

}

function ExtractSpecSites(Specimenobj){
	//alert("specimen: "+Specimenobj.value);
	//see if we have more then one specimen which is delimted by charcode(7)
	if(Specimenobj.value.indexOf(SpecDelim) != Specimenobj.value.lastIndexOf(SpecDelim)){
		//alert("More than one specimens")
		SelectedSpecimens = Specimenobj.value.split(SpecDelim);
	}
	else{
		Specimenobj.value=SitesDelim+""+Specimenobj.value;
		//alert("One specimens: "+Specimenobj.value)
		var specsite = Specimenobj.value.substr(Specimenobj.value.indexOf(SitesDelim));
		//SelectedSpecimens[0] = specsite.substr(0,specsite.indexOf(SpecDelim));
		SelectedSpecimens[0] = specsite.substr(1,specsite.indexOf(SpecDelim)-1);
		var sites = specsite.substr(specsite.indexOf(SpecDelim)+1,specsite.length);
		//alert("extract sites="+sites);
		SelectedSites = sites.split(SiteDelim);
	}
}


//Log # 29236 ; Amin ; 01/NOV/2002 When Specimen collected field ticked can only modify  Order Notes, Processing Notes
//log 30570: 1-Oct-2003 enable care provider to notify (flds 'CareProvider' and 'CareProvList') as well
function DisableAllButTwo(eForm,mode){
    var iNumElems = eForm.elements.length;     //for only form elements.
    //log 61154 TedT
	var enabledfldnames="";
	var readonlyfldnames="";
	if(mode=="PARTIALREAD"){
		enabledfldnames = ",OEORIRemarks,OEORIDepProcNotes,OECPRDesc,UserCode,PIN,CareProvider,CareProvList,";
		//log 59208 TedT if site is using external labtrak, allow collection time to be changed
		if(ExtLabFlag=="Y") enabledfldnames+="SpecCollected,ColDate,ColTime,ReceivedDate,ReceivedTime,"
		readonlyfldnames = ",OSTATDesc,";
	}
    for (var i=0; i<iNumElems; i++)  {
        var eElem = eForm.elements[i];
        //if ( (eElem.name != 'OEORIRemarks') && (eElem.name != 'OEORIDepProcNotes') && (eElem.name != 'OECPRDesc') && (eElem.name != 'UserCode') && (eElem.name != 'PIN')) {
        //Log 60455 Bo 07-08-2006: if the field is "readOnly=true" already, don't set it to be "disabled=true" again.
		if ((enabledfldnames.indexOf(","+eElem.name+",")==-1)&&(eElem.type!="hidden")&&(readonlyfldnames.indexOf(","+eElem.name+",")==-1)&&(eElem.readOnly==false)) {
            if (("hidden" != eElem.type)&&("INPUT" == eElem.tagName) || ("TEXTAREA" == eElem.tagName)) {
                eElem.disabled = true;
                var img=document.getElementById("ld159i"+eElem.id); //to hid the images for the brokers.
                //if (img) img.onclick="";
                if (img) { img.style.visibility="hidden"; }
            } else if ("SELECT" == eElem.tagName) {
                var cOpts = eElem.options;
                var iNumOpts = cOpts.length;
                for (var j=0; j<iNumOpts; j++) {
                    var eOpt = cOpts[j];
                    eOpt.disabled = true;
                }
            }
	}
    }
}

//  function written to call csp which will populate site box
//  from labtrak anatomical sites based on selected specimen
//  JPD LOG 54225
function GetLTSitesBySpec(){
	var Specimenobj=document.getElementById("TestSetCode");
	var Siteobj=document.getElementById("Site");
	if(Specimenobj && Siteobj && ExtLabFlag=="N") {
		clearsites();
		var SpecArray = getSelectedListItems(Specimenobj);
		if(SpecArray.length == 1){
			var url="oeorder.getlabtraksites.csp?WINNAME="+window.name+"&SpecCode="+SpecArray[0];
			websys_createWindow(url,"TRAK_hidden");
			setTimeout("setsitesfromlabtrak()",1800);
		}
	}	
	return false;
}
function setsitesfromlabtrak() {
	var ssobj=document.getElementById("SpecSites");
	if (ssobj) {
		clearsites();
		AddSiteToList(ssobj.value);
	}
	return false;
}
function clearsites() {
	var Siteobj=document.getElementById("Site");
	if (Siteobj) Siteobj.length=0;
	return false;
}

function BodyLoadHandler() {
	//alert("sites: "+sites);
	//alert("specs: "+specs);
	//self.resizeTo(750, 550);
	//window.moveTo(5, 1)
	//Log 46074
	var Siteobj=document.getElementById("Site");
	if ((Siteobj)&&(Siteobj.disabled)) {bSiteDisabled=true; }
	
	//LOG 52931 JPD
	if (Siteobj) Siteobj.disabled=false;
	var Specobj=document.getElementById("TestSetCode");
	if (Specobj) Specobj.disabled=false;

	// ANA LOG 27959 If there is a default Status against the Layout,then do not use the default coming from Mainloop.
	// This change is made to all details screens.
	var tempstOBJ=document.getElementById("tempOSTATDesc");
	var statOBJ=document.getElementById("OSTATDesc");
	if (statOBJ&&statOBJ.value==""&&tempstOBJ) statOBJ.value=tempstOBJ.value;
	var sobj=document.getElementById("OSTATDesc");
	var bfobj=document.getElementById("BilledFlag");
	if (bfobj) {
		if (bfobj.value=="TR"||bfobj.value=="R") {
			if (sobj) sobj.disabled=true;
		}
	}

	var SpecColObj=document.getElementById("SpecCollected");
	if (SpecColObj) SpecColObj.onclick=SpecColCheck;

	var RecDateObj=document.getElementById("ReceivedDate");
	if (RecDateObj) RecDateObj.onblur=ActivateSpecCol;

	var ColDateobj=document.getElementById("ColDate");
	var ColTimeobj=document.getElementById("ColTime");

	//log 59208 TedT update collection date and time
	if(ColDateobj) ColDateobj.onblur=UpdateCollectionDateTime;
	if(ColTimeobj) ColTimeobj.onblur=UpdateCollectionDateTime;
	
	if (ColDateobj && ColDateobj.value!="") {
		if (SpecColObj)	SpecColObj.checked=true;
	}

	var RecTimeObj=document.getElementById("ReceivedTime");	
	var dateon=document.getElementById("datetimeonpage");
	if (dateon) {
		if (!RecDateObj) dateon.value=dateon.value+"^"+"RecDate";
		if (!RecTimeObj) dateon.value=dateon.value+"^"+"RecTime";
		if (!ColDateobj) dateon.value=dateon.value+"^"+"ColDate";
		if (!ColDateobj) dateon.value=dateon.value+"^"+"ColTime";
	}

	var par_win = window.opener;
	if (OrderWindow!="") {
		par_win=window.open('',OrderWindow); 
		if ((OrderWindow=="order_entry")&&(par_win)) par_win.DisableUpdateButton(1);	// LOG 38509 RC 3/12/03 Disable Update Button on Order Entry Screen
	}	

	//LOG 35170 RC 13/06/03 Require 3 htm links on order details screens
	var patOrdFile1=document.getElementById("patOrdFile1");
	var patOrdFile2=document.getElementById("patOrdFile2");
	var patOrdFile3=document.getElementById("patOrdFile3");
	var PatientOrderFile1=document.getElementById("PatientOrderFile1");
	var PatientOrderFile2=document.getElementById("PatientOrderFile2");
	var PatientOrderFile3=document.getElementById("PatientOrderFile3");

	if ((patOrdFile1)&&(PatientOrderFile1)) {
		if (patOrdFile1.value=="") {
			PatientOrderFile1.disabled=true;
			PatientOrderFile1.onclick=NoLink;
		} else {
			PatientOrderFile1.onclick=OpenWindow1;
		}
	}
	if ((patOrdFile2)&&(PatientOrderFile2)) {
		if (patOrdFile2.value=="") {
			PatientOrderFile2.disabled=true;
			PatientOrderFile2.onclick=NoLink;
		} else {
			PatientOrderFile2.onclick=OpenWindow2;
		}
	}
	if ((patOrdFile3)&&(PatientOrderFile3)) {
		if (patOrdFile3.value=="") {
			PatientOrderFile3.disabled=true;
			PatientOrderFile3.onclick=NoLink;
		} else {
			PatientOrderFile3.onclick=OpenWindow3;
		}
	}

	var UpdateSaveObj=document.getElementById("UpdateSaveDefaults");
	if (UpdateSaveObj) UpdateSaveObj.onclick = UpdateSaveDefaultsDelayOnUpdate;	//update link
	if (tsc['UpdateSaveDefaults']) {
		websys_sckeys[tsc['UpdateSaveDefaults']]=UpdateSaveDefaultsDelayOnUpdate;
	}

	var UpdateObj = document.getElementById("Update");
	if (UpdateObj) UpdateObj.onclick = DelayOnUpdate;	//update link
	if (tsc['Update']) {
		websys_sckeys[tsc['Update']]=DelayOnUpdate;
	}
	var PatProObj = document.getElementById("PatOrderProfile");
	if (PatProObj) PatProObj.onclick = PatientOrderProfile;
	obj=document.getElementById("Delete");
	if (obj) obj.onclick=DeleteClickHandler;
	LoadCareProviders();
	LoadRefDoctor();
	var obj=document.getElementById("DeleteRef");
	if (obj) obj.onclick=DeleteRefClickHandler;
	var ssobj=document.getElementById("SpecSites");
	//alert("SpecSites " + ssobj.value);
	if (ssobj)
		//ExtractSpecSites(ssobj);
	var specSelOBJ=document.getElementById("specSel");
	//alert("selectedsites"+specSelOBJ.value);
	if ((specSelOBJ)&&(specSelOBJ.value!=""))	{
		//denise
		//SetSelectedSpecimensValue(specSelOBJ.value);
		ExtractSpecSites(specSelOBJ);
	}
	var Specimenobj=document.getElementById("TestSetCode");
	if(Specimenobj)
		Specimenobj.onchange=SpecimenChangeHandler;

	var sobj=document.getElementById("OSTATDesc");
	var scodeobj=document.getElementById("OrdStatCode");
	if (scodeobj) {
		//alert(scodeobj.value);
		if(scodeobj.value=="E") {
			//DisableElement(sobj);
			MakeFieldReadonly("OSTATDesc","ld159iOSTATDesc");
		}
	}

	//var obj=document.getElementById('TestSetCode');
	var orderidobj=document.forms['fOEOrder_Lab'].elements['ID'];
	if (orderidobj) {
		var specimens=SelectedSpecimens.join("^");
		//Log 48858 PeterC 22/04/05: Commented out the below if condition so that specs shows up on fav.
		//if (orderidobj.value!="") {
			//alert(SelectedSites.join('^'));
			AddSpecToList(specs,tsetSelected);
			if (document.getElementById("LTAnoSites")) {var LTAnoSites=document.getElementById("LTAnoSites").value} else {var LTAnoSites=""};
			//Log 57634 PeterC 28/12/05: Modified the restrictions below so that the site would show correctly.
			if ((ExtLabFlag=="Y") && ((SelectedSites!="") || (sites!=""))) { // || (deflab=="") *comment out deflab condition to retain my sanity.
				AddSiteToList(sites);
			} else if (ExtLabFlag=="N") { //LOG 54225
				clearsites(); 
				AddSiteToList(LTAnoSites);
				//if (SelectedSites!="") SetSelectedLabTrakSites(SelectedSites.join('^'));
				//GetLTSitesBySpec(); 	
				if (SelectedSites!="") setTimeout("SetSelectedLabTrakSites(SelectedSites.join('^'))",1000);
			//} else if (SelectedSites=="" && ExtLabFlag=="N") {
			//	clearsites(); 		
			//	GetLTSitesBySpec(); 	
			}
			if ((ExtLabFlag=="Y") || (deflab=="")) SetSelectedSites(SelectedSites.join("^"));
		//}
	}
	
	var obj=document.getElementById("OEORIRefDocDR");
	//alert(obj);
	//if (obj) obj.onkeydown=REFDDesc_lookuphandlerCustom;
	//var obj=document.getElementById("ld159iOEORIRefDocDR");
	//if (obj) obj.onclick=REFDDesc_lookuphandlerCustom;

	var qobj=document.getElementById("Questionnaire");
	if (qobj) qobj.onclick=QuestionnaireClickHandler;
	HideField();
	var iobj=document.fOEOrder_Lab.ID;
	var Labtestobj=document.getElementById("OEORILabTestSetRow");
	var frm=document.fOEOrder_Lab;
	var StatCode="";
	var ostcodeobj=document.getElementById("OriginalOrdStatCode");
	if (ostcodeobj) StatCode=ostcodeobj.value;
	//alert ("OEORILabTestSetRow = "+Labtestobj.value);

	var modeobj=document.getElementById("Mode");
	if ((modeobj)&&(modeobj.value=="READONLY"||modeobj.value=="PARTIALREAD")) 
		DisableAllButTwo(frm,modeobj.value); //log61154 TedT

	if ((Labtestobj) && (Labtestobj.value !="")) { //if has info in OEORILabTestSetRow you can't edit that page.
		if (StatCode!="I") DisableAllButTwo(frm,"PARTIALREAD");
	}else{
		if ((iobj) && (iobj.value!="")) {
			if ((SpecColObj)&&(SpecColObj.checked==true))  {

				if (StatCode!="I") DisableAllButTwo(frm,"PARTIALREAD");		  //Log # 29236 ; Amin ; 01/NOV/2002 When Specimen collected field ticked can only modify  CareProvider, Order Notes, Processing Notes
			}else{
			  // Log 57817
			  //EnableFields();
			}
		} else {
			SpecColCheck();
		}
	}
	//SpecimenChangeHandler();

	var NCobj=document.getElementById("NotifyClinician");
	if (NCobj) NCobj.onclick=NotifyClinicianChangeHandler;

	//Log 46700
	var SummaryFlag="";
	var objSF=document.getElementById("SummaryFlag");
	if ((objSF)&&(objSF.value!="")) SummaryFlag=objSF.value;
	if (OrderWindow=="oeorder_entry") {
		var hosobj=document.getElementById("hiddenOrderStatus");
		var hpsobj=document.getElementById("hiddenPendingStatus");
		var sobj=document.getElementById("OSTATDesc");
		if (sobj) {
			if ((hpsobj)&&(hpsobj.value!="")) {
				sobj.value=hpsobj.value;
				sobj.innerText=hpsobj.value;
			}
			else if ((sobj.value=="")&&(hosobj)&&(hosobj.value!="")) {
				sobj.value=hosobj.value;
				sobj.innerText=hosobj.value;
			}
		}
	}else if (SummaryFlag!="") {
		var hosobj=document.getElementById("hiddenOrderStatus");
		var hpsobj=document.getElementById("hiddenPendingStatus");
		var sobj=document.getElementById("OSTATDesc");
		if (sobj) {
			if ((hpsobj)&&(hpsobj.value!="")) {
				sobj.value=hpsobj.value;
				sobj.innerText=hpsobj.value;
			}
			else if ((hosobj)&&(hosobj.value!="")) {
				sobj.value=hosobj.value;
				sobj.innerText=hosobj.value;
			}
		}
	}else {
		var hosobj=document.getElementById("hiddenOrderStatus");
		var sobj=document.getElementById("OSTATDesc");
		if (sobj) {
			 if ((hosobj)&&(hosobj.value!="")) {
			 	sobj.value=hosobj.value;
				sobj.innerText=hosobj.value;
			}
		}
	}

	InitStatusCheck("ld159iOSTATDesc");
	var ssobj=document.getElementById("InsertedSpecSites");
	//alert(ssobj.value);
	var idobj=document.getElementById("ID");
	if ((idobj)&&(idobj.value!=null)) {
		if ((ssobj)&&(ssobj.value!=null)) SelectSpecSites(ssobj.value);
	}

	//Log 50948 PeterC 10/03/05
	if (document.getElementById("CareProvList")) {document.getElementById("CareProvList").tkItemPopulate=1;}
	if (document.getElementById("RefDoctorList")) {document.getElementById("RefDoctorList").tkItemPopulate=1;}
	
	//alert(tsetSelected);
	//var OEORILabEpisodeNo=document.getElementById("OEORILabEpisodeNo");
	//if (OEORILabEpisodeNo&&(OEORILabEpisodeNo.value!="")&&(OEORILabEpisodeNo.disabled)) SetSelectedSpecimensValueOrderEntry(tsetSelected);
	
	var objboldlnk=document.getElementById("BoldLinks");
	var objalertmess=document.getElementById("OEOrdAlertMessage");
	if (objboldlnk && objalertmess && objboldlnk.value=="1") objalertmess.style.fontWeight="bold"	
	
	//Disable Clinical Condition for patients not pregnant
	var PregFlag=document.getElementById('HidPregFlag');
	if (PregFlag && (PregFlag.value!="on")) {
		var obj=document.getElementById('ClinCond');
		if (obj) {
			obj.value="";
			obj.disabled=true;
			var obj=document.getElementById('ld159iClinCond');
			if (obj) obj.disabled=true;
		}
		var obj=document.getElementById('ClinCondDR');
		if (obj) obj.value="";
	}
	window.focus();  // 65197
}

function UpdateSaveDefaultsDelayOnUpdate(){
	setTimeout("UpdateSaveDefaultsClickHandler()",1000);
	return false;
}

function DelayOnUpdate(){
	setTimeout("UpdateClickHandler()",1000);
	return false;
}

function SelectSpecSites(insertedSites) {
	var insertedSiteAry=insertedSites.split("^");
	var lst=document.getElementById("Site");
	if (lst) {
		lst.selectedIndex=-1;
		for (var j=0; j<lst.length; j++) {
			if ((lst.options[j].value!=null)&&(lst.options[j].value!="")) {
				for (var i=0; i<insertedSiteAry.length; i++) {
					//alert(lst.options[j].value+" - "+mPiece(insertedSiteAry[0],"*",0));
					//SB 6/6/05 (52911): Original code: mPiece(insertedSiteAry[0],"*",i)
					if (lst.options[j].value==mPiece(insertedSiteAry[i],"*",0)) lst.options[j].selected = true;
				}
				
			}
			
		}
	}



} 

function NoLink() {
	return false;
}

function OpenWindow1() {
	var patOrdFile1=document.getElementById("patOrdFile1");
	var PatientOrderFile1=document.getElementById("PatientOrderFile1");
	var www=/www/gi; var http=/http/gi; var htm=/htm/gi; var dir=/\\/gi;

	if ((patOrdFile1)&&(patOrdFile1.value!="")) {
		var url=patOrdFile1.value;
		if ((url.search(http) == -1)&&(url.search(www) != -1)) url="http://"+url
		if ((url.search(htm) != -1)&&(url.search(dir) == -1)) url="..\\Help\\"+url
		websys_createWindow(url, 'PatientOrderFile1', 'top=50,left=100,width=600,height=550,scrollbars=yes,resizable=yes');
	}
	return false;
}

function OpenWindow2() {
	var patOrdFile2=document.getElementById("patOrdFile2");
	var PatientOrderFile2=document.getElementById("PatientOrderFile2");
	var www=/www/gi; var http=/http/gi; var htm=/htm/gi; var dir=/\\/gi;

	if ((patOrdFile2)&&(patOrdFile2.value!="")) {
		var url=patOrdFile2.value;
		if ((url.search(http) == -1)&&(url.search(www) != -1)) url="http://"+url
		if ((url.search(htm) != -1)&&(url.search(dir) == -1)) url="..\\Help\\"+url
		websys_createWindow(url, 'PatientOrderFile2', 'top=50,left=100,width=600,height=550,scrollbars=yes,resizable=yes');
	}
	return false;
}

function OpenWindow3() {
	var patOrdFile3=document.getElementById("patOrdFile3");
	var PatientOrderFile3=document.getElementById("PatientOrderFile3");
	var www=/www/gi; var http=/http/gi; var htm=/htm/gi; var dir=/\\/gi;

	if ((patOrdFile3)&&(patOrdFile3.value!="")) {
		var url=patOrdFile3.value;
		if ((url.search(http) == -1)&&(url.search(www) != -1)) url="http://"+url
		if ((url.search(htm) != -1)&&(url.search(dir) == -1)) url="..\\Help\\"+url
		websys_createWindow(url, 'PatientOrderFile3', 'top=50,left=100,width=600,height=550,scrollbars=yes,resizable=yes');
	}
	return false;
}

function ActivateSpecCol() {
	var RecDate="";
	var RecTime="";
	var SpecColObj=document.getElementById("SpecCollected");
	var RecDateObj=document.getElementById("ReceivedDate");
	if (RecDateObj) RecDate=RecDateObj.value;

	var RecTimeObj=document.getElementById("ReceivedTime");

	if(RecDate!=""){
		var hidRecTime="";
		var RecTimeobj=document.getElementById("ReceivedTime");
		var hidRecTimeobj=document.getElementById("HidRecTime");
		if ((hidRecTime) && (RecTimeobj) && (RecTimeobj.value=="")) RecTimeobj.value=hidRecTimeobj.value;

		var SpecColObj=document.getElementById("SpecCollected");
		if (SpecColObj&&SpecColObj.checked==false) {
			if (SpecColObj) SpecColObj.checked=true;
			SpecColCheck();
		}

	}

	else {
		//if (SpecColObj) SpecColObj.checked=false;
		if (RecTimeObj) RecTimeObj.value="";
		//SpecColCheck();

	}
	//var check=VerifyColRecDateTime();
}

function OEORIRemarks_onkeydown() {
//required to call this function to override the generic script
//DL : LOG 29062 : 02/Oct/02

}


function OEORIDepProcNotes_onkeydown() {
//required to call this function to override the generic script
//DL : LOG 29062 : 02/Oct/02

}

function fillDateTime(){
	var hidColDate="";
	var hidColTime="";

	var ColDateobj=document.getElementById("ColDate");
	var ColTimeobj=document.getElementById("ColTime");
	var hidColDateobj=document.getElementById("HidColDate");
	var hidColTimeobj=document.getElementById("HidColTime");
	if ((hidColDateobj) && (ColDateobj) && (ColDateobj.value=="")) ColDateobj.value=hidColDateobj.value;
	if ((hidColTimeobj) && (ColTimeobj) && (ColTimeobj.value=="")) ColTimeobj.value=hidColTimeobj.value;
}

function SpecColCheck() {
	var SpecColObj=document.getElementById("SpecCollected");
	if (SpecColObj&&SpecColObj.checked) {
		EnableFields();
		fillDateTime();
	} else {
		DisableFields();
	}

}

function AddSpecToList(specs,tsetSelected) {
	//alert("add: "+specs+" - "+tsetSelected);
	var obj=document.getElementById("TestSetCode");
	var data=specs.split(String.fromCharCode(2));
	var sdata=data.join("^");
	if (obj) {
		obj.selectedIndex = -1;
		//var updatedspecs="";
		//var updatedspecs=obj.value;
		//if (updatedspecs!="") updatedspecs=updatedspecs.split(String.fromCharCode(2));
		for (var i=0; i<data.length-1; i++) {
			var specimen=mPiece(sdata,"^",i);
			var code=mPiece(specimen,String.fromCharCode(1),0);
			var desc=mPiece(specimen,String.fromCharCode(1),2);
			//alert("spec= "+specimen+" code= "+code+" desc= "+desc);
			var defspec=mPiece(specimen,String.fromCharCode(1),1);
			obj.options[obj.length] = new Option(desc,code);
		}
		if (tsetSelected!="") SetSelectedSpecimensValue(tsetSelected);
		var IDObj=document.getElementById("ID");
		if ((IDObj)&&(IDObj.value=="")) {
			SetSelectedSpecimensValueNoID(sites);
		}
	}

}

function AddSiteToList(SpecSites) {
	var obj=document.getElementById("Site");
	var data=SpecSites.split("^");

	if (obj) {
		obj.selectedIndex = -1;
		for (var i=0; i<data.length; i++) {
			var desc=mPiece(data[i],String.fromCharCode(2),1);
			var code=mPiece(data[i],String.fromCharCode(2),0);
			//var desc=data[i+1]
			obj.options[obj.length] = new Option(desc,code);
		}
	}
}

function SetSelectedSpecimensValue(SelectedSpecimen) {
	var arrSelected = SelectedSpecimen.split(String.fromCharCode(2));
	var lst=document.getElementById("TestSetCode");
	if (lst) {
		lst.selectedIndex=-1;
		for (var i in arrSelected) {
			if (arrSelected[i] == "") continue;
			for (var j=0; j<lst.length; j++) {
				//alert("******"+mPiece(arrSelected[i],String.fromCharCode(1),0)+"-"+lst.options[j].value+"******");
				if ((mPiece(arrSelected[i],String.fromCharCode(1),0) == lst.options[j].value)&&(lst.options[j].selected==false)) {
					//lst.options[j].selected = true;
					///*
					if (lst.disabled==true) {
						lst.options[j].style.color="yellow";
  						lst.options[j].selected = true;
					}
					else lst.options[j].selected = true;
					//*/
				}
			}
		}
	}
}

function SetSelectedSpecimensValueNoID(SelectedSpecimen) {
	SelectedSpecimen=SelectedSpecimen.replace(SitesDelim,"")
	var arrSelected = SelectedSpecimen.split(SpecDelim);
	var lst=document.getElementById("TestSetCode");
	if (lst) {
		lst.selectedIndex=-1;
		for (var i in arrSelected) {
			if (arrSelected[i] == "") continue;
			for (var j=0; j<lst.length; j++) {
				if ((mPiece(arrSelected[i],SiteDelim,0) == lst.options[j].value)&&(lst.options[j].selected==false)) {
				if (lst.disabled==true) {
						lst.options[j].style.color="yellow";
  						lst.options[j].selected = true;
					}
					else lst.options[j].selected = true;
				}
			}
		}
	}
}


function SetSelectedSpecimensValueOrderEntry(SelectedSpecimen) {
	var arrSelected = SelectedSpecimen.split(String.fromCharCode(9));
	var lst=document.getElementById("TestSetCode");
	if (lst) {
		lst.selectedIndex=-1;
		for (var i in arrSelected) {
			if (arrSelected[i] == "") continue;
			for (var j=0; j<lst.length; j++) {
				
				if ((mPiece(arrSelected[i],String.fromCharCode(1),0) == lst.options[j].value)&&(lst.options[j].selected==false)) {
				//if ((mPiece(arrSelected[i],String.fromCharCode(7),0) == lst.options[j].value)&&(lst.options[j].selected==false)) {
					lst.options[j].selected = true;
				}

			}
		}
	}

}

function SetSelectedSpecimensText(SelectedSpecimen) {
	var arrSelected = SelectedSpecimen.split("^");
	var lst=document.getElementById("TestSetCode");
	if (lst) {
		lst.selectedIndex=-1;
		for (var i in arrSelected) {
			if (arrSelected[i] == "") continue;
			for (var j=0; j<lst.length; j++) {
				if (arrSelected[i] == lst.options[j].text) {
					lst.options[j].selected = true;
				}
			}
		}
	}
}

function SetSelectedSites(SelectedSites) {
	//alert("in SetSelectedSites: "+SelectedSites);

	var arrSelected = SelectedSites.split("^");
	var lst=document.getElementById("Site");
	if (lst) {
		lst.selectedIndex=-1;
		for (var i in arrSelected) {
			if (arrSelected[i] == "") continue;
			for (var j=0; j<lst.length; j++) {
				if (arrSelected[i] == lst.options[j].value) {
					lst.options[j].selected = true;
				}
			}
		}
	}
}

// JPD 54225
function SetSelectedLabTrakSites(SelectedSites) {
	var arrSelected = SelectedSites.split("^");
	var lst=document.getElementById("Site");
	if (lst) {
		lst.selectedIndex=-1;
		for (var i in arrSelected) {
			if (arrSelected[i] == "") continue;
			for (var j=0; j<lst.length; j++) {
				if (mPiece(arrSelected[i],String.fromCharCode(2),1) == lst.options[j].value) {
					lst.options[j].selected = true;
				}
			}
		}
	}
}
function DeleteRefClickHandler() {
	//Delete items from lstOrders listbox when a "Delete" button is clicked.
	var obj=document.getElementById("RefDoctorList")
	if (obj) RemoveFromList(document.fOEOrder_Normal,obj)
}

function ClearField() {
	//var obj=document.getElementById("TestSetCode");
	//if (obj) obj.value="";
	//document.fOEOrder_Lab.CareProvider.value="";
	var obj=document.forms['fOEOrder_Lab'].elements['CareProvider'];
	if (obj) obj.value="";
	var obj=document.getElementById("OEORIRefDocDR")
	if (obj) obj.value="";
	var obj=document.forms['fOEOrder_Lab'].elements['CopyToClinician'];
	if (obj) obj.value="";
}
function DeleteClickHandler() {
	//Delete items from lstOrders listbox when a "Delete" button is clicked.
	var obj=document.getElementById("CareProvList")
	if (obj) RemoveFromList(document.fOEOrder_Lab,obj)
}

function EnableFields() {
	//log 59208 TedT need to enable check field too
	var SpecColObj=document.getElementById("SpecCollected");
	var ColDateObj = document.getElementById("ColDate");
	var ColTimeObj = document.getElementById("ColTime");
	var ColDatelbl = document.getElementById("cColDate");
	var ColTimelbl = document.getElementById("cColTime");

	if (ColDateObj&&ColTimeObj) {
		if(SpecColObj){
			SpecColObj.disabled=false;
			SpecColObj.className="";
		}
		ColDateObj.disabled = false;
		ColTimeObj.disabled = false;
		ColDateObj.className = "";
		ColTimeObj.className = "";
		if (ColTimelbl) ColTimelbl = ColTimelbl.className = ""; //"clsRequired";
		if (ColDatelbl) ColDatelbl = ColDatelbl.className = ""; //"clsRequired";
	}
}

function DisableFields() {

	var ColDateObj = document.getElementById("ColDate");
	var ColDatelbl = document.getElementById("cColDate");
	var ColTimeObj = document.getElementById("ColTime");
	var ColTimelbl = document.getElementById("cColTime");

	if ((ColDateObj)&&(ColDateObj.tagName=="INPUT")&&(ColTimeObj)&&(ColTimeObj.tagName=="INPUT")) {
		ColDateObj.value = "";
		ColTimeObj.value = "";
		ColDateObj.disabled = true;
		ColTimeObj.disabled = true;
		ColDateObj.className = "disabledField";
		ColTimeObj.className = "disabledField";
		if (ColDatelbl) ColDatelbl = ColDatelbl.className = "";
		if (ColTimelbl) ColDatelbl = ColTimelbl.className = "";
	}

}
/*
function BodyUnloadHandler(e) {
	if ((self == top)&&(updated)) {
		var win=window.opener;
		if (win) {
			//win.treload('websys.csp');
		}
	}
}
*/
function BodyUnLoadHandler() { //log 30710 AmiN Start Date must be within Episode Admin Date and Discharge date.
	//If there is any mandatory field left unfilled, alert the user and delete the order item from the list.
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
		// log 63386 BoC: close Questionnaire Window when closing order details window
		if (par_win.QuestionnaireWin) {
			try{
				par_win.QuestionnaireWin.close();
			}catch(e){}
		}
	}	

	//Go to the details page of the next order item
	if ((par_win)&&(par_win.document.fOEOrder_Custom)) par_win.OrderDetailsShowing(par_win.document.fOEOrder_Custom);

	// JD refresh order list with new values 54852
	if (OrderWindow=="oeorder_entry") {
		try {
			var detailFrame=window.open("","oeorder_entry");
			//log 60877 timeout to allow username and PIN validation
			if (detailFrame) detailFrame.DelayedRefreshSessionList();
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
	for (var i=0;i<document.fOEOrder_Lab.elements.length;i++) {
		if (document.fOEOrder_Lab.elements[i].id!="") {
			var elemid="c"+document.fOEOrder_Lab.elements[i].id;
			var elemc=document.getElementById(elemid);
			var elem=document.getElementById(document.fOEOrder_Lab.elements[i].id);
			if ((elemc) && (elemc.className=="clsRequired")) {
				if ((elem)&&(elem.value=="")) AllGetValue=AllGetValue+elemc.innerText+":  "+t['XMISSING']+"\n";
			}
		}
	}
	return AllGetValue;
}

document.body.onload = BodyLoadHandler;
/*
function OEORISttDat_onBlur(e) {
	var obj=document.getElementById("OEORISttDat");
	Gparam5=obj.value;
	var objDate = DateStringToDateObj(Gparam5);
	var objToday = new Date();
	if (objDate < objToday) {
		var hsdcobj=document.getElementById("HiddenStartDateCheck");
		if (hsdcobj) hsdcobj.onchange();
		//alert("Gsdcheckval="+Gsdcheckval);
		if (Gsdcheckval=="Y") {
			alert(t['InClosedAccPeriod']);
		}
	}
}

function HiddenStartDateCheck_changehandler(encmeth) {
	//alert(" "+encmeth+" "+Gparam5);
	Gsdcheckval=cspRunServerMethod(encmeth,Gparam5);
}
*/

//Log 61186 PeterC 29/11/06
var Gparam6="";
var Gparam7="";
var Gparam8="";
var currDate="";
function OEORISttDat_onBlur(e) {
	var obj=document.getElementById("OEORISttDat");
	Gparam5=obj.value;
	var obj=document.getElementById("OEORIItmMastDR");
	if((obj)&&(obj.value!="")) Gparam6=obj.value;
	var obj=document.getElementById("EpisodeID");
	if((obj)&&(obj.value!="")) Gparam7=obj.value;
	var obj=document.getElementById("OECPRDesc");
	if((obj)&&(obj.value!="")) Gparam8=obj.value;
	var hsdcobj=document.getElementById("HiddenStartDateCheck");
	if (hsdcobj) hsdcobj.onchange();
	//alert("Gsdcheckval="+Gsdcheckval);
	var ICAPAlert=mPiece(Gsdcheckval,"^",0);
	var RecLoc=mPiece(Gsdcheckval,"^",1);
	if ((ICAPAlert!="")&&(ICAPAlert=="Y")) {
		alert(t['InClosedAccPeriod']);
	}
	var obj=document.getElementById("CTLOCDesc");
	if((obj)&&(Gparam5!="")&&(Gparam5!=currDate)) obj.value=RecLoc;
	if(currDate!=Gparam5) currDate=Gparam5;
}

function HiddenStartDateCheck_changehandler(encmeth) {
	Gsdcheckval=cspRunServerMethod(encmeth,Gparam5,Gparam6,Gparam7,Gparam8);
}

var obj=document.getElementById("OEORISttDat");
if (obj) {
	obj.onblur=OEORISttDat_onBlur;
	currDate=obj.value;
}

document.body.onunload = BodyUnLoadHandler;  //log 30710

function DisableElementsWhenInvoiced() {
 	var obj=document.getElementById("OEORISttDat");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("OEORISttTim");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("OEORIEndDate");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("OEORIEndTime");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("OEORIQty");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("DrugForm");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("OEORIDoseQty");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("PHCFRDesc1");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("PHCDUDesc1");
	if (obj) obj.disabled=true;
	var obj=document.getElementById("OSTATDesc");
	//if (obj) obj.disabled=true;
	var obj=document.getElementById("PHCINDesc1");
	if (obj) obj.disabled=true;
}

function DisableSpecimenListBox() {
	var Specimenobj=document.getElementById("TestSetCode");
	if (Specimenobj) Specimenobj.disabled=true;
}

//log 59208 TedT update collection date and time so either both are blank or both have value
function UpdateCollectionDateTime() {
	var current=this.value;
	var SpecColObj=document.getElementById("SpecCollected");
	
	if(SpecColObj) {
		if(current!="") SpecColObj.checked=true;
		else SpecColObj.checked=false;
		SpecColCheck();
	}
	else {
		if(current!="") fillDateTime();
		else {
			var ColDateobj=document.getElementById("ColDate");
			var ColTimeobj=document.getElementById("ColTime");
			if(ColDateobj) ColDateobj.value="";
			if(ColTimeobj) ColTimeobj.value="";
		}
	}
}

//Log 64399 PeterC 20/07/07
function LookUpRecLocHandler(str) {
	//alert(str);
	var lu = str.split("^");
	if (lu[3]!="") {
		var tselect=""
		var tmpArr=lu[3];
		tmpArr=tmpArr.split(String.fromCharCode(2));

		for (var i=0; i<tmpArr.length-1; i++) {
			var CurrStr=tmpArr[i];
			if (mPiece(CurrStr,String.fromCharCode(1),1)=="Y") tselect=tselect+CurrStr+String.fromCharCode(2);
		}
		var obj=document.getElementById("TestSetCode");
		for (var i=(obj.length-1); i>=0; i--) {
			obj.options[i]=null;
		}
		AddSpecToList(lu[3],tselect)
	}
}