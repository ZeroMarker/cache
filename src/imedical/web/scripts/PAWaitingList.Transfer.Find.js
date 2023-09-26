//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var PAWTransListWin=top.frames["TRAK_main"].frames["PAWLTransList"];
var HIDDEN_FIND_PARAM = "^^^^^^^^^^^^^^^^A|C|H|I|P|PRE|S";

if (PAWTransListWin) document.fPAWaitingList_Transfer_Find.TFRAME.value=PAWTransListWin.parent.name;

function BodyLoadHandler(e) {
	obj=document.getElementById('Find');
	if (obj) obj.onclick=FindClickHandler;
	if (tsc['Find']) websys_sckeys[tsc['Find']]=FindClickHandler;

	obj=document.getElementById('TransWaitList');
	if (obj) obj.onclick=TransClickHandler1;
	obj=document.getElementById('TransAllWL');
	if (obj) obj.onclick=TransClickHandler1;

}

function TransClickHandler1(e){
	var el=websys_getSrcElement(e);	
	var WIDStr=""
	var tbl=PAWTransListWin.document.getElementById("tPAWaitingListInquiry_List");
	if (top.frames["eprmenu"]){
		var WID=top.frames["eprmenu"].document.getElementById("WaitingListID");
		WIDStr=WID.value;
	} else {
		var WID=PAWTransListWin.WaitingListIDBuilder("WaitingListID") ;
		WIDStr=WID;
	}
	var objWID=document.getElementById('WIDStr');
	if (objWID) objWID.value=WIDStr;
	if (el.id=="TransAllWL") {
		if (objWID) objWID.value="AllRecords";
		var objhfp=document.getElementById('HiddenFindParam');
		if (objhfp) objhfp.value=HIDDEN_FIND_PARAM 
		TransAllWL_click();
	} else {
		TransWaitList_click();
	}
	return;
}	

function TransClickHandler(e) {
	var el=websys_getSrcElement(e);	
	var WIDStr=""
	var tbl=PAWTransListWin.document.getElementById("tPAWaitingListInquiry_List");
	if (top.frames["eprmenu"]){
		var WID=top.frames["eprmenu"].document.getElementById("WaitingListID");
		WIDStr=WID.value;
	} else {
		var WID=PAWTransListWin.WaitingListIDBuilder("WaitingListID") ;
		WIDStr=WID;
	}
	var objWID=document.getElementById('WIDStr');
	if (objWID) objWID.value=WIDStr;
	var objhfp=document.getElementById('HiddenFindParam');
	if (objhfp) objhfp.value=HIDDEN_FIND_PARAM 
	TransAllWL_click();
	return;
/*	if (el) {
		var OldWaitingListType=""
		var OldHospital=""
		var OldSpeciality=""
		var OldConsult=""
		if (el.id=="TransAllWL") WIDStr="AllRecords";
		objspec=document.getElementById('OldSpecialty');
		if (objspec) OldSpeciality=objspec.value
		objhosp=document.getElementById('HOSPDesc');
		if (objhosp) OldHospital=objhosp.value
		objconsult=document.getElementById('OldConsult');
		if (objconsult) OldConsult=objconsult.value
		objwltype=document.getElementById('OldWaitListType');
		if (objwltype) OldWaitingListType=objwltype.value
		HiddenFindParam = HIDDEN_FIND_PARAM;		// MK - L: 29309
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PAWaitingList.Transfer.New&WIDStr="+WIDStr+"&OldSpeciality="+OldSpeciality+"&OldHospital="+OldHospital+"&OldConsult="+OldConsult+"&OldWaitingListType="+OldWaitingListType+"'&HiddenFindParam=" + HiddenFindParam;
	}
	websys_createWindow(lnk,"frmNewWaitList","top=30,left=20,width=300,height=300,resizable=yes")
*/
}

function FindClickHandler(e) {
	var objWaitType=document.getElementById('OldWaitListType');
	if (objWaitType) waittype=objWaitType.value;
	var objConsult=document.getElementById('OldConsult');
	if (objConsult) consult=objConsult.value;
	var objSpecialty=document.getElementById('OldSpecialty');
	if (objSpecialty) speciality=objSpecialty.value;
	var objHospital=document.getElementById('HOSPDesc');
	if (objHospital) hosp=objHospital.value;

	//KK 06/Mar/2003 Log 30680: Added StatusDesc field to the component. Need to filter on Status as well.
	HIDDEN_FIND_PARAM = "^^^^^^^^^^^^^^Date^^A|C|H|I|P|PRE|S";
	var objStatusDesc=document.getElementById("StatusDesc");
	if ((objStatusDesc) && (objStatusDesc.value=="")){
		var objStatusCode=document.getElementById("StatusCode");
		if (objStatusCode) objStatusCode.value="";
	}
	var objStat=document.getElementById("StatusCode");
	if ((objStat)&&(objStat.value!="")){
		HIDDEN_FIND_PARAM = "^^^^^^^^^^^^^^^^"+objStat.value;
	}

	// SA 26.3.02 - log 23850: Suspended patients are to appear in WL 
	// Inquiry. Changed HiddenFindParam adding "S" - suspended.
	HiddenFindParam = HIDDEN_FIND_PARAM;
	//alert(HiddenFindParam );
	//HiddenFindParam="^^^^^^^^^^^^^^^^A|C|H|I|P|PRE";
	//alert("HiddenFindParam="+HiddenFindParam);
	//parent.frames["PAWLTransList"].location="websys.default.csp?WEBSYS.TCOMPONENT=PAWaitingListInquiry.List&PatientID=&LocDesc='"+speciality+"'&HospDesc='"+hosp+"'&CareProvDesc='"+consult+"'&ListTypeDesc='" + waittype + "'&HiddenFindParam=" + HiddenFindParam;
	//KK single quotes removed - was giving error. 
	wllnk="websys.default.csp?WEBSYS.TCOMPONENT=PAWaitingListInquiry.List&PatientID=&LocDesc="+speciality+"&HospDesc="+hosp+"&CareProvDesc="+consult+"&ListTypeCode="+waittype+"&HiddenFindParam=" + HiddenFindParam
	parent.frames["PAWLTransList"].location=wllnk;
	//parent.frames["PAWLTransList"].location="websys.default.csp?WEBSYS.TCOMPONENT=PAWaitingListInquiry.List&PatientID=&+="+speciality+"&HospDesc="+hosp+"&CareProvDesc="+consult+"&ListTypeDesc="+waittype+"&HiddenFindParam=" + HiddenFindParam;
}

function WLTypeLookUpHandler(str) {
 	var lu = str.split("^");
	var obj;
	// SA 10.12.01: Function to default Department and Doctor if one 
	// is associated with the Waiting List Type selected.
	if (lu[2]!="") {
		obj=document.getElementById("OldSpecialty");
		if (obj) obj.value = lu[2];
	}
	if (lu[3]!="") {
		obj=document.getElementById("OldConsult");
		if (obj) obj.value = lu[3];
	}
	if (lu[4]!="") {
		obj=document.getElementById("HOSPDesc");
		if (obj) obj.value = lu[4];
	}
}

function StatusLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('StatusDesc');
	if (obj) obj.value = lu[1];
	var obj=document.getElementById("StatusCode");
	if (obj) obj.value = lu[0];
}

function LocLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('OldSpecialty');
	if (obj) obj.value = lu[1];
}
function HospLookup(str) {
	var lu = str.split("^");
	var obj=document.getElementById("HospID");
	if (obj) obj.value=lu[1];
}
document.body.onload=BodyLoadHandler;