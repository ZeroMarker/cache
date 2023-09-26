// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var lobj=document.getElementById("LocDesc");
var robj=document.getElementById("RequestedFrom");
function ReasLookUpHandler(txt) {
	var adata=txt.split("^");
	var ReasonDesc=adata[0];
	var robj=document.getElementById("ReasForRequest");
	if (robj) robj.value=ReasonDesc;
}

function HospLookup(txt) {
	var adata=txt.split("^");
	var HospID=adata[1];
	var OrigHospVal="";
	var hobj=document.getElementById("hospID");
	if (hobj) {
		OrigHospVal=hobj.value;
		hobj.value=HospID;
	}
	if(OrigHospVal!=HospID) {
		var obj=document.getElementById("LocDesc");
		if (obj) obj.value="";
		var obj=document.getElementById("RequestedFrom");
		if (obj) obj.value="";
		var obj=document.getElementById("CurrLoc");
		if (obj) obj.value="";
	}
}

function LookUpSelCurrLoc(txt) {
	var adata=txt.split("^");
	var LocDesc=adata[0];
	var LocID=adata[1];
	txt=LocDesc+"^"+LocID;
	var lobj=document.getElementById("CurrLoc");
	if (lobj) lobj.value=LocDesc;
}
function LookUpSelReqFrom() {
	// Commented out for Log 40131
	//if (robj!="") {
	//	if (lobj) lobj.value="";
	//}
}

function LookUpSelLoc(txt) {
	// Commented out for Log 40131
	//if (lobj!="") {
	//	if (robj) robj.value="";
	//}
	var adata=txt.split("^");
	var LocDesc=adata[0];
	var LocID=adata[1];
	var lobj=document.getElementById("LocDesc");
	if (lobj) lobj.value=LocDesc;
}

function ChangeStatusHandler(str) {
	var lu=str.split("^");
	var sobj=document.getElementById("Status");
	if (sobj) sobj.value=lu[1];
}
function SelectRowHandler(e) {
	var eSrc=websys_getSrcElement(e);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var arry=eSrc.id.split("z");
	rowsel=arry[arry.length-1];

	var elementID="rtmasz"+rowsel;
	var elValObj=document.getElementById(elementID);
	var wintop=window.top;
	var winf=top.frames['eprmenu'];
	if (winf) {
		wintop.document.elementID=elementID;
		if (elValObj) wintop.document.elementValue=elValObj.innerText;
	}
	var vobj=document.getElementById("volFlagz"+rowsel);
	if ((eSrc.id=="Movez"+rowsel)||(eSrc.id=="Receivedz"+rowsel)) return checkVolume(vobj,eSrc);
}
function CancelAllClickHandler(){
	//alert("hello ")
	var IDs=""; var MasVolIDs=""; var ReqStatus=""; var ReqVolumeIDs=""; var PatientIDs="";
	var caObj=document.getElementById("CancelAll");
	if (listTbl) {
		for (var i=1; i<listTbl.rows.length; i++) {
			var rtObj=document.getElementById("rtmasz"+i);
			if (rtObj) IDs=IDs+rtObj.innerText+",";
			var mvObj=document.getElementById("ReqVolIdsz"+i);
			if (mvObj) MasVolIDs=MasVolIDs+mvObj.value+",";
			var rvObj=document.getElementById("DelVolIdsz"+i);
			if (rvObj) ReqVolumeIDs=ReqVolumeIDs+rvObj.value+",";
			var rsObj=document.getElementById("Statusz"+i);
			if (rsObj) ReqStatus=ReqStatus+rsObj.innerText+",";
			var pidObj=document.getElementById("PatientIDz"+i);
			if (pidObj) PatientIDs=PatientIDs+pidObj.value+",";
		}
	}
	//if (caObj) var url=caObj.href;
	//alert("PatientIDs="+PatientIDs)
	var url="websys.default.csp?WEBSYS.TCOMPONENT=RTRequest.Cancel&IDs="+IDs+"&MasVolIDs="+MasVolIDs+"&ReqStatus="+ReqStatus+"&ReqVolumeIDs="+ReqVolumeIDs+"&PatientIDs="+PatientIDs+"&SelectAll=1";
	//alert("url "+url);
	websys_lu(url,false,"");
	return false;
	//alert("caObj.href"+caObj.href);
	//if (url!="") url=url+"&IDs="+IDs+"&MasVolIDs="+MasVolIDs+"&ReqStatus="+ReqStatus+"&ReqVolumeIDs="+ReqVolumeIDs+"&PatientID="+PatientIDs;
	//alert("url "+url);
	//if (caObj) caObj.href=url;
	//var url="websys.Default.csp?WEBSYS.TCOMPONENT=RTRequest.Cancel&IDs="+IDs+"&MasVolIDs="+MasVolIDs+"&ReqStatus="+ReqStatus+"&ReqVolumeIDs="+ReqVolumeIDs+"&PatientID="+PatientIDs;
}
function checkVolume(vobj,lnkobj) {
		var text=vobj.value;
		//alert(text);
		var pattern=new RegExp(text,"i");
		if ((vobj)&&(pattern.test("novolume"))) {
		//alert("here1");
			if (lnkobj.id=="Receivedz"+rowsel) alert(t['Rec_VolCheck']);
			if (lnkobj.id=="Movez"+rowsel) alert(t['Volume_Check']);
		} else {
			//alert("here2");
			var url=lnkobj.href;
			// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
			websys_createWindow(url,"MOVE","height=400,width=600,left=120,top=120,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
		}
		return false;
}
var pullobj=document.getElementById("PullingDateFrom");
if (pullobj) pullobj.focus();

//creates multiple links within the same column.
function SetMultipleLinks() {
	// Log 59598 - BC - 29-06-2006 : Change statusbar variable (status=) to display the status bar (=yes).
	var newwinparams='height=400,width=600,left=120,top=120,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes';
	for (var i=1; i<listTbl.rows.length; i++) {
		//Creates links for current location
		var lnkCurrLoc=document.getElementById('tblCurrLocz'+i);
		if ((lnkCurrLoc)&&(lnkCurrLoc.innerHTML!="")) {
			var arrReqIDs=document.getElementById("ReqVolIdsz"+i).value.split(',');
			var arrlocs=lnkCurrLoc.innerHTML.split(',');
			var parentobj=websys_getParentElement(lnkCurrLoc);
			for (j=1; j<arrlocs.length; j++) {
				var lnknew=lnkCurrLoc.cloneNode(true);
				lnknew.innerHTML=arrlocs[j];
				//nb: cloning doesn't seem to copy the href property correctly... use the lnkCurrLoc.href property instead
				lnknew.href = "javascript:websys_lu('"+lnkCurrLoc.href+"&ReqVolIds="+arrReqIDs[j]+"');";
				lnknew=parentobj.appendChild(lnknew);
			}
			lnkCurrLoc.innerHTML=arrlocs[0];
			lnkCurrLoc.href = "javascript:websys_lu('"+lnkCurrLoc.href+"&ReqVolIds="+arrReqIDs[0]+"');";
		}
		//creates links for volume desc???
	}
}


var listTbl=document.getElementById("tRTRequest_FindMRRequest");
//if (listTbl) listTbl.onclick=SelectRow1;
if (listTbl) SetMultipleLinks();
//ANA This has been put back in. It may not seem like its doing much, However this is being called from the createrequest.csp.So DO NOT DELETE again! Thanks!
function FindClickHandler() {
	//log 31295; AmiN;  must fill(Both RequiredDateFrom & RequiredDateTo ) or ( Both RequestDateFrom & RequestDateTo )
	//log 38027; PeterC above condition as well as or ( Both PullingDateFrom & PullingDateTo )
	var RequiredDateFromObj=document.getElementById("RequiredDateFrom");
	var RequiredDateToObj=document.getElementById("RequiredDateTo");

	var RequestDateFromObj=document.getElementById("RequestDateFrom");
	var RequestDateToObj=document.getElementById("RequestDateTo");

	PullingDateFromObj=document.getElementById("PullingDateFrom");
	PullingDateToObj=document.getElementById("PullingDateTo");

	var InitLogOnFindObj=document.getElementById("InitLogOnFind");
	if(InitLogOnFindObj) InitLogOnFindObj.value="N";


	// LOG 41845 RC 15/01/04 Had to comment this out because the didn't require the date objects to be mandatory anymore
	// 						 But thought to leave it here, just in case...
	/*if ((RequiredDateFromObj) && (RequiredDateToObj)) {
		if ((RequiredDateFromObj.value!="") && (RequiredDateToObj.value!="")) return Find1_click();
	}

	if ((RequestDateFromObj) && (RequestDateToObj)) {
		if ((RequestDateFromObj.value!="") && (RequestDateToObj.value!="")) return Find1_click();
	}

	if ((PullingDateFromObj) && (PullingDateToObj)) {
		if ((PullingDateFromObj.value!="") && (PullingDateToObj.value!="")) return Find1_click();
	}

	alert(t['DateMandatory']);
	return false;*/

	return Find1_click();

}

var fobj=document.getElementById("Find1");
if (fobj) fobj.onclick=FindClickHandler;
/*function BodyLoadHandler() {

	if (tsc['Find1']) {
		websys_sckeys[tsc['Find1']]=FindClickHandler;
	}
}*/
function BodyLoadHandler() {
	//moved to table.onclick
	//document.onclick=SelectRow;
	// ANA 08.05.02 This is to highlight the previously selected row when the page is refreshed.
	var win=window.top;
	var winf=top.frames['eprmenu'];
	var elementID="";
	var elementValue="";
	if (winf) {
		elementID=win.document.elementID
		elementValue=win.document.elementValue;
	}
	var caObj=document.getElementById("CancelAll");
	if (caObj) caObj.onclick=CancelAllClickHandler;
	if (listTbl)	{
		for(var i=1;i<listTbl.rows.length;i++) {
			var rtvalue="";
			var RowHexColour=""
			RowHexColour=document.getElementById("ReasonColorz"+i);

			//for (var CurrentCell=0; CurrentCell<tbl.rows[i].cells.length; CurrentCell++) {
			if ((RowHexColour)&&(RowHexColour.value!="")) {
				//listTbl.rows[i].style.backgroundColor="#"+RowHexColour.value;
				//PeterC 25/07/05: Commented out the below 2 lines and added in the third line
				//var clsname=AddReasonStyleClass(RowHexColour.value);
				//listTbl.rows[i].className = clsname;
				tbl.rows[i].style.backgroundColor="#"+RowHexColour.value;
			}
			//}
			var rtobj=document.getElementById("rtmasz"+i);
			if (rtobj) rtvalue=rtobj.innerText;
			if (rtvalue==elementValue) {
				if (elementID!="") HighlightRow_OnLoad(elementID);
				//break;
			}
		}

	}
	var obj=document.getElementById("LocDesc");
	if ((obj)&&(obj.value!="")&&(obj.onchange)) obj.onchange();
	var obj=document.getElementById("RequestedFrom");
	if ((obj)&&(obj.value!="")&&(obj.onchange)) obj.onchange();
	if (tsc['Find1']) {
		websys_sckeys[tsc['Find1']]=FindClickHandler;
	}
	var sfObj=document.getElementById("SearchPref");
	var hsfobj=document.getElementById("HasSearchPref");
	if ((hsfobj)&&(hsfobj.value!="")&&(sfObj)) sfObj.style.fontWeight="bold";
	if (self==top) websys_reSizeT();
	var MRTNobj=document.getElementById("MRRtnDate");
	var DOHLobj=document.getElementById("DaysOutHomeLoc");
	if((MRTNobj)&&(DOHLobj)) {
		MRTNobj.onblur=InactivateField;
		DOHLobj.onblur=InactivateField;
		if((MRTNobj)&&(MRTNobj.value!="")) DisableField("DaysOutHomeLoc","");
		if((DOHLobj)&&(DOHLobj.value!="")) DisableField("MRRtnDate","ld982iMRRtnDate");
	}
	var ostobj=document.getElementById("OutStdingMR");
	if((ostobj)&&(ostobj.value=="Y")) {
		if (listTbl){
			for(var i=1;i<listTbl.rows.length;i++) {
				var mvobj=document.getElementById("Movez"+i);
				if(mvobj) mvobj.onclick=MoveVolumeHandler;
			}
		}
	}
}

//Log 61696 PeterC 24/11/06
function MoveVolumeHandler(evt) {
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var row=rowObj.rowIndex;
	if(row==0) {
		return false;
	}
	var MasVolID="";
	var PatientID="";
	var mvobj=document.getElementById("Movez"+row);
	var vobj=document.getElementById("ReqVolIdsz"+row);
	if((vobj)&&(vobj.value!="")) MasVolID=vobj.value;
	var pobj=document.getElementById("PatientIDz"+row);
	if((pobj)&&(pobj!="")) PatientID=pobj.value;
	var url="websys.default.csp?WEBSYS.TCOMPONENT=RTVolume.Move&MasVolID="+MasVolID+"&PatientID="+PatientID;
	if(mvobj) mvobj.href=url;

}

function InactivateField() {
	var MRTNobj=document.getElementById("MRRtnDate");
	var DOHLobj=document.getElementById("DaysOutHomeLoc");

	if((MRTNobj)&&(MRTNobj.value!="")) DisableField("DaysOutHomeLoc","");
	if((DOHLobj)&&(DOHLobj.value!="")) DisableField("MRRtnDate","ld982iMRRtnDate");

	if((MRTNobj.value=="")&&(DOHLobj.value=="")) {
		EnableField("DaysOutHomeLoc","");
		EnableField("MRRtnDate","ld982iMRRtnDate");
	}
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

function EnableField(fldName,icN) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.disabled = false;
	}
	if (icN) {
		var objIcon=document.getElementById(icN);
		if (objIcon) objIcon.style.visibility = "";
	}

}

function refreshing(win) {
	if (win) {
		var formRad=win.document.forms['fRTRequest_FindMRRequest'];
		if (formRad) {
			//alert("Here1");
			// ANA Using the URl looses workflow.
			win.treload('websys.csp');
		}
	} else if (window) {
		//alert("Here2");
		//should be from epr chart csp page
		window.history.go(0);
	}
}

function CancelBulkRequest() {
	//alert("Testing");
	var IDs=""; var MasVolIDs=""; var ReqStatus=""; var ReqVolumeIDs=""; var PatientIDs="";
	var RequiredDateTo="";
	var caObj=document.getElementById("CancelAll");
	if (listTbl) {
		for (var i=1; i<listTbl.rows.length; i++) {
			var PAobj=document.getElementById("Selectz"+i);
			if ((PAobj) &&(PAobj.checked==true))
			{
				var rtObj=document.getElementById("rtmasz"+i);
				if (rtObj) IDs=IDs+rtObj.innerText+",";
				var mvObj=document.getElementById("ReqVolIdsz"+i);
				if (mvObj) MasVolIDs=MasVolIDs+mvObj.value+",";
				var rvObj=document.getElementById("DelVolIdsz"+i);
				if (rvObj) ReqVolumeIDs=ReqVolumeIDs+rvObj.value+",";
				var rsObj=document.getElementById("Statusz"+i);
				if (rsObj) ReqStatus=ReqStatus+rsObj.innerText+",";
				var pidObj=document.getElementById("PatientIDz"+i);
				if (pidObj) PatientIDs=PatientIDs+pidObj.value+",";
			}
		}
	}
	if (MasVolIDs.length==0) {

		var rdObj=document.getElementById("RequiredDateTo");
		if ((rdObj)&&(rdObj.value!="")) RequiredDateTo=rdObj.value
		//alert("Require Date Passed "+RequiredDateTo);
		var url="websys.default.csp?WEBSYS.TCOMPONENT=RTRequest.Cancel&RequestDateTo="+RequiredDateTo+"&ReqDateMandatory=Y";
		// Log 59598 - BC - 29-06-2006 : Change statusbar variable (status=) to display the status bar (=yes).
		websys_lu(url,false,"height=400,width=600,left=120,top=120,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
		return false;
	}
	var url="websys.default.csp?WEBSYS.TCOMPONENT=RTRequest.Cancel&IDs="+IDs+"&MasVolIDs="+MasVolIDs+"&ReqStatus="+ReqStatus+"&ReqVolumeIDs="+ReqVolumeIDs+"&PatientIDs="+PatientIDs+"&SelectAll=1";
	// Log 59598 - BC - 29-06-2006 : Change statusbar variable (status=) to display the status bar (=yes).
	websys_lu(url,false,"height=400,width=600,left=120,top=120,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
	return false;
}

//BM Log 34846
function RTReqItemIDsGetSelected(frm,rowlastclicked) {
	//alert("in RTReqItemIDsGetSelected");
	var arrRTReqItemIDs=new Array();
	arrRTReqItemIDs["ReqID"]="";
	arrRTReqItemIDs["VolID"]="";
	arrRTReqItemIDs["firstSelected"]="";
	var RTReqIDs="";
	var RTPatIDs="";
	var RTReqVolIDs="";
	var tbl=document.getElementById("tRTRequest_FindMRRequest");
	if (tbl) {
		for (var i=1;i<tbl.rows.length;i++) {
			var sObj=document.getElementById("Selectz"+i);
			if ((sObj) && (sObj.checked) && (!sObj.disabled)) {
				RTReqIDs=RTReqIDs+document.getElementById("DelVolIdsz"+i).value+"^";
				RTReqVolIDs=RTReqVolIDs+document.getElementById("ReqVolIdsz"+i).value+"^";
				if (arrRTReqItemIDs["firstSelected"]=="") arrRTReqItemIDs["firstSelected"]=i;
				/*
				var vfobj=document.getElementById("volFlagz"+i);
				var pattern=new RegExp(vfobj.value,"i");
				if ((vfobj)&&(pattern.test("novolume"))) {
					alert(t['Empty_Volume']);
					sObj.checked=false;
				}
				else {
					RTReqIDs=RTReqIDs+document.getElementById("DelVolIdsz"+i).value+"^";
					RTReqVolIDs=RTReqVolIDs+document.getElementById("ReqVolIdsz"+i).value+"^";
				}
				*/
				//RTPatIDs=RTPatIDs+document.getElementById("PatientIDz"+i).value+"^";
			}
		}
		arrRTReqItemIDs["ReqID"]=RTReqIDs;
		arrRTReqItemIDs["VolID"]=RTReqVolIDs;
	}
	//alert("RTReqIDs="+RTReqIDs+RTPatIDs+"  RTReqVolIDs="+RTReqVolIDs);
	if (RTReqIDs=="" && RTReqVolIDs=="") {
		if (tbl.rows[rowlastclicked].className=='clsRowSelected') {
			if (arrRTReqItemIDs["firstSelected"]=="") arrRTReqItemIDs["firstSelected"]=rowlastclicked;
		}
	}
	return arrRTReqItemIDs
}

function ClearOnMultipleSelection(objRow,winf) {
	//alert ("ClearOnMultipleSelection");
	var tbl=getTable(objRow);
	var frm=getFrmFromTbl(tbl);
	var arrIDs=RTReqItemIDsGetSelected(frm,1);
	//if ((frm)&&(arrIDs.length)) {
	if (frm) {
		var row=arrIDs["firstSelected"];
		EPR_SelectEpisodeDetails(frm,row,winf);
	}
}

document.body.onload=BodyLoadHandler;


function AddReasonStyleClass(colour) {
	//alert("in AddReasonStyleClass");
	var clsname="Reason"+colour;
	var cssname="."+clsname;
	var params="background-color:#"+colour+";"
	tk_AddStyleRule(cssname,params);
	return clsname;
}

//Log 53950 21-09-2006 Boc: add function to handler Acknowledge Multiple (selected) Requests and Acknowledge All Requests for the Page 
function AckMultiReqHandler() {
	var rowIndex,reqvolid;
	var reqvolid="";
	var ReqStatus="";
	var eSrc=websys_getSrcElement();
	var tbl=getTableName(eSrc);
	var frm=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(frm,tbl,"Selectz");
	if (aryfound.length==0) {
		alert (t['NOITEMSSELECTED']);
		return false;
	}
	for (j=0;j<aryfound.length;j++ ) {
		rowIndex=aryfound[j]
		reqvolid=reqvolid+frm.elements["DelVolIdsz"+rowIndex].value+"^";
		if (document.getElementById("Statusz"+rowIndex)){
			ReqStatus=ReqStatus+document.getElementById("Statusz"+rowIndex).innerText+"^";
		}
		//PatientID=frm.elements["PatientIDz"+rowIndex].value;
	}
	//alert (reqvolid+"\n"+ReqStatus);
	var url="rtrequest.acknowledge.csp?&reqvolid="+reqvolid+"&ReqStatus="+ReqStatus;
    websys_createWindow(url,"");
}

function AckAllReqHandler() {
	var rowIndex,reqvolid;
	var reqvolid="";
	var ReqStatus="";
	var eSrc=websys_getSrcElement();
	var tbl=getTableName(eSrc);
	var frm=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var tbLen=tbl.rows.length;
	for (j=1;j<tbLen;j++ ) {
		rowIndex=j
		reqvolid=reqvolid+frm.elements["DelVolIdsz"+rowIndex].value+"^";
		if (document.getElementById("Statusz"+rowIndex)){
			ReqStatus=ReqStatus+document.getElementById("Statusz"+rowIndex).innerText+"^";
		}
		//PatientID=frm.elements["PatientIDz"+rowIndex].value;
	}
	//alert (reqvolid+"\n"+ReqStatus);
	var url="rtrequest.acknowledge.csp?&reqvolid="+reqvolid+"&ReqStatus="+ReqStatus;
    websys_createWindow(url,"");
}
//end of log 53950

//Log 61205 5-10-2006 BoC: add select all handler
var sobj=document.getElementById("SelectAll");
if (sobj) sobj.onclick=SelectAll;

function SelectAll() {
	var arrReqIDs=new Array();
	var RTReqIDs="";
	var RTReqVolIDs="";
	var tbl1=document.getElementById("tRTRequest_FindMRRequest");
	var ReqItemID="";
	var ReqVolID="";
	var winf = null;
	if (window.top != window.self) winf = window.top;
	if (tbl1) {
		for (i=1; i<tbl1.rows.length; i++) {
			var sobj=document.getElementById("Selectz"+i);
			if ((sobj) && (sobj.disabled==false) ) {
				//sobj.click();
				sobj.checked=true;
				RTReqIDs=RTReqIDs+document.getElementById("DelVolIdsz"+i).value+"^";
				RTReqVolIDs=RTReqVolIDs+document.getElementById("ReqVolIdsz"+i).value+"^";
			}
		}
	}
	//alert (RTReqIDs+"\n"+RTReqVolIDs);
	arrReqIDs["ReqID"]=RTReqIDs;
	arrReqIDs["VolID"]=RTReqVolIDs;
	ReqItemID=arrReqIDs["ReqID"];
	ReqVolID=arrReqIDs["VolID"];
	if (winf) {
		if (winf.frames["eprmenu"]) {
			winf.frames["eprmenu"].MENU_TRELOADPAGE=winf.frames["TRAK_main"].TRELOADPAGE;
			winf.frames["eprmenu"].MENU_TRELOADID=winf.frames["TRAK_main"].TRELOADID;
		}
		try {
			//patID,episID,mradm,titleName,apptID,waitinglistID,OEOrdItemIDs,SinglePatientFlag,WardID,PAAdmCodingID,multipleIDs,OEORIItemStatus,BillRowIds,BillTypes,wlstatus,ARCIMDesc,FollowUpApptID,ItemApptStatus,Decease,ReqIDs,ReqVolIDs,canGiveBirth,MultiEpisodeID,OperRoomID,AnaesthesiaID,NokID
			winf.SetEpisodeDetails("","","","","","","","","","","","","","","","","","","",ReqItemID,ReqVolID,"","","","","");
		} catch(e) {}
	}
}