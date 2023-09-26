/**
 * FileName: dhcbill.opbill.refund.accpinv.js
 * Anchor: ZhYW
 * Date: 2019-04-23
 * Description: 门诊集中打印发票退费
 */

/**
* 卡支付发票退费
*/
function accInvRefSaveInfo() {
	var row = $("#invList").datagrid("getSelected");
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var invFlag = row.invFlag;
	if (!invRowId || (invFlag != "API")) {
		return;
	}
	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCAccPayINV", id: invRowId}, false);
	if (jsonObj.APIFlag != "N") {
		$.messager.popover({msg: "该发票已退费，不能退费", type: "info"});
		return;
	}
	var accMBalance = getValueById("accMBalance");
	var insuPayAmt = getValueById("insuPayAmt");
	if (+accMBalance < +insuPayAmt) {
		$.messager.alert("提示", "请补交医保统筹额" + numCompute(insuPayAmt, accMBalance, "-") + "，否则不能退费.", "info");
		return;
	}
	var newInsType = getValueById("invInsType");
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
		var invOrderStr = getAccInvOrderStr();
		if (!GV.RefOrdAry.join("^")) {
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
				if (GV.AccPINVYBConFlag == "0") {
					$.messager.popover({msg: "配置不连接医保，请检查门诊系统参数配置", type: "info"});
					return;
				}else {
					var myYBHand = "0";
					var myExpStr = "^^1";
					var CPPFlag = "Y";
					var rtn = InsuOPDivideStrike(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, insuDivId, curAdmSource, curInsType, myExpStr, CPPFlag);
					if (rtn != "0") {
						$.messager.popover({msg: "医保发票冲票错误，不能退费，请联系管理员", type: "info"});
						return;
					}
				}
			}
			
			var refundMode = getValueById("refundMode");
			jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.CTPayMode", id: refundMode}, false);
			if (jsonObj.CTPMCode != "CPP") {
				$.messager.popover({msg: "集中打印发票退费时，退费支付方式必须是（<font color=red>预交金</font>）", type: "info"});
				return;
			}
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
				RefPaySum: getValueById("refundAmt"),
				RebillFlag: GV.ReBillFlag,
				ExpStr: myExpStr
			}, function(refRtn) {
				var myAry = refRtn.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
				if (myAry[0] == "0") {
					var newPrtRowId = myAry[1];
					var myCID = myAry[2];
					if ((GV.AccPINVYBConFlag == "1") && ((insuDivId != "") || (+newAdmSource > 0)) && (myCID != "")) {
						accPInvInsuDiv(myCID);    //医保分解
					}
					accPInvPrint(newPrtRowId);
					$.messager.alert("提示", "退费成功", "success");
					disablePageBtn();
					return;
				}else {
					switch (myAry[0]) {
					case "109":
						$.messager.alert("提示", "没有票据，不能退费", "info");
						break;
					default:
						$.messager.alert("提示", "退费失败：" + myAry[0], "info");
					}
					return;
				}
			});
		}
	}
}

/**
* 获取退费医嘱
*/
function getAccInvOrderStr() {
	GV.RefOrdAry = [];
	GV.ReBillFlag = 0;
	var refInvOrdObj = {};
	if (GV.OrdGridObj.getChecked().length != GV.OrdGridObj.getRows().length) {
		GV.ReBillFlag = 1;
	}
	$.each(GV.OrdGridObj.getRows(), function (index, row) {
		refInvOrdObj[row.prtId] = refInvOrdObj[row.prtId] || "";
		if (getOrdItmRowChecked(index)) {
			GV.RefOrdAry.push(row.oeori);   //退费的医嘱
			if (row.isAppRepFlag != "Y") {
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
			refInvOrdObj[row.prtId + "REFSUM"] = numCompute((refInvOrdObj[row.prtId + "REFSUM"] || 0), row.refAmt, "+");
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
function accPInvInsuDiv(myCID) {
	if (!myCID) {
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
	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.PACAdmReason", id: newInsType}, false);
	var newAdmSource = jsonObj.REAAdmSource;
	var myExpStr = strikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + insuNo + "^" + cardType;
	myExpStr += "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + leftAmt + "^" + chargeSource;
	myExpStr += "^" + DBConStr + "^" + DYLB + "^" + getValueById("accMRowId") + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + leftAmt + "^" + moneyType;
	console.log(myYBHand + "#" + PUBLIC_CONSTANT.SESSION.USERID + "#" + myCID + "#" + newAdmSource + "#" + newInsType + "#" + myExpStr + "#" + myCPPFlag);
	var rtn = InsuOPDivide(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, myCID, newAdmSource, newInsType, myExpStr, myCPPFlag);
	if (rtn != "0") {
		$.messager.alert("提示", "医保分解失败：" + rtn, "error");
		return false;
	}
	
	rtn = $.m({ClassName: "web.UDHCAccPrtPayFoot", MethodName: "UpdateAPIForYBDiv", TMPGID: myCID, ExpStr: ""}, false);
	var myAry = rtn.split("^");
	if (myAry[0] == "0") {
		var refundAmt = getValueById("refundAmt");
		var myYBPayAmt = myAry[1];
		setValueById("factRefundAmt", numCompute(refundAmt, myYBPayAmt, "-"));
		return true;
	}else {
		$.messager.alert("提示", "更新医保的支付方式失败：" + rtn, "error");
		return false;
	}
}

/**
* 原号重打
*/
function accInvReprt() {
	var row = $("#invList").datagrid("getSelected");
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
	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCAccPayINV", id: invRowId}, false);
	if (jsonObj.APIFlag != "N") {
		$.messager.popover({msg: "该发票已退费，不能重打", type: "info"});
		return;
	}
	$.messager.confirm("确认", "是否确认将发票【<font color='red'>" + invNo + "</font>】重新打印? ", function (r) {
		if (r) {
			accPInvPrint(invRowId);
		}
	});
}

/**
* 补调医保
*/
function accInvReInsuDivide() {
	var row = $("#invList").datagrid("getSelected");
	if (!row) {
		return;
	}
	var invRowId = row.invRowId;
	var invFlag = row.invFlag;
	if (!invRowId || (invFlag != "API")) {
		return;
	}
	if (getValueById("insuDivId")) {
		$.messager.popover({msg: "该发票已经医保结算，不能再补调", type: "info"});
		return;
	}
	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCAccPayINV", id: invRowId}, false);
	if (jsonObj.APIFlag != "N") {
		$.messager.popover({msg: "该发票已退费，不能补调医保", type: "info"});
		return;
	}
	if ((jsonObj.APIINVRepDR) || (jsonObj.APIPUserDR != PUBLIC_CONSTANT.SESSION.USERID)) {
		$.messager.popover({msg: "收费员已结算或不是本人收据，不能补调医保", type: "info"});
		return;
	}
	if (GV.AccPINVYBConFlag == "0")  {
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
	var writeOffFlag = $.m({ClassName: "web.DHCOPBillRefund", MethodName: "CheckWriteOffAPI", accPInvId: invRowId}, false);
	if (writeOffFlag == "Y") {
		$.messager.popover({msg: "非卡支付发票，不能补掉医保", type: "info"});
		return;
	}
	$.messager.confirm("确认", "是否确认补调医保? ", function (r) {
		if (r) {
			$.m({
				ClassName: "web.udhcOPRefEdit1",
				MethodName: "BuildInsuTmp",
				AccPInvID: invRowId,
				InsTypeID: newInsType
			}, function(myCID) {
				accPInvInsuDiv(myCID);    //医保分解
			});
		}
	});
}

function accPInvPrint(accPInvIdStr) {
	if (GV.AccPINVXMLName == "") {
		return;
	}
	var myAry = accPInvIdStr.split("^");
	$.each(myAry, function(index, id) {
		if (id) {
			getXMLConfig(GV.AccPINVXMLName);
			var paymDesc = $("#refundMode").combobox("getText");
			var myExpStr = "^^" + PUBLIC_CONSTANT.SESSION.GROUPID;
			var encmeth = getValueById("ReadOPDataEncrypt");
			var prtInfo = cspRunServerMethod(encmeth, "xmlPrintFun", GV.AccPINVXMLName, id, PUBLIC_CONSTANT.SESSION.USERCODE, paymDesc, myExpStr);
		}
	});
}