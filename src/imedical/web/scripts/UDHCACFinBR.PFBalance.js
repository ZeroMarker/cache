///UDHCACFinBR.PFBalance.js

var m_RefreshFlag = 0;

function BodyLoadHandler() {
	var obj = document.getElementById("Refresh");
	if (obj) {
		obj.onclick = Refresh_Click;
	}
	var obj = document.getElementById("Foot");
	if (obj) {
		obj.onclick = Foot_Click;
	}
	//DHCWeb_DisBtnA("Foot");
	var obj = document.getElementById("Print");
	if (obj) {
		obj.onclick = Print_Click;
	}
	var obj = document.getElementById("PatAccDetail");
	if (obj) {
		obj.onclick = PatAccDetail_Click;
	}
	var obj = document.getElementById("PatPreDetail");
	if (obj) {
		obj.onclick = PatPreDetail_Click;
	}
	var obj = document.getElementById("PatCardPayDetail");
	if (obj) {
		obj.onclick = PatCardPayDetail_Click;
	}
}

function Refresh_Click() {
	ReadData();
}

function Foot_Click() {
	SaveData();
}

function Print_Click() {
	PrintClickHandlerAHSLRep();
}

function PatAccDetail_Click() {
	ReLoadADetails();
}

function PatPreDetail_Click() {
	
}

function PatCardPayDetail_Click() {
	
}

function ReadData() {
	//DHCWeb_DisBtnA("Foot");
	var myencrypt = DHCWebD_GetObjValue("ReadADEncrypt");
	if (myencrypt != "") {
		var myrtn = cspRunServerMethod(myencrypt, "");
		if (myrtn == "") {
			return;
		}
		var myary = myrtn.split(String.fromCharCode(3));
		var myAcInfo = myary[1].split("^");
		//alert(myAcInfo);
		DHCWebD_SetObjValueA("PFBLastDate", myAcInfo[0]);
		DHCWebD_SetObjValueA("PFBLastTime", myAcInfo[1]);
		DHCWebD_SetObjValueA("PFBCurrentDate", myAcInfo[2]);
		DHCWebD_SetObjValueA("PFBCurrentTime", myAcInfo[3]);
		DHCWebD_SetObjValueA("LastPDLeft", myAcInfo[4]);
		DHCWebD_SetObjValueA("PDIncomeSum", myAcInfo[5]);
		DHCWebD_SetObjValueA("PDReturnSum", myAcInfo[6]);
		DHCWebD_SetObjValueA("AccPaySum", myAcInfo[7]);
		DHCWebD_SetObjValueA("PDLeft", myAcInfo[8]);
		DHCWebD_SetObjValueA("PrtAccPaySum", myAcInfo[9]);
		DHCWebD_SetObjValueA("NOPrtAccPaySum", myAcInfo[10]);
		if (myary[0] == "0") {
			var obj = document.getElementById("Foot");
			if (obj) {
				DHCWeb_AvailabilityBtnA(obj, Foot_Click);
			}
		} else {
			
		}
	}
	ReLoadADetails();
	m_RefreshFlag = 1;
}

function ReLoadADetails() {
	var myBDate = DHCWebD_GetObjValue("PFBLastDate");
	var myBTime = DHCWebD_GetObjValue("PFBLastTime");
	var myEndDate = DHCWebD_GetObjValue("PFBCurrentDate");
	var myEndTime = DHCWebD_GetObjValue("PFBCurrentTime");
	if((myBDate=="")||(myEndDate=="")){
		
		var datestr=tkMakeServerCall("web.UDHCACFinBRFoot1","getdatetime");
		myBDate=datestr.split("^")[0];
		myBTime=datestr.split("^")[1];
		myEndDate=datestr.split("^")[0];
		myEndTime=datestr.split("^")[1];
	}
	var href = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCACFinBR.PFBalance.ACDetail";
	href += "&BDate=" + myBDate + "&BTime=" + myBTime + "&EndDate=" + myEndDate + "&EndTime=" + myEndTime;
	var obj = parent.frames["UDHCACFinBR_PFBalance_Detail"];
	obj.location.href = href;
}

function SaveData() {
	//DHCWeb_DisBtnA("Foot");
	if (m_RefreshFlag == "0") {
		alert("请先刷新再结算!");
		return;
	}
	var myFInfo = BuildACData();
	var tmpAry = myFInfo.split("^");
	if ((tmpAry[2] == "") || (tmpAry[3] == "") || (tmpAry[5] == "") || (tmpAry[6] == "")) {
		alert(t["NoFootData"]);
		return;
	}
	var myUser = session['LOGON.USERID'];
	var myExpStr = "";
	var myrtn = confirm(t["SaveTip"]);
	if (myrtn == false) {
		return;
	}
	var myencrypt = DHCWebD_GetObjValue("SaveADEncrypt");
	if (myencrypt != "") {
		var myrtn = cspRunServerMethod(myencrypt, myUser, myFInfo, myExpStr);
		var myary = myrtn.split(String.fromCharCode(3));
		if (myary[0] == "0") {
			DHCWebD_SetObjValueA("AccPFRowID", myary[1]);
			alert(t["FootOK"]);
			ReLoadADetails();
			m_RefreshFlag = 0;
			//DHCWeb_DisBtnA("Foot");
		} else {
			var obj = document.getElementById("Foot");
			if (obj) {
				DHCWeb_AvailabilityBtnA(obj, Foot_Click);
			}
			alert(t["FootErr"]);
		}
	}
}

function BuildACData() {
	var myary = new Array();
	//x AccPF_RowID                            DHC_AccPFoot Row ID           1      xx
	//x AccPF_Date                             AccPF_Date                    2      x
	myary[2] = DHCWebD_GetObjValue("PFBCurrentDate");
	//x AccPF_Time                             AccPF_Time                    3      xx
	myary[3] = DHCWebD_GetObjValue("PFBCurrentTime");
	//x AccPF_User_DR                          AccPF_User_DR                 4      xx
	myary[4] = session['LOGON.USERID'];
	//x AccPF_LastDate                         AccPF_LastDate                5      xk
	myary[5] = DHCWebD_GetObjValue("PFBLastDate");
	//x AccPF_LastTime                         AccPF_LastTime                6      xx
	myary[6] = DHCWebD_GetObjValue("PFBLastTime");
	//AccPF_PreLeftSum                       AccPF_PreLeftSum                7      xx
	myary[7] = DHCWebD_GetObjValue("LastPDLeft");
	//x AccPF_PreSum                           AccPF_PreSum                  8      xx
	myary[8] = DHCWebD_GetObjValue("PDIncomeSum");
	//AccPF_CardPaySum                       AccPF_CardPaySum                9      x
	myary[9] = DHCWebD_GetObjValue("AccPaySum");
	//x AccPF_LeftSum                          AccPF_LeftSum                 10     xx
	myary[10] = DHCWebD_GetObjValue("PDLeft");
	//x AccPF_RefundPreSum                     AccPF_RefundPreSum            11     xx
	myary[11] = DHCWebD_GetObjValue("PDReturnSum");
	//x AccPF_Note1                            AccPF_Note1                   12     xx
	//x AccPF_Note2                            AccPF_Note2                   13     xx
	//x AccPF_Note3                            AccPF_Note3                   14     xx
	//x AccPF_Note4                            AccPF_Note4                   15     xx
	//x AccPF_Note5                            AccPF_Note5                   16     xx
	//x AccPF_Note6                            AccPF_Note6                   17     xx
	//x AccPF_Note7                            AccPF_Note7                   18     xx
	//x AccPF_Note8                            AccPF_Note8                   19     xx
	//x AccPF_Note9                            AccPF_Note9                   20
	//x AccPF_Note10                           AccPF_Note10                  21     xx
	//myary[]
	var mystr = myary.join("^");
	return mystr;
}

document.body.onload = BodyLoadHandler;
