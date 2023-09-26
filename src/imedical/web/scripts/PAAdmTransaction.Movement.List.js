//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//KM 27-Aug-2002: NB: PAAdmTransaction.js works in conjunction with this file.

var f=document.getElementById("fPAADMTransaction_Movement_List");
var tbl=document.getElementById("tPAADMTransaction_Movement_List");
var f2=document.getElementById("fPAADMTransaction_Transfer_List");

//called from paadmtrans.csp
function MoveTransfersFormat() {
	var tbl=document.getElementById("tPAADMTransaction_Movement_List");
	for (var i=1;i<tbl.rows.length;i++) {
		var eSrc=f.elements["TransTypez"+i];
		if (eSrc.value=="B") {
			var obj=getRow(eSrc);
			obj.className="TransactionBooking";
		}
	}
}

function validateAction() {
	var EpisodeID=document.getElementById('EpisodeID').value;
	var ifInPath = tkMakeServerCall('web.DHCCPW.MR.Interface','GetCurrPathWay',EpisodeID);//判读是否进入临床路径
	if(ifInPath!=""){
		alert('该病人在临床路径中,如需转科请先退出临床路径!临床路径信息:'+ifInPath);
			return;
	}
	var eSrc=websys_getSrcElement(window.event.srcElement);
	if (eSrc.tagName=="IMG") var eSrc=websys_getParentElement(eSrc);
	if (eSrc.id=="NewMove") {var origcode=move;} else {var origcode=mandt;}
    
    // ab 29.09.04 - allow user to click 'new' to clear the screen on booking page
    if (document.getElementById("fPAADMTransaction_EditBooking")) {
			var EpisodeID=document.getElementById('EpisodeID').value;
			var PatientID=document.getElementById('PatientID').value;
			var TWKFL=document.getElementById('TWKFL').value;
			var TWKFLI=document.getElementById('TWKFLI').value;
			
			//url="paadmtransaction.booking.csp?TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&ID="+ID+"&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&TransType="+TransType;
			url="websys.csp?TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&ID=&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&TransType=B";
			//alert(url);
            window.location.href=url;
            return true;
    }
	
    if (document.getElementById("VisitStatus").value=="A") {
		// cjb 16/07/2003 37169.  If any of the episodes have been coded, and the User clicks New, display the warning message
		if (objcoded1.value==1) {
			var objconfirm=t['NewCoded'];
			if (confirm(objconfirm)){
				
				if (typeof origcode!="function") origcode=new Function(origcode);
				if(origcode()==false) return false;
				return false;
			}
		} else {
			if (typeof origcode!="function") origcode=new Function(origcode);
			if(origcode()==false) return false;
			return false;
			
		}
	
	
	} else {

		alert(t['NotAdmitted']);
		return false;
	}
	return true;
}

var mandt="";
var move="";
var obj=document.getElementById("NewMandT");
if (obj) {mandt=obj.onclick;obj.onclick=validateAction;}
var obj=document.getElementById("NewMove");
if (obj) {
	move=obj.onclick;
	obj.onclick=validateAction;
}


// CJB 26699 05082002

	var objsent1="";
	var objcoded1="";
	var objmessage="";
	var warned="";
	
	// Coded1 and Sent1 set in the component and indicate if any of the episodes (SMR01/FCE) for this admission have been coded or sent
	var objcoded1=document.getElementById('Coded1');
	var objsent1=document.getElementById('Sent1');

	// build up the message to display
	if (objsent1.value=="1") var objmessage=t['Sent']+"\n";
	if (objcoded1.value=="1") var objmessage=objmessage+t['Coded']+"\n";
	if (objmessage!="") var objmessage=objmessage+"\n"+t['SentCodedMsg'];

function SelectRowHandler(evt) {
	//websys.List.js has already set the selected row into a variable called selectedRowObj
	
	// ab 3.09.03 - prevent from deselecting row (was killing the episodeid passed through menus)
	if (!selectedRowObj.rowIndex) { SelectRow(); return false;}
	var url="",objType,objID;
	var eSrc=websys_getSrcElement(evt);
	if (selectedRowObj) var row=selectedRowObj.rowIndex;
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	if (eSrc.tagName=="TD") eSrc=eSrc.firstChild;
	// cjb (27036) the url variable uses eSrc.href, but takes out the workflow, so that the new window opens the edit, not the next page of the workflow
	/*
	if (eSrc.href) {
		var temp1=eSrc.href.split("&TWKFL");
		var temp2=eSrc.href.split("&ID");
		var url = temp1[0] + "&ID" + temp2[1];
	}*/
	// ab 8.03.04 - we now have a workflow for the edit component (Trak.Inpatient Movement Edit) so the above isnt needed
	url=eSrc.href;
       /// alert("ddd");
	var VisitStatus=document.getElementById("VisitStatus"); 
	var WaitList=document.getElementById("PAADMWaitListDR");
	var FirstTransM=document.getElementById("FirstTransM");
	var FirstTransT=document.getElementById("FirstTransT");
	var FirstTransB=document.getElementById("FirstTransB");
	var eSrcAry=eSrc.id.split("z");
	//alert(eSrcAry[0]);
	if ((eSrcAry[0]=="edit1")||(eSrcAry[0]=="delete1")) { 
		var objType=document.getElementById('TransType1z'+row); 
	} else {
		var objType=document.getElementById('TransTypez'+row);
	}
	if ((eSrcAry[0]=="edit1")||(eSrcAry[0]=="delete1")) { 
		var objID=document.getElementById('TRANSRowID2z'+row); 
	} else {
		var objID=document.getElementById('TRANSRowID1z'+row);
	}
	
	
	
	if (((eSrcAry[0]=="edit")||(eSrcAry[0]=="edit1"))&&(!document.getElementById("fPAADMTransaction_EditBooking"))) {
		// if any episodes for this admission have been coded or sent
		if ((objsent1.value=="1") || (objcoded1.value=="1")) {
			// display the warning message - true if OK, therefore continue to edit
			if (confirm(objmessage)) {
				// the variable 'warned' is used to set TRANS_Warned on PA_AdmTransaction.
				// warned="E" means 'Edited after warning'
				var warned="E";
				websys_createWindow(url+"&warned="+warned,"testname","top=80,left=180,width=420,height=400,scrollbars=yes,resizable=yes,status=yes");
			} else {
				return false;
			}
			// ab 5.12.02 - 30200 - dont allow edit/delete of first/booking transactions for waiting list TCI
		} else if ((VisitStatus)&&(WaitList)&&(WaitList.value!="")&&(VisitStatus.value=="P")&&
				((objType)&&(objType.value=="B"))
				) {
				alert(t["WaitListTCI"]);
				return false;
		} else if ((VisitStatus)&&(WaitList)&&(WaitList.value!="")&&(VisitStatus.value!="P")&&
				((FirstTransB)&&(objID)&&(FirstTransB.value==objID.value))
				) {
				alert(t["WaitListTCI"]);
				return false;
		} else {
			// else none of the episodes for this admission have been coded or sent, so don't display the warning message and open the edit window as normal
			//var objType=document.getElementById('TransTypez'+eSrcAry[1]);
			var objFirstBook="";
			if (eSrcAry[0]=="edit") { var objFirstBook=document.getElementById('FirstBookedz'+eSrcAry[1]); }
			if ((objType)&&(objFirstBook)&&(objType.value=="B")&&(eSrcAry[0]=="edit")&&(objFirstBook.value==1)) {
				alert(t['PreAdmDelEdit']);
			} else {
				// ab 7.10.03 - open the PAAdmTransaction.EditBooking screen for bookings
				if ((objType)&&(objType.value=="B")) {
					var re=/TWKFL=\d+/;
					url=url.replace(re,"TWKFL=");
					url="websys.default.csp?WEBSYS.TCOMPONENT=PAAdmTransaction.EditBooking&"+url.split("?")[1];
				}
				websys_createWindow(url,"testname","top=80,left=180,width=420,height=400,scrollbars=yes,resizable=yes,status=yes");
			}
		}
		return false; 
  	} else if ((eSrcAry[0]=="delete")||(eSrcAry[0]=="delete1")) {
		// if the user hits the delete button on PAAdmTransaction.Movement.List or PAAdmTransaction.Transfer.List
		// this is needed as this js overwrites the SelectRowHandler on PAAdmTransaction.Transfer.List.js
		/*if (!document.forms["fPAADMTransaction_EditBooking"]) {
			var obj=document.forms["fPAAdmTransaction_Movement_List"].TWKFLI;
			if (obj) obj.value=eval(obj.value)-1;
			alert(obj.value);
		}*/
		// RQG 19.02.03 LOG32766 - Dont allow deletion of episode if status is Preadmitted
		if (((objsent1.value=="1")||(objcoded1.value=="1"))&&((objType)&&(objType.value!="B"))) {
			if (confirm(objmessage)){
				// the variable 'warned' is used to set TRANS_Warned on PA_AdmTransaction.
				// warned="D" means 'Deleted after warning'
				var warned="D";
				eSrc.href+="&warned="+warned;
				return true;
			}else{
				return false;
			}
		} else if (((objsent1.value=="1")||(objcoded1.value=="1"))&&((objType)&&(objType.value=="B"))) {
				alert(t["BookedDel"]);
				return false;
		// ab 5.12.02 - 30200 - dont allow delete of first/booking transactions for waiting list TCI
		} else if ((VisitStatus)&&(WaitList)&&(WaitList.value!="")&&(VisitStatus.value=="P")&&
				(((objType)&&(objType.value=="B"))||
				((FirstTransM)&&(objID)&&(FirstTransM.value==objID.value))||
				((FirstTransT)&&(objID)&&(FirstTransT.value==objID.value))
				)) {
				alert(t["WaitListTCI"]);
				return false;
		} else if ((VisitStatus)&&(WaitList)&&(WaitList.value!="")&&(VisitStatus.value!="P")&&
				(((FirstTransM)&&(objID)&&(FirstTransM.value==objID.value))||
				((FirstTransT)&&(objID)&&(FirstTransT.value==objID.value))||
				((FirstTransB)&&(objID)&&(FirstTransB.value==objID.value))
				)) {
				alert(t["WaitListTCI"]);
				return false;
		} else {
			var objType=document.getElementById('TransTypez'+eSrcAry[1]);
			var objFirstBook=document.getElementById('FirstBookedz'+eSrcAry[1]);
			if ((objType)&&(objFirstBook)&&(objType.value=="B")&&(eSrcAry[0]=="delete")&&(objFirstBook.value==1)) {
				alert(t['PreAdmDelEdit']);
				return false;
			}
		}
		return true;
  	}else if (eSrcAry[0]=="TRANSReadyForBill") {
		//md billing log 54039
		//alert(url);
		return true;
  	} 
	else {
		//Only do next bit of the booking edit form also exists on this page;
		// ab 5.12.02 - 30200 - dont allow edit/delete of first/booking transactions for waiting list TCI
		if (document.getElementById("fPAADMTransaction_EditBooking")) {
			if ((VisitStatus)&&(WaitList)&&(WaitList.value!="")&&(VisitStatus.value=="P")&&
			(((objType)&&(objType.value=="B"))||
			((FirstTransM)&&(objID)&&(FirstTransM.value==objID.value))||
			((FirstTransT)&&(objID)&&(FirstTransT.value==objID.value))
			)) {
				alert(t["WaitListTCI"]);
				return false;
			}
			if ((VisitStatus)&&(WaitList)&&(WaitList.value!="")&&(VisitStatus.value=="A")&&
			(((FirstTransM)&&(objID)&&(FirstTransM.value==objID.value))||
			((FirstTransT)&&(objID)&&(FirstTransT.value==objID.value))||
			((FirstTransB)&&(objID)&&(FirstTransB.value==objID.value))
			)) {
				alert(t["WaitListTCI"]);
				return false;
			}
			
			// ab 29.05.03 - added this so users are unable to edit the first booking from the inpatient bed request menu
			var objFirstBook=document.getElementById('FirstBookedz'+row);
			var objType=document.getElementById('TransTypez'+row);
			if ((objFirstBook)&&(objFirstBook.value==1)&&(objType)&&(objType.value=="B")) {
				alert(t['PreAdmDelEdit']);
				return false;
			}
			var url=eSrc.href
			var ID=document.getElementById('IDz'+row).value;
			var TransType=document.getElementById('TransTypez'+row).value;
			var EpisodeID=document.getElementById('EpisodeIDz'+row).value;
			var PatientID=document.getElementById('PatientIDz'+row).value;
			var TWKFL=document.getElementById('TWKFL').value;
			var TWKFLI=document.getElementById('TWKFLI').value;
			//url="paadmtransaction.booking.csp?TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&ID="+ID+"&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&TransType="+TransType;
			url="websys.csp?TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&ID="+ID+"&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&TransType="+TransType;
			//alert(url);
            window.location.href=url; 
			//websys_createWindow(url,"testname","top=80,left=180,width=420,height=400,scrollbars=yes,resizable=yes,status=yes");
		}
		return false;
  	}
}

// CJB end 26699 05082002
function checklinkHandler(evt) {
	var eSrc=websys_getSrcElement(evt);	
	if (eSrc.disabled==true) return false;
}

//This function is also called from paadmtransaction.booking.csp
function PAAdmTransactionMovementListLoadHandler() {
	var obj=document.getElementById("TransType");
	//disable New buttons when just dealing with bookings.
	if ((obj)&&(obj.value=="B")) {
		//var obj2=document.getElementById('NewMove');
		//if (obj2) obj2.disabled=true;obj2.onclick=checklinkHandler;
		var obj2=document.getElementById('NewMandT');
		if (obj2) obj2.disabled=true;obj2.onclick=checklinkHandler;
	}
}

//document.body.onload=PAAdmTransactionMovementListLoadHandler;
