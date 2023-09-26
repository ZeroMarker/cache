///	DHCBillPayScanCodeService.js

/**
 * [createScanCodePay 创建扫码付订单]
 * @param {[String]} tradeType    [业务类型]
 * @param {[String]} payMode 		[支付方式]
 * @param {[String]} tradeAmt     [金额]
 * @param {[String]} expStr       [扩展串(科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)^原订单ID^收退标志(C收D退))]
 */
function createScanCodePay(tradeType, payMode, tradeAmt, scanCode, expStr) {
	var buildRtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "CreateScanCodePay", tradeType, payMode, tradeAmt, scanCode, expStr);
	return buildRtn;
}

/**
 * [commitScanCodePay 提交扫码支付]
 * @param {[String]} ETPRowID    [订单ID]
 * @param {[String]} scanCode    [手机支付码]
 */
function commitScanCodePay(ETPRowID, scanCode) {
	var payRtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "CommitScanCodePay", ETPRowID, scanCode);
	return payRtn;
}

/**
 * [verifyScanCodePayStatus 查询订单状态]
 * @param {[String]} ETPRowID    [订单ID]
 * @param {[String]} scanCode    [手机支付码]
 */
function verifyScanCodePayStatus(ETPRowID, ScanCode) {
	var payRtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "VerifyScanCodePayStatus", ETPRowID, ScanCode);
	return payRtn
}

/**
 * [cancelScanCodePay 订单关闭]
 * @param {[String]} ETPRowID    [订单ID]
 * @param {[String]} scanCode 	[手机支付码]
 */
function cancelScanCodePay(ETPRowID, ScanCode) {
	var payRtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "CancelScanCodePay", ETPRowID, ScanCode);
	return payRtn;
}

/**
 * [refundScanCodePay 退费接口]
 * @param {[String]} TradeType    [业务类型]
 * @param {[String]} ReceipRowID 	[原业务ID]
 * @param {[String]} RefundAmt    [退款金额]
 * @param {[String]} OriginalType [原业务类型]
 * @param {[String]} OriginalID   [原订单ID]
 * @param {[String]} ExpStr 	    [扩展串(科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)^原订单ID^收退标志(C收D退))]
 */
function refundScanCodePay(TradeType, RefundAmt, OriginalID, ExpStr) {
	var rtnValue = {
		rtnCode: "-2001",
		rtnMsg: "接口退费失败"
	};
	var RefRtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "RefundScanCodePay", TradeType, RefundAmt, OriginalID, ExpStr);
	var rtn = RefRtn.split('^')[0];
	switch (rtn) {
	case "00":
		rtnValue.rtnCode = "0";
		rtnValue.rtnMsg = "接口退费成功";
		if (RefRtn.split('^')[1] != "0") {
			//保存数据失败返回1
			rtnValue.rtnCode = "1";
			rtnValue.rtnMsg = "接口退费成功,保存订单数据失败";
		}
		break;
	case "100":
		rtnValue.rtnCode = "-2002";
		rtnValue.rtnMsg = "程序异常,接口退费失败"; //返回描述
		break;
	case "200":
		rtnValue.rtnCode = "-2003";
		rtnValue.rtnMsg = "接口调用异常,接口退费失败"; //返回描述
		break;
	case "300":
		rtnValue.rtnCode = "-2004";
		rtnValue.rtnMsg = "支付方式未配置Adapter类,接口退费失败"; //返回描述
		break;
	default:
		rtnValue.rtnMsg = "-2005";
		rtnValue.rtnMsg = "接口退费失败:" + rtn;   //返回描述
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
		rtnCode: "-3001",
		rtnMsg: "订单冲销失败"
	};
	var RefRtn = tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic", "CorrectScanCodePay", ETPRowID, ExpStr);
	var rtn = RefRtn.split('^')[0];
	switch (rtn) {
	case "00":
		rtnValue.rtnCode = "0";
		rtnValue.rtnMsg = "订单冲销成功";
		if (RefRtn.split('^')[1] != "0") {
			//保存数据失败返回1
			rtnValue.rtnCode = "1";
			rtnValue.rtnMsg = "订单冲销成功,保存订单数据失败";
		}
		break;
	case "100":
		rtnValue.rtnCode = "-3002";
		rtnValue.rtnMsg = "程序异常,订单冲销失败"; //返回描述
		break;
	case "200":
		rtnValue.rtnCode = "-3003";
		rtnValue.rtnMsg = "接口调用异常,订单冲销失败"; //返回描述
		break;
	case "300":
		rtnValue.rtnCode = "-3004";
		rtnValue.rtnMsg = "支付方式未配置Adapter类,订单冲销失败"; //返回描述
		break;
	default:
		rtnValue.rtnMsg = "-3005";
		rtnValue.rtnMsg = "订单冲销失败:" + rtn; //返回描述
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
	var payRtn=tkMakeServerCall("DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic","ScanOrderConHIS",ETPRowID,HisPrtStr);
	return  payRtn;
}
*/
