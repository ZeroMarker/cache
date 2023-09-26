// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

if (document.getElementById('HospitalList')) document.getElementById('HospitalList').tkItemPopulate=1;
if (document.getElementById('LocationList')) document.getElementById('LocationList').tkItemPopulate=1;
if (document.getElementById('Location2List')) document.getElementById('Location2List').tkItemPopulate=1;
if (document.getElementById('LocationListByLogonHospital')) document.getElementById('LocationListByLogonHospital').tkItemPopulate=1;

function BodyLoadHandler() {
	var print=document.getElementById('Print');
	if (print) print.onclick=timedelayonPrint;
	var preview=document.getElementById('Preview');
	if (preview) preview.onclick=timedelayonPreview;

	var obj=document.getElementById("DeleteHospital");
	if ((obj)) obj.onclick=HospitalDeleteClickHandler;
	var obj=document.getElementById("DeleteLocation");
	if ((obj)) obj.onclick=LocationDeleteClickHandler;
	var obj=document.getElementById("DeleteLocation2");
	if ((obj)) obj.onclick=Location2DeleteClickHandler;
	var obj=document.getElementById("DeleteLocbyLogonHosp");
	if ((obj)) obj.onclick=DeleteLocbyLogonHospDeleteClickHandler;

	var obj=document.getElementById('DateFrom');
	if (obj) obj.onchange=DateChangeHandler;
	var obj=document.getElementById('DateTo');
	if (obj) obj.onchange=DateChangeHandler;
}

function DateChangeHandler(evt) {

	var eSrc=websys_getSrcElement(e);
	var objDateFrom=document.getElementById('DateFrom');
	var objDateTo=document.getElementById('DateTo');
	var objAcctPeriod=document.getElementById('AcctPeriod');
    // ab 16.09.05 54331 - fixed conditional
	if ((eSrc.id=="DateFrom") && (objDateFrom)) {
		DateFrom_changehandler();
		if ((objDateFrom.className=='')&&(objAcctPeriod)) {
			objAcctPeriod.value="";
		}
	}
	if ((eSrc.id=="DateTo") && (objDateTo)) {
		DateTo_changehandler();
		if ((objAcctPeriod)&&(objDateTo.className=='')) {
			objAcctPeriod.value="";
		}
	}

}

function AcctPeriodLookUp(value) {
	var arrvalue = value.split("^");
	var obj=document.getElementById('AcctPeriod');
	if (obj) {
		obj.value=unescape(arrvalue[0]);
		obj.className='';
	}
	var obj=document.getElementById('DateFrom');
	if (obj) {
		obj.value=unescape(arrvalue[2]);
		obj.className='';
	}
	var obj=document.getElementById('DateTo');
	if (obj) {
		obj.value=unescape(arrvalue[3]);
		obj.className='';
	}

}

function timedelayonPrint() {
	setTimeout("PrintOptionclickhandler()",1500);
	return false;
}

function timedelayonPreview() {
	setTimeout("PreviewOptionclickhandler()",1500);
	return false;
}

function PrintOptionclickhandler(){
	var printopt=document.getElementById('PrintOption');
	var PrintPreview=document.getElementById('PrintPreview');
	var ReportType=document.getElementById("ReportType");
	if ((printopt) && (printopt.value=="1") && (PrintPreview.value=="0")&&(ReportType.value!="Other")){
		if (!InvalidCheck()) return false;
		var objReportCode=document.getElementById('ReportCode');
		if (objReportCode) ReportCode=objReportCode.value;
		var frmparent;
		frmparent=document.getElementById('fwebcommon_DateFromTo_Custom');
		var url="";
		if (frmparent) url=frmparent.action;
		url=url+'&ReportCode='+ ReportCode;
		websys_print('1',url,'','','Print_clickhandler');
	} else {
		Print_clickhandler();
	}

}

function PreviewOptionclickhandler(){
	Print_clickhandler(true);
}

function RegoLookUpSelect(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("RegoLookUp");
	if (obj) obj.value = lu[0];
}

function SSUSRNameLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('SSUSRName');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('SSUserID');
	if (obj) obj.value=lu[1];
}

function READescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('READesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('ReasonRequestID');
	if (obj) obj.value=lu[1];
}

function MonthLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('Month')
	if (obj) obj.value = lu[0];
}

function SortTypeByLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('RTReportSortType')
	if (obj) obj.value = lu[0];
	var obj=document.getElementById('SortCode')
	if (obj) obj.value = lu[1];
}

function RTREVStatusLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('RTREVStatus')
	if (obj) obj.value = lu[0];
	var obj=document.getElementById('RTREVStatusCode')
	if (obj) obj.value = lu[1];
}

function TRUSTDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('TRUSTDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('TrustID');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('HOSPDesc');
	if (obj) obj.value="";
	var obj=document.getElementById('HospitalID');
	if (obj) obj.value="";
}

function SortTypeLookUpSelect(str) {
  var lu = str.split("^");
	var obj=document.getElementById('SortType');
	if (obj) obj.value=lu[0];
}
function LookUp1LookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('LookUp1');
	if (obj) obj.value=lu[0];
}
function LookUp2LookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('LookUp2');
	if (obj) obj.value=lu[0];
}

function HOSPDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('HOSPDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('HospitalID');
	if (obj) obj.value=lu[1];
	var objList=document.getElementById('HospitalList');
	if (objList) {
		var txtField='HOSPDesc';
		var lstField='HospitalList';
		LookupSelectforList(txtField,lstField,str);
	}

}

function LookupSelectforList(tfield,lfield,txt) {
	//Add an item to HospitalList when an item is selected from
	//the Lookup, then clears the text field.
	var adata=txt.split("^");
	var obj=document.getElementById(lfield);  //Listbox
	if (obj) {
		//Need to check if Hospital already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert( adata[0] + " has already been selected");
				var obj=document.getElementById(tfield);  //Textbox with lookup
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert( adata[0] + " has already been selected");
				var obj=document.getElementById(tfield);
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);
	var obj=document.getElementById(tfield);
	if (obj) obj.value="";
}

function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	//code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}


function HospitalDeleteClickHandler() {
	//Delete items from DPTEntered listbox when "Delete" button is clicked.
	var obj=document.getElementById("HospitalList");
	if (obj)
		RemoveFromList(obj);
	return false;
}

function LocationDeleteClickHandler() {
	//Delete items from DPTEntered listbox when "Delete" button is clicked.
	var obj=document.getElementById("LocationList");
	if (obj)
		RemoveFromList(obj);
	return false;
}

function Location2DeleteClickHandler() {
	//Delete items from DPTEntered listbox when "Delete" button is clicked.
	var obj=document.getElementById("Location2List");
	if (obj)
		RemoveFromList(obj);
	return false;
}

function DeleteLocbyLogonHospDeleteClickHandler() {
	//Delete items from DPTEntered listbox when "Delete" button is clicked.
	var obj=document.getElementById("LocationListByLogonHospital");
	if (obj)
		RemoveFromList(obj);
	return false;
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function BuildIDsfromList(){
	//Hospital
	var objList=document.getElementById('HospitalList');
	if (objList) {
		var IDfield='HospitalID';
		var lstfield='HospitalList';
		UpdatewithIDs(lstfield,IDfield);
	}
	//Location
	var objList=document.getElementById('LocationList');
	if (objList) {
		var IDfield='LocationID';
		var lstfield='LocationList';
		UpdatewithIDs(lstfield,IDfield);
	}
	//Location2
	var objList=document.getElementById('Location2List');
	if (objList) {
		var IDfield='Location2ID';
		var lstfield='Location2List';
		UpdatewithIDs(lstfield,IDfield);
	}
	//LocationListByLogonHospital
	var objList=document.getElementById('LocationListByLogonHospital');
	if (objList) {
		var IDfield='LocationByLogonHospitalID';
		var lstfield='LocationListByLogonHospital';
		UpdatewithIDs(lstfield,IDfield);
	}

}

function UpdatewithIDs(lstfield,IDfield) {
	var arrItems = new Array();
	var lst = document.getElementById(lstfield);
	var objPrintPreview=document.getElementById("PrintPreview");
	var objReportType=document.getElementById("ReportType");
	var SlectedIDs="";
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			SlectedIDs=SlectedIDs + lst.options[j].value + ",";
		}
		SlectedIDs=SlectedIDs.substring(0,(SlectedIDs.length-1));
		var el = document.getElementById(IDfield);
		if (el) el.value = SlectedIDs;
	}
}

function NFMIDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('NFMIDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('GovernmentCategoryID');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('DEPCodeStart');
	if (obj) obj.value="";
	var obj=document.getElementById('DEPCodeEnd');
	if (obj) obj.value="";
}

function DEPCodeStartLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('DEPCodeStart');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('DEPCodeEnd');
	if (obj) obj.value="";
}

function DEPCodeEndLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('DEPCodeEnd');
	if (obj) obj.value=lu[0];
}


function CTLOCDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('CTLOCDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('LocationID');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('RESDesc');
	if (obj) obj.value="";
	var obj=document.getElementById('ResourceID');
	if (obj) obj.value="";
	var obj=document.getElementById('SERDesc');
	if (obj) obj.value="";
	var obj=document.getElementById('SESSDesc');
	if (obj) obj.value=""
	var obj=document.getElementById('SessionID');
	if (obj) obj.value="";

	var objList=document.getElementById('LocationList');
	if (objList) {
		var txtField='CTLOCDesc';
		var lstField='LocationList';
		LookupSelectforList(txtField,lstField,str);
	}
}


function CTLOCDescLookUpSelectLoc2(str) {
	var lu = str.split("^");
	var obj=document.getElementById('CTLOCDesc2');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('Location2ID');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('RESDesc');
	if (obj) obj.value="";
	var obj=document.getElementById('ResourceID');
	if (obj) obj.value="";
	var obj=document.getElementById('SERDesc');
	if (obj) obj.value="";
	var obj=document.getElementById('SESSDesc');
	if (obj) obj.value=""
	var obj=document.getElementById('SessionID');
	if (obj) obj.value="";
	// KK 29/jul/2002 Log 25954
	var objList=document.getElementById('Location2List');
	if (objList) {
		var txtField='CTLOCDesc2';
		var lstField='Location2List';
		LookupSelectforList(txtField,lstField,str);
	}

}

function HCRDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('HCRDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('HealthCareRegionID');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('RESDesc');
	if (obj) obj.value="";
	var obj=document.getElementById('ResourceID');
	if (obj) obj.value="";
	var obj=document.getElementById('SERDesc');
	if (obj) obj.value="";
	var obj=document.getElementById('SESSDesc');
	if (obj) obj.value=""
	var obj=document.getElementById('SessionID');
	if (obj) obj.value="";
}

function RESDescLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('CTLOCDesc');
	if ((obj) && (obj.value=="")) obj.value=lu[2];
	var obj=document.getElementById('LocationID');
	if ((obj) && (obj.value=="")) obj.value=lu[3];
	var obj=document.getElementById('RESDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('ResourceID');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('SERDesc');
	if (obj) obj.value="";
	var obj=document.getElementById('ServiceID');
	if (obj) obj.value="";
	var obj=document.getElementById('SESSDesc');
	if (obj) obj.value="";
	var obj=document.getElementById('SessionID');
	if (obj) obj.value="";
}

function SERDescLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('SERDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('ServiceID');
	if (obj) obj.value=lu[2];
}

function SESSDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('SESSDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('RESDesc');
	if (obj) obj.value=lu[2];
	var obj=document.getElementById('SessionID');
	if (obj) obj.value=lu[3];
	var lu2=lu[3].split("||");
	var obj=document.getElementById('ResourceID');
	if (obj) obj.value=lu2[0];
}

function DateHtmlToCrystal(datestr) {
	if (dtformat=="DMMMY") dtseparator=" ";
	var dx=datestr.split(dtseparator);
	//invalid date string
	if (dx.length<=1) return '';
	switch (dtformat) {
		case "DMY":
			return 'Date(' + dx[2] + ',' + dx[1] + ',' + dx[0] + ')';
			break;
		case "MDY":
			return 'Date(' + dx[2] + ',' + dx[0] + ',' + dx[1] + ')';
			break;
		case "YMD":
			return 'Date(' + dx[0] + ',' + dx[1] + ',' + dx[2] + ')';
			break;
		case "DMMMY":
			dx[1]=MonthsShortToNum(dx[1]);
			return 'Date(' + dx[2] + ',' + dx[1] + ',' + dx[0] + ')';
			break;
		case "HIJRA":
			var ddx=dx[2].split(" ");
			return 'Date(' + ddx[0] + ',' + dx[1] + ',' + dx[0] + ')';
			break;
	}
	return '';
}


function TimeHtmlToCrystal(timestr) {
	//output time(HH,MM,SS)
	var dx=timestr.split(tmseparator);
	//invalid time string
	if (dx.length<=1) return '';
	return 'time(' + dx[0] + ',' + dx[1] + ',00)';
	//invalid format
	return '';
}

function CheckBoxToValue(chkvalue,obj) {
	//return either 'Y' or 'N'
	if ((chkvalue)&&(obj)){
		obj.value="Y";
	}
	if (chkvalue) return 'Y';
	return '';
}

function GetIdValue(descstr,idstr) {
	//get the value of the hidden ID field that corresponds to the description field
	var objdesc=document.getElementById(descstr);
	if ((objdesc) && (objdesc.value!="")){
		var objid;
		objid=document.getElementById(idstr);
		if (objid) return objid.value;
	} else {
		var objid1=document.getElementById(idstr);
		if (objid1) objid1.value="";
		return "";
	}
}


function AssignParameterValue(elementid,promptcnt,obj,frm) {
	//this function is called after the print button is clicked. it assigns the required value to the Crystal
	//parameter in the correct order, ie this function ensures that the order of fields on the pages is the order
	//of parameters being passed to Crystal.

	if (elementid=="DateFrom") frm.elements["prompt"+promptcnt].value=DateHtmlToCrystal(obj.value);
	if (elementid=="DateTo") frm.elements["prompt"+promptcnt].value=DateHtmlToCrystal(obj.value);
	if (elementid=="DateFromPast") frm.elements["prompt"+promptcnt].value=DateHtmlToCrystal(obj.value);
	if (elementid=="DateToPast") frm.elements["prompt"+promptcnt].value=DateHtmlToCrystal(obj.value);
	if (elementid=="TimeFrom") frm.elements["prompt"+promptcnt].value=TimeHtmlToCrystal(obj.value);
	if (elementid=="TimeTo") frm.elements["prompt"+promptcnt].value=TimeHtmlToCrystal(obj.value);
	if (elementid=="HCRDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("HCRDesc","HealthCareRegionID");
	if (elementid=="RESDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("RESDesc","ResourceID");
	if (elementid=="SERDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("SERDesc","ServiceID");
	if (elementid=="SESSDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("SESSDesc","SessionID");
	if (elementid=="TRUSTDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("TRUSTDesc","TrustID");
	if (elementid=="NFMIDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("NFMIDesc","GovernmentCategoryID");
	if (elementid=="READesc") frm.elements["prompt"+promptcnt].value = GetIdValue("READesc","ReasonRequestID");
	if (elementid=="RTReportSortType") frm.elements["prompt"+promptcnt].value = GetIdValue("RTReportSortType","SortCode");
	if (elementid=="RTREVStatus") frm.elements["prompt"+promptcnt].value = GetIdValue("RTREVStatus","RTREVStatusCode");   //obj.value;
	if (elementid=="DEPCodeStart") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="DEPCodeEnd") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="SSUSRName") frm.elements["prompt"+promptcnt].value = GetIdValue("SSUSRName","SSUserID");
	if (elementid=="numeric1") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="textbox1") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="textbox2") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="checkbox1") frm.elements["prompt"+promptcnt].value = CheckBoxToValue(obj.checked,obj);
	if (elementid=="checkbox2") frm.elements["prompt"+promptcnt].value = CheckBoxToValue(obj.checked,obj);
	if (elementid=="RegoLookUp") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="DRGCodeF") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="DRGCodeT") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="MRCIDCodeF") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="MRCIDCodeT") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="CTRGDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("CTRGDesc","ReligionID");
	if (elementid=="WLPCode") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="CTPCPDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("CTPCPDesc","CareProviderID");
	if (elementid=="PREFLDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("PREFLDesc","LanguageID");
	if (elementid=="CARETYPDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("CARETYPDesc","CareTypeID");
	if (elementid=="RUDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("RUDesc","ResponsibleUnitID");
	if (elementid=="ADSOUDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("ADSOUDesc","AdmissionSourceID");
	if (elementid=="IPATDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("IPATDesc","InpatAdmissionTypeID");
	if (elementid=="READescAdm") frm.elements["prompt"+promptcnt].value = GetIdValue("READescAdm","AdmissionReasonID");
	if (elementid=="Reportsorttype") frm.elements["prompt"+promptcnt].value = GetIdValue("Reportsorttype","SortCode");
	if (elementid=="Payor") frm.elements["prompt"+promptcnt].value = GetIdValue("Payor","PayorID");
	if (elementid=="PayorPlan") frm.elements["prompt"+promptcnt].value = GetIdValue("PayorPlan","PayorPlanID");
	if (elementid=="Month") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="SortType") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="RTREQBatchID") frm.elements["prompt"+promptcnt].value = GetIdValue("RTREQBatchID","RTREQRowId");
	if (elementid=="SUBTDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("SUBTDesc","IntendedManagementID");
	if (elementid=="INSTCode3") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="PFSDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("PFSDesc","PFSDescID");
	if (elementid=="MEALTDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("MEALTDesc","MealTypeID");
	if (elementid=="SSGRPDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("SSGRPDesc","SecurityGroupID");
	if (elementid=="STAFFDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("STAFFDesc","StaffTypeID");
	if (elementid=="CTCPTDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("CTCPTDesc","CareProviderTypeID");
	if (elementid=="ARCIMDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("ARCIMDesc","OrderItemID");
	if (elementid=="CTDSPDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("CTDSPDesc","DischargeTypeID");
	if (elementid=="ARCICDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("ARCICDesc","ItemCategoryID");
	if (elementid=="LookUp1") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="LookUp2") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="HospitalByLogonTrust") frm.elements["prompt"+promptcnt].value = GetIdValue("HospitalByLogonTrust","HospitalByLogonTrustID");
	if (elementid=="SIGNFDesc") frm.elements["prompt"+promptcnt].value = GetIdValue("SIGNFDesc","CampusID");
	if (elementid=="SortType2") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="NGODesc") frm.elements["prompt"+promptcnt].value = GetIdValue("NGODesc","NGOID");

	if (elementid=="HOSPDesc") {
		//If the list is in the form then get the list of ids
		var objList=document.getElementById('HospitalList');
		if (objList) {
			var idval = document.getElementById("HospitalID");
			if (idval) frm.elements["prompt"+promptcnt].value = idval.value;
			//alert(idval.value);
		} else {frm.elements["prompt"+promptcnt].value = GetIdValue("HOSPDesc","HospitalID");}
	}
	//Location
	if (elementid=="CTLOCDesc"){
		var objList=document.getElementById('LocationList');
		if (objList) {
			var idval = document.getElementById("LocationID");
			if (idval) frm.elements["prompt"+promptcnt].value = idval.value;
		} else {frm.elements["prompt"+promptcnt].value = GetIdValue("CTLOCDesc","LocationID");}
	}
	//Location2
	if (elementid=="CTLOCDesc2") {
		var objList=document.getElementById('Location2List');
		if (objList) {
			var idval = document.getElementById("Location2ID");
			if (idval) frm.elements["prompt"+promptcnt].value = idval.value;
		} else { frm.elements["prompt"+promptcnt].value = GetIdValue("CTLOCDesc2","Location2ID");	}
	}
	//LocationByLogonHospital
	if (elementid=="LocationByLogonHospital") {
		var objList=document.getElementById('LocationListByLogonHospital');
		if (objList) {
			var idval = document.getElementById("LocationByLogonHospitalID");
			if (idval) frm.elements["prompt"+promptcnt].value = idval.value;
		} else { frm.elements["prompt"+promptcnt].value = GetIdValue("LocationByLogonHospital","LocationByLogonHospitalID");	}
	}

	//increment the prompt count so that the next field on the page is assigned to the next Crystal parameter.
	promptcnt++;
	return promptcnt;
}

function Print_clickhandler(preview) {
	// pre-Submit validation
	if (fwebcommon_DateFromTo_Custom_submit()) {
	    // Log 48398 YC - Check that fields aren't clsInvalid.
	    if (!InvalidCheck()) return false;
	    // end Log 48398
	    var frm;
	    frm=document.getElementById('fwebcommon_DateFromTo_Custom');
	    if (frm) {
				var holdaction;
				holdaction=frm.action;
				BuildIDsfromList();
				if ((frm.elements["ReportType"].value=="Crystal")||(frm.elements["ReportType"].value=="Word")) {
					var promptcnt=0;
					var obj;
					var elementid;
					//loop thru each text box on the page and assign the selected value to crystal parameters
					for (var i=0;i<frm.elements.tags("INPUT").length;i++) {
						if (frm.elements.tags("INPUT")[i]) {
							if (frm.elements.tags("INPUT")[i].type=="text"||(frm.elements.tags("INPUT")[i].type=="checkbox")) {
								elementid=frm.elements.tags("INPUT")[i].id;
								obj=document.getElementById(elementid);
								promptcnt=AssignParameterValue(elementid,promptcnt,obj,frm);
							}
						}
						if (promptcnt==9) break;
					}
					if ((frm.elements["PrintPreview"].value=="1")||(preview)) {
						var previewpvalue="";
						var multipval="";
						var crystalras="";
						var objCrystalRAS=document.getElementById("CrystalReportsRAS");
						if ((objCrystalRAS)&&(objCrystalRAS.value=="Disable")) {
							alert("Previewing of Crystal Reports Disabled!");
							return false;
						}
						for (var i=0; i<9; i++) {
							var strpval=mPiece(frm.elements["prompt"+i].value,'"',1);
							multipval="";
							previewpvalue+="&prompt" + i + "=" + frm.elements["prompt"+i].value;
						}
				 		var previewurl="";
						previewpvalue=previewpvalue.substring(1,(previewpvalue.length));
						var objVT=document.getElementById('ViewerType');
						if ((objVT) && (objVT.value!="")){
						previewurl=frm.action+"?init="+objVT.value+"&"+previewpvalue;
					}else{
						previewurl=frm.action+"?"+previewpvalue;
					}

					if ((objCrystalRAS)&&(objCrystalRAS.value=="RAS")){
						var RASPreviewURL="";
						RASPreviewURL=GetRASURL(frm.action);
						previewurl=RASPreviewURL+"&"+previewpvalue;
					}
					previewurl=previewurl+"&viewer=0"
					websys_createWindow(previewurl,"REPORTWINDOW","top=0,left=0,width="+screen.availWidth+",height="+screen.availHeight+",toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");

					frm.target="REPORTWINDOW";
					return false;
				} else {
					frm.target="TRAK_hidden";
	        frm.action="websys.csp";
					frm.submit();
					frm.action=holdaction;
					return false;
				}
			}
			frm.target="TRAK_hidden";
			frm.action="websys.csp";
			frm.submit();
			frm.action=holdaction;
			return false;
	 	}
	} else {
	  	return false;
	}
}

function DRGCodeFLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('DRGCodeF');
	if (obj) obj.value=lu[0];
}

function DRGCodeTLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('DRGCodeT');
	if (obj) obj.value=lu[0];
}

function MRCIDCodeFLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('MRCIDCodeF');
	if (obj) obj.value=lu[2];
}

function MRCIDCodeTLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('MRCIDCodeT');
	if (obj) obj.value=lu[2];
}

function CTRGDescLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('CTRGDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('ReligionID');
	if (obj) obj.value=lu[1];
}

function WLPCodeLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('WLPCode');
	if (obj) obj.value=lu[2];
}

function CTPCPDescLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('CTPCPDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('CareProviderID');
	if (obj) obj.value=lu[1];
}

function PREFLDescLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('PREFLDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('LanguageID');
	if (obj) obj.value=lu[1];
}


function CARETYPDescLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('CARETYPDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('CareTypeID');
	if (obj) obj.value=lu[1];
}

function RUDescLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('RUDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('ResponsibleUnitID');
	if (obj) obj.value=lu[1];
}

function ADSOUDescLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('ADSOUDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('AdmissionSourceID');
	if (obj) obj.value=lu[1];
}

function IPATDescLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('IPATDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('InpatAdmissionTypeID');
	if (obj) obj.value=lu[1];
}

function READescAdmLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('READescAdm');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('AdmissionReasonID');
	if (obj) obj.value=lu[1];
}

function ReportsorttypeLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('Reportsorttype');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('SortCode');
	if (obj) obj.value=lu[1];
}


function PayorLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('Payor');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('PayorID');
	if (obj) obj.value=lu[1];
}

function PayorPlanLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('PayorPlan');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('PayorPlanID');
	if (obj) obj.value=lu[1];

}


function RTREQBatchIDLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('RTREQBatchID');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('RTREQRowId');
	if (obj) obj.value=lu[1];
}


function SUBTDescLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('SUBTDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('IntendedManagementID');
	if (obj) obj.value=lu[1];
}


function INSTCode3LookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('INSTCode3');
	if ((obj) && (lu[0])) obj.value=lu[0];
}


function PFSDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('PFSDesc');
	if ((obj) && (lu[0])) obj.value=lu[0];
	var obj=document.getElementById('PFSDescID');
	if ((obj) && (lu[1])) obj.value=lu[1];
}


function MEALTDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('MEALTDesc');
	if ((obj) && (lu[0])) obj.value=lu[0];
	var obj=document.getElementById('MealTypeID');
	if ((obj) && (lu[1])) obj.value=lu[1];
}


function SSGRPDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('SSGRPDesc');
	if ((obj) && (lu[0])) obj.value=lu[0];
	var obj=document.getElementById('SecurityGroupID');
	if ((obj) && (lu[1])) obj.value=lu[1];
}

function STAFFDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('STAFFDesc');
	if ((obj) && (lu[0])) obj.value=lu[0];
	var obj=document.getElementById('StaffTypeID');
	if ((obj) && (lu[1])) obj.value=lu[1];
}

function CTCPTDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('CTCPTDesc');
	if ((obj) && (lu[0])) obj.value=lu[0];
	var obj=document.getElementById('CareProviderTypeID');
	if ((obj) && (lu[1])) obj.value=lu[1];
}

function ARCIMDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("ARCIMDesc");
	if ((obj) && (lu[2])) obj.value=lu[0];
	var obj=document.getElementById("OrderItemID");
	if ((obj) && (lu[0])) obj.value=lu[1];
}


function CTDSPDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("CTDSPDesc");
	if ((obj) && (lu[0])) obj.value=lu[0];
	var obj=document.getElementById("DischargeTypeID");
	if ((obj) && (lu[1])) obj.value=lu[1];
}


function ARCICDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("ARCICDesc");
	if ((obj) && (lu[0])) obj.value=lu[0];
	var obj=document.getElementById("ItemCategoryID");
	if ((obj) && (lu[1])) obj.value=lu[1];
}


function ValidateDateFromTo(){
	var objdatefr=document.getElementById("DateFrom");
	var objdateto=document.getElementById("DateTo");
	var objdatefrpast=document.getElementById("DateFromPast");
	var objdatetopast=document.getElementById("DateToPast");
	if ((objdatefr)&&(objdatefr.value!="")&&(objdateto)&&(objdateto.value!="")) {
		var mystr=DateStringCompare(objdatefr.value,objdateto.value);
		if (mystr == 1) {
			// First Date is greater than second Date
			alert(t['DTFR_GR_DTTO']);
			return false;
		}
	}
	if ((objdatefrpast)&&(objdatefrpast.value!="")&&(objdatetopast)&&(objdatetopast.value!="")) {
		var mystr=DateStringCompare(objdatefrpast.value,objdatetopast.value);
		if (mystr == 1) {
			// First Date is greater than second Date
			alert(t['DTFR_GR_DTTO']);
			return false;
		}
	}
	if ((objdatefrpast)&&(objdatefrpast.value!="")) {
		var mystr=DateStringCompareToday(objdatefrpast.value);
		if (mystr == 1) {
			alert(t['DTFR_GR_TODAY']);
			return false;
		}
	}
	if ((objdatetopast)&&(objdatetopast.value!="")) {
		var mystr=DateStringCompareToday(objdatetopast.value);
		if (mystr == 1) {
			alert(t['DTTO_GR_TODAY']);
			return false;
		}
	}
	return true;
}

function HospitalByLogonTrustLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('HospitalByLogonTrust');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('HospitalByLogonTrustID');
	if (obj) obj.value=lu[0];
}

function CampusLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("SIGNFDesc");
	if (obj) obj.value=lu[1];
	var obj=document.getElementById("CampusID");
	if (obj) obj.value=lu[0];
}

function LocByLogonHospLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("LocationByLogonHospital");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("LocationByLogonHospitalID");
	if (obj) obj.value=lu[1];
	var objList=document.getElementById("LocationListByLogonHospital");
	if (objList) {
		var txtField="LocationByLogonHospital";
		var lstField="LocationListByLogonHospital";
		LookupSelectforList(txtField,lstField,str);
	}

}

function GetRASURL(actionurl){
	var rname="";
	var raspreviewurl="";
	var returnstring="";
	var viewertype="";
	var pathtoreports="";
	var pathtoscripts="";
	var reportmanagerdsn="";
	var configmanagerdsn="";

	var urltocrystal=document.getElementById('URLToCrystal');
	var objviewertype=document.getElementById('ViewerType');
	if (objviewertype) viewertype=objviewertype.value;
	var objpathtoreports=document.getElementById('PathToReports');
	if (objpathtoreports) pathtoreports=objpathtoreports.value;
	var objpathtoscripts=document.getElementById('PathToScripts');
	if (objpathtoscripts) pathtoscripts=objpathtoscripts.value;
	var objreportmanagerdsn=document.getElementById('reportmanagerdsn');
	if (objreportmanagerdsn) reportmanagerdsn=objreportmanagerdsn.value;
	var objconfigmanagerdsn=document.getElementById('configmanagerdsn');
	if (objconfigmanagerdsn) configmanagerdsn=objconfigmanagerdsn.value;
	var ID=document.getElementById("TREPORT");
	if (ID) ID=ID.value;

	for (var i=actionurl.length;i>=0;i--) {
		rname=mPiece(actionurl,"/",i);
		if (rname!="") {
			raspreviewurl="../csp/";
			urltocrystal=websys_escape(urltocrystal.value);

			returnstring=raspreviewurl+"crystalpreview.csp?a=a&ID="+ID+"&report="+rname+"&init="+viewertype+"&pathtoreports="+pathtoreports+"&pathtoscripts="+pathtoscripts+"&reportmanagerdsn="+reportmanagerdsn+"&configmanagerdsn="+configmanagerdsn+"&urltocrystal="+urltocrystal;
			return returnstring;
		}
	}
	return returnstring;
}


function NGODescLookUpSelect(str) {
    	var lu = str.split("^");
	var obj=document.getElementById('NGOID');
	if (obj) obj.value=lu[1];
}

function mPiece(s1,sep,n) {
	delimArray = s1.split(sep);
  if ((n <= delimArray.length-1) && (n >= 0)) {
  	return delimArray[n];
	} else {
	 	return ""
  }
}

function InvalidCheck() {
	var frm;
	frm=document.getElementById('fwebcommon_DateFromTo_Custom');
	if (frm) {
		for (var i=0;i<=frm.elements.tags("INPUT").length+1;i++) {
			if (frm.elements[i]) {
				if (frm.elements[i].type=="text"||(frm.elements[i].type=="checkbox")) {
					if(frm.elements[i].className=="clsInvalid") {
						alert(t[frm.elements[i].id]+": "+t['XINVALID']);
						frm.elements[i].focus();
						return false;
					}
				}
			}
		}
	}
	return true;
}


document.body.onload = BodyLoadHandler;

var frmSearch=document.getElementById('fwebcommon_DateFromTo_Custom');
if (frmSearch.elements["PrintPreview"].value!="1") {
	for (var i=0; i<9; i++) {
		var obj=frmSearch.elements["prompt"+i];
		if (obj) obj.disabled=true;
	}
}
