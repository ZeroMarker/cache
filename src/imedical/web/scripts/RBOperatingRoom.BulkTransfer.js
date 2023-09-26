// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler() {
	var obj=document.getElementById("Location");
	if (obj) obj.onblur=locationchange;

	var obj=document.getElementById("Resource");
	if (obj) obj.onblur=resourcechange;

	//var obj=document.getElementById("update");
	//if (obj) obj.onclick=UpdateClickHandler;

	var obj=document.getElementById("TransferDate");
	if (obj) {
		obj.onblur=datechangeb;
		//obj.disabled=true;
		}
	var obj=document.getElementById("TransferTime");
	if (obj) {
		//obj.disabled=true;
		}
}

function datechangeb() {
	//alert("datechangeb()");
	var obj1 = document.getElementById('TransferDate')
	if ((obj1)&& (obj1.value=="")){
		var obj = document.getElementById('sessionid')
		if (obj) obj.value="";
		var obj = document.getElementById('TransferTime')
		if (obj) obj.value="";
	}
}


function dateLookUpB(str) {
	var lu = str.split("^");
	var obj = document.getElementById('TransferDate')
	if (obj) obj.value=lu[0];
	var obj = document.getElementById('HTransferDate')
	if (obj) obj.value=lu[0];
	var obj = document.getElementById('Resource')
	if (obj) obj.value=lu[2];
	var obj = document.getElementById('Location')
	if (obj) obj.value=lu[3];
	var obj = document.getElementById('TransferTime')
	if (obj) {obj.value=lu[1];}
	var obj = document.getElementById('HTransferTime')
	if (obj) {obj.value=lu[1];}
	var obj = document.getElementById('LocationID')
	if (obj) obj.value=lu[9];
	var obj = document.getElementById('RescID')
	if (obj) obj.value=lu[8];
	var obj = document.getElementById('sessionid')
	if (obj) obj.value=lu[6];
	var obj = document.getElementById('LogicalDate')
	if (obj) obj.value=lu[7];
	var obj = document.getElementById('CPsSession')
	if (obj) obj.value=lu[11];
	var obj = document.getElementById('SchedID')
	if (obj) obj.value=lu[17];
	datechangeb();
}

function resourcechange() {
	var obj = document.getElementById('Resource')
	if ((obj)&& (obj.value=="")){
		var obj = document.getElementById('RescID')
		if (obj) obj.value="";
	}
}

function locationchange() {
	var obj = document.getElementById('Location')
	if ((obj)&& (obj.value=="")){
		// This is being done so that we can look up resources with the same name but different locations
		var obj = document.getElementById('RescID')
		if (obj) obj.value="";
		var obj = document.getElementById('LocationID')
		if (obj) obj.value="";
	}
}

function resourceLookUp(str) {
	var lu = str.split("^");
	//alert(str);
	var obj = document.getElementById('Location')
	if (obj) obj.value=lu[3];
	var obj = document.getElementById('LocationID')
	if (obj) obj.value=lu[4];
	var obj = document.getElementById('Resource')
	if (obj) obj.value=lu[0];
	var obj = document.getElementById('RescID')
	if (obj) obj.value=lu[2];

}

/*function UpdateClickHandler(e) {
	var loc="";
	var locid="";
	var res="";
	var resid="";
	var transdate="";
	var transtime="";
	var sessionsid="";
	var apptlist="";
	var operlist="";
	var ignore="";
	var surg="";
	var anaeth="";
	var totaldur="";
	var Reason="";
	var Usercode="";
	var PIN="";
	if (document.getElementById('Location')) loc=document.getElementById('Location').value;
	if (document.getElementById('Resource')) res=document.getElementById('Resource').value;
	if (document.getElementById('LocationID')) locid=document.getElementById('LocationID').value;
	if (document.getElementById('RescID')) resid=document.getElementById('RescID').value;
	if (document.getElementById('TransferDate')) transdate=document.getElementById('TransferDate').value;
	if (document.getElementById('TransferTime')) transtime=document.getElementById('TransferTime').value;
	if (document.getElementById('ApptList')) apptlist=document.getElementById('ApptList').value;
	if (document.getElementById('OperList')) operlist=document.getElementById('OperList').value;
	if (document.getElementById('sessionid')) sessionsid=document.getElementById('sessionid').value;
	if (document.getElementById('ignoreCP')) ignore=document.getElementById('ignoreCP').value;
	if (document.getElementById('RBOPSurgeonDR')) surg=document.getElementById('RBOPSurgeonDR').value;
	if (document.getElementById('RBOPAnaesthetistDR')) anaeth=document.getElementById('RBOPAnaesthetistDR').value;
	if (document.getElementById('TotalDuration')) totaldur=document.getElementById('TotalDuration').value;
	if (document.getElementById('APPTReasonForTransferDR')) Reason=document.getElementById('APPTReasonForTransferDR').value;
	if (document.getElementById('UserCode')) Usercode=document.getElementById('UserCode').value;
	if (document.getElementById('PIN')) PIN=document.getElementById('PIN').value;
	//alert(loc+","+res+","+locid+","+resid+","+transdate+","+transtime+","+apptlist+","+operlist+","+sessionsid+","+ignore+","+surg+","+anaeth+","+totaldur+","+Reason+","+Usercode+","+PIN)
	var link="rboperatingroom.bulktransfer.csp?"
	link=link+"Location="+loc+"&Resource="+res+"&LocationID="+locid+"&RescID="+resid+"&TransferDate="+transdate+"&TransferTime="+transtime;
	link=link+"&ApptList="+apptlist+"&OperList="+operlist+"&sessionid="+sessionsid+"&ignoreCP="+ignore+"&RBOPSurgeonDR="+surg+"&RBOPAnaesthetistDR="+anaeth+"&TotalDuration="+totaldur+"&APPTReasonForTransferDR="+Reason+"&UserCode="+Usercode+"&PIN="+PIN;
	websys_createWindow(link,"TRAK_hidden");
}*/


// LOG 54811 RC 23/09/05 Moved to rboperatingroom.bulktransferclose.csp
/*function DocumentUnLoadHandler() {
	//alert(window.opener.name);
	//alert(window.opener.parent.frames("TRAK_Main").name);
	alert(window.opener.parent.frames("TRAK_Main").frames(0).name);
	//for theatre inquiry menu
	if (window.opener.parent.frames("TRAK_Main").frames(0).name=="RBOperatingRoomEdit") {
		//alert(window.opener.parent.frames("TRAK_Main").frames(0).name);
		//window.opener.parent.frames("TRAK_Main").find1_click();
		window.opener.parent.frames("TRAK_Main").frames(0).find1_click();
	}
	//for OT diary
	if (window.opener.parent.frames("TRAK_Main").frames(0).name=="work_top") {
		if(window.opener.parent.frames("TRAK_Main").frames(1).frames(0).name=="RBOperatingRoomEdit"){
			window.opener.parent.frames("TRAK_Main").frames(1).frames(0).find1_click();
		}
	}
}*/

document.body.onload = DocumentLoadHandler;
//document.body.onunload = DocumentUnLoadHandler;