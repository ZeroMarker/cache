/**
 * FileName: dhcbill.conf.page.ipcharge.js
 * Author: ZhYW
 * Date: 2020-04-08
 * Description: 住院收费页面配置
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
	
	var tableName = "Bill_IP_Charge";
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
				code: GV.UpdateInsTypeCode,
				siteId: newValue
			}, function (rtn) {
				$("#updateInsType").switchbox("setValue", (rtn == 1));        //修改费别时是否重新生成账单
			});
			
			$.m({
				ClassName: "web.DHCBillPageConf",
				MethodName: "GetConfValue",
				pageId: GV.PageId,
				site: GV.Site,
				code: GV.BabyUnPayAllowMotherPayCode,
				siteId: newValue
			}, function (rtn) {
				$("#babyUnPayAllowMotherPay").switchbox("setValue", (rtn == 1));        //婴儿未结算时母亲是否允许结算
			});
		}
	});
	
	$("#delPayMode").combobox({
		panelHeight: 'auto',
		valueField: 'value',
		textField: 'text',
		editable: false,
		data:[{value: '0', text: '押金回冲'},
			  {value: '1', text: '押金不回冲'}],
		onChange: function(newValue, oldValue) {
			if (newValue == 1) {
				$("#btn-TransPMList").removeClass("disabled").popover();
			}else {
				$("#btn-TransPMList").addClass("disabled").popover('destroy');
			}
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
		if (r) {
			var confObj = {};
						
			confObj[GV.UpdateInsTypeCode + "VAL"] = $("#updateInsType").switchbox("getValue") ? 1 : 0;
			confObj[GV.UpdateInsTypeCode + "DESC"] = "修改费别时是否重新生成账单";
			
			confObj[GV.BabyUnPayAllowMotherPayCode + "VAL"] = $("#babyUnPayAllowMotherPay").switchbox("getValue") ? 1 : 0;
			confObj[GV.BabyUnPayAllowMotherPayCode + "DESC"] = "婴儿未结算时母亲是否允许结算";
			
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
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: "保存成功", type: "success"});
					return;
				}
				$.messager.popover({msg: "保存失败：" + (myAry[1] || myAry[0]), type: "error"});
			});
		}
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