/// DHCBillPayService.js

/**
 * @fileOverview <支付组件支付函数>
 * @author <zhenghao>
 * @version <Pos、扫码、窗口银行直连>
 * @updateDate <2018-03-20>
 */

/**
 * m_RefFlag配置说明:
 * 		配置0: 表示差额退费
 *			   优点(1.门诊结算拆多张票只需刷pos一次; 2.门诊部分退费只需要操作1次pos[退差额] 3.可以再任意终端进行退费)
 *	      	   缺点(当日退费不能及时到账)
 * 		配置1: 表示全退再收
 *			   优点(当日退费可以实时到账)
 *		  	   缺点(1.门诊结算拆多张票需要刷pos多次; 2.门诊部分退费需要操作2次pos[先全退再部分收]; 3.必须到原缴款pos终端进行退费;)
 * 		此配置需跟医院核实，是走当日撤销还是当日退货(前提银行支持当日退货)
 */

var m_RefFlag = 0;

/**
 * [PayService 支付服务]
 * @param  {[String]} tradeType       [业务类型 OP/PRE/DEP/IP/INSU/CARD]
 * @param  {[String]} payMode   	  [支付方式ID]
 * @param  {[String]} tradeAmt        [金额]
 * @param  {[String]} expStr          [扩展串(科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空))]
 * @param  {[function]} callback      [回调函数]
 * @return {[obj]}  rtnValue          [返回值 obj.ResultCode结果代码(0成功;1交易成功或部分交易成功,需提示ResultMsg;其他:失败);obj.ResultMsg结果描述;obj.ETPRowID订单ID(多个^分隔,门诊收费用);obj.SuccessPrtStr成功业务ID(多个^分隔,门诊收费用)]
 */
function PayService() {
	var tradeType = arguments[0];
	var payMode = arguments[1];
	var tradeAmt = arguments[2];
	var expStr = arguments[3];
	var callback = arguments[4];

	//科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)
	var expStrAry = expStr.split("^");
	var hisPrtStr = expStrAry[6] || ""; //业务id

	var rtnValue = {
		ResultCode: 0,
		ResultMsg: "该支付方式不需调用接口收费",
		PayMode: payMode,
		ETPRowID: ""
	};
	var payModeInfo = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetCallModeByPayMode", payMode);
	var myAry = payModeInfo.split("^");
	var payCallFlag = myAry[0];     //是否调用第三方接口
	var payMethodClass = myAry[1];  //支付方式对应的adapter类
	var payCallMode = myAry[2];     //接口类型
	
	if (payCallFlag == 0) {
		callback(rtnValue);
		return;
	}
	if (!tradeAmt && hisPrtStr) {
		tradeAmt = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetChargeAmt", tradeType, hisPrtStr, payMode);
	}
	if (tradeAmt == 0) {
		rtnValue.ResultMsg = "支付金额为0，不调用第三方支付";
		callback(rtnValue);
		return;
	}
	switch(payCallMode) {
	case "DLL":
		//调用POS服务js调用
		rtnValue = posPay(tradeType, tradeAmt, payMode, expStr);  //DHCBillMisPosPay.js
		rtnValue.PayMode = payMode;
		callback(rtnValue);
		break;
	case "WS":
		//调用银医直连服务js调用
		break;
	case "SP":
		m_RefFlag = 0;   //扫码付只支持退货
		
		//弹出扫码扣费组件
		var argumentObj = {
			tradeType: tradeType,
			payMode: payMode,
			tradeAmt: tradeAmt,
			expStr: expStr
		};
		var url = "dhcbill.scancodepay.csp?arguments=" + encodeURIComponent(JSON.stringify(argumentObj));
		websys_showModal({
			url: url,
			title: '扫码支付',
			iconCls: 'icon-w-scan-code',
			height: 260,
			width: 440,
			closable: false,
			callbackFunc: function(rtnValue) {
				rtnValue.PayMode = payMode;
				callback(rtnValue);
			}
		});
		break;
	default:
	}
}

/**
 * [RefundPayService 支付组件退款服务]
 * @param {[String]} tradeType      [业务类型]
 * @param {[String]} initPrtRowId   [原业务ID]
 * @param {[String]} abortPrtRowId  [负业务ID]
 * @param {[String]} newPrtRowId    [门诊退费重收新票]
 * @param {[String]} refundAmt    	[退款金额  出院退押金、门诊退账户余额 必传]
 * @param {[String]} originalType   [原业务类型  交叉业务必传]
 * @param {[String]} expStr         [科室^安全组^院区^操作员ID]
 * @param {[String]} rtnValue    	[obj.ResultCode:代码(0:交易成功,数据处理正常;1:交易成功,需提醒数据处理异常);obj.ResultMsg:描述]
 */
function RefundPayService() {
	var tradeType = arguments[0];
	var initPrtRowId = arguments[1];
	var abortPrtRowId = arguments[2];
	var newPrtRowId = arguments[3];
	var refundAmt = arguments[4];
	var originalType = arguments[5];
	var expStr = arguments[6];
	
	var _getPendRefAry = function() {
		var pendRefJsonStr = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetPendingRefData", tradeType, initPrtRowId, abortPrtRowId, newPrtRowId, originalType);
		return JSON.parse(pendRefJsonStr);
	};
	
	var _callRefSrv = function() {
		var rtnJson = {
			ResultCode: -2001,
			ResultMsg: "退款失败"
		};
		switch(payCallMode) {
		case "DLL":
			//调用POS服务js调用
			rtnJson = posPayRefund(initPrtRowId, abortPrtRowId, newPrtRowId, tradeType, payMode, orgETPRowId, originalType, pendRefAmt, expStr);
			break;
		case "WS":
			//调用银医直连服务js调用
			rtnJson.ResultMsg = "银医直连接口未实现";
			break;
		case "SP":
			//扫码退费
			//^业务表指针串(以!分隔,可为空)^原订单ID^收退标志(C收D退)
			expStr += "^" + hisPrtStr;
			rtnJson = refundScanCodePay(tradeType, orgETPRowId, pendRefAmt, expStr);
			break;
		default:
		}
		return rtnJson;
	};
	
	var hisPrtStr = abortPrtRowId + "!" + newPrtRowId;  //业务id
	var rtnValue = {
		ResultCode: 0,
		ResultMsg: "退款成功"
	};
	var pendRefAmt = 0;           //待退款金额
	var orgETPRowId = "";         //原支付订单Id
	var payMode = "";             //退费方式Id
	var payCallMode = "";         //调用接口服务模式
	
	var refJson = {};
	var pendRefAry = _getPendRefAry();
	if (pendRefAry.length == 0) {
		rtnValue.ResultCode = 0;
		rtnValue.ResultMsg = "无可退款订单";
		return rtnValue;
	}
	for(var i = 0, len = pendRefAry.length; i < len; i++) {
		refJson = pendRefAry[i];        //{"ETPID": 1, "PayMID":"1", "PendRefAmt":2.00, "PayCallMode":"SP"}
		orgETPRowId = refJson.ETPID;
		payMode = refJson.PayMID;
		payCallMode = refJson.PayCallMode;
		pendRefAmt = (refundAmt == 0) ? refJson.PendRefAmt : refundAmt;
		if (pendRefAmt == 0) {
			//作废重打不需要调用接口
			rtnValue.ResultMsg = "金额为0，不需调用接口";
			continue;
		}
		var rtnJson = _callRefSrv();
		rtnValue.ResultCode += rtnJson.ResultCode;
		if (rtnValue.ResultCode != 0) {
			rtnValue.ResultMsg += rtnJson.ResultMsg;
		}
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
	var rtn = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "RelationOrderToHIS", ETPRowID, hisPrtStr, tradeType);
	var myAry = rtn.split("^");
	var code = myAry[0];
	var msg = myAry[1];
	var rtnValue = {
		ResultCode: code,
		ResultMsg: msg
	};
	return rtnValue;
}

/**
 * [CancelPayService 支付冲销服务]
 * @param {[String]} ETPRowID		[订单ID]
 * @param {[String]} ExpStr			[扩展串(科室^安全组^院区^操作员ID)]
 */
function CancelPayService(ETPRowID, ExpStr) {
	var rtnValue = {
		ResultCode: 0,
		ResultMsg: "订单不需退费"
	};
	var rtn = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetCanRevokeFlag", ETPRowID);
	var myAry = rtn.split("^");
	if (myAry[0] != 0) {
		rtnValue.ResultCode = myAry[0];
		rtnValue.ResultMsg = myAry[1];
		return rtnValue;
	}
	
	var paymId = GetETPPayModeID(ETPRowID);
	var payModeInfo = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetCallModeByPayMode", paymId);
	var myAry = payModeInfo.split("^");
	var payCallFlag = myAry[0];     //是否调用第三方接口
	var payCallMode = myAry[2];     //接口类型
	if (payCallFlag == 0) {
		return rtnValue;
	}
	switch(payCallMode) {
	case "DLL":
		//调用Pos服务js调用
		var rtnValue = correctPosPay(ETPRowID, ExpStr);
		break;
	case "WS":
		//调用直连服务js调用
		rtnValue = "";
		break;
	case "SP":
		rtnValue = correctScanCodePay(ETPRowID, ExpStr);
		break;
	default:
	}
	return rtnValue;
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <按现金结算>
 * @param {[String]} PrtRowID [业务表ID]
 * @return{[String]} myrtn [0成功]
 */
function UpdateCARDToCASH(prtRowIdStr) {
	return tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "UpdateCARDToCASH", prtRowIdStr);
}

/**
 * @author <zfb>
 * @date <2018-3-12>
 * @desc <获取银行交易类型>
 * @param {[String]} orgETPRowId [原正记录业务表对应交易表rowId]
 * @param {[String]} bankType [银行pos类型 例如:联迪LD/创识CS等]
 * @param {[String]} posTerminal [业务表ID]
 * @return{[String]} bankTradeType [银行交易类型C/D/T]
 */
function GetBankTradeType(orgETPRowId, PosConfig) {
	return tkMakeServerCall("DHCBILL.MisPos.BLL.MisPosLogic", "CheckRefundTradeType", orgETPRowId, PosConfig);
}

/**
 * 门诊收费调用
 * 调用接口收费，返回需要完成的发票串
 * *
 * 有个Bug,项目又上了扫码付,又上了POS
 * 扫码需要支持退货,POS要走全退再收(这里不能单独根据m_RefFlag判断)
 * *
 */
function OPPayService(myPRTStr, PayMode, ExpStr) {
	var RtnPrtStr = "";
	
	//根据POS配置m_RefFlag处理(0-表示差额退费;1表示全退再收,收费时需单张收费)
	var prtRowIDAry = myPRTStr.split("^");
	if (m_RefFlag == 1) {
		//单张支付
		var i;
		for (i = 0; i < prtRowIDAry.length; i++) {
			var PrtRowID = prtRowIDAry[i];
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
					if (RelaRtn.ResultCode != 0) {
						$.messager.alert("提示", "支付成功," + RelaRtn.ResultMsg + "，请联系信息科处理", "error");
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
				if (RelaRtn.ResultCode != 0) {
					$.messager.alert("提示", "支付成功," + RelaRtn.ResultMsg + "，请联系信息科处理", "error");
				}
				$.messager.alert("提示", PayRtn.ResultMsg + "，请联系信息科处理", "error"); //HIS有异常也继续交易
				break;
			default:
				$.messager.alert("提示", PayRtn.ResultMsg, "error");
			}
			
			//遇到支付异常,不再继续支付
			if ([0, 1].indexOf(+PayRtn.ResultCode) == -1) {
				var FailPrtStr = "";
				var j;
				for (j = i; j < prtRowIDAry.length; j++) {
					var FailPrtRowID = prtRowIDAry[j];
					if (FailPrtStr == "") {
						FailPrtStr = FailPrtRowID;
					} else {
						FailPrtStr = FailPrtStr + "^" + FailPrtRowID;
					}
				}

				var RtnFailPrtStr = DealtFailPrtData(FailPrtStr);   //处理支付失败数据
				if (RtnPrtStr == "") {
					RtnPrtStr = RtnFailPrtStr;
				} else {
					RtnPrtStr = RtnPrtStr + "^" + RtnFailPrtStr;
				}
				break;
			}
		}
	} else {
		var payPRTStr = prtRowIDAry.join("!");
		var myExpStr = ExpStr + "^" + payPRTStr;
		var PayRtn = PayService("OP", PayMode, "", myExpStr);
		switch (PayRtn.ResultCode) {
		case "0":
			//支付成功 调用关联订单
			RtnPrtStr = myPRTStr;
			if (PayRtn.ETPRowID != "") {
				var RelaRtn = RelationService(PayRtn.ETPRowID, payPRTStr, "OP");
				if (RelaRtn.ResultCode != 0) {
					$.messager.alert("提示", "支付成功，" + RelaRtn.ResultMsg + "，请联系信息科处理", "error");
				}
			}
			break;
		case "1":
			RtnPrtStr = myPRTStr;
			var RelaRtn = RelationService(PayRtn.ETPRowID, payPRTStr, "OP");
			if (RelaRtn.ResultCode != 0) {
				$.messager.alert("提示", "支付成功，" + RelaRtn.ResultMsg + "，请联系信息科处理", "error");
			}
			$.messager.alert("提示", PayRtn.ResultMsg + "，请联系信息科处理", "error");
			break;
		default:
			$.messager.alert("提示", PayRtn.ResultMsg, "error");
			RtnPrtStr = DealtFailPrtData(myPRTStr);    //处理支付失败数据
		}
	}
	return RtnPrtStr;
}

/**
 * @param {[String]} FailPrtStr     [调用第三方支付失败的发票串](以"^"分割)
 * @return{[String]} myRtn			[返回需要继续完成的发票串](以"^"分割)
 */
function DealtFailPrtData(FailPrtStr) {
	var myRtn = "";
	//医保患者交易失败怎么处理(0:更新成现金需要继续完成;1:回滚医保;2:收费员自己到异常处理界面处理)
	var HandleFlag = 0;
	
	//分自费和医保2种情况分别处理
	var insTypeId = getValueById("insTypeId");
	var admSource = tkMakeServerCall("web.DHCBillCommon", "GetPropValById", "PAC_AdmReason", insTypeId, "REA_AdmSource");
	if ((CV.INVYBConFlag == 1) && (admSource > 0)) {
		//医保患者处理方式(更新成现金? 还是需补交易)
		if (HandleFlag == 0) {
			//更新成现金成功需要继续完成
			var myrtn = UpdateCARDToCASH(FailPrtStr);
			if (myrtn == 0) {
				myRtn = FailPrtStr;
				$.messager.alert("提示", "医保病人支付失败，按现金结算，请注意收取现金", "info");
			} else {
				$.messager.alert("提示", "医保病人支付失败，按现金结算失败，请到收费异常处理界面处理", "error");
			}
		} else if (HandleFlag == 1) {
			//撤销医保结算
			var FailPrtAry = FailPrtStr.split("^");
			var i;
			for (i = FailPrtAry.length; i > 0; i--) {
				var FailPrtRowID = FailPrtAry[i];
				var ExpStr = "" + "^" + session['LOGON.GROUPID'] + "^";
				//待完成
				//var rollRtn = HISRollBack(FailPrtRowID, InsDivDR, InsTypeDR, AdmSource, ExpStr);
			}
		} else {
			//不处理
			$.messager.alert("提示", "医保病人支付失败，请到收费异常处理界面处理", "error");
		}
	} else {
		//自费患者回滚
		var ExpStr = "" + "^" + session['LOGON.GROUPID'] + "^";
		var myrtn = DHCWebOPYB_DeleteHISData(FailPrtStr, ExpStr);
		if (myrtn == 0) {
			$.messager.alert("自费病人支付失败，回滚发票成功，请重试");
		} else {
			$.messager.alert("自费病人支付失败，回滚发票失败，请到异常处理回滚发票");
		}
	}
	return myRtn;
}

/**
 * [CheckPayService 支付查证服务（不确定订单是否成功查证第三方）]
 * @param {[String]} IBPRowid    [订单ID]
 * @return{[obj]} 	 rtnValue    [返回值 obj.ResultCode结果代码(0成功;非0失败);obj.ResultMsg结果描述]
 */
function CheckPayService(ETPRowID) {
	var rtnValue = {
		ResultCode: -1,
		ResultMsg: "订单支付失败"
	};
	var paymId = GetETPPayModeID(ETPRowID);
	var payModeInfo = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetCallModeByPayMode", paymId);
	var payCallMode = payModeInfo.split("^")[2];
	var payCallFlag = payModeInfo.split("^")[0];
	if (payCallFlag == 0) {
		rtnValue.ResultCode = 0;
		rtnValue.ResultMsg = "该支付方式不需调用接口";
		return rtnValue;
	}
	if (payCallMode == "DLL") {
		//调用Pos服务js调用
		rtnValue = BankPayCheck(ETPRowID);
	} else if (payCallMode == "WS") {
		//调用直连服务js调用
	} else if (payCallMode == "SP") {
	}
	return rtnValue;
}

/**
 * @author <suhuide>
 * @date <2021-11-17>
 * @desc <根据订单表RowID获取第三方支付方式ID>
 * @param {[String]} ETPRowID: DHC_BillExtTradePay.RowId
 * @return{[String]} PayModeID: CT_PayMode.RowId
 */
function GetETPPayModeID(ETPRowID) {
	return tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetETPPayModeID", ETPRowID);
}