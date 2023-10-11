///	DHCBillPayScanCodeService.js

/**
 * [createScanCodePay 创建扫码付订单]
 * @param {[String]} tradeType    [业务类型]
 * @param {[String]} payMode 	  [支付方式]
 * @param {[String]} tradeAmt     [金额]
 * @param {[String]} expStr       [扩展串(科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)^原订单ID^收退标志(C收D退))]
 */
function createScanCodePay(tradeType, payMode, tradeAmt, scanCode, expStr) {
	var rtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "CreateScanCodePay", tradeType, payMode, tradeAmt, scanCode, expStr);
	return rtn;
}

/**
 * [commitScanCodePay 提交扫码支付]
 * @param {[String]} ETPRowID    [订单ID]
 * @param {[String]} scanCode    [手机支付码]
 */
function commitScanCodePay(ETPRowID, scanCode) {
	var rtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "CommitScanCodePay", ETPRowID, scanCode);
	return rtn;
}

/**
 * [verifyScanCodePayStatus 查询订单状态]
 * @param {[String]} ETPRowID    [订单ID]
 * @param {[String]} scanCode    [手机支付码]
 */
function verifyScanCodePayStatus(ETPRowID, ScanCode) {
	var rtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "VerifyScanCodePayStatus", ETPRowID, ScanCode);
	return rtn;
}

/**
 * [cancelScanCodePay 订单关闭]
 * @param {[String]} ETPRowID    [订单ID]
 * @param {[String]} scanCode 	[手机支付码]
 */
function cancelScanCodePay(ETPRowID, ScanCode) {
	var rtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "CancelScanCodePay", ETPRowID, ScanCode);
	return rtn;
}

/**
 * [refundScanCodePay 退费接口]
 * @param {[String]} TradeType    [业务类型]
 * @param {[String]} OrgETPRowID  [原订单ID]
 * @param {[String]} RefundAmt    [退款金额]
 * @param {[String]} ExpStr 	  [扩展串(科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)^原订单ID^收退标志(C收D退))]
 */
function refundScanCodePay(TradeType, OrgETPRowID, RefundAmt, ExpStr) {
	var rtnValue = {
		ResultCode: -2001,
		ResultMsg: "接口退费失败"
	};
	var rtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "RefundScanCodePay", TradeType, OrgETPRowID, RefundAmt, ExpStr);
	var myAry = rtn.split("^");
	switch (myAry[0]) {
	case "00":
		var code = 0;
		var msg = "接口退费成功";
		if (myAry[1] != 0) {
			//保存数据失败返回1
			code = 1;
			msg = "接口退费成功，保存订单数据失败";
		}
		rtnValue.ResultCode = code;
		rtnValue.ResultMsg = msg;
		break;
	default:
		rtnValue.ResultCode = -2002;
		rtnValue.ResultMsg = myAry[1] || "接口退费失败";   //返回描述
	}
	return rtnValue;
}

/**
 * [correctScanCodePay 冲销接口]
 * @param {[String]} ETPRowID   [订单ID]
 * @param {[String]} ExpStr 	[扩展串(科室^安全组^院区^操作员ID)]
 */
function correctScanCodePay(ETPRowID, ExpStr) {
	var rtnValue = {
		ResultCode: -3001,
		ResultMsg: "订单冲销失败"
	};
	var rtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "CorrectScanCodePay", ETPRowID, ExpStr);
	var myAry = rtn.split("^");
	switch (myAry[0]) {
	case "00":
		var code = 0;
		var msg = "订单冲销成功";
		if (myAry[1] != 0) {
			//保存数据失败返回1
			code = 1;
			msg = "订单冲销成功，保存订单数据失败";
		}
		rtnValue.ResultCode = code;
		rtnValue.ResultMsg = msg;
		break;
	default:
		rtnValue.ResultCode = -3002;
		rtnValue.ResultMsg = myAry[1] || "订单冲销失败"; //返回描述
	}
	return rtnValue;
}

/**
 * [linkBussinssToNO 订单关联业务]
 * @param {[String]} ETPRowID    [订单ID]
 * @param {[String]} HisPrtStr   [业务ID]
 */
/*
function scanOrderConHIS(ETPRowID, HisPrtStr) {
	var rtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "ScanOrderConHIS", ETPRowID, HisPrtStr);
	return rtn;
}
*/