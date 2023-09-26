/// DHCBillPayService.js

/**
 * @fileOverview <支付组件支付函数>
 * @author <zhenghao>
 * @version <Pos、扫码、窗口银行直连>
 * @updateDate <2018-03-20>
 */

/// m_RefFlag配置说明：
/// 配置1：	优点(当日退费可以实时到账)
///			缺点(1.门诊结算拆多张票需要刷pos多次; 2.门诊部分退费需要操作2次pos[先全退再部分收]; 3.必须到原缴款pos终端进行退费;)
/// 配置0：	优点(1.门诊结算拆多张票只需刷pos一次; 2.门诊部分退费只需要操作1次pos[退差额] 3.可以再任意终端进行退费)
///			缺点(当日退费不能及时到账)
/// 此配置需跟医院核实，是走当日撤销还是当日退货(前提银行支持当日退货)
var m_RefFlag = 0;    //配置：0-表示差额退费;1表示全退再收;

/**
 * [PayService 支付服务]
 * @param {[String]} tradeType    [业务类型 OP/PRE/DEP/IP/INSU/CARD]
 * @param {[String]} payMode   	  [支付方式ID]
 * @param {[String]} tradeAmt     [金额]
 * @param {[String]} expStr       [扩展串(科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空))]
 * @return{[obj]} 	 rtnValue     [返回值 obj.ResultCode结果代码(0成功;1交易成功或部分交易成功,需提示ResultMsg;其他:失败);obj.ResultMsg结果描述;obj.ETPRowID订单ID(多个^分隔,门诊收费用);obj.SuccessPrtStr成功业务ID(多个^分隔,门诊收费用)]
 */
function PayService(tradeType, payMode, tradeAmt, expStr) {
	//科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)
	var expStrAry = expStr.split('^');
	var hisPrtStr = expStrAry[6]; //业务id

	var rtnValue = {
		ResultCode: "00",
		ResultMsg: "该支付方式不需调用接口收费",
		ETPRowID: ""
	};
	var payModeInfo = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetCallModeByPayMode", payMode);
	var tmpAry = payModeInfo.split("^");
	var payCallFlag = tmpAry[0];     //是否调用银医卡软POS接口
	var payMethodClass = tmpAry[1];  //支付方式对应的adapter类
	var payCallMode = tmpAry[2];     //接口类型
	//var payRefFlag = tmpAry[3]; 	 //退费标志

	if ((tradeAmt == "") && (hisPrtStr != "")) {
		tradeAmt = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetChargeAmt", tradeType, hisPrtStr, payMode);
	}
	if (+tradeAmt == 0) {
		rtnValue.ResultCode = "00";
		rtnValue.ResultMsg = "支付金额为0，不调用第三方支付!";
		return rtnValue;
	}

	if ((payCallMode == "DLL") && (payCallFlag != "0")) {
		//调用Pos服务js调用
		var rtnValue = posPay(tradeType, tradeAmt, payMode, expStr);  //DHCBillMisPosPay.js
	} else if ((payCallMode == "WS") && (payCallFlag != "0")) {
		//调用直连服务js调用
		rtnValue = "";
	} else if ((payCallMode == "SP") && (payCallFlag != "0")) {
		//弹出扫码扣费组件(模态窗口)
		var lnk = "dhcbill.scancodepay.csp";
		var iHeight = 260;
		var iWidth = 440;
		var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置
		var iLeft = (window.screen.availWidth - 10 - iWidth) / 2; //获得窗口的水平位置
		var parm = {
			tradeType: tradeType,
			payMode: payMode,
			tradeAmt: tradeAmt,
			expStr: expStr
		};
		rtnValue = window.showModalDialog(lnk, parm, 'dialogHeight:' + iHeight + 'px;dialogWidth:' + iWidth + 'px;dialogHeight:' + iHeight + 'px;dialogLeft:' + iLeft + 'px;dialogTop:' + iTop + 'px;resizable:no;status:no;scroll:no');
		//扫码付只支持退货
		m_RefFlag = 0;
	} else {
		return rtnValue;
	}

	return rtnValue;
}

/**
 * [RefundPayService 支付组件退款服务]
 * @param {[String]} tradeType      [业务类型]
 * @param {[String]} receipRowID    [原业务ID]
 * @param {[String]} abortPrtRowID  [负业务ID]
 * @param {[String]} newPrtRowID    [门诊退费重收新票]
 * @param {[String]} refundAmt    	[退款金额  出院退押金、门诊退账户余额 必传]
 * @param {[String]} originalType   [原业务类型  交叉业务必传]
 * @param {[String]} rtnValue    	[obj.rtnCode:代码(0:交易成功,数据处理正常;1:交易成功,需提醒数据处理异常);obj.rtnMsg:描述]
 */
function RefundPayService(tradeType, receipRowID, abortPrtRowID, newPrtRowID, refundAmt, originalType, expStr) {
	//科室^安全组^院区^操作员ID^病人ID^就诊
	var expStrAry = expStr.split('^');
	var hisPrtStr = abortPrtRowID + "!" + newPrtRowID; //业务id
	var rtnValue = {
		rtnCode: 0,
		rtnMsg: "成功"
	};
	//add by xiongwang 2018-04-30 判断改退费记录是否已调用接口退费(不存在一条退费记录需要调用几次接口情况)
	var TradeRefAmt = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetETPRefAmtByAbortPrt", originalType, abortPrtRowID);
	if (TradeRefAmt > 0) {
		var rtnValue = {
			rtnCode: 1,
			rtnMsg: "该记录已成功退费,不需再退费"
		};
		return rtnValue;
	}
	var OrgETPRowID = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetOrgETPRowIDByPrt", receipRowID, originalType);
	var payMode = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetPayModedrByETPRowID", OrgETPRowID);
	var payCallInfo = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetCallModeByPayMode", payMode);
	//公用取退费金额方法????需添加
	if (refundAmt == "") {
		refundAmt = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetRefundAmt", originalType, abortPrtRowID, newPrtRowID, payMode, refundAmt);
	}
	if (+refundAmt == 0) {
		//作废从打？？？
		var rtnValue = {
			rtnCode: "0",
			rtnMsg: "金额为0,不需调用接口"
		};
		return rtnValue;
	}

	var payCallFlag = payCallInfo.split("^")[0];
	var payCallMode = payCallInfo.split("^")[2];

	if ((payCallMode == "DLL") && (payCallFlag != "0")) {
		var bankTradeType = "D"; //退费
		//调用Pos服务js调用
		var rtnValue = posPayRefund(receipRowID, abortPrtRowID, newPrtRowID, tradeType, payMode, OrgETPRowID, originalType, refundAmt, expStr);
	} else if ((payCallMode == "WS") && (payCallFlag != "0")) {
		//调用直连服务js调用
		var rtnValue = {
			rtnCode: "0",
			rtnMsg: ""
		};
	} else if ((payCallMode == "SP") && (payCallFlag != "0")) {
		//^业务表指针串(以!分隔,可为空)^原订单ID^收退标志(C收D退)
		var expStr = expStr + "^" + hisPrtStr;
		var rtnValue = refundScanCodePay(tradeType, refundAmt, OrgETPRowID, expStr);
	}
	
	return rtnValue;
}

/**
 * [RelationService 业务关联服务]
 * @param {[String]} ETPRowID    [订单ID]
 * @param {[String]} hisPrtStr   [业务表ID]
 * @param {[String]} tradeType   [业务类型 OP/PRE/DEP/IP/INSU/CARD]
 * @return{[obj]} 	 rtnValue    [返回值 obj.ResultCode结果代码(0成功;非0失败);obj.ResultMsg结果描述]
 */
function RelationService(ETPRowID, hisPrtStr, tradeType) {
	var linkRtn = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "RelationOrderToHIS", ETPRowID, hisPrtStr, tradeType);
	var ResultCode = linkRtn.split('^')[0];
	var ResultMsg = linkRtn.split('^')[1];
	var RtnValue = {
		ResultCode: ResultCode,
		ResultMsg: ResultMsg
	};
	return RtnValue;
}

/**
 * [CancelPayService 支付冲销服务]
 * @param {[String]} ETPRowID		[订单ID]
 * @param {[String]} ExpStr			[扩展串(科室^安全组^院区^操作员ID)]
 */
function CorrectScanCodePay(ETPRowID, ExpStr) {
	var RtnValue = {
		ResultCode: "0",
		ResultMsg: "订单不需退费"
	};
	var paymode = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetPayModedrByETPRowID", ETPRowID);
	var payModeInfo = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetCallModeByPayMode", paymode);
	var payCallMode = payModeInfo.split("^")[4];
	if ((payCallMode == "DLL") && (payCallFlag != "0")) {
		//调用Pos服务js调用
		//POS收费成功,HIS收费失败,是否也考虑冲正????
		rtnValue = "";
	} else if ((payCallMode == "WS") && (payCallFlag != "0")) {
		//调用直连服务js调用
		rtnValue = "";
	} else if ((payCallMode == "SP") && (payCallFlag != "0")) {
		//var cacelRtn = cancelScanCodePay(ETPRowID, "");
		var RtnValue = correctScanCodePay(ETPRowID, ExpStr);
	}
	return RtnValue;
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <按现金结算>
 * @param {[String]} PrtRowID [业务表ID]
 * @return{[String]} myrtn [0成功]
 */
function UpdateCARDToCASH(PrtRowID) {
	var myrtn = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "UpdateCARDToCASH", PrtRowID);
	return myrtn;
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <获取银行交易类型>
 * @param {[String]} OrgETPRowID [原正记录业务表对应交易表rowid]
 * @param {[String]} bankType [银行pos类型 例如:联迪LD/创识CS等]
 * @param {[String]} posTerminal [业务表ID]
 * @return{[String]} bankTradeType [银行交易类型C/D/T]
 */
function GetBankTradeType(OrgETPRowID, PosConfig) {
	var bankTradeType = tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "CheckRefundTradeType", OrgETPRowID, PosConfig);
	return bankTradeType;
}

//门诊收费调用
//调用接口收费,返回需要完成的发票串
function OPPayService(myPRTStr, PayMode, ExpStr) {
	var RtnPrtStr = "";
	/*有个BUG,项目又上了扫码付,又上了POS)
	 *扫码需要支持退货,POS要走全退再收(这里不能单独根据m_RefFlag判断)
	 */
	//根据POS配置m_RefFlag处理(0-表示差额退费;1表示全退再收,收费时需单张收费;)
	if (m_RefFlag == "1") {
		//单张支付
		var PrtLen = myPRTStr.split("^").length;
		for (i = 0; i < PrtLen; i++) {
			var PrtRowID = myPRTStr.split("^")[i];
			var myExpStr = ExpStr + "^" + PrtRowID;
			var PayRtn = PayService("OP", PayMode, "", myExpStr);
			switch (PayRtn.ResultCode) {
			case "0":
				//拼接需返回的发票串
				if (RtnPrtStr == "") {
					RtnPrtStr = PrtRowID;
				} else {
					RtnPrtStr = RtnPrtStr + "^" + PrtRowID;
				}
				//支付成功 调用关联订单(订单ID不为空时)
				if (PayRtn.ETPRowID != "") {
					var RelaRtn = RelationService(PayRtn.ETPRowID, PrtRowID, "OP");
					if (RelaRtn.ResultCode != "0") {
						alert("支付成功," + RelaRtn.ResultMsg + "请联系信息科处理");
					}
				}
				break;
			case "1":
				//拼接需返回的发票串
				if (RtnPrtStr == "") {
					RtnPrtStr = PrtRowID;
				} else {
					RtnPrtStr = RtnPrtStr + "^" + PrtRowID;
				}
				//支付成功 调用关联订单
				var RelaRtn = RelationService(PayRtn.ETPRowID, PrtRowID, "OP");
				if (RelaRtn.ResultCode != "0") {
					alert("支付成功," + RelaRtn.ResultMsg + "请联系信息科处理");
				}
				alert(PayRtn.ResultMsg + ",请联系信息科处理"); //HIS有异常也继续交易
				break;
			default:
				alert(PayRtn.ResultMsg);
			}
			//遇到支付异常,不再继续支付,
			if ((PayRtn.ResultCode != "0") && (PayRtn.ResultCode != "1")) {
				var FailPrtStr = "";
				for (j = i; j < PrtLen; j++) {
					var FailPrtRowID = myPRTStr.split("^")[j];
					if (FailPrtStr == "") {
						FailPrtStr = FailPrtRowID;
					} else {
						FailPrtStr = FailPrtStr + "^" + FailPrtRowID;
					}
				}
				var RtnFailPrtStr = DealtFailPrtData(FailPrtStr); //处理支付失败数据
				if (RtnPrtStr == "") {
					RtnPrtStr = RtnFailPrtStr;
				} else {
					RtnPrtStr = RtnPrtStr + "^" + RtnFailPrtStr;
				}
				break;
			}
		}
	} else {
		var prtRowIDAry = myPRTStr.split("^");
		var payPRTStr = prtRowIDAry.join("!");
		var myExpStr = ExpStr + "^" + payPRTStr;
		var PayRtn = PayService("OP", PayMode, "", myExpStr);
		switch (PayRtn.ResultCode) {
		case "0":
			//支付成功 调用关联订单
			RtnPrtStr = myPRTStr;
			if (PayRtn.ETPRowID != "") {
				var RelaRtn = RelationService(PayRtn.ETPRowID, payPRTStr, "OP");
				if (RelaRtn.ResultCode != "0") {
					alert("支付成功," + RelaRtn.ResultMsg + "请联系信息科处理");
				}
			}
			break;
		case "1":
			RtnPrtStr = myPRTStr;
			var RelaRtn = RelationService(PayRtn.ETPRowID, payPRTStr, "OP");
			if (RelaRtn.ResultCode != "0") {
				alert("支付成功," + RelaRtn.ResultMsg + "请联系信息科处理");
			}
			alert(PayRtn.ResultMsg + ",请联系信息科处理");
			break;
		default:
			alert(PayRtn.ResultMsg);
			RtnPrtStr = DealtFailPrtData(myPRTStr);  //处理支付失败数据
		}
	}
	return RtnPrtStr;
}

/* @param {[String]} FailPrtStr     [调用第三方支付失败的发票串](以"^"分割)
 * @return{[String]} myRtn			[返回需要继续完成的发票串](以"^"分割)
 */
function DealtFailPrtData(FailPrtStr) {
	var myRtn = "";
	//医保患者交易失败怎么处理(0更新成现金需要继续完成;1回滚医保;2收费员自己到异常处理界面处理)
	var HandleFlag = "0";
	//分自费和医保2种情况分别处理
	var myYBINS = DHCWebD_GetObjValue("YBFlag");
	if ((m_YBConFlag == "1") && (myYBINS > 0)) {
		//医保患者处理方式(更新成现金();还是需补交易)
		if (HandleFlag == "0") {
			//更新成现金成功需要继续完成
			var Len = FailPrtStr.split("^").length;
			for (i = 0; i < Len; i++) {
				var myrtn = UpdateCARDToCASH(FailPrtStr);
				if (myrtn == "0") {
					myRtn = FailPrtStr;
					alert("医保病人支付失败,按现金结算,请注意收取现金.");
				} else {
					alert("医保病人支付失败,按现金结算失败,请到收费异常处理界面处理.");
				}
			}
		} else if (HandleFlag == "1") {
			//撤销医保结算
			var Len = FailPrtStr.split("^").length;
			for (i = Len; i > 0; i--) {
				var FailPrtRowID = FailPrtStr.split("^")[i];
				var ExpStr = "" + "^" + session['LOGON.GROUPID'] + "^";
				//待完成
				//var rollRtn = HISRollBack(FailPrtRowID, InsDivDR, InsTypeDR, AdmSource, ExpStr);
			}
			myRtn = "";
		} else {
			//不处理
			alert("医保病人支付失败,请到收费异常处理界面处理.");
			myRtn = "";
		}
	} else {
		//自费患者回滚
		var ExpStr = "" + "^" + session['LOGON.GROUPID'] + "^";
		var myrtn = DHCWebOPYB_DeleteHISData(FailPrtStr, ExpStr);
		if (myrtn == "0") {
			alert("自费病人支付失败,回滚发票成功,请重试");
		} else {
			alert("自费病人支付失败,回滚发票失败,请到异常处理回滚发票!");
		}
	}
	return myRtn;
}