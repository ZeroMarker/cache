/**
 * FileName: dhcbill.opbill.refund.inv.js
 * Anchor: ZhYW
 * Date: 2019-04-23
 * Description: 普通门诊发票退费
 */

/**
* 普通发票退费
*/
function invRefSaveInfo() {
	var row = $("#invList").datagrid("getSelected");
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var prtRowId = row.prtRowId;
	var invFlag = row.invFlag;
	var accPInvId = "";    //集中打印发票RowId
	if ((invFlag == "API") && prtRowId) {    //集中打印发票自动撤销时按小条退费，在退费程序中撤消集中打印发票
		accPInvId = invRowId;
		invRowId = prtRowId;
		invFlag = "PRT";
	}
	if (!invRowId || (invFlag == "API")) {
		return;
	}
	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCINVPRT", id: invRowId}, false);
	if (jsonObj.PRTFlag != "N") {
		$.messager.popover({msg: "该发票已退费，不能退费", type: "info"});
		return;
	}
	var rtn = $.m({ClassName: "web.DHCOPBillChargExcepiton", MethodName: "JudgeINVTPFlag", PrtRowid: invRowId, ExpStr: ""}, false);
	if (+rtn != 0) {
		$.messager.popover({msg: "有未处理的异常发票，请先处理后在退费", type: "info"});
		return;
	}
	//增加判断发票里退费数量大于收费数量时不能结算
	var rtn = $.m({ClassName: "web.DHCOPBillRefund", MethodName: "CheckOENegativeNum", PrtRowid: invRowId}, false);
	if (+rtn > 0) {
		$.messager.popover({msg: "退费数量大于收费数量请核实", type: "info"});
		return;
	}
	var newInsType = getValueById("newInsType");
	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.PACAdmReason", id: newInsType}, false);
	var newAdmSource = jsonObj.REAAdmSource;
	var curInsType = getValueById("insTypeId");
	jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.PACAdmReason", id: curInsType}, false);
	var curAdmSource = jsonObj.REAAdmSource;
	
	var msg = "是否确认退费? ";
	var invStr = invRowId + ":" + invFlag;
	var invIsOPToIP = $.m({ClassName: "web.DHCOPBillEmergTrans2IP", MethodName: "CheckInvIsOPToIP", invStr: invStr}, false);
	if (invIsOPToIP == "1") {
		msg = "有医嘱已转入住院，退费后转入的医嘱将不能撤回，是否确认退费? ";
	}
	$.messager.confirm("确认", msg, function (r) {
		if (r) {
			if ((newInsType != "") && (newInsType != curInsType)) {
				$.messager.confirm("确认", "重新收费的收费类别发生变化，是否确认退费? ", function (r) {
					if (r) {
						_linkRefund();
					}
				});
			}else {
				_linkRefund();
			}
		}
	});
	
	function _linkRefund() {
		var invOrderStr = getInvOrderStr();
		if (!invOrderStr) {
			$.messager.confirm("确认", "没有需要退费的医嘱，是否确认过号重打发票? ", function (r) {
				if (r) {
					_refund();
				}
			});
		}else {
			_refund();
		}
		
		function _refund() {
			var insuDivId = getValueById("insuDivId");
			if (insuDivId != "") {
				if (GV.INVYBConFlag == "0") {
					$.messager.popover({msg: "配置不连接医保，请检查门诊系统参数配置", type: "info"});
					return;
				} else {
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
					var myYBRtn = DHCWebOPYB_ParkINVFYB(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, insuDivId, curAdmSource, curInsType, myExpStr, myCPPFlag);
					if (myYBRtn != "0") {
						$.messager.popover({msg: "医保发票冲票错误，不能退费，请联系管理员", type: "info"});
						return;
					}
				}
				var insuInfo = $.m({ClassName: "web.DHCINSUPort", MethodName: "CheckINSUDivFlag", InvPrtDr: invRowId, PBDr: "", JustThread: "", CPPFlag: "", DivFlag: "S"}, false);
				var myAry = insuInfo.split("!");
				if (myAry[0] != "Y") {
					$.messager.popover({msg: "医保退费失败，请稍后重退", type: "info"});
					return;
				}
			}
			
			var patPayAmt = numCompute(row.patShareAmt, getValueById("refundAmt"), "-");  //重收金额
			var refundMode = getValueById("refundMode");
			var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.CTPayMode", id: refundMode}, false);
			var refmodeCode = jsonObj.CTPMCode;
			var invPayment = getValueById("invPayment");
			var myExpStr = invPayment + "^^^^" + accPInvId;
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
				myExpStr: myExpStr
			}, function(refRtn) {
				var refAry = refRtn.split("^");
				if (+refAry[0] == 0) {
					var newPrtRowId = "";    //新票RowId
					var strikeRowId = "";    //负票RowId
					var refInvFlag = "N";
					if (refAry.length > 1) {
						newPrtRowId = refAry[1];
						strikeRowId = refAry[2];
						refInvFlag = refAry[3];
					}
					if ((GV.INVYBConFlag == "1") && ((insuDivId != "") || (+newAdmSource > 0)) && (newPrtRowId != "")) {
						var myYBHand = "";
						var myCPPFlag = "";
						var strikeFlag = "S";
						var insuNo = "";
						var cardType = "";
						var YLLB = getValueById("insuAdmType");
						var DicCode = getValueById("insuDic");
						var DicDesc = $("#insuDic").combobox("getText");
						var DYLB = "";
						var chargeSource = "01";
						var DBConStr = "";       //数据库连接串
						var moneyType = "";
						var selPaymId = (invPayment == "N") ? refundMode : "";
						var accMRowId = getValueById("accMRowId");
						var leftAmt = "";
						if (accMRowId) {
							leftAmt = $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "getAccBalance", Accid: accMRowId}, false);
						}
						if (refmodeCode != "CPP") {
							leftAmt = "";
							myCPPFlag = "NotCPPFlag";
						}
						var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
						myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource;
						myExpStr += "^" + DBConStr + "^" + DYLB + "^" + getValueById("accMRowId") + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + leftAmt + "^" + moneyType;
						var myYBRtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, newPrtRowId, newAdmSource, newInsType, myExpStr, myCPPFlag);
						var myYBAry = myYBRtn.split("^");
						if (myYBAry[0] == "YBCancle") {
							return;
						}
						if (myYBAry[0] == "HisCancleFailed") {
							$.messager.alert("提示", "医保取消结算成功，但HIS系统取消结算失败", "error");
							return;
						}
					}
					
					completeCharge(invRowId, refRtn);
					/*
					if ((invPayment == "Y") && (invOrderStr != "") && (newPrtRowId != "")) {
						updatePayment(invRowId, refRtn);
					}else {
						completeCharge(invRowId, refRtn);
					}
					*/
				}else {
					var myAry = refAry[0].split(PUBLIC_CONSTANT.SEPARATOR.CH3);
					var errCode = myAry[0];
					var job = (myAry.length > 1) ? myAry[1] : "";
					chargeErrorTip("refundError", errCode, job);
				}
			});
		}
	}
}

/**
* 门诊收费确认完成
*/
function completeCharge(oldPrtRowId, refRtn) {
	
	var newPrtRowId = "";    //新票RowId
	var strikeRowId = "";    //负票RowId
	var refInvFlag = "N";
	
	var myAry = refRtn.split("^");
	if (myAry.length > 1) {
		newPrtRowId = myAry[1];
		strikeRowId = myAry[2];
		refInvFlag = myAry[3];
	}
	var newInsType = getValueById("newInsType");
	
	if (newPrtRowId != "") {
		
		//20200602 Lid 获取新发票支付方式列表
		var myPayInfo = $.m({ClassName: "web.DHCBillConsIF", MethodName: "GetNewInvPayMList", oldPrtRowId: oldPrtRowId, strikeRowId: strikeRowId, prtRowId: newPrtRowId, refundPayMode: getValueById("refundMode")}, false);
		
		//调用确认完成方法
		var accMRowId = getValueById("accMRowId");
		var myExpStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + accMRowId;
		myExpStr += "^" + GV.InvRequireFlag + "^" + "" + "^" + "" + "^" + "" + "^" + "";
		myExpStr += "^" + newInsType;
		var rtn = $.m({
			ClassName: "web.DHCBillConsIF",
			MethodName: "CompleteCharge",
			CallFlag: 3,
			Guser: PUBLIC_CONSTANT.SESSION.USERID,
			InsTypeDR: getValueById("insTypeId"),
			PrtRowIDStr: newPrtRowId,
			SFlag: 1,
			OldPrtInvDR: oldPrtRowId,
			ExpStr: myExpStr,
			PayInfo: myPayInfo
		}, false);
		if (rtn != "0") {
			chargeErrorTip("completeError", rtn);
			disablePageBtn();
			return;
		}
	}
	var insuDivId = getValueById("insuDivId");
	if ((GV.INVYBConFlag == "1") && (insuDivId != "")) {
		$.m({
			ClassName: "web.udhcOPBillIF",
			MethodName: "ReadParkSum",
			PRTRowID: oldPrtRowId,
			ExpStr: ""
		}, function(rtn) {
			setValueById("factRefundAmt", rtn);
		});
	}
	//更新中间表
	$.m({ClassName: "web.udhcOPPHARWIN", MethodName: "UpdateRETFLAG", PRTRowIDStr: newPrtRowId + "^" + strikeRowId});
	
	//第三方退费接口 DHCBillPayService.js
	var tradeType = "OP";
	var refundAmt = "";
	var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^^";
	var rtnValue = RefundPayService(tradeType, oldPrtRowId, strikeRowId, newPrtRowId, refundAmt, "OP", expStr);
	var msg = "退费成功";
	var iconCls = "success";
	if (rtnValue.rtnCode != "0") {
		msg = "HIS退费成功，第三方退费失败：" + rtnValue.rtnMsg + "，错误代码：" + rtnValue.rtnCode + "，请补交易";
		iconCls = "error";
	}
	//
	$.messager.alert("提示", msg, iconCls);
	if (refInvFlag == "Y") {
		billPrintTask(strikeRowId);
	}
	billPrintTask(newPrtRowId);
	disablePageBtn();
	return;
}

/**
* 获取退费医嘱
*/
function getInvOrderStr() {
	GV.RefOrdAry = [];
	GV.ReBillFlag = 0;
	var myAry = [];
	if (GV.OrdGridObj.getChecked().length != GV.OrdGridObj.getRows().length) {
		GV.ReBillFlag = 1;
	}
	$.each(GV.OrdGridObj.getChecked(), function (index, row) {
		if (row.isAppRepFlag != "Y") {
			if (+row.refQty != +row.billQty) {
				GV.ReBillFlag = 1;
			}
		}else {
			if (+row.refQty == 1) {
				GV.ReBillFlag = 1;
			}
		}
		GV.RefOrdAry.push(row.oeori);
	});
	return GV.RefOrdAry.join("^");
}

/**
* 多种支付方式弹窗
*/
function updatePayment(oldPrtRowId, refRtn) {
	$("#refPaymWin").show().dialog({
		iconCls: 'icon-w-paid',
		title: '多种支付退费',
		draggable: false,
		modal: true,
		closable: false
	});
	initWinMenu(oldPrtRowId, refRtn);
}

/**
* 原号重打
*/
function invReprt() {
	var row = $("#invList").datagrid("getSelected");
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
	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCINVPRT", id: invRowId}, false);
	if (jsonObj.PRTFlag != "N") {
		$.messager.popover({msg: "该发票已退费，不能重打", type: "info"});
		return;
	}
	$.messager.confirm("确认", "是否确认将发票【<font color='red'>" + invNo + "</font>】重新打印? ", function (r) {
		if (r) {
			billPrintTask(invRowId);
		}
	});
}

/**
* 补调医保
*/
function invReInsuDivide() {
	var row = $("#invList").datagrid("getSelected");
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var invFlag = row.invFlag;
	if (!invRowId || (invFlag == "API")) {
		return;
	}
	if (getValueById("insuDivId")) {
		$.messager.popover({msg: "该发票已经医保结算，不能再补调", type: "info"});
		return;
	}
	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCINVPRT", id: invRowId}, false);
	if (jsonObj.PRTFlag != "N") {
		$.messager.popover({msg: "该发票已退费，不能补调医保", type: "info"});
		return;
	}
	if ((jsonObj.PRTDHCINVPRTRDR) || (jsonObj.PRTUsr != PUBLIC_CONSTANT.SESSION.USERID)) {
		$.messager.popover({msg: "收费员已结算或不是本人收据，不能补调医保", type: "info"});
		return;
	}
	if (GV.INVYBConFlag == "0")  {
		$.messager.popover({msg: "配置不连接医保，请检查门诊系统参数配置", type: "info"});
		return;
	}
	var newInsType = getValueById("newInsType");
	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.PACAdmReason", id: newInsType}, false);
	var newAdmSource = jsonObj.REAAdmSource;
	if (!(+newAdmSource > 0)) {
		$.messager.popover({msg: "请选择医保费别进行补调医保", type: "info"});
		return;
	}
	$.messager.confirm("确认", "是否确认补调医保? ", function (r) {
		if (r) {
			var refundMode = getValueById("refundMode");
			var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.CTPayMode", id: refundMode}, false);
			var refmodeCode = jsonObj.CTPMCode;
			var invPayment = getValueById("invPayment");
			//调用医保接口
			var myYBHand = "";
			var myCPPFlag = "";
			var strikeFlag = "S";    //补掉医保接口时传"S"
			var insuNo = "";
			var cardType = "";
			var YLLB = getValueById("insuAdmType");
			var DicCode = getValueById("insuDic");
			var DicDesc = $("#insuDic").combobox("getText");
			var DYLB = "";
			var chargeSource = "01";
			var DBConStr = "";       //数据库连接串
			var selPaymId = (invPayment == "N") ? refundMode : "";
			var moneyType = "";
			var accMRowId = getValueById("accMRowId");
			var leftAmt = ""; 
			if (accMRowId) {
				leftAmt = $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "getAccBalance", Accid: accMRowId}, false);
			}
			if (refmodeCode != "CPP") {
				leftAmt = "";
				myCPPFlag = "NotCPPFlag";
			}
			var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
			myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource;
			myExpStr += "^" + DBConStr + "^" + DYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + leftAmt + "^" + moneyType;
			var myYBRtn = DHCWebOPYB_DataUpdate(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, invRowId, newAdmSource, newInsType, myExpStr, myCPPFlag);
			var myYBAry = myYBRtn.split("^");
			if (myYBAry[0] == "0") {
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
						return;
					}else {
						$.messager.alert("提示", "补调医保成功，请退款: " + myAry[1] + "元", "success"); //此处提示不考虑多种支付方式
					}
					$.m({
						ClassName: "web.UDHCJFBaseCommon",
						MethodName: "GetPrtInsDivDR",
						PrtRowID: invRowId,
						PrtFlag: "PRT"
					}, function(myInsuDivId) {
						setValueById("insuDivId", myInsuDivId);
					});
				});
			}
		}
	});
}

/**
* 撤销留观结算
*/
function cancleStayCharge() {
	var row = $("#invList").datagrid("getSelected");
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var prtRowId = row.prtRowId;
	var invFlag = row.invFlag;
	var accPInvId = "";                      //集中打印发票RowId
	if ((invFlag == "API") && prtRowId) {    //集中打印发票撤销时按小条撤销，在撤销留观程序中撤消集中打印发票
		accPInvId = invRowId;
		invRowId = prtRowId;
		invFlag = "PRT";
	}
	if (!invRowId || (invFlag == "API")) {
		return;
	}
	var stayFlag = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPrtInvStat", PrtRowID: invRowId}, false);
	if (stayFlag != "Y") {
		$.messager.popover({msg: "非留观发票，不能撤销", type: "info"});
		return;
	}
	$.messager.confirm("确认", "是否确认撤销留观结算? ", function (r) {
		if (r) {
			var insTypeId = getValueById("insTypeId");
			var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.PACAdmReason", id: insTypeId}, false);
			var curAdmSource = jsonObj.REAAdmSource;
 			var insuDivId = getValueById("insuDivId");
			if (insuDivId != "") {
				if (GV.INVYBConFlag == "0") {
					$.messager.popover({msg: "配置不连接医保，请检查门诊系统参数配置", type: "info"});
					return;
				} else {
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
					var rtn = DHCWebOPYB_ParkINVFYB(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, insuDivId, curAdmSource, insTypeId, myExpStr, myCPPFlag);
					if (rtn != "0") {
						$.messager.popover({msg: "医保发票冲票错误，不能撤销，请联系管理员", type: "info"});
						return;
					}
				}
			}
			//撤销留观结算
			var expStr = accPInvId + "^";
			$.m({
				ClassName: "web.DHCOPBillStayCharge",
				MethodName: "StayChargeCancel",
				prtRowId: invRowId,
				guser: PUBLIC_CONSTANT.SESSION.USERID,
				groupDr: PUBLIC_CONSTANT.SESSION.GROUPID,
				ctLocDr: PUBLIC_CONSTANT.SESSION.CTLOCID,
				expStr: expStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == "0") {
					$.messager.alert("提示", "撤销成功", "success");
					disablePageBtn();
				}else {
					$.messager.alert("提示", "撤销失败：" + rtn, "error");
				}
			});
		}
	});
}

function billPrintTask(prtInvIdStr) {
	var myOldXmlName = GV.INVXMLName;
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
			GV.INVXMLName = myOldXmlName;
			getXMLConfig(GV.INVXMLName);
		} else {
			invPrint(prtInvIdStr);
		}
		GV.INVXMLName = myOldXmlName;
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
			var paymDesc = $("#refundMode").combobox("getText");
			var myExpStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadCommOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", className, methodName, GV.INVXMLName, id, PUBLIC_CONSTANT.SESSION.USERID, paymDesc, myExpStr);
		}
	});
}

function invPrint(prtInvIdStr) {
	if (GV.INVXMLName == "") {
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