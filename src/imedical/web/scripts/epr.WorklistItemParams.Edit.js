// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 2.07.02

f=document.fepr_WorklistItemParams_Edit_CPEpisode;

function DocumentLoadHandler() {
	//websys_reSizeT();
	disableFields();

	var obj=document.getElementById("WIPLogonCP");
	if (obj) obj.onclick=disableFields;
	var obj=document.getElementById("WIPLogonCaseMan");
	if (obj) obj.onclick=disableFields;
	var obj = document.getElementById("deleteCPs");
	if (obj) obj.onclick = DeleteCPClickHandler;
	var objList = document.getElementById("WIPCPList");
	var objlistbox = document.getElementById("CPs");
	if ((objList)&&(objlistbox)) {
		AddAllItemsToList(objlistbox, objList.value);
	}

	var obj = document.getElementById("deleteUnits");
	if (obj) obj.onclick = DeleteUnitClickHandler;
	var objList = document.getElementById("WIPUnitList");
	var objlistbox = document.getElementById("Units");
	if ((objList)&&(objlistbox)) {
		AddAllItemsToList(objlistbox, objList.value);
	}

	var obj=document.getElementById("WIPLogonHosp");
	if (obj) obj.onclick=LogonHospClickHandler;

	var obj = document.getElementById("deleteHosps");
	if (obj) obj.onclick = DeleteHospClickHandler;
	
	var objList = document.getElementById("WIPHospitalList");
	var objlistbox = document.getElementById("Hosps");
	if ((objList)&&(objlistbox)) {
		AddAllItemsToList(objlistbox, objList.value);
	}


	var obj=document.getElementById("WIPLogonSpecialty");
	if (obj) obj.onclick=disableFields;
	var obj = document.getElementById("deleteSpecs");
	if (obj) obj.onclick = DeleteSpecClickHandler;

	var objList = document.getElementById("WIPSpecialtyList");
	var objlistbox = document.getElementById("Specs");
	if ((objList)&&(objlistbox)) {
		AddAllItemsToList(objlistbox, objList.value);
	}

	var obj=document.getElementById("WIPLogonLoc");
	if (obj) obj.onclick=LogonLocClickHandler;
	var obj = document.getElementById("deleteLocs");
	if (obj) obj.onclick = DeleteLocClickHandler;
	var objList = document.getElementById("WIPLocList");
	var objlistbox = document.getElementById("Locs");
	if ((objList)&&(objlistbox)) {
		AddAllItemsToList(objlistbox, objList.value);
	}

	var obj=document.getElementById("WIPDateToToday");
	if (obj) obj.onclick=disableFields;

	var obj=document.getElementById("WIPDateFromToday");
	if (obj) obj.onclick=disableFields;

	var obj=document.getElementById("WIPLogonRoundCP");
	if (obj) obj.onclick=disableFields;

	var obj=document.getElementById("WIPLogonRoundRR");
	if (obj) obj.onclick=disableFields;

	var objEQ=document.getElementById("RESDesc");
	if (objEQ) objEQ.onblur=EQChangeHandler;

	var objCP=document.getElementById("WIPCareProvDR");
	if (objCP) objCP.onblur=CPChangeHandler;

	obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;

	setVisList();
	setRefList();
	setReqList();
	setRadStatList();
	var obj=document.getElementById("ID");
	if ((obj)&&(obj.value=="")) ListsDefault();
	RefSelectHandler();
	VisSelectHandler();
	ReqSelectHandler();

	var obj=document.getElementById("VisitStatus");
	if (obj) obj.onchange=VisSelectHandler;

	var obj=document.getElementById("RefStatus");
	if (obj) obj.onchange=RefSelectHandler;

	var obj=document.getElementById("ReqStatus");
	if (obj) obj.onchange=ReqSelectHandler;

	var obj=document.getElementById("RadStatus");
	if (obj) obj.onchange=RadStatSelectHandler;

	var objOutPat=document.getElementById("EpisodeOutPat");
	var objInPat=document.getElementById("EpisodeInPat");
	var objEmerPat = document.getElementById("EpisodeEmerPat");
	var objEpisType = document.getElementById("WIPEpisodeTypeList");
	if (objEpisType) {
		if ((objOutPat)&&(objEpisType.value.indexOf("O")!=-1)) objOutPat.checked = true;
		if ((objInPat)&&(objEpisType.value.indexOf("I")!=-1)) objInPat.checked = true;
		if ((objEmerPat)&&(objEpisType.value.indexOf("E")!=-1)) objEmerPat.checked = true;
	}


	return true;
}

function AddAllItemsToList(obj, list) {
	var tmp = list.split(String.fromCharCode(1));
	for (var pce=0; pce < tmp.length; pce ++) {
		var strings = tmp[pce].split(String.fromCharCode(2));
		//alert(strings[1] + '\n'+ strings[0]);
		if (strings.length > 1) AddItemToList(obj, strings[1].split(","), strings[0].split(","));
	}
}


function UpdateHandler() {
	if(checkMandatory()) {
	if (f) {

		var objlist = f.CPs;
		if (objlist) {
			var ary=returnValuesWithDescriptions(objlist);
			var objWIP=document.getElementById("WIPCPList");
			if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
		}
	
		var objlist = f.Hosps;
		if (objlist) {
			var ary=returnValuesWithDescriptions(objlist);
			var objWIP=document.getElementById("WIPHospitalList");
			if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
		}
	
		var objlist = f.Specs;
		if (objlist) {
			var ary=returnValuesWithDescriptions(objlist);
			var objWIP=document.getElementById("WIPSpecialtyList");
			if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
		}
		
		var objlist = f.Units;
		if (objlist) {
			var ary=returnValuesWithDescriptions(objlist);
			var objWIP=document.getElementById("WIPUnitList");
			if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
		}
	
		var objlist = f.Locs;
		if (objlist) {
			var ary=returnValuesWithDescriptions(objlist);
			var objWIP=document.getElementById("WIPLocList");
			if (objWIP) {
				objWIP.value = ary.join(String.fromCharCode(1));
				//alert(objWIP.value);
			}
		}
	
		var objOutPat=document.getElementById("EpisodeOutPat");
		var objInPat=document.getElementById("EpisodeInPat");
		var objEmerPat = document.getElementById("EpisodeEmerPat");
		var objEpisType = document.getElementById("WIPEpisodeTypeList");
		if ( objEpisType ) {
			objEpisType.value = "";
			if (objOutPat && (objOutPat.checked)) objEpisType.value = objEpisType.value + "O";
			if (objInPat && (objInPat.checked)) objEpisType.value = objEpisType.value + "I";
			if (objEmerPat && (objEmerPat.checked)) objEpisType.value = objEpisType.value + "E";
			if (objEpisType.value == "") {
				alert("No episode types have been selected");
				return false;
			}
		}
	 }
	
	 return update1_click();
	}
}

function returnValuesWithDescriptions(obj) {
	var ary=new Array();
	for (var i=0; i<obj.length; i++) {
		var tmp = obj.options[i].value + String.fromCharCode(2)+ obj.options[i].text;
		ary[i]= tmp;
	}
	return ary;
}

function LogonHospClickHandler() {
	var objWIPLogonHosp=document.getElementById("WIPLogonHosp");
	if (objWIPLogonHosp) {
		if (objWIPLogonHosp.checked) {
			DisableField("Hospital");
			DisableLookup("ld1469iHospital");
			var obj = document.getElementById("Hosps");
			if (obj) ClearAllList(obj);
			var objLogonHosp=document.getElementById("LogonHospital");
			var objHospIDs=document.getElementById("HospIDs");
			if ((objHospIDs)&&(objLogonHosp)) objHospIDs.value=objLogonHosp.value;
		} else {
			EnableField("Hospital");
			EnableLookup("ld1469iHospital");
			var objHospIDs=document.getElementById("HospIDs");
			if (objHospIDs) objHospIDs.value="";
		}
	}
	disableFields();
}

function LogonLocClickHandler() {
	var objWIPLogonLoc=document.getElementById("WIPLogonLoc");
	var objLocation=document.getElementById("Location");
	var objLocs=document.getElementById("Locs");
		
	if (objWIPLogonLoc) {
		if (objWIPLogonLoc.checked) {
			DisableField("Location");
			DisableLookup("ld1469iLocation");
			if (objLocs) ClearAllList(objLocs);
			var objLogonLoc=session['LOGON.CTLOCID'];
			var objLocIDs=document.getElementById("LocIDs");
			if ((objLocIDs)&&(objLogonLoc)) objLocIDs.value=objLogonLoc.value;
		} else {
			EnableField("Location");
			EnableLookup("ld1469iLocation");
			var objLocIDs=document.getElementById("LocIDs");
			if (objLocIDs) objLocIDs.value="";
		}
	}
	disableFields();
}


function checkMandatory() {
	var msg="";

	if (msg != "") {
		alert(msg);
		return false;
	} else {
		return true;
	}

}

/*
function setStatusList() {
  // populates list with visit statuses
 var obj=document.getElementById("vstats");
 var objSel=document.getElementById("vstatssel");
 var objList=document.getElementById("VisitStatus");
 if ((obj)&&(objList)&&(objSel)) {
  var statary=obj.value.split("^");
  var statarysel=objSel.value.split("^");
  for (var i=0;i<statary.length;i++) {
    objList.options[i]=new Option(statary[i],statary[i]);
    if (statarysel[i]=="1") objList.options[i].selected=true;
  }
 }
 return;
}*/

function setVisList() {
	// sets selected visit statuses
	var rarysel;
	var rstat=document.getElementById("vstats");
	var RefList=document.getElementById("VisitStatus");

	if ((rstat)&&(RefList)&&(rstat.value!="")) {
		var refary=rstat.value.split("$$");
		for (var i=0;i<RefList.options.length;i++) {
			if (refary[i]) rarysel=refary[i].split("*");
			if ((rarysel[0]==RefList.options[i].value)&&(rarysel[1]==1)) RefList.options[i].selected=true;
		}
	}
	return true;
}

function setRefList() {
	// sets selected referral statuses
	var rarysel;
	var rstat=document.getElementById("rstat");
	var RefList=document.getElementById("RefStatus");

	if ((rstat)&&(RefList)&&(rstat.value!="")) {
		var refary=rstat.value.split("$$");

		for (var i=0;i<RefList.options.length;i++) {
			if (refary[i]) rarysel=refary[i].split("*");
			if ((rarysel[0]==RefList.options[i].value)&&(rarysel[1]==1)) RefList.options[i].selected=true;
		}
	}
	return true;
}

function setReqList() {
	// sets selected request statuses
	var rarysel;
	var rstat=document.getElementById("reqstat");
	var ReqList=document.getElementById("ReqStatus");

	if ((rstat)&&(ReqList)&&(rstat.value!="")) {
		var refary=rstat.value.split("$$");

		for (var i=0;i<ReqList.options.length;i++) {
			if (refary[i]) rarysel=refary[i].split("*");
			if ((rarysel[0]==ReqList.options[i].value)&&(rarysel[1]==1)) ReqList.options[i].selected=true;
		}
	}
	return true;
}

function ListsDefault() {
	var RefList=document.getElementById("RefStatus");
	var VisList=document.getElementById("VisitStatus");
	var ReqList=document.getElementById("ReqStatus");
	var SortOrder=document.getElementById("SortOrder");

	if (RefList) {
		for (var i=0;i<RefList.options.length;i++) {
			RefList.options[i].selected=true;
		}
	}

	if (VisList) {
		for (var i=0;i<VisList.options.length;i++) {
			VisList.options[i].selected=true;
		}
	}

	if (ReqList) {
		for (var i=0;i<ReqList.options.length;i++) {
			ReqList.options[i].selected=true;
		}
	}
}

function setRadStatList() {
	// sets selected rad statuses
	var rarysel;
	var rstat=document.getElementById("WipRadStatus");
	var RefList=document.getElementById("RadStatus");

	if ((rstat)&&(RefList)&&(rstat.value!="")) {
		var refary=rstat.value.split("|");

		for (var i=0;i<RefList.options.length;i++) {
			for (var j=0; j<refary.length; j++) {
				if(RefList.options[i].value==refary[j]) RefList.options[i].selected=true;
			}
		}
	}
	return true;
}

//------

function RadStatSelectHandler() {
	// builds rstat string to save multiple rad statuses
	var rstat=document.getElementById("WipRadStatus");
	var RefList=document.getElementById("RadStatus");
	var rst="";

	if ((RefList)&&(rstat)) {
		for (var i=0;i<RefList.options.length;i++) {
			if (RefList.options[i].selected==true)
			      rst=rst+RefList.options[i].value+"|";
		}
		rstat.value=rst;
	}
	return true;
}

function VisSelectHandler() {
	// builds rstat string to save multiple visit statuses
	var rstat=document.getElementById("vstats");
	var RefList=document.getElementById("VisitStatus");
	var rst="",rcnt=0;
	if ((RefList)&&(rstat)) {
		for (var i=0;i<RefList.options.length;i++) {
			if (i!=0) rst=rst+"$$";
			if (RefList.options[i].selected==true) rbool=1
			else rbool=0;
			rst=rst+RefList.options[i].value+"*"+rbool;
			if (rbool==1) rcnt=rcnt+1;
		}
		rstat.value=rst;
		// if they dont choose any of them then dont filter
		if (rcnt==0) rstat.value="";
	}
	return true;
}

/*
function VisitSelectHandler() {
  // builds vstatsel string to save which statuses they want to display
 var obj=document.getElementById("VisitStatus");
 var selAdm="0",selPre="0",selDis="0";
 if (obj) {
  if ((obj.options[0])&&(obj.options[0].selected==true)) selAdm="1";
  if ((obj.options[1])&&(obj.options[1].selected==true)) selPre="1";
  if ((obj.options[2])&&(obj.options[2].selected==true)) selDis="1";

   var objVA=document.getElementById("WIPViewAll");
   if (objVA) {
     if ((obj.options[0].selected==true)&&(obj.options[1].selected==true)&&(obj.options[2].selected==true)) objVA.value=1;
     else objVA.value=0;
   }
 }
 var sel=selAdm+"^"+selPre+"^"+selDis;
 //alert(sel);
 var obj=document.getElementById("vstatssel");
 if (obj) obj.value=sel;



 return;
}*/

function RefSelectHandler() {
	// builds rstat string to save multiple ref statuses
	var rstat=document.getElementById("rstat");
	var RefList=document.getElementById("RefStatus");
	var rst="",rcnt=0;
	if ((RefList)&&(rstat)) {
		for (var i=0;i<RefList.options.length;i++) {
		      if (i!=0) rst=rst+"$$";
		      if (RefList.options[i].selected==true) rbool=1
		      else rbool=0;
		      rst=rst+RefList.options[i].value+"*"+rbool;
		      if (rbool==1) rcnt=rcnt+1;
		}
		rstat.value=rst;
		// if they dont choose any of them then dont filter
		if (rcnt==0) rstat.value="";
	}
	return true;
}

function ReqSelectHandler() {
	// builds reqstat string to save multiple request statuses
	var rstat=document.getElementById("reqstat");
	var ReqList=document.getElementById("ReqStatus");
	var rst="";

	if ((ReqList)&&(rstat)) {
		for (var i=0;i<ReqList.options.length;i++) {
			if (i!=0) rst=rst+"$$";
			if (ReqList.options[i].selected==true) rbool=1
			else rbool=0;
			rst=rst+ReqList.options[i].value+"*"+rbool;
		}
		rstat.value=rst;
	}
	return true;
}

function EQChangeHandler(str) {
	var objEQ=document.getElementById("RESDesc");
	var objCP=document.getElementById("WIPCareProvDR");
	var objLoc=document.getElementById("WIPLocationDR");
	var objResID=document.getElementById("RESRowID");
	if (objEQ) {
		if (objEQ.value!="") {
				if (objCP) objCP.value="";
				if (objLoc) objLoc.value="";
		}
        // ab 19.01.05 49049
		if ((objEQ.value=="")&&(objResID)) objResID.value="";
	}
	if (str) {
		var lu=str.split("^");
		if (objResID) objResID.value=lu[3];
	}
	return true;
}

function CPChangeHandler(str) {
	//alert(str);
	if (str) var lu=str.split("^");
	if (str) {
		var obj=document.getElementById("WIPCareProvDR");
		if (obj) obj.value=lu[0];
		var obj2=document.getElementById("LinkLocCP");
		if ((obj2)&&(obj2.value==1)) {
			var obj=document.getElementById("WIPLocationDR");
			if (obj) obj.value=lu[2];
		}
	}
	var objEQ=document.getElementById("RESDesc");
	var objResID=document.getElementById("RESRowID");
	var objCP=document.getElementById("WIPCareProvDR");
	if ((objEQ)&&(objCP)) {
		if (objCP.value!="") {
			objEQ.value="";
			if (objResID) objResID.value="";
		}
	}
	if ((str)&&(str!="")) {
		// now add it to the list...
		if ((f)&&(f.WIPCareProvDR)) f.WIPCareProvDR.value="";
		if ((f)&&(f.CPs)) TransferToList(f.CPs,lu[0]+"^"+lu[1]);
	}
}

function LookUpSpec(val) {
	f.Specialty.value="";
	TransferCodeToList(f.Specs,val)
}

function LookUpUnit(val) {
	f.Unit.value="";
	var txt = val.split("^");
	if (txt.length>1) {
		var newstring = txt[1] + "^" + txt[0];
		TransferToList(f.Units, newstring);
	}
}
function DeleteUnitClickHandler(e) {
	ClearSelectedList(f.Units);
	return false;
}

function DeleteCPClickHandler(e) {
	ClearSelectedList(f.CPs);
	return false;
}

function DeleteSpecClickHandler(e) {
	ClearSelectedList(f.Specs);
	return false;
}

function DeleteHospClickHandler(e) {
	var obj=document.getElementById("HospIDs");
	if (obj) DeleteFromIdString(f.Hosps,obj)
	
	ClearSelectedList(f.Hosps);
	return false;
}

function DeleteLocClickHandler(e) {
	var obj=document.getElementById("LocIDs");
	if (obj) DeleteFromIdString(f.Locs,obj)
	
	ClearSelectedList(f.Locs);
	return false;
}

// manages the | delimited string of ids when a listbox item is deleted
function DeleteFromIdString(list,obj) {
	var str="";
	var ary2=new Array();
	if ((list)&&(obj)) {
		var ary=obj.value.split("|");
		for (var i=0;i<list.length;i++) {
			if (list.options[i].selected) ary[i]="";
		}
		for (var i=0;i<ary.length;i++) {
			if (ary[i]!="") ary2.push(ary[i]);
		}
		obj.value=ary2.join("|");
	}
}

function TransferCodeToList (obj, str) {
	// swap pieces 2 and 3
	var txt = str.split("^");
	if (txt.length>1) {
		var newstring = txt[0] + "^" + txt[2];
		TransferToList(obj, newstring);
	}
	
}

function LookUpHosp(val) {
	f.Hospital.value="";
	TransferCodeToList(f.Hosps,val)
	var txt = val.split("^");
	var obj=document.getElementById("HospIDs");
	if (obj) {
		if (obj.value!="") obj.value=obj.value+"|";
		obj.value=obj.value+txt[1];
	}
}

function LookUpLoc(val) {
	if ((f)&&(f.WIPLocationDR)) f.WIPLocationDR.value="";
	var txt = val.split("^");
	if (txt.length>1) {
		var newstring = txt[1] + "^" + txt[0];
		if ((f)&&(f.Locs)) TransferToList(f.Locs, newstring);
		
		var obj=document.getElementById("LocIDs");
		if (obj) {
			if (obj.value!="") obj.value=obj.value+"|";
			obj.value=obj.value+txt[3];
		}
	}
}

function LocLookupSelect(str) {
	var lu=str.split("^");
	var obj=document.getElementById("WIPLocationDR");
	//if (obj) obj.value=lu[1];
	if ((f)&&(f.WIPLocationDR)) f.WIPLocationDR.value="";
	if ((f)&&(f.Locs)) TransferCodeToList(f.Locs,str)
	var objEQ=document.getElementById("RESDesc");
	var objResID=document.getElementById("RESRowID");
	var objLoc=document.getElementById("WIPLocationDR");
	if ((objEQ)&&(objLoc)) {
		if (objLoc.value!="") {
			objEQ.value="";
			objResID.value="";
		}
	}
}

function disableFields() {
	var objUseCP=document.getElementById("WIPLogonCP");
	var objUseLogon=document.getElementById("WIPLogonLoc");
	var objDFCurr=document.getElementById("WIPDateFromToday");
	var objDTCurr=document.getElementById("WIPDateToToday");
	var objViewAll=document.getElementById("WIPViewAll");
	var objCP=document.getElementById("WIPCareProvDR");
	var objLoc=document.getElementById("WIPLocationDR");
	var objRoundCP=document.getElementById("WIPLogonRoundCP");
	var objRoundRR=document.getElementById("WIPLogonRoundRR");
	var objWIPLogonCP=document.getElementById("WIPLogonCP");
	var WIPLogonCaseMan=document.getElementById("WIPLogonCaseMan");
	var objCPs=document.getElementById("CPs");
	var objCP=document.getElementById("CP");

	var objWIPLogonHosp=document.getElementById("WIPLogonHosp");
	var objHospital=document.getElementById("Hospital");
	var objHosps=document.getElementById("Hosps");
	
	var objWIPLogonSpec=document.getElementById("WIPLogonSpecialty");
	var objSpecialty=document.getElementById("Specialty");
	var objSpecs=document.getElementById("Specs");

	if (((objRoundCP)&&(objRoundCP.checked==true))||((objUseCP)&&(objUseCP.checked==true))||
	((objRoundRR)&&(objRoundRR.checked==true))) {
		DisableField("WIPCareProvDR");
		DisableLookup("ld1469iWIPCareProvDR");
		DisableField("RESDesc");
		DisableLookup("ld1469iRESDesc");
		if ((objRoundCP)&&(objRoundCP.checked==true)) {
			if (objRoundRR) objRoundRR.checked=false;
			if (objRoundRR) objRoundRR.disabled=true;
			if (objUseCP) objUseCP.checked=false;
			if (objUseCP) objUseCP.disabled=true;
			var obj = document.getElementById("CPs");
			if (obj) ClearAllList(obj);
		} else if ((objUseCP)&&(objUseCP.checked==true)) {
			if (objRoundRR) objRoundRR.checked=false;
			if (objRoundRR) objRoundRR.disabled=true;
			if (objRoundCP) objRoundCP.checked=false;
			if (objRoundCP) objRoundCP.disabled=true;
			var obj = document.getElementById("CPs");
			if (obj) ClearAllList(obj);
		} else if ((objRoundRR)&&(objRoundRR.checked==true)) {
			if (objUseCP) objUseCP.checked=false;
			if (objUseCP) objUseCP.disabled=true;
			if (objRoundCP) objRoundCP.checked=false;
			if (objRoundCP) objRoundCP.disabled=true;
			var obj = document.getElementById("CPs");
			if (obj) ClearAllList(obj);
		}
	} else if (((objRoundCP)&&(objRoundCP.checked==false))||((objUseCP)&&(objUseCP.checked==false))||
		((objRoundRR)&&(objRoundRR.checked==false))) {
		EnableField("WIPCareProvDR");
		EnableLookup("ld1469iWIPCareProvDR");
		EnableField("RESDesc");
		EnableLookup("ld1469iRESDesc");
		EnableField("WIPLogonRoundRR");
		EnableField("WIPLogonCP");
		EnableField("WIPLogonRoundCP");
	}

	if ((objUseLogon)&&(objUseLogon.checked==true)) {
		DisableField("WIPLocationDR");
		DisableLookup("ld1469iWIPLocationDR");
	} else if ((objUseLogon)&&(objUseLogon.checked==false)) {
		EnableField("WIPLocationDR");
		EnableLookup("ld1469iWIPLocationDR");
	}

	if (objWIPLogonCP) {
		if (objWIPLogonCP.checked) {
			DisableField("CP");
			DisableLookup("ld1469iCP");
			var obj = document.getElementById("CPs");
			if (obj) ClearAllList(obj);
		} else {
			EnableField("CP");
			EnableLookup("ld1469iCP");
		}
	}

	if (objWIPLogonHosp) {
		if (objWIPLogonHosp.checked) {
			DisableField("Hospital");
			DisableLookup("ld1469iHospital");
			var obj = document.getElementById("Hosps");
			if (obj) ClearAllList(obj);
		} else {
			EnableField("Hospital");
			EnableLookup("ld1469iHospital");
		}
	}

	if (objWIPLogonSpec) {
		if (objWIPLogonSpec.checked) {
			DisableField("Specialty");
			DisableLookup("ld1469iSpecialty");
			var obj = document.getElementById("Specs");
			if (obj) ClearAllList(obj);
		} else {
			EnableField("Specialty");
			EnableLookup("ld1469iSpecialty");
		}
	}

	if ((objDFCurr)&&(objDFCurr.checked==true)) {
		DisableField("WIPDateFrom");
		DisableLookup("ld1469iWIPDateFrom");
		DisableField("WIPDtFromOffset");
	} else if ((objDFCurr)&&(objDFCurr.checked==false)) {
		EnableField("WIPDateFrom");
		EnableLookup("ld1469iWIPDateFrom");
		EnableField("WIPDtFromOffset");
	}

	if ((objDTCurr)&&(objDTCurr.checked==true)) {
		DisableField("WIPDateTo");
		DisableLookup("ld1469iWIPDateTo");
		DisableField("WIPDtToOffset");
	} else if ((objDTCurr)&&(objDTCurr.checked==false)) {
		EnableField("WIPDateTo");
		EnableLookup("ld1469iWIPDateTo");
		EnableField("WIPDtToOffset");
	}
	
	if ((WIPLogonCaseMan)&&(WIPLogonCaseMan.checked==true)) {
		DisableField("WIPCaseManager");
		DisableLookup("ld1469iWIPCaseManager");
	} else if ((WIPLogonCaseMan)&&(WIPLogonCaseMan.checked==false)) {
		EnableField("WIPCaseManager");
		EnableLookup("ld1469iWIPCaseManager");
	}

	return true;
}


document.body.onload=DocumentLoadHandler;

//--------------------------------------------------------------

function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl=lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl=lbl.className = "";
	}
}

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";

	}
}

function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";

	}
}

function DisableLookup(fldName) {
	var obj=document.getElementById(fldName);
	if (obj) obj.disabled=true;
}

function EnableLookup(fldName) {
	var obj=document.getElementById(fldName);
	if (obj) obj.disabled=false;
}


