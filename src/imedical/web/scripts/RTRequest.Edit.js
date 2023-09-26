// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
 
var MoveFlag="";
var Uncode="";
var Discharge="";

var objRTREQDoctorDR=document.getElementById('RTREQDoctorDR');
var objRTREQReqLocDR=document.getElementById('RTREQReqLocDR');
var objHidRTREQReqLocDR=document.getElementById('HidRTREQReqLocDR');
var objRTREQReqTelNo=document.getElementById('RTREQReqTelNo');
var objRTREQReqExtNo=document.getElementById('RTREQReqExtNo');
var objRTREQPagerNo=document.getElementById('RTREQPagerNo');
var obj=document.getElementById('hiddenTelNo');
var HRLobj=document.getElementById('RTReqLocID');

if (obj){
	var obj1=document.getElementById('RTREQReqTelNo');
	// LOG 26988;DL;29/7/02
	if (obj1 && obj1.value=="") obj1.value=obj.value;
}
var Uobj=document.getElementById("Update1");
if (Uobj) Uobj.onclick=UpdateClickTestReason;
if (tsc['Update1']) {
	websys_sckeys[tsc['Update1']]=UpdateClickTestReason;
}
var UMobj=document.getElementById("UpdateMove");
if (UMobj) {UMobj.onclick=UpdateMoveClickHandler;}
var obj=document.getElementById("outstanding");
if ((obj)&&(UMobj)&&(obj.value=="N")) {UMobj.disabled=true; UMobj.onclick=BlankClickHandler;}
var VSobj=document.getElementById("VerifiedStatus");
if (VSobj) VSobj.onclick=BlankClickHandler;
if (self==top) websys_reSizeT();
var ntObj=document.getElementById("NewTransaction");
if (ntObj) ntObj.onclick=NewTransClickHandler;

function ReasLookUpHandler(txt) {
	var adata=txt.split("^");
	var ReasonDesc=adata[0];
	var robj=document.getElementById("RTREQReqReasonDR");
	if (robj) robj.value=ReasonDesc;
}
function BlankClickHandler(){
	return false;
}

function NewTransClickHandler(){
	if ((ntObj)&&(ntObj.href!="")) {
		var twkfli="";
		var arr=ntObj.href.split("?");
		var twObj=document.getElementById("TWKFLI");
		if (twObj) twkfli=twObj.value-1;
		//alert(arr[0]+" "+twkfli+" "+arr[1]);
		ntObj.href=arr[0]+"?TWKFLI="+twkfli+"&"+arr[1];
		//alert(ntObj.href);
		window.location=ntObj.href;
	}
	return false;
}
function UpdateMoveClickHandler() {
	Uncode="";
	Discharge="";
	MoveFlag="Y";
	var locid="";
	var locdesc="";
	var UnverifiedAlert="";
	var INComDisSum="";
	var mfOBJ=document.getElementById("MoveFlag");
	if (mfOBJ) mfOBJ.value=MoveFlag;
	//----------------
	var lobj=document.getElementById("RTReqLocID");
	var ldobj=document.getElementById("RTREQReqLocDR");
	var HVobj=document.getElementById("HiddenVerify");
	var HDobj=document.getElementById("HiddenDSSummary");
	if ((lobj)&&(lobj.value!="")) locid=lobj.value;
	if ((ldobj)&&(ldobj.value!="")) locdesc=ldobj.value;
	if ((locid!="")&&(locdesc!="")) {
		var returntext="";
		var tbl=document.getElementById("tRTMasVol_FindRequestVolume");
		var DLobj="";
		if(tbl){
			for (var j=1;j<tbl.rows.length;j++) {
				var type="";
				var volume="";
				var obj=document.getElementById('CurrLocIDz'+j);
				var tobj=document.getElementById('hidRTMAVTYPDescz'+j);
				var vobj=document.getElementById('hidRTMAVVolDescz'+j);
				var htmlobj=document.getElementById('hidTempHomeLocz'+j);
				var hmlobj=document.getElementById('hidHomeLocz'+j);
				var sobj=document.getElementById('AddVolz'+j);
				
				if((tobj)&&(tobj.value!="")) type=tobj.value
				if((vobj)&&(vobj.value!="")) volume=vobj.value
				
				if ((obj)&&(obj.value==locid)&&(sobj.checked==true)){
					returntext=returntext+type+" "+volume+t['ALREADY_AT']+locdesc+"\n";
				}

				if ((vobj)&&(vobj.value=="")&&(sobj.checked==true)){
					alert(type+t['BLANK_VOL']+t['UpdateMove']);
					return false;
				}
			
				if ((hmlobj)&&(hmlobj.value==locid)&&(sobj.checked==true)&&(htmlobj)&&(htmlobj.value!="")){
					returntext=returntext+type+" "+volume+t['HAS_TEMPHOME']+htmlobj.value+"\n";
				}
				
				if ((HVobj)&&(HVobj.value=="1")){
					var HomeLocList=""
					var HLLObj=document.getElementById('HomeLocListz'+j);
					if((HLLObj)&&(HLLObj.value)!="") {
						HomeLocList=HLLObj.value;
						var adata=HomeLocList.split("^");
						for (var jk=0;jk<adata.length;jk++) {
							var currloc=adata[jk];
							if (locid==currloc){
								//alert("UV");
								UnverifiedAlert="Y";
								break;
							}
						}
					}
					if((UnverifiedAlert=="Y")&&(Uncode=="")) { 
						returntext+=t['UNICD_CODING']+"\n";
						Uncode="Y";
					}
				}

				if ((HDobj)&&(HDobj.value=="1")){
					var HomeLocList=""
					var HLLObj=document.getElementById('HomeLocListz'+j);
					if((HLLObj)&&(HLLObj.value)!="") {
						HomeLocList=HLLObj.value;
						var adata=HomeLocList.split("^");
						for (var jk=0;jk<adata.length;jk++) {
							var currloc=adata[jk];
							if (locid==currloc){
								//alert("UV");
								INComDisSum="Y";
								break;
							}
						}
					}
					if((INComDisSum=="Y")&&(Discharge=="")) {
						returntext+=t['InComDisSum']+"\n";
						Discharge="Y";
					}
				}

			}

			if(returntext!="") {				
				var choice=confirm(returntext+"\n"+t['CONTINUE']);
				if(choice) {
					UpdateClickHandler();
				}
				else{ return false;}
			}
			else{UpdateClickHandler();}
		}
	}
	//----------------
	//UpdateClickHandler();
}
function UpdateClickHandler() {
	//alert("about to update");
	var dm="";  var tm=""; 	var rm=""; var requestid=""; var rtnm="";	
	var requestStatus="";	var AllowToUpdate=true;
	// if ID is present only Update the Request Do not create new one or track out.
	
	//getVolRowIds();
	if(getVolRowIds()=="FAIL") return false;
	var iobj=document.getElementById("RequestID");
	if (iobj) requestid=iobj.value;
	
	var rsobj=document.getElementById("ReqStatus");
	if (rsobj) requestStatus=rsobj.value;
	if (rsobj) {
		statusAry=rsobj.value.split(",");
		requestStatus=statusAry[0];
	}

	//AmiN 20 May 2002 Added Date and Time as Mandatory fields. 

	var Dateobj=document.getElementById("RTREQDate");
	if ((Dateobj) && (Dateobj.value=="")) {		
		dm=t['DateMandatory'] + "\n";
	}
				
	var Timeobj=document.getElementById("RTREQTime");
	if ((Timeobj) && (Timeobj.value=="")) {	
		tm=t['TimeMandatory'] +  "\n";
	}

	var Rtnobj=document.getElementById("MRReturnDate");
	if ((Rtnobj) && (Rtnobj.value!="")) {
		if (DateStringCompareToday(Rtnobj.value)<0) rtnm=t['INVALID_RTNDATE'] +  "\n";
	}

	// ANA LOG 33983 
	var RequestForm=document.forms["fRTMasVol_FindRequestVolume"];
	//alert("RequestForm"+RequestForm+"MoveFlag="+MoveFlag);
	if (RequestForm) {
		var FREQtbl=RequestForm.document.getElementById("tRTMasVol_FindRequestVolume");
		//alert("FREQtbl"+FREQtbl);
		if(FREQtbl){
			var ReqVolIds=""; var RTMAVRowIds="";
			for (var c=1; c<=FREQtbl.rows.length; c++) {
				var RMobj=FREQtbl.document.getElementById("RTMAVRowIdz"+c);
				var RVobj=FREQtbl.document.getElementById("ReqVolIDz"+c);
				var AVobj=FREQtbl.document.getElementById("AddVolz"+c);
				//if ((RMobj)&&(RVobj)&&(RVobj.value!="")&&(RMobj!="")) {
				if ((RMobj)&&(RVobj)&&(AVobj)&&(AVobj.checked)) {
					RTMAVRowIds=RTMAVRowIds+RMobj.value+"^";
					ReqVolIds=ReqVolIds+RVobj.value+"^";
				}
			}
			var NTOBJ=document.getElementById("NewTrans");
			if((NTOBJ)&&(NTOBJ.value=="1")&&(MoveFlag=="Y")) ReqVolIds="";
			//Log 47537 23/11/04 PeterC
			var HROBJ=document.getElementById("hidReqID");
			if((HROBJ)&&(HROBJ.value=="")&&(MoveFlag=="Y")) ReqVolIds="";
			var rqidsOBJ=document.getElementById("ReqVolIds");
			if (rqidsOBJ) rqidsOBJ.value=ReqVolIds;
			var rqmasOBJ=document.getElementById("RTMAVRowIds");
			if (rqmasOBJ) rqmasOBJ.value=RTMAVRowIds;
			//alert(ReqVolIds+"**"+RTMAVRowIds);
			//return false;
		}
	}
	// 56931
	var Reasonobj=document.getElementById("RTREQReqReasonDR");
	if ((Reasonobj) && (Reasonobj.className=="clsInvalid")) {
		alert(t['RTREQReqReasonDR'] + " " + t['INVALID']);
		return false;
	}
	/* PeterC Log 28688 25/09/2002 make the field reason unmandatory
	var Reasonobj=document.getElementById("RTREQReqReasonDR");
	if ((Reasonobj) && (Reasonobj.value=="")) {	
		rm=t['ReasonMandatory'] +  "\n";
	}
	*/	
	var patid="";	var reqid="";	var ac="";
	var pobj=document.getElementById("PatientID");
	if (pobj) patid=pobj.value;
	
	var PAObj=document.getElementById("RTREQPatientAttending");
	//Log 52162 12/05/05 PeterC: Need to blank out the variable "ReqIds" on Update
	var QObj=document.getElementById("ReqIds");
	if(QObj) QObj.value="";

	var vidObj=document.getElementById("VolumeIDs");
	if (MoveFlag!="Y") {
			if ((vidObj) && (vidObj.value!="")) {
			if ((requestid!="") && (requestStatus=="X")) AllowToUpdate=false;
			if (AllowToUpdate) {
				//alert("in here"+window.opener);
				if ((dm !="") || (tm !="")  || (rm !="") || (rtnm !="")){
					alert(dm + tm + rm + rtnm); 	
				}else {
					//alert("MoveFlag="+MoveFlag);
					return Update1_click();
				}
			} else {	
				ac=t['AlreadyCancelled'];	
				//alert(t['AlreadyCancelled']);
				window.close();
			}
		}
	} else {
			if (vidObj) vidObj.value="";
			//alert("about to update and move");
			return UpdateMove_click();
	}
}
function getVolRowIds() {
	var eTABLE=document.getElementById("tRTMasVol_FindRequestVolume");
	var VolDesc="";
	var Rowid="";
	if (eTABLE) {
		if (eTABLE.rows.length>0) {
			var pObj=document.getElementById("RTMAVRTMASParRefz1");
			if (pObj) Rowid=pObj.value;
			var mObj=document.getElementById("RTREQMRNoDR");
			if (mObj) mObj.value=Rowid;
		}
		for (var i=1; i<eTABLE.rows.length; i++) {
			var AddObj=document.getElementById("AddVolz"+i);
			if (AddObj.checked) {
				var vObj=document.getElementById("IDz"+i);
				if (vObj) {
					if (VolDesc=="") {
						VolDesc=vObj.value;
					} else {
						VolDesc=VolDesc+"^"+vObj.value;
					}
				}			
			}
		}
	}
	var obj=document.getElementById("outstanding");
	if ((obj)&&(obj.value!="N")&&(VolDesc=="")) {
		alert(t['Select_Volume']);
		return "FAIL";
	}

	if((obj)&&(obj.value=="N")&&(VolDesc=="")){
		var robj=document.getElementById("ReqIds");
		var vidObj=document.getElementById("VolumeIDs");
		if((robj)&&(robj.value!="")){
			VolDesc=robj.value;
		}
	}
	var vidObj=document.getElementById("VolumeIDs");
	if (vidObj) vidObj.value=VolDesc;
}

function CareProvLookUpHandler(str) {
	if ((objRTREQDoctorDR)&&(objRTREQPagerNo)) {
		var lu = str.split("^");
		//Default Pager number when Care Provider selected
		if (objRTREQPagerNo) objRTREQPagerNo.value = lu[2];
	}
}
function HospitalLookUpHandler(str) {
	//alert(str);
	var HospID="";
	var lu = str.split("^");	
	var hdrobj=document.getElementById("CurrHospitalDR");
	if (hdrobj) {
		HospID=hdrobj.value;
		hdrobj.value=lu[0];
	}
	var hdcobj=document.getElementById("HospitalDesc");
	if (hdcobj) hdcobj.value=lu[1];

	var rlcobj=document.getElementById("RTREQReqLocDR");
	if ((rlcobj)&&(HospID!=lu[0])) rlcobj.value="";
}

//log 60440 Bo 03-08-2006: changes made to handle telephone number and extensions which are different with the defaults in RTRequest.Edit.
//If the telephone number and the extensions have been saved, the saved numbers are being displayed instead of the default number (e,g. empty).
var ReqLocLookUpFlag=0;
if (objHidRTREQReqLocDR.value=="") ReqLocLookUpFlag++;

function ReqLocLookUpHandler(str) {
	if (ReqLocLookUpFlag==0) {
		ReqLocLookUpFlag++;
		return;
	}
	var LocID="";
	var lu = str.split("^");
	LocID=lu[1];
	if (HRLobj) HRLobj.value=LocID;
	if ((objRTREQReqLocDR)&&(objRTREQReqTelNo)) {
		//Default telephone number when requesting location selected
		if (objRTREQReqTelNo) objRTREQReqTelNo.value = lu[8];
	}	
	if ((objRTREQReqLocDR)&&(objRTREQReqExtNo)) {
		//Default extension number when requesting location selected
		if (objRTREQReqExtNo) objRTREQReqExtNo.value = lu[9];
	}

	if (LocID!="") {
		var tbl=document.getElementById("tRTMaster_FindAllBookedRequest");
		var ReqLocDuplicateCount=0;
		var DLobj="";
		var twkfli="";
		var twObj=document.getElementById("TWKFLI");
		if (twObj) twkfli=twObj.value-1;
		if(tbl){
			for (var j=1;j<tbl.rows.length;j++) {
				var obj=document.getElementById('RTReqLocIDz'+j);
				if ((obj)&&(obj.value==LocID)){
					ReqLocDuplicateCount++;
					var DLobj=document.getElementById("CTLOCDescz"+j);
					var arr=DLobj.href.split("?");
					DLobj.href=arr[0]+"?TWKFLI="+twkfli+"&"+arr[1];
					//alert(DLobj.href);		
				}
			}
			if(ReqLocDuplicateCount==1) {
				var choice=confirm(t['REQ_EXIST']);
				if(choice) {
					window.location=DLobj.href;
				}
				else{ return true;}
			}

			if(ReqLocDuplicateCount>1) {
				alert(t['REQ_MULTIPLE']);
				return true;
			}
		}
	}
}

function EnterKey(e) {
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if ((websys_getAlt(e)&&keycode!=18)||(keycode==33)||(keycode==34)) {
		try {	
			var key=String.fromCharCode(keycode);
				//if (key=="D") DeleteClickHandler();
				if (key=="U") UpdateClickHandler();
				//if (key=="A") AddClickHandler();
				//if (key=="F") AddToFavClickHandler();
				//if (key=="O") OrderDetailsClickHandler();				
				//websys_sckeys[key]();
				//websys_cancel();
		}
		//catch and ignore
		catch(e) {}
	}
	
}

function UpdateClickTestReason(){
	var Robj=document.getElementById("RTREQReqReasonDR");
	if((Robj)&&(Robj.value=="")){
		//log59072 Tedt
		alert(t['RTREQReqReasonDR']+" "+t['IsMandatory']+" "+t['Update1']);
		return false;
	}
	else {UpdateClickHandler();}
}

function BodyLoadHandler(){
	var Uobj=document.getElementById("Update1");
	if (Uobj) { Uobj.onclick=UpdateClickTestReason;}
	if (tsc['Update1']) {
		websys_sckeys[tsc['Update1']]=UpdateClickTestReason;
	}
	var UMobj=document.getElementById("UpdateMove");
	if (UMobj) { UMobj.onclick=UpdateMoveClickHandler;}
}

