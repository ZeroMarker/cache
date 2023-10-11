/**
 * FileName: dhcbill.opbill.refund.inv.js
 * Author: ZhYW
 * Date: 2019-04-23
 * Description: 普通门诊发票退费
 */

/**
* 普通发票退费
*/
function invRefSaveInfo() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var row = GV.InvList.getSelected();
			if (!row) {
				return reject();
			}
			invRowId = row.invRowId;
			invFlag = row.invFlag;
			if ((invFlag == "API") && (row.prtRowId > 0)) {    //集中打印发票自动撤销时按小条退费，在退费程序中撤消集中打印发票
				accPInvId = invRowId;
				invRowId = row.prtRowId;
				invFlag = "PRT";
			}
			if (!invRowId || (invFlag == "API")) {
				return reject();
			}
			var prtFlag = getPropValById("DHC_INVPRT", invRowId, "PRT_Flag");
			if (prtFlag != "N") {
				$.messager.popover({msg: "该发票已退费，不能退费", type: "info"});
				return reject();
			}
			var rtn = $.m({ClassName: "web.DHCOPBillChargExcepiton", MethodName: "JudgeINVTPFlag", PrtRowid: invRowId, ExpStr: ""}, false);
			if (rtn != 0) {
				$.messager.popover({msg: "有未处理的异常发票，请先处理后在退费", type: "info"});
				return reject();
			}
			//增加判断发票里退费数量大于收费数量时不能结算
			var rtn = $.m({ClassName: "web.DHCOPBillRefund", MethodName: "IsValidRefQty", prtRowId: invRowId}, false);
			if (rtn > 0) {
				$.messager.popover({msg: "退费数量大于收费数量请核实", type: "info"});
				return reject();
			}
			//+2022-11-22 ZhYW 医保收费跨月是否能退费
			if (insuDivId > 0) {
				var rtn = isAllowedRefInsuDiffMth(invRowId, invFlag);
				if (!rtn) {
					$.messager.popover({msg: "医保结算发票已跨月，不允许退费", type: "info"});
					return reject();
				}
			}
			admStr = getAdmByPrtRowId(invRowId);
			//+2022-03-29 ZhYW 判断是否做了直接退费审核
			if (GV.IsDirRefAudited == 1) {
				GV.ReBillFlag = 0;     //做了直接退费审核时，全部退费
			}
			isPassNo = isPassNoReChg();
			//+2022-11-01 ZhYW 判断第三方支付的门诊收费是否允许原路退
			if (!isPassNo) {
				var rtn = $.m({ClassName: "web.DHCOPBillRefund", MethodName: "IsAllowedInitModeToRefund", prtRowId: invRowId, refModeId: refundMode}, false);
				var myAry = rtn.split("^");
				if (myAry[0] != 0) {
					$.messager.popover({msg: (myAry[1] || myAry[0]), type: "info"});
					return reject();
				}
			}
			if ((GV.ReBillFlag == 1) && (admSource > 0)) {
				//+2023-04-04 ZhYW 医保住院患者是否允许门诊部分退费
				var rtn = isAllowedIPPatPartRef(patientId);
				if (!rtn) {
					$.messager.popover({msg: "该患者正在住院，不能医保部分退费", type: "info"});
					return reject();
				}
				//+2023-03-28 WangXQ 医保收费部分退费时医疗类别是否必填
				if (!insuAdmType) {
					var rtn = $.m({ClassName: "web.DHCOPBillRefund", MethodName: "IsInsuAdmTypeRequired", hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
					if (rtn != 0)  {
						$.messager.popover({msg: "请先选择医疗类别", type: "info"});
						return reject();
					}
				}
			}
			patPayAmt = Number(row.patShareAmt).sub(refundAmt).toFixed(2);  //重收金额
			return resolve();
		});
	};
	
	var _cfr = function () {
		return new Promise(function (resolve, reject) {
			var msg = "是否确认退费? ";
			if (isPassNo) {
				msg = "没有需要退费的医嘱，是否确认过号重打发票? ";
			}else {
				var invStr = invRowId + ":" + invFlag;
				var invIsOPToIP = $.m({ClassName: "web.DHCOPBillEmergTrans2IP", MethodName: "CheckInvIsOPToIP", invStr: invStr}, false);
				if (invIsOPToIP == 1) {
					msg = "有医嘱已转入住院，退费后转入的医嘱将不能撤回，" + msg;
				}
			}
			$.messager.confirm("确认", msg, function (r) {
				return r ? resolve() : reject();
			});
		}).then(function() {
			return new Promise(function (resolve, reject) {
				var bool = hasNoCancelAuditOrd();
				if (!bool) {
					return resolve();
				}
				var msg = "有已退费审核的医嘱未撤销执行或未退回，如果继续，请告知患者需重新申请退费，";
				msg += (isPassNo ? "是否确认过号重打发票" : "是否确认退费") + "? ";
				$.messager.confirm("确认", msg, function (r) {
					return r ? resolve() : reject();
				});
			});
		}).then(function() {
			return new Promise(function (resolve, reject) {
				if (GV.ReBillFlag != 1) {
					return resolve();
				}
				if (newInsType == curInsType) {
					return resolve();
				}
				var msg = "重新收费的收费类别发生变化，" + (isPassNo ? "是否确认过号重打发票" : "是否确认退费") + "? ";
				$.messager.confirm("确认", msg, function (r) {
					return r ? resolve() : reject();
				});
			});
		});
	};
	
	/**
	* 医保退费
	*/
	var _insuPark = function() {
		return new Promise(function (resolve, reject) {
			if (!(insuDivId > 0)) {
				return resolve();
			}
			if (CV.INVYBConFlag != 1) {
				$.messager.popover({msg: "配置不连接医保，请检查门诊系统参数配置", type: "info"});
				return reject();
			}
			var myYBHand = "";
			var myCPPFlag = "";
			var strikeFlag = "S";
			var insuNo = "";
			var cardType = "";
			var YLLB = "";
			var DicCode = "";
			var DicDesc = "";
			var DYLB = "";
			var chargeSource = "01";
			var leftAmt = "";
			var moneyType = "";
			var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
			myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource + "^" + DYLB;
			myExpStr += "^" + "" + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "!" + leftAmt + "^" + moneyType;
			var rtn = DHCWebOPYB_ParkINVFYB(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, insuDivId, curAdmSource, curInsType, myExpStr, myCPPFlag);
			if (rtn != 0) {
				$.messager.popover({msg: "医保退费失败，错误代码：" + rtn, type: "info"});
				return reject();
			}
			var insuInfo = $.m({ClassName: "web.DHCINSUPort", MethodName: "CheckINSUDivFlag", InvPrtDr: invRowId, PBDr: "", JustThread: "", CPPFlag: "", DivFlag: "S"}, false);
			var myAry = insuInfo.split("!");
			if (myAry[0] != "Y") {
				$.messager.popover({msg: "医保退费失败，请稍后重退", type: "info"});
				return reject();
			}
			return resolve();
		});
	};
	
	/**
	* HIS退费
	*/
	var _refund = function () {
		return new Promise(function (resolve, reject) {
			var expStr = invPayment + "^" + GV.InvRequireFlag + "^^^" + accPInvId;
			$.m({
				ClassName: "web.udhcOPRefEditIF",
				MethodName: "RefundReceipt",
				INVPRTRowid: invRowId,
				rUser: PUBLIC_CONSTANT.SESSION.USERID,
				sFlag: getValueById("refBtnFlag"),
				StopOrdStr: invOrderStr,
				NInvPay: patPayAmt,
				gloc: PUBLIC_CONSTANT.SESSION.GROUPID,
				RebillFlag: GV.ReBillFlag,
				ULoadLocDR: PUBLIC_CONSTANT.SESSION.CTLOCID,
				RPayModeDR: refundMode,
				NewInsType: newInsType,
				ExpStr: expStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] != 0) {
					chargeErrorTip("refundError", rtn);
					return reject();
				}
				disablePageBtn();
				newPrtRowId = myAry[1] || "";     //新票RowId
				strikeRowId = myAry[2] || "";     //负票RowId
				refInvFlag = myAry[3] || "N";     //是否打印负发票标识
				return resolve();
			});
		});
	};
	
	/**
	* 医保结算
	*/
	var _insuDiv = function () {
		return new Promise(function (resolve, reject) {
			if (!(newPrtRowId > 0)) {
				return resolve();
			}
			if (CV.INVYBConFlag != 1) {   //配置了不连接医保
				return resolve();
			}
			if (!(admSource > 0)) {   //非医保结算
				return resolve();
			}
			//ShangXuehao 2020-11-26 如果自付费用为0并且费用为0不调医保返回false
			var zeroAmtUseYB = ((patPayAmt > 0) || (CV.ZeroAmtUseYBFlag == 1));
			if (!zeroAmtUseYB) {
				return resolve();
			}
			var myYBHand = "";
			var myCPPFlag = "";
			var strikeFlag = "S";
			var insuNo = "";
			var cardType = "";
			var YLLB = insuAdmType;
			var DicCode = insuDicCode;
			var DicDesc = insuDicDesc;
			var DYLB = "";
			var chargeSource = "01";
			var DBConStr = "";         //数据库连接串
			var moneyType = "";
			var selPaymId = (invPayment == "N") ? refundMode : "";
			var leftAmt = "";
			if (refModeCode != "CPP") {
				myCPPFlag = "NotCPPFlag";
			}else {
				leftAmt = accMLeft;
			}
			var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
			myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource;
			myExpStr += "^" + DBConStr + "^" + DYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + leftAmt + "^" + moneyType;
			var rtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, newPrtRowId, admSource, insTypeId, myExpStr, myCPPFlag);
			var myAry = rtn.split("^");
			if (myAry[0] != 0) {
				var msg = "医保" + ((myAry[0] == "YBCancle") ? "取消结算" : "结算失败") + "，HIS将按自费完成收费";
				$.messager.alert("提示", msg, "warning", function() {
					return resolve();
				});
				return;
			}
			return resolve();
		});
	};
	
	/**
	* 获取部分退费后，需要收费的支付方式信息
	*/
	var _getPayInfo = function () {
		return new Promise(function (resolve, reject) {
			if (!(newPrtRowId > 0)) {
				return resolve();
			}
			payInfo = $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetNewInvPayMList", oldPrtRowId: invRowId, strikeRowId: strikeRowId, prtRowId: newPrtRowId, refundPayMode: refundMode}, false);
			return resolve();
		});
	};
	
	/**
	* 是否需要收银
	*/
	var _isNeedToPay = function () {
		return new Promise(function (resolve, reject) {
			if (!(newPrtRowId > 0)) {
				return resolve();
			}
			//部分退费后，患者支付大于退款金额时需要收银
			isNeedToPay = ($.m({ClassName: "web.DHCOPBillRefund", MethodName: "IsNeedPayAftRef", striRowId: strikeRowId, payInfo: payInfo}, false) == 1);
			return resolve();
		});
	};
	
	/**
	* 生成支付方式列表
	* 如果有第三方支付也在此方法中完成
	*/
	var _buildPayMList = function() {
		return new Promise(function (resolve, reject) {
			if (!isNeedToPay) {
				return resolve();    //不需要收银
			}
			var invAmtInfo = getInvAmtInfo(newPrtRowId);
			var aryAmt = invAmtInfo.split("^");
		    var totalAmt = aryAmt[0];
		    var discAmt = aryAmt[1];
		    var payorAmt = aryAmt[2];
		    var patShareAmt = aryAmt[3];
		    var insuAmt = aryAmt[4];
		    var payAmt = Number(patShareAmt).sub(insuAmt).toFixed(2); //自费支付额
		    if (payAmt == 0) {
		        return resolve();     //无需自费支付时，直接确认完成
		    }
		    var argumentObj = {
		        title: "收银台-门诊退费重收",
		        cardNo: cardNo,
		        cardTypeId: cardTypeId,
		        accMRowId: accMRowId,
		        accMLeft: accMLeft,
		        patientId: patientId,
		        episodeIdStr: admStr,
		        insTypeId: insTypeId,
		        typeFlag: "FEE",
		        prtRowIdStr: newPrtRowId,
		        totalAmt: totalAmt,
		        discAmt: discAmt,
		        payorAmt: payorAmt,
		        patShareAmt: patShareAmt,
		        insuAmt: insuAmt,
		        payAmt: payAmt,
		        bizType: "OP"
		    };
		    BILL_INF.showCheckout(argumentObj).then(function (payMList) {
			    payInfo = payMList;
		        resolve();
		    }, function () {
			    $.messager.alert("提示", "收银失败，请在【门诊收费异常处理】界面处理。", "error", function() {
				    reject();
				});
		    });
		});
	};
	
	/**
	* 确认完成
	*/
	var _complete = function() {
		return new Promise(function (resolve, reject) {
			if (!(newPrtRowId > 0)) {
				return resolve();    //没用新发票记录时按成功返回
			}
			var fairType = "";
			var actualMoney = "";
			var change = "";
			var roundErr = "";
			var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + accMRowId;
			expStr += "^" + GV.InvRequireFlag + "^" + fairType + "^" + actualMoney + "^" + change + "^" + roundErr;
			expStr += "^" + newInsType;
			var rtn = $.m({
				ClassName: "web.DHCBillConsIF",
				MethodName: "CompleteCharge",
				CallFlag: 3,
				Guser: PUBLIC_CONSTANT.SESSION.USERID,
				InsTypeDR: curInsType,
				PrtRowIDStr: newPrtRowId,
				SFlag: 1,
				OldPrtInvDR: invRowId,
				ExpStr: expStr,
				PayInfo: payInfo
			}, false);
			if (rtn != 0) {
				chargeErrorTip("completeError", rtn);
				return reject();
			}
			resolve();
		});
	};
	
	/**
	* 调用第三方退费接口 DHCBillPayService.js
	*/
	var _refSrv = function() {
		return new Promise(function (resolve, reject) {
			var tradeType = "OP";
			var prtInvId = (!isNeedToPay) ? newPrtRowId : "";  //+2022-11-29 ZhYW 如果收银了，则需要将原票全退
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
			refSrvRtnObj = RefundPayService(tradeType, invRowId, strikeRowId, prtInvId, "", tradeType, expStr);
			resolve();
		});
	};
	
	/**
	* 确认完成成功
	*/
	var _success = function() {
		if (refInvFlag == "Y") {
			billPrintTask(strikeRowId);
		}
		billPrintTask(newPrtRowId);
		
		//提示信息
		var msg = isPassNo ? "过号重打发票成功" : "退费成功";
		var iconCls = "success";
		if (!$.isEmptyObject(refSrvRtnObj) && (refSrvRtnObj.ResultCode != 0)) {
			msg = $g("HIS退费成功，第三方退款失败：") + refSrvRtnObj.ResultMsg + $g("，错误代码：") + refSrvRtnObj.ResultCode + $g("，请补交易");
			iconCls = "error";
		}
		var invStr = invRowId + ":" + "PRT";
		var refMsg = getRefInfoHTML(invStr);
		if (refMsg) {
			msg = "<p class=\"fail-Cls\">" + msg + "</p>";
			msg += refMsg;
		}
		$.messager.alert("提示", msg, iconCls, function() {
			if (GV.IsDirRefAudited == 1) {
				var diffAmt = _getReChgAmt();
				if (diffAmt > 0) {
					$.messager.alert("提示", ("<p class=\"fail-Cls\">患者还需交款 " + diffAmt + " 元，请继续收费</p>"), "info", function() {
						var url = "dhcbill.opbill.charge.main.csp?SelectPatRowId=" + patientId + "&SelectAdmRowId=" +  admStr;
						websys_showModal({
							url: url,
							title: '门诊收费',
							iconCls: 'icon-w-inv',
							width: $(window).width() - 20,
							height: $(window).height() - 50
						});
					});
				}
			}
		});
	};
	
	/**
	* 确认完成失败，撤销第三方交易
	*/
	var _fail = function() {
		var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
		$.each(payInfo.split(PUBLIC_CONSTANT.SEPARATOR.CH2), function(index, item) {
			if (item) {
				var myPayMAry = item.split("^");
				var myETPRowID = myPayMAry[11];
				if (myETPRowID) {
					var rtnValue = CancelPayService(myETPRowID, expStr);
					if (rtnValue.ResultCode != 0){
						$.messager.popover({msg: "第三方支付撤销失败，请联系工程师处理", type: "error"});
					}
				}
			}
		});
	};
	
	/**
	* 直接退费审核过的发票，全部退费时，提示还需交款的金额
	*/
	var _getReChgAmt = function() {
		var patShareAmt = getPropValById("DHC_INVPRT", invRowId, "PRT_PatientShare");
		var ordRefundAmt = getValueById("ordRefundAmt");
		var diffAmt = Number(patShareAmt).sub(ordRefundAmt).toFixed(2);
		return diffAmt;
	};
	
	if ($("#btn-refund").linkbutton("options").disabled) {
		return;
	}
	$("#btn-refund").linkbutton("disable");
	
	var cardNo = getValueById("CardNo");
	var cardTypeId = getValueById("CardTypeRowId");
	var patientId = getValueById("patientId");
	var accMRowId = getValueById("accMRowId");
	var accMLeft = getAccMLeft();   //账户余额
	var refundMode = getValueById("refundMode");
	var refModeCode = getPropValById("CT_PayMode", refundMode, "CTPM_Code");
	var refundAmt = getValueById("refundAmt");
	var invPayment = getValueById("invPayment");
	
	var newInsType = getValueById("newInsType");
	var curInsType = getValueById("insTypeId");
	var insTypeId = newInsType || curInsType;
	var admSource = getPropValById("PAC_AdmReason", insTypeId, "REA_AdmSource");
	var curAdmSource = getPropValById("PAC_AdmReason", curInsType, "REA_AdmSource");
	
	var insuDivId = getValueById("insuDivId");
	var insuAdmType = getValueById("insuAdmType");  //医疗类别
	var insuDicCode = getValueById("insuDic");      //病种编码
	var insuDicDesc = $("#insuDic").combobox("getText");

	var invRowId = "";          //DHC_INVPRT.RowId
	var invFlag = "";
	var accPInvId = "";         //DHC_AccPayInv.RowId
	var admStr = "";            //就诊RowId(多个之间以"^"分隔)
	
	var patPayAmt = 0;          //重收金额
	
	var invOrderStr = getInvOrderStr();   //待退费医嘱
	var isPassNo = false;   //是否过号重打(true:是, false:否)
	
	var newPrtRowId = "";       //新票RowId
	var strikeRowId = "";       //负票RowId
	var refInvFlag = "";        //是否打印负发票标识
	
	var isNeedToPay = false;     //是否需要收银标识(自费支付)

	var payInfo = "";
	
	var refSrvRtnObj = {};         //第三方退费返回对象

	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_insuPark)
		.then(_refund)
		.then(_insuDiv)
		.then(_getPayInfo)
		.then(_isNeedToPay)
		.then(_buildPayMList)
		.then(_complete)
		.then(_refSrv)
		.then(function() {
			_success();
		}, function() {
			_fail();
			$("#btn-refund").linkbutton("enable");
		});
}

/**
* 根据发票获取就诊
*/
function getAdmByPrtRowId(prtRowIdStr) {
	return $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetAdmByPrtRowId", prtRowIdStr: prtRowIdStr}, false);
}

/**
* 获取结算发票信息
*/
function getInvAmtInfo(prtRowIdStr) {
	return $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetInvAmtData", prtRowIdStr: prtRowIdStr}, false);
}

/**
* 获取退费医嘱
*/
function getInvOrderStr() {
	var refOrdAry = [];
	GV.ReBillFlag = 0;
	if (GV.OEItmList.getChecked().length != GV.OEItmList.getRows().length) {
		GV.ReBillFlag = 1;
	}
	$.each(GV.OEItmList.getChecked(), function (index, row) {
		if (row.isAppRep != "Y") {
			if (+row.refQty != +row.billQty) {
				GV.ReBillFlag = 1;
			}
		}else {
			if (+row.refQty == 1) {
				GV.ReBillFlag = 1;
			}
		}
		refOrdAry.push(row.oeori);
	});
	return refOrdAry.join("^");
}

/**
* 多种支付方式弹窗
*/
function updatePayment(oldPrtRowId, refPrtRowIdStr) {
	$("#refPaymWin").show().dialog({
		iconCls: 'icon-w-paid',
		title: '多种支付退费',
		draggable: false,
		modal: true,
		closable: false
	});
	initWinMenu(oldPrtRowId, refPrtRowIdStr);
}

/**
* 原号重打
*/
function invReprt() {
	var row = GV.InvList.getSelected();
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var invFlag = row.invFlag;
	if (!invRowId || (invFlag == "API")) {
		return;
	}
	var invNo = row.invNo;
	if (!invNo) {
		$.messager.popover({msg: "没有打印发票，不能重打", type: "info"});
		return;
	}
	var prtFlag = getPropValById("DHC_INVPRT", invRowId, "PRT_Flag");
	if (prtFlag != "N") {
		$.messager.popover({msg: "该发票已退费，不能重打", type: "info"});
		return;
	}
	$.messager.confirm("确认", $g("是否确认将发票") +"【<font color='red'>" + invNo + "</font>】" + $g("重新打印? "), function (r) {
		if (!r) {
			return;
		}
		billPrintTask(invRowId);
	});
}

/**
* 补调医保
*/
function invReInsuDivide() {
	var _validate = function () {
		return new Promise(function (resolve, reject) {
			var row = GV.InvList.getSelected();
			if (!row) {
				return reject();
			}
			invRowId = row.invRowId;
			invFlag = row.invFlag;
			if (!invRowId || (invFlag == "API")) {
				return reject();
			}
			if (getValueById("insuDivId")) {
				$.messager.popover({msg: "该记录已经医保结算，不能再补调", type: "info"});
				return reject();
			}
			var jsonObj = getPersistClsObj("User.DHCINVPRT", invRowId);
			if (jsonObj.PRTFlag != "N") {
				$.messager.popover({msg: "该记录已退费，不能补调医保", type: "info"});
				return reject();
			}
			if (jsonObj.PRTDHCINVPRTRDR > 0) {
				$.messager.popover({msg: "该记录已做日结账，不能补调医保", type: "info"});
				return reject();
			}
			if (jsonObj.PRTUsr != PUBLIC_CONSTANT.SESSION.USERID) {
				$.messager.popover({msg: "非您本人的收费记录，不能补调医保", type: "info"});
				return reject();
			}
			if (CV.INVYBConFlag != 1) {
				$.messager.popover({msg: "配置不连接医保，请检查门诊系统参数配置", type: "info"});
				return reject();
			}
			if (!(newAdmSource > 0)) {
				$.messager.popover({msg: "请选择医保费别进行补调医保", type: "info"});
				return reject();
			}
			resolve();
		});
	};
		
	var _cfr = function () {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认补调医保? ", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	/**
	* 医保结算
	*/
	var _insuDiv = function () {
		return new Promise(function (resolve, reject) {
			//调用医保接口
			var myYBHand = "";
			var myCPPFlag = "";
			var strikeFlag = "S";    //补掉医保接口时传"S"
			var insuNo = "";
			var cardType = "";
			var YLLB = insuDicDesc;
			var DicCode = getValueById("insuDic");
			var DicDesc = $("#insuDic").combobox("getText");
			var DYLB = "";
			var chargeSource = "01";
			var DBConStr = "";       //数据库连接串
			var selPaymId = (invPayment == "N") ? refundMode : "";
			var moneyType = "";
			var leftAmt = "";
			if (refModeCode != "CPP") {
				myCPPFlag = "NotCPPFlag";
			}else {
				leftAmt = accMLeft;
			}
			var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
			myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource;
			myExpStr += "^" + DBConStr + "^" + DYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + leftAmt + "^" + moneyType;
			var rtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, invRowId, newAdmSource, newInsType, myExpStr, myCPPFlag);
			var myAry = rtn.split("^");
			if (myAry[0] != 0) {
				return reject();
			}
			resolve();
		});
	};
	
	var _updateInv = function () {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "web.udhcOPRefEditIF",
				MethodName: "UpdateInvInsuDiv",
				prtRowId: invRowId,
				insTypeId: newInsType,
				userId: PUBLIC_CONSTANT.SESSION.USERID
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] != 0) {
					$.messager.alert("提示", "更新发票失败，请联系管理员修改发票费别", "error");
					return resolve();
				}
				$.messager.alert("提示", "补调医保成功，请退款: " + myAry[1] + "元", "success"); //此处提示不考虑多种支付方式
				reject();
			});
		});
	};
	
	var _success = function () {
		//获取医保结算Id
		var insuDivId = getPropValById("DHC_INVPRT", invRowId, "PRT_InsDiv_DR");
		setValueById("insuDivId", insuDivId);
	};
	
	if ($("#btn-reInsuDivide").linkbutton("options").disabled) {
		return;
	}
	$("#btn-reInsuDivide").linkbutton("disable");
	
	var accMRowId = getValueById("accMRowId");
	var accMLeft = getAccMLeft();   //账户余额
	
	var refundMode = getValueById("refundMode");
	var refModeCode = getPropValById("CT_PayMode", refundMode, "CTPM_Code");
	var invPayment = getValueById("invPayment");
	
	var newInsType = getValueById("newInsType");
	var newAdmSource = getPropValById("PAC_AdmReason", newInsType, "REA_AdmSource");

	var invRowId = "";          //DHC_INVPRT.RowId
	var invFlag = "";

	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_insuDiv)
		.then(_updateInv)
		.then(function() {
			_success();
		}, function () {
			$("#btn-reInsuDivide").linkbutton("enable");
		});
}

/**
* 撤销留观结算
*/
function cancleStayCharge() {
	var _validate = function () {
		return new Promise(function (resolve, reject) {
			var row = GV.InvList.getSelected();
			if (!row) {
				return reject();
			}
			invRowId = row.invRowId;
			invFlag = row.invFlag;
			if ((invFlag == "API") && (row.prtRowId > 0)) {    //集中打印发票撤销时按小条撤销，在撤销留观程序中撤消集中打印发票
				accPInvId = invRowId;
				invRowId = row.prtRowId;
				invFlag = "PRT";
			}
			if (!invRowId || (invFlag == "API")) {
				return reject();
			}
			var stayFlag = getPropValById("DHC_INVPRT", invRowId, "PRT_StayFlag");
			if (stayFlag != "Y") {
				$.messager.popover({msg: "非留观发票，不能撤销", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function () {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认撤销留观结算? ", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	/**
	* 医保退费
	*/
	var _insuPark = function() {
		return new Promise(function (resolve, reject) {
			var insuDivId = getValueById("insuDivId");
			if (!(insuDivId > 0)) {
				return resolve();
			}
			if (CV.INVYBConFlag != 1) {
				$.messager.popover({msg: "配置不连接医保，请检查门诊系统参数配置", type: "info"});
				return reject();
			}
			var myYBHand = "";
			var myCPPFlag = "";
			var strikeFlag = "S";
			var insuNo = "";
			var cardType = "";
			var YLLB = "";
			var DicCode = "";
			var DicDesc = "";
			var DYLB = "";
			var chargeSource = "01";
			var leftAmt = "";
			var moneyType = "";
			var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
			myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource + "^" + DYLB;
			myExpStr += "^" + "" + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "!" + leftAmt + "^" + moneyType;
			var rtn = DHCWebOPYB_ParkINVFYB(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, insuDivId, curAdmSource, curInsType, myExpStr, myCPPFlag);
			if (rtn != 0) {
				$.messager.popover({msg: "医保退费失败，错误代码：" + rtn, type: "info"});
				return reject();
			}
			return resolve();
		});
	};
	
	/**
	* 撤销留观结算
	*/
	var _cancel = function() {
		return new Promise(function (resolve, reject) {
			var expStr = accPInvId + "^";
			$.m({
				ClassName: "web.DHCOPBillStayCharge",
				MethodName: "StayChargeCancel",
				prtRowId: invRowId,
				sessionStr: getSessionStr(),
				expStr: expStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					newPrtRowId = myAry[1] || "";    //新票RowId
					strikeRowId = myAry[2] || "";    //负票RowId
					return resolve();
				}
				$.messager.alert("提示", "撤销失败：" + (myAry[1] || myAry[0]), "error");
				reject();
			});
		});
	};
	
	/**
	* 调用第三方退费接口 DHCBillPayService.js
	*/
	var _refSrv = function() {
		return new Promise(function (resolve, reject) {
			var tradeType = "OP";
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
			refSrvRtnObj = RefundPayService(tradeType, invRowId, strikeRowId, newPrtRowId, "", tradeType, expStr);
			resolve();
		});
	};
	
	var _success = function() {
		var msg = "撤销结算成功";
		var iconCls = "success";
		if (!$.isEmptyObject(refSrvRtnObj) && (refSrvRtnObj.ResultCode != 0)) {
			msg = $g("HIS撤销结算成功，第三方退款失败：") + refSrvRtnObj.ResultMsg + $g("，错误代码：") + refSrvRtnObj.ResultCode + $g("，请补交易");
			iconCls = "error";
		}
		$.messager.alert("提示", msg, iconCls);
		disablePageBtn();
	};
	
	if ($("#btn-cancleStayCharge").linkbutton("options").disabled) {
		return;
	}
	$("#btn-cancleStayCharge").linkbutton("disable");
	
	var curInsType = getValueById("insTypeId");
	var curAdmSource = getPropValById("PAC_AdmReason", curInsType, "REA_AdmSource");

	var invRowId = "";
	var invFlag = "";
	var accPInvId = "";
	var newPrtRowId = "";    //新票RowId
	var strikeRowId = "";    //负票RowId
	var refSrvRtnObj = {};   //第三方退费返回对象
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_insuPark)
		.then(_cancel)
		.then(_refSrv)
		.then(function() {
			_success();
		}, function () {
			$("#btn-cancleStayCharge").linkbutton("enable");
		});
}

function billPrintTask(prtInvIdStr) {
	GV.INVXMLName = CV.INVXMLName;
	$.m({
		ClassName: "web.UDHCOPGSPTEdit",
		MethodName: "GetPrtListByGRowID",
		GPRowID: PUBLIC_CONSTANT.SESSION.GROUPID,
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		PrtType: "CP"
	}, function(rtn) {
		var myAry = rtn.split(PUBLIC_CONSTANT.SEPARATOR.CH1);
		if (myAry[0] == "Y") {
			billPrintList(myAry[1], prtInvIdStr);
			getXMLConfig(GV.INVXMLName);
			return;
		}
		invPrint(prtInvIdStr);
	});
}

function billPrintList(prtTaskStr, prtInvIdStr) {
	var myTListAry = prtTaskStr.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
	$.each(myTListAry, function(index, myTStr) {
		if (myTStr) {
			var myAry = myTStr.split("^");
			var myPrtXMLName = myAry[0];
			GV.INVXMLName = myPrtXMLName;
			var myClassName = myAry[1];
			var myMethodName = myAry[2];
			if ((myAry[3] == "") || (myAry[3] == "XML")) {
				if (myPrtXMLName) {
					getXMLConfig(myPrtXMLName);
					commBillPrint(prtInvIdStr, myClassName, myMethodName);
				}
			}
		}
	});
}

function commBillPrint(prtInvIdStr, className, methodName) {
	var myAry = prtInvIdStr.split("^");
	$.each(myAry, function(index, id) {
		if (id) {
			var paymDesc = "";
			var myExpStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadCommOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", className, methodName, GV.INVXMLName, id, PUBLIC_CONSTANT.SESSION.USERID, paymDesc, myExpStr);
		}
	});
}

function invPrint(prtInvIdStr) {
	if (!GV.INVXMLName) {
		return;
	}
	var myAry = prtInvIdStr.split("^");
	$.each(myAry, function(index, id) {
		if (id) {
			//根据实际发票的收费类别查找模板名称
			var tmpPrtXMLName = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPrtXMLName", prtRowID: id, patType: "O", defaultXMLName: GV.INVXMLName}, false);
			getXMLConfig(tmpPrtXMLName);    //此处只修改调用模板, 不需要修改PrtXMLName
			var paymDesc = $("#refundMode").combobox("getText");
			var myExpStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", GV.INVXMLName, id, PUBLIC_CONSTANT.SESSION.USERCODE, paymDesc, myExpStr);
		}
	});
}
