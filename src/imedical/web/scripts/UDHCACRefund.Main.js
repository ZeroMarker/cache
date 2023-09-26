/// UDHCACRefund.Main.js

var m_YBConFlag = "0"; //default not Connection YB
var ExeFlag = 0;
var m_AbortFlag = 0;
var m_RefundFlag = 0;
var m_RebillFlag = 0;
var m_RefRowIDStr = new Array();
var m_InsType = "";
var m_admsource = "";
var m_SelectCardTypeRowID = "";
var StopOrderstr = "";
var FramName = "UDHCACRefund_main";

function BodyLoadHandler() {
	var obj = document.getElementById("ReceipNO");
	if (obj) {
		obj.onkeypress = ReceipNO_OnKeyPress;
	}
	//14.12.5 补调医保
	var obj = document.getElementById("LinkInsu");
	if (obj) {
		obj.onclick = LinkInsuPay;
	}
	var obj = document.getElementById("Abort");
	DHCWeb_DisBtnA("Abort");

	var obj = document.getElementById("Refund");
	DHCWeb_DisBtnA("Refund");

	var obj = document.getElementById("Clear");
	if (obj) {
		obj.onclick = Clear_OnClick;
	}

	IntDocument();
	DHCWeb_setfocus("ReceipNO");

	IntDoc();
	document.onkeydown = DHCWeb_EStopSpaceKey;
	
	var obj = document.getElementById("ReceipNO");
	var myReloadFlag = DHCWebD_GetObjValue("ReloadFlag");
	if ((myReloadFlag == "1")&&(obj.value != "")) {
		//Load Receipt Info Direct
		event.keyCode = 13;
		ReceipNO_OnKeyPress();
		event.keyCode = 0;
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

	var obj = document.getElementById("ReadCardQuery");
	if (obj) {
		obj.onclick = ReadCardQuery_OnClick;
	}

	var obj = document.getElementById("RePrt");
	if (obj) {
		obj.onclick = RePrt_OnClick;
	}
	var obj = document.getElementById("ReNumber");
	if (obj) {
		obj.onclick = ReNumber_Click;
	}
	document.onkeydown = DocumentOnKeydown;

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
		//_"^"_GSRowID_"^"_FootFlag_"^"_RecLocFlag_"^"_PrtINVFlag
		//foot Flag
		//Check Invoice PrtFlag
		mPrtINVFlag = myary[4];
		//Get ColPrtXMLName
		var myPrtXMLName = myary[11];
	}
	PrtXMLName = myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName);    //INVPrtFlag

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

function Abort_OnClick() {
	RefundSaveInfo("A");
}

function Refund_OnClick() {
	RefundSaveInfo("S");
}

function Clear_OnClick() {
	SetACRefundMain();
	SetACRefOEOrder("");
	//SetACRefPayList("");
	//SetACRefOrder("");
}

function ReceipNO_OnKeyPress() {
	var key = event.keyCode;
	var myReceipNO = DHCWebD_GetObjValue("ReceipNO");
	if ((myReceipNO != "") && (key == 13)) {
		GetInfoByReceipNO();
	}
}

function GetInfoByReceipNO() {
	var myReceipNO = DHCWebD_GetObjValue("ReceipNO");
	var myUser = session['LOGON.USERID'];
	var encmeth = DHCWebD_GetObjValue("ReadINVByNoEncrypt");
	var myrtn = cspRunServerMethod(encmeth, myReceipNO, myUser);
	var rtn = myrtn.split("^")[0];
	if (rtn != "0") {
		alert(t['06']);
		websys_setfocus('ReceipNO');
		return websys_cancel();
	} else {
		WrtRefundMain(myrtn);
		var myAPIRowID = DHCWebD_GetObjValue("OldAccPayINVRowID");
		//SetACRefPayList(myAPIRowID);
		SetACRefOEOrder(myAPIRowID);
	}
}

function SetACRefundMain() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCACRefund.Main";
	RefundMain = parent.frames["UDHCACRefund_Main"];
	RefundMain.location.href = lnk;
}

function SetACRefPayList(APIRowID) {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCACRefund.PayList&APIRowID=" + APIRowID;
	var PayList = parent.frames["UDHCACRefund_PayList"];
	PayList.location.href = lnk;
}

function SetACRefOEOrder(APIRowID) {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCACRefund.OEOrder&APIRowID=" + APIRowID;
	var ACOEList = parent.frames["UDHCACRefund_OEOrder"];
	ACOEList.location.href = lnk;
}

function SetACRefOrder(ReceipRowid) {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.Order&ReceipRowid=" + ReceipRowid;
	var PayOrdList = parent.frames["udhcOPRefund_Order"];
	PayOrdList.location.href = lnk;
}

function IntDocument() {
	var obj = document.getElementById("RefundPayMode");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}
	DHCWebD_ClearAllListA("RefundPayMode");
	var encmeth = DHCWebD_GetObjValue("PayModeEncrypt");
	var mygLoc = session['LOGON.GROUPID'];
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "RefundPayMode");
	}
}

function WrtRefundMain(AccINVInfo) {
	// Write Info For Main Form
	var myary = AccINVInfo.split("^");
	DHCWebD_SetObjValueB("ReceipNO", myary[1]);
	DHCWebD_SetObjValueB("PatientID", myary[2]);
	DHCWebD_SetObjValueB("PatientName", myary[3]);
	DHCWebD_SetObjValueB("PatientSex", myary[4]);
	DHCWebD_SetObjValueB("INVSum", myary[5]);
	var myBtnFlag = myary[6];
	DHCWebD_SetObjValueB("AccNo", myary[7]);
	DHCWebD_SetObjValueB("AccLeft", myary[8]);
	DHCWebD_SetObjValueB("AccRowID", myary[9]);
	DHCWebD_SetObjValueB("AccStatus", myary[10]);
	DHCWebD_SetObjValueB("AutoFlag", myary[26]);       //14.12.5
	var obj = document.getElementById("RefundPayMode");
	if (obj) {
		var mylen = obj.options.length;
		for (var i = 0; i < mylen; i++) {
			var myval = obj.options[i].value;
			var mypayary = myval.split("^");
			if (myary[11] == mypayary[0]) {
				obj.options.selectedIndex = i;
				break;
			}
		}
	}
	DHCWebD_SetObjValueB("YBPaySum", myary[12]);
	DHCWebD_SetObjValueB("AccStatDesc", myary[13]);
	DHCWebD_SetObjValueB("OldAccPayINVRowID", myary[14]);
	DHCWebD_SetObjValueB("PatSelfPay", myary[16]);
	DHCWebD_SetObjValueB("INSDivDR", myary[17]);
	if (myary.length > 24) {
		m_InsType = myary[24];
	}
	if (myary.length > 25) {
		m_admsource = myary[25];
	}
	DHCWeb_DisBtnA("Abort");
	DHCWeb_DisBtnA("Refund");
	if (myary[15] != "N") {
		DHCWeb_DisBtnA("Abort");
		DHCWeb_DisBtnA("Refund");
		alert(t[myary[15] + "01"]);
		return;
	}
	var myVer = DHCWebD_GetObjValue("DHCVersion");
	//Check Account Status
	if (myary[10] == "F") {
		//foot
		DHCWeb_DisBtnA("Abort");
		DHCWeb_DisBtnA("Refund");
		alert(t["AccFootTip"]);
		return;
	}
	//判断集中打印发票退费是否需要先撤销集中打印发票 add zhli  2017.12.90
	if (myary[27] != "0") {
		DHCWeb_DisBtnA("Abort");
		DHCWeb_DisBtnA("Refund");
		alert("请先撤销集中打印发票再退费");
		return;
	}
	switch (myBtnFlag) {
	case "S":
		var obj = document.getElementById("Refund");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, Refund_OnClick);
		}
		if (myVer == "0") {
			ExeFlag = 0;
		} else {
			ExeFlag = 0;
		}
		break;
	case "P":
		var obj = document.getElementById("Abort");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, Abort_OnClick);
		}
		ExeFlag = 0;
		break;
	default:
		ExeFlag = 1;
		/*
		//+2019-03-25 ZhYW 先去掉不用
		DHCWeb_DisBtnA("Abort");
		DHCWeb_DisBtnA("Refund");
		alert(t['10']);
		*/
	}
}

function EnBtn(myBtnFlag) {
	switch (myBtnFlag) {
	case "S":
		var obj = document.getElementById("Refund");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, Refund_OnClick);
		}
		break;
	case "A":
		var obj = document.getElementById("Abort");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, Abort_OnClick);
		}
		break;
	default:
	}
}

function RefundSaveInfo(RefundFlag) {
	DHCWeb_DisBtnA("Abort");
	DHCWeb_DisBtnA("Refund");
	//add 2012-12-20
	var AccLeft = DHCWebD_GetObjValue("AccLeft");
	var YBPaySum = DHCWebD_GetObjValue("YBPaySum");
	if (eval(AccLeft) < eval(YBPaySum)) {
		var InsuRemain = eval(YBPaySum) - eval(AccLeft);
		alert("请补交医保统筹额" + InsuRemain + ",否则不能退费.");
		return;
	}
	//end
	
	var PrtStr = getOrderstr();
	if (StopOrderstr == "") {
		var myrtn = window.confirm("没有需要退费的医嘱,是否确认过号重打发票?");
		if (!myrtn) {
			return myrtn;
		}
	}
	var rtn = CheckRefund(RefundFlag);
	if (!rtn) {
		alert(t["CheckTip"]);
		EnBtn(RefundFlag);
		return rtn;
	}
	var rtn = CardYBPark();
	if (!rtn) {
		return rtn;
	}
	var myAPIRowID = DHCWebD_GetObjValue("OldAccPayINVRowID");
	var myUser = session['LOGON.USERID'];
	var gloc = session['LOGON.GROUPID'];
	var myUserLocID = session['LOGON.CTLOCID'];
	var mystr = DHCWeb_GetListBoxValue("RefundPayMode");
	var myary = mystr.split("^");
	var myPayModeDR = myary[0];
	var myPayModeCode = myary[1];
	//2015-03-28 Lid 标准版退费支付方式必须是预交金，项目上根据具体情况再修改。
	if (myPayModeCode != "CPP") {
		alert('退费支付方式错误，请核实!(集中打印发票退费时，退费支付方式必须是"预交金")');
		return false;
	}
	var myRefPaySum = DHCWebD_GetObjValue("RefundSum");
	//var myExpStr = "";
	//modify hujunbin 14.12.5
	var AutoFlag = DHCWebD_GetObjValue("AutoFlag");     //14.12.5
	var myExpStr = "^^^^^" + AutoFlag;
	var encmeth = DHCWebD_GetObjValue("SaveParkDataEncrypt");
	if (encmeth != "") {
		var rtnvalue = cspRunServerMethod(encmeth, myAPIRowID, PrtStr, myUser, RefundFlag, gloc, myUserLocID, myPayModeDR, myRefPaySum, m_RebillFlag, myExpStr);
		//alert(rtnvalue);
		var myary = rtnvalue.split(String.fromCharCode(2));
		var rtn = myary[0].split("^");
		if (rtn[0] == '0') {
			//Set CID  for  YB
			DHCWebD_SetObjValueB("CID", myary[2]);
			var mystr = YBInsDiv();
			BillPrintNew(myary[1]);
			var myRefPaySum = DHCWebD_GetObjValue("RefundSum");
			var PayMStr = "";
			var PayMobj = document.getElementById("RefundPayMode");
			if (PayMobj) {
				PayMStr = PayMobj.options[PayMobj.selectedIndex].innerText;
			}
			//start 14.12.5 hujunbin
			var myINVSum = DHCWebD_GetObjValue("INVSum");
			//var myThisRefPaySum = parseFloat(myINVSum) + parseFloat(myRefPaySum);
			var myThisRefPaySum = "";
			var myEncrypt = DHCWebD_GetObjValue("ReadRefSumEncrypt");
			if (myEncrypt != "") {
				myThisRefPaySum = cspRunServerMethod(myEncrypt, myAPIRowID);
			}
			alert("实际退费金额:" + myThisRefPaySum + t["ParkYMB"] + ", 退费方式为" + PayMStr);  //alert  return Money
			//alert("实际退费金额:" + myRefPaySum + t["ParkYMB"] + ", 退费方式为" + PayMStr);
			alert("退费成功");
			return true;
		} else {
			switch (rtn[0]) {
			case 109:
				alert(t['08']);
			default:
				alert(t['09']);
			}
			return false;
		}
	}
}

function BillPrintNew(INVstr) {
	if (PrtXMLName == "") {
		return;
	}
	var INVtmp = INVstr.split("^");
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] == "") {
			continue;
		}
		if (INVtmp[invi] != "") {
			//add 2011-06-16 tangtao 温岭打印两种格式发票
			var datanum = tkMakeServerCall("web.UDHCOPINVPrtData12", "JudgePBDetailsByAccInvRowid", INVtmp[invi], session['LOGON.GROUPDESC']);
			var datanum = eval(datanum);
			if (datanum == 0) {
				alert("发票不存在,不能打印当前发票!");
				return;
			} else {
				PrtXMLName1 = PrtXMLName;
			}
		}
		DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName1);       //重新获取xml信息
		var encmeth = DHCWebD_GetObjValue('ReadINVDataEncrypt');
		var PayMode = DHCWebD_GetObjValue("PayMode");
		var Guser = session['LOGON.USERID'];
		var sUserCode = session["LOGON.USERCODE"];
		var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", PrtXMLName, INVtmp[invi], sUserCode, PayMode, "");
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
}

function CardYBPark() {
	var myINSDivDR = DHCWebD_GetObjValue("INSDivDR");
	if (myINSDivDR == "") {
		return true;
	}
	if ((myINSDivDR != "") && (m_YBConFlag == "0")) {
		alert(t["ReqYBTip"]);   //Require YB Connection
		return false;
	}
	var myrtn = QueryYBsysStrik(myINSDivDR);
	if (myrtn == "0") {
		return true;
	} else {
		alert(t["YBParErr"]);
		return false;
	}
}

function QueryYBsysStrik(myINSDivDR) {
	/*
	if (insuINSUFlag != "Y") {
		alert("No YB Client!");
		return "-1";
	}
	if (insuDLLFlag != "Y") {
		alert("No Intial");
		return "-1";
	}
	if (insudHandle <= 0){
		alert("dHandle="+insudHandle);
		return "-1";
	}
	*/
	var insudHandle = "0";
	var myUser = session['LOGON.USERID'];
	var ExpStr = "^^1";
	var InsuType = m_InsType;
	var CPPFlag = "Y";
	var OutString = InsuOPDivideStrike(insudHandle, myUser, myINSDivDR, m_admsource, InsuType, ExpStr, CPPFlag);
	return OutString;
}

function YBInsDiv() {
	//YB   Decompose
	var myCID = DHCWebD_GetObjValue("CID");
	if (myCID == "") {
		return "";
	}
	var myrtn = QueryYBsys(myCID);
	if (myrtn != "0") {
		alert(t["YBParErr"] + myrtn);
		return t["YBParErr"] + myrtn + ", ";
	}
	var encmeth = DHCWebD_GetObjValue("SaveYBDataEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, myCID, "");
		//alert(myrtn);
		var myvalue = myrtn.split("^");
		if (myvalue[0] != "0") {
			alert(t["YBPMErr"] + myrtn);
			return t["YBPMErr"] + myrtn + ", ";
		} else {
			var myRefundSum = DHCWebD_GetObjValue("RefundSum");
			if (isNaN(myRefundSum)) {
				myRefundSum = 0;
			}
			var myYBPay = myvalue[1];
			if (isNaN(myYBPay)) {
				myYBPay = 0;
			}
			//myRefundSum = parseFloat(myRefundSum) + parseFloat(myYBPay);
			myRefundSum = parseFloat(myRefundSum) - parseFloat(myYBPay);
			myRefundSum = myRefundSum.toFixed(2);
			DHCWebD_SetObjValueB("RefundSum", myRefundSum);
		}
	}
	return "";
}

function QueryYBsys(myCID) {
	/*
	if (insuINSUFlag != "Y"){
		alert("No YB Client!");
		return "-1";
	}
	if (insuDLLFlag != "Y"){
		alert("No Intial");
		return "-1";
	}
	if (insudHandle <= 0){
		alert("dHandle=" + insudHandle);
		return "-1";
	}
	*/
	//StrikeFlag^安全组Dr^InsuNo^CardType^YLLB^DicCode^DicDesc^账户余额^结算来源^待遇类型^账户ID^院区DR！Money^MoneyType
	var StrikeFlag = "N";
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
	var DBConStr = "";    //数据库连接串
	var AccMId= "";
	var LeftAmt = "";
	var MoneyType = "";
	var SelPaymId = "";
	var myExpStrYB = StrikeFlag + "^" + GroupDR + "^" + InsuNo + "^" + CardType + "^" + YLLB + "^" + DicCode + "^" + DicDesc;
	myExpStrYB += "^" + LeftAmt + "^" + ChargeSource + "^"+ DBConStr + "^" + DYLB + "^" + AccMId + "^" + HospDR + "^" + SelPaymId + "!" + LeftAmt + "^" + MoneyType;
	var InsuType = m_InsType;
	var CPPFlag = "Y";
	var OutString = InsuOPDivide(insudHandle, myUser, myCID, m_admsource, InsuType, myExpStrYB, CPPFlag);
	return OutString;
}

function CheckRefund(RefundFlag) {
	var listdoc = parent.frames["UDHCACRefund_OEOrder"].document;
	var objtbl = listdoc.getElementById("tUDHCACRefund_OEOrder");
	var Rows = objtbl.rows.length;
	var rtn = false;
	for (var j = 1; j < Rows; j++) {
		var excobj = listdoc.getElementById('TExcuteflagz' + j);
		var sExcute = DHCWebD_GetCellValue(excobj);
		if (sExcute == 0) {
			AllExecute = 0;
		}
		var TSelect = listdoc.getElementById("Tselectz" + j);
		var selflag = DHCWebD_GetCellValue(TSelect);
		if (TSelect.checked) {
			rtn = true;
		}
	}
	if (ExeFlag == 0) {
		rtn = true;
	}
	return rtn;
}

function getOrderstr() {
	var listdoc = parent.frames["UDHCACRefund_OEOrder"].document;
	StopOrderstr = "";
	var AllExecute = 1;
	var PartRefFlag = 0;
	var ExeFlag = 0;
	m_RefRowIDStr = new Array();
	var myOrdRowIDStr = new Array();
	var myRebillAry = new Array();
	var myRtnPatSum = new Array();
	var objtbl = listdoc.getElementById("tUDHCACRefund_OEOrder");
	var Rows = objtbl.rows.length;
	for (var j = 1; j < Rows; j++) {
		var excobj = listdoc.getElementById('TExcuteflagz' + j);
		var sExcute = DHCWebD_GetCellValue(excobj);
		if (sExcute == 0) {
			AllExecute = 0;
		}
		var TSelect = listdoc.getElementById("Tselectz" + j);
		var selflag = DHCWebD_GetCellValue(TSelect);
		if (TSelect.disabled == true) {
			ExeFlag = 0;
		}
		var ordobj = listdoc.getElementById('TOrderRowidz' + j);
		var sOrderRowid = DHCWebD_GetCellValue(ordobj);
		var qtyObj = listdoc.getElementById('TOrderQtyz' + j);
		var ordqty = DHCWebD_GetCellValue(qtyObj);
		var myobj = listdoc.getElementById('PRTRowIDz' + j);
		var myprtRowID = DHCWebD_GetCellValue(myobj);
		var refqtyObj = listdoc.getElementById('TReturnQtyz' + j);
		var refordqty = DHCWebD_GetCellValue(refqtyObj);
		if (!isNaN(refordqty) && (PartRefFlag == 0)) {
			if (refordqty > 0) {
				PartRefFlag = 1;
			}
		}
		var findflag = false;
		var mylen = m_RefRowIDStr.length;
		for (var myIdx = 0; myIdx < mylen; myIdx++) {
			if (myprtRowID == m_RefRowIDStr[myIdx]) {
				findflag = true;
				break;
			}
		}
		if (!findflag) {
			myIdx = mylen;
			myOrdRowIDStr[myIdx] = new Array();
		}
		m_RefRowIDStr[myIdx] = myprtRowID;
		if (selflag == false) {
			myRebillAry[myIdx] = 1;
			m_RebillFlag = 1;
		}
		if ((selflag == true) && (sExcute == "1") && (ordqty != refordqty)) {
			myRebillAry[myIdx] = 1;
			m_RebillFlag = 1;
		}
		//+2017-07-06 ZhYW 执行数量
		var ExecQtyObj = listdoc.getElementById('TOEORDExecQtyz' + j);
		var ExecQty = DHCWebD_GetCellValue(ExecQtyObj);
		//只有一条部分执行的医嘱退费再收费
		if (ExecQty == "") {
			ExecQty = 0;
		}
		if ((selflag == true) && (ExecQty != "0") && (ordqty != ExecQty)) {
			myRebillAry[myIdx] = 1;
			m_RebillFlag = 1;
		}
		//
		var TSelect = listdoc.getElementById("Tselectz" + j);
		if (TSelect.checked) {
			var myCurlen = myOrdRowIDStr[myIdx].length;
			myOrdRowIDStr[myIdx][myCurlen] = sOrderRowid;
			var obj = listdoc.getElementById('RefSumz' + j);
			var myRefSum = DHCWebD_GetCellValue(obj);
			//+2017-07-06 ZhYW
			var orderSumObj = listdoc.getElementById('TOrderSumz' + j);
			var orderSum = DHCWebD_GetCellValue(orderSumObj);
			if (parseFloat(orderSum) != parseFloat(myRefSum)) {
				myRebillAry[myIdx] = 1;
				m_RebillFlag = 1;
			}
			//
			if (isNaN(myRtnPatSum[myIdx])) {
				myRtnPatSum[myIdx] = parseFloat(myRefSum);
			} else {
				myRtnPatSum[myIdx] = myRtnPatSum[myIdx] + parseFloat(myRefSum);
			}
			if (StopOrderstr == "") {
				StopOrderstr = sOrderRowid;
			} else {
				StopOrderstr = StopOrderstr + "^" + sOrderRowid;
			}
		}
	}
	var mylen = m_RefRowIDStr.length;
	var myary = new Array();
	for (var i = 0; i < mylen; i++) {
		if ((isNaN(myRebillAry[i])) || (myRebillAry[i] == "")) {
			myRebillAry[i] = 0;
		}
		if ((isNaN(myRtnPatSum[i])) || (myRtnPatSum[i] == "")) {
			myRtnPatSum[i] = 0;
		}
		myRtnPatSum[i] = myRtnPatSum[i].toFixed(2);
		myary[i] = m_RefRowIDStr[i] + String.fromCharCode(3) + myOrdRowIDStr[i].join("^");
		myary[i] += String.fromCharCode(3) + myRebillAry[i];
		myary[i] += String.fromCharCode(3) + myRtnPatSum[i];
	}
	var myInfo = myary.join(String.fromCharCode(2));
	return myInfo;
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
}

function ReadCardQuery_OnClick() {
	var myCardTypeValue = combo_CardType.getSelectedValue();
	var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeRowID, myCardTypeValue);
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		//DHCWebD_SetObjValueB("PatientID", myary[5]);
		ReadCardQueryINV(myary[5]);
		break;
	case "-200":
		alert("无效卡");
		break;
	case "-201":
		ReadCardQueryINV(myary[5]);
		break;
	default:
	}
}

function ReadCardQueryINV(PAPMNo) {
	var mygLocDR = session['LOGON.GROUPID'];
	var myULoadLocDR = session['LOGON.CTLOCID'];
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk += "&FramName=UDHCACRefund_main&PatientNO=" + PAPMNo;
	lnk += "&AuditFlag=ALL&sFlag=API&INVStatus=N";
	lnk += "&gLocDR=" + mygLocDR + "&ULoadLocDR=" + myULoadLocDR;
	var openObj = window;   //2018-05-29 ZhYW 解决在使用Modal Dialog的时候，弹出多个页面会导致新页面session丢失，需要重新login
	if (typeof(window.dialogArguments) == "object") {
		openObj = window.dialogArguments;
	}
	var NewWin = openObj.open(lnk, "udhcOPINV_Query", "scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function RePrt_OnClick() {
	var myReceipNO = DHCWebD_GetObjValue("ReceipNO");
	var rtn = window.confirm("是否确认将" + myReceipNO + "发票重新打印?");
	if (!rtn) {
		return;
	}
	var myAPIRowID = DHCWebD_GetObjValue("OldAccPayINVRowID");
	if (myAPIRowID == "") {
		alert("请输入需要打印的发票号并回车");
		return;
	}
	BillPrintNew(myAPIRowID);
}

function DocumentOnKeydown() {
	DHCWeb_EStopSpaceKey();
	var keycode;
	try {
		keycode = websys_getKey(e);
	} catch (e) {
		keycode = websys_getKey();
	}
	if (keycode == 115) {  //F4
		var obj = document.getElementById("ReadCardQuery");
		if (obj) {
			obj.click();
		}
	}
}

//add hujunbin 14.12.5
function LinkInsuPay() {
	var myAPIRowID = DHCWebD_GetObjValue("OldAccPayINVRowID");
	if (myAPIRowID == "") {
		alert("请输入需要补调医保的发票号并回车");
		return;
	}
	var InsuInfo = tkMakeServerCall("web.udhcOPRefEdit1", "BuildInsuTmp", myAPIRowID);
	if (InsuInfo != "") {
		DHCWebD_SetObjValueB("CID", InsuInfo);
		var mystr = YBInsDiv();
	}
}

//add yq 20150803
///添加过号重打功能
function ReNumber_Click() {
	var RepPrintFlag = window.confirm("是否确认作废原发票重打发票?");
	if (!RepPrintFlag) {
		return;
	}
	DHCWeb_DisBtnA("Abort");
	DHCWeb_DisBtnA("Refund");
	//add 2012-12-20
	var AccLeft = DHCWebD_GetObjValue("AccLeft");
	var YBPaySum = DHCWebD_GetObjValue("YBPaySum");
	if (eval(AccLeft) < eval(YBPaySum)) {
		var InsuRemain = eval(YBPaySum) - eval(AccLeft);
		//alert("请补交医保统筹额" + InsuRemain + ",否则不能退费.");
		//return;
	}
	//+2017-09-15 ZhYW
	var ListObj = parent.frames["UDHCACRefund_OEOrder"];
	ListObj.SelectAll(false);
	
	var PrtStr = getOrderstr();
	if (StopOrderstr != "") {
		alert("有需要退费医嘱不能新号重打.");
		return rtn;
	}
	var myReceipNO = DHCWebD_GetObjValue("ReceipNO");
	var myUser = session['LOGON.USERID'];
	var encmeth = DHCWebD_GetObjValue("ReadINVByNoEncrypt");
	var myrtn = cspRunServerMethod(encmeth, myReceipNO, myUser);
	var rtn = myrtn.split("^")[0];
	var RefundFlag = "";
	if (myrtn.split("^")[6] == "P") {
		RefundFlag = "A";
	} else {
		RefundFlag = "S";
	}
	var rtn = CardYBPark();
	if (rtn == false) {
		return rtn;
	}
	var myAPIRowID = DHCWebD_GetObjValue("OldAccPayINVRowID");
	var myUser = session['LOGON.USERID'];
	var gloc = session['LOGON.GROUPID'];
	var myUserLocID = session['LOGON.CTLOCID'];
	var mystr = DHCWeb_GetListBoxValue("RefundPayMode");
	var myary = mystr.split("^");
	var myPayModeDR = myary[0];
	var myPayModeCode = myary[1];
	//2015-03-28 Lid 标准版退费支付方式必须是预交金，项目上根据具体情况再修改。
	if (myPayModeCode != "CPP") {
		alert('退费支付方式错误，请核实!(集中打印发票退费时，退费支付方式必须是"预交金")');
		return false;
	}
	var myRefPaySum = DHCWebD_GetObjValue("RefundSum");
	//var myExpStr = "";
	//modify hujunbin 14.12.5
	var AutoFlag = DHCWebD_GetObjValue("AutoFlag");    //14.12.5
	var myExpStr = "^^^^^" + AutoFlag;
	var encmeth = DHCWebD_GetObjValue("SaveParkDataEncrypt");
	if (encmeth != "") {
		var rtnvalue = cspRunServerMethod(encmeth, myAPIRowID, PrtStr, myUser, RefundFlag, gloc, myUserLocID, myPayModeDR, myRefPaySum, m_RebillFlag, myExpStr);
		var myary = rtnvalue.split(String.fromCharCode(2));
		var rtn = myary[0].split("^");
		if (rtn[0] == '0') {
			//Set CID  for  YB
			DHCWebD_SetObjValueB("CID", myary[2]);
			var mystr = YBInsDiv();
			BillPrintNew(myary[1]);
			var myRefPaySum = DHCWebD_GetObjValue("RefundSum");
			var PayMStr = "";
			var PayMobj = document.getElementById("RefundPayMode");
			if (PayMobj) {
				PayMStr = PayMobj.options[PayMobj.selectedIndex].innerText;
			}
			//start 14.12.5 hujunbin
			var myINVSum = document.getElementById("INVSum").value;
			//var myThisRefPaySum = parseFloat(myINVSum)+parseFloat(myRefPaySum);
			var myThisRefPaySum = "";
			var myEncrypt = DHCWebD_GetObjValue("ReadRefSumEncrypt");
			if (myEncrypt != "") {
				myThisRefPaySum = cspRunServerMethod(myEncrypt, myAPIRowID);
			}
			alert("新号重打成功");
			return true;
		} else {
			switch (rtn[0]) {
			case 109:
				alert(t['08']);
			default:
				alert(t['09']);
			}
			return false;
		}
	}
}

document.body.onload = BodyLoadHandler;