// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


document.body.onload = Init;

function Init(){
	obj=document.getElementById('ANAOPOpStartDate');
	if (obj) obj.onblur=DoOpStartDateVal;

	obj=document.getElementById('ANAOPOpEndDate');
	if (obj) obj.onblur=DoOpFinishDateVal;

	obj=document.getElementById('ANAOPOpStartTime');
	if (obj) obj.onblur=DoOpStartTimeVal;

	obj=document.getElementById('ANAOPOpEndTime');
	if (obj) obj.onblur=DoOpFinishTimeVal;

	obj=document.getElementById('ANAOPStatus');
	if (obj) obj.onblur=DoStatusValidation;

	obj=document.getElementById('SurgPref');
	if (obj) obj.onclick=SurgPrefClickHandler;

	obj=document.getElementById('update');
	if (obj) obj.onclick=UpdateAll;
	if (tsc['update']) websys_sckeys[tsc['update']]=UpdateAll;

	obj=document.getElementById('UpdateClose');
	if (obj) obj.onclick=UpdateCloseAll;
	if (tsc['UpdateClose']) websys_sckeys[tsc['UpdateClose']]=UpdateCloseAll;

	// Log 56034 - GC - 03-05-2006 : Define onblur for ANAOPTorniquetBodySiteDR,ANAOPTorniquetDateFrom,ANAOPTorniquetDateTo,ANAOPTorniquetTimeFrom,ANAOPTorniquetTimeTo
	var obj=document.getElementById('ANAOPTorniquetBodySiteDR');
	if (obj) obj.onblur=ANAOPTorniquetBodySiteDR_ChangeHandler;
	ANAOPTorniquetBodySiteDR_ChangeHandler();

	obj=document.getElementById('ANAOPTorniquetDateFrom');
	if (obj) obj.onblur=DoTorDateFromVal;

	obj=document.getElementById('ANAOPTorniquetDateTo');
	if (obj) obj.onblur=DoTorDateToVal;

	obj=document.getElementById('ANAOPTorniquetTimeFrom');
	if (obj) obj.onblur=DoTorTimeFromVal;

	obj=document.getElementById('ANAOPTorniquetTimeTo');
	if (obj) obj.onblur=DoTorTimeToVal;
	// End Log 56034

	//Log 59307
	var obj=document.getElementById("PROCEntered");
	var obj1=document.getElementById("PROCDescString");
	if ((obj)&&(obj1)&&(obj1.value!="")) {
		PopulateListType(obj1.value,"PROCEntered")
	}
	var obj=document.getElementById("OPEntered");
	var obj1=document.getElementById("OPDescString");
	if ((obj)&&(obj1)&&(obj1.value!="")) {
		PopulateListType(obj1.value,"OPEntered")
	}
	var obj=document.getElementById('DeleteProcedure');
	if (obj) obj.onclick=PROCDeleteClickHandler;
	var obj=document.getElementById('DeleteOperation');
	if (obj) obj.onclick=OPDeleteClickHandler;


	CalcDurations();

	DisableLinks();

	DoStatusValidation();

	InitBoldLinks();

	DoInitStatusValidation();
}



//Disable the Positions link for a new operation
function DisableLinks(){
	var objId = document.getElementById("ID");
	if (objId && objId.value==""){
		var objLink = document.getElementById("PositionLink");
		if (objLink){
			objLink.disabled=true;
			objLink.onclick="";
		}
		var objLink = document.getElementById("StaffLink");
		if (objLink){
			objLink.disabled=true;
			objLink.onclick="";
		}
		var objSurgLink = document.getElementById("SurgPref");
		if (objSurgLink){
			objSurgLink.disabled=true;
			objSurgLink.onclick="";
		}
		var objAnnotImgLink = document.getElementById("AnnotateImage");
		if (objAnnotImgLink){
			objAnnotImgLink.disabled=true;
			objAnnotImgLink.onclick="";
		}
	}
	var SurgOEString = document.getElementById("SurgOEString");
	if (SurgOEString && SurgOEString.value==0){
		var objSurgLink = document.getElementById("SurgPref");
		if (objSurgLink){
			objSurgLink.disabled=true;
			objSurgLink.onclick="";
		}
	}
	var RBOpIDobj=document.getElementById("ANARBOPId");
	if (RBOpIDobj && RBOpIDobj.value=="") {
		var objTBFLink=document.getElementById("TBFormLink");
		if (objTBFLink){
			objTBFLink.disabled=true;
			objTBFLink.onclick="";
		}
	}
}

function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "";
	}
}

function DisableField(fldName) {
	var lbl = ('c'+fldName);
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "clsDisabled";
		if (lbl) lbl = lbl.className = "";
	}
}

function EnableField(fldName) {
	var lbl = ('c'+fldName);
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "";
	}
}

// Log 56034 - GC - 04-05-2006 : Set fldName to blank and make it read only. Blank value gets updated in the database.
function SetReadOnly(fldName) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.value="";
		fld.readOnly=true;
	}
}

function UnsetReadOnly(fldName) {
	var fld = document.getElementById(fldName);
	if (fld) fld.readOnly=false;
}
// End Log 56034

function setBoldLinks(el,state) {
	obj=document.getElementById(el);
	if (obj) {
		if (state==1) {obj.style.fontWeight="bold";}
		else {obj.style.fontWeight="normal";}
	}
}

function InitBoldLinks(){
	var objBold=document.getElementById('BoldLinks');
	if (objBold) {
		var BoldLink = objBold.value.split("^");
		setBoldLinks("PositionLink",BoldLink[0]);
		setBoldLinks("StaffLink",BoldLink[1]);
		setBoldLinks("SurgPref",BoldLink[2]);
		// Log 53870 - AI - 16-11-2005 : The "Post-Op Diagnosis" link.
		setBoldLinks("diagnosis",BoldLink[3]);
		// end Log 53870
		// Log 63746 - EZ - 11-09-2007 : The "Annotation Image" link.
		setBoldLinks("AnnotateImage",BoldLink[4]);
		// end Log 63746
	}
}

//If the status (StatusId) is "A" (cancelled) then, set cancellation reason to mandatory, else set cancellation reason to disabled.
//This is executed when page is loaded and everytime value in ANAOPStatus is changed.
function DoStatusValidation(){
	var objSId = document.getElementById("StatusId");
	var objSts = document.getElementById("ANAOPStatus");
	var objCnclRsn = document.getElementById("ANAOPCancelReason");
	if (objSId && objCnclRsn && objSts){
		//if status is blanked out, set statusid to blank (b/c when status is blanked out lookuphandler is not called and status id retains it's previous value)
		if(objSts.value == ""){
			objSId.value = "";
		}

		if (objSId.value == "A"){
			EnableField("ANAOPCancelReason");
			labelMandatory("ANAOPCancelReason");
		}
		else{
			DisableField("ANAOPCancelReason");
			labelNormal("ANAOPCancelReason");
		}
	}


}

//If the status (StatusId) is "A", then disable all fields.  This is executed on page load.
function DoInitStatusValidation(){
	var objSId = document.getElementById("StatusId");
	if(objSId && (objSId.value == "A" || objSId.value=="D")){
		makeReadOnly();
	}
}

//This function makes fields disabled.
function makeReadOnly() {
	var el=document.forms["fORAnaOperation_Edit"].elements;
	if(!el) {return;}
	for (var i=0;i<el.length;i++) {
		if (!(el[i].type=="hidden")) {
			//if(el[i].id != "update" && el[i].id != "ANAOPStatus" && el[i].id != "ANAOPCancelReason"){
			if(el[i].id != "update"){
				el[i].disabled=true;
			}
		}
	}
	var arrLookUps=document.getElementsByTagName("IMG");
	for (var i=0; i<arrLookUps.length; i++) {
		if ((arrLookUps[i].id)&&(arrLookUps[i].id.charAt(0)=="l")) {
			if(arrLookUps[i].id.indexOf("ANAOPStatus") == -1){
				arrLookUps[i].disabled=true;
			}
		}
	}

	var arrLinks=document.getElementsByTagName("A");
	for (var i=0; i<arrLinks.length; i++) {
		if ((arrLinks[i].id)) {
			var par=websys_getParentElement(arrLinks[i]);
			if ((par)&&(par.id)&&(par.id.indexOf("tbMenu")==0)) continue;
			if(arrLinks[i].id != "Close" && arrLinks[i].id.indexOf("AuditTrailLog") == -1 && arrLinks[i].id.indexOf("AuditTrailData") == -1 && arrLinks[i].id != "PositionLink" && arrLinks[i].id != "StaffLink" && arrLinks[i].id != "SurgPref" && arrLinks[i].id != "AnnotateImage"){
				arrLinks[i].disabled=true;
				arrLinks[i].className="clsDisabled";
				arrLinks[i].onclick=LinkDisabled;
				arrLinks[i].style.cursor='default';
			}
		}
	}
	//58620 RC 21/03/06 Make TextAreas readonly instead, so scrollbars can be used.
	var txtAreas=document.getElementsByTagName("textarea")
	for (var i=0; i<txtAreas.length; i++) {
		if(txtAreas[i].id){
			txtAreas[i].disabled=false;
			txtAreas[i].readOnly=true;
			txtAreas[i].className="clsReadOnly";
		}
	}


	//var obj=document.getElementById("UserCode");
	//if (obj) obj.disabled=false;
	//var obj=document.getElementById("PIN");
	//if (obj) obj.disabled=false;
}

function LinkDisabled() {
	return false;
}


function UpdateAll(){
	// Log 56034 - GC - 03-05-2006 : Logic moved to checkFields()
	if (!checkFields()) return false;

	//Log 47058 - Checkboxes are read as blank when not ticked, so copy the value to a hidden field
	var chkItemsCnt = document.getElementById("ANAOPCountedItems");
	var hItemsCnt = document.getElementById("HItemsCounted");
	if (chkItemsCnt && hItemsCnt) hItemsCnt.value=chkItemsCnt.checked;
	//alert("chk val " + hItemsCnt.value);
	return update_click();

}

function UpdateCloseAll(){
	// Log 56034 - GC - 03-05-2006 : Logic moved to checkFields()
	if (!checkFields()) return false;

	return UpdateClose_click();

}

function PROCDeleteClickHandler() {
	//alert("PROCDeleteClickHandler 1");
	ProcedureDeleteClickHandler("PROCEntered")
	//alert("PROCDeleteClickHandler 2");
}

function OPDeleteClickHandler() {
	ProcedureDeleteClickHandler("OPEntered")
}

function ProcedureDeleteClickHandler(lista) {
	//alert("ProcedureDeleteClickHandler 1 "+lista);
	var obj=document.getElementById(lista)
	if (obj) {
		//alert("ProcedureDeleteClickHandler 2 "+lista);
		RemoveFromList(obj);
		if (lista=="PROCEntered"){hiddenfield="PROCDescString";lbchange="ProcedureListBoxChanged"}
		if (lista=="OPEntered"){hiddenfield="OPDescString";lbchange="OperationListBoxChanged"}
		UpdateProcedures(lista,hiddenfield,lbchange);
	}
	return false;
}

function ProcLookup(txt) {
	ProcedureLookupSelect(txt,"PROCEntered","PROCDesc")
}

function OPLookup(txt) {
	ProcedureLookupSelect(txt,"OPEntered","OPDesc")
}

function ProcedureLookupSelect(txt,lista,field) {
	//Add an item to ALGEnetered when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	//alert("adata 1="+adata);
	var obj=document.getElementById(lista)

	if (obj) {
		//Need to check if Procedure already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Item has already been selected");
				var obj=document.getElementById(field)
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Item has already been selected");
				var obj=document.getElementById(field)
				if (obj) obj.value="";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	}
	if (obj) AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById(field)
	if (obj) obj.value="";
	if (lista=="PROCEntered"){hiddenfield="PROCDescString";lbchange="ProcedureListBoxChanged"}
	if (lista=="OPEntered"){hiddenfield="OPDescString";lbchange="OperationListBoxChanged"}
	UpdateProcedures(lista,hiddenfield,lbchange);
	//alert("adata 2="+adata);
}

function UpdateProcedures(lista,hiddenfield,lbchange) {
	//alert("update");
	var arrItems = new Array();
	var lst = document.getElementById(lista);
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			arrItems[j] = lst.options[j].value;
		}
		var el = document.getElementById(hiddenfield);
		if (el) el.value = arrItems.join(String.fromCharCode(1));
		//alert(el.value);
		var check = document.getElementById(lbchange);
		check.value=1

	}
}

function PopulateListType(str,lista){
	//alert(str)
	var obj=document.getElementById(lista)
	if (obj) {
		var selections=str.split(String.fromCharCode(1));
		for (var jj=0;jj<selections.length;jj++) {
			var selection=selections[jj].split(String.fromCharCode(2));
			AddItemToList(obj,selection[1],selection[0]);
		}
	}
}

function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	code=String.fromCharCode(2)+code
	//
	list.options[list.options.length] = new Option(desc,code);
}

function RemoveFromList(obj) {
	//alert("RemoveFromList");
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

// Log 56034 - GC - 03-05-2006 : Function to check fields before updating
function checkFields(){
	var msg="";

	var objSId = document.getElementById("StatusId");
	var objCnclRsn = document.getElementById("ANAOPCancelReason");
	if (objSId && objSId.value == "A" && objCnclRsn && objCnclRsn.value == "") {
		msg="'" + t['ANAOPCancelReason'] + "' " + t['XMISSING'];
	}

	var objTBS = document.getElementById("ANAOPTorniquetBodySiteDR");

	var objTDFrom = document.getElementById("ANAOPTorniquetDateFrom");
	if (objTBS && objTBS.value != "" && objTDFrom && objTDFrom.value == "") {
		if (msg!="") msg=msg + "\n" + "'" + t['ANAOPTorniquetDateFrom'] + "' " + t['XMISSING'];
		if (msg=="") msg="'" + t['ANAOPTorniquetDateFrom'] + "' " + t['XMISSING'];
	}

	var objTDTo = document.getElementById("ANAOPTorniquetDateTo");
	if (objTBS && objTBS.value != "" && objTDTo && objTDTo.value == "") {
		if (msg!="") msg=msg + "\n" + "'" + t['ANAOPTorniquetDateTo'] + "' " + t['XMISSING'];
		if (msg=="") msg="'" + t['ANAOPTorniquetDateTo'] + "' " + t['XMISSING'];
	}

	var objTTFrom = document.getElementById("ANAOPTorniquetTimeFrom");
	if (objTBS && objTBS.value != "" && objTTFrom && objTTFrom.value == "") {
		if (msg!="") msg=msg + "\n" + "'" + t['ANAOPTorniquetTimeFrom'] + "' " + t['XMISSING'];
		if (msg=="") msg="'" + t['ANAOPTorniquetTimeFrom'] + "' " + t['XMISSING'];
	}

	var objTTTo = document.getElementById("ANAOPTorniquetTimeTo");
	if (objTBS && objTBS.value != "" && objTTTo && objTTTo.value == "") {
		if (msg!="") msg=msg + "\n" + "'" + t['ANAOPTorniquetTimeTo'] + "' " + t['XMISSING'];
		if (msg=="") msg="'" + t['ANAOPTorniquetTimeTo'] + "' " + t['XMISSING'];
	}

	if (msg!=""){
		alert(msg);
		return false;
	}

	return true;

}
// End Log 56034

function ANAOPStatusLookupHandler(str){
	var lu=str.split("^");
	var obj=document.getElementById("StatusId");
	if (obj) obj.value=lu[2];

	DoStatusValidation();
}

function ANAOPBladeLookUpHandler(str) {
	var lu=str.split("^");
	var obj=document.getElementById("ANAOPBlade");
	if (obj) obj.value=lu[1];
}

function ANAOPDeptOpLookUpHandler(str) {
	var lu=str.split("^");
	var obj=document.getElementById("ANAOPDeptOp");
	if (obj) obj.value=lu[0];
}

function LocationTextChangeHandler() {
	//no function
}

function SurgDescLookUpSelect(str) {
	var lu = str.split("^");
	//alert(str);
	var objres=document.getElementById('Surgeon');
	if (objres) objres.value=lu[0];
}

function SurgPrefClickHandler() {
	var obj=document.getElementById('SurgPref');
	var objSId = document.getElementById("StatusId");
	var AnaOpDR=document.getElementById("ID");
	var indx="AnaOp";
	//log 60490 TedT
	var patient=document.getElementById("PatientID");
	if(patient) patient=patient.value;
	var episode=document.getElementById("EpisodeID");
	if(episode) episode=episode.value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=OEOrder.OrderItemList&Pref=Surgical_Preferences&CONTEXT=OP&PatientID="+patient+"&EpisodeID="+episode;
	lnk+="&AnaOperDR="+AnaOpDR.value+"&index="+indx
	if (objSId.value=="D") lnk+="&ReadOnly=1"
	websys_createWindow(lnk,"","width=800, height=600, top=30, left=30 scrollbars resizable");
	return false;
}

//Calculate in hours and minutes the difference between start date/time and end date/time.  Display as HH:MM.
function CalcTimeDiffHM(sDateName, sTimeName, eDateName, eTimeName, durFldName){
	var sDate = document.getElementById(sDateName);
	var sTime = document.getElementById(sTimeName);
	var eDate = document.getElementById(eDateName);
	var eTime = document.getElementById(eTimeName);
	var durFld = document.getElementById(durFldName);

	if(sDate == null || sTime == null || eDate == null || eTime == null || durFld == null)
		return;

	if(sDate.value == "" || sTime.value == "" || eDate.value == "" || eTime.value == ""){
		durFld.value = "";
		return;
	}

	durFld.value = DateTimeDiffInHMStr(sDate.value, sTime.value, eDate.value, eTime.value);
}

//This function compares the passed date and time to current date and time.  If passed date/time is in the future,
//an error message is given.
function DoDateTimeFutureValidation(dateFld, timeFld){
	var dt = document.getElementById(dateFld);
	if(dt && dt.value != ""){
		var dateCmpr = DateStringCompareToday(dt.value);
		if(dateCmpr == 1){
			alert("'" + t[dateFld] + "' " + t["FutureDate"]);
    			dt.value = "";
	    		websys_setfocus(dateFld);
			return false;

			//dt.className='clsInvalid';
			//websys_setfocus(dateFld);
			//return  websys_cancel();
		}
		//if date is today's date, then check time to make sure that it's not in the future
		else if (dateCmpr == 0){
			var tm = document.getElementById(timeFld);
			if(tm && tm.value!="" && dt.value!=""){//need to check dt as well as it may have been set to "" above
				// Log 59259 - GC - 29/05/06: Modified for THAI date format
				var timeCmpr=DateTimeStringCompareToday(dt.value,tm.value)
				if(timeCmpr == 1) {
					alert(t[timeFld] + " " + t["FutureDate"]);
					tm.value = "";
					websys_setfocus(timeFld);
					return false;
				}
				/*var arrDate = DateStringToArray(dt.value);
				var arrTime = TimeStringToArray(tm.value);
				var entDateTime = new Date(arrDate["yr"],arrDate["mn"]-1,arrDate["dy"],arrTime["hr"],arrTime["mn"],0);
				var nowDateTime = new Date();
				if (entDateTime.getTime() > nowDateTime.getTime()){
					alert("'" + t[timeFld] + "' " + t["FutureDate"]);
	    				tm.value = "";
    					websys_setfocus(timeFld);
					return false;
				}*/
				// End Log 59259
			}

		}
	}
	return true;
}

//This function compares the passed date and time to the admission date and time.  If passed date/time is not after
//the admission date time, an error message is given.
function DoDateTimeAdmValidation(dateFld, timeFld){
	var dt = document.getElementById(dateFld);
	var dtAdm = document.getElementById("AdmDate");
	var tmAdm = document.getElementById("AdmTime");
	if(dt && dt.value != "" && dtAdm && dtAdm.value != ""){
		var dateCmpr = DateStringCompare(dtAdm.value,dt.value);
		if(dateCmpr == 1){
			alert("'" + t[dateFld] + "' " + t["AdmDate"] + " " + dtAdm.value + " " + tmAdm.value);
    			dt.value = "";
	    		websys_setfocus(dateFld);
			return false;
		}
		//if date is after adm date, then check time to make sure that it is after admission time
		else if (dateCmpr == 0){
			var tm = document.getElementById(timeFld);
			if(tm && tm.value!="" && dt.value!="" && tmAdm && tmAdm.value!=""){//need to check dt as well as it may have been set to "" above
			/*	var arrDate = DateStringToArray(dt.value);
				var arrTime = TimeStringToArray(tm.value);
				var arrAdmDate = DateStringToArray(dtAdm.value);
				var arrAdmTime = TimeStringToArray(tmAdm.value);
				var entDateTime = new Date(arrDate["yr"],arrDate["mn"]-1,arrDate["dy"],arrTime["hr"],arrTime["mn"],0);
				var admDateTime = new Date(arrAdmDate["yr"],arrAdmDate["mn"]-1,arrAdmDate["dy"],arrAdmTime["hr"],arrAdmTime["mn"],0);
				if (entDateTime.getTime() < admDateTime.getTime()){
					alert("'" + t[timeFld] + "' " + t["AdmDate"] + " " + dtAdm.value + " " + tmAdm.value);
	    				tm.value = "";
    					websys_setfocus(timeFld);
					return false;
				}
			*/
				var dtcompare= DateTimeStringCompare(dtAdm.value,tmAdm.value,dt.value,tm.value)
				if (dtcompare=="1"){
					alert("'" + t[timeFld] + "' " + t["AdmDate"] + " " + dtAdm.value + " " + tmAdm.value);
	    				tm.value = "";
    					websys_setfocus(timeFld);
					return false;
				}
			}

		}
	}
	return true;
}

//This function gives an error message if the start date/time and end date/time are not in sequence.
function DoDateTimeStartEndValidation(sdateFld, stimeFld, edateFld, etimeFld, entFld){
	var dtStart = document.getElementById(sdateFld);
	var dtEnd = document.getElementById(edateFld);
	var entFld = document.getElementById(entFld);
	if(dtStart && dtStart.value != "" && dtEnd && dtEnd.value != ""){
		var dateCmpr = DateStringCompare(dtStart.value,dtEnd.value);
		if(dateCmpr == 1){
			//alert(t['StartEndDateTime']);
			alert("'" + t[sdateFld] + "/" + t[stimeFld] + "' " + t["MustBeBefore"] + " '" + t[edateFld] + "/" + t[etimeFld] + "'");
    			//dtStart.value = "";
	    		//websys_setfocus(sdateFld);
			entFld.value = "";
			websys_setfocus(entFld);
			return false;
		}
		//if start date is before end date, then check start time to make sure that it is befor end time
		else if (dateCmpr == 0){
			var tmStart = document.getElementById(stimeFld);
			var tmEnd = document.getElementById(etimeFld);
			if(tmStart && tmStart.value!="" && dtStart.value!="" && dtEnd.value!="" && tmEnd && tmEnd.value!=""){//need to check dt as well as it may have been set to "" above
			/*	var arrSDate = DateStringToArray(dtStart.value);
				var arrSTime = TimeStringToArray(tmStart.value);
				var arrEDate = DateStringToArray(dtEnd.value);
				var arrETime = TimeStringToArray(tmEnd.value);
				var startDateTime = new Date(arrSDate["yr"],arrSDate["mn"]-1,arrSDate["dy"],arrSTime["hr"],arrSTime["mn"],0);
				var endDateTime = new Date(arrEDate["yr"],arrEDate["mn"]-1,arrEDate["dy"],arrETime["hr"],arrETime["mn"],0);
				if (endDateTime.getTime() < startDateTime.getTime()){
					//alert(t['StartEndDateTime']);
					alert("'" + t[sdateFld] + "/" + t[stimeFld] + "' " + t["MustBeBefore"] + " '" + t[edateFld] + "/" + t[etimeFld] + "'");
	    				//tmStart.value = "";
    					//websys_setfocus(stimeFld);
					entFld.value = "";
					websys_setfocus(entFld);
					return false;
				}
			*/
			var dtcompare= DateTimeStringCompare(dtStart.value,tmStart.value,dtEnd.value,tmEnd.value)
				if (dtcompare=="1"){
					//alert(t['StartEndDateTime']);
					alert("'" + t[sdateFld] + "/" + t[stimeFld] + "' " + t["MustBeBefore"] + " '" + t[edateFld] + "/" + t[etimeFld] + "'");
	    				//tmStart.value = "";
    					//websys_setfocus(stimeFld);
					entFld.value = "";
					websys_setfocus(entFld);
					return false;
				}

			}

		}
	}
	return true;
}


function DoOpStartDateVal(){
	ANAOPOpStartDate_changehandler(e)
	if (DoDateTimeFutureValidation("ANAOPOpStartDate","ANAOPOpStartTime")){
		if (DoDateTimeAdmValidation("ANAOPOpStartDate","ANAOPOpStartTime")){
			DoDateTimeStartEndValidation("ANAOPOpStartDate","ANAOPOpStartTime","ANAOPOpEndDate","ANAOPOpEndTime","ANAOPOpStartDate");
			CalcTimeDiffHM("ANAOPOpStartDate","ANAOPOpStartTime","ANAOPOpEndDate","ANAOPOpEndTime","OpDuration");
		}
	}
}

function DoOpStartTimeVal(){
	ANAOPOpStartTime_changehandler(e)
	if(DoDateTimeFutureValidation("ANAOPOpStartDate","ANAOPOpStartTime")){
		if(DoDateTimeAdmValidation("ANAOPOpStartDate","ANAOPOpStartTime")){
			DoDateTimeStartEndValidation("ANAOPOpStartDate","ANAOPOpStartTime","ANAOPOpEndDate","ANAOPOpEndTime","ANAOPOpStartTime");
			CalcTimeDiffHM("ANAOPOpStartDate","ANAOPOpStartTime","ANAOPOpEndDate","ANAOPOpEndTime","OpDuration");
		}
	}
}

function DoOpFinishDateVal(){
	ANAOPOpEndDate_changehandler(e)
	if (DoDateTimeFutureValidation("ANAOPOpEndDate","ANAOPOpEndTime")){
		if (DoDateTimeAdmValidation("ANAOPOpEndDate","ANAOPOpEndTime")){
			DoDateTimeStartEndValidation("ANAOPOpStartDate","ANAOPOpStartTime","ANAOPOpEndDate","ANAOPOpEndTime","ANAOPOpEndDate");
			CalcTimeDiffHM("ANAOPOpStartDate","ANAOPOpStartTime","ANAOPOpEndDate","ANAOPOpEndTime","OpDuration");
		}
	}
}

function DoOpFinishTimeVal(){
	ANAOPOpEndTime_changehandler(e)
	if (DoDateTimeFutureValidation("ANAOPOpEndDate","ANAOPOpEndTime")){
		if (DoDateTimeAdmValidation("ANAOPOpEndDate","ANAOPOpEndTime")){
			DoDateTimeStartEndValidation("ANAOPOpStartDate","ANAOPOpStartTime","ANAOPOpEndDate","ANAOPOpEndTime","ANAOPOpEndTime");
			CalcTimeDiffHM("ANAOPOpStartDate","ANAOPOpStartTime","ANAOPOpEndDate","ANAOPOpEndTime","OpDuration");
		}
	}
}

//calculates the durations between start date/time and end date/time
function CalcDurations(){
	CalcTimeDiffHM("ANAOPOpStartDate","ANAOPOpStartTime","ANAOPOpEndDate","ANAOPOpEndTime","OpDuration");
}

function My_Alert() {
	debugger;
	alert("here")
	return 1;
}


// Log 56034 - GC - 03-05-2006 : onblur for ANAOPTorniquetBodySiteDR - Enables/Disables date/time values depending on Torniquet Applied To field value
function ANAOPTorniquetBodySiteDR_ChangeHandler(){
	var obj=document.getElementById('ANAOPTorniquetBodySiteDR');

	if (obj){
		if (obj.value!=""){
			labelMandatory("ANAOPTorniquetDateFrom");
			labelMandatory("ANAOPTorniquetDateTo");
			labelMandatory("ANAOPTorniquetTimeFrom");
			labelMandatory("ANAOPTorniquetTimeTo");

			UnsetReadOnly("ANAOPTorniquetDateFrom")
			UnsetReadOnly("ANAOPTorniquetDateTo");
			UnsetReadOnly("ANAOPTorniquetTimeFrom");
			UnsetReadOnly("ANAOPTorniquetTimeTo");
		}
		else{
			labelNormal("ANAOPTorniquetDateFrom");
			labelNormal("ANAOPTorniquetDateTo");
			labelNormal("ANAOPTorniquetTimeFrom");
			labelNormal("ANAOPTorniquetTimeTo");

			// Did not use DisableField() because the blank value doesn't get updated in the DB. So when page loads, initially
			// date values gets loaded before disappearing in a flick of a second. So used SetReadOnly() instead.
			SetReadOnly("ANAOPTorniquetDateFrom")
			SetReadOnly("ANAOPTorniquetDateTo");
			SetReadOnly("ANAOPTorniquetTimeFrom");
			SetReadOnly("ANAOPTorniquetTimeTo");
		}
	}
}


// The Lookup for ANAOPTorniquetBodySiteDR
function ANAOPTorniquetBodySiteDRLookupHandler(str){
	ANAOPTorniquetBodySiteDR_ChangeHandler();
}

// Torniquet Date From Validation
function DoTorDateFromVal(){
	ANAOPTorniquetDateFrom_changehandler(e)
	if (DoDateTimeFutureValidation("ANAOPTorniquetDateFrom","ANAOPTorniquetTimeFrom")){
		if (DoDateTimeAdmValidation("ANAOPTorniquetDateFrom","ANAOPTorniquetTimeFrom")){
			DoDateTimeStartEndValidation("ANAOPTorniquetDateFrom","ANAOPTorniquetTimeFrom","ANAOPTorniquetDateTo","ANAOPTorniquetTimeTo","ANAOPTorniquetDateFrom");
		}
	}
}

// Torniquet Date To Validation
function DoTorDateToVal(){
	ANAOPTorniquetDateTo_changehandler(e)
	if (DoDateTimeFutureValidation("ANAOPTorniquetDateTo","ANAOPTorniquetTimeTo")){
		if (DoDateTimeAdmValidation("ANAOPTorniquetDateTo","ANAOPTorniquetTimeTo")){
			DoDateTimeStartEndValidation("ANAOPTorniquetDateFrom","ANAOPTorniquetTimeFrom","ANAOPTorniquetDateTo","ANAOPTorniquetTimeTo","ANAOPTorniquetDateTo");
		}
	}
}

// Torniquet Time From Validation
function DoTorTimeFromVal(){
	ANAOPTorniquetTimeFrom_changehandler(e)
	if (DoDateTimeFutureValidation("ANAOPTorniquetDateFrom","ANAOPTorniquetTimeFrom")){
		if (DoDateTimeAdmValidation("ANAOPTorniquetDateFrom","ANAOPTorniquetTimeFrom")){
			DoDateTimeStartEndValidation("ANAOPTorniquetDateFrom","ANAOPTorniquetTimeFrom","ANAOPTorniquetDateTo","ANAOPTorniquetTimeTo","ANAOPTorniquetTimeFrom");
		}
	}
}

// Torniquet Time To Validation
function DoTorTimeToVal(){
	ANAOPTorniquetTimeTo_changehandler(e)
	if (DoDateTimeFutureValidation("ANAOPTorniquetDateTo","ANAOPTorniquetTimeTo")){
		if (DoDateTimeAdmValidation("ANAOPTorniquetDateTo","ANAOPTorniquetTimeTo")){
			DoDateTimeStartEndValidation("ANAOPTorniquetDateFrom","ANAOPTorniquetTimeFrom","ANAOPTorniquetDateTo","ANAOPTorniquetTimeTo","ANAOPTorniquetTimeTo");
		}
	}
}
//End Log 56034



