// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
//W650
function BodyLoadHandler() {
	var objGroupBatch=document.getElementById("GroupBatch");
	if (objGroupBatch) objGroupBatch.onclick=Open3MGrouper;
	var objUnGroupBatch=document.getElementById("UngroupBatch");
	if (objUnGroupBatch) objUnGroupBatch.onclick=UngroupBatchHandler;
	// RQG 14.08.03 L32803
	var objGroupBatchVisasys=document.getElementById("GroupBatchVisasys");
	if (objGroupBatchVisasys) objGroupBatchVisasys.onclick=OpenVisGrouper;
}

function Open3MGrouper() {

	if (!CheckDates()) {
		return false;
	}

	var ReadyToBatch=1;
	ReadyToBatch=confirm(t['TIME_WARNING']+"\n"+t['OK_START']);
	if (!ReadyToBatch) {		
		return false;
	}

	var objMode=document.getElementById("Mode");

	var objDateFrom=document.getElementById("DischargeDateFrom");
	var objDateTo=document.getElementById("DischargeDateTo");
	var objPayor=document.getElementById("Payor");
	var objPAADMVerified=document.getElementById("PAADMVerified");
	var objDRGPath=document.getElementById("DRGPath");
	var objShowAdmWithDRGCodes=document.getElementById("ShowAdmWithDRGCodes");
	var objBatchEpisodesCount=document.getElementById("BatchEpisodesCount");
	var objBatchFailCount=document.getElementById("BatchFailCount");
	var objBatchGroupMsg=document.getElementById("BatchGroupMsg");
	var objDRGGrouperVersion=document.getElementById("DRGGrouperVersion");
	var objDRGGrouperVersionID=document.getElementById("DRGGrouperVersionID");
	
	var DateFrom="";
	var DateTo="";
	var Payor="";
	var PAADMVerified="";
	var DRGPath="";
	var ShowAdmWithDRGCodes="";	
	var DRGGrouperVersionID="";	

	if (objMode) objMode.value="BATCH";
	if (objDateFrom) DateFrom=objDateFrom.value;
	if (objDateTo) DateTo=objDateTo.value;
	if (objPayor) Payor=objPayor.value;
	if (objPAADMVerified) PAADMVerified=objPAADMVerified.value;
	if (objDRGPath) DRGPath=objDRGPath.value;
	
	if ((objShowAdmWithDRGCodes)&&(objShowAdmWithDRGCodes.checked)) {
		ShowAdmWithDRGCodes="Y";
	} else {
		ShowAdmWithDRGCodes="N";
	}
	
	var objBatchFailCount=document.getElementById("BatchFailCount");
	if (objBatchFailCount) objBatchFailCount.value="1";
	if (objBatchGroupMsg) objBatchGroupMsg.value="";
	
	if ((objDRGGrouperVersion) && (objDRGGrouperVersion.value!="")) DRGGrouperVersionID=objDRGGrouperVersionID.value
	
	//;;KK 31/Mar/2004 L:37859
	var url="paadmcoding.findbatch.group.csp?mode=BATCH&dischdatefr="+DateFrom+"&dischdateto="+DateTo+"&payor="+Payor+"&verified="+PAADMVerified+"&showadmwithdrgcodes="+ShowAdmWithDRGCodes+"&drgpath="+DRGPath+"&DRGGrouperVersionID="+DRGGrouperVersionID;
	
	SubmitBeforeGrouper(url);    

	//CheckJobStatus(); // AJI 37859
	
	//return GroupBatch_click();

	return false;
	
	
	// RQG 15.11.02 Log27337: The batch grouping will now call "PAAdmCoding.Execute3MGrouper"
	// Link item "GroupBatch" is now changed to a button and the ff. codes are not needed.
	// SA 16.3.02 - implemented for log 23706.
	/***
	var url="websys.default.csp?WEBSYS.TCOMPONENT=PAAdmCoding.Edit3MDRG";
	// RQG 04.11.02 - Implemented "Mode" field in replacement to EpisodeID
	//url += "&EpisodeID=BATCH&DischargeDateFrom="+DateFrom+"&DischargeDateTo="+DateTo;
	url += "&Mode=BATCH&DischargeDateFrom="+DateFrom+"&DischargeDateTo="+DateTo;
	url += "&Payor="+Payor+"&PAADMVerified="+PAADMVerified;
	url += "&ShowAdmWithDRGCodes="+ShowAdmWithDRGCodes+"&DRGPath="+DRGPath;
	//alert("url="+url);
	//return false;
	websys_createWindow(url,"TRAK_hidden");
	***/

}

function OpenVisGrouper() {

	// L32803
	var objGrouperType=document.getElementById("GrouperType");
	if (objGrouperType) objGrouperType.value="Visasys";
	
	if (!CheckDates()) {
		return false;
	}

	var ReadyToBatch=1;
	ReadyToBatch=confirm(t['TIME_WARNING']+"\n"+t['OK_START']);
	if (!ReadyToBatch) {
		return false;
	}
	var objMode=document.getElementById("Mode");

	var objDateFrom=document.getElementById("DischargeDateFrom");
	var objDateTo=document.getElementById("DischargeDateTo");
	var objPayor=document.getElementById("Payor");
	var objPAADMVerified=document.getElementById("PAADMVerified");
	var objDRGPath=document.getElementById("DRGPath");
	var objShowAdmWithDRGCodes=document.getElementById("ShowAdmWithDRGCodes");
	var objBatchEpisodesCount=document.getElementById("BatchEpisodesCount");
	var objBatchFailCount=document.getElementById("BatchFailCount");

	var DateFrom="";
	var DateTo="";
	var Payor="";
	var PAADMVerified="";
	var DRGPath="";
	var ShowAdmWithDRGCodes="";	
	if (objMode) objMode.value="BATCH";
	if (objDateFrom) DateFrom=objDateFrom.value;
	if (objDateTo) DateTo=objDateTo.value;
	if (objPayor) Payor=objPayor.value;
	if (objPAADMVerified) PAADMVerified=objPAADMVerified.value;
	if (objDRGPath) DRGPath=objDRGPath.value;
	
	if ((objShowAdmWithDRGCodes)&&(objShowAdmWithDRGCodes.checked)) {
		ShowAdmWithDRGCodes="Y";
	} else {
		ShowAdmWithDRGCodes="N";
	}
		
	return GroupBatchVisasys_click();
}

function CheckDates() {
	// SA: The cache function called will do all the date from/to validation
	// This function will just check that the mandatory fields have been filled.

	var from=document.getElementById("DischargeDateFrom");
	var to=document.getElementById("DischargeDateTo");
	var today=document.getElementById("DateToday");

	if ((from)&&(from.value=="")) {
		if ((to)&&(to.value=="")) {
			alert(t['DATE_FROM_BLANK']+"\n"+t['DATE_TO_BLANK']);
		} else {
			alert(t['DATE_FROM_BLANK']);
		}
		return false;
	}

	if ((to)&&(to.value=="")) {
		alert(t['DATE_TO_BLANK']);
		return false;
	}

	// RQG 16.09.03 L32801: Change the code below to call the new date function
	//var fromdt=SplitDateStr(from.value)
	//var todt=SplitDateStr(to.value)
	//var todaydt=SplitDateStr(today.value)
	//alert(to.value)
	//var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
	//var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
	//var dttoday=new Date(todaydt["yr"], todaydt["mn"]-1, todaydt["dy"]);
	//if ((to)&&(from)) {
	//	if (dtto< dtfrom) {
	//		alert(t['DATE_ERROR']);
	//		return false;
	//	}
	//	
	//	if (dttoday < dtto) {
	//		alert(t['NO_FUTURE_DATES']);
	//		return false;
	//	}		
	//}


	var compstr="";

	if ((to) && (to.value!="") && (from) && (from.value!="")) {
		//alert(to.value+"  "+from.value);
		compstr = DateStringCompare(to.value,from.value);
		//alert("ok");
	}
	if (compstr == -1) {
	// To-Date is less than From-Date
		alert(t['DATE_ERROR']);
		return false;
	}
	compstr="";
	//if ((today) && (to) && (today.value!="") && (to.value!="")) compstr = DateStringCompare(today.value,to.value);
	if (compstr == -1) {
	// Todays Date is less than To-Date
		alert(t['NO_FUTURE_DATES']);
		return false;
	}

	return true;
}

//KK 6/May/2003 Log 34531
function UngroupBatchHandler() {
	var bOKToUngroup=1;
	bOKToUngroup=confirm(t['UNGROUP_BATCH']);
	//alert(bOKToUngroup);
	if (!bOKToUngroup) {
		return false;
	} else {
		return UngroupBatch();
	}
}





// cjb 27/10/2005 43304 - copied from grouper
function UngroupBatch() {

	if (!CheckDates()) {
		return false;
	}

	var objMode=document.getElementById("Mode");

	var objDateFrom=document.getElementById("DischargeDateFrom");
	var objDateTo=document.getElementById("DischargeDateTo");
	var objPayor=document.getElementById("Payor");
	var objPAADMVerified=document.getElementById("PAADMVerified");
	var objDRGPath=document.getElementById("DRGPath");
	var objShowAdmWithDRGCodes=document.getElementById("ShowAdmWithDRGCodes");
	var objBatchEpisodesCount=document.getElementById("BatchEpisodesCount");
	var objBatchUnGroupMsg=document.getElementById("BatchUnGroupMsg");

	var DateFrom="";
	var DateTo="";
	var Payor="";
	var PAADMVerified="";
	var DRGPath="";
	var ShowAdmWithDRGCodes="";	

	if (objMode) objMode.value="BATCH";
	if (objDateFrom) DateFrom=objDateFrom.value;
	if (objDateTo) DateTo=objDateTo.value;
	if (objPayor) Payor=objPayor.value;
	if (objPAADMVerified) PAADMVerified=objPAADMVerified.value;
	if (objDRGPath) DRGPath=objDRGPath.value;
	
	if ((objShowAdmWithDRGCodes)&&(objShowAdmWithDRGCodes.checked)) {
		ShowAdmWithDRGCodes="Y";
	} else {
		ShowAdmWithDRGCodes="N";
	}

	if (objBatchUnGroupMsg) objBatchUnGroupMsg.value="";
	//;;KK 31/Mar/2004 L:37859
	var url="paadmcoding.findbatch.ungroup.csp?mode=BATCH&dischdatefr="+DateFrom+"&dischdateto="+DateTo+"&payor="+Payor+"&verified="+PAADMVerified+"&showadmwithdrgcodes="+ShowAdmWithDRGCodes+"&drgpath="+DRGPath;
	
	SubmitBeforeUnGrouper(url);    

	return false;

}





// AJI:37859 ;;KK 31/Mar/2004 L:37859
function CheckJobStatus() {
	var objBatchGroupMsg=document.getElementById("BatchGroupMsg");
	if ((objBatchGroupMsg)&&(objBatchGroupMsg.value!="")) return false;
	var timerID = null;
	var DELAY = 5000;
	var link = "checkbatchgroup.csp";   
	websys_createWindow(link,"TRAK_hidden");

	timerID = self.setTimeout("CheckJobStatus()", DELAY);
}

//;;KK 31/Mar/2004 L:37859
function SubmitBeforeGrouper(url) {
	var frm=document.forms["fPAAdmCoding_FindBatch"];
	if (frm) {
		//frm.target="TRAK_hidden"; frm.action="paadmcoding.findbatch.group.csp";
		frm.target="TRAK_hidden"; frm.action=url;
		if (frm.TEVENT) frm.TEVENT.value="fPAAdmCoding_FindBatch";
		frm.submit();
	}
	//frm.target=window.name
	window.setTimeout("CheckJobStatus()",2000);
}

// cjb 27/10/2005 43304 - copied from grouper
function CheckJobStatusUnGrouper() {
	var objBatchUnGroupMsg=document.getElementById("BatchUnGroupMsg");
	if ((objBatchUnGroupMsg)&&(objBatchUnGroupMsg.value!="")) return false;
	var timerID = null;
	var DELAY = 5000;
	var link = "checkbatchungroup.csp";   
	websys_createWindow(link,"TRAK_hidden");

	timerID = self.setTimeout("CheckJobStatusUnGrouper()", DELAY);
}

function SubmitBeforeUnGrouper(url) {
	var frm=document.forms["fPAAdmCoding_FindBatch"];
	if (frm) {
		frm.target="TRAK_hidden"; frm.action=url;
		if (frm.TEVENT) frm.TEVENT.value="fPAAdmCoding_FindBatch";
		frm.submit();
	}
	window.setTimeout("CheckJobStatusUnGrouper()",2000);
}

// cjb 30/06/2006 56092
function LookUpDRGGrouperVersionSelect(str){
	var lu=str.split("^");
	var obj=document.getElementById("DRGGrouperVersionID");
	
	if (obj) obj.value=lu[1];
}


document.body.onload=BodyLoadHandler;
