/**
 * FileName: dhcbill.print.js
 * Anchor: ZhYW
 * Date: 2019-03-27
 * Description: 计费打印公共js头文件
 */
 
/**
 * 门诊退费申请单打印
 * @method refReqListPrint
 * @param {Array} reqInvAry
 *               如: ["232373:PRT", "232365:PRT"]
 * @author ZhYW
 * refReqListPrint(123)
 */
function refReqListPrint(reqInvAry) {
	if (reqInvAry.length == 0) {
		$.messager.popover({msg: "票据ID传入错误", type: "error"});
		return;
	}
	getXMLConfig("DHCOPBillAudit");
	reqInvAry.forEach(function(invStr) {
		if (!invStr) {
			return true;
		}
		var rtn = tkMakeServerCall("web.UDHCOPINVPrtData12", "GetOPOEAuditData", "xmlPrintFun", invStr, session['LOGON.USERCODE'], session['LOGON.CTLOCID']);
	});
}

/**
 * 住院发票打印
 * @method inpatInvPrint
 * @param {String}
 * @author ZhYW
 * inpatInvPrint("123#")
 */
function inpatInvPrint(prtRowIdStr) {
	try {
		var myAry = prtRowIdStr.split("#");
		var prtRowId = myAry[0];
		var rePrtFlag = myAry[1] || "";  //补打标识
		var xmlName = tkMakeServerCall("web.UDHCJFBaseCommon", "GetPrtXMLName", prtRowId, "I", "DHCJFIPReceipt");
		getXMLConfig(xmlName);
		var txtInfo = tkMakeServerCall("web.UDHCJFPRINTINV", "GetPrintInfo", prtRowId, rePrtFlag);
		xmlPrintFun(txtInfo, "");
	} catch (e) {
		$.messager.popover({msg: "打印异常：" + e.message, type: "error"});
	}
}

/**
 * 住院押金条打印
 * @method depositPrint
 * @param {String}
 * @author ZhYW
 * depositPrint("123#")
 */
function depositPrint(prtRowIdStr) {
	try {
		var myAry = prtRowIdStr.split("#");
		var depositId = myAry[0];
		var rePrtFlag = myAry[1] || "";  //补打标识
		getXMLConfig("DHCJFDeposit");
		var rtn = tkMakeServerCall("web.DHCIPBillDeposit", "GetPrintInfo", "xmlPrintFun", depositId, rePrtFlag);
	} catch (e) {
		$.messager.popover({msg: "打印异常：" + e.message, type: "error"});
	}
}

/**
 * 门诊预交金条打印
 * @method accPreDepPrint
 * @param {String}
 * @author ZhYW
 * accPreDepPrint("123#")
 */
function accPreDepPrint(preDepIdStr) {
	var xmlName = "UDHCAccDeposit";
	getXMLConfig(xmlName);
	var userId = session['LOGON.USERID'];
	var myAry = preDepIdStr.split("#");
	var accPDRowId = myAry[0];
	var rePrtFlag = myAry[1] || "";    //补打标识
	var expStr = rePrtFlag + "^";
	var rtn = tkMakeServerCall("web.UDHCOPPrtInfoIF", "GetPrtInfo", "xmlPrintFun", xmlName, accPDRowId, userId, expStr);
}

/**
 * 留观押金条打印
 * @method emPreDepPrint
 * @param {String}
 * @author ZhYW
 * emPreDepPrint("123#")
 */
function emPreDepPrint(preDepIdStr) {
	var xmlName = "UDHCEPMDeposit";
	getXMLConfig(xmlName);
	var userId = session['LOGON.USERID'];
	var myAry = preDepIdStr.split("#");
	var accPDRowId = myAry[0];
	var rePrtFlag = myAry[1] || "";    //补打标识
	var expStr = rePrtFlag + "^";
	var rtn = tkMakeServerCall("web.UDHCOPPrtInfoIF", "GetPrtInfo", "xmlPrintFun", xmlName, accPDRowId, userId, expStr);
}

/**
 * 欠费补交打印
 * @method arrBackPrint
 * @param {String}
 * @author ZhYW
 * arrBackPrint("123")
 */
function arrBackPrint(rowId) {
	try {
		getXMLConfig("DHCJFQFPrint");
		var rtn = tkMakeServerCall("web.UDHCJFQFDEAL", "GetPrintInfo", "xmlPrintFun", rowId);
	} catch (e) {
		$.messager.popover({msg: "打印异常：" + e.message, type: "error"});
	}
}

/**
 * 门诊收费导诊单打印
 * @method directPrint
 * @param {String}
 * @author ZhYW
 * directPrint("123^234")
 */
function directPrint(rowIdStr) {
	try {
		getXMLConfig("DHCOPBillDirect");
		var expStr = session['LOGON.USERID'] + "^" + session['LOGON.GROUPID']+ "^" + session['LOGON.CTLOCID'];
		var myAry = rowIdStr.split("^");
		myAry.forEach(function(id) {
			if (!(id > 0)) {
				return true;
			}
			$.cm({
				ClassName: "BILL.OP.BL.Direct.Interface",
				MethodName: "GetPrintJsonStr",
				prtRowId: id,
				expStr: expStr
			}, function(jsonAry) {
				xmlPrintFun("", "", jsonAry);
			});
		});
	} catch (e) {
		$.messager.popover({msg: "打印异常：" + e.message, type: "error"});
	}
}

/**
 * 住院集中打印发票
 * @method summaryInvPrint
 * @param {String}
 * @author ZhYW
 * summaryInvPrint("1^2")
 */
function summaryInvPrint(spiIdStr) {
	try {
		var myAry = spiIdStr.split("#");
		var rePrtFlag = myAry[1] || "";  //补打标识
		var prtRowId = "";
		$.each(myAry[0].split("^"), function(index, item) {
			if (!(item > 0)) {
				return true;
			}
			//目前住院集中打印发票VS小条为1:1，若以后是1:n则需要修改打印方法
			prtRowId = $.m({ClassName: "BILL.IP.BL.SummaryPrtInv", MethodName: "GetPrtRowIdStrBySPI", spiRowId: item}, false);
			inpatInvPrint(prtRowId + "#" + rePrtFlag);
		});
	} catch (e) {
		$.messager.popover({msg: "打印异常：" + e.message, type: "error"});
	}
}

function getXMLConfig(CFlag) {
	try {
		PrtAryData.length = 0;
		var PrtConfig = tkMakeServerCall("web.DHCXMLIO", "ReadXML", "DHCP_RecConStr", CFlag);
		for (var i = 0; i < PrtAryData.length; i++) {
			PrtAryData[i] = DHCP_TextEncoder(PrtAryData[i]);
		}
	} catch (e) {
		$.messager.popover({msg: e.message, type: "error"});
	}
}

function xmlPrintFun(inpara, inlist, jsonArr, reportNote, otherCfg) {
	otherCfg = otherCfg || {printListByText: true};
	DHC_PrintByLodop(getLodop(), inpara, inlist, jsonArr, reportNote, otherCfg);
}