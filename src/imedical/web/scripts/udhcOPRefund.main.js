/// udhcOPRefund.main.js

var GUser;
var ExeFlag;
var RebillFlag;
var m_AbortPop = 0;
var m_RefundPop = 0;
var PrtXMLName;
var m_YBConFlag = "0";    //default not Connection YB
var m_SelectCardTypeRowID = "";
var PUsr = "";
var PUsrN = "";
var InvFlag = "";
var FramName = "udhcOPRefund_main";

function BodyLoadHandler() {
	var obj = document.getElementById("RefundPayMode");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}
	DHCWebD_ClearAllListA("RefundPayMode");
	var mygLoc = session['LOGON.GROUPID'];
	var encmeth = DHCWebD_GetObjValue("PayModeEncrypt");
	if (encmeth != "") {
		var refPayMExpStr = "REF";
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "RefundPayMode", mygLoc, "", refPayMExpStr);
	}
	IntDoc();
	var obj = document.getElementById("ReceipNO");
	if (obj) {
		obj.onkeydown = ReceipNO_KeyDown;
	}
	var obj = document.getElementById("Abort");
	DHCWeb_DisBtn(obj);
	obj = document.getElementById("Refund");
	DHCWeb_DisBtn(obj);
	obj = document.getElementById("RefClear");
	if (obj) {
		obj.onclick = RefundClear_Click;
	}
	obj = document.getElementById("BtnQuery");
	if (obj) {
		obj.onclick = INVQuery_Click;
	}
	var obj = document.getElementById("ReadCardQuery");
	if (obj) {
		obj.onclick = ReadCardQuery_OnClick;
	}
	ReadINVInfo();
	var ReceipRowid = DHCWebD_GetObjValue("ReceipID");
	if (ReceipRowid != "") {
		GetPayModeList(ReceipRowid);
	}
	DHCWeb_setfocus("ReceipNO");
	document.onkeydown = document_OnKeyDown;
	var encmeth = DHCWebD_GetObjValue("ReadOPBaseEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth);
		var myary = myrtn.split("^");
		m_YBConFlag = myary[12];
		DHCWebD_SetObjValueA("RoundNum", myary[13]);
	}
	if (m_YBConFlag == "1") {
		DHCWebOPYB_InitForm();
	}
	var obj = document.getElementById('CardTypeDefine');
	if (obj) {
		ReadCardType();
		obj.setAttribute("isDefualt", "true");
		combo_CardType = dhtmlXComboFromSelect("CardTypeDefine");
	}
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle = combo_CardTypeKeydownHandler;
	}
	combo_CardTypeKeydownHandler();
	//modify 2011-06-10 增加发票补打功能
	obj = document.getElementById("RePrt");
	if (obj) {
		obj.onclick = RePrt_Click;
	}
	obj = document.getElementById("ReNumber");
	if (obj) {
		obj.onclick = ReNumber_Click;
	}
	//补调用医保接口
	obj = document.getElementById("BtpPrtInvInsu");
	if (obj) {
		obj.onclick = PrtInvInsuUpdate;
	}
}

function document_OnKeyDown() {
	var e = event ? event : (window.event ? window.event : null);
	parent.window.FrameShutCutKeyFrame(e);
	DHCWeb_EStopSpaceKey();
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

function INVQuery_Click() {
	//DHCOPINV.Query
	QueryInv();
}

function ReadCardQuery_OnClick() {
	//var myrtn = DHCACC_GetAccInfo();
	var myCardTypeValue = combo_CardType.getSelectedValue();
	var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeRowID, myCardTypeValue);
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		//var obj = document.getElementById("PatientID");
		//obj.value = myary[5];
		ReadCardQueryINV(myary[5]);
		//ReadPatInfo();
		break;
	case "-200":
		alert(t["-200"]);
		break;
	case "-201":
		ReadCardQueryINV(myary[5]);
		/*
		alert(t["-201"]);
		var obj = document.getElementById("PatientID");
		obj.value = myary[5];
		ReadPatInfo();
		*/
		break;
	default:
		//alert("");
	}
}

function ReadCardQueryINV(PAPMNo) {
	var mygLocDR = session['LOGON.GROUPID'];
	var myULoadLocDR = session['LOGON.CTLOCID'];
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk += "&FramName=udhcOPRefund_main&PatientNO=" + PAPMNo;
	lnk += "&AuditFlag=ALL&sFlag=PRT&INVStatus=N";
	lnk += "&gLocDR=" + mygLocDR + "&ULoadLocDR=" + myULoadLocDR;
	var openObj = window;   //2018-05-29 ZhYW 解决在使用Modal Dialog的时候，弹出多个页面会导致页面新页面session丢失，需要重新login
	if (typeof(window.dialogArguments) == "object") {
		openObj = window.dialogArguments;
	}
	var NewWin = openObj.open(lnk, "udhcOPINV_Query", "scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function QueryInv() {
	var mygLocDR = session['LOGON.GROUPID'];
	var myULoadLocDR = session['LOGON.CTLOCID'];
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk += "&FramName=udhcOPRefund_main";
	lnk += "&AuditFlag=ALL&sFlag=PRT&INVStatus=N";
	lnk += "&gLocDR=" + mygLocDR + "&ULoadLocDR=" + myULoadLocDR;
	var openObj = window;   //2018-05-29 ZhYW 解决在使用Modal Dialog的时候，弹出多个页面会导致页面新页面session丢失，需要重新login
	if (typeof(window.dialogArguments) == "object") {
		openObj = window.dialogArguments;
	}
	var NewWin = openObj.open(lnk, "udhcOPINV_Query", "scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function RefundClear_Click() {
	IntRefMain();
	AddIDToOrder("");
}

function BVerify_Click() {
	var ReceipID = DHCWebD_GetObjValue("ReceipID");
	GUser = session['LOGON.USERID'];
	var encmeth = DHCWebD_GetObjValue('getVerify');
	if (cspRunServerMethod(encmeth, ReceipID, GUser) == '0') {
		alert(t['04']);
	} else {
		alert(t['05']);
	}
}

function ReceipNO_KeyDown(e) {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	if ((obj) && (obj.value != "") && (key == 13)) {
		var No = obj.value;
		var UserDepID = session['LOGON.CTLOCID'];
		var encmeth = DHCWebD_GetObjValue('getReceipID');
		var mytmprtn = cspRunServerMethod(encmeth, 'SetReceipID', '', No, UserDepID);
		if (mytmprtn == '-1') {
			alert("该发票号不存,请核实!");
			websys_setfocus('ReceipNO');
			return websys_cancel();
		} else if ((mytmprtn == '-2') || (mytmprtn.split("^")[1] == 'API')) {
			alert(t["15"]);
			websys_setfocus('ReceipNO');
			return websys_cancel();
		} else {
			var ReceipID = DHCWebD_GetObjValue("ReceipID");
			//yyx 2010-09-02
			//多种支付方式加载
			GetPayModeList(ReceipID);
			var encmeth = DHCWebD_GetObjValue("getReceiptinfo");
			if (cspRunServerMethod(encmeth, "SetReceipInfo", "", ReceipID) == '0') {
				parent.frames['udhcOPRefund_Order'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.Order&ReceipRowid=" + ReceipID;
				var flag = InvprtIsRegister(ReceipID);
				if (flag) {
					alert(t['invprtIsRegister']);
					var aobj = document.getElementById("Abort");
					if (aobj) {
						DHCWeb_DisBtn(aobj);
					}
					var reobj = document.getElementById("Refund");
					if (reobj) {
						DHCWeb_DisBtn(reobj);
					}
				}
			}
		}
	}
}

function ReadINVInfo() {
	//read INV Infomation
	var ReceipID = DHCWebD_GetObjValue("ReceipID");
	if (ReceipID == "") {
		return;
	}
	var encmeth = DHCWebD_GetObjValue('getReceiptinfo');
	var rtn = cspRunServerMethod(encmeth, 'SetReceipInfo', '', ReceipID);
	if (rtn == '0') {
		parent.frames['udhcOPRefund_Order'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.Order&ReceipRowid=" + ReceipID;
	}
}

function OPINVRefund_OnClick() {
	var aobj = document.getElementById("Abort");
	if (!aobj.disabled) {
		Abort_Click();
	} else {
		var robj = document.getElementById("Refund");
		if (!robj.disabled) {
			Refund_Click();
		}
	}
}

function Abort_Click() {
	var aobj = document.getElementById("Abort");
	if (aobj) {
		//DHCWeb_DisBtn(aobj);
	}
	var rtn = RefundSaveInfo("A");
	var aobj = document.getElementById("Abort");
	if ((rtn == false) && (aobj)) {
		//DHCWeb_DisBtn(aobj);
		DHCWeb_AvailabilityBtnA(aobj, Abort_Click);
	}
	if (rtn == true) {
		DHCWeb_DisBtn(aobj);
	}
}

function Refund_Click() {
	var robj = document.getElementById("Refund");
	if (robj) {
		//DHCWeb_DisBtn(robj);
	}
	var rtn = RefundSaveInfo("S");
	var robj = document.getElementById("Refund");
	if ((rtn == false) && (robj)) {
		DHCWeb_AvailabilityBtnA(robj, Refund_Click);
	}
	if (rtn == true) {
		DHCWeb_DisBtn(robj)
	}
}

function getOrderstr() {
	var listdoc = parent.frames["udhcOPRefund_Order"].document;
	var StopOrderAry = [];
	RebillFlag = 0;
	ExeFlag = 0;
	var objtbl = listdoc.getElementById('tudhcOPRefund_Order');
	var Rows = objtbl.rows.length;
	for (var j = 1; j < Rows; j++) {
		var excobj = listdoc.getElementById('TExcuteflagz' + j);
		var sExcute = DHCWebD_GetCellValue(excobj);
		var TSelect = listdoc.getElementById("Tselectz" + j);
		var selflag = DHCWebD_GetCellValue(TSelect);
		if (TSelect.disabled) {
			ExeFlag = 0;
		}
		var ordobj = listdoc.getElementById('TOrderRowidz' + j);
		var sOrderRowid = DHCWebD_GetCellValue(ordobj);
		var qtyObj = listdoc.getElementById('TOrderQtyz' + j);
		var ordqty = DHCWebD_GetCellValue(qtyObj);
		var refqtyObj = listdoc.getElementById('TReturnQtyz' + j);
		var refordqty = DHCWebD_GetCellValue(refqtyObj);
		//执行数量 yyx 2010-07-19
		var ExecQtyObj = listdoc.getElementById('TOEORDExecQtyz' + j);
		var ExecQty = DHCWebD_GetCellValue(ExecQtyObj);
		if (!selflag) {
			RebillFlag = 1;
		}
		if ((selflag) && (sExcute == "1") && (ordqty != refordqty)) {
			RebillFlag = 1;
		}
		//只有一条部分执行的医嘱退费再收费
		if (ExecQty == "") {
			ExecQty = 0;
		}
		if ((selflag) && (ExecQty != "0") && (ordqty != ExecQty)) {
			RebillFlag = 1;
		}
		var orderSumObj = listdoc.getElementById('TOrderSumz' + j);
		var orderSum = DHCWebD_GetCellValue(orderSumObj);
		var refSumObj = listdoc.getElementById('RefSumz' + j);
		var refSum = DHCWebD_GetCellValue(refSumObj);
		if (selflag && (+orderSum != +refSum)) {
			//部分退费
			RebillFlag = 1;
		}
		if (selflag) {
			StopOrderAry.push(sOrderRowid);
		}
	}
	
	var StopOrderStr = StopOrderAry.join('^');
	return StopOrderStr;
}

function RefundSaveInfo(RefundFlag) {
	//modify 2013-01-21 退费前判断该病人是否有异常发票
	var ReceipRowid = DHCWebD_GetObjValue("ReceipID");
	var rtn = tkMakeServerCall("web.DHCOPBillChargExcepiton", "JudgeINVTPFlag", ReceipRowid, "");
	if (rtn != "0") {
		alert("有未处理的异常发票请先处理后在退费");
		return;
	}
	//modify 2015-02-14 chenxi 增加判断发票里退费数量大于收费数量时不能结算
	var NegativeNum = CheckOENegativeNum(ReceipRowid);
	if ((NegativeNum == "") || (NegativeNum == " ")) {
		alert("发票查询有误!!");
		return;
	}
	if (isNaN(NegativeNum)) {
		alert("发票查询有误!!");
		return;
	}
	if (eval(NegativeNum) > 0) {
		alert("退费数量大于收费数量请核实!!");
		return;
	}
	var rtn = CheckRefund(RefundFlag);
	if (!rtn) {
		return rtn;
	}
	var rtn = CheckRefPaym();
	if (!rtn) {
		return rtn;
	}
	//yyx 2009-09-16
	//取选中的新的费别,并且根据费别取admsource判断是否需要调用医保接口
	var NewInsType = DHCWeb_GetListBoxValue('InsTypeList');
	var encmeth = DHCWebD_GetObjValue('GetAdmSource');
	var AdmSource = cspRunServerMethod(encmeth, NewInsType);
	var CurInsType = DHCWebD_GetObjValue("CurrentInsType");
	if ((CurInsType != NewInsType) && (NewInsType != "")) {
		var myrtn = window.confirm("重新收费的收费类别发生变化,是否确认退费?");
		if (!myrtn) {
			return myrtn;
		}
	}
	var StopOrdStr = getOrderstr();
	if (StopOrdStr == "") {
		var myrtn = window.confirm("没有需要退费的医嘱,是否确认过号重打发票?");
		if (!myrtn) {
			return myrtn;
		}
	}
	/*
	if (StopOrdStr == "") {
		alert("请选择要退费的医嘱.");
		return;
	}
	*/
	//Connection YB for Park Fair
	m_YBConFlag = 1;
	var myINSDivDR = DHCWebD_GetObjValue("INSDivDR");
	//alert("myINSDivDR=" + myINSDivDR);
	if (myINSDivDR != "") {
		//YB  INV
		if (m_YBConFlag == "0") {
			alert(t["YBINVTip"]);
			return;
		} else {
			//YB  Park Interface
			var myYBHand = "";
			var myCPPFlag = "";
			var myINSDivDR = myINSDivDR;
			var StrikeFlag = RebillFlag;
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
			var myExpStr = StrikeFlag + "^" + GroupDR + "^" + InsuNo + "^" + CardType + "^" + YLLB + "^" + DicCode + "^" + DicDesc;
			myExpStr += "^" + LeftAmt + "^" + ChargeSource + "^" + DYLB + "^" + "" + "^" + HospDR + "!" + LeftAmt + "^" + MoneyType;
			var rtn = DHCWebOPYB_ParkINVFYB(myYBHand, myUser, myINSDivDR, AdmSource, NewInsType, myExpStr, myCPPFlag);
			if (rtn != "0") {
				alert(t["YBParkErrTip"]);
				return;
			}
		}
	}
	if (myINSDivDR != "") {
		var InsuInfo = tkMakeServerCall("web.DHCINSUPort", "CheckINSUDivFlag", ReceipRowid, "", "", "", "S");
		InsuInfo = InsuInfo.split("!");
		if (InsuInfo[0] != "Y") {
			alert("医保退费失败,请稍后重退");
			return;
		}
	}
	var myUser = session['LOGON.USERID'];
	var gloc = session['LOGON.GROUPID'];
	var invodj = document.getElementById("Sum");
	var refundobj = document.getElementById("RefundSum");
	var patPay = 0;
	if ((invodj) && (refundobj)) {
		var invsum = invodj.value;
		if (isNaN(invsum)) {
			invsum = 0;
		}
		var refundsum = refundobj.value;
		if (isNaN(refundsum)) {
			refundsum = 0;
		}
		patPay = invsum - refundsum;
		patPay = patPay.toFixed(2);
	}
	//INVPRTRowid,rUser,sFlag,StopOrdStr,NInvPay,gloc
	var myUserLocID = session['LOGON.CTLOCID'];
	var mystr = DHCWeb_GetListBoxValue("RefundPayMode");
	var myary = mystr.split("^");
	var myPayModeDR = myary[0];
	var myPayModeCode = myary[2];
	//Lid 2010-07-05 更新多种支付方式,对于卡消费在界面上控制?在此不做控制
	var PayMentFlag = DHCWebD_GetObjValue("PayMentFlag");
	var MulityPayModeFlag = PayMentFlag ? "Y" : "N";
	var myExpStr = MulityPayModeFlag + "^^^^";
	var encmeth = DHCWebD_GetObjValue('getRefundRcpt');
	var rtnvalue = cspRunServerMethod(encmeth, ReceipRowid, myUser, RefundFlag, StopOrdStr, patPay, gloc, RebillFlag, myUserLocID, myPayModeDR, NewInsType, myExpStr);
	var myary = rtnvalue.split(String.fromCharCode(2));
	var rtn = myary[0].split("^");
	if (rtn[0] == '0') {
		//Add YB InterFace   &&(myPRTRowID!="")
		var myPRTRowID = "";
		var StrikeRowID = "";
		var RefundInvFlag = "N";
		if (rtn.length > 1) {
			myPRTRowID = rtn[1];
			StrikeRowID = rtn[2];
			RefundInvFlag = rtn[3];
		}
		var myINSDivDR = DHCWebD_GetObjValue("INSDivDR");
		if (((m_YBConFlag == "1") && (myINSDivDR != ""))) {
			var myYBHand = "";
			var myCPPFlag = "";
			var myExpStr = RebillFlag + "^";
			DHCWebOPYB_ParkINVFYBConfirm(myYBHand, myCPPFlag, myINSDivDR, myExpStr);
		}
		if (((m_YBConFlag == "1") && (myINSDivDR != "") && (myPRTRowID != "")) || ((m_YBConFlag == "1") && (AdmSource != 0) && (myPRTRowID != ""))) {
			var myYBHand = "";
			var myCPPFlag = "";
			var StrikeFlag = "S";
			var GroupDR = session['LOGON.GROUPID'];
			var HospDR = session['LOGON.HOSPID'];
			var InsuNo = "";
			var CardType = "";
			var YLLB = "";
			var DicCode = "";
			var DicDesc = "";
			var DYLB = "";
			var ChargeSource = "01";
			var DBConStr = "";    //数据库连接串
			var MoneyType = "";
			var SelPayMDR = (MulityPayModeFlag == "N") ? myPayModeDR : "";
			var myUser = session['LOGON.USERID'];
			var myAccMRowID = DHCWebD_GetObjValue("AccMRowID");
			var LeftAmt = tkMakeServerCall("web.UDHCAccManageCLS", "getAccBalance", myAccMRowID);
			if (myPayModeCode != "CPP") {
				LeftAmt = "";
				myCPPFlag = "NotCPPFlag";
			}
			var myExpStr = StrikeFlag + "^" + GroupDR + "^" + InsuNo + "^" + CardType + "^" + YLLB + "^" + DicCode + "^" + DicDesc;
			myExpStr += "^" + LeftAmt + "^" + ChargeSource + "^" + DBConStr + "^" + DYLB + "^" + myAccMRowID + "^" + HospDR + "^" + SelPayMDR + "!" + LeftAmt + "^" + MoneyType;
			DHCWebOPYB_DataUpdate(myYBHand, myUser, myPRTRowID, AdmSource, NewInsType, myExpStr, myCPPFlag);
		}
		
		//套餐退费
		var CheckPkgFlag = tkMakeServerCall("BILL.PKG.COM.BLCommon", "CheckByPrtstr", myPRTRowID);
		if (CheckPkgFlag == 1){
			var patNO = DHCWebD_GetObjValue("PatientID");  //病人登记号
			var PkgExpstr = "N^" + session['LOGON.USERID'] + "^" + session['LOGON.GROUPID'] + "^" + patNO;
			var rtn = tkMakeServerCall("BILL.PKG.COM.BLCommon", "UpdateInvPayModeByPrtStr", myPRTRowID, myPayModeDR, PkgExpstr);
			if (rtn != "0") {
				alert("更新套餐支付支付方式失败: "+ rtn);
				return;
			}
		}
		
		if ((MulityPayModeFlag == 'Y') && (StopOrdStr != "") && (RebillFlag == 1)) {
			var rtn = UpdatePayment(ReceipRowid, StrikeRowID, myPRTRowID); //入参:发票Rowid串
			if (!rtn) {
				//alert("更新门诊收费多种支付方式失败,请到门诊收费界面重新结算.")  //2016-06-01
				//return;
			}
		}
		//银医卡接口
		if (myPayModeCode == "CARDCPP") {
			var BMCRtn = BankCardRefund(ReceipRowid, StrikeRowID, myPRTRowID);
		}
		//门诊收费确认完成
		var encmeth = DHCWebD_GetObjValue('CompleteChargeEncrypt');
		if (myPRTRowID != "") {
			//新发票rowid不为空时，要确认完成
			//对于退费重新的确认完成,扩展参数取不到时可以先传空,在类里取值。
			var TMPExpStr = gloc + "^" + myUserLocID + "^" + "" + "^" + "";
				TMPExpStr += "^" + "";
				TMPExpStr += "^" + "" + "^" + "" + "^" + "";
				TMPExpStr += "^" + NewInsType;
			var rtn = cspRunServerMethod(encmeth, "3", myUser, CurInsType, myPRTRowID, "1", ReceipRowid, TMPExpStr);
			if (rtn != "0") {
				//2017-12-19 ZhYW
				chargeFail_alert('completeFail', rtn);
				return;
			}
		}
		
		/*
		//第三方退费接口 start RefundPayService.js
		var TradeType = "OP";
		var refundAmt = "";
		var expStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] + "^^";
		var refRtn = RefundPayService(TradeType, ReceipRowid, StrikeRowID, myPRTRowID, refundAmt, "OP", expStr);
		if(refRtn.split("^")[0] != 0){
			alert(refRtn.split("^")[1] + ",错误代码" + refRtn.split("^")[0]);
		}
		//
		*/
		var myRCalFlag = 1;
		var myINSDivDR = DHCWebD_GetObjValue("INSDivDR");
		if (((m_YBConFlag == "1") && (myINSDivDR != "")) || (myRCalFlag == 1)) {
			var encmeth = DHCWebD_GetObjValue("ReadRefSumEncrypt");
			if (encmeth != "") {
				var myExpstr = "";
				var myRefSum = cspRunServerMethod(encmeth, ReceipRowid, myExpstr);
				var obj = document.getElementById("FactRefSum");
				if (obj) {
					obj.value = myRefSum;
				}
			}
		}
		var encmeth = DHCWebD_GetObjValue('getUpdateRETFLAG');
		if (encmeth != "") {
			var mytmprtn = cspRunServerMethod(encmeth, myary[0]);

		}
		if (RefundInvFlag == "Y") {
			BillPrintTaskListNew(StrikeRowID);
		}

		BillPrintTaskListNew(myPRTRowID);

		alert(t['07']);

		return true;
	} else {
		//2017-12-19 ZhYW
		chargeFail_alert('refundFail', rtn[0]);
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
					DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName);  //INVPrtFlag
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
	var PayMode = DHCWebD_GetObjValue("PayMode");
	var Guser = session['LOGON.USERID'];
	var sUserCode = session['LOGON.USERCODE'];
	var myExpStr = "";
	var myPreDep = DHCWebD_GetObjValue("Actualmoney");
	var myCharge = DHCWebD_GetObjValue("Change");
	var myCurGroupDR = session['LOGON.GROUPID'];
	var myExpStr = myPreDep + "^" + myCharge + "^" + myCurGroupDR;
	var encmeth = DHCWebD_GetObjValue('ReadCommOPDataEncrypt');
	var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", ClassName, MethodName, PrtXMLName, INVstr, sUserCode, PayMode, myExpStr);
	//}
	//}
}

function CommBillPrintNewSigle(INVstr, ClassName, MethodName) {
	var INVtmp = INVstr.split("^");
	//INVstr
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var PayMode = DHCWebD_GetObjValue('PayMode');
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myExpStr = "";
			var myPreDep = DHCWebD_GetObjValue('Actualmoney');
			var myCharge = DHCWebD_GetObjValue("Change");
			var myCurGroupDR = session['LOGON.GROUPID'];
			var myExpStr = myPreDep + "^" + myCharge + "^" + myCurGroupDR;
			var encmeth = DHCWebD_GetObjValue('ReadCommOPDataEncrypt');
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
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			//+2017-06-02 ZhYW 根据实际发票的收费类别查找模板名称
			var tmpPrtXMLName = tkMakeServerCall("web.UDHCJFBaseCommon", "GetPrtXMLName", INVtmp[invi], "O", PrtXMLName);
			DHCP_GetXMLConfig("InvPrintEncrypt", tmpPrtXMLName); //此处只修改调用模板, 不需要修改PrtXMLName
			//
			var PayMode = DHCWebD_GetObjValue('RefundPayMode');
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			//GetInvoicePrtDetail(JSFunName As %String,InvRowID, UseID, PayMode
			//JSFunName, PrtXMLName, InvRowID, UseID, PayMode, ExpStr
			var myCurGroupDR = session['LOGON.GROUPID'];
			var myExpStr = "^^" + myCurGroupDR;
			var encmeth = DHCWebD_GetObjValue('getSendtoPrintinfo');
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", PrtXMLName, INVtmp[invi], sUserCode, PayMode, myExpStr);
		}
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
}

function CheckRefund(RefundFlag) {
	var mySOrder = getOrderstr();
	var myrtn = window.confirm(t["BackConfirmINVTip"]);
	if (!myrtn) {
		return myrtn;
	}
	if (mySOrder == "") {
		if ((ExeFlag == 0) && (RefundFlag == "A")) {
			return true;
		}
		if ((ExeFlag == 0) && (RefundFlag == "S")) {
			return true;
		}
		//alert(t['03']);
		//return false;
	}
	var myReceipNO = DHCWebD_GetObjValue("ReceipNO");
	if (myReceipNO != "") {
		//alert(t["BackINVTip"]);
	}
	return true;
}

function SetReceipID(value) {
	var ReceipIDInfo = value.split("^");
	var ReceipID = ReceipIDInfo[0];
	var IDobj = document.getElementById("ReceipID");
	IDobj.value = ReceipID;
}

function SetReceipInfo(value) {
	var Split_Value = value.split("^");
	var Sumobj = document.getElementById("Sum");
	var sexobj = document.getElementById("PatientSex");
	var nameobj = document.getElementById("PatientName");
	var noobj = document.getElementById("PatientID");
	var cobj = document.getElementById("Abort");
	var robj = document.getElementById("Refund");
	GUser = session['LOGON.USERID'];
	noobj.value = Split_Value[0];
	nameobj.value = Split_Value[1];
	sexobj.value = Split_Value[2];
	Sumobj.value = Split_Value[3];
	PUsr = Split_Value[6];
	PUsrN = Split_Value[23];
	DHCWebD_SetObjValueA("AccMRowID", Split_Value[22]);
	var PatDr = Split_Value[19];
	var obj = document.getElementById("INSDivDR");
	if (obj) {
		obj.value = Split_Value[13];
	}
	var obj = document.getElementById("CurrentInsType");
	if (obj) {
		obj.value = Split_Value[17];
	}
	DHCWeb_DisBtn(cobj);
	DHCWeb_DisBtn(robj);
	var isPayMExsit = 0;
	if (Split_Value[9] != "") {
		var obj = document.getElementById("RefundPayMode");
		var myLen = obj.options.length;
		for (var i = 0; i < myLen; i++) {
			var mystr = obj.options[i].value;
			var myary = mystr.split("^");
			if (myary[0] == Split_Value[9]) {
				obj.selectedIndex = i;
				isPayMExsit = 1;
				break;
			}
		}
	}
	if (isPayMExsit == 0) {
		alert(t["PermissionDeniedRefund"]);
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}
	AddPrescTypeToList(PatDr);
	if ((Split_Value[6] == GUser) && (Split_Value[7] == "")) {
		InvFlag = "A";
		if (m_AbortPop == "1") {
			DHCWeb_AvailabilityBtnA(cobj, Abort_Click);
		} else {
			alert(t["NoAbortPop"]);
		}
	} else {
		InvFlag = "S";
		if (m_RefundPop == "1") {
			DHCWeb_AvailabilityBtnA(robj, Refund_Click);
		} else {
			alert(t["NoRefundPop"]);
		}
	}
	if ((Split_Value[18] != "") && (Split_Value[18] != "N")) {
		alert(t['-201']);
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}
	/*
	//+2019-03-25 ZhYW 先去掉不用
	if (((Split_Value[8] != "Y") && !((Split_Value[6] == GUser) && (Split_Value[7] == ""))) || (Split_Value[14] == "Y")) {
		alert(t['10']);
		websys_setfocus('ReceipNO');
		DHCWeb_DisBtn(cobj);
		DHCWeb_DisBtn(robj);
		return websys_cancel();
	}
	*/
	var myColPFlag = Split_Value[10];
	if (myColPFlag == "1") {
		alert(t["ColPTip"]);
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}
	if (Split_Value[4] == "A") {
		alert(t['11']);
		websys_setfocus('ReceipNO');
		DHCWeb_DisBtn(cobj);
		return websys_cancel();
	}
	if (Split_Value[5] == "1") {
		alert(t['12']);
		websys_setfocus('ReceipNO');
		DHCWeb_DisBtn(robj);
		return websys_cancel();
	}
}

function AddIDToOrder(ReceipID) {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.Order&ReceipRowid=" + ReceipID;
	var AdmCharge = parent.frames['udhcOPRefund_Order'];
	AdmCharge.location.href = lnk;
}

function IntRefMain() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund_main";
	var AdmCharge = parent.frames['udhcOPRefund_main'];
	AdmCharge.location.href = lnk;
}

function ReadCardType() {
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "CardTypeDefine");
	}
}

function combo_CardTypeKeydownHandler() {
	var myoptval = combo_CardType.getSelectedValue();
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_SelectCardTypeRowID = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	m_CCMRowID = myary[14];
	//Read Card Mode
	if (myary[16] == "Handle") {
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadCard");
	} else {
		//m_CCMRowID = GetCardEqRowId();
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.readOnly = true;
		}
		var obj = document.getElementById("ReadCard");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, ReadHFMagCard_Click);
		}
	}
}

///Creator:yyx
///CreateDate:2009-09-16
///Function: 显示病人的费别
function AddPrescTypeToList(PatDr) {
	var CurInsType = DHCWebD_GetObjValue("CurrentInsType");
	var myExpStr = "";
	var encmeth = DHCWebD_GetObjValue('GetPatPresc');
	var PrescTypeStr = cspRunServerMethod(encmeth, PatDr, myExpStr);
	var PrescType = PrescTypeStr.split("\002");
	var InsTypeList = document.getElementById('InsTypeList');
	InsTypeList.size = 1;
	InsTypeList.multiple = false;
	if (PrescType.length == 0) {
		return "";
	}
	var DefaultIndex = 0;
	for (i = 0; i < PrescType.length; i++) {
		PrescList = PrescType[i].split("^");
		var ListText = PrescList[0];
		var ListValue = PrescList[1];
		var PatInsType = PrescList[2];
		InsTypeList.options[i] = new Option(ListText, ListValue);
		if (CurInsType == ListValue) {
			DefaultIndex = i;
		}
	}
	InsTypeList.options[DefaultIndex].selected = true;
}

function InvprtIsRegister(invprtRowid) {
	var encmeth = DHCWebD_GetObjValue('getPrtFairType');
	if (encmeth != "") {
		var fairType = cspRunServerMethod(encmeth, invprtRowid);
		if (fairType == "R") {
			return true;
		}
		return false;
	}
}

///Creator: yyx
///CreateDate: 2010-09-01
///Function: 加载支付方式
function GetPayModeList(PrtRowID) {
	var PayModeListObj = document.getElementById('PayModeList');
	PayModeListObj.options.length = 0;
	var encmeth = DHCWebD_GetObjValue('GetPayModeList');
	if (encmeth != "") {
		var PayModeInfo = cspRunServerMethod(encmeth, PrtRowID);
		PayModeInfo = PayModeInfo.split("&");
		if (PayModeInfo[0] > 1) {
			DHCWebD_SetObjValueB('PayMentFlag', true);
		} else {
			DHCWebD_SetObjValueB('PayMentFlag', false);
		}
		for (i = 1; i < PayModeInfo.length; i++) {
			option = document.createElement("option");
			option.value = PayModeInfo[i];
			option.text = PayModeInfo[i];
			PayModeListObj.add(option);
		}
	}
}

///Lid 2010-07-05 更新多种支付方式?如果更新失败?则程序回滚
function UpdatePayment(ReceipRowid, StrikeRowID, myPRTRowID) {
	var paymentFlag = DHCWebD_GetObjValue('PayMentFlag'); //多种支付方式标志
	var myrtn = true;
	if (paymentFlag) {
		var patNO = DHCWebD_GetObjValue("PatientID"); //病人登记号
		var expstr = "N^" + session['LOGON.USERID'] + "^" + session['LOGON.GROUPID'] + "^" + patNO;
		//更新过多种支付方式
		var str = 'websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillPaymentRefund&NewPrtRowid=' + myPRTRowID + '&OldPrtRowid=' + ReceipRowid;
		var DlgReturnValue = window.showModalDialog(str, "", 'dialogWidth:700px;dialogHeight:450px;resizable:yes'); //HTML样式的模态对话框
		//alert(DlgReturnValue);
		if ((DlgReturnValue == "undefined") || ((typeof(DlgReturnValue) == "undefined"))) {
			DlgReturnValue = -2;
		}
		//alert(DlgReturnValue);
		switch (DlgReturnValue) {
		case -1:
			myrtn = true; //不使用多种支付方式
			break;
		case -2:
			myrtn = false;
			var delexpstr = "^" + session['LOGON.GROUPID'];
			//2016-06-01
			/*
			var err = DeleteHISData(myPRTRowID, delexpstr)
			if (rtn === "HisCancelSuccess") {
				myrtn = false;      //撤销结算
				//alert("取消结算成功");
			} else if (rtn === "HisCancelFail") {
				myrtn = true;      //His撤销失败时?按默认支付方式结算出票
				alert("His撤销失败,按默认支付方式结算!");
			}
			*/
			alert("按默认支付方式结算!");
			break;
		default:
			var rtn = UpDatePaymode(ReceipRowid, StrikeRowID, myPRTRowID, DlgReturnValue, expstr);
			if (rtn === "0") {
				myrtn = true;
			} else if (rtn === "HisCancelSuccess") {
				myrtn = false; //撤销结算
			} else if (rtn === "HisCancelFail") {
				myrtn = true;  //His撤销失败时?按默认支付方式结算出票
				alert("His撤销失败,按默认支付方式结算!");
			}
		}
	}
	return myrtn
}

///Lid 2010-07-06 更新多种支付方式
function UpDatePaymode(OldPrtRowid, StrikeRowID, NewPrtRowid, payMInfo, expstr) {
	var rtn = tkMakeServerCall("web.DHCOPBillManyPaymentLogic", "UpdateNewInvPayM2", payMInfo, OldPrtRowid, NewPrtRowid, expstr);
	//alert(rtn);
	var myrtn = rtn;
	if (rtn !== "0") {
		//多种支付方式更新失败,分三种情况:
		//   1.自费病人?His撤销结算?
		//   2.医保病人?如果医保有撤销函数?则医保?His都撤销结算?
		//   3.医保病人?如果医保没有撤销函数?则His不能撤销结算,只能按默认支付方式结算?或者补结算?
		var delexpstr = "^" + session['LOGON.GROUPID'];
		return DeleteHISData(NewPrtRowid, expstr);
	}
	return rtn;
}

///Lid 2010-07-06 回滚His数据
function DeleteHISData(prtRowidStr, expstr) {
	var err = DHCWebOPYB_DeleteHISData(prtRowidStr, expstr);
	if (err === "0") {
		myrtn = "HisCancelSuccess"; //His撤销成功
	} else {
		myrtn = "HisCancelFail";   //His撤销失败
	}
	return myrtn;
}

function RePrt_Click() {
	var myReceipNO = DHCWebD_GetObjValue("ReceipNO");
	var rtn = window.confirm("是否确认将" + myReceipNO + "发票重新打印?");
	if (!rtn) {
		return;
	}
	var ReceipRowid = DHCWebD_GetObjValue("ReceipID");
	if ((ReceipRowid == "") || (ReceipRowid == " ")) {
		alert("请选择要补打的发票");
		return;
	}
	BillPrintNew("^" + ReceipRowid);
}

/**
* 过号重打
*/
function ReNumber_Click() {
	var RepPrintFlag = window.confirm("是否确认作废原发票重打发票?");
	if (!RepPrintFlag) {
		return;
	}
	//+2017-09-15 ZhYW
	var ListObj = parent.frames["udhcOPRefund_Order"];
	ListObj.SelectAll(false);
	//
	var StopOrdStr = getOrderstr();
	if (StopOrdStr != "") {
		alert("有停止医嘱不能新号重打.");
		return;
	}
	var myUser = session['LOGON.USERID'];
	if (PUsr != myUser) {
		alert("请联系操作员:" + PUsrN + "," + "新号重打.");
		return;
	}
	var rtn = CheckRefPaym();
	if (!rtn) {
		return rtn;
	}
	/*
	//update  2010.10.11  zhl   sp
	if (ExeSel == "1"){
		alert("有执行的医嘱,不能新号重打!");
		return;
	}
	*/
	var ReceipRowid = DHCWebD_GetObjValue("ReceipID");
	var gloc = session['LOGON.GROUPID'];
	var invodj = document.getElementById("Sum");
	var refundobj = document.getElementById("RefundSum");
	var patPay = 0;
	if ((invodj) && (refundobj)) {
		var invsum = invodj.value;
		if (isNaN(invsum)) {
			invsum = 0;
		}
		var refundsum = refundobj.value;
		if (isNaN(refundsum)) {
			refundsum = 0;
		}
		patPay = invsum - refundsum;
		patPay = patPay.toFixed(2);
	}
	var NewInsType = DHCWeb_GetListBoxValue('InsTypeList');
	var myUserLocID = session['LOGON.CTLOCID'];
	var mystr = DHCWeb_GetListBoxValue("RefundPayMode");
	var myary = mystr.split("^");
	var myPayModeDR = myary[0];
	var PayMentFlag = DHCWebD_GetObjValue("PayMentFlag");
	var MulityPayModeFlag = PayMentFlag ? 'Y' : 'N';
	var myExpStr = MulityPayModeFlag  + "^^^^";
	var encmeth = DHCWebD_GetObjValue('getRefundRcpt');
	var rtnvalue = cspRunServerMethod(encmeth, ReceipRowid, myUser, InvFlag, StopOrdStr, patPay, gloc, RebillFlag, myUserLocID, myPayModeDR, NewInsType, myExpStr);
	var myary = rtnvalue.split(String.fromCharCode(2));
	var rtn = myary[0].split("^");
	if (rtn[0] == '0') {
		//Add YB InterFace
		var myPRTRowID = "";
		if (rtn.length > 1) {
			myPRTRowID = rtn[1];
		}
		var myINSDivDR = DHCWebD_GetObjValue('INSDivDR');
		if (myINSDivDR != "") {
			var encmeth = DHCWebD_GetObjValue('UpRepInvPayM');
			if (encmeth != "") {
				var mytmprtn = cspRunServerMethod(encmeth, ReceipRowid, myary[0]);
			}
		}
		//门诊收费确认完成
		var encmeth = DHCWebD_GetObjValue('CompleteChargeEncrypt');
		//对于退费重新的确认完成,扩展参数取不到时可以先传空,在类里取值。
		var TMPExpStr = gloc + "^" + myUserLocID + "^" + "" + "^" + "";
			TMPExpStr += "^" + "";
			TMPExpStr += "^" + "" + "^" + "" + "^" + "";
			TMPExpStr += "^" + NewInsType;
		
		var CurInsType = ""; //为空时，取发票表上的费别
		var rtn = cspRunServerMethod(encmeth, "3", myUser, CurInsType, myPRTRowID, "1", ReceipRowid, TMPExpStr);
		if (rtn != "0") {
			alert(t['CompleteFailed']);
			return;
		}
		BillPrintNew("^" + myPRTRowID);
		alert("新号重打成功");
		return true;
	} else {
		switch (rtn[0]) {
		case 101:
			alert("过号失败101");
		default:
			alert("过号失败" + rtn[0]);
		}
		return false;
	}
}

/*
* 补调医保接口
*/
function PrtInvInsuUpdate() {
	var myINSDivDR = DHCWebD_GetObjValue("INSDivDR");
	var ReceipRowid = DHCWebD_GetObjValue("ReceipID");
	if (InvFlag != "A") {
		alert("收费员已结算或不是本人收据,不允许调用医保接口.");
		return;
	}
	if (myINSDivDR != "") {
		alert("此发票已经是医保结算,不允许调用医保接口.");
		return;
	}
	var NewInsType = DHCWeb_GetListBoxValue('InsTypeList');
	var encmeth = DHCWebD_GetObjValue('GetAdmSource');
	var AdmSource = cspRunServerMethod(encmeth, NewInsType);
	var CurInsType = DHCWebD_GetObjValue("CurrentInsType");
	if ((CurInsType != NewInsType) && (NewInsType != "")) {
		var myrtn = window.confirm("重新收费的收费类别发生变化,是否确认退费?");
		if (!myrtn) {
			return myrtn;
		}
	}
	var myPayModeDesc = DHCWebD_GetObjValue('RefundPayMode');
	var myStr = DHCWeb_GetListBoxValue("RefundPayMode");
	var myAry = myStr.split("^");
	var myPayModeDR = myAry[0];
	var myPayModeCode = myAry[2];
	if (((m_YBConFlag == "1") && (myINSDivDR == "") && (AdmSource != 0) && (ReceipRowid != ""))) {		
		var myYBHand = "";
		var myCPPFlag = "";
		var StrikeFlag = "N";
		var GroupDR = session['LOGON.GROUPID'];
		var HospDR = session['LOGON.HOSPID'];
		var InsuNo = "";
		var CardType = "";
		var YLLB = "";
		var DicCode = "";
		var DicDesc = "";
		var DYLB = "";
		var ChargeSource = "01";
		var MoneyType = "";
		var myUser = session['LOGON.USERID'];
		var myAccMRowID = DHCWebD_GetObjValue("AccMRowID");
		var LeftAmt = tkMakeServerCall("web.UDHCAccManageCLS", "getAccBalance", myAccMRowID);
		if (myPayModeCode != "CPP") {
			LeftAmt = "";
			myCPPFlag = "NotCPPFlag";
		}
		var myExpStr = StrikeFlag + "^" + GroupDR + "^" + InsuNo + "^" + CardType + "^" + YLLB + "^" + DicCode + "^" + DicDesc;
		myExpStr += "^" + LeftAmt + "^" + ChargeSource + "^" + DYLB + "^" + myAccMRowID + "^" + HospDR + "!" + LeftAmt + "^" + MoneyType;
			
		myYBrtn = DHCWebOPYB_DataUpdate(myYBHand, myUser, ReceipRowid, AdmSource, NewInsType, myExpStr, myCPPFlag);
		var myYBarry = myYBrtn.split("^");
		if (myYBarry[0] == "0") {
			var rtn = tkMakeServerCall("web.DHCBillCons12", "UpdateInvInstype", ReceipRowid, NewInsType, session['LOGON.USERID']);
			rtn = rtn.split("^");
			if (rtn[0] != 0){
				 alert('更新发票费别失败, 请联系管理员修改发票费别');
			}else {
				alert('请退款,' + myPayModeDesc + ': ' + rtn[1] + '元');   //此处提示不考虑多种支付方式
			}
			var prtInsDivDr = tkMakeServerCall("web.udhcOPRefEdit1", "GetInsDivDrByPrtRowid", ReceipRowid);
			if ((prtInsDivDr != "") && (prtInsDivDr != "0")) {
				DHCWebD_SetObjValueA("INSDivDR", prtInsDivDr);
				//ReNumber_Click();
			}
		}
	}
}

///HIS撤销结算
function HISRollBack(PrtRowID, PRTInsDivDR, InsTypeDR, AdmSource, ExpStr) {
	var GroupDR = session['LOGON.GROUPID'];
	var myUser = session['LOGON.USERID'];
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
		var DYLB = "";
		var LeftAmt = "";
		var MoneyType = ""; //卡类型
		var LeftAmtStr = LeftAmt + "!" + LeftAmt + "^" + MoneyType;
		var myExpStr = StrikeFlag + "^" + GroupDR + "^" + InsuNo + "^" + CardType + "^" + YLLB + "^" + DicCode + "^" + DYLB + "^" + LeftAmtStr;
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
	} else {
		alert(t['CancelFailed']);
	}
	return rtn;
}

/// Creator:       chenxi
/// CreateDate:    2015-02-14
/// Function:      判断发票退费时退费数量是否大于收费数量
function CheckOENegativeNum(InvRowid) {
	if ((InvRowid == "") || (InvRowid == " ")) {
		return 0;
	}
	var ErrNum = tkMakeServerCall("web.udhcOPRefund", "CheckOENegativeNum", InvRowid);
	return ErrNum;
}

function CheckRefPaym() {
	var rtn = true;
	var myPaymAry = [];
	var PayModeList = document.getElementById("PayModeList");
	if (PayModeList) {
		for (var i = 0; i < PayModeList.length; i++) {
			var myStr = PayModeList.options[i].value;
			var myPaymCode = myStr.split(/\s+/g)[2];
			myPaymAry.push(myPaymCode);
		}
	}
	var RefundPayMode = DHCWeb_GetListBoxValue("RefundPayMode");
	var refPaymCode = RefundPayMode.split("^")[2];
	if ((myPaymAry.indexOf('QF') != -1) && (refPaymCode != 'QF')) {
		alert('欠费发票退费只能选欠费支付方式');
		rtn = false;
	}
	if ((myPaymAry.indexOf('QF') == -1) && (refPaymCode == 'QF')) {
		alert('非欠费发票退费不能选欠费支付方式');
		rtn = false;
	}
	if ((myPaymAry.indexOf('CPP') == -1) && (refPaymCode == 'CPP')) {
		alert('非预交金支付发票不能选预交金退费');
		rtn = false;
	}
	return rtn;
}

document.body.onload = BodyLoadHandler;