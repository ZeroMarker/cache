/// udhcOPRefEditFind.js

var PrtXMLName;
var papnoobj;

function BodyLoadHandler() {
	ValidateDocumentData();
	DHCWeb_setfocus("opcardno");
	papnoobj = document.getElementById("PatientNO");
	if (papnoobj) {
		papnoobj.onkeydown = PatNo_OnKeyDown;
	}

	var PatMed = document.getElementById("PatMed");
	if (PatMed) {
		PatMed.onkeydown = PatMedicare_keydown;
	}
	var Refund = document.getElementById("Refund");
	if (Refund) {
		Refund.onclick = Refund_Click;
	}
	var All = document.getElementById("SelectAll");
	if (All) {
		All.onclick = SelectAll;
	}
	var obj = document.getElementById('OPCardType');
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		loadCardType();
		obj.onchange = OPCardType_OnChange;
	}

	//insert by yq 增加读卡功能
	var readcard = document.getElementById('readcard');
	if (readcard) {
		readcard.onclick = readcard_click;
	}
	var obj = document.getElementById('opcardno');
	if (obj) {
		obj.onkeydown = CardNo_onkeydown;
	}
	
	var rows = DHCWeb_GetTBRows('tudhcOPRefEditFind');
	for (var i = 1; i <= rows; i++) {
		var DspStatus = DHCWeb_GetColumnData("TDrugStatus", i);
		if (DspStatus != "正常") {
			document.getElementById('checkz' + i).disabled = true;
			document.getElementById('TDrugStatusz' + i).style.color = "red";
		}
	}
}

function readcard_click() {
	//clearall();
	ReadCardClickHandlerNew();
}

function clearall() {
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefEditFind";
}

function IntDoc() {
	//Load Base Config
	var mygLoc = session['LOGON.GROUPID'];
	var encmeth = DHCWebD_GetObjValue("GSCFEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, mygLoc);
	}
	var myary = myrtn.split("^");
	if (myary[0] == 0) {
		//_"^"_GSRowID_"^"_FootFlag_"^"_RecLocFlag_"^"_PrtINVFlag
		//foot Flag
		m_AbortPop = myary[7];
		m_RefundPop = myary[8];
		//Get PrtXMLName
		var myPrtXMLName = myary[10];
	}
	PrtXMLName = myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName); //INVPrtFlag
}

function Refund_Click() {
	DHCWeb_DisBtnA("Refund");
	var rtn = RefundSaveInfo("S");
	var robj = document.getElementById("Refund");
	if ((!rtn) && (robj)) {
		DHCWeb_AvailabilityBtnA(robj, Refund_Click);
	}
}

function getstr() {
	var prtRowIdAry = new Array();
	var totalMoney = 0;
	var num = 0;
	var rows = DHCWeb_GetTBRows('tudhcOPRefEditFind');
	for (var i = 1; i <= rows; i++) {
		var check = DHCWeb_GetColumnData("check", i);
		if (check) {
			var prtRowId = document.getElementById('PrtRowidz' + i).innerText;
			prtRowIdAry.push(prtRowId);
			var totSum = DHCWeb_GetColumnData("TotSum", i);
			totalMoney += Number(totSum);
			num++;
		}
	}
	var prtRowIdStr = prtRowIdAry.join('^');
	totalMoney = parseFloat(totalMoney).toFixed(2);
	return prtRowIdStr + "#" + totalMoney + "#" + num;
}

function RefundSaveInfo(RefundFlag) {
	var OPPatName = DHCWebD_GetObjValue('OPPatName');
	var IPPatName = DHCWebD_GetObjValue('IPPatname');
	if (OPPatName != IPPatName) {
		var rtn = window.confirm("病人姓名不同,是否确认转费用?");
		if (!rtn) {
			return false;
		}
	}
	var IPAdmRowID = DHCWebD_GetObjValue("IPAdm");
	var IPpacward = DHCWebD_GetObjValue("IPpacward");
	if ((IPAdmRowID == "") || (IPpacward == "")) {
		alert("请选择住院就诊.");
		return false;
	}
	var confFlag = tkMakeServerCall("web.UDHCJFBillDetailOrder", "GetCodingFlagByAdm", IPAdmRowID);
	if (confFlag == "Y") {
		alert("住院就诊已经做财务审核,请先撤销审核后再导入");
		return false;
	}
	var StopPrtRowidStr = getstr();
	var tmpstr = StopPrtRowidStr.split("#");
	if ((tmpstr[0] == "") || (tmpstr[1] == 0) || (tmpstr[2] == 0)) {
		alert("请选择发票信息!");
		return false;
	}
	var myUser = session['LOGON.USERID'];
	var gloc = session['LOGON.GROUPID'];
	var myUserLocID = session['LOGON.CTLOCID'];
	var judgertn = tkMakeServerCall("web.udhcOPRefEditCopy", "JudgeAlreadyRefund", tmpstr[0], IPAdmRowID);
	if (judgertn.split("^")[0] == 1) {
		alert("有如下发票ID:" + judgertn.split("^")[1] + " 的发票所对应就诊的医嘱费用已经转入另外的住院就诊记录,不允许一个门诊就诊的医嘱费用转入多个住院就诊!");
		return false;
	}
	alert("本次共选择" + tmpstr[2] + "张发票,总金额为" + tmpstr[1] + "元！");
	var flag = window.confirm("是否将选中的门诊费用并入选中病人的住院费用中？一旦并入不可撤销");
	if (!flag) {
		return false;
	}
	//add by guoning 2017-07-27
	var myInsuDivStr = tkMakeServerCall("web.DHCINSUPort", "GetDivDrAndAdmReaByInvPrt", tmpstr[0]);
	if (myInsuDivStr != "N") {
		var myINSDivDR = myInsuDivStr.split("!")[0];
		var myInsType = myInsuDivStr.split("!")[1];
		var myAdmSource = myInsuDivStr.split("!")[2];
		var StrikeFlag = "";
		var insudHandle = "0";
		var myUser = session['LOGON.USERID'];
		var GroupDR = session['LOGON.GROUPID'];
		var HospDR = session['LOGON.HOSPID'];
		var InsuNo = "";
		var CardType = "";
		var YLLB = "";
		var DicCode = "";
		var DicDesc = "";
		var DYLB = "";
		var ChargeSource = "01";
		var LeftAmt = "";
		var MoneyType = "";
		var myExpStrYB = StrikeFlag + "^" + GroupDR + "^" + InsuNo + "^" + CardType + "^" + YLLB + "^" + DicCode + "^" + DicDesc;
		myExpStrYB += "^" + LeftAmt + "^" + ChargeSource + "^" + DYLB + "^" + "" + "^" + HospDR + "!" + LeftAmt + "^" + MoneyType;
		var CPPFlag = "";
		var rtn = DHCWebOPYB_ParkINVFYB(insudHandle, myUser, myINSDivDR, myAdmSource, myInsType, myExpStrYB, CPPFlag);
		if (rtn != "0") {
			alert("医保发票退费失败！不能进行转费用操作！");
			return false;
		}
	}
	//
	var RPayModeDR = "";
	var encmeth = DHCWebD_GetObjValue('getRefundRcpt');
	var rtnvalue = cspRunServerMethod(encmeth, tmpstr[0], myUser, RefundFlag, myUserLocID, RPayModeDR, IPAdmRowID);
	//alert(rtnvalue);
	var myary = rtnvalue.split(String.fromCharCode(2));
	var rtn = myary[0].split("^");
	if (rtn[0] == '0') {
		//Add YB InterFace   &&(myPRTRowID!="")
		var myPRTRowID = "";
		var myInsuDivStr = "";
		if (rtn.length > 1) {
			myPRTRowID = rtn[1];
		}
		var encmeth = DHCWebD_GetObjValue('getUpdateRETFLAG');
		if (encmeth != "") {
			var mytmprtn = cspRunServerMethod(encmeth, myary[0]);
		}
		BillPrintTaskListNew(myary[0]);
		alert(t['07']);
		Find_click();  //+2017-07-04 ZhYW
		return true;
	} else {
		alert('转住院失败:' + rtn[0]);
		return false;
	}
}

function BillPrintTaskListNew(INVstr) {
	var myOldXmlName = PrtXMLName;
	var myTaskList = DHCWebD_GetObjValue("ReadPrtList");
	var myary = myTaskList.split(String.fromCharCode(1));
	if (myary[0] == "Y") {
		BillPrintTaskList(myary[1], INVstr)
		PrtXMLName = myOldXmlName;
		DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName);  //INVPrtFlag
	} else {
		BillPrintNew(INVstr);
	}
	PrtXMLName = myOldXmlName;
}

function BillPrintTaskList(PrtTaskStr, INVstr) {
	var myTListAry = PrtTaskStr.split(String.fromCharCode(2));
	for (var i = 0; i < myTListAry.length; i++) {
		if (myTListAry[i] != "") {
			var myStrAry = myTListAry[i].split("^");
			//myXmlName_"^"_myClassName_"^"_myMethodName
			var myPrtXMLName = myStrAry[0];
			PrtXMLName = myPrtXMLName;
			var myClassName = myStrAry[1];
			var myMethodName = myStrAry[2];
			if ((myStrAry[3] == "") || (myStrAry[3] == "XML")) {
				if (myPrtXMLName != "") {
					DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName); //INVPrtFlag
					CommBillPrintNew(INVstr, myClassName, myMethodName);
				}
			}
		}
	}
}

function CommBillPrintNew(INVstr, ClassName, MethodName) {
	var INVtmp = INVstr.split("^");
	var encmeth = DHCWebD_GetObjValue('ReadCommOPDataEncrypt');
	var PayMode = DHCWebD_GetObjValue("PayMode");
	var Guser = session['LOGON.USERID'];
	var sUserCode = session['LOGON.USERCODE'];
	var myExpStr = "";
	var myPreDep = DHCWebD_GetObjValue("Actualmoney");
	var myCharge = DHCWebD_GetObjValue("Change");
	var myCurGroupDR = session['LOGON.GROUPID'];
	var myExpStr = myPreDep + "^" + myCharge + "^" + myCurGroupDR;
	var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", ClassName, MethodName, PrtXMLName, INVstr, sUserCode, PayMode, myExpStr);
}

function CommBillPrintNewSigle(INVstr, ClassName, MethodName) {
	var INVtmp = INVstr.split("^");
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = DHCWebD_GetObjValue('ReadCommOPDataEncrypt');
			var PayMode = DHCWebD_GetObjValue("PayMode");
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myExpStr = "";
			var myPreDep = DHCWebD_GetObjValue("Actualmoney");
			var myCharge = DHCWebD_GetObjValue("Change");
			var myCurGroupDR = session['LOGON.GROUPID'];
			var myExpStr = myPreDep + "^" + myCharge + "^" + myCurGroupDR;
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", ClassName, MethodName, PrtXMLName, INVtmp[invi], sUserCode, PayMode, myExpStr);
		}
	}
}

function BillPrintNew(INVstr) {
	if (PrtXMLName == "") {
		return;
	}
	var INVtmp = INVstr.split("^");
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = DHCWebD_GetObjValue('getSendtoPrintinfo');
			var PayMode = DHCWebD_GetObjValue("RefundPayMode");
			var Guser = session['LOGON.USERID'];
			var sUserCode = session["LOGON.USERCODE"];
			var myCurGroupDR = session['LOGON.GROUPID'];
			var myExpStr = "^^" + myCurGroupDR;
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", PrtXMLName, INVtmp[invi], sUserCode, PayMode, myExpStr);
		}
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	///Lid 2010-02-25 明细分发票打印
	var chr2 = String.fromCharCode(2);
	var guser = session['LOGON.USERID'];
	var group = session['LOGON.GROUPID'];
	var invRowid = TxtInfo.split("^")[0].split(chr2)[1]; //主发票Rowid
	var listAry = ListInfo.split("!");
	var listNum = listAry.length;
	var myobj = document.getElementById("ClsBillPrint");
	for (i = 0; i < listNum; i++) {
		switch (i) {
		case 0:
			DHCP_PrintFun(myobj, TxtInfo, listAry[i]);
			break;
		default:
			//走发票号
			var rtn = tkMakeServerCall("web.UDHCOPINVPrtData24", "UpdateInvoice", guser, group, invRowid);
			var sucessFlag = rtn.split("^")[0];
			//打印明细
			if (sucessFlag == 0) {
				//附票发票头信息
				var patName = TxtInfo.split("^")[1]; //病人姓名
				var regNO = TxtInfo.split("^")[2]; //登记号
				var date = TxtInfo.split("^")[3]; //收费日期
				var userCode = TxtInfo.split("^")[4]; //收款员Code
				var patInsType = TxtInfo.split("^")[7]; //病人类型
				var invNO = TxtInfo.split("^")[9].split(chr2)[1]; //主发票号
				var currInvNO = rtn.split("^")[1]; //当前发票号
				var invSubTxtInfo = patName + "^" + regNO + "^" + date + "^" + userCode + "^" + patInsType + "^" + "mainInvNO" + chr2 + "主发票号:" + invNO + "^" + "InvNo" + chr2 + currInvNO;
				DHCP_PrintFun(myobj, invSubTxtInfo, listAry[i]);
			} else {
				alert("发票号码更新失败");
				return;
			}
		}
	}
}

function ReadCardType() {
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "CardTypeDefine");
	}
}

function ValidateDocumentData() {
	var myobj = document.getElementById("CardTypeDefine");
	if (myobj) {
		myobj.size = 1;
		myobj.multiple = false;
	}
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "CardTypeDefine");
	}
}

function Find_Click() {
	var StartDate = DHCWebD_GetObjValue("StartDate");
	var EndDate = DHCWebD_GetObjValue("EndDate");
	var PatientNO = DHCWebD_GetObjValue("PatientNO");
	var CardNo = DHCWebD_GetObjValue("opcardno");
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefEditFind&StartDate=" + StartDate + "&EndDate=" + EndDate + "&PatientNO=" + PatientNO + "&opcardno=" + CardNo;
	window.location.href = lnk;
}

function FindPatByMedicare() {
	var PatMed = DHCWebD_GetObjValue('PatMed');
	var encmeth = DHCWebD_GetObjValue('GetMethodByPatMed');
	var PatNo = cspRunServerMethod(encmeth, PatMed);
	if (PatNo != "") {
		var tmp = document.getElementById('PatientID');
		if (tmp) {
			DHCWebD_SetObjValueB('PatientID', PatNo);
			var IPAdm = document.getElementById('IPAdm');
			if (IPAdm) {
				IPAdm_lookuphandler();
			}
		}
	}
}

function PatMedicare_keydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		FindPatByMedicare();
	}
}

function QueryIPAdmlookup(value) {
	var str = value.split("^");
	DHCWebD_SetObjValueB('IPPatname', str[3]);
	DHCWebD_SetObjValueB('IPpacward', str[7]);
}

function SelectAll() {
	var IfCheck = DHCWebD_GetObjValue('SelectAll');
	var eSrc = window.event.srcElement;
	var objtbl = document.getElementById('tudhcOPRefEditFind');
	var rows = objtbl.rows.length;
	for (i = 1; i <= rows - 1; i++) {
		var DspStatus = DHCWeb_GetColumnData("TDrugStatus", i);
		if (DspStatus != "正常") {
			continue;
		}
		DHCWeb_SetColumnData("check", i, IfCheck);
	}
}

function PatNo_OnKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var PatientNO = DHCWebD_GetObjValue("PatientNO");
		if (PatientNO == "") {
			return;
		}
		PatientNO = tkMakeServerCall("web.UDHCJFBaseCommon", "regnocon", PatientNO);
		DHCWebD_SetObjValueB("PatientNO", PatientNO);
		getpatinfo1();
	}
}

function getpatinfo1() {
	var PatientNO = DHCWebD_GetObjValue("PatientNO");
	if (PatientNO != "") {
		var rtn = tkMakeServerCall("web.UDHCJFORDCHK", "getpatcurradm", "setpat_val", "", PatientNO, "");
		if (rtn == "") {
			alert("没有此病人信息");
		}else {
			Find_click();
		}
	}
}

function setpat_val(value) {
	var val = value.split("^");
	DHCWebD_SetObjValueB('PatientID', val[0]);
	DHCWebD_SetObjValueB('OPPatName', val[1]);
}

function CardNo_onkeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		//Set Card No Length;
		var obj = document.getElementById("opcardno");
		if (obj.value == "") {
			return;
		}
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value;
			}
		}
		var myCardNo = DHCWebD_GetObjValue("opcardno");
		var mySecurityNo = "";
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardNo, mySecurityNo, "PatInfo");
		var myary = myrtn.split("^");
		//alert(myary);
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			DHCWebD_SetObjValueB("opcardno", myary[1]);
			DHCWebD_SetObjValueB("PatientNO", myary[5]);
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			DHCWebD_SetObjValueB("opcardno", myary[1]);
			DHCWebD_SetObjValueB("PatientNO", myary[5]);
			getpatinfo1();
			break;
		default:
			//alert("");
		}
		return;
	}
}

document.body.onload = BodyLoadHandler;