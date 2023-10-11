/**
 * FileName: dhcbill.opbill.refund.accpinv.js
 * Author: ZhYW
 * Date: 2019-04-23
 * Description: 门诊集中打印发票退费
 */

/**
* 卡支付发票退费
*/
function accInvRefSaveInfo() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var row = GV.InvList.getSelected();
			if (!row) {
				return reject();
			}
			invRowId = row.invRowId;
			invFlag = row.invFlag;
			if (!invRowId || (invFlag != "API")) {
				return reject();
			}
			var jsonObj = getPersistClsObj("User.DHCAccPayINV", invRowId);
			if (jsonObj.APIFlag != "N") {
				$.messager.popover({msg: "该发票已退费，不能退费", type: "info"});
				return reject();
			}
			var patShareAmt = jsonObj.APIPatientShare;
			
			var accMLeft = getValueById("accMLeft");
			var insuPayAmt = getValueById("insuPayAmt");
			if (+accMLeft < +insuPayAmt) {
				$.messager.alert("提示", "请补交医保统筹额：" + Number(insuPayAmt).sub(accMLeft).toFixed(2) + "，否则不能退费.", "info");
				return reject();
			}
			if (refModeCode != "CPP") {
				$.messager.popover({msg: "集中打印发票退费时，退费支付方式必须是<font color=\"red\">预交金</font>", type: "info"});
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
			//+2022-03-29 ZhYW 判断是否做了直接退费审核
			if (GV.IsDirRefAudited == 1) {
				GV.ReBillFlag = 0;     //做了直接退费审核时，全部退费。
			}
			isPassNo = isPassNoReChg();
			
			if ((GV.ReBillFlag == 1) && (admSource > 0)) {
				//+2023-04-04 ZhYW 医保住院患者是否允许门诊部分退费
				var rtn = isAllowedIPPatPartRef(patientId);
				if (!rtn) {
					$.messager.popover({msg: "该患者正在住院，不能医保部分退费", type: "info"});
					return reject();
				}
			}
			patPayAmt = Number(patShareAmt).sub(refundAmt).toFixed(2); 	//重收金额
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
				$.messager.confirm("确认", "重新收费的收费类别发生变化，是否确认退费? ", function (r) {
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
			if (CV.AccPINVYBConFlag != 1) {
				$.messager.popover({msg: "配置不连接医保，请检查门诊系统参数配置", type: "info"});
				return reject();
			}
			var myYBHand = "0";
			var myExpStr = "^^^^";
			var CPPFlag = "Y";
			var rtn = InsuOPDivideStrike(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, insuDivId, curAdmSource, curInsType, myExpStr, CPPFlag);
			if (rtn != 0) {
				$.messager.popover({msg: "医保退费失败，错误代码：" + rtn, type: "info"});
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
			var autoFlag = getValueById("autoFlag");
			var myExpStr = "^^^^^" + autoFlag + "^" + newInsType;
			$.m({
				ClassName: "web.udhcOPRefEditIF",
				MethodName: "AccPayINVRefund",
				APIRowID: invRowId,
				PRTOrdStr: invOrderStr,
				rUser: PUBLIC_CONSTANT.SESSION.USERID,
				sFlag: getValueById("refBtnFlag"),
				gloc: PUBLIC_CONSTANT.SESSION.GROUPID,
				ULoadLocDR: PUBLIC_CONSTANT.SESSION.CTLOCID,
				RPayModeDR: refundMode,
				RefPaySum: refundAmt,
				RebillFlag: GV.ReBillFlag,
				ExpStr: myExpStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] != 0) {
					$.messager.alert("提示", ("退费失败：" + (myAry[1] || myAry[0])), "error");
					return reject();
				}
				
				disablePageBtn();

				newPrtRowId = myAry[1];
				pid = myAry[2];
				
				return resolve();
			});
		});
	};
	
	/**
	* 医保结算
	*/
	var _insuDiv = function () {
		return new Promise(function (resolve, reject) {
			if (!(pid > 0)) {
				return resolve();
			}
			if (CV.AccPINVYBConFlag != 1) {   //配置了不连接医保
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
			var rtn = accPInvInsuDiv(pid);    //医保分解
			if (!rtn) {
				return reject();
			}
			return resolve();
		});
	};
	
	/**
	* 退费完成
	*/
	var _complete = function() {
		return new Promise(function (resolve, reject) {
			if (newPrtRowId > 0) {
				accPInvPrint(newPrtRowId);
			}
			var msg = isPassNo ? "过号重打发票成功" : "退费成功";
			var iconCls = "success";
			var invStr = invRowId + ":" + "API";
			var refMsg = getRefInfoHTML(invStr);
			if (refMsg) {
				msg = "<p class=\"fail-Cls\">" + msg + "</p>";
				msg += refMsg;
			}
			$.messager.alert("提示", msg, iconCls, function() {
				if (GV.IsDirRefAudited == 1) {
					var diffAmt = _getReChgAmt();
					if (diffAmt > 0) {
						$.messager.alert("提示", ("<p class=\"fail-Cls\">患者还需交款 " + diffAmt + " 元，请继续收费</p>"), "info");
					}
				}
			});
		});
	};
	
	/**
	* 直接退费审核过的发票，全部退费时，提示还需交款的金额
	*/
	var _getReChgAmt = function() {
		var patShareAmt = getPropValById("DHC_AccPayINV", invRowId, "API_PatientShare");
		var ordRefundAmt = getValueById("ordRefundAmt");
		var diffAmt = Number(patShareAmt).sub(ordRefundAmt).toFixed(2);
		return diffAmt;
	};
	
	if ($("#btn-refund").linkbutton("options").disabled) {
		return;
	}
	$("#btn-refund").linkbutton("disable");
	
	var patientId = getValueById("patientId");
	var refundMode = getValueById("refundMode");
	var refModeCode = getPropValById("CT_PayMode", refundMode, "CTPM_Code");
	
	var newInsType = getValueById("newInsType");
	var curInsType = getValueById("insTypeId");
	var insTypeId = newInsType || curInsType;
	var admSource = getPropValById("PAC_AdmReason", insTypeId, "REA_AdmSource");
	var curAdmSource = getPropValById("PAC_AdmReason", curInsType, "REA_AdmSource");
	
	var insuDivId = getValueById("insuDivId");

	var invRowId = "";    //DHC_AccPayInv.RowId
	var invFlag = "";
	
	var refundAmt = getValueById("refundAmt");
	var patPayAmt = 0; 	 //重收金额

	var newPrtRowId = "";     //新票RowId
	var pid = "";             //退费重收生成的进程号
	
	var invOrderStr = getAccInvOrderStr();
	var isPassNo = false;   //是否过号重打(true:是,false:否)
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_insuPark)
		.then(_refund)
		.then(_insuDiv)
		.then(_complete, function () {
			$("#btn-refund").linkbutton("enable");
		});
}

/**
* 获取退费医嘱
*/
function getAccInvOrderStr() {
	GV.ReBillFlag = 0;
	var refInvOrdObj = {};
	if (GV.OEItmList.getChecked().length != GV.OEItmList.getRows().length) {
		GV.ReBillFlag = 1;
	}
	$.each(GV.OEItmList.getRows(), function (index, row) {
		refInvOrdObj[row.prtId] = refInvOrdObj[row.prtId] || "";
		if (getOrdItmRowChecked(index)) {
			if (row.isAppRep != "Y") {
				if (+row.refQty != +row.billQty) {
					GV.ReBillFlag = 1;
					refInvOrdObj[row.prtId + "REBILLFLAG"] = 1;
				}
			}else {
				if (+row.refQty == 1) {
					GV.ReBillFlag = 1;
					refInvOrdObj[row.prtId + "REBILLFLAG"] = 1;
				}
			}
			if (!refInvOrdObj[row.prtId]) {
				refInvOrdObj[row.prtId] = row.oeori;
			}else {
				refInvOrdObj[row.prtId] = refInvOrdObj[row.prtId] + "^" + row.oeori;
			}
			refInvOrdObj[row.prtId + "REFSUM"] = Number(refInvOrdObj[row.prtId + "REFSUM"] || 0).add(row.refAmt).toFixed(2);
		}else {
			GV.ReBillFlag = 1;
			refInvOrdObj[row.prtId + "REBILLFLAG"] = 1;
		}
	});
	
	var myAry = [];
	var reg = /[a-z]/i;
	var str;
	$.each(refInvOrdObj, function (key, value) {
		if (reg.test(key)) {
			return true;
		}
		str = key + PUBLIC_CONSTANT.SEPARATOR.CH3 + value;
		str += PUBLIC_CONSTANT.SEPARATOR.CH3 + (refInvOrdObj[key + "REBILLFLAG"] || 0);
		str += PUBLIC_CONSTANT.SEPARATOR.CH3 + (refInvOrdObj[key + "REFSUM"] || 0);
		myAry.push(str);
	});
	
	return myAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
}

/**
* 医保分解
*/
function accPInvInsuDiv(pid) {
	if (!pid) {
		return true;
	}
	var myYBHand = "0";
	var myCPPFlag = "Y";
	var strikeFlag = "N";
	var insuNo = "";
	var cardType = "";
	var YLLB = "";
	var DicCode = "";
	var DicDesc = "";
	var DYLB = "";
	var chargeSource = "01";
	var DBConStr = "";        //数据库连接串
	var leftAmt = "";
	var moneyType = "";
	var selPaymId = "";
	var newInsType = getValueById("newInsType");
	var newAdmSource = getPropValById("PAC_AdmReason", newInsType, "REA_AdmSource");
	var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
	myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource;
	myExpStr += "^" + DBConStr + "^" + DYLB + "^" + getValueById("accMRowId") + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + leftAmt + "^" + moneyType;
	var rtn = InsuOPDivide(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, pid, newAdmSource, newInsType, myExpStr, myCPPFlag);
	if (rtn != 0) {
		$.messager.alert("提示", "医保分解失败：" + rtn, "error");
		return false;
	}
	rtn = $.m({ClassName: "web.UDHCAccPrtPayFoot", MethodName: "UpdateAPIForYBDiv", TMPGID: pid, ExpStr: ""}, false);
	var myAry = rtn.split("^");
	if (myAry[0] == 0) {
		var refundAmt = getValueById("refundAmt");
		var myYBPayAmt = myAry[1];
		setValueById("factRefundAmt", Number(refundAmt).sub(myYBPayAmt).toFixed(2));
		return true;
	}
	$.messager.alert("提示", "更新医保的支付方式失败：" + rtn, "error");
	return false;
}

/**
* 原号重打
*/
function accInvReprt() {
	var row = GV.InvList.getSelected();
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var invFlag = row.invFlag;
	if (!invRowId || (invFlag != "API")) {
		return;
	}
	var invNo = row.invNo;
	if (!invNo) {
		$.messager.popover({msg: "没有打印发票，不能重打", type: "info"});
		return;
	}
	var prtFlag = getPropValById("DHC_AccPayINV", invRowId, "API_Flag");
	if (prtFlag != "N") {
		$.messager.popover({msg: "该发票已退费，不能重打", type: "info"});
		return;
	}
	$.messager.confirm("确认", $g("是否确认将发票") + "【<font color='red'>" + invNo + "</font>】" + $g("重新打印? "), function (r) {
		if (!r) {
			return;
		}
		accPInvPrint(invRowId);
	});
}

/**
* 补调医保
*/
function accInvReInsuDivide() {
	var _validate = function () {
		return new Promise(function (resolve, reject) {
			var row = GV.InvList.getSelected();
			if (!row) {
				return reject();
			}
			invRowId = row.invRowId;
			invFlag = row.invFlag;
			if (!invRowId || (invFlag != "API")) {
				return reject();
			}
			if (getValueById("insuDivId")) {
				$.messager.popover({msg: "该发票已经医保结算，不能再补调", type: "info"});
				return reject();
			}
			var jsonObj = getPersistClsObj("User.DHCAccPayINV", invRowId);
			if (jsonObj.APIFlag != "N") {
				$.messager.popover({msg: "该发票已退费，不能补调医保", type: "info"});
				return reject();
			}
			if (jsonObj.APIINVRepDR > 0) {
				$.messager.popover({msg: "该记录已做日结账，不能补调医保", type: "info"});
				return reject();
			}
			if (jsonObj.APIPUserDR != PUBLIC_CONSTANT.SESSION.USERID) {
				$.messager.popover({msg: "非您本人的打印记录，不能补调医保", type: "info"});
				return reject();
			}
			if (CV.AccPINVYBConFlag != 1) {
				$.messager.popover({msg: "配置不连接医保，请检查门诊系统参数配置", type: "info"});
				return reject();
			}
			if (!(newAdmSource > 0)) {
				$.messager.popover({msg: "请选择医保费别进行补调医保", type: "info"});
				return reject();
			}
			var writeOffFlag = $.m({ClassName: "web.DHCOPBillRefund", MethodName: "CheckWriteOffAPI", accPInvId: invRowId}, false);
			if (writeOffFlag == "Y") {
				$.messager.popover({msg: "非卡支付发票，不能补掉医保", type: "info"});
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
	
	var _getPID = function () {
		$.m({
			ClassName: "web.udhcOPRefEdit1",
			MethodName: "BuildInsuTmp",
			AccPInvID: invRowId,
			InsTypeID: newInsType
		}, function(pid) {
			accPInvInsuDiv(pid);    //医保分解
		});
	};
	
	if ($("#btn-reInsuDivide").linkbutton("options").disabled) {
		return;
	}
	$("#btn-reInsuDivide").linkbutton("disable");
	
	var newInsType = getValueById("newInsType");
	var newAdmSource = getPropValById("PAC_AdmReason", newInsType, "REA_AdmSource");
	
	var invRowId = "";
	var invFlag = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(function() {
			_getPID();
		}, function () {
			$("#btn-reInsuDivide").linkbutton("enable");
		});
}

function accPInvPrint(accPInvIdStr) {
	GV.AccPINVXMLName = CV.AccPINVXMLName;
	if (!GV.AccPINVXMLName) {
		return;
	}
	var myAry = accPInvIdStr.split("^");
	$.each(myAry, function(index, id) {
		if (id) {
			getXMLConfig(GV.AccPINVXMLName);
			var paymDesc = "";
			var myExpStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", GV.AccPINVXMLName, id, PUBLIC_CONSTANT.SESSION.USERCODE, paymDesc, myExpStr);
		}
	});
}
