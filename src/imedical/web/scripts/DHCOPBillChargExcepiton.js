/// DHCOPBillChargExcepiton.js
/// Lid
/// 2012-03-30
/// 门诊收费异常处理
/// 异常代码:
///Excepiton=1011:"自费患者,确认完成失败."
///Excepiton=1012:"自费患者,银医卡交易成功,HIS确认完成失败."
///Excepiton=1013:"自费患者,银医卡交易失败."
///Excepiton=1014:"医保患者,医保结算失败"
///Excepiton=1015:"医保患者,医保结算成功,HIS确认完成失败."
///Excepiton=1016:"医保患者,医保结算失败,银医卡不做结算."
///Excepiton=1017:"医保患者,医保结算成功,银医卡结算成功,HIS确认完成失败."
///Excepiton=1018:"医保患者,医保结算成功,银医卡结算失败,HIS不做确认完成."
///
var SelectedRow = "-1";
var m_CardNoLength = 15;
var m_SelectCardTypeDR = "";
var InvRequireFlag = "Y"; ///默认打印发票
///临时存储一张发票数据
var PRTINVDATA = {
	PrtRowID: "",
	PrtInv: "",
	PrtTotalAmt: 0,
	PRTPatientShare: 0,
	PRTDiscAmount: 0,
	PRTPayorShare: 0,
	PrtFlag: "",
	PrtDate: "",
	PrtTime: "",
	PrtUsr: "",
	PrtInsTypeDR: "",
	PrtInsDivDR: "",
	PrtFairType: "",
	Clear: function () {
		this.PrtRowID = "",
		this.PrtInv = "";
		this.PrtTotalAmt = 0,
		this.PRTPatientShare = 0,
		this.PRTDiscAmount = 0,
		this.PRTPayorShare = 0;
		this.PrtFlag = "";
		this.PrtDate = "",
		this.PrtTime = "",
		this.PrtUsr = "";
		this.PrtInsTypeDR = "";
		this.PrtInsDivDR = "";
		this.PrtFairType = "";
	},
	SetValue: function (PrtRowID, PrtInv, TotalAmt, PatientShare, DiscAmount, PayorShare, PrtFlag, PrtDate, PrtTime, PrtUsr, InsTypeDR, InsDivDR, FairType) {
		this.PrtRowID = PrtRowID,
		this.PrtInv = PrtInv;
		this.PrtTotalAmt = TotalAmt,
		this.PRTPatientShare = PatientShare,
		this.PRTDiscAmount = DiscAmount,
		this.PRTPayorShare = PayorShare;
		this.PrtFlag = PrtFlag;
		this.PrtDate = PrtDate,
		this.PrtTime = PrtTime,
		this.PrtUsr = PrtUsr;
		this.PrtInsTypeDR = InsTypeDR;
		this.PrtInsDivDR = InsDivDR;
		this.PrtFairType = FairType;
	}
}

function BodyLoadHandler() {
	var obj = document.getElementById("CardTypeDefine");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		obj.onchange = CardTypeDefine_OnChange;
	}
	var obj = document.getElementById("Clear");
	if (obj) {
		obj.onclick = Clear_Click;
	}
	var obj = document.getElementById("Find");
	if (obj) {
		obj.onclick = Find_OnClick;
	}
	var obj = document.getElementById("CardNo");
	if (obj) {
		obj.onkeydown = CardNo_OnKeyDown;
	}
	var obj = document.getElementById("PatientNO");
	if (obj) {
		obj.onkeydown = PatientNO_OnKeyDown;
	}
	var Obj = document.getElementById('ReadCard');
	if (Obj) {
		DHCWeb_DisBtn(Obj);
	}
	IntDoc();
	CardTypeDefine_OnChange();
	document.onkeydown = Doc_OnKeyDown;
}

function CardNo_OnKeyDown() {
	if (!e) {
		var e = event ? event : (window.event ? window.event : null);
	}
	var key = websys_getKey(e);
	if ((key == 13)) {
		//Set Card No Length;
		SetCardNOLength();
		var myCardNo = DHCWebD_GetObjValue("CardNo");
		var mySecurityNo = "";
		//var myrtn=DHCACC_GetAccInfo();
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardNo, mySecurityNo, "PatInfo");
		var myary = myrtn.split("^");
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			var obj = document.getElementById("PatientNO");
			obj.value = myary[5];
			var obj = document.getElementById("CardNo");
			DHCWebD_SetObjValueB("CardNo", myary[1]);
			DHCWebD_SetObjValueB("AccRowID", myary[7]);
			var myAccRowID = DHCWebD_GetObjValue("AccRowID");
			var PatDr = myary[4];
			SetPatientInfo(PatDr);
			break;
		case "-200":
			break;
		case "-201":
			var myPAPMNo = myary[5];
			var obj = document.getElementById("PatientNO");
			obj.value = myary[5];
			var PatDr = myary[4];
			SetPatientInfo(PatDr);
			break;
		default:
			//alert("");
		}
		return;
	}
}

function PatientNO_OnKeyDown() {
	if (!e) {
		var e = event ? event : (window.event ? window.event : null);
	}
	var key = websys_getKey(e);
	if ((key == 13)) {
		var PatientNOObj = websys_$("PatientNO");
		if ((PatientNOObj) && (PatientNOObj.value != "")) {
			var PatNo = PatientNOObj.value;
			var encmeth = websys_$V('GetPAPMI');
			var myExpStr = "";
			var PatDr = cspRunServerMethod(encmeth, PatNo, myExpStr);
			if (PatDr == "") {
				alert(t['RegNoError']);
				PatientNOObj.className = 'clsInvalid';
				websys_setfocus('PatientNO');
				return websys_cancel();
			} else {
				PatientNOObj.className = 'clsvalid';
			}
			SetPatientInfo(PatDr);
			Find_click();
		}
	}
}

function SetPatientInfo(PatDr) {
	var encmeth = websys_$V('GetPatInfo');
	var myExpStr = "";
	var PatInfoStr = cspRunServerMethod(encmeth, PatDr, myExpStr);
	var PatInfo = PatInfoStr.split("^");
	DHCWebD_SetObjValueB("PAPMIDR", PatInfo[0]);
	DHCWebD_SetObjValueB("PatientNO", PatInfo[1]);
	DHCWebD_SetObjValueB("PatientName", PatInfo[2]);
	var EncryptLevelObj = document.getElementById('EncryptLevel');
	if (EncryptLevelObj) {
		EncryptLevelObj.value = PatInfo[22];
	}
	var PatLevelObj = document.getElementById('PatLevel');
	if (PatLevelObj) {
		PatLevelObj.value = PatInfo[23];
	}
}

function Find_OnClick() {
	Find_click();
}

function SetCardNOLength() {
	var obj = document.getElementById('CardNo');
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

function IntDoc() {
	var mySessionStr = DHCWeb_GetSessionPara();
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = websys_$V("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "CardTypeDefine", mySessionStr);
	}
	var mygLoc = session['LOGON.GROUPID'];
	var encmeth = websys_$V("GSCFEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, mygLoc);
	}
	var myary = myrtn.split("^");
	if (myary[0] == 0) {
		//foot Flag
		var billobj = document.getElementById("Bill");
		if ((billobj) && (myary[2] == 0)) {
			DHCWeb_DisBtn(billobj);
		}
		//Check Invoice PrtFlag
		mPrtINVFlag = myary[4];
		//Get PrtXMLName
		var myPrtXMLName = myary[10];
	}
	PrtXMLName = myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName);   //INVPrtFlag
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
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.readOnly = false;
		}
	} else {
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.readOnly = true;
		}
		var obj = document.getElementById("ReadCard");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, ReadMagCard_Click);
		}
	}
	//Set Focus
	if (myary[16] == "Handle") {
		DHCWeb_setfocus("CardNo");
	} else {
		DHCWeb_setfocus("ReadCard");
	}
	m_CardNoLength = myary[17];
}

function ReadMagCard_Click() {
	var myCardTypeValue = DHCWeb_GetListBoxValue("CardTypeDefine");
	if (m_SelectCardTypeDR == "") {
		var myrtn = DHCACC_GetAccInfo();
	} else {
		//alert(m_SelectCardTypeDR+","+myCardTypeValue);
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardTypeValue);
	}
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		var obj = document.getElementById("PatientNO");
		obj.value = myary[5];
		var PatDr = myary[4];
		var obj = document.getElementById("CardNo");
		DHCWebD_SetObjValueB("CardNo", myary[1]);
		DHCWebD_SetObjValueB("AccRowID", myary[7]);
		var myAccRowID = DHCWebD_GetObjValue("AccRowID");
		SetPatientInfo(PatDr);
		Find_OnClick();
		//Account Can Pay
		break;
	case "-200":
		break;
	case "-201":
		var obj = document.getElementById("PatientNO");
		obj.value = myary[5];
		var PatDr = myary[4];
		SetPatientInfo(PatDr);
		Find_OnClick();
		break;
	default:
		//alert("");
	}
}

function Doc_OnKeyDown() {
}

///清屏
function Clear_Click() {
	//window.location.href = window.location.href;
	//window.location.reload;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillChargExcepiton";
	window.location.href = lnk;
}

///撤销
function BtnCancelOnClick(Me, PrtRowID, AccMRowID, PRTInsDivDR, InsTypeDR, AdmSource, Exception) {
	SelectRowHandler();      //模拟行单击
	GetPrtInvData(PrtRowID); //初始化发票对象
	if (("TP" != PRTINVDATA.PrtFlag) || (PRTINVDATA.PrtFlag == "")) {
		return;
	}
	var Guser = session['LOGON.USERID'];
	var Group = session['LOGON.GROUPID'];
	if (PRTINVDATA.PrtUsr != Guser) {
		//+2018-07-03 ZhYW 其他收费员撤销判断是否超过时限
		var isTimeOut = tkMakeServerCall("web.DHCOPBillChargExcepiton", "CheckIsTimeOut", PrtRowID);
		if (isTimeOut == 'N') {
			alert("非原发票收费员不能撤销!");
			return;
		}
	}
	var rtn = tkMakeServerCall("web.DHCOPBillChargExcepiton", "GetOrdStatus", PrtRowID);
	var rtn = rtn.split("^");
	if (rtn[0] == "C") {
		alert("此发票药品已发药,不允许撤销此发票.");
		return;
	}
	if (rtn[0] == "E") {
		alert("此发票已有已执行医嘱,不允许撤销此发票.");
		return;
	}
	if (!CheckData()) {
		return;
	}
	switch (Exception) {
	case 1011:
		var truthBeTold = window.confirm(t['E1011'] + t['IsCancel']);
		if (!truthBeTold) {
			break;
		}
		var ExpStr = "^" + Group;
		var rtn = HISRollBack(PrtRowID, AccMRowID, PRTInsDivDR, InsTypeDR, AdmSource, ExpStr);
		break;
	case 1012:
		alert('"' + t['E1012'] + '"' + t['MSG01']);
		break;
	case 1013:
		var truthBeTold = window.confirm(t['E1013'] + t['IsCancel']);
		if (!truthBeTold) {
			break;
		}
		var ExpStr = "^" + Group;
		var rtn = HISRollBack(PrtRowID, AccMRowID, PRTInsDivDR, InsTypeDR, AdmSource, ExpStr);
		break;
	case 1014:
		var truthBeTold = window.confirm(t['E1014'] + t['IsCancel']);
		if (!truthBeTold) {
			break;
		}
		var ExpStr = "^" + Group;
		var rtn = HISRollBack(PrtRowID, AccMRowID, PRTInsDivDR, InsTypeDR, AdmSource, ExpStr);
		break;
	case 1015:
		alert('"' + t['E1015'] + '"' + t['MSG01']);
		break;
	case 1016:
		var truthBeTold = window.confirm(t['E1016'] + t['IsCancel']);
		if (!truthBeTold) {
			break;
		}
		var ExpStr = "^" + Group;
		var rtn = HISRollBack(PrtRowID, AccMRowID, PRTInsDivDR, InsTypeDR, AdmSource, ExpStr);
		break;
	case 1017:
		alert('"' + t['E1017'] + '"' + t['MSG01']);
		break;
	case 1018:
		var truthBeTold = window.confirm(t['E1018'] + t['IsCancel']);
		if (!truthBeTold) {
			break;
		}
		var ExpStr = "^" + Group;
		HISRollBack(PrtRowID, AccMRowID, PRTInsDivDR, InsTypeDR, AdmSource, ExpStr);
		break;
	default:
	}
}

///继续确认完成
function BtnCompleteClick(Me, PrtRowID, AccMRowID, PRTInsDivDR, InsTypeDR, AdmSource, Exception) {
	SelectRowHandler();         //模拟行单击
	var Guser = session['LOGON.USERID'];
	var Group = session['LOGON.GROUPID'];
	GetPrtInvData(PrtRowID);    //初始化发票对象
	if ("TP" != PRTINVDATA.PrtFlag) {
		alert(t['MSG03']);
		return;
	}
	if (PRTINVDATA.PrtUsr != Guser) {
		alert("非原发票收费员不能完成!");
		return;
	}
	/*
	//add by zhl 20141121
	var myExpStrYB = "^" + session['LOGON.GROUPID'];
	var checkRtn = tkMakeServerCall("web.DHCOPINVCons", "CheckOPInvInsuData", PrtRowID, myExpStrYB);
	var myCheckAry = checkRtn.split("^");
	if ((myCheckAry[0] != "Y") && (myCheckAry[1] == "0")) {
		alert("医保结算数据错误,HIS已撤销异常记录,请到门诊收费页面进行结算.");
		Find_click();
		return;
	}
	//zhl  end
	*/
	switch (Exception) {
	case 1011:
		var truthBeTold = window.confirm(t['E1011'] + t['IsComplete']);
		if (!truthBeTold) {
			break;
		}
		var ExpStr = "^^^^";
		var rtn = HISCompleteCharge(PrtRowID, AccMRowID, PRTInsDivDR, InsTypeDR, AdmSource, ExpStr);
		break;
	case 1012:
		var truthBeTold = window.confirm(t['E1012'] + t['IsComplete']);
		if (!truthBeTold) {
			break;
		}
		var ExpStr = "^^^^";
		var rtn = HISCompleteCharge(PrtRowID, AccMRowID, PRTInsDivDR, InsTypeDR, AdmSource, ExpStr);
		break;
	case 1013:
		alert('"' + t['E1013'] + '"' + t['MSG02']);
		break;
	case 1014:
		alert('"' + t['E1014'] + '"' + t['MSG02']);
		break;
	case 1015:
		var truthBeTold = window.confirm(t['E1015'] + t['IsComplete']);
		if (!truthBeTold) {
			break;
		}
		var ExpStr = "^^^^";
		var rtn = HISCompleteCharge(PrtRowID, AccMRowID, PRTInsDivDR, InsTypeDR, AdmSource, ExpStr);
		break;
	case 1016:
		alert('"' + t['E1016'] + '"' + t['MSG02']);
		break;
	case 1017:
		var truthBeTold = window.confirm(t['E1017'] + t['IsComplete']);
		if (!truthBeTold) {
			break;
		}
		var ExpStr = "^^^^";
		var rtn = HISCompleteCharge(PrtRowID, AccMRowID, PRTInsDivDR, InsTypeDR, AdmSource, ExpStr);
		break;
	case 1018:
		alert('"' + t['E1018'] + '"' + t['MSG02']);
		break;
	default:
	}
}

function CheckData(PrtRowID, InsTypeDR, AdmSource, Exception) {
	if ((PrtRowID == "") || (PrtRowID == "0")) {
		alert(t['PrtRowIDNull']);
		return false;
	}
	if ((InsTypeDR == "") || (InsTypeDR == "0")) {
		alert(t['InsTypeDRNull']);
		return false;
	}
	if ((Exception == "") || (Exception == "0")) {
		alert(t['ExceptionNull']);
		return false;
	}
	return true;
}

///HIS确认完成
function HISCompleteCharge(PrtRowID, AccMRowID, PRTInsDivDR, InsTypeDR, AdmSource, ExpStr) {
	var msg = GetLogData(PrtRowID); //获取发票信息，用于存日志
	var Guser = session['LOGON.USERID'];
	var Group = session['LOGON.GROUPID'];
	var CTLocDR = session['LOGON.CTLOCID'];
	var OldPrtInvDR = "";   //原发票号
	var encmeth = websys_$V("CompleteChargeEncrypt");
	var myAccMRowID = AccMRowID;
	var myActualmoney = ""; //预收额
	var myChange = "";      //找零
	var myOPErr = "";       //分币误差
	var NewInsType = InsTypeDR; //新费别，默认就是发票费别
	var myExpStr = Group + "^" + CTLocDR + "^" + myAccMRowID + "^" + InvRequireFlag;
	var myExpStr = myExpStr + "^" + "F";
	var myExpStr = myExpStr + "^" + myActualmoney + "^" + myChange + "^" + myOPErr;
	var myExpStr = myExpStr + "^" + NewInsType;
	var rtn = cspRunServerMethod(encmeth, "4", Guser, InsTypeDR, PrtRowID, "0", OldPrtInvDR, myExpStr);
	if (rtn == "0") {
		SetExcepitonLog(PrtRowID, "完成", msg); //记录日志
		var InvStr = rtn + "^" + PrtRowID;
		BillPrintTaskListNew(InvStr);
		alert(t['CompleteSuccess']);
		Find_click();
	} else {
		alert(t['CompleteFailed']);
	}
	return rtn;
}

///HIS撤销结算
function HISRollBack(PrtRowID, AccMRowID, PRTInsDivDR, InsTypeDR, AdmSource, ExpStr) {
	var msg = GetLogData(PrtRowID); //获取发票信息，用于存日志
	var GroupDR = session['LOGON.GROUPID'];
	var myUser = session['LOGON.USERID'];
	var HospDR = session['LOGON.HOSPID'];
	if (PRTInsDivDR != "") {
		//撤销医保结算
		var myYBHand = "";
		var myCPPFlag = "";
		var myINSDivDR = PRTInsDivDR;
		var StrikeFlag = "S";
		var InsuNo = "";
		var CardType = "";
		var YLLB = "";
		var DicCode = "";
		var DicDesc = "";
		var DYLB = "";
		var ChargeSource = "01";  //结算来源
		var LeftAmt = tkMakeServerCall("web.UDHCAccManageCLS", "getAccBalance", AccMRowID);
		var MoneyType = "";
		var myExpStr = StrikeFlag + "^" + GroupDR + "^" + InsuNo + "^" + CardType + "^" + YLLB + "^" + DicCode + "^" + DicDesc;
		myExpStr += "^" + LeftAmt + "^" + ChargeSource + "^" + DYLB + "^" + AccMRowID + "^" + HospDR + "!" + LeftAmt + "^" + MoneyType;
		var rtn = DHCWebOPYB_ParkINVFYB(myYBHand, myUser, PRTInsDivDR, AdmSource, InsTypeDR, myExpStr, myCPPFlag);
		if (rtn != "0") {
			alert(t["YBParkErrTip"]);
			return rtn;
		}
	}
	//HIS数据回滚
	var rtn = DHCWebOPYB_DeleteHISData(PrtRowID, ExpStr);
	if (rtn == "0") {
		alert(t['CancelSuccess']);
		SetExcepitonLog(PrtRowID, "撤销", msg); //记录日志
		//window.location.href=window.location.href;
		//window.location.reload;
		Find_click();
	} else {
		alert(t['CancelFailed']);
	}
	return rtn;
}

function GetPrtInvData(ReceipID) {
	var encmeth = websys_$V("getReceiptinfo");
	if (cspRunServerMethod(encmeth, 'SetReceipInfo', '', ReceipID) == '0') {}
}

function SetReceipInfo(value) {
	var Split_Value = value.split("^");
	var PatNO = Split_Value[0];       //登记号
	var PatName = Split_Value[1];     //患者姓名
	var Sex = Split_Value[2];         //性别
	var PatShareAmt = Split_Value[3]; //自付金额
	var PrtFlag = Split_Value[4];     //发票状态
	var PrtUsr = Split_Value[6];
	var PrtInsDivDR = Split_Value[13]; //医保结算指针(insu_divide)
	var PrtInsTypeDR = Split_Value[17];
	var PrtPayMDR = Split_Value[9];    //发票支付方式,此处取的是DHC_InvPayMode表的第一条记录的支付方式
	var PatDr = Split_Value[19];       //Pa_PatMas表RowID
	PRTINVDATA.Clear();
	PRTINVDATA.SetValue("", "", 0, 0, 0, 0, PrtFlag, "", "", PrtUsr, PrtInsTypeDR, PrtInsDivDR, "");
}

///行单击,组件中有COMPONENT元素,所以注意rowIndex的值
function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	Objtbl = document.getElementById('tDHCOPBillChargExcepiton');
	Rows = Objtbl.rows.length;
	var lastrowindex = Rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) {
		return;
	}
	if (selectrow != SelectedRow) {
		if (selectrow > 1) {
			FactRow = selectrow - 1;
		} else {
			FactRow = selectrow;
		}
		var SelRowObj = document.getElementById('TPAPMIDRz' + FactRow);
		DHCWebD_SetObjValueB("PAPMIDR", SelRowObj.value);
		var SelRowObj = document.getElementById('TAccMDRz' + FactRow);
		DHCWebD_SetObjValueB("AccRowID", SelRowObj.value);
		var SelRowObj = document.getElementById('TPrtRowidz' + FactRow);
		DHCWebD_SetObjValueB("INVRowid", SelRowObj.innerText);
		SelectedRow = selectrow;
	} else {
	}
}

///行单击
function SelectRowHandlerOld() {
	var eSrc = window.event.srcElement;
	Objtbl = document.getElementById('tDHCOPBillChargExcepiton');
	Rows = Objtbl.rows.length;
	var lastrowindex = Rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) {
		return;
	}
	if (selectrow != SelectedRow) {
		var SelRowObj = document.getElementById('TPAPMIDRz' + selectrow);
		DHCWebD_SetObjValueB("PAPMIDR", SelRowObj.value);
		var SelRowObj = document.getElementById('TAccMDRz' + selectrow);
		DHCWebD_SetObjValueB("AccRowID", SelRowObj.value);
		var SelRowObj = document.getElementById('TPrtRowidz' + selectrow);
		DHCWebD_SetObjValueB("INVRowid", SelRowObj.innerText);
		SelectedRow = selectrow;
	} else {
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

///发票打印
function BillPrintTaskList(PrtTaskStr, INVstr) {
	var myTListAry = PrtTaskStr.split(String.fromCharCode(2));
	for (var i = 0; i < myTListAry.length; i++) {
		if (myTListAry[i] != "") {
			var myStrAry = myTListAry[i].split("^");
			//myXmlName_"^"_myClassName_"^"_myMethodName_"^"_myPrintMode_"^"_HardEquipDR
			var myPrtXMLName = myStrAry[0];
			PrtXMLName = myPrtXMLName;
			var myClassName = myStrAry[1];
			var myMethodName = myStrAry[2];
			var myPrintMode = myStrAry[3];
			var myPrintDeviceDR = myStrAry[4];
			if ((myStrAry[3] == "") || (myStrAry[3] == "XML")) {
				if (myPrtXMLName != "") {
					DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName);   //INVPrtFlag
					CommBillPrintNew(INVstr, myClassName, myMethodName);
				}
			} else if ((myStrAry[3] == "BC")) {
				//暂时用不到先注释
				//OtherPrintDevice(INVstr, myClassName, myMethodName, myPrintDeviceDR);
			}
		}
	}
}

function OtherPrintDevice(INVstr, ClassName, MethodName, PrintDeviceDR) {
	var myExpStr = "";
	var encmeth = websys_$V("ReadOPDataOtherDeviceEncrypt");
	if (encmeth != "") {
		var Printinfo = cspRunServerMethod(encmeth, "DHCWCOM_OtherPrintDeviceEquip", ClassName, MethodName, PrintDeviceDR, INVstr, myExpStr);
	}
}

function CommBillPrintNew(INVstr, ClassName, MethodName) {
	var INVtmp = INVstr.split("^");
	//INVstr
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = websys_$V('ReadCommOPDataEncrypt');
			var PayMode = "";
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myCurGroupDR = session['LOGON.GROUPID'];
			var myExpStr = "";
			var myPreDep = ""; //实收金额
			var myCharge = ""; //找零金额
			var myExpStr = myPreDep + "^" + myCharge + "^" + myCurGroupDR;
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", ClassName, MethodName, PrtXMLName, INVtmp[invi], sUserCode, PayMode, myExpStr);
		}
	}
}

function CommBillPrintNewSigle(INVstr, ClassName, MethodName) {
	var INVtmp = INVstr.split("^");
	//INVstr
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = websys_$V('ReadCommOPDataEncrypt');
			var PayMode = "";
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myExpStr = "";
			var myPreDep = "";
			var myCharge = "";
			var myCurGroupDR = session['LOGON.GROUPID'];
			var myExpStr = myPreDep + "^" + myCharge + "^" + myCurGroupDR;
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", ClassName, MethodName, PrtXMLName, INVtmp[invi], sUserCode, PayMode, myExpStr);
		}
	}
}

function BillPrintNew(INVstr) {
	if (InvRequireFlag == "N") {
		return;
	}
	if (PrtXMLName == "") {
		return;
	}
	var INVtmp = INVstr.split("^");
	//INVstr
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = websys_$V('getSendtoPrintinfo');
			var PayMode = "";
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myCurGroupDR = session['LOGON.GROUPID'];
			var myExpStr = "";
			var myPreDep = ""; //实收金额
			var myCharge = ""; //找零金额
			var myExpStr = myPreDep + "^" + myCharge + "^" + myCurGroupDR;
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", PrtXMLName, INVtmp[invi], sUserCode, PayMode, myExpStr);
		}
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
}

function GetLogData(prtRowID) {
	var msg = "";
	var invInfo = tkMakeServerCall("web.DHCOPBillChargExcepiton", "GetOPRcptinfo", prtRowID);
	var tmpArg = invInfo.split("^");
	//发票rowid^发票日期^发票时间^PAPMI指针^病人姓名^病人登记号^收费员姓名^发票金额
	var prtDate = tmpArg[1];
	var prtTime = tmpArg[2];
	var papmi = tmpArg[3];
	var patName = tmpArg[4];
	var patientID = tmpArg[5];
	var prtUserName = tmpArg[6];
	var prtAmt = tmpArg[7];
	var guserName = session['LOGON.USERNAME'];
	var groupDesc = session['LOGON.GROUPDESC'];
	var msg = "操作人：" + guserName;
	msg = msg + " ^ " + "发票指针：" + prtRowID;
	msg = msg + " ^ " + "发票日期：" + prtDate;
	msg = msg + " ^ " + "发票时间：" + prtTime;
	msg = msg + " ^ " + "发票金额：" + prtAmt;
	msg = msg + " ^ " + "主索引：" + papmi;
	msg = msg + " ^ " + "病人ID：" + patientID;
	msg = msg + " ^ " + "病人姓名：" + patName;
	msg = msg + " ^ " + "收费员姓名：" + prtUserName;
	return msg;
}

function SetExcepitonLog(prtRowID, flag, msg) {
	var rtn = tkMakeServerCall("web.DHCOPBillChargExcepiton", "SetExcepitonLog", prtRowID, flag, msg);
}

document.body.onload = BodyLoadHandler;
