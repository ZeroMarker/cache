/**
 *fileName:	DHCOPBillLocCheckOut.js
 *autor:	Lid
 *date:		2014-04-11
 *desc:		科室直接结算业务，供诊间、医技科室、药房等科室调用
 *使用：
 *	1.组件上添加隐藏元素，如果存在就不用添加了
 *		GroupConfigInfo 隐藏 valueget:s val=##class(web.UDHCOPGSConfig).ReadCFByGRowID(%session.Get("LOGON.GROUPID"))
 *		ReadPrtList 隐藏 valueget:s val=##class(web.UDHCOPGSPTEdit).GetPrtListByGRowID(%session.Get("LOGON.GROUPID"),"CP")
 *		getSendtoPrintinfo 隐藏 valueget:s val=##class(%CSP.Page).Encrypt($lb("web.UDHCOPINVPrtIF.GetOPPrtData"))
 * 		DHCBillPrint 隐藏 CUSTOM custom expression：d ##class(web.DHCBillPrint).InvBillPrintCLSID()
 *		InvPrintEncrypt 隐藏 valueget：s val=##class(%CSP.Page).Encrypt($lb("web.DHCXMLIO.ReadXML"))
 *		CardBillCardTypeValue 隐藏 valueget:s val=##class(web.UDHCOPOtherLB).getDefaultCardType()
 *		ReadCommOPDataEncrypt 隐藏 valueget:s val=##class(%CSP.Page).Encrypt($lb("web.UDHCOPINVPrtIF.GetOPCommPrtData"))
 *
 */
/**
 *打印模版
 */
var PrtXMLName = "";
				
/**
 *提示消息
 */
var MSG = {
	CARDINVALID_ERROR: '卡无效',
	NOACCOUNT_ERROR: '此卡无有效账户',
	CARDNO_NULL: '卡号不能为空.',
	READCARD_ERROR: '卡验证错误!',
	DIFF_PATIENTID_ERROR: '该卡对应的病人和界面上的病人不一致',
	CARD_ERROR: '卡验证错误.',
	LACK_MONEY: '账户余额不足.',
	TP_STATUS_ERROR: '有预结算异常数据,请先处理.',
	NO_CHARGE_DATA: '无结算数据.',
	AMT_MIS_MATCH: '金额不符',
	PAID_MODE_ERROR: '支付方式错误.',
	PARAMETER_ERROR: '入参错误.',
	OEORISTRING_ERROR: '传入的医嘱串格式错误.',
	OTHER_ERROR: '结算错误.',
	COMPLETE_FAILED: '确认完成失败.',
	SUCCESS: '结算成功.',
	REGFEE_ERROR: '挂号医嘱与收费医嘱不能同时结算',
	EXSIT_TP_DATA: '有预结算记录，请先撤销后再结算'
};

/**
 *结算
 *参数：
 *	cardNO:卡号,不能为空
 *	patientID:登记号Rowid，不能为空
 *	episodeID:就诊号，可以为空（注：为空时，OeoriIDStr不能为空）
 *	insType：费别，可以为空
 *	oeoriIDStr：结算的医嘱串，可以为空(注：为空时，EpisodeID不能为空)
 *	guser：操作员Rowid，不能为空
 *	groupDR：安全组Rowid，不能为空
 *	locDR：登录科室Rowid，不能为空
 *	hospDR：院区Rowid，可以为空(为空时，根据登录科室取院区)
 */

function checkOut(cardNO, patientID, episodeID, insType, oeoriIDStr, guser, groupDR, locDR, hospDR) {
	var checkOutInfoExpStr = guser + "^" + locDR + "^" + groupDR + "^" + hospDR;
	
	var isTP = tkMakeServerCall("web.DHCOPBillChargExcepiton", "CheckTPFlagByEpisodeID", episodeID, "");
	if (isTP == 1){
		$.messager.alert("提示", MSG.EXSIT_TP_DATA, "info");
		return;
	}
	
	var checkOutInfo = tkMakeServerCall("web.udhcOPBillIF", "GetLocCheckOutInfo", episodeID, insType, oeoriIDStr, checkOutInfoExpStr);
	var tmpList = checkOutInfo.split("!");
	if (tmpList.length < 4) {
		$.messager.alert("提示", MSG.NO_CHARGE_DATA, "info");
		return;
	}
	var patPaySum = tmpList[0];
	var oeoriIdStr = tmpList[1];
	var admIdStr = tmpList[2];
	var papmiId = tmpList[3];
	if (oeoriIdStr == "") {
		$.messager.alert("提示", MSG.NO_CHARGE_DATA, "info");
		return;
	}
	//卡校验
	var obj = document.getElementById("CardBillCardTypeValue");
	if (obj) {
		var CardTypeValue = obj.value;
		var temparr = CardTypeValue.split("^");
		var CardTypeRowId = temparr[0];
		m_CCMRowID = temparr[14];
		m_ReadCardMode = temparr[16];
		var retStr = DHCACC_CheckMCFPay(patPaySum, cardNO, episodeID, CardTypeRowId);
	} else {
		var retStr = DHCACC_CheckMCFPay3(patPaySum, patientID);
	}

	tmpList = retStr.split("^");
	var tmpFlag = tmpList[0];
	var accManId = tmpList[1];  //账户RowID

	if (tmpFlag == "-206") {
		$.messager.alert("提示", tmpFlag + " : " + MSG.CARD_ERROR, "info");
		return;
	}
	if (tmpFlag == "-207") {
		$.messager.alert("提示", tmpFlag + " : " + MSG.DIFF_PATIENTID_ERROR, "info");
		return;
	}
	if (tmpFlag == "-205") {
		var myBalance = tmpList[4];
		$.messager.alert("提示", tmpFlag + " : " + MSG.LACK_MONEY + " 差额<font color='red'>" + myBalance + "</font>元", "info");
		return;
	}
	if (tmpFlag == "-200") {
		$.messager.alert("提示", tmpFlag + " : " + MSG.CARDINVALID_ERROR, "info");
		return;
	}
	if (tmpFlag == "-201") {
		$.messager.alert("提示", tmpFlag + " : " + MSG.NOACCOUNT_ERROR, "info");
		return;
	}
	if (tmpFlag != "0") {
		$.messager.alert("提示", tmpFlag + " : " + MSG.READCARD_ERROR, "info");
		return;
	}

	//结算
	var expStr = "";
	var retStr = tkMakeServerCall("web.udhcOPBillIF", "OPOEORDBILLINL", papmiId, admIdStr, oeoriIdStr, patPaySum, guser, groupDR, locDR, accManId, expStr);
	tmpList = retStr.split(String.fromCharCode(2));

	var err = tmpList[0];
	if (tmpList.length > 1) {
		if (err == "101") {
			$.messager.alert("提示", "(" + err + ")" + MSG.NO_CHARGE_DATA, "error");
			return;
		}
		if (err == "102") {
			$.messager.alert("提示", "(" + err + ")" + MSG.AMT_MIS_MATCH, "error");
			return;
		}
		if (err == "105") {
			$.messager.alert("提示", "(" + err + ")" + MSG.PAID_MODE_ERROR, "error");
			return;
		}
		if (err == "120") {
			$.messager.alert("提示", "(" + err + ")" + MSG.TP_STATUS_ERROR, "error");
			return;
		}
		if (err == "2620") {
			$.messager.alert("提示", "(" + err + ")" + MSG.PARAMETER_ERROR, "error");
			return;
		}
		if (err == "2621") {
			$.messager.alert("提示", "(" + err + ")" + MSG.OEORISTRING_ERROR, "error");
			return;
		}
		if (err == "130") {
			$.messager.alert("提示", "(" + err + ")" + MSG.REGFEE_ERROR, "error");
			return;
		}
		if (err != 0) {
			$.messager.alert("提示", "(" + err + ")" + MSG.OTHER_ERROR, "error");
			return;
		}
		
		if (tmpList[0] == "0") {
			var myPRTStr = tmpList[1];
	
			var myPayInfo = buildPayStr(myPRTStr,accManId);
			
			//门诊收费确认完成
			var compExpStr = groupDR + "^" + locDR + "^" + accManId + "^N^F^^^^^";
			var rtn = tkMakeServerCall("web.DHCBillConsIF", "CompleteCharge", "8", guser, "", myPRTStr, "0", "", compExpStr,myPayInfo);
			if (rtn != "0") {
				$.messager.alert("提示", MSG.COMPLETE_FAILED, "error");
				return;
			}else {
				var myLeft = tkMakeServerCall("web.UDHCAccManageCLS", "getAccBalance", accManId);  //取账户余额  add zhangli  17.7.26
				var msg = MSG.SUCCESS + " 本次消费<font style='color:red'>" + patPaySum + "</font>元，余额<font style='color:red'>" + myLeft + "</font>元";
				$.messager.alert("提示", msg, "success");
				BillPrintTaskListNew(tmpList[1]);
			}
		}
	}
}

function BillPrintTaskListNew(INVstr) {
	var obj = document.getElementById("GroupConfigInfo");
	if (obj) {
		var myGruopConfigInfo = obj.value;
		var myary = myGruopConfigInfo.split("^");
		if (myary[0] == 0) {
			var myPrtXMLName = myary[10];
			PrtXMLName = myPrtXMLName;
			DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName);
		}
	}

	var myOldXmlName = PrtXMLName;
	var myTaskList = "";
	var obj = document.getElementById("ReadPrtList");
	if (obj) {
		myTaskList = obj.value;
	}
	var myary = myTaskList.split(String.fromCharCode(1));
	if (myary[0] == "Y") {
		BillPrintTaskList(myary[1], INVstr);
		PrtXMLName = myOldXmlName;
		DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName); //INVPrtFlag
	} else {
		//BillPrintNew(INVstr);
	}
	PrtXMLName = myOldXmlName;
}

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
					DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName);    //INVPrtFlag
					CommBillPrintNew(INVstr, myClassName, myMethodName);
				}
			} else if ((myStrAry[3] == "BC")) {
				OtherPrintDevice(INVstr, myClassName, myMethodName, myPrintDeviceDR);
			}
		}
	}
}

function OtherPrintDevice(INVstr, ClassName, MethodName, PrintDeviceDR) {
	var myExpStr = "";
	var encmeth = $("#ReadOPDataOtherDeviceEncrypt").val();
	if (encmeth != "") {
		var Printinfo = cspRunServerMethod(encmeth, "DHCWCOM_OtherPrintDeviceEquip", ClassName, MethodName, PrintDeviceDR, INVstr, myExpStr);
	}
}

function CommBillPrintNew(INVstr, ClassName, MethodName) {
	var INVtmp = INVstr.split("^");
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = $("#ReadCommOPDataEncrypt").val();
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
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = $("#getSendtoPrintinfo").val();
			var PayMode = "";
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myExpStr = "";
			var myPreDep = $("#Actualmoney").val();
			var myCharge = $("#Change").val();
			var myCurGroupDR = session['LOGON.GROUPID'];
			var myExpStr = myPreDep + "^" + myCharge + "^" + myCurGroupDR;
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", PrtXMLName, INVtmp[invi], sUserCode, PayMode, myExpStr);
		}
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, TxtInfo, ListInfo);
}

function buildPayStr(prtRowIdStr, accMRowId) {
	var payStr = "";
	var payMCode = "CPP";
	var payMInfo = tkMakeServerCall("web.DHCBillCommon", "GetPayModeByCode", payMCode);
	var paymode = payMInfo.split("^")[0];
	var myPayCard = accMRowId;
	var patUnit = ""
	var myBankDR = ""
	var myCheckNo = "";
	var myChequeDate = "";
	var myPayAccNo = "";
	var myPayMAmt = "";
	
	var mySelfPayAmt = getPatSelfPayAmt(prtRowIdStr);
	var myInvRoundErrDetails = "";  //发票分币误差明细
	var actualMoney = "";   //实收
	var backChange = "";    //找零
	
	payStr = paymode + "^" + myBankDR + "^" + myCheckNo + "^" + myPayCard + "^" + patUnit + "^" + myChequeDate + "^" + myPayAccNo + "^" + mySelfPayAmt + "^" + myInvRoundErrDetails + "^" + actualMoney + "^" + backChange ;
	payStr = payStr.replace(/undefined/g, "");    //替换所有的undefined

	return payStr;
}

/**
* 2020-06-08
* Lid
* 获取患者自费金额
*/
function getPatSelfPayAmt(prtRowIdStr){
	var patSelfPayAmt = tkMakeServerCall("web.DHCBillConsIF", "GetPatSelfPayAmt", prtRowIdStr);
	return patSelfPayAmt;
}

/**
* 2020-06-08
* Lid
* 计算分币误差
*/
function calcInvPayMAmtRound(prtRowIdStr, payAmt){
	var invRoundInfo = tkMakeServerCall("web.DHCBillConsIF", "GetManyInvRoundErrAmt", prtRowIdStr, payAmt);
	return invRoundInfo;
}