/**
 * FileName: dhcbill.ipbill.intpay.itm.js
 * Anchor: ZhYW
 * Date: 2019-09-12
 * Description: 医嘱拆分账单
 */

var GV = {
	BillID: getParam("BillID")
};

$(function () {
	initQueryMenu();
	initOEOREList();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			findClick();
		}
	});
	
	$HUI.linkbutton("#btn-split", {
		onClick: function () {
			splitClick();
		}
	});
	
	$HUI.linkbutton("#btn-calc", {
		onClick: function () {
			calcClick();
		}
	});
	
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	//医嘱大类
	$HUI.combobox("#ordCat", {
		panelHeight: 150,
		multiple: true,
		url: $URL + "?ClassName=web.UDHCJFIntBill&QueryName=ordcatlookup&ResultSetType=array&desc=&HospId=" + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		selectOnNavigation: false,
		formatter:function(row) {
			return row.text + "<span class='icon'></span>";
		},
		onChange: function(newVal, oldVal) {
			var $combo = $(this);
			$combo.combobox("panel").find(".icon").removeClass("icon-ok");
			$.each(newVal, function(index, val) {
				$combo.combobox("panel").find(".combobox-item-selected .icon").addClass("icon-ok");
			});
		}
	});
	
	//医嘱子类
	$HUI.combobox("#ordSubCat", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.UDHCJFIntBill&QueryName=ordsubcatlookup&ResultSetType=array&ordCatId=&desc=&HospId=" + PUBLIC_CONSTANT.SESSION.HOSPID,
		multiple: true,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		selectOnNavigation: false,
		formatter:function(row) {
			return row.text + "<span class='icon'></span>";
		},
		onChange: function(newVal, oldVal){
			var $combo = $(this);
			$combo.combobox("panel").find(".icon").removeClass("icon-ok");
			$.each(newVal, function(index, val) {
				$combo.combobox("panel").find(".combobox-item-selected .icon").addClass("icon-ok");
			});
		}
	});
	
	//医嘱项
	$HUI.combobox("#arcim", {
		panelHeight: 150,
		url: $URL,
		multiple: true,
		mode: 'remote',
		method: 'get',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		selectOnNavigation: false,
		onBeforeLoad: function (param) {
			param.ClassName = "web.UDHCJFIntBill";
			param.QueryName = "arcitemlookup";
			param.ResultSetType = "array";
			param.BillNo = GV.BillID;
			param.ordcatid = "";
			param.ordsubcatid =  "";
			param.desc = "";
		},
		formatter:function(row) {
			return row.text + "<span class='icon'></span>";
		},
		onChange: function(newVal, oldVal) {
			var $combo = $(this);
			$combo.combobox("panel").find(".icon").removeClass("icon-ok");
			$.each(newVal, function(index, val) {
				$combo.combobox("panel").find(".combobox-item-selected .icon").addClass("icon-ok");
			});
		}
	});

	$HUI.combogrid("#ordItem", {
		panelWidth: 430,
		panelHeight: 260,
		url: $URL,
		mode: 'remote',
		method: 'get',
		delay: 200,
		lazy: true,
		idField: 'orderid',
		textField: 'orderdesc',
		pagination: true,
		multiple: true,
		selectOnNavigation: false,
		columns: [[{field: 'ck', title: 'ck', checkbox: true},
				   {field: 'orderdesc', title: '医嘱', width: 200},
			 	   {field: 'orddate', title: '开始日期', width: 100},
			       {field: 'orderid', title: '医嘱ID', width: 80}
		  ]],
		onBeforeLoad: function (param) {
			param.ClassName = "web.UDHCJFIntBill";
			param.QueryName = "orderlookup";
			param.BillNo = GV.BillID;
			param.ordcatid = "";
			param.ordsubcatid = "";
			param.arcimid = "";
			param.desc = param.q
		}
	});
}
	
function initOEOREList() {
	GV.OEOREList = $HUI.datagrid("#oeoreList", {
		fit: true,
		border: true,
		bodyCls: 'panel-header-gray',
		selectOnCheck: false,
		checkOnSelect: false,
		striped: true,
		pageSize: 999999999,
		data: [],
		columns: [[{title: 'ck', field: 'ck', checkbox: true},
				   {title: '医嘱日期', field: 'TOrdDate', width: 100},
				   {title: '医嘱名称', field: 'TArcimDesc', width: 200},
				   {title: '医嘱分类', field: 'TSubCatDesc', width: 100},
				   {title: '医嘱大类', field: 'TCatDesc', width: 100},
				   {title: '单价', field: 'TPrice', width: 100, align: 'right'},
				   {title: '数量', field: 'TQty', width: 100},
				   {title: '金额', field: 'TAmt', width: 100, align: 'right'},
				   {title: 'TExecRowID', field: 'TExecRowID', hidden: true},
				   {title: 'TPBORowID', field: 'TPBORowID', hidden: true}
			]],
		onLoadSuccess: function (data) {
			$(this).datagrid("clearChecked");
		},
		onUncheckAll: function(rows) {
			$("#amount").numberbox("clear");
		}
	});
}

function loadOEOREList() {
	var ordCatAry = $("#ordCat").combobox("getValues");
	var ordCatStr = ordCatAry ? ordCatAry.join("^") : "";
	var ordSubCatAry = $("#ordSubCat").combobox("getValues");
	var ordSubCatStr = ordSubCatAry ? ordSubCatAry.join("^") : "";
	var arcimAry = $("#arcim").combobox("getValues");
	var arcimStr = arcimAry ? arcimAry.join("^") : "";
	var ordItemAry = $("#ordItem").combogrid("getValues");
	var ordItemStr = ordItemAry ? ordItemAry.join("^") : "";

	var queryParams = {
		ClassName: "web.DHCIPBILLOEORIItemGroup",
		QueryName: "SearchOEORIItemGroup",
		BillNo: GV.BillID,
		StDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		OrdCatStr: ordCatStr,
		OrdSubCatStr: ordSubCatStr,
		ArcimStr: arcimStr,
		OEOrdItemStr: ordItemStr,
		Guser: PUBLIC_CONSTANT.SESSION.USERID
	}
	loadDataGridStore("oeoreList", queryParams);
}

function findClick() {
	loadOEOREList();
}

/**
* 拆分账单
*/
function splitClick() {
	if (!GV.BillID) {
		$.messager.popover({msg: "请先账单", type: "info"});
		return;
	}
	var execAry = [];
	$.each(GV.OEOREList.getChecked(), function(index, row) {
		var oeore = row.TExecRowID;
		if (!oeore) {
			return true;
		}
		execAry.push(oeore);
	});
	if (execAry.length == 0) {
		$.messager.popover({msg: "请选择需要拆分的医嘱", type: "info"});
		return;
	}
	
	$.messager.confirm("确认", "确认拆分账单？", function(r) {
		if (r) {
			var rtn = $.m({ClassName: "web.DHCIPBILLOEORIItemGroup", MethodName: "UpOEORIItemGroup", execAry: execAry}, false);
			if (rtn != "0") {
				$.messager.popover({msg: "更新医嘱表失败", type: "error"});
				return;
			}
			
			var num = $.m({ClassName: "web.UDHCJFCASHIER", MethodName: "Judge", adm: GV.BillID}, false);
			if (+num > 1) {
				$.messager.popover({msg: "患者有多个未结算账单，不允许拆分账单", type: "error"});
				return;
			}
			
			$.m({
				ClassName: "web.DHCIPBILLOEORIItemGroup",
				MethodName: "RINBILLOrdItemGroup",
				bill: GV.BillID,
				guser: PUBLIC_CONSTANT.SESSION.USERID,
				execAry: execAry
			}, function(rtn) {
				var myAry = rtn.split("^");
				switch(myAry[0]) {
				case "0":
					$.messager.alert("提示", "拆分账单成功", "success", function() {
						if (window.parent && (typeof window.parent.setDefTabFromIframe == "function")) {
							window.parent.setDefTabFromIframe();
						}
					});
					break;
				case "NotBill":
					$.messager.popover({msg: "请先账单", type: "info"});
					break;
				case "NotItemGroup":
					$.messager.popover({msg: "没有符合条件的医嘱，不能拆分账单", type: "info"});
					break;
				default:
					$.messager.popover({msg: "拆分账单失败：" + myAry[0], type: "info"});
					break;
				}
			});
		}
	});
}

/**
* 收集金额
*/
function calcClick() {
	var execAry = [];
	$.each(GV.OEOREList.getChecked(), function(index, row) {
		var oeore = row.TExecRowID;
		if (!oeore) {
			return true;
		}
		execAry.push(oeore);
	});
	if (execAry.length == 0) {
		$.messager.popover({msg: "请选择需要拆分的医嘱", type: "info"});
		return;
	}
	$.m({
		ClassName: "web.DHCIPBILLOEORIItemGroup",
		MethodName: "GetSelOEOREBillAmt",
		bill: GV.BillID,
		execAry: execAry
	}, function(amt) {
		setValueById("amount", amt);
	});
}

/**
* 清屏
*/
function clearClick() {
	$(".datebox-f").datebox("setValue", "");
	$(".numberbox-f").numberbox("clear");
	$(".combobox-f").combobox("clear").combobox("reload");
	
	$("#ordItem").combogrid("clear").combogrid("grid").datagrid("load", {
		ClassName: "web.UDHCJFIntBill",
		QueryName: "orderlookup",
		BillNo: "",
		ordcatid: "",
		ordsubcatid: "",
		arcimid: "",
		desc: ""
	});

	$("#oeoreList").datagrid("clearChecked").datagrid("load", {
		ClassName: "web.DHCIPBILLOEORIItemGroup",
		QueryName: "SearchOEORIItemGroup",
		BillNo: "",
		StDate: "",
		EndDate: "",
		OrdCatStr: "",
		OrdSubCatStr: "",
		ArcimStr: "",
		OEOrdItemStr: "",
		Guser: PUBLIC_CONSTANT.SESSION.USERID
	});
}