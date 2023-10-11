﻿/**
 * FileName: dhcbill.ipbill.billdtl.js
 * Author: ZhYW
 * Date: 2019-05-22
 * Description: 患者费用明细
 */

$(function () {
	initQueryMenu();
	initBillDtlList();
});

function initQueryMenu() {
	getPatInfoByAdm(CV.EpisodeID);  //dhcbill.inpatient.banner.csp
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadBillDtlList();
		}
	});
	
	$HUI.linkbutton("#btn-print", {
		onClick: function () {
			printClick();
		}
	});
}

function initBillDtlList() {
	$HUI.datagrid("#billDtlList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		className: "web.DHCIPBillPatFeeDtl",
		queryName: "FindBillDtl",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if (!cm[i].width) {
					cm[i].width = 130;
					if (cm[i].field == "TCateDesc") {
						cm[i].width = 120;
					}
					if (cm[i].field == "TItmDesc") {
						cm[i].width = 198;
					}
					if (cm[i].field == "TChargeBasis") {
						cm[i].width = 120;
					}
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.DHCIPBillPatFeeDtl",
			QueryName: "FindBillDtl",
			billId: CV.BillID,
			stDate: "",
			endDate: "",
			episodeId: CV.EpisodeID,
			otherQryStr:  CV.CateID + "!" + (getValueById("splitCK") ? 1 : 0)
		},
		rowStyler: function (index, row) {
			if ([$g("小计"), $g("合计")].indexOf(row.TCateDesc) != -1) {
				return 'font-weight: bold';
			}
		}
	});
}

function loadBillDtlList() {
	var isSplit = getValueById("splitCK") ? 1 : 0;
	var otherQryStr = CV.CateID + "!" + isSplit;
	var queryParams = {
		ClassName: "web.DHCIPBillPatFeeDtl",
		QueryName: "FindBillDtl",
		billId: CV.BillID,
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		episodeId: CV.EpisodeID,
		otherQryStr: otherQryStr
	}
	loadDataGridStore("billDtlList", queryParams);
}

/**
* 打印费用明细
*/
function printClick() {
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var isSplit = getValueById("splitCK") ? 1 : 0;
	var otherQryStr = CV.CateID + "!" + isSplit;
	var splitColFlag = getPageCfgValue("dhcbill.ipbill.billdtl.csp", "BSC", "", PUBLIC_CONSTANT.SESSION.HOSPID);
	$.m({
		ClassName: "web.DHCBillDtlListPrtLog",
		MethodName: "SavePrtLog",
		userId: PUBLIC_CONSTANT.SESSION.USERID,
		invStr: CV.BillID + ":" + "IP"
	}, function (rtn) {
		if (rtn != 0) {
			$.messager.popover({msg: "保存日志失败", type: "error"});
			return;
		}
		var paramObj = {
			billId: CV.BillID,
			stDate: stDate,
			endDate: endDate,
			episodeId: CV.EpisodeID,
			otherQryStr: otherQryStr
		};
		var params = "";
		$.each(Object.keys(paramObj), function(index, prop) {
			params += ((params == "") ? "" : ";") + prop + "=" + paramObj[prop];
		});
		var fileName = (splitColFlag == 1) ? "DHCBILL-IPBILL-FYQDSL.rpx" : "DHCBILL-IPBILL-FYQD.rpx";
		fileName = "{" + fileName + "(" + params + ")}";
		DHCCPM_RQDirectPrint(fileName);
	});
}