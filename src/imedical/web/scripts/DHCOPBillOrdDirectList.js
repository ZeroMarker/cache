///DHCOPBillOrdDirectList.js
///Lid
///2010-06-01
///医嘱导引单打印

///报表模板路径
var path = "";
var m_CardNoLength = 12;
var FramName = "DHCOPBillOrdDirectList";
function BodyLoadHandler() {
	var obj = document.getElementById("ReceipNO");
	if (obj) {
		obj.onkeydown = invNO_keydownHandler;
	}
	var obj = document.getElementById("ReceipID");
	var obj = document.getElementById("print");
	if (obj) {
		obj.onclick = print_onclick;
	}
	var obj = document.getElementById("Clear");
	if (obj) {
		obj.onclick = Clear_OnClick;
	}
	var tabFlag = document.getElementById("TabFlag").value;
	if (tabFlag != "") {
		document.getElementById("sFlag").value = tabFlag;
	}
	var obj = document.getElementById('ReadInsuCard');
	if (obj) {
		obj.onclick = ReadInsuCard_OnClick;
	}
	var obj = document.getElementById("RCardNo");
	if (obj) {
		if (obj.type != "Hiden") {
			obj.onkeydown = RCardNo_KeyDown;
		}
	}
	//初始化卡类型
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
	var myobj = document.getElementById("CardTypeDefine");
	if (myobj) {
		myobj.onchange = CardTypeDefine_OnChange;
	}
	CardTypeDefine_OnChange();
	var obj = document.getElementById("btnInvFind");
	if (obj) {
		obj.onclick = find_onclick;
	}
	ReadINVInfo()
	getpath();
	var PatientIDNode = websys_$('PatientID');
	if (PatientIDNode) {
		PatientIDNode.onkeydown = PatientID_KeyDown;
	}
}

///发票号回车事件
function invNO_keydownHandler() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		var obj = document.getElementById("ReceipNO");
		var invInfo = tkMakeServerCall("web.DHCOPBILLOrdDirectList", "GetInvInfoByPrtRowid", obj.value, "");
		initDoc(invInfo);
		var IDobj = document.getElementById("ReceipID");
		var INVRID = IDobj.value;
		if (INVRID == "") {
			return;
		}
		var sFlag = document.getElementById("sFlag").value;
		parent.frames['DHCOPBillOrdDirectList_Order'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillOrdDirectList.Order&ReceipID=" + INVRID + "&sFlag=" + sFlag;
	}
}

function CardTypeDefine_OnChange() {
	var myoptval = DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	//Read Card Mode
	if (myary[16] == "Handle") {
		var myobj = document.getElementById("RCardNo");
		if (myobj) {
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadPCSC");
	} else {
		var myobj = document.getElementById("RCardNo");
		if (myobj) {
			myobj.readOnly = true;
		}
		var obj = document.getElementById("ReadPCSC");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, ReadHFMagCard_Click);
		}
	}
	//Set Focus
	if (myary[16] == "Handle") {
		DHCWeb_setfocus("RCardNo");
	} else {
		DHCWeb_setfocus("ReadPCSC");
	}
	m_CardNoLength = myary[17];
}

function SetCardNOLength() {
	var obj = document.getElementById('RCardNo');
	if (obj.value != '') {
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value;
			}
		}
		var myCardobj = document.getElementById('CardNo');
		if (myCardobj) {
			myCardobj.value = obj.value;
		}
	}
}

function initDoc(value) {
	//标志^发票号^发票Rowid ^登记号^ 病人姓名^ 病人性别^ 收费员 ^总金额^ 病人自付金额 ^发票状态
	//sFlag_"^"_invNO_"^"_prtRowid_"^"_PapmiNo_"^"_PapmiName_"^"_PapmiSex_"^"_PRTUsr_"^"_PRTAcount_"^"_PRTPatPay_"^"_flag
	if (value == "") {
		return;
	}
	var tmpAry = value.split("^");
	document.getElementById("sFlag").value = tmpAry[0];
	document.getElementById("ReceipNO").value = tmpAry[1];
	document.getElementById("ReceipID").value = tmpAry[2];
	document.getElementById("PatientID").value = tmpAry[3];
	document.getElementById("patName").value = tmpAry[4];
}

function Clear_OnClick() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillOrdDirectList";
	var obj = parent.frames['DHCOPBillOrdDirectList'];
	obj.location.href = lnk;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillOrdDirectList.Order&ReceipID=" + "";
	var obj = parent.frames['DHCOPBillOrdDirectList_Order'];
	obj.location.href = lnk;
	/*
	document.getElementById("sFlag").value = "";
	document.getElementById("ReceipNO").value = "";
	document.getElementById("ReceipID").value = "";
	document.getElementById("PatientID").value = "";
	document.getElementById("patName").value = "";
	DHCWeb_setfocus("ReceipNO");
	 */
}

///打印医嘱导引单
function print_onclick() {
	var prtRowid = document.getElementById("ReceipID").value;
	var sFlag = document.getElementById("sFlag").value;
	if (sFlag == "PRT") {
		var InvStr = 0 + "^" + prtRowid;
		PrintOrderDriect(InvStr);
	} else if (sFlag == "API") {
		var myrtn = window.confirm(t["IsPrintAPI"]);
		if (!myrtn) {
			return myrtn;
		}
		var prtRowIdStr = tkMakeServerCall("web.DHCOPBILLOrdDirectList", "GetPrtRowId", prtRowid);
		var tmpAry = prtRowIdStr.split("^");
		for (var i = 0; i < tmpAry.length; i++) {
			var tmpPrtRowid = tmpAry[i];
			var InvStr = 0 + "^" + tmpPrtRowid;
			PrintOrderDriect(InvStr);
		}
	} else {
		var InvStr = 0 + "^" + prtRowid;
		PrintOrderDriect(InvStr);
	}
}

///获取选中的医嘱Rowid
function getSelectedOrdRowid() {
	var myRows = DHCWeb_GetTBRows("tDHCOPBillOrdDirectList");
	var ordRowidStr = "";
	for (var i = 1; i <= myRows; i++) {
		var sSelect = document.getElementById('Tselectz' + i);
		if (sSelect.checked) {
			var ordRowid = document.getElementById("TOrderRowidz" + i).value;
			if (ordRowidStr == "") {
				ordRowidStr = ordRowid;
			} else {
				ordRowidStr = ordRowidStr + "^" + ordRowid;
			}
		}
	}
	return ordRowidStr;
}

function getpath() {
	var encmeth = DHCWebD_GetObjValue('getpath');
	path = cspRunServerMethod(encmeth, '', '');
}

function ReadINVInfo() {
	//read INV Infomation
	var sFlag = DHCWebD_GetObjValue('TabFlag');
	if (sFlag == "") {
		return;
	}
	var INVRID = DHCWebD_GetObjValue('ReceipID');
	if (INVRID == "") {
		return;
	}
	var invInfo = tkMakeServerCall("web.DHCOPBILLOrdDirectList", "GetInvInfoByPrtRowid", "", INVRID, sFlag);
	initDoc(invInfo);
	parent.frames['DHCOPBillOrdDirectList_Order'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillOrdDirectList.Order&ReceipID=" + INVRID + "&sFlag=" + sFlag;
}

function find_onclick() {
	QueryInv();
}

function QueryInv() {
	var mygLocDR = session['LOGON.GROUPID'];
	var myULoadLocDR = session['LOGON.CTLOCID'];
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk += "&FramName=DHCOPBillOrdDirectList";
	lnk += "&AuditFlag=ALL&sFlag=ALL&INVStatus=N";
	lnk += "&gLocDR=" + mygLocDR + "&ULoadLocDR=" + myULoadLocDR;
	lnk += "&PatientNO=" + websys_$V('PatientID');
	var NewWin = open(lnk, "udhcOPINV_Query", "scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function ReadCardQueryINV(PAPMNo) {
	var mygLocDR = session['LOGON.GROUPID'];
	var myULoadLocDR = session['LOGON.CTLOCID'];
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk += "&FramName=DHCOPBillOrdDirectList&PatientNO=" + PAPMNo;
	lnk += "&AuditFlag=ALL&sFlag=ALL&INVStatus=N";
	lnk += "&gLocDR=" + mygLocDR + "&ULoadLocDR=" + myULoadLocDR;
	var NewWin = open(lnk, "udhcOPINV_Query", "scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

///读医保卡
function ReadInsuCard_OnClick() {
	try {
		var rtn = ReadCard("N");
		if ((rtn == "-1") || (rtn == "")) {
			return;
		}
		var myArr = rtn.split("|");
		var obj = document.getElementById('RCardNo');
		if (obj) {
			obj.value = myArr[0];
		}
		var CardNo = myArr[0];
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, CardNo, "", "PatInfo");
		if (CardNo == "") {
			return;
		}
		var myary = myrtn.split("^");
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var obj = document.getElementById("PatientID");
			obj.value = myary[5];
			ReadCardQueryINV(myary[5]);
			break;
		case "-200":
			alert("卡无效");
			//websys_setfocus('RegNo');
			break;
		case "-201":
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var obj = document.getElementById("PatientID");
			obj.value = myary[5];
			ReadCardQueryINV(myary[5]);
			break;
		default:
		}
	} catch (e) {
		//alert("读卡错误:" + " " + e.message);
		return;
	}
}

function ReadHFMagCard_Click() {
	var myCardTypeValue = DHCWeb_GetListBoxValue("CardTypeDefine");
	if (m_SelectCardTypeDR == "") {
		var myrtn = DHCACC_GetAccInfo();
	} else {
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardTypeValue);
	}
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		var obj = document.getElementById("PatientID");
		obj.value = myary[5];
		var obj = document.getElementById("CardNo");
		DHCWebD_SetObjValueB("CardNo", myary[1]);
		DHCWebD_SetObjValueB("RCardNo", myary[1]);
		//DHCWebD_SetObjValueB("AccRowID", myary[7]);
		ReadCardQueryINV(myary[5]);
		break;
	case "-200":
		alert(t["-200"]);
		break;
	case "-201":
		var obj = document.getElementById("PatientID");
		obj.value = myary[5];
		ReadCardQueryINV(myary[5]);
		break;
	default:
		//alert("");
	}
}

function RCardNo_KeyDown() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if ((key == 13)) {
		var myDHCVersion = DHCWebD_GetObjValue("DHCVersion");
		//Set Card No Length;
		SetCardNOLength();
		var myCardNo = DHCWebD_GetObjValue("CardNo");
		var mySecurityNo = "";
		//var myrtn = DHCACC_GetAccInfo();
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardNo, mySecurityNo, "PatInfo");
		var myary = myrtn.split("^");
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			var obj = document.getElementById("PatientID");
			obj.value = myary[5];
			var obj = document.getElementById("CardNo");
			//DHCWebD_SetObjValueB("CardNo", myary[1]);
			//DHCWebD_SetObjValueB("AccRowID", myary[7]);
			ReadCardQueryINV(myary[5]);
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			var myPAPMNo = myary[5];
			var obj = document.getElementById("PatientID");
			obj.value = myary[5];
			ReadCardQueryINV(myary[5]);
			break;
		default:
		}
		return;
	}
}

function PatientID_KeyDown() {
	if (window.event.keyCode == 13) {
		var PatIDNode = websys_$("PatientID");
		if ((PatIDNode) && (PatIDNode.value != "")) {
			var PatNo = PatIDNode.value;
			PatNo = tkMakeServerCall("web.UDHCJFBaseCommon", "regnocon", PatNo);
			PatIDNode.value = PatNo;
			var myExpStr = "";
			var PatDr = tkMakeServerCall("web.DHCOPCashierIF", "GetPAPMIByNo", PatNo, myExpStr);
			if (PatDr == "") {
				PatIDNode.value = "";
				alert('登记号错误,请重新输入?');
				PatIDNode.className = 'clsInvalid';
				websys_setfocus('PatientID');
				return websys_cancel();
			} else {
				PatIDNode.className = 'clsvalid';
			}
		}
	}
}

document.body.onload = BodyLoadHandler;
