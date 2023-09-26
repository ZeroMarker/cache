// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var f=document.fepr_GroupSettings_Edit;

// Log 39459 - AI - 09-10-2003 : Disable the OnlyShowUncollectedOnCollection checkbox if NOT External Lab System.
var objExtLabFlag=document.getElementById("ExtLabFlag");
var objOnlyShowUncollected=document.getElementById("OnlyShowUncollectedOnCollection");
if ((objExtLabFlag)&&(objOnlyShowUncollected)) {
	if (objExtLabFlag.value=="Y") {
		objOnlyShowUncollected.disabled=false;
		objOnlyShowUncollected.className = "";
	} else {
		objOnlyShowUncollected.value="";
		objOnlyShowUncollected.disabled=true;
		objOnlyShowUncollected.className = "disabledField";
	}
}


function DefiningOrdersClickHandler(e) {
	vals="&ID="+f.ID.value;
	vals=vals+"&GroupID="+f.GroupDR.value;
	vals=vals+"&OEItemDetailsID="+f.OEItemDetailsID.value;
	vals=vals+"&OESetItemsID="+f.OESetItemsID.value;
	vals=vals+"&OEItemItemID="+f.OEItemItemID.value;
	vals=vals+"&OEItemSubcatID="+f.OEItemSubcatID.value;
	vals=vals+"&OESetSetID="+f.OESetSetID.value;
	vals=vals+"&OESetSubcatID="+f.OESetSubcatID.value;
	vals=vals+"&OEExecSubcatID="+f.OEExecSubcatID.value;
	vals=vals+"&OEExecItemID="+f.OEExecItemID.value;
	//Log 58162 BoC 05/09/2006: pass OEQuesSubcatID and OEQuesCatID
	vals=vals+"&OEQuesCatID="+f.OEQuesCatID.value;
	vals=vals+"&OEQuesSubcatID="+f.OEQuesSubcatID.value;
	websys_createWindow("websys.default.csp?WEBSYS.TCOMPONENT=epr.GroupSettings.EditOEDetails"+vals,"new","top=0,left=0,width=450,height=450,status=yes,resizable=yes,scrollbars=yes")
}

function DefiningCarPrvTpClickHandler(e) {
	vals="&ID="+f.ID.value;
	vals=vals+"&GroupID="+f.GroupDR.value;
	vals=vals+"&CarPrvTpID="+f.CarPrvTpID.value;
	websys_createWindow("websys.default.csp?WEBSYS.TCOMPONENT=epr.GroupSettings.EditCarPrvTp"+vals,"new","top=0,left=0,width=450,height=450,status=yes,resizable=yes,scrollbars=yes")
}

// Log 42975 - AI - The Click Handler for "Define Discharge Summary Document Types" button.
function DefiningDisSumDocTpClickHandler(e) {
	vals="&ID="+f.ID.value;
	vals=vals+"&GroupID="+f.GroupDR.value;
	vals=vals+"&DisSumDocTpID="+f.DisSumDocTpID.value;
	websys_createWindow("websys.default.csp?WEBSYS.TCOMPONENT=epr.GroupSettings.EditDisSumDocTp"+vals,"new","top=0,left=0,width=450,height=450,status=yes,resizable=yes,scrollbars=yes")
}

// Log 44164 - AI - 31-05-2004 : The Click Handler for "Define Discharge Summary EPR Chart Book" button.
function DefiningDisSumEPRChartBookClickHandler(e) {
	vals="&ID="+f.ID.value;
	vals=vals+"&GroupID="+f.GroupDR.value;
	vals=vals+"&DisSumEPRChartBookID="+f.DisSumEPRChartBookID.value;
	websys_createWindow("websys.default.csp?WEBSYS.TCOMPONENT=epr.GroupSettings.EditDisSumEPRChartBook"+vals,"new","top=0,left=0,width=450,height=450,status=yes,resizable=yes,scrollbars=yes")
}

// Log 46501 - MD - 19-10-2004 : The Click Handler for "Define Pharmacy Queue" button.
function DefinePharmQClickHandler(e) {
	vals="&ID="+f.ID.value;
	vals=vals+"&GroupID="+f.GroupDR.value;
	vals=vals+"&PharmQID="+f.PharmQID.value;
	websys_createWindow("websys.default.csp?WEBSYS.TCOMPONENT=epr.GroupSettings.EditPhamacyQ"+vals,"new","top=0,left=0,width=450,height=450,status=yes,resizable=yes,scrollbars=yes")
}

// Log 51381 - BKJ - The Click Handler for "Display Result Types" button.
function DefiningDisplayResultTypes(e) {
	vals="&ID="+f.ID.value;
	vals=vals+"&GroupID="+f.GroupDR.value;
	vals=vals+"&DisplayResultTypeID="+f.DisplayResultTypes.value;
	websys_createWindow("websys.default.csp?WEBSYS.TCOMPONENT=epr.GroupSettings.EditDisResTp"+vals,"new","top=0,left=0,width=450,height=450,status=yes,resizable=yes,scrollbars=yes")
}

function DefineAllergySevClickHandler(e) {
	vals="&ID="+f.ID.value;
	vals=vals+"&GroupID="+f.GroupDR.value;
	vals=vals+"&AllergyID="+f.AllergySeverity.value;
	websys_createWindow("websys.default.csp?WEBSYS.TCOMPONENT=epr.GroupSettings.EditAllergySev"+vals,"new","top=0,left=0,width=450,height=450,status=yes,resizable=yes,scrollbars=yes")
}

function DefineDrugIntClickHandler(e) {
	vals="&ID="+f.ID.value;
	vals=vals+"&GroupID="+f.GroupDR.value;
	vals=vals+"&DrugIntID="+f.DrugIntSeverity.value;
	websys_createWindow("websys.default.csp?WEBSYS.TCOMPONENT=epr.GroupSettings.EditDrugInt"+vals,"new","top=0,left=0,width=450,height=450,status=yes,resizable=yes,scrollbars=yes")
}

function DefineAuditTabClickHandler(e) {
	vals="&ID="+f.ID.value;
	vals=vals+"&GroupID="+f.GroupDR.value;
	vals=vals+"&AuditTabID="+f.AuditTables.value;
	websys_createWindow("websys.default.csp?WEBSYS.TCOMPONENT=epr.GroupSettings.EditAuditTab"+vals,"new","top=0,left=0,width=450,height=450,status=yes,resizable=yes,scrollbars=yes")
}

function DefiningPatTypeRstClickHandler(e) {
	vals="&ID="+f.ID.value;
	vals=vals+"&GroupID="+f.GroupDR.value;
	vals=vals+"&PatTypeRstID="+f.PatTypeRstID.value;
	websys_createWindow("websys.default.csp?WEBSYS.TCOMPONENT=epr.GroupSettings.EditPatTypeRestr"+vals,"new","top=0,left=0,width=450,height=450,status=yes,resizable=yes,scrollbars=yes")
}

function LookUpProfile(val) {
	ary=val.split("^");
	//f.elements[ary[2]+"_ID"].value=ary[1];
	//checkForDuplicates(ary[2])
}


if (document.getElementById('DefiningOrders')) {
	document.getElementById('DefiningOrders').onclick = DefiningOrdersClickHandler;
}

if (document.getElementById('DefiningCarPrvTp')) {
	document.getElementById('DefiningCarPrvTp').onclick = DefiningCarPrvTpClickHandler;
}

// Log 42975 - AI - Define the Click Handler for "Define Discharge Summary Document Types" button.
if (document.getElementById('DefiningDisSumDocTp')) {
	document.getElementById('DefiningDisSumDocTp').onclick = DefiningDisSumDocTpClickHandler;
}

// Log 44164 - AI - 31-05-2004 : Define the Click Handler for "Define Discharge Summary EPR Chart" button.
if (document.getElementById('DefiningDisSumEPRChartBook')) {
	document.getElementById('DefiningDisSumEPRChartBook').onclick = DefiningDisSumEPRChartBookClickHandler;
}

// Log 46501 - MD - 19-10-2004 : Define the Click Handler for "Define Pharmacy Queue" button.
if (document.getElementById('DefinePharmQ')) {
	document.getElementById('DefinePharmQ').onclick = DefinePharmQClickHandler;
}

// Log 51371 - BKJ - Define the Click Handler for "Define Display Result Types" button.
if (document.getElementById('DefiningDisplayResultTypes')) {
	document.getElementById('DefiningDisplayResultTypes').onclick = DefiningDisplayResultTypes;
}

if (document.getElementById('DefineAllergySev')) {
	document.getElementById('DefineAllergySev').onclick = DefineAllergySevClickHandler;
}

if (document.getElementById('DefineDrugInt')) {
	document.getElementById('DefineDrugInt').onclick = DefineDrugIntClickHandler;
}

if (document.getElementById('DefineAuditTab')) {
	document.getElementById('DefineAuditTab').onclick = DefineAuditTabClickHandler;
}

if (document.getElementById('DefiningPatTypeRst')) {
	document.getElementById('DefiningPatTypeRst').onclick = DefiningPatTypeRstClickHandler;
}

function EditProfile() {
	var OrderDesc="";
	var obj=document.getElementById("OrderProfileDR");
	if (obj) OrderDesc=obj.value;
	
	var vals="PPType="+this.name+"&PPDesc="+OrderDesc;
	//if (f.elements[this.name+"_Desc"].value!="") vals=vals+"&ID="+f.elements[this.name+"_ID"].value;
	//if (f.elements[this.name+"_Desc"].value=="") vals=vals+"&ID=";
	websys_createWindow('epr.ctprofileparams.edit.csp?'+vals,'Profiles','top=0,left=0,width=500,height=450,status=yes,resizable=yes,scrollbars=yes');
	return false;
}

if (document.getElementById('OP')) {
	document.getElementById('OP').onclick = EditProfile;
}

function eprGroupSettingsEdit_UpdateClickHandler() {
	var msg=""; var doupdate=1;
	var obj=f.TopApptFramePerc;
	if ((obj)&&(obj.value!="")) msg+=t['TopApptFramePerc']+' '+t['DEFUNCT']+'\n';
	var obj=f.MidApptFramePerc;
	if ((obj)&&(obj.value!="")) msg+=t['MidApptFramePerc']+' '+t['DEFUNCT']+'\n';
	var obj=f.TransCspMidFrame;
	if ((obj)&&(obj.value!="")) msg+=t['TransCspMidFrame']+' '+t['DEFUNCT']+'\n';
	var obj=f.TransCspTopFrame;
	if ((obj)&&(obj.value!="")) msg+=t['TransCspTopFrame']+' '+t['DEFUNCT']+'\n';
	if (msg!="") {
		msg += t['FRAMEPREF']+'\n';
		doupdate=confirm(msg+t['CONTINUE']);
	}
	if (doupdate) return update1_click();
}
var obj=document.getElementById('update1');
if (obj) obj.onclick=eprGroupSettingsEdit_UpdateClickHandler;

function eprGroupSettingsEdit_BodyLoadHandler() {
    BoldLinks();

	if (tsc['update1']) websys_sckeys[tsc['update1']]=eprGroupSettingsEdit_UpdateClickHandler;
}

function BoldLinks() {
    // ab 14.12.04 - 47698 - bold links
	var obj=document.getElementById('DefiningCarPrvTp');
    var objID=document.getElementById("CarPrvTpID");
    if ((objID)&&(objID.value!="")&&(obj)) obj.style.fontWeight="bold";
	var obj=document.getElementById('DefiningDisSumDocTp');
    var objID=document.getElementById("DisSumDocTpID");
    if ((objID)&&(objID.value!="")&&(obj)) obj.style.fontWeight="bold";
    var obj=document.getElementById('DefiningPatTypeRst');
    var objID=document.getElementById("PatTypeRstID");
    if ((objID)&&(objID.value!="")&&(obj)) obj.style.fontWeight="bold";
	var obj=document.getElementById('DefinePharmQ');
    var objID=document.getElementById("PharmQID");
    if ((objID)&&(objID.value!="")&&(obj)) obj.style.fontWeight="bold";
	var obj=document.getElementById('DefineAllergySev');
    var objID=document.getElementById("AllergySeverity");
    if ((objID)&&(objID.value!="")&&(obj)) obj.style.fontWeight="bold";
	var obj=document.getElementById('DefineDrugInt');
    var objID=document.getElementById("DrugIntSeverity");
    if ((objID)&&(objID.value!="")&&(obj)) obj.style.fontWeight="bold";

    var obj=document.getElementById('DefiningDisplayResultTypes');
    var objID=document.getElementById("DisplayResultTypes");
    if ((objID)&&(objID.value!="")&&(obj)) obj.style.fontWeight="bold";

    var obj=document.getElementById('DefineAuditTab');
    var objID=document.getElementById("AuditTables");
    if ((objID)&&(objID.value!="")&&(obj)) obj.style.fontWeight="bold";

    var obj=document.getElementById('DefiningOrders');
    var objID1=document.getElementById("OEItemItemID");
    var objID2=document.getElementById("OESetItemsID");
    var objID3=document.getElementById("OEItemSubcatID");
    var objID4=document.getElementById("OESetSubcatID");
    var objID5=document.getElementById("OESetSetID");
    var objID6=document.getElementById("OEExecItemID");
    var objID7=document.getElementById("OEExecSubcatID");
    var objID8=document.getElementById("OEItemDetailsID");
    var orderids=objID1.value+objID2.value+objID3.value+objID4.value+objID5.value+objID6.value+objID7.value+objID8.value;
    if ((objID)&&(orderids!="")&&(obj)) obj.style.fontWeight="bold";
	var obj=document.getElementById('FramePreference');
    var objID=document.getElementById("BoldFrameLink");
    if ((objID)&&(objID.value!="")&&(obj)) obj.style.fontWeight="bold";
}

function RBDisplaySessionTypeLookUp(str) {
	var lu=str.split("^");
	if (f.RBDisplaySessionType && lu[2]=="Y") {
		if (f.SSGRPDisplayServiceDetails) f.SSGRPDisplayServiceDetails.value=""
	}
}

function DisplayServiceDetailsLookUp(str) {
	var lu=str.split("^");
	if (f.SSGRPDisplayServiceDetails && lu[2]=="Y") {
		if (f.RBDisplaySessionType) f.RBDisplaySessionType.value=""
	}
}

document.body.onload=eprGroupSettingsEdit_BodyLoadHandler;