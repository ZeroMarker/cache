/**
 * FileName: dhcbill.conf.page.op2ip.js
 * Anchor: ZhYW
 * Date: 2019-11-01
 * Description: 门急诊费用转住院页面配置
 */

$(function() {
	$HUI.linkbutton("#btn-save", {
		onClick: function () {
			saveClick();
		}
	});
	
	var tableName = "Bill_OP_OP2IP";
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
			loadItemCateList(newValue);
		}
	});
	
	GV.LimitItemCateList = $HUI.datagrid("#limitItemCateList", {
		fit: true,
		striped: true,
		title: '不能转入住院医嘱子类',
		headerCls: 'panel-header-gray',
		fitColumns: true,
		rownumbers: false,
		pageSize: 999999999,
		loadMsg: '',
		toolbar: [],
		data: [],
		columns: [[{title: 'ck', field: 'ck', checkbox: true},
				   {title: 'id', field: 'id', hidden: true},
		           {title: 'code', field: 'code', hidden: true},
				   {title: '子类名称', field: 'desc', width: 120}
			]],
		onLoadSuccess: function(data) {
			$.each(data.rows, function (index, row) {
				if (row.checked) {
					GV.LimitItemCateList.checkRow(index);
				}
			});
		}
	});
});

function loadItemCateList(hospital) {
	var queryParams = {
		ClassName: "web.DHCBillPageConf",
		QueryName: "FindLimit2IPItemCat",
		pageId: GV.PageId,
		site: GV.Site,
		code: GV.CateCode,
		siteId: hospital,
		rows: 99999999
	}
	loadDataGridStore("limitItemCateList", queryParams);
}

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
			var limitCatAry = [];
			var str = "";
			$.each(GV.LimitItemCateList.getChecked(), function(index, row) {
				limitCatAry.push(row.id);
			});
			confObj[GV.CateCode + "VAL"] = limitCatAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
			confObj[GV.CateCode + "DESC"] = "不能转入住院医嘱子类";
			
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
				if (rtn == "0") {
					$.messager.popover({msg: "保存成功", type: "success"});
				}else {
					$.messager.popover({msg: "保存失败：" + rtn, type: "error"});
				}
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