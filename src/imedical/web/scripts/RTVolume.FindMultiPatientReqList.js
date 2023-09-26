// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//w642dev
var tbl=document.getElementById("tRTVolume_FindMultiPatientReqList");
var hiddenTelNo="";
var selFlag=0;

/// 59790 /// MODE="BatchCreate"
var MODE=""
if (document.getElementById("MODE")) MODE=document.getElementById("MODE").value;
////

function SelectAll(evt) {
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			var sobj=document.getElementById("Selectz"+i);
			var vobj=document.getElementById("hidRTMAVVolDescz"+i);
			if ((sobj) && (sobj.disabled==false) ) {
				if (((vobj)&&(vobj.value!=""))||(MODE=="BatchCreate")) sobj.checked=true;
			}

		}
	}
	return false;
}

function RefreshAfterNewVolume(){
	window.treload("websys.reload.csp");
}

/*
function PrintList(evt) {
	var PrintListId="";
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			var vobj=document.getElementById("RTMAVRowIdz"+i);
			if ((vobj)&&(vobj.value!="")) {
				if (PrintListId!="") PrintListId=PrintListId+"^";
				PrintListId=PrintListId+vobj.value;
			}
		}
	}
	alert(PrintListId);
	return false;
}
*/

function UpdateHandler(evt) {
	//alert(parent.frames[0].document.getElementById("VolDescs").value);
	//alert(parent.frames[0].document.getElementById("patids").value);
	//alert(parent.frames[0].document.getElementById("TYPIDs").value);

	var Rtnobj=document.getElementById("ReturnDate");
	if ((Rtnobj)&&(Rtnobj.value!="")) {
		if (DateStringCompareToday(Rtnobj.value)<0) {
			alert(t['INVALID_RTNDATE']);
			return false;
		}
	}

	var MRLobj=document.getElementById("MRLocation");
	if((MRLobj)&&(MRLobj.value!="")&&(MRLobj.className=="clsInvalid")) {
		alert("'"+t['MRLocation']+ "' "+t['XINVALID']);
		return false;
	}

	//log59488 Tedt clear hidden variable values if MRLocation is empty
	if(MRLobj.value==""){
		var MRLID = document.getElementById("MRLocationID");
		if(MRLID) MRLID.value="";
		var MRLDR = document.getElementById("MRLocationDR");
		if(MRLDR) MRLDR.value="";
		hiddenTelNo="";
		var Ext = document.getElementById("RTREQReqExtNo");
		if(Ext) Ext.value="";
	}

	//BM Log 34846 Check for records without volume
	var tbl=document.getElementById("tRTVolume_FindMultiPatientReqList");
	for (var i=1;i<tbl.rows.length;i++) {
			var sObj=document.getElementById("Selectz"+i);
			if ((sObj) && (sObj.checked) && (!sObj.disabled)) {
				var vdObj=document.getElementById("hidRTMAVVolDescz"+i);
				if ((vdObj)&&(vdObj.value=="")) {
					alert(t['Empty_Volume']);
					return false;
				}
			}
	}

	var BPobj=document.getElementById("BulkPatient");
	if((BPobj)&&(BPobj.value=="Y")) {
		var LocDescUpper,HomeLocList,returnText=""
		var obj=document.getElementById("MRLocation");
		if((obj)&&(obj.value!="")) {
			LocDescUpper=obj.value;
			LocDescUpper=LocDescUpper.toUpperCase();
			for(var i=1;i<tbl.rows.length;i++) {
				var HomeLocList=""
				VObj=document.getElementById("ICDVerifiedz"+i);
				var sObj=document.getElementById("Selectz"+i);
				if((VObj)&&(VObj.value=="1")&&(sObj)&&(sObj.checked))
				{
					HLLObj=document.getElementById("HomeLocListz"+i);
					HNObj=document.getElementById("hidNamez"+i);
					PRNObj=document.getElementById("HidPatRegNoz"+i);
					HMTObj=document.getElementById("HidMRTypez"+i);
					HTDObj=document.getElementById("HidTypeDescz"+i);
					CMObj=document.getElementById("CurrMRNz"+i);
					if((HLLObj)&&(HLLObj.value)!="") {
						//alert(HLLObj.value);
						HomeLocList=HLLObj.value;
						HomeLocList=HomeLocList.toUpperCase();
						var adata=HomeLocList.split("^");
						for (var jk=0;jk<adata.length;jk++) {
							var currloc=adata[jk];
							//if (LocDescUpper==currloc) returnText=returnText+HNObj.value+t['REGNO']+PRNObj.value+t['REGNO']+CMObj.value+t['RECORDTYPE']+HMTObj.value+t['VOLUME']+HTDObj.value+"\n";
							if (LocDescUpper==currloc) returnText=returnText+HNObj.value+t['MRN']+CMObj.value+t['RECORDTYPE']+HMTObj.value+t['VOLUME']+HTDObj.value+"\n";
						}
					}

				}
			}
		}
		if(returnText!="") {
			var choice=confirm(returnText+"\n"+t['CONTINUE']);
			if(!choice) return false;
		}
	}

	var obj=document.getElementById("MRLocation");
	var tbl=document.getElementById("tRTVolume_FindMultiPatientReqList");


	//alert(parent.frames[0].name);
	var fr=parent.frames[0];
	//alert(fr.name);
	if (fr) {
		if (fr.name=="FindBulkRequest") {
			var bFlag=1;
			var check=CheckRequest(obj,tbl,"N","epr.default.csp",bFlag);
			if (!check) return false;
			if (selFlag&&obj&&obj.value=="") {
				alert(t['NoLocation']);
				return false;
			}
			return Update1_click();
		} else {
			UpdateBulkTracking(obj,tbl);
		}
	}
}

function UpdateBulkTracking() {
	//check that records with no requests requires the MRLocation field to be filled
	//alert("updating");
	var obj=document.getElementById("MRLocation");
	var tbl=document.getElementById("tRTVolume_FindMultiPatientReqList");
	var alertmsg="";

	if ( (!obj) || ((obj)&&(obj.value=="")) ) {
		if (tbl) {
			for (i=1; i<tbl.rows.length; i++) {
				var obj=document.getElementById("Selectz"+i);
				if ((obj)&&(obj.checked)&&(document.getElementById("ReqVolIDz"+i).value=="")) {
					alert(t['RequiredLocation']);
					return false;
				}
			}
		}
	}
	var cobj=document.getElementById("CreateReqConfig");
	//alert(cobj.value);
	if (cobj) {
		if (cobj.value=="Y") {
			var bFlag=0;
			var check=CheckRequest(obj,tbl,"Y","rtvolume.multipatientreqlist.csp",bFlag);
		}
		else {
			if ((obj)&&(tbl)) {
				var MRLocDesc="";
				var mrdescobj=document.getElementById("MRLocation");
				if (mrdescobj) MRLocDesc=mrdescobj.value;

				for (i=1; i<tbl.rows.length; i++) {
					var obj=document.getElementById("Selectz"+i);
					var loc=document.getElementById("RTMAVCurLocDescz"+i);
					var vol=document.getElementById("RTMAVVolDescz"+i);
					var typ=document.getElementById("RTMAVTYPDescz"+i);;
					var reg=document.getElementById("PatRegNoz"+i);
					var mrn=document.getElementById("MRNz"+i);
					var patient="";
					if (reg) patient=t['PATIENT']+" "+reg.innerText+" ";
					else if (mrn) patient=t['PATIENT']+" "+mrn.innerText+" ";
					if (vol) patient=patient+t['VOL']+" "+vol.innerText+" ";
					if (typ) patient=patient+t['RECTYPE']+" "+typ.innerText+"\n";
					var errors="";
					if ((obj)&&(obj.checked)) {
						if ((loc)&&(loc.innerText==MRLocDesc)) {
							errors=errors+t['SAMELOC']+"\n";
						}
						// BM Log 34845
						if (MRLocDesc==document.getElementById("HomeLocDRz"+i).value&&document.getElementById("TempHomeLocDRz"+i).value!="") {
							//if (!confirm(t['TempHomeLocExists']+document.getElementById("RTMAVVolDescz"+i).innerText+" of type "+document.getElementById("RTMAVTYPDescz"+i).innerText+" of patient "+document.getElementById("PatNamez"+i).innerText+"\r\n"+t['DoContinue'])) {
							//	return false;
							//}
							errors=errors+t['TempHomeLocExists']+"\n";
						}
					}
					if (errors!="") alertmsg=alertmsg+patient+errors+"\n"
				}
				if ((alertmsg!="")&&(!confirm(alertmsg+t['DoContinue']))) return false;
			}
		}
	}

	return Update1_click();


	//return false;
	//if (check==true) {return Update1_click();} else {return false;}
}

function CheckRequest(obj,tbl,CreateTrans,DirectTo,bFlag) {
	var pidvolids="";
	var check=false;
	var MRLocID="";
	var MRLocDR="";
	var MRLocDesc="";
	var TelExt="";
	var alertmsg="";

	if (obj) {
		var mridobj=document.getElementById("MRLocationID");
		var mrdescobj=document.getElementById("MRLocation");
		var mrdrobj=document.getElementById("MRLocationDR");
		if (mridobj) MRLocID=mridobj.value;
		if (mrdescobj) MRLocDesc=mrdescobj.value;
		if (mrdrobj) MRLocDR=mrdrobj.value;
		var extobj=document.getElementById("RTREQReqExtNo");
		if (extobj) TelExt=extobj.value;

		for (i=1; i<tbl.rows.length; i++) {
			var obj=document.getElementById("Selectz"+i);
			var loc=document.getElementById("RTMAVCurLocDescz"+i);
			var vol=document.getElementById("RTMAVVolDescz"+i);
			var typ=document.getElementById("RTMAVTYPDescz"+i);
			var reg=document.getElementById("PatRegNoz"+i);
			var mrn=document.getElementById("MRNz"+i);
			var patient="";
			if (reg) patient=t['PATIENT']+" "+reg.innerText+" ";
			else if (mrn) patient=t['PATIENT']+" "+mrn.innerText+" ";
			if (vol) patient=patient+t['VOL']+" "+vol.innerText+" ";
			if (typ) patient=patient+t['RECTYPE']+" "+typ.innerText+"\n";
			var errors="";
			if ((obj)&&(obj.checked)) {
				selFlag=1;
				var RVOBJ=document.getElementById("ReqVolIDz"+i);
				var RTMOBJ=document.getElementById("hidRTMAVRequestDRz"+i)
				var RTRQOBJ=document.getElementById("RTREQReqLocDRz"+i)
				var RTMPOBJ=document.getElementById("RTMASPatNoDRz"+i)
				var RTMVROBJ=document.getElementById("RTMAVRowIdz"+i)
				if ((loc)&&(loc.innerText==MRLocDesc)) {
					errors=errors+t['SAMELOC']+"\n";
				}
				// BM Log 34845
				if (MRLocDesc==document.getElementById("HomeLocDRz"+i).value&&document.getElementById("TempHomeLocDRz"+i).value!="") {
					//if (!confirm(t['TempHomeLocExists']+document.getElementById("RTMAVVolDescz"+i).innerText+" of type "+document.getElementById("RTMAVTYPDescz"+i).innerText+" of patient "+document.getElementById("PatNamez"+i).innerText+"\r\n"+t['DoContinue'])) {
					//	return false;
					//}
					errors=errors+t['TempHomeLocExists']+"\n";
				}
				if (RVOBJ&&RTMOBJ&&RTRQOBJ&&RTMPOBJ&&RTMVROBJ) {
					//Log 38914 PeterC 08/09/03 Checking for RTMAVRequestDR removed
					//if ((document.getElementById("ReqVolIDz"+i).value!="") && (document.getElementById("hidRTMAVRequestDRz"+i).value==null) && (MRLocID!=""))
					if ((document.getElementById("ReqVolIDz"+i).value!="") && (MRLocID!="")) {
						//if (document.getElementById("RTREQReqLocDRz"+i).value!=MRLocID) {
							pidvolids=pidvolids+document.getElementById("RTMASPatNoDRz"+i).value+String.fromCharCode(2)+document.getElementById("RTMAVRowIdz"+i).value+"^";
						//}
					} else {
						if (document.getElementById("ReqVolIDz"+i).value=="") {
							//Log 38914 PeterC 08/09/03 Checking for RTMAVRequestDR removed
							//if (document.getElementById("hidRTMAVRequestDRz"+i).value==null) {
							pidvolids=pidvolids+document.getElementById("RTMASPatNoDRz"+i).value+String.fromCharCode(2)+document.getElementById("RTMAVRowIdz"+i).value+"^";
							//}
						}
					}
				}
			}
			if (errors!="") alertmsg=alertmsg+patient+errors+"\n"
		}
		if ((alertmsg!="")&&(!confirm(alertmsg+t['DoContinue']))) return false;
		//alert(pidvolids);
		//CreateRequest(volids);
		var patid="";
		var reqid="";
		var ReqLoc="";
		var recvby="";
		var vols="";
		var pobj=document.getElementById("PatientIDs");
		if (pobj) patid=pobj.value;
		var robj=document.getElementById("MRLocation");
		if (robj) ReqLoc=robj.value;
		var rbobj=document.getElementById("ReceivedBy");
		if (rbobj) recvby=rbobj.value;
		var vobj=document.getElementById("VolDescs");
		if (vobj) vols=vobj.value;

		//alert(CreateTrans);
		//var url="rtvolume.createbulkrequests.csp?PidMasVolid="+pidvolids+"&GoingToLoc="+ReqLoc+"&hiddenTelNo="+hiddenTelNo+"&PatientIDs="+patid+"&CreateTrans="+CreateTrans+"&Page="+DirectTo+"&ReceivedBy="+recvby+"&VolDescs="+vols;
		//alert(url);
		//top.frames["TRAK_hidden"].location.href=url;
		//alert("PARAM:"+pidvolids+","+ReqLoc+","+hiddenTelNo+","+TelExt+","+patid+","+CreateTrans+","+DirectTo+","+recvby+","+vols,bFlag);
		InsertValues(pidvolids,ReqLoc,hiddenTelNo,TelExt,patid,CreateTrans,DirectTo,recvby,vols,bFlag);
		check=true;
		//alert("updating from hidden");
	}
	return check;
}
function InsertValues(pidvolids,ReqLoc,hiddenTelNo,TelExt,patid,CreateTrans,DirectTo,recvby,vols,bFlag){
	var PidMasVolidOBJ=document.getElementById("PidMasVolid");
	if (PidMasVolidOBJ) PidMasVolidOBJ.value=pidvolids;
	var GoingToLocOBJ=document.getElementById("GoingToLoc");
	if (GoingToLocOBJ) GoingToLocOBJ.value=ReqLoc;
	var hiddenTelNoOBJ=document.getElementById("hiddenTelNo");
	if (hiddenTelNoOBJ) hiddenTelNoOBJ.value=hiddenTelNo;
	var hiddenTelExtOBJ=document.getElementById("hiddenTelExt");
	if (hiddenTelExtOBJ) hiddenTelExtOBJ.value=TelExt;
	var PatientIDsOBJ=document.getElementById("PatientIDs1");
	if (PatientIDsOBJ) PatientIDsOBJ.value=patid;
	var CreateTransOBJ=document.getElementById("CreateTrans");
	if (CreateTransOBJ) CreateTransOBJ.value=CreateTrans;
	var PageOBJ=document.getElementById("Page");
	if (PageOBJ) PageOBJ.value=DirectTo;
	var ReceivedByOBJ=document.getElementById("ReceivedBy1");
	if (ReceivedByOBJ) ReceivedByOBJ.value=recvby;
	var VolDescsOBJ=document.getElementById("VolDescs1");
	if (VolDescsOBJ) VolDescsOBJ.value=vols;
	var bFlagOBJ=document.getElementById("bFlag");
	if (bFlagOBJ) bFlagOBJ.value=bFlag;
}
function SelectRequests(len) {
	//alert(len+"*"+tbl.rows.length);
	if (tbl) {
		for (i=len; i<tbl.rows.length; i++) {
			var sobj=document.getElementById("Selectz"+i);
			var vobj=document.getElementById("RTMAVVolDescz"+i);

			if ((sobj) && (sobj.disabled==false)) {
				if ((vobj) && (vobj.value!="")) sobj.checked=true;
			}
		}
	}
	return false;
}

function docLoaded() {
	//alert("loading");
	var RFobj=document.getElementById("ReloadFlag");
	if((RFobj)&&(RFobj.value=="Y"))	RefreshParent();
	ClearField();
	if (document.getElementById("Bookedz1")) {
		var valToBecome="<IMG SRC='../images/websys/update.gif' id='Booked' title='' border=0>";
		//changeColContent(tbl,'Booked','BookedHidden','Y',valToBecome);
	}

	//Select checkboxes
	var flagobj=document.getElementById("scanFlag");
	//alert(flagobj.value);
	if(flagobj && (flagobj.value=="on"))
	{
		try{
			//alert("customs select");
			customselectChBoxes();
		}catch(e){}
	}

	else selectChBoxes();
	SetReceived();
	SetFocus();

	//var obj=parent.frames[0].document.getElementById("UR");
	//if (obj) obj.();

	var lenobj=obj=parent.frames[0].document.getElementById("TblLength");
	var pcurrMRType="";
	if (lenobj) {
		var pcurrRegNo="";
		var pcurrReqID="";
		var pcurrBatchID="";
		var pcurrMRType="";
		var pcurrVol="";

		var purobj=parent.frames[0].document.getElementById("UR");
		if (purobj) pcurrRegNO=purobj.value;

		var preqobj=parent.frames[0].document.getElementById("RequestIDs");
		if (preqobj) pcurrReqID=preqobj.value;

		var pbatchobj=parent.frames[0].document.getElementById("ReqBatchID");
		if (pbatchobj) pcurrBatchID=pbatchobj.value;

		var pmrtypeobj=parent.frames[0].document.getElementById("TYPDesc");
		if (pmrtypeobj) pcurrMRType=pmrtypeobj.value;

		var pvolobj=parent.frames[0].document.getElementById("RTMAVVolDesc");
		if (pvolobj) pcurrVol=pvolobj.value;

		//alert(pcurrMRType+"*"+pcurrVol+"$"+lenobj.value);
		//alert(pcurrRegNO+"**"+pcurrReqID+"**"+pcurrBatchID+"**");
		//alert("lenght= "+lenobj.value);
		//alert("here1:"+purobj+preqobj+pbatchobj);
		/*
		if ((lenobj.value!=null) && (lenobj.value>0)) {
			if ((pcurrRegNO=="") && ((pcurrReqID!="") || (pcurrBatchID!=""))) SelectRequests(lenobj.value);
			// BM Log 34747
			else if ((pcurrMRType!="") || (pcurrVol!="")) SelectRequests(lenobj.value);
		}
		else {
			if ((pcurrRegNO=="") && ((pcurrReqID!="") || (pcurrBatchID!=""))) SelectRequests(1);
			// BM Log 34747
			else if ((pcurrMRType!="") || (pcurrVol!="")) SelectRequests(1);
		}
		*/
	}

	if (this.name=="FindBulkTracking") {

		var tbl=document.getElementById("tRTVolume_FindMultiPatientReqList");
		var patid="";
		var pobj=document.getElementById("PatientIDs");
		//Log 49743 PeterC 17/02/05: Prompt the window only when it is not a merged URN
		var IMObj=document.getElementById("IsMerged");
		if (pobj) patid=pobj.value;
		patid=mPiece(patid,"^",0);
		//if ((tbl)&&(tbl.rows.length==1)&&(patid!="")) {
		//LOG 43002 01/04/04 PeterC: Need to run the create volume functionality for every subsequent patient that has been added to the list
		var typid="";
		var tobj=document.getElementById("TYPIDs");
		if (tobj) typid=tobj.value;
		typid=mPiece(typid,"^",0);
		var volDesc="";
		var vobj=document.getElementById("VolDescs");
		if (vobj) volDesc=vobj.value;
		volDesc=mPiece(volDesc,"^",0);
		var MRNo="";
		var mobj=document.getElementById("MRNs");
		if (mobj) MRNo=mobj.value;
		if(MRNo!="") MRNo=mPiece(MRNo,"^",0);
		//alert(typid+","+volDesc+","+pcurrMRType);
		//Log 49651 PeterC 18/02/05
		//// 59790 - Added BatchCreate condition //// 
		if ((tbl)&&(CheckVolumeReturn(patid,pcurrMRType,volDesc)!="Y")&&(MODE!="BatchCreate")&&(patid!="")&&(IMObj)&&(IMObj.value!="Y")) {
			var choice2=confirm(t['DoYouNeedToAddNewVolume']);
			if (choice2!=false) {
				// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
				websys_createWindow("rtvolume.edit.csp?PatientID="+patid+"&TYPID="+typid+"&DefaultTYPDesc=Y&DefaultVolumeDesc="+volDesc+"&URNumber="+MRNo,"New","height=350,width=450,top=200,left=250,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
			}
		}
	}
	document.onclick=SelectRow1;
	EnableFindLink();
	if (tsc['Update1']) websys_sckeys[tsc['Update1']]=UpdateHandlerDelay;

}

function EnableFindLink(){

	var fr=parent.frames[0];
	if ((fr)&&((fr.name=="FindBulkRequest")||(fr.name=="FindBulkTrack"))) {
		var obj=window.parent.frames[0].document.getElementById("find1");
		if (obj) {
			obj.onclick=window.parent.frames[0].FindClick_Handler;
			obj.disabled=false;
		}
	}
	return true;
}
//Log 49651 PeterC 18/02/05
function CheckVolumeReturn(PatientID,MRType,VolDesc) {
	var tbl=document.getElementById("tRTVolume_FindMultiPatientReqList");
	var found="";
	for (i=1; i<tbl.rows.length; i++) {
		var patidobj=document.getElementById("RTMASPatNoDRz"+i);
		var hidMRTypeObj=document.getElementById("HidMRTypez"+i);
		var hidVolDescObj=document.getElementById("hidRTMAVVolDescz"+i);
		if ((patidobj)&&(patidobj.value==PatientID)&&((MRType=="")||(hidMRTypeObj.value==MRType))&&((VolDesc=="")||(hidVolDescObj.value==VolDesc))) {
 			found="Y";
			break;
		}

	}

	var obj=window.parent.frames[0].document.getElementById("hiddenReqVolIDs");
	if((obj)&&(obj.value!="")) found="Y";

	return found;
}

function selectChBoxes() {
	//Keep Selection when loading.
	//BM LOg 34747 Do autoselect in reversed order

	var iobj=parent.frames[0].document.getElementById("selectedItems");
	if (iobj) {
		if(iobj.value!="^") var str=iobj.value.split("^");
		//alert(iobj.value);
		var iPos=0;
		var tbl=document.getElementById("tRTVolume_FindMultiPatientReqList");
		//alert("Table length="+tbl.rows.length);
		if (tbl) {
			for (var i=0;i<str.length;i++) {
				iPos=tbl.rows.length-str[i];
				//alert(iPos);
				var sobj=document.getElementById("Selectz"+iPos);
				if (sobj) {
					sobj.checked=true;
				}
			}
		}
	}

	//ANA 29-APR-02 for queensland demo. selects records if current location is same as logon location.
	//var locDesc="";
	var length=1;
	var lobj=parent.frames[0].document.getElementById("TblLength");
	if (lobj) length=lobj.value;
	var MRDesc="";
	//var locObj=document.getElementById("logLoc");
	var MRType=document.getElementById("MRTYPDesc");
	if (MRType && MRType.value!="") MRDesc=MRType.value;
	//if (locObj) locDesc=locObj.value;
	var tbl=document.getElementById("tRTVolume_FindMultiPatientReqList");
	if (tbl) {
		var defselvolids="^";
		for(var i=1;i<tbl.rows.length;i++) {
			var RVObj=document.getElementById("RTMAVRowIdz"+i);
			var sobj=document.getElementById("Selectz"+i);
			var currRT="";
			var currVol="";
			if ((RVObj)&&(RVObj.value!="")) {
				currRT=mPiece(RVObj.value,"||",0);
				currVol=mPiece(RVObj.value,"||",1);
				if (defselvolids.indexOf("^"+currRT+"||")==-1) defselvolids=defselvolids+RVObj.value+"^";
				else if(defselvolids.indexOf("^"+currRT+"||")!=-1) {
					var prefix=mPiece(defselvolids,"^"+currRT+"||",0);
					var suffix=mPiece(defselvolids,"^"+currRT+"||",1);
					var paste1=mPiece(suffix,"^",0);
					var paste2=mPiece(suffix,"^",1);
					if(parseInt(paste1)<parseInt(currVol)) {
						defselvolids=prefix+"^"+currRT+"||"+currVol+"^"+paste2
					}
				}
			}	
		}
		for(var i=1;i<tbl.rows.length;i++) {
			var Obj=document.getElementById("RTMAVRowIdz"+i);
			var SelObj=document.getElementById("Selectz"+i);
			if((Obj)&&(Obj.value)&&(defselvolids.indexOf("^"+Obj.value+"^")!=-1)&&(SelObj)) SelObj.checked=true;
		}
	}
	var LastItemSelected=0;
	var isobj=parent.frames[0].document.getElementById("ItemSelectedPassedIn");
	if (isobj) LastItemSelected=isobj.value;
	//alert(LastItemSelected);
	for (var i=tbl.rows.length-1;i>0;i--) {
		//alert(i+"#"+tbl.rows.length+"#"+(tbl.rows.length-i<LastItemSelected+1));
		if (tbl.rows.length-i<LastItemSelected+1) {
			var sobj=document.getElementById("Selectz"+i);
			if (sobj) {
				sobj.checked=true;
			}
		}
	}

	for(var i=1;i<tbl.rows.length;i++) {
		var IBObj=document.getElementById("IsBatchz"+i);
		var SObj=document.getElementById("Selectz"+i);
		if((IBObj)&&(IBObj.value=="Y")&&(SObj)){
			SObj.checked=true;
		}
	}
}

function SetReceived() {
	var tbl=document.getElementById("tRTVolume_FindMultiPatientReqList");
	if (tbl) {
		for(var i=1;i<tbl.rows.length;i++) {
		var irobj=document.getElementById("IsReceivedz"+i);
		if((irobj)&&(irobj.value=="R")) disableReceived(i);
		}
	}
}

function disableReceived(str) {

	var robj=document.getElementById("Receivedz"+str);
	if(robj) {
 		robj.onclick=BlankClickHandler;
	}

}

function BlankClickHandler() {
	alert(t['VOLREC']);
	return false;
}

function SetFocus() {
	var urobj=parent.frames[0].document.getElementById("MRN");
	if (urobj) {
		urobj.select();
		urobj.focus();
	}

}

function SetFocusToUR(str) {
	//alert(str);
	ClearField();
	var lu=str.split("^");
	var obj=parent.frames[0].document.getElementById("MRN");
	if (obj) obj.select();  //?? what does
	var mrobj=document.getElementById("MRLocationID");
	if (mrobj) mrobj.value=lu[1];
	var mrdrobj=document.getElementById("MRLocationDR");
	if (mrdrobj) mrdrobj.value=lu[8];
	hiddenTelNo=lu[8];
	var extobj=document.getElementById("RTREQReqExtNo");
	if (extobj) extobj.value=lu[9];
}

function HospitalInfo(str) {  // HOSP_Desc, HOSP_RowId, HOSP_Code *****  Log# 28782; AmiN ; 21/Nov/2002 add hospital field and restrict Going to Location*****
	var mrlocobj=document.getElementById("MRLocation");
	if (mrlocobj) mrlocobj.value="";
	var descobj=document.getElementById("HOSPDesc");
	var codeobj=document.getElementById("HospID");  //CTLOC_Hospital_DR=:hospID
	var lu=str.split("^");

	if (descobj){
		descobj.value=lu[0];
		if (codeobj){ codeobj.value=lu[1]; }
	//}else{
		//if (codeobj) { codeobj.value=""; }  //Amin log 34838 commented out for log
	}

	//alert(lu[0]+"^"+lu[1]+"^"+lu[2]);
}

/*
function PrintSelectedRowsHandler(lnk,newwin) {
	//for crystal report
	//var EpisodeID=parent.document.getElementById("EpisodeID");
	//var PatientID=parent.document.getElementById("PatientID");
	var found=0;
	//var tbl=document.getElementById("tOEOrdItem_ListEMR");
	var eSrc=websys_getSrcElement();
	var tbl=getTableName(eSrc);
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"PrintSelectz");
	//HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	//Log 19666
	//alert("here: "+aryfound.length);
	var HitCount=Math.round(Math.random() * 1000)
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		for (i in aryfound) {
			var row=aryfound[i];
			if (!f.elements["RTMAVRowIdz"+row]) continue;
			if (f.elements["RTMAVRowIdz"+row].value!="") {

				var arrParam=lnk.split("&prompt0=");
				lnk=arrParam[0];
				PassReportParameters(lnk,newwin,f.elements["RTMAVRowIdz"+row].value,HitCount);
			}
		}
	}
}
function PrintBarcodeLabelHandler(tblname,lnk,newwin) {
	var found=0;
	//var eSrc=websys_getSrcElement();
	//var tbl=getTableName(eSrc);
	//var tbl=document.getElementById(tblname);
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
	//HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	//Log 19666
	//var HitCount=Math.round(Math.random() * 1000)
	var MasVolIDs="";
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		for (i in aryfound) {
			var row=aryfound[i];
			if (!f.elements["RTMAVRowIdz"+row]) continue;
			if (f.elements["RTMAVRowIdz"+row].value!="") {
				MasVolIDs=MasVolIDs+f.elements["RTMAVRowIdz"+row].value+",";
				//lnk=arrParam[0] + "&EpisodeID="+EpisodeID + "&PatientID="+PatientID +"&prompt0=";

			}
		}
				lnk=lnk+"&rtmav="+MasVolIDs;
				if (newwin=="TRAK_hidden") {
					//alert(lnk);
					websys_createWindow(lnk,"TRAK_hidden");
				} else {
					websys_lu(lnk,false,"width="+screen.availWidth+",height="+screen.availHeight);
				}
	}
	//alert(MasVolIDs);
}
*/
//commented the PrintSelectedRowsHandler and the PrintBarcodeLabelHandler above, can be removed after testing the following
function PrintSelectedRowsHandler(tblname,lnk,newwin) {
	var found=0;
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"PrintSelectz");
	//HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	//Log 19666
	//alert("here: "+aryfound.length);
	var HitCount=Math.round(Math.random() * 1000)
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		if (newwin=="TRAK_hidden") {
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="RTMAVRowId">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					//alert(row);
					// check for specific values - these values must be hidden in the component
					if (!f.elements["RTMAVRowIdz"+row]) continue;
					if (f.elements["RTMAVRowIdz"+row].value!="") {
						document.writeln('<INPUT NAME="RTMAVRowId" VALUE="' + f.elements["RTMAVRowIdz"+row].value + '">');
					}
				}
				/*
				document.writeln('</FORM><SCR'+'IPT>');
				document.writeln('window.HFORM.submit();');
				document.writeln('</SCR'+'IPT></BODY></HTML>');
				document.close();
				*/
				//Log 63760 PeterC 28/05/07
				document.writeln('</FORM></BODY></HTML>');
				document.close();
				document.HFORM.submit();
			}
		} else {
			// for each row selected
			for (i in aryfound) {
				var row=aryfound[i];
				// check for specific values - these values must be hidden in the component
				if (!f.elements["RTMAVRowIdz"+row]) continue;
				if (f.elements["RTMAVRowIdz"+row].value!="") {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["RTMAVRowIdz"+row].value);
				}
			}
		}
	}
	//alert("Test Print");
	var obj=parent.frames[0].document.getElementById("MRN");
	if (obj) {
		//alert("RESET");
		obj.select();
		obj.focus();
	}
}

function PrintBarcodeLabelHandler(tblname,lnk,newwin) {
	var found=0;
	//var eSrc=websys_getSrcElement();
	//var tbl=getTableName(eSrc);
	//var tbl=document.getElementById(tblname);
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
	//HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	//Log 19666
	//var HitCount=Math.round(Math.random() * 1000)
	var MasVolIDs="";
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		for (i in aryfound) {
			var row=aryfound[i];
			if (!f.elements["RTMAVRowIdz"+row]) continue;
			if (f.elements["RTMAVRowIdz"+row].value!="") {
				MasVolIDs=MasVolIDs+f.elements["RTMAVRowIdz"+row].value+",";
				//lnk=arrParam[0] + "&EpisodeID="+EpisodeID + "&PatientID="+PatientID +"&prompt0=";

			}
		}
				lnk=lnk+"&rtmav="+MasVolIDs;
				if (newwin=="TRAK_hidden") {
					//alert(lnk);
					websys_createWindow(lnk,"TRAK_hidden");
				} else {
					websys_lu(lnk,false,"width="+screen.availWidth+",height="+screen.availHeight);
				}
	}
	//alert(MasVolIDs);
	//alert("Test Print");
	var obj=parent.frames[0].document.getElementById("MRN");
	if (obj) {
		//alert("RESET");
		obj.select();
		obj.focus();
	}
}

function SelectRow1(e) {
	//alert("here0");
	var eSrc=websys_getSrcElement(e);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var arry=eSrc.id.split("z");
	rowsel=arry[arry.length-1];
	var vobj=document.getElementById("RTMAVVolDescz"+rowsel);
	var irobj=document.getElementById("IsReceivedz"+rowsel);
	//alert(eSrc.id);
	//if ((eSrc.id=="Receivedz"+rowsel)||(eSrc.id=="RTMAVVolDescz"+rowsel)) return checkVolume(vobj,eSrc);
	//if ((eSrc.id=="Receivedz"+rowsel)) return checkVolume(vobj,eSrc);
	if ((eSrc.id=="Receivedz"+rowsel)&&(irobj.value!="R")) {return checkVolume(vobj,eSrc);}
	else if ((eSrc.id=="Selectz"+rowsel)) VolumeCheck();
}

function checkVolume(vobj,lnkobj) {
		//var text=""; //vobj.innerText;
		//var pattern=new RegExp(text,"i");
		if ((vobj)&&(vobj.innerText=="CreateVolume")) {
			if (lnkobj.id=="Receivedz"+rowsel) alert(t['Rec_VolCheck']);
			if (lnkobj.id=="RTMAVVolDescz"+rowsel) alert(t['Volume_Check']);
			//alert("here1");
			//alert(t['Volume_Check']);
		} else {
			//alert("here2");
			var url=lnkobj.href;
			// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
			websys_createWindow(url,"MOVE","height=250,width=400,left=250,top=200,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
		}
		return false;
}

function VolumeCheck(e){
	if (MODE=="BatchCreate") return;
	//alert("volumecheck");
	SetFocus();
	var src=websys_getSrcElement(e);
	var arry=src.id.split("z");
	rowsel=arry[arry.length-1];

	var vobj=document.getElementById("RTMAVVolDescz"+rowsel);
	if ((vobj)&&(vobj.innerText=="")){
		var sobj=document.getElementById("Selectz"+rowsel);
		if ((sobj)&&(sobj.checked)) {
			alert(t['Volume_Check']);
			//alert("Volume is blank, please create volume before update.");
			sobj.checked=false;
		}
	}

}

//// 59790 ////
function BatchCreateClick(){
	if (MODE!="BatchCreate") return;
	var Patients=""
	if (tbl) {
		for (var i=1;i<tbl.rows.length;i++) {
			var SelecttObj=document.getElementById("Selectz"+i);
			if (SelecttObj && SelecttObj.checked) {
				var PatObj=document.getElementById("RTMASPatNoDRz"+i);
				if (PatObj && PatObj.value!="") Patients=Patients + PatObj.value + "^"
			}
		}
	}
	if (Patients=="") { alert(t['NOITEMSSELECTED']); } 
	else {
		// alert("JD LIST: " + Patients);
		var url="websys.default.csp?WEBSYS.TCOMPONENT=RTVolume.Edit&BatchPats="+Patients
		websys_createWindow(url,"","top=200,left=250,width=290,height=150,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
	}

	return;
}

//AmiN log 28782 Clear out hospital information erased as to not restrict Going to Location field.
function ClearField() {
	var HOSPDescObj=document.getElementById("HOSPDesc");
	var HospIDObj=document.getElementById("HospID");
	//alert("hosp : "+HOSPDescObj.value);
	//HOSPDescObj.value="";
	//alert("obj: "+HOSPDescObj);
	if (HOSPDescObj){
		//alert("obj and blank");

		if ((HospIDObj) && (HOSPDescObj.value=="")) HospIDObj.value="";
	}else{
		//if (HospIDObj) HospIDObj.value=""; //Amin log 34838 commented out for log
	}
}


var HOSPDescObj=document.getElementById("HOSPDesc");
if (HOSPDescObj){
	 HOSPDescObj.onblur=ClearField;
}else{
	//ClearField(); //Amin log 34838 commented out for log
}

// log 28782 end

function RefreshParent(){
	window.parent.location="epr.default.csp"
}

function EnterKey(e) {
	//Log 31868
	var key = websys_getKey(e);
	var eSrc=websys_getSrcElement(e);
	if (eSrc.id!="REQComments") {
		var locobj=document.getElementById("MRLocation");
		if ((locobj)&&(key==13)) {
			locobj.blur();
			var upobj=document.getElementById("Update1");
			if (upobj) upobj.focus();
		}
	}
}

function ReceiveHandler() {
	var CONTEXT=session['CONTEXT'];
	var PatientIDs="";
	var RTMasVolIDs="";
	var VolumeDescs="";
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			var sobj=document.getElementById("Selectz"+i);
			var IRObj=document.getElementById("IsReceivedz"+i);
			if ((sobj)&&(!sobj.disabled)&&(sobj.checked)&&(IRObj)&&(IRObj.value=="Y")) {

				var HVDObj=document.getElementById("hidRTMAVVolDescz"+i);
				var PIDObj=document.getElementById("RTMASPatNoDRz"+i);
				var VIDObj=document.getElementById("RTMAVRowIdz"+i);
				if((HVDObj)&&(HVDObj.value=="")) {
					alert(t['VOL_BLANK']);
					return false;
				}
				PatientIDs=PatientIDs+PIDObj.value+"^";
				RTMasVolIDs=RTMasVolIDs+VIDObj.value+"^";
				VolumeDescs=VolumeDescs+HVDObj.value+"^";
			}
		}
	}
	var url="websys.default.csp?WEBSYS.TCOMPONENT=RTMVTrans.Received&PARREF="+RTMasVolIDs+"&PatientIDs="+PatientIDs+"&VolumeDesc="+VolumeDescs;
	url += "&CONTEXT="+CONTEXT;
	//alert(url);
	if((PatientIDs!="")&&(RTMasVolIDs!="")&&(VolumeDescs!="")) websys_lu(url,false,"");
	return false;
}

document.body.onkeydown=EnterKey;

var sobj=document.getElementById("SelectAll");
if (sobj) sobj.onclick=SelectAll;


// 59790 //
var bcobj=document.getElementById("BatchCreate");
if (bcobj) {
	if (MODE=="BatchCreate") { bcobj.onclick=BatchCreateClick; }
	else {
		bcobj.disabled=true;
		bcobj.style.visibility="hidden";}
}

//var plobj=document.getElementById("PrintList");
//if (plobj) plobj.onclick=PrintList;

//if (tbl) tbl.onclick=SetFocus;

var mrobj=document.getElementById("MRLocation");
//if (mrobj) mrobj.onclick=SetFocus;

var obj=document.getElementById("Update1");
if (obj) obj.onclick=UpdateHandlerDelay;

function UpdateHandlerDelay() {
	window.setTimeout("UpdateHandler()",500)
}

// Log: 57858-Bo-12/07/2006: create new function to handle "Bulk Inactivate"

function BulkInactivateClickHandler() {
    var CONTEXT=session['CONTEXT'];
    var PatientIDs="";
	var RTMasVolIDs="";
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			var sobj=document.getElementById("Selectz"+i);
			//var IRObj=document.getElementById("IsReceivedz"+i);
			if ((sobj)&&(!sobj.disabled)&&(sobj.checked)) {

				var HVDObj=document.getElementById("hidRTMAVVolDescz"+i);
				var PIDObj=document.getElementById("RTMASPatNoDRz"+i);
				var VIDObj=document.getElementById("RTMAVRowIdz"+i);
				if((HVDObj)&&(HVDObj.value=="")) {
					alert(t['VOL_BLANK']);
					return false;
				}
				PatientIDs=PatientIDs+PIDObj.value+"^";
				RTMasVolIDs=RTMasVolIDs+VIDObj.value+"^";
			}
		}
	}
   var url="websys.default.csp?WEBSYS.TCOMPONENT=RTMasVol.BulkInactivate&RTMasVolIDs="+RTMasVolIDs+"&PatientIDs="+PatientIDs;
   websys_lu(url,false,"");
	
}

// End of log 57858

document.body.onload=docLoaded;


