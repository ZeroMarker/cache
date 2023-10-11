/**
 * FileName: dhcbill.conf.page.opcharge.js
 * Author: ZhYW
 * Date: 2021-11-04
 * Description: 门诊收费页面配置
 */﻿

$(function() {
	$HUI.linkbutton("#btn-save", {
		onClick: function () {
			saveClick();
		}
	});
	
	var options = {
		onText: '是',
		offText: '否',
		size: 'small',
		onClass: 'primary',
		offClass: 'gray',
		checked: false
	};
	$(".search-table td>div").switchbox(options);
	
	var tableName = "Bill_OP_Charge";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#hospital").combobox({
		panelHeight: 150,
		width: 350,
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
			$.m({
				ClassName: "web.DHCBillPageConf",
				MethodName: "GetConfValue",
				pageId: GV.PageId,
				site: GV.Site,
				code: GV.LockAdmCode,
				siteId: newValue
			}, function (rtn) {
				$("#lockAdm").switchbox("setValue", (rtn == 1));         //是否启用就诊记录加锁
			});
			
			$.m({
				ClassName: "web.DHCBillPageConf",
				MethodName: "GetConfValue",
				pageId: GV.PageId,
				site: GV.Site,
				code: GV.WarrPayCode,
				siteId: newValue
			}, function (rtn) {
				$("#warrPayCode").switchbox("setValue", (rtn == 1));       //欠费结算是否需要担保
			});
		}
	});
});

/**
* 保存
*/
function saveClick() {
	if (!checkData()) {
		return;
	}
	var hospital = getValueById("hospital");
	
	$.messager.confirm("确认", "确认保存?", function(r) {
		if (!r) {
			return;
		}
		var confObj = {};
		confObj[GV.LockAdmCode + "VAL"] = $("#lockAdm").switchbox("getValue") ? 1 : 0;
		confObj[GV.LockAdmCode + "DESC"] = "是否启用就诊记录加锁";
		
		confObj[GV.WarrPayCode + "VAL"] = $("#warrPayCode").switchbox("getValue") ? 1 : 0;
		confObj[GV.WarrPayCode + "DESC"] = "欠费结算是否需要担保";
		
		var confAry = [];
		$.each(GV.CodeStr.split("^"), function(index, item) {
			var myObj = {};
			myObj.PCSite = GV.Site;
			myObj.PCSiteDR = hospital;
			myObj.PCCode = item;
			myObj.PCValue = confObj[item + "VAL"];
			myObj.PCDesc = confObj[item + "DESC"];
			confAry.push(JSON.stringify(myObj));
		});

		$.m({
			ClassName: "web.DHCBillPageConf",
			MethodName: "SaveConfInfo",
			pageId: GV.PageId,
			confList: confAry
		}, function(rtn) {
			if (rtn == 0) {
				$.messager.popover({msg: "保存成功", type: "success"});
				return;
			}
			$.messager.popover({msg: "保存失败：" + rtn, type: "error"});
		});
	});
}

function checkData() {
	var bool = true;
	$(".validatebox-text").each(function() {
		if (!$(this).validatebox("isValid")) {
			bool = false;
			return false;
		}
	});
	return bool;
}