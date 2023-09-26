////UDHCACFinBR.PFBalanceRP.js

function BodyLoadHandler() {
	document.body.style.padding = "0px";
	document.body.style.paddingTop = "0px";
	$('label').css("margin-right", "6px");
	$('label').css("margin-left", "3px");
	$('td.CellData').css("padding", "0px");
	$('td.CellData>table').css("border-spacing", "0px 7px");
	var obj=document.getElementById("Print");
	if (obj){
		obj.onclick=Print_Click;
	}
	var myPFRowID=getValueById("PFRowID");
	ReadData(myPFRowID);
}

function Refresh_Click(){
	var myPFRowID=getValueById("PFRowID");
	ReadData(myPFRowID);
}

function Print_Click(){
	// PrintClickHandlerAHSLRep(); UDHCACFinBR.CommPrintExcel.js
	PrintClickHandlerAHSLRepNew();
}

function ReadData(PFRowID){
	var myencrypt=getValueById("ReadADEncrypt");
	if (myencrypt!=""){
		var myrtn=cspRunServerMethod(myencrypt,PFRowID);
		var myary=myrtn.split(String.fromCharCode(3))
		var myAcInfo=myary[1].split("^");
		setValueById("PFBLastDate",myAcInfo[0]);
		setValueById("PFBLastTime",myAcInfo[1]);
		setValueById("PFBCurrentDate",myAcInfo[2]);
		setValueById("PFBCurrentTime",myAcInfo[3]);
		setValueById("LastPDLeft",myAcInfo[4]);
		setValueById("PDIncomeSum",myAcInfo[5]);
		setValueById("PDReturnSum",myAcInfo[6]);
		setValueById("AccPaySum",myAcInfo[7]);
		setValueById("PDLeft",myAcInfo[8]);
		setValueById("RoundSum",myAcInfo[9]);
		//setValueById("PrtAccPaySum",myAcInfo[9]);
		//setValueById("NOPrtAccPaySum",myAcInfo[10]);
	}
}

function PrintClickHandlerAHSLRepNew(){
	var APFRowID = getValueById("PFRowID");
	var myPFBLastDate = getValueById("PFBLastDate") +'  ' + getValueById("PFBLastTime");
	var myPFBCurrentDate = getValueById("PFBCurrentDate") + '  ' + getValueById("PFBCurrentTime");
	var myUserName = session['LOGON.USERNAME'];
	var fileName = "DHCBILL-OPACCRemainderCollect.raq&APFRowID=" + APFRowID + "&myPFBLastDate=" + myPFBLastDate + "&myPFBCurrentDate=" + myPFBCurrentDate + "&myUserName=" + myUserName;
 	DHCCPM_RQPrint(fileName,1200,800);
}
document.body.onload=BodyLoadHandler;



