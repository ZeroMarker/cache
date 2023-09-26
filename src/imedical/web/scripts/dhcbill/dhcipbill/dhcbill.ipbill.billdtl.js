﻿/**
 * FileName: dhcbill.ipbill.billdtl.js
 * Anchor: ZhYW
 * Date: 2019-05-22
 * Description: 患者费用明细
 */

var GV = {
	EpisodeID: getParam("EpisodeID"),
	BillRowId: getParam("BillRowId"),
	CateRowId: getParam("CateRowId")
};

$(function () {
	initQueryMenu();
	initBillDtlList();
});

function initQueryMenu() {	
	getPatInfoByAdm(GV.EpisodeID);  //dhcbill.inpatient.banner.csp
	$.m({
		ClassName: "web.UDHCJFBaseCommon",
		MethodName: "GetPatAdmInDays",
		PAADMRowID: GV.EpisodeID,
		BillNo: GV.BillRowId
	}, function(rtn) {
		var myAry = rtn.split("^");
		setValueById("stDate", myAry[0]);
		setValueById("endDate", myAry[1]);
	});
	
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
		pagination: true,
		pageSize: 20,
		columns: [[{title: '分类', field: 'CateDesc', width: 150},
				   {title: '项目名称', field: 'ItmDesc', width: 220},
				   {title: '单位', field: 'UOM', width: 120},
				   {title: '单价', field: 'Price', align: 'right', width: 120},
				   {title: '数量', field: 'Qty', width: 120},
				   {title: '金额', field: 'Amount', align: 'right', width: 120},
				   {title: '医保分类', field: 'YBDesc', width: 100},
				   {title: '剂型', field: 'PhcfDesc', width: 120, hidden: true},
				   {title: '产地', field: 'PhmnfName', width: 120, hidden: true},
				   {title: '物价编码', field: 'ChargeBasis', width: 150},
				   {title: 'Adm', field: 'Adm', hidden: true},
				   {title: 'CateID', field: 'CateID', hidden: true},
				   {title: 'ItmID', field: 'ItmID', hidden: true},
				   {title: 'DtlFlag', field: 'DtlFlag', hidden: true}
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.DHCIPBillPatFeeDtl",
			QueryName: "FindBillDtl",
			billId: GV.BillRowId,
			stDate: "",
			endDate: "",
			tarCateId: GV.CateRowId
		},
		rowStyler: function (index, row) {
			if ((row.CateDesc.indexOf("小计") != -1) || (row.CateDesc.indexOf("合计") != -1)) {
				return 'font-weight: bold';
			}
		}
	});
}

function loadBillDtlList() {
	var queryParams = {
		ClassName: "web.DHCIPBillPatFeeDtl",
		QueryName: "FindBillDtl",
		billId: GV.BillRowId,
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		tarCateId: GV.CateRowId
	}
	loadDataGridStore("billDtlList", queryParams);
}

/**
* 打印费用明细
*/
function printClick() {
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var tarCateId = GV.CateRowId;
	$.m({
		ClassName: "web.DHCBillDtlListPrtLog",
		MethodName: "SavePrtLog",
		userId: PUBLIC_CONSTANT.SESSION.USERID,
		invStr: GV.BillRowId + ":" + "IP"
	}, function (rtn) {
		if (rtn != 0) {
			$.messager.popover({msg: '保存日志失败', type: 'error'});
			return;
		}
		var parameter = "billId=" + GV.BillRowId + ";" + "stDate=" + stDate + ";" + "endDate=" + endDate + ";" + "tarCateId=" + tarCateId;
		var fileName = "{DHCBILL-IPBILL-FYQD.rpx(" + parameter + ")}";
		DHCCPM_RQDirectPrint(fileName);
	});
}