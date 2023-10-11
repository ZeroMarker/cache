/**
 * FileName: dhcbill.ipbill.charge.paym.js
 * Author: ZhYW
 * Date: 2019-03-18
 * Description: 住院收费支付方式弹窗
 */﻿

$(function () {
	refreshBar("", GV.EpisodeID);
	//初始化查询菜单
	initQueryMenu();
});

function initQueryMenu() {
	//打印费用清单
	$HUI.linkbutton("#btn-prtFeeDtl", {
		onClick: function () {
			printFeeDtlClick();
		}
	});
	
	//打印医保结算单
	$HUI.linkbutton("#btn-prtInsuJSD", {
		onClick: function () {
			printInsuJSDClick();
		}
	});

	initPatFeeInfo();
}

/**
* 结算
*/
function chargeClick() {
	var _cfr = function () {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认结算？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	if ($("#btn-disCharge").linkbutton("options").disabled) {
		return;
	}
	$("#btn-disCharge").linkbutton("disable");
	
	var promise = Promise.resolve();
	promise
		.then(_cfr)
		.then(charge)
		.then(function() {
			$("#btn-disCharge").linkbutton("enable");
		}, function() {
			$("#btn-disCharge").linkbutton("enable");
		});
}

/**
* 打印费用清单
*/
function printFeeDtlClick() {
	var rtn = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPatAdmInDays", adm: GV.EpisodeID, bill: GV.BillID}, false);
	var myAry = rtn.split("^");
	var stDate = myAry[0];
	var endDate = myAry[1];
	
	var tarCateId = "";
	var splitColFlag = $.m({ClassName: "web.DHCBillPageConf", MethodName: "GetPageConfValue", cspName: "dhcbill.ipbill.billdtl.csp", code: "BSC", groupId: "", hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
	$.m({
		ClassName: "web.DHCBillDtlListPrtLog",
		MethodName: "SavePrtLog",
		userId: PUBLIC_CONSTANT.SESSION.USERID,
		invStr: GV.BillID + ":" + "IP"
	}, function (rtn) {
		if (rtn != 0) {
			$.messager.popover({msg: '保存日志失败', type: 'error'});
			return;
		}
		var parameter = "billId=" + GV.BillID + ";" + "stDate=" + stDate + ";" + "endDate=" + endDate + ";" + "tarCateId=" + tarCateId;
		var fileName = (splitColFlag == 1) ? "DHCBILL-IPBILL-FYQDSL.rpx" : "DHCBILL-IPBILL-FYQD.rpx";
		fileName = "{" + fileName + "(" + parameter + ")}";
		DHCCPM_RQDirectPrint(fileName);
	});
}