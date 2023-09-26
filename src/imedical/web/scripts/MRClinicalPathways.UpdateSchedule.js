// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
var CPSchedForm=document.forms["fMRClinicalPathways_CarePlanSchedule"];
var ScheduleForm=document.forms["fMRClinicalPathways_Schedule"];
var UpdateForm=document.forms["fMRClinicalPathways_UpdateSchedule"];
var hidItemCnt=0;
function UpdateClickHandler() {
	var time=""; var date="";
	var dtobj=UpdateForm.document.getElementById("Date");
	var tmobj=UpdateForm.document.getElementById("Time");
	var OEobj=UpdateForm.document.getElementById("ORIRowIDs");
	var hasTop="";
	//Log 43072 11/06/04 PeterC: Added the try-catch due to error from non-conflict update
	try {
		if (top.opener.document.getElementById("tMRClinicalPathways_ConfSched")) hasTop=1;
	}catch(e){}
	if (dtobj) date=dtobj.value;
	if (tmobj) time=tmobj.value;
	BuildQueryString(date,time);
	if ((date=="")&&(time=="")) {
		if(hasTop==1){
			if (top.opener.document.getElementById("tMRClinicalPathways_ConfSched")) {
				if (UpdateForm) {
					top.location="websys.close.csp"
					return false;
 				} 
 			}
		}
		if (UpdateForm.elements["XTRELOADID"]) UpdateForm.elements["XTRELOADID"].value="";
 		Update_click();
		return false;
	}

	DUMMYHiddenUpdate_click();
	return false;

	//// No longer required - 60386
	//ANA LOG 31442 Added to refresh back into Schedule page after booking. Hidden button was added. 
	//Clikcing update will take you into the carePlan.List page.
	//alert("update"+date+"  "+time+" "+OEobj.value);
	//DUMMYHiddenUpdate_click();
	//alert("After DUMMYHiddenUpdate_click");
	//Log 43072 11/06/04 PeterC: Added the below line to make the page stay on "MRClinicalPathways.UpdateSchedule"
	//if (ConfSelect=="Y") {
	//	var openwindow=top.opener;
	//	//if (openwindow) alert("openwindow.name="+openwindow.name);
	//	if ((openwindow)&&(openwindow.name=="frmConfSched")) openwindow.RefreshBooking();
	//	window.close();	
	//}
	//else {
	//	window.history.go(0);
	//}
	//return false;
	
	//return Update_click();
}
function BuildQueryString(date,time){
	var QueryString="";
	var rebookoeorlist="";
	var fdate=""
	var ftime=""
	DeleteAllHiddenItems();
	var CPStbl=CPSchedForm.document.getElementById("tMRClinicalPathways_CarePlanSchedule");
	var servid="";
	var serv=CPSchedForm.document.getElementById("StepServiceID");
	if (serv) servid=serv.value
	var fdateobj=ScheduleForm.document.getElementById("fapptdate");
	if (fdateobj) fdate=fdateobj.value
	var ftimeobj=ScheduleForm.document.getElementById("fappttime");
	if (ftimeobj) ftime=ftimeobj.value
	var fservidobj=ScheduleForm.document.getElementById("fservid");
	if (fservidobj) fservid=fservidobj.value
	if ((window.opener)&&(self==top)&&(CPSchedForm)) {
		if (CPStbl){
			for (var c=1; c<=CPStbl.rows.length; c++) {
				var SCobj=CPStbl.document.getElementById("Selectz"+c);
				if (SCobj&&SCobj.checked) {
					var OEORIobj=CPStbl.document.getElementById("ORIRowIDz"+c);
					var ARCIMobj=CPStbl.document.getElementById("ARCIMRowIdz"+c);
					// ANA LOG 27641 This should always have only 1 item.Run when accessing from the conflicting screen.
					// BMC Log 36001 This can contain more than one item 
					if ((OEORIobj)&&(OEORIobj.value!="")) {
						QueryString=QueryString+OEORIobj.value+"&"+date+"&"+time+"&"+servid+"^";
						rebookoeorlist=rebookoeorlist+OEORIobj.value+"&"+fdate+"&"+ftime+"&"+fservid+"^";
					}
				}
			}
		}	
		var qsobj=document.getElementById("QueryString");
		if (qsobj) qsobj.value=QueryString;
		//alert(QueryString+"  ,  "+rebookoeorlist);
		var rebookoeorlistobj=document.getElementById("rebookoeorlist");
		if (rebookoeorlistobj) rebookoeorlistobj.value=rebookoeorlist;
	} else if (CPSchedForm) {
		if (CPStbl){
			var ServiceID="";
			var SSobj=document.getElementById('StepServiceID');
			if (SSobj) ServiceID=SSobj.value;
			// ANA LOG 31442 13-JAN-02. Freq & Duration entered on MRClinicalPathways.CarePlanSchedule 
			// page should override the default freq and durtion of the items
			var DurF=""; var IntInDays=""; var DispTime=""; var dur=""; var freq="";
			var fqOBJ=CPSchedForm.document.getElementById('PHCFRDesc1');
			if (fqOBJ&&(fqOBJ!="")) freq=fqOBJ.value;
			var ddOBJ=CPSchedForm.document.getElementById('PHCDUDesc1');
			if (ddOBJ&&(ddOBJ!="")) dur=ddOBJ.value;
			var DFobj=CPSchedForm.document.getElementById('DurFactor');
			if (DFobj&&(DFobj.value!="")) DurF=parseInt(DFobj.value);
			var fqINTobj=CPSchedForm.document.getElementById('IntInDays');
			if (fqINTobj&&(fqINTobj.value!="")) IntInDays=parseInt(fqINTobj.value);
			var DTobj=CPSchedForm.document.getElementById('DispTime');
			if (DTobj&&(DTobj.value!="")) DispTime=DTobj.value;
			//alert("obj= "+DTobj+" value "+DTobj.value);
			//alert("dur "+DFobj.value);
			
			for (var c=1; c<=CPStbl.rows.length; c++) {
				var SCobj=CPStbl.document.getElementById("Selectz"+c);
				if (SCobj&&SCobj.checked) {
					var OEORIobj=CPStbl.document.getElementById("ORIRowIDz"+c);
					var ARCIMobj=CPStbl.document.getElementById("ARCIMRowIdz"+c);
					var DURobj=CPStbl.document.getElementById("Durationz"+c);
					var DispObj=CPStbl.document.getElementById("DipensingTimez"+c);
					//alert("Update schedule");
					var IntObj=CPStbl.document.getElementById("FreqIntDays1z"+c);
					var duration=0; var DipensingTime=""; var FreqIntDays=0;
					
					if ((DurF!="")&&(dur!="")) { // 14Jan02 override LOG 31442
						duration=DurF;
					} else {
						if (DURobj.value=="") duration=1;
						else duration=parseInt(DURobj.value);
					}
					//alert("Disp Time =" +DispTime+" time="+time);
					 if ((DispTime!="")&&(freq!="")) {// 14Jan02 override LOG 31442
					 	DipensingTime=DispTime;
					 } else {
					 	if (DispObj&&(DispObj.value)&&(DispObj.value!="")){
							var ARR=DispObj.value.split("*");
							DispObj.value=ARR.join("^")
							DipensingTime=DispObj.value;
						}
					}
					
					//alert("DipensingTime =" +DipensingTime);
					if ((IntInDays!="")&&(freq!="")) {// 14Jan02 override LOG 31442
						FreqIntDays=IntInDays;
					} else {
						if (IntObj.value=="") FreqIntDays=1;
						else FreqIntDays=parseInt(IntObj.value);
					}
					//alert("duration "+duration+" FreqIntDays="+FreqIntDays+" DipensingTime="+DipensingTime);
					//return;
					for (var d=1;d<=duration;d=d+FreqIntDays) {
						var wkCount;
						wkCount=getwkCount(d);
						var timeDifference=0;
						var DispTimeArray=DipensingTime.split("^");
						if (DispTimeArray) {
							//alert("hello "+DispTimeArray.length)
							//BM changed from e<DispTimeArray.length-1 to e<DispTimeArray.length
							//for(var e=0;e<DispTimeArray.length-1;e++){
							for(var e=0;e<DispTimeArray.length;e++){
									var tm; var dt; var SchedID="";
									//ANA 25JUL02. If there is no dispensing time Setup.no bookings will be made.
									tm=parseInt(DispTimeArray[e]); dt=parseInt(date)+parseInt(d)-1;
									if (e==0) timeDifference=getTimeDifference(tm,time);
									//alert("tm="+tm+" timeDifference="+timeDifference);
									tm=parseInt(tm)+parseInt(timeDifference);
									if (isNaN(Number(tm))) tm=parseInt(time);
									//alert("tm="+tm+" timeDifference="+timeDifference);
									//alert("Date="+dt+"  Time="+tm);
									var SchedIDObj=ScheduleForm.document.getElementById("SchedIDz"+tm+"^"+dt);
									if (SchedIDObj) SchedID=SchedIDObj.value;
									//alert("ServiceID "+ServiceID);
									if ((OEORIobj)&&(OEORIobj.value!="")) QueryString=QueryString+OEORIobj.value+"&"+dt+"&"+tm+"&"+ServiceID+"&"+SchedID+"^";
							}
							//alert("AddInput="+QueryString);
							AddInput(QueryString);
							QueryString="";
						}
					}
				}
			}
		}
		//alert(hidItemCnt);
		document.fMRClinicalPathways_UpdateSchedule.kCounter.value = hidItemCnt;	
	}
}
function getTimeDifference(dispTime,selTime){
	var Difference=0
	Difference=parseInt(selTime)-parseInt(dispTime);
	return Difference
}
function getwkCount(day) {
	var wkcount;
	if (day%7==0) wkcount=parseInt(day/7);
	if (day%7>0) wkcount=parseInt(day/7)+parseInt(1);
	//alert(day+"week count "+wkcount)
	return wkcount;
}
//ANA LOG 27641 23-AUG-02. Avoiding MAXSTRING error. Adding new item for every row.
function AddInput(value) {
	hidItemCnt++;
	//Create a new element
	var NewElement=document.createElement("INPUT");
	//set the properties
	NewElement.id = 'hiddenitem' + hidItemCnt;
	NewElement.name = 'hiddenitem' + hidItemCnt;
	//NewElement.value = escape(value);
	NewElement.value = value;
	NewElement.type = "HIDDEN";

	//alert(NewElement.value);		

	document.fMRClinicalPathways_UpdateSchedule.dummy.insertAdjacentElement("afterEnd",NewElement);	
}
function DeleteAllHiddenItems() {
	for (i=1; i<=hidItemCnt; i++) {
		//var id="'"+"hiddenitem"+hidItemCnt+"'";
		var id="hiddenitem"+hidItemCnt;
		var objhid=document.getElementById(id);
		if (objhid) objhid.outerText='';		
	}
	hidItemCnt=0;
}

function BodyLoadHandler() {
	//alert("BodyLoadHandler Update Schedule");
	var ServString="";
	var SSobj=CPSchedForm.document.getElementById('ServString'); 
	if (SSobj) ServString=SSobj.value;
	if (ServString!="") {
		//alert("ServString="+ServString);
		SERDescLookUpSelect(ServString);
	}
	
	var upobj=document.getElementById("Update");
	if (upobj) upobj.onclick=UpdateClickHandler;

	var Deselectobj=document.getElementById("DeselectAll"); //AmiN log 30869
	if (Deselectobj){ Deselectobj.onclick = DeselectAll; } 
	
	var Selectobj=document.getElementById("SelectAll"); //AmiN log 30869
	if (Selectobj) { Selectobj.onclick = SelectAll; } 
	
	if (FocusWindowName!="") {
	  	var openwin = window.open("",FocusWindowName);
		if (openwin) openwin.focus();
  	}

}
function RefreshBooking() {
	window.history.go(0);
}
document.body.onload=BodyLoadHandler;