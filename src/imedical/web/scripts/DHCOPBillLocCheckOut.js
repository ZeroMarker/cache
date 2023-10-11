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
	CARDINVALID_ERROR: $g('卡无效'),
	NOACCOUNT_ERROR: $g('此卡无有效账户'),
	CARDNO_NULL: $g('卡号不能为空'),
	READCARD_ERROR: $g('卡验证错误'),
	DIFF_PATIENTID_ERROR: $g('该卡对应的病人和界面上的病人不一致'),
	CARD_ERROR: $g('卡验证错误'),
	LACK_MONEY: $g('账户余额不足'),
	TP_STATUS_ERROR: $g('有异常收费记录，请先撤销后再结算'),
	NO_CHARGE_DATA: $g('无结算数据'),
	AMT_MIS_MATCH: $g('金额不符'),
	PAID_MODE_ERROR: $g('支付方式错误'),
	PARAMETER_ERROR: $g('入参错误'),
	OEORISTRING_ERROR: $g('传入的医嘱串格式错误'),
	OTHER_ERROR: $g('结算错误'),
	COMPLETE_FAILED: $g('确认完成失败'),
	SUCCESS: $g('结算成功'),
	REGFEE_ERROR: $g('挂号医嘱与收费医嘱不能同时结算'),
	PAYMODE_ERROR: $g('未配置的支付方式'),
	MULTHOSP_AUTH: $g('本院未授予结算该患者医嘱权限')
};

/**
 * 结算
 * 参数：
 *	cardNO: 卡号,不能为空
 *	patientID: 登记号Rowid，不能为空
 *	episodeID: 就诊号，可以为空（注：为空时，OeoriIDStr不能为空）
 *	insType：费别，可以为空
 *	oeoriIDStr：结算的医嘱串，可以为空(注：为空时，EpisodeID不能为空)
 *	userId：操作员Rowid，不能为空
 *	groupId：安全组Rowid，不能为空
 *	ctLocId：登录科室Rowid，不能为空
 *	hospId：院区Rowid，可以为空(为空时，根据登录科室取院区)
 */

function checkOut(cardNO, patientID, episodeID, insType, oeoriIDStr, userId, groupId, ctLocId, hospId, callbackFun) {
	var isTP = tkMakeServerCall("web.DHCOPBillChargExcepiton", "CheckTPFlagByEpisodeID", episodeID, "");
	if (isTP == 1) {
		$.messager.alert("提示", MSG.TP_STATUS_ERROR, "info");
		return;
	}
	
	var sessionStr = userId + "^" + groupId + "^" + ctLocId + "^" + hospId;
	var hasAuth = tkMakeServerCall("web.udhcOPBill1", "HasHospChgAuth", episodeID, sessionStr);
	if (hasAuth == 0) {
		$.messager.alert("提示", MSG.MULTHOSP_AUTH, "info");
		return;
	}
	//+2023-03-17 ZhYW 判断安全组是否与结算用户对照，未对照不允许结算
	var footUserId = tkMakeServerCall("web.DHCOPCashier", "GetGrupContFootUser", groupId, hospId);
	if (!(footUserId > 0)) {
		$.messager.alert("提示", "该安全组未对照结算操作员，不能结算，请联系信息中心维护对照", "info");
		return;
	}
	var checkOutInfo = tkMakeServerCall("web.udhcOPBillIF", "GetLocCheckOutInfo", episodeID, insType, oeoriIDStr, sessionStr);
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

	new Promise(function (resolve, reject) {
		//卡校验
		var CardTypeValue = $("#CardBillCardTypeValue").val();
		if (CardTypeValue) {
			var temparr = CardTypeValue.split("^");
			var CardTypeRowId = temparr[0];
			m_CCMRowID = temparr[14];
			m_ReadCardMode = temparr[16];
			DHCACC_CheckMCFPay(patPaySum, cardNO, episodeID, CardTypeRowId, "", resolve);
		} else {
			var retStr = DHCACC_CheckMCFPay3(patPaySum, patientID);
			resolve(retStr);
		}
    }).then(function (retStr) {
	    var tmpList = retStr.split("^");
		var tmpFlag = tmpList[0];
		var accManId = tmpList[1];  //账户RowID

		if (tmpFlag == -206) {
			$.messager.alert("提示", tmpFlag + " : " + MSG.CARD_ERROR, "info");
			return;
		}
		if (tmpFlag == -207) {
			$.messager.alert("提示", tmpFlag + " : " + MSG.DIFF_PATIENTID_ERROR, "info");
			return;
		}
		if (tmpFlag == -205) {
			$.messager.alert("提示", tmpFlag + " : " + MSG.LACK_MONEY + " 差额<font color='red'>" + Number(tmpList[4]).toFixed(2) + "</font>元", "info");
			return;
		}
		if (tmpFlag == -200) {
			$.messager.alert("提示", tmpFlag + " : " + MSG.CARDINVALID_ERROR, "info");
			return;
		}
		if (tmpFlag == -201) {
			$.messager.alert("提示", tmpFlag + " : " + MSG.NOACCOUNT_ERROR, "info");
			return;
		}
		if (tmpFlag != 0) {
			$.messager.alert("提示", tmpFlag + " : " + MSG.READCARD_ERROR, "info");
			return;
		}

		//结算
		var rtnValue = tkMakeServerCall("web.udhcOPBillIF", "OPOEORDBILLINL", papmiId, admIdStr, oeoriIdStr, patPaySum, accManId, sessionStr);
		var myAry = rtnValue.split("^");
		if (myAry[0] != 0) {
			var rtnAry = rtnValue.split(String.fromCharCode(3));
			var errAry = rtnAry[0].split("^");   //错误代码^失败消息
			var msg = $g(String(errAry.slice(1)) || errAry[0]);
			$.messager.alert("提示", $g("预结算失败") + "：" + $g(msg), "error");
			return;
		}
		var myPRTStr = myAry.filter(function (item) {
	        return (item > 0);
	    }).join("^");
		var myPayInfo = buildPayStr(myPRTStr, accManId);
		//门诊收费确认完成		
		var isRequiredInv = "N";
		var fairType = "F";
		var actualMoney = "";
		var changeAmt = "";
		var roundErr = "";
		var chgInsTypeId = "";
		var stayFlag = "";       //留观标识
		var checkOutMode = 1;
		var insuDicCode = "";    //病种编码
		var isDiagPay = 1;       //+2023-03-17 ZhYW 是否诊间消费标识
		
		var myAry = [];
		myAry.push(groupId);             //1
		myAry.push(ctLocId);             //2
		myAry.push(accManId);            //3
		myAry.push(isRequiredInv);       //4
		myAry.push(fairType);            //5
		myAry.push(actualMoney);         //6
		myAry.push(changeAmt);           //7
		myAry.push(roundErr);            //8
		myAry.push(chgInsTypeId);        //9
		myAry.push(ClientIPAddress);     //10
		myAry.push(stayFlag);            //11
		myAry.push(checkOutMode);        //12
		myAry.push(insuDicCode);         //13
		myAry.push(footUserId);          //14
		var expStr = myAry.join("^");

		var rtnValue = tkMakeServerCall("web.DHCBillConsIF", "CompleteCharge", "3", userId, "", myPRTStr, "0", "", expStr, myPayInfo);
		var myAry = rtnValue.split("^");
		if (myAry[0] == 0) {
			var myLeft = tkMakeServerCall("web.UDHCAccManageCLS", "getAccBalance", accManId);  //取账户余额  add zhangli  17.7.26
			var msg = $g(MSG.SUCCESS) + "，" + $g("本次消费") + "<font style=\"color:red\">" + patPaySum + "</font>" + $g("元") + "，" + $g("余额") + "<font style=\"color:red\">" + myLeft + "</font>" + $g("元");
			$.messager.alert("提示", msg, "success", function() {
				if (callbackFun) callbackFun();
				BillPrintTaskListNew(myPRTStr);
			});
			return;
		}
		var msg = $g(String(myAry.slice(1)) || myAry[0]);
		$.messager.alert("提示", $g("确认完成失败") + ": " + $g(msg), "error");
    });
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
	var myTaskList = $("#ReadPrtList").val();
	var myary = myTaskList ? myTaskList.split(String.fromCharCode(1)) : "N";
	if (myary[0] == "Y") {
		BillPrintTaskList(myary[1], INVstr);
		PrtXMLName = myOldXmlName;
		DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName);  //INVPrtFlag
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
			var myPreDep = "";
			var myCharge = "";
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
	var payMCode = "CPP";
	var payMInfo = tkMakeServerCall("web.DHCBillCommon", "GetPayModeByCode", payMCode);
	var paymode = payMInfo.split("^")[0];
	var myPayCard = accMRowId;
	var patUnit = "";
	var myBankDR = "";
	var myCheckNo = "";
	var myChequeDate = "";
	var myPayAccNo = "";
	var myPayMAmt = "";
	
	var mySelfPayAmt = getPatSelfPayAmt(prtRowIdStr);
	var myInvRoundErrDetails = "";  //发票分币误差明细
	var actualMoney = "";   //实收
	var backChange = "";    //找零
	
	var payStr = paymode + "^" + myBankDR + "^" + myCheckNo + "^" + myPayCard + "^" + patUnit + "^" + myChequeDate + "^" + myPayAccNo + "^" + mySelfPayAmt + "^" + myInvRoundErrDetails + "^" + actualMoney + "^" + backChange ;
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