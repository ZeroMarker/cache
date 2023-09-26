﻿/**
 * FileName: dhcbill.conf.group.main.js
 * Anchor: ZhYW
 * Date: 2019-10-21
 * Description: 安全组功能授权
 */

var GV = {};

$(function() {
	$(".tabs-container").tabs({
		onSelect: function(title) {
			loadTabContent();
    	}
	});
	initGroupList();
});

function initGroupList() {
	var tableName = "Bill_Com_GroupAuth";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#hospital").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			var queryParams = {
				ClassName: "BILL.CFG.COM.GroupAuth",
				QueryName: "QuerySSGroup",
				hospId: newValue,
				desc: $("#group-search").searchbox("getValue")
			}
			loadDataGridStore("groupList", queryParams);
		}
	});
	
	$("#group-search").searchbox({
		searcher: function(value) {
			var queryParams = {
				ClassName: "BILL.CFG.COM.GroupAuth",
				QueryName: "QuerySSGroup",
				hospId: getValueById("hospital"),
				desc: value
			}
			loadDataGridStore("groupList", queryParams);
		}
	});
	
	GV.GroupList = $HUI.datagrid("#groupList", {
		fit: true,
		border: false,
		singleSelect: true,
		fitColumns: true,
		pagination: true,
		pageSize: 30,
		displayMsg: '',
		idField: 'id',
		data: [],
		columns: [[
			{title: '安全组', field: 'text', width: 230},
			{filed: 'id', hidden: true}
		]],
		onLoadSuccess: function(data) {
			$HUI.datagrid("#groupList").unselectAll();
			$("iframe").attr("src", "dhcbill.nodata.warning.csp");
		},
		onSelect: function(index, row) {
			loadTabContent();
		}
	});
}

function loadTabContent() {
	var row = GV.GroupList.getSelected();
	if (!row) {
		return;
	}
	var groupId = row.id;
	if (!groupId) {
		return;
	}
	var iframeId = $(".tabs-container>.tabs-panels>.panel:visible").find("iframe").attr("id");
	var url = "";
	switch(iframeId) {
	case "parasetting-iframe":
		url = "dhcbill.conf.group.parasetting.csp";
		break;
	case "paym-iframe":
		url = "dhcbill.conf.group.paym.csp";
		break;
	case "recLoc-iframe":
		url = "dhcbill.conf.group.recloc.csp";
		break;
	case "tabs-iframe":
		url = "dhcbill.conf.group.tabs.csp";
		break;
	case "ipbillmenu-iframe":
		url = "dhcbill.conf.group.ipbillmenu.csp";
		break;
	default:
	}
	
	var hospId = getValueById("hospital");
	var src = url+ "?GroupId=" + groupId + "&HospId=" + hospId;
	if ($("#" + iframeId).attr("src") != src) {
		$("#" + iframeId).attr("src", src);
	}
}