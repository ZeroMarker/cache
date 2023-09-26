/**
 * 体检第三方支付服务  DHCPEPayService.js
 * @Author   wangguoying
 * @DateTime 2019-12-27
 */


/**
 * 备注：第三方支付方式包含互联网组扫码付  ^DHCPESetting("DHCPE","ExtPayModeCode")="^MISPOS^SMF^"
 * 	 互联网组扫码付 ^DHCPESetting("DHCPE","DHCScanCode")="^SMF^"
 */


/**
 * [pePayRtn 返回对象]
 * ResultCode：结果代码				
 * 				-100：医保结算失败
 * 				-200：结算失败，发票未回滚，需要信息科处理
 * 				-300：第三方结算失败
 * 				-400:程序异常
 * 				-500:退费失败
 * ResultMsg：描述
 * ETPRowID：计费组的交易订单ID
 * PEBarCodePayStr：互联网交易信息
 * ExpStr:返回的扩展信息  如医保结算需返回  医保ID^自费金额
 */
var pePayRtn = {
	ResultCode: "0",
	ResultMsg: "",
	ETPRowID: "",
	PEBarCodePayStr: "",
	ExpStr: ""
};


/**
 * [医保结算]
 * @param    {[int]}    invprt    [体检发票Id]
 * @param    {[float]}    amount    [金额]
 * @param    {[int]}    userId    [用户ID]
 * @param    {[int]}    AdmSorce [Pac_admreason.rea_AdmSource]
 * @param    {[int]}    admReason [Pac_admreason.Rowid]
 * @return   {object}    pePayRtn
 * @Author   wangguoying
 * @DateTime 2019-12-27
 */
function insurancePay(invprt, amount, userId, AdmSorce, AdmReason) {
	pePayRtn = {
		ResultCode: "0",
		ResultMsg: "",
		ETPRowID: "",
		PEBarCodePayStr: "",
		ExpStr: ""
	};

	var StrikeFlag = "N";
	var GroupID = session['LOGON.GROUPID'];
	var HOSPID=session['LOGON.HOSPID'];
	var InsuNo = ""; //医保个人编号、医保卡号、医保号的加密串 供磁卡的地方用 
	var CardType = ""; //有无医保卡
	var YLLB = getValueById("YLLB"); //医疗类别（普通门诊、门诊特病、门诊工伤、门诊生育）
	var DicCode = ""; //病种代码
	var DicDesc = "";
	var BillSource = "01"; //结算来源
	var Type = "";
	var MoneyType = "";
	var TJPayMode=$("#PayMode").combogrid("getValue");
	
	var ExpStr = StrikeFlag + "^" + GroupID + "^" + InsuNo + "^" + CardType + "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + amount + "^" + BillSource + "^" + Type +"^^"+"^"+HOSPID+"^"+TJPayMode+ "!" + amount + "^" + MoneyType
	
	try {
		//var ret = InsuPEDivide("0", userId, invprt, AdmSorce, AdmReason, ExpStr, "N"); //医保组函数  DHCInsuPort.js
		var ret = InsuPEDivide("0", userId, invprt, AdmSorce, AdmReason, ExpStr, "NotCPPFlag"); //医保组函数 DHCInsuPort.js
		var InsuArr = ret.split("^");
		var ret = InsuArr[0];
		if ((ret == "-3") || (ret == "-4")) { //失败
			//回滚刚收费的发票


			var Return = tkMakeServerCall("web.DHCPE.DHCPEBillCharge", "CancelCashie", invprt, userId);
			if (Return == "") {
				pePayRtn.ResultCode = -100;
				pePayRtn.ResultMsg = "医保结算失败";
				return pePayRtn;
			} else {
				pePayRtn.ResultCode = -200;
				pePayRtn.ResultMsg = "回滚失败，请联系信息科：" + Return;
				return pePayRtn;
			}

		} else if (ret == "-1") {
			if (parent.parent.ALertWin) parent.parent.ALertWin.SetIAmount(amount);
			pePayRtn.ExpStr = "^" + amount;
			alert("医保结算失败,本次收费为全自费");
		} else {
			if (parent.parent.ALertWin) parent.parent.ALertWin.SetIAmount(InsuArr[2]);
			pePayRtn.ExpStr = InsuArr[1] + "^" + amount;
			alert("医保结算成功,病人自费金额为:" + InsuArr[2]);
		}
	} catch (e) {
		pePayRtn.ResultCode = -404;
		pePayRtn.ResultMsg = "调用医保失败^" + e.message;
		return pePayRtn;
	}
	return pePayRtn;
}

/**
 * [第三方支付]
 * @param    {[int]}    invprt    [发票Id]
 * @param    {[int]}    userId    [用户id]
 * @param    {[int]}    InsuID    [医保结算id]
 * @param    {[int]}    AdmSorce [Pac_admreason.rea_AdmSource]
 * @param    {[int]}    admReason [Pac_admreason.Rowid]
 * @return   {object}    pePayRtn
 * @Author   wangguoying
 * @DateTime 2019-12-27
 */
function extPay(invprt, userId, InsuID, AdmSorce, admReason) {
	pePayRtn = {
		ResultCode: "0",
		ResultMsg: "",
		ETPRowID: "",
		PEBarCodePayStr: "",
		ExpStr: ""
	};
	var payInfo = tkMakeServerCall("web.DHCPE.CashierEx", "GetPayInfoByPayCode", invprt); //验证是否需要第三方支付
	if (payInfo == "") {
		return pePayRtn;
	}
	var char1 = String.fromCharCode(1)
	var baseInfo = payInfo.split(char1)[1];
	var patId = baseInfo.split("^")[0];
	var paadm = baseInfo.split("^")[1];
	var scanFlag = baseInfo.split("^")[2];
	if (scanFlag == "1") {
		return scancodePay(payInfo, invprt, userId, InsuID, AdmSorce, admReason);
	}
	var payInfo = payInfo.split(char1)[0];
	var payArr = payInfo.split("^");
	var payDR = payArr[0];
	var payCode = payArr[1];
	var payAmt = payArr[2];

	if (parseFloat(payAmt) <= 0) {
		return pePayRtn;
	}
	//科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)
	var expStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] + "^" + patId + "^" + paadm + "^^C^" + invprt;
	var PayCenterRtn = PayService("PE", payDR, payAmt, expStr);
	if (PayCenterRtn.ResultCode != "0") {
		return cancelExtCashier(PayCenterRtn.ResultMsg, invprt, userId, InsuID, AdmSorce, admReason);
	} else {
		pePayRtn.ETPRowID = PayCenterRtn.ETPRowID;
		//记录下计费订单ID，后边正式结算失败或关联订单失败时，可以根据发票取到订单ID再到异常处理界面进行手工关联
		var relate = tkMakeServerCall("web.DHCPE.CashierEx", "SetRelationTrade", invprt, PayCenterRtn.ETPRowID);
	}
	return pePayRtn;
}

/**
 * [互联网扫码付]
 * @param    {[String]}    payInfo   [支付信息]
 * @param    {[int]}    invprt    [发票Id]
 * @param    {[int]}    userId    [用户id]
 * @param    {[int]}    InsuID    [医保结算id]
 * @param    {[int]}    AdmSorce [Pac_admreason.rea_AdmSource]
 * @param    {[int]}    admReason [Pac_admreason.Rowid]
 * @return   {object}    pePayRtn
 * @Author   wangguoying
 * @DateTime 2020-01-09
 */
function scancodePay(payInfo, invprt, userId, InsuID, AdmSorce, admReason) {
	pePayRtn = {
		ResultCode: "0",
		ResultMsg: "",
		ETPRowID: "",
		PEBarCodePayStr: "",
		ExpStr: ""
	};
	var char1 = String.fromCharCode(1)
	var baseInfo = payInfo.split(char1)[1];
	var patId = baseInfo.split("^")[0];
	var paadm = baseInfo.split("^")[1];
	var scanFlag = baseInfo.split("^")[2];
	if (scanFlag != "1") {
		return pePayRtn;
	}
	var payInfo = payInfo.split(char1)[0];
	var payArr = payInfo.split("^");
	var payDR = payArr[0];
	var payCode = payArr[1];
	var payAmt = payArr[2];
	if (parseFloat(payAmt) <= 0) {
		return pePayRtn;
	}

	var groupId = session['LOGON.GROUPID'];
	var locId = session['LOGON.CTLOCID'];
	var expStr = userId + "^" + groupId + "^" + locId + "^" + session['LOGON.HOSPID'];
	var str = "dhcbarcodepay.csp";
	var payBarCode = window.showModalDialog(str, "", 'dialogWidth:300px;dialogHeight:150px;resizable:yes'); //HTML样式的模态对话框
	if ((payBarCode == "") || (payBarCode == "undefind")) {
		return cancelExtCashier("未扫码", invprt, userId, InsuID, AdmSorce, admReason);
	}
	var PEBarCodePayStr = tkMakeServerCall("MHC.BarCodePay", "PEBarCodePay", paadm, payBarCode, invprt, payAmt, payCode, expStr);
	var rtnAry = PEBarCodePayStr.split("^");
	if (rtnAry[0] != 0) {
		return cancelExtCashier("互联网支付失败", invprt, userId, InsuID, AdmSorce, admReason);
	} else {
		pePayRtn.PEBarCodePayStr = PEBarCodePayStr;
	}
	return pePayRtn;
}



/**
 * [撤销预结算 支付失败时调用]
 * @param    {[String]}    msg       [提示信息]
 * @param    {[int]}    userId    [用户id]
 * @param    {[int]}    InsuID    [医保结算id]
 * @param    {[int]}    AdmSorce [Pac_admreason.rea_AdmSource]
 * @param    {[int]}    admReason [Pac_admreason.Rowid]
 * @return   {object}    pePayRtn
 * @Author   wangguoying
 * @DateTime 2020-01-09
 */
function cancelExtCashier(msg, invprt, userId, InsuID, AdmSorce, AdmReason) {
	pePayRtn = {
		ResultCode: "-300",
		ResultMsg: "第三方支付失败:" + msg,
		ETPRowID: "",
		PEBarCodePayStr: "",
		ExpStr: ""
	};
	var Return = tkMakeServerCall("web.DHCPE.DHCPEBillCharge", "CancelCashie", invprt, userId);
	if (Return != "") {
		pePayRtn.ResultCode = -200;
		pePayRtn.ResultMsg = "第三方支付失败,发票未回滚，请联系信息科：" + Return;
	}
	//如果医保成功，撤销医保结算
	if (InsuID != "") {
		var insuStr = ""
		try {
			var insuRet = InsuPEDivideStrike("0", userId, InsuID, AdmSorce, AdmReason, insuStr, "N");
			if (insuRet != "0") {
				pePayRtn.ResultMsg = "结算失败,医保未退费,请和信息中心联系";
			}
		} catch (e) {
			pePayRtn.ResultMsg = "结算失败,医保未退费,请和信息中心联系\n" + e.message;
		}
	}

	return pePayRtn;
}



/**
 * [第三方退费]
 * @param    {[int]}    dropInvprt [被退的发票ID]
 * @param    {[int]}    oriInvprt [原发票ID]
 * @return   {object}    pePayRtn
 * @Author   wangguoying
 * @DateTime 2019-12-27
 */
function extRefund(dropInvprt,oriInvprt){
	pePayRtn = {
		ResultCode:"0",
		ResultMsg: "",
		ETPRowID: "",
		PEBarCodePayStr:"",
		ExpStr:""
	};
	var refundInfo=tkMakeServerCall("web.DHCPE.CashierEx","GetPOSRefundPara","",dropInvprt,oriInvprt);
	if (refundInfo == "") {
		return pePayRtn;
	}
	var char1 = String.fromCharCode(1);
	var PEBarCodePayStr = refundInfo.split(char1)[1]; //互联网扫码付支付记录
	refundInfo = refundInfo.split(char1)[0];
	var refundDr = refundInfo.split("^")[1];
	var refundAmt = parseFloat(refundInfo.split("^")[2]);
	var oldETPRowID = refundInfo.split("^")[3];
	var oldINvID = refundInfo.split("^")[4]; //正票
	var dropInvID = refundInfo.split("^")[5]; //负票    			
	var newInvID = refundInfo.split("^")[6] //新票
	var oriInvID = refundInfo.split("^")[7] //原始正票
	var paadm = refundInfo.split("^")[8];
	var scanFlag = refundInfo.split("^")[9] //互联网扫码付


	if (scanFlag == "1") {
		var updateRtn = tkMakeServerCall("MHC.BarCodePay", "updatePEBarCodePay", paadm, PEBarCodePayStr, "D", "");
		if (updateRtn.split("^")[0] != "0") {
			pePayRtn.ResultCode = -500;
			pePayRtn.ResultMsg = "体检退费成功，调用互联网退费接口失败,请补交易！\n" + updateRtn;
		} else {
			//记录第三方退费成功 
			var record = tkMakeServerCall("web.DHCPE.CashierEx", "RecordPOSRefund", dropInvID);
		}
	} else {
		var expStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] + "^^^^^D^";
		var refRtn = RefundPayService("PE", oldINvID, dropInvID, newInvID, refundAmt, "PE", expStr);
		if (refRtn.rtnCode != "0") {
			pePayRtn.ResultCode = -500;
			pePayRtn.ResultMsg = "体检退费成功，调用第三方退费接口失败,请补交易！\n" + refRtn.rtnMsg;
		} else {
			//记录第三方退费成功 
			var record = tkMakeServerCall("web.DHCPE.CashierEx", "RecordPOSRefund", dropInvID);
		}
	}
	return pePayRtn;
}