/// UDHCACAcc.PatPayINVPrt.js

var m_YBConFlag = "0"; //default not Connection YB
var myYBFlag = 0;

function BodyLoadHandler() {
	var obj = document.getElementById("INVPrint");
	if (obj) {
		obj.onclick = INVPrint_Click;
	}
	IntDocument();
	ParseINVInfo();
	IntDoc();
}

function IntDoc() {
	var mygLoc = session['LOGON.GROUPID'];
	//Load Base Config
	var encmeth = DHCWebD_GetObjValue("GSCFEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, mygLoc);
	}
	var myary = myrtn.split("^");
	if (myary[0] == 0) {
		//Check Invoice PrtFlag
		mPrtINVFlag = myary[4];
		//Get ColPrtXMLName
		var myPrtXMLName = myary[11];
	}
	PrtXMLName = myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName);  //INVPrtFlag
	var encmeth = DHCWebD_GetObjValue("ReadOPBaseEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth);
	}
	var myary = myrtn.split("^");
	m_YBConFlag = myary[9];
	if (m_YBConFlag == "1") {
		//iniInsuForm();
	}
}

function INVPrint_Click() {
	//DHCWeb_DisBtnA("INVPrint");
	var APLRowIDStr = DHCWebD_GetObjValue("APLRowIDStr");
	if (APLRowIDStr == "") {
		alert("�빴ѡ��Ҫ��ӡ�Ľ����¼");
		return;
	}
	var myColStr = BulidPrtColStr();
	var myCID = DHCWebD_GetObjValue("CID");
	var myUnYBFlag = DHCWebD_GetObjValue("UnYBPatType");
	var AutoYBFlag = DHCWebD_GetObjValue("GHFlag");
	var RegFlag = DHCWebD_GetObjValue("RegFlag");
	var Insurtn = "Y!";
	if ((myYBFlag != "0") && (myUnYBFlag != "1") && (AutoYBFlag != "1") && (RegFlag != "1")) {
		Insurtn = tkMakeServerCall("web.DHCOPINVCons", "CheckAPIInsuData", myCID, "");
		//alert("Insurtn=" + Insurtn);
	}
	Insurtn = Insurtn.split("!");
	if ((myColStr == "") || (Insurtn[0] != "Y")) {
		if (Insurtn[1] != "") {
			var insuinfo = Insurtn[1].split("@");
			for (var i = 0; i < insuinfo.length; i++) {
				var IData = insuinfo[i].split("^");
				var OutString = "";
				var insudHandle = "0";
				var myUser = session['LOGON.USERID'];
				var InsuExpStr = "^^^";
				var myInsuType = IData[1];
				var myadmsource = IData[2];
				var myINSDivDR = IData[0];
				if (myINSDivDR == "") {
					continue;
				}
				var CPPFlag = "Y";
				var OutString = InsuOPDivideStrike(insudHandle, myUser, myINSDivDR, myadmsource, myInsuType, InsuExpStr, CPPFlag);
				//alert("OutString=" + OutString);
			}
		}
		var obj = document.getElementById("INVPrint");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, INVPrint_Click);
		}
		alert(t["ErrToFresh"]);
		return;
	}
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	//var myCID = DHCWebD_GetObjValue("CID");
	var myUsrDR = session['LOGON.USERID'];
	var myGroupDr = session['LOGON.GROUPID'];
	var PAPMIRowID = DHCWebD_GetObjValue('PAPMIRowID');
	var myPAPMIDR = PAPMIRowID;
	//var AutoYBFlag = DHCWebD_GetObjValue("GHFlag"); //modify hujunbin 14.12.5 ���AutoYBFlagҽ�������־
	var myExpStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^^^" + AutoYBFlag;
	var encmeth = DHCWebD_GetObjValue("SaveINVEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, myColStr, myUsrDR, myAccRowID, myPAPMIDR, myExpStr);
		var rtn = myrtn.split("^")[0];
		if (rtn == 0) {
			//Delete ^TMP
			var encmeth = DHCWebD_GetObjValue("DelTMPG");
			if (encmeth != "") {
				var rtn = cspRunServerMethod(encmeth);
			}
			var encmeth = DHCWebD_GetObjValue("DelINVTMP");
			if (encmeth != "") {
				var rtn = cspRunServerMethod(encmeth, myCID);
			}
			//Print Invoice for Patient
			BillPrintNew(myrtn);
			alert(t["PrtOK"]);
			var PatPayListObj = parent.frames['UDHCACAcc_PatPayList'];
			var PayListWin = PatPayListObj.window;
			PayListWin.location.reload();
			//PayListWin.RefreshDoc();
		} else {
			//alert(t[rtn]);
			var obj = document.getElementById("INVPrint");
			if (obj) {
				DHCWeb_AvailabilityBtnA(obj, INVPrint_Click);
			}
		}
	}
}

function BulidPrtColStr() {
	var rtn = 0;
	var myYBTPaySum = 0;
	var myCancleSum = 0;
	var myPrtColStr = "";
	//Add YB  Foot For Card User
	var mydoc = parent.frames["UDHCACAcc_PatBaseInfo"].document;
	myYBFlag = "0";
	var myAdmReasonID = "";
	var myobj = mydoc.getElementById("InsType");
	if (myobj) {
		var myIdx = myobj.options.selectedIndex;
		myValue = myobj.options[myIdx].value;
		var myInsType = myValue.split("^")[0];
		myYBFlag = myValue.split("^")[2];
		// ȡ�������Ͷ��յ�Ĭ�Ϸѱ�
		myAdmReasonID = myValue.split("^")[3];
	}
	//+2017-05-31 modify by ZhYW
	var myUnYBFlag = 0;
	var myObj = mydoc.getElementById("UnYBPatType");
	if ((myObj) && (myObj.checked)) {
		myUnYBFlag = 1;
	}
	DHCWebD_SetObjValueB("UnYBPatType", myUnYBFlag);
	var AutoYBFlag = 0;
	var myObj = mydoc.getElementById("GHFlag");
	if ((myObj) && (myObj.checked)) {
		AutoYBFlag = 1;
	}
	DHCWebD_SetObjValueB("GHFlag", AutoYBFlag);
	var RegFlag = 0;
	var myObj = mydoc.getElementById("RegFlag");
	if ((myObj) && (myObj.checked)) {
		RegFlag = 1;
	}
	DHCWebD_SetObjValueB("RegFlag", RegFlag);
	//
	//�������շѺ󲻵�ҽ���ӿ� add hujunbin 14.12.5
	//modify hujunbin 14.12.5 ���ҽ�������־�ж�(AutoYBFlag != "1")
	if ((myYBFlag != "0") && (myUnYBFlag != "1") && (AutoYBFlag != "1") && (RegFlag != "1")) {
		var myCID = DHCWebD_GetObjValue("CID");
		var myrtn = QueryYBsys(myCID, myYBFlag, myAdmReasonID);  //+2017-06-01 modify by ZhYW ͨ���ѱ�RowID����ҽ���ӿ�(ԭ��������λ)
		//var myrtn = QueryYBsys(myCID, myYBFlag, myInsType);
		/*
		if (myrtn == "-1") {
			myrtn = "0";
		}
		*/
		if (myrtn != "0") {
			alert(t["YBParErr"] + myrtn);
			return "";
		}
	}
	DHCWebD_ClearAllListA("INVInfo");
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	var myCID = DHCWebD_GetObjValue("CID");
	var myExpStr = "^^^^^" + AutoYBFlag;
	var encmeth = DHCWebD_GetObjValue("ReadYBEncrypt");
	if ((encmeth != "")&&(myCID != "")) {
		//modify hujunbin 14.12.5 �����չ��
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToList", "INVInfo", myCID, myExpStr);
		if (rtn != 0) {
			alert(t["ParErr"]);
			return "";
		}
	}else {
		alert(t["NoPrintData"]);
		return "";
	}
	var myYBSum = 0;
	var myPersonSum = 0;
	var myRefSum = 0;
	var myINVSum = 0;
	var myYBAccPaySum = 0;
	var myYBTCPaySum = 0;
	var myYBDBPaySum = 0;
	var myCID = "";
	var obj = document.getElementById("INVInfo");
	if (obj) {
		var mylen = obj.options.length;
		for (var i = 0; i < mylen; i++) {
			var myopt = obj.options[i];
			if (myPrtColStr == "") {
				myPrtColStr = myopt.value;
			} else {
				myPrtColStr += String.fromCharCode(2) + myopt.value;
			}
			var myListAry = myopt.value.split(String.fromCharCode(3));
			myCID = myListAry[0].split("^")[2];
			var myary3 = myListAry[3];
			var myary33 = myary3.split("^");
			myYBSum = (myYBSum + parseFloat(myary33[0]));
			myPersonSum = (myPersonSum + parseFloat(myary33[1]));
			myRefSum = (myRefSum + parseFloat(myary33[2]));
			var myary4 = myListAry[4];
			var myary44 = myary4.split("^");
			//myCardPaySum_"^"_myYBAccPaySum_"^"_myYBTCPaySum_"^"_myYBDBPaySum
			myYBAccPaySum = myYBAccPaySum + parseFloat(myary44[1]);
			myYBTCPaySum = myYBTCPaySum + parseFloat(myary44[2]);
			myYBDBPaySum = myYBDBPaySum + parseFloat(myary44[3]);
		}
	}
	myINVSum = parseFloat(myYBSum) + parseFloat(myPersonSum);
	var obj = document.getElementById("YBTPaySum");
	if (obj) {
		obj.value = myYBSum.toFixed(2);
	}
	var obj = document.getElementById("PatAccPaySum");
	if (obj) {
		obj.value = myPersonSum.toFixed(2);
	}
	var obj = document.getElementById("CancleSum");
	if (obj) {
		obj.value = myRefSum.toFixed(2);
	}
	var obj = document.getElementById("YBCardAccPay");
	if (obj) {
		obj.value = myYBAccPaySum.toFixed(2);
	}
	var obj = document.getElementById("YBTCPaySum");
	if (obj) {
		obj.value = myYBTCPaySum.toFixed(2);
	}
	var obj = document.getElementById("YBBAPaySum");
	if (obj) {
		obj.value = myYBDBPaySum.toFixed(2);
	}
	var obj = document.getElementById("INVSum");
	if (obj) {
		obj.value = myINVSum.toFixed(2);
	}
	return myPrtColStr;
}

function IntDocument() {
	var obj = document.getElementById("YBTPaySum");
	if (obj) {
		obj.readOnly = true;
	}
	var obj = document.getElementById("PatAccPaySum");
	if (obj) {
		obj.readOnly = true;
	}
	var obj = document.getElementById("CancleSum");
	if (obj) {
		obj.readOnly = true;
	}
	var obj = document.getElementById("YBCardAccPay");
	if (obj) {
		obj.readOnly = true;
	}
	var obj = document.getElementById("YBTCPaySum");
	if (obj) {
		obj.readOnly = true;
	}
	var obj = document.getElementById("YBBAPaySum");
	if (obj) {
		obj.readOnly = true;
	}
	var obj = document.getElementById("INVSum");
	if (obj) {
		obj.readOnly = true;
	}

	var obj = document.getElementById("ReceiptNO");
	if (obj) {
		obj.readOnly = true;
	}
	GetReceiptNo();
}

function ParseINVInfo() {
	//DHCWebD_ClearAllListA("INVInfo");
	var myAPINVInfo = "";
	var myAPINVDesc = "";
	var myvIdx = 0;
	DHCWebD_ClearAllListA("INVInfo");
	var APLRowIDStr = DHCWebD_GetObjValue("APLRowIDStr");
	if (APLRowIDStr == "") {
		return;
	}
	//add hujunbin 14.12.5 ҽ�������־
	var AutoYBFlag = DHCWebD_GetObjValue("GHFlag");
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	var myExpStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.USERID'] + "^" + session['LOGON.HOSPID'];
	myExpStr += "^^" + AutoYBFlag; //add hujunbin 14.12.5 �̶���������λ��
	var encmeth = DHCWebD_GetObjValue("ParINVEncrypt");
	if (encmeth != "") {
		//var rtn = cspRunServerMethod(encmeth, "ShowINVCPDetails", "", APLRowIDStr, myExpStr);
		//modify hujunbin 14.12.5 ���AutoYBFlag ҽ�������־
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToList", "INVInfo", APLRowIDStr, myExpStr);
		if (rtn != 0) {
			alert(t["ParErr"] + "**" + rtn);
			return;
		} else {
			var myCID = DHCWebD_GetObjValue("CID");
			var encmeth = DHCWebD_GetObjValue("DelINVTMP");
			if (encmeth != "") {
				var rtn = cspRunServerMethod(encmeth, myCID);
			}
		}
	}
	var myCID = "";
	var obj = document.getElementById("INVInfo");
	if (obj) {
		var mylen = obj.options.length;
		if (mylen > 0) {
			var myopt = obj.options[0];
			var myary = myopt.value.split(String.fromCharCode(3));
			myCID = myary[5];
		}
	}
	var obj = document.getElementById("CID");
	if (obj) {
		obj.value = myCID;
	}
}

function ShowINVCPDetails(INVCInfo) {
	var obj = document.getElementById("INVInfo");
	var mylistlen = obj.options.length;
	var myary = INVCInfo.split(String.fromCharCode(2));
	var myPrtDesc = myary[0];
	var myPrtInfo = myary[1];
	var myDescary = myPrtDesc.split("^");
	myPrtInfo = myDescary[0] + String.fromCharCode(3) + myPrtInfo;
	myPrtDesc = myDescary.join("  ");
	obj.options[mylistlen] = new Option(myPrtDesc, myPrtInfo);
}

function ParseINVInfoOld() {
	var myAPINVInfo = "";
	var myAPINVDesc = "";
	var myvIdx = 0;
	var APLRowIDStr = DHCWebD_GetObjValue("APLRowIDStr");
	var encmeth = DHCWebD_GetObjValue("ParINVEncrypt");
	if (encmeth != "") {
		var myinfo = cspRunServerMethod(encmeth, APLRowIDStr);
		var myary = myinfo.split(String.fromCharCode(2));
		var rtn = myary[0];
		if (rtn != 0) {
			alert(t["ParErr"]);
		} else {
			//InsType
			for (var i = 1; i < myary.length; i++) {
				myAPINVInfo += myary[i];
				var myINVary = myary[i].split(String.fromCharCode(3));
				var myInsAry = myINVary[0].split("^");
				var myInsDesc = myInsAry[1];
				var myPrtary = myINVary[1].split(String.fromCharCode(4));
				for (var j = 1; j < myPrtary.length; j++) {
					var myary5 = myPrtary.split(String.fromCharCode(5));
					myvIdx = myvIdx + 1;
					myAPINVDesc += "No:" + myvIdx + " Sum:" + " InsType:" + myInsDesc;
				}
			}
			//var myPrtInfo=
		}
	}
}

function UpdatePrtInfo() {
	var encmeth = DHCWebD_GetObjValue("ParINVEncrypt");
	if (encmeth != "") {
		var myinfo = cspRunServerMethod(encmeth, APLRowIDStr);
	}
}

function GetReceiptNo() {
	var encmeth = DHCWebD_GetObjValue("GetreceipNO");
	var Guser = session['LOGON.USERID'];
	var Group = session['LOGON.GROUPID'];
	/*var myPINVFlag = "Y";
	var myExpStr = Guser + "^" + myPINVFlag + "^" + Group;
	if (cspRunServerMethod(encmeth, "SetReceipNO", "", myExpStr) != 0) {
		alert(t['05']);
		return;
	}*/
	if (cspRunServerMethod(encmeth, "SetReceipNO", "",Guser) != 0) {
		alert(t['05']);
		return;
	}
}

function SetReceipNO(value) {
	var myary = value.split("^");
	var ls_ReceipNo = myary[0];
	var obj = document.getElementById("ReceiptNO");
	if (obj) {
		obj.value = ls_ReceipNo;
	}
	DHCWebD_SetObjValueA("INVLeftNum", myary[2]);
	if (myary[1] != "0") {
		obj.className = 'clsInvalid';
	}
}

function BillPrintNew(INVstr) {
	if (myPrtXMLName = "") {
		alert("No Print!");
		return;
	}
	var INVtmp = INVstr.split("^");
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = DHCWebD_GetObjValue("ReadINVDataEncrypt");
			var PayMode = DHCWebD_GetObjValue("PayMode");
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myExpStr = "";
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", PrtXMLName, INVtmp[invi], sUserCode, PayMode, myExpStr);
		}
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	var myobj = document.getElementById("ClsBillPrint");
	TxtInfo = TxtInfo + "^" + "APIFlag" + String.fromCharCode(2) + "(��)";
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
}

function QueryYBsys(myCID, myYBFlag, myAdmReasonID) {
	var StrikeFlag = "";
	var insudHandle = 0;
	var myUsrDR = session['LOGON.USERID'];
	var GroupDR = session['LOGON.GROUPID'];
	var HospDR = session['LOGON.HOSPID'];
	var InsuNo = "";
	var CardType = "";
	var YLLB = "";
	var DicCode = "";
	var DicDesc = "";
	var DYLB = "";
	var ChargeSource = "01";
	var DBConStr = "";    //���ݿ����Ӵ�
	var LeftAmt = "";
	var MoneyType = "";
	var SelPayMDR = "";
	var myExpStrYB = StrikeFlag + "^" + GroupDR + "^" + InsuNo + "^" + CardType + "^" + YLLB + "^" + DicCode + "^" + DicDesc;
	myExpStrYB += "^" + LeftAmt + "^" + ChargeSource + "^" + DBConStr + "^" + DYLB + "^" + "" + "^" + HospDR + "^" + SelPayMDR + "!" + LeftAmt + "^" + MoneyType;
	var CPPFlag = "Y";
	var OutString = InsuOPDivide(insudHandle, myUsrDR, myCID, myYBFlag, myAdmReasonID, myExpStrYB, CPPFlag);
	return OutString;
}

function BodyUnLoadHandler() {
	if (m_YBConFlag == "1") {
		BodyUnLoad();
	}
	var encmeth = DHCWebD_GetObjValue("DelTMPG");
	var rtn = cspRunServerMethod(encmeth);
	DelServerTMP();
}

function DelServerTMP() {
	var myCID = DHCWebD_GetObjValue("CID");
	var encmeth = DHCWebD_GetObjValue("DelINVTMP");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, myCID);
	}
}

//���Է�Ʊ��ʽ
function test(invRowid) {
	var encmeth = DHCWebD_GetObjValue("ReadINVDataEncrypt");
	var PayMode = DHCWebD_GetObjValue("PayMode");
	var Guser = session['LOGON.USERID'];
	var sUserCode = session['LOGON.USERCODE'];
	var myExpStr = "";
	var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", "INVPrtFlagCPP", invRowid, sUserCode, PayMode, myExpStr);
}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;
