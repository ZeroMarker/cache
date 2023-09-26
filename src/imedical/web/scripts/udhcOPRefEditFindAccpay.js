/// udhcOPRefEditFindAccpay.js

var PrtXMLName;

function BodyLoadHandler() {
	ValidateDocumentData();
	DHCWeb_setfocus("CardNo");
	var CardNo = document.getElementById("CardNo");
	if (CardNo) {
		CardNo.onkeydown = CardNo_onkeydown;
	}
	var PatientNO = document.getElementById("PatientNO");
	if (PatientNO) {
		PatientNO.onkeydown = PatientNo_onkeydown;
	}
	var PatMed = document.getElementById("PatMed");
	if (PatMed) {
		PatMed.onkeydown = PatMedicare_keydown;
	}
	var readcard = document.getElementById('readcard');
	if (readcard) {
		readcard.onclick = readcard_click;
	}
	var obj = document.getElementById('OPCardType');
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		loadCardType();
		obj.onchange = OPCardType_OnChange;
	}
	var Refund = document.getElementById("Refund");
	if (Refund) {
		Refund.onclick = Refund_Click;
	}
	var objAll = document.getElementById("SelectAll");
	if (objAll) {
		objAll.onclick = SelectAll;
	}
	var obj = document.getElementById("Find");
	if (obj) {
		obj.onclick = Find_Click;
	}
	checkDrugStatus();
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
		//alert(m_AbortPop+"^"+m_RefundPop);
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
	var rows = DHCWeb_GetTBRows('tudhcOPRefEditFindAccpay');
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
	var StopPrtRowidStr = getstr();
	var tmpstr = StopPrtRowidStr.split("#");
	if ((tmpstr[0] == "") || (tmpstr[1] == 0) || (tmpstr[2] == 0)) {
		alert("请选择发票信息!");
		return false;
	}
	var myUser = session['LOGON.USERID'];
	var gloc = session['LOGON.GROUPID'];
	var myUserLocID = session['LOGON.CTLOCID'];
	
	var IPAdmRowID = DHCWebD_GetObjValue("IPAdm");
	var IPpacward = DHCWebD_GetObjValue("IPpacward");
	if ((IPAdmRowID == "") || (IPpacward == "")) {
		alert("请选择住院就诊.");
		return false;
	}
	alert("本次共选择" + tmpstr[2] + "张发票,总金额为" + tmpstr[1] + "元！");
	var flag = window.confirm("是否将选中的门诊费用并入选中病人的住院费用中？一旦并入不可撤销");
	if (!flag) {
		return false;
	}
	//+2017-10-12 ZhYW 集中打印发票医保退费
	var myInsuDivStr = tkMakeServerCall("web.udhcOPRefEditCopyNew", "GetInsuDivInfo", tmpstr[0]);
	if (myInsuDivStr != "") {
		var myDataAry = myInsuDivStr.split(String.fromCharCode(2));
		for (var i = 0; i < myDataAry.length; i++) {
			var myAry = myDataAry[i].split("^");
			var myInsDivDR = myAry[0];
			if (myInsDivDR == "") {
				continue;
			}
			var myInsType = myAry[1];
			var myAdmSource = myAry[2];
			var insudHandle = "0";
			var myYBExpStr = "^^1";
			var myCPPFlag = "";
			var OutString = InsuOPDivideStrike(insudHandle, myUser, myInsDivDR, myAdmSource, myInsType, myYBExpStr, myCPPFlag);
			if (OutString != "0") {
				alert("医保发票退费失败,不能进行转费用操作！");
				return false;
			}
		}
	}
	//
	var RPayModeDR = 1;   //退费方式为现金
	var IPAdmRowID = IPAdmRowID + "^" + "API";
	var encmeth = DHCWebD_GetObjValue("getRefundRcpt");
	var rtnvalue = cspRunServerMethod(encmeth, tmpstr[0], myUser, RefundFlag, myUserLocID, RPayModeDR, IPAdmRowID);
	var myary = rtnvalue.split(String.fromCharCode(2));
	var rtn = myary[0].split("^");
	if (rtn[0] == '0') {
		//Add YB InterFace   &&(myPRTRowID!="")
		var myPRTRowID = "";
		if (rtn.length > 1) {
			myPRTRowID = rtn[1];
		}
		var RETFLAGobj = document.getElementById("getUpdateRETFLAG");
		if (RETFLAGobj != null) {
			var encmeth = RETFLAGobj.value;
			var mytmprtn = cspRunServerMethod(encmeth, myary[0]);
		}
		BillPrintTaskListNew(myary[0]);
		alert(t['07']);
		Find_Click();     //zhangli  17.7.25   自动刷新
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
		DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName); //INVPrtFlag
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
	//INVstr
	//for (var invi=1;invi<INVtmp.length;invi++)
	//{
	//if (INVtmp[invi]!=""){
	var encmeth = DHCWebD_GetObjValue("ReadCommOPDataEncrypt");
	var PayMode = DHCWebD_GetObjValue("PayMode");
	var Guser = session['LOGON.USERID'];
	var sUserCode = session['LOGON.USERCODE'];
	var myExpStr = "";
	var myPreDep = DHCWebD_GetObjValue("Actualmoney");
	var myCharge = DHCWebD_GetObjValue("Change");
	var myCurGroupDR = session['LOGON.GROUPID'];
	var myExpStr = myPreDep + "^" + myCharge + "^" + myCurGroupDR;
	var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", ClassName, MethodName, PrtXMLName, INVstr, sUserCode, PayMode, myExpStr);
	//}
	//}
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
	//var myary = INVstr.split(String.fromCharCode(2));
	var INVtmp = INVstr.split("^");
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = DHCWebD_GetObjValue('getSendtoPrintinfo');
			var PayMode = "";
			var payobj = document.getElementById("RefundPayMode");
			if (payobj) {
				//var PayMode = payobj.value;
				var PayMode = DHCWebD_GetObjValue("RefundPayMode");
			}
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

function Trim(str) {
	return str.replace(/[\t\n\r ]/g, "");
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
	var CardNo = DHCWebD_GetObjValue("CardNo");
	var sFlag = DHCWebD_GetObjValue("sFlag");
	var IPAdm = DHCWebD_GetObjValue("IPAdm");
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefEditFindAccpay&StartDate=" + StartDate + "&EndDate=" + EndDate + "&PatientNO=" + PatientNO + "&CardNo=" + CardNo + "&sFlag=" + sFlag + "&IPAdm=" + IPAdm;
	window.location.href = lnk;
}

function FindPatByMedicare() {
	var p1 = DHCWebD_GetObjValue("PatMed");
	var encmeth = DHCWebD_GetObjValue("GetMethodByPatMed");
	var PatNo = cspRunServerMethod(encmeth, p1);
	if (PatNo != "") {
		var tmp = document.getElementById('PatientID');
		if (tmp) {
			tmp.value = PatNo;
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
	var rows = DHCWeb_GetTBRows('tudhcOPRefEditFindAccpay');
	for (i = 1; i <= rows; i++) {
		var DspStatus = DHCWeb_GetColumnData("TDrugStatus", i);
		if (DspStatus != "正常") {
			continue;
		}
		DHCWeb_SetColumnData("check", i, IfCheck);
	}
}
function readcard_click() {
	//clearall();
	ReadCardClickHandler();
}

function clearall() {
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefEditFindAccpay";
}

function getpatinfo1() {
	var PatientNO = DHCWebD_GetObjValue("PatientNO");
	if (PatientNO != "") {
		/*
		var encmeth = DHCWebD_GetObjValue("getadm");
		if (cspRunServerMethod(encmeth, 'setpat_val', '', PatientNO) == ""){
			alert("没有此病人信息");
		}
		*/
		var encmeth = DHCWebD_GetObjValue("GetPAPMI");
		var patInfo = cspRunServerMethod(encmeth, PatientNO);
		if (patInfo != "") {
			var myAry = patInfo.split("^");
			DHCWebD_SetObjValueB('IPPatname', myAry[1]);
			DHCWebD_SetObjValueB('PatientNO', myAry[2]);
		}
		Find_Click();
	}
}

function setpat_val(value) {
	var val = value.split("^");
	regnoobj.value = val[0];
	nameobj.value = val[1];
	admobj.value = val[2];
	Adm = admobj.value;
	episodeidobj.value = Adm;
	DHCWebD_SetObjValueB('patmedicare', val[6]);
	DHCWebD_SetObjValueB('decease', val[7]);
	if (val[7] != t['23']) {
		document.getElementById("decease").style.color = "red";
	} else {
		document.getElementById("decease").style.color = "black";
	}
	if (val[8] == "A") {
		//alert(t['56']);
	}
	var encmeth = DHCWebD_GetObjValue("getpapmiid");
	var patid = cspRunServerMethod(encmeth, val[0]);
	DHCWebD_SetObjValueB('PatientID', patid);
	if (patid != "") {
		getybcardno();
	}
}

function checkDrugStatus() {
	var rows = DHCWeb_GetTBRows('tudhcOPRefEditFindAccpay');
	for (i = 1; i <= rows; i++) {
		var DspStatus = DHCWeb_GetColumnData("TDrugStatus", i);
		if (DspStatus != "正常") {
			document.getElementById('checkz' + i).disabled = true;
			document.getElementById('TDrugStatusz' + i).style.color = "red";
		}
	}
}

function PatientNo_onkeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getpatinfo1();
	}
}

function CardNo_onkeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		//Set Card No Length;
		var obj = document.getElementById("CardNo");
		if (obj.value == "") {
			return;
		}
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value;
			}
		}
		var myCardNo = DHCWebD_GetObjValue("CardNo");
		var mySecurityNo = "";
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardNo, mySecurityNo, "PatInfo");
		var myary = myrtn.split("^");
		//alert(myary);
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			DHCWebD_SetObjValueB("CardNo", myary[1]);
			DHCWebD_SetObjValueB("PatientNO", myary[5]);
			getpatinfo1();
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			DHCWebD_SetObjValueB("CardNo", myary[1]);
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
