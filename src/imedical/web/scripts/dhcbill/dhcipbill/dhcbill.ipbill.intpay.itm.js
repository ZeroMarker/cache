/**
 * FileName: dhcbill.ipbill.intpay.itm.js
 * Author: ZhYW
 * Date: 2019-09-12
 * Description: 医嘱拆分账单
 */

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
	
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	//医嘱大类
	$HUI.combobox("#ordCat", {
		panelHeight: 150,
		multiple: true,
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryOrdCate&ResultSetType=array&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
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
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryARCItemCat&ResultSetType=array&ordCatId=&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID,
		multiple: true,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
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
	
	//医嘱项
	$HUI.combobox("#arcim", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.UDHCJFIntBill&QueryName=arcitemlookup&ResultSetType=array",
		multiple: true,
		mode: 'remote',
		method: 'get',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		selectOnNavigation: false,
		onBeforeLoad: function (param) {
			param.BillNo = CV.BillID;
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
		url: $URL + "?ClassName=web.UDHCJFIntBill&QueryName=orderlookup",
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
			param.BillNo = CV.BillID;
			param.ordcatid = "";
			param.ordsubcatid = "";
			param.arcimid = "";
			param.desc = param.q
		}
	});
}

function initOEOREList() {
	var ordCatAry = $("#ordCat").combobox("getValues");
	var ordCatStr = ordCatAry.join("^");
	var ordSubCatAry = $("#ordSubCat").combobox("getValues");
	var ordSubCatStr = ordSubCatAry.join("^");
	var arcimAry = $("#arcim").combobox("getValues");
	var arcimStr = arcimAry.join("^");
	var ordItemAry = $("#ordItem").combogrid("getValues");
	var ordItemStr = ordItemAry.join("^");

	GV.OEOREList = $HUI.datagrid("#oeoreList", {
		fit: true,
		border: true,
		bodyCls: 'panel-header-gray',
		selectOnCheck: false,
		checkOnSelect: false,
		striped: true,
		rownumbers: true,
		pageSize: 999999999,
		className: "web.DHCIPBILLOEORIItemGroup",
		queryName: "QryOEOREList",
		onColumnsLoad: function(cm) {
			cm.unshift({field: 'ck', checkbox: true});   //往数组开始位置增加一项
			for (var i = (cm.length-1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TExecRowID", "TPBORowID"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (!cm[i].width) {
					cm[i].width = 150;
					if ($.inArray(cm[i].field, ["TArcimDesc"]) != -1) {
						cm[i].width = 260;
					}
				}
			}
		},
		onLoadSuccess: function (data) {
			$(this).datagrid("clearChecked");
		},
		onCheck: function(index, row) {
			calcAmount();
		},
		onUncheck: function(index, row) {
			calcAmount();
		},
		onCheckAll: function(rows) {
			calcAmount();
		},
		onUncheckAll: function(rows) {
			$("#amount").numberbox("clear");
		}
	});
}

function loadOEOREList() {
	var ordCatAry = $("#ordCat").combobox("getValues");
	var ordCatStr = ordCatAry.join("^");
	var ordSubCatAry = $("#ordSubCat").combobox("getValues");
	var ordSubCatStr = ordSubCatAry.join("^");
	var arcimAry = $("#arcim").combobox("getValues");
	var arcimStr = arcimAry.join("^");
	var ordItemAry = $("#ordItem").combogrid("getValues");
	var ordItemStr = ordItemAry.join("^");

	var queryParams = {
		ClassName: "web.DHCIPBILLOEORIItemGroup",
		QueryName: "QryOEOREList",
		BillNo: CV.BillID,
		StDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		OrdCatStr: ordCatStr,
		OrdSubCatStr: ordSubCatStr,
		ArcimStr: arcimStr,
		OEOrdItemStr: ordItemStr,
		rows: 999999999
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
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!CV.BillID) {
				$.messager.popover({msg: "请先账单", type: "info"});
				return reject();
			}
			if (execAry.length == 0) {
				$.messager.popover({msg: "请选择需要拆分的医嘱", type: "info"});
				return reject();
			}
			if (getValueById("amount") < 0) {
				$.messager.popover({msg: "拆分的金额不能小于0", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "确认拆分账单？", function(r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _split = function() {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "web.DHCIPBILLOEORIItemGroup",
				MethodName: "RINBILL",
				bill: CV.BillID,
				userId: PUBLIC_CONSTANT.SESSION.USERID,
				execAry: execAry
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.alert("提示", "拆分账单成功，请注意进行封账，否则不能账单", "success", function() {
						return resolve();
					});
					return;
				}
				$.messager.popover({msg: "拆分账单失败：" + (myAry[1] || myAry[0]), type: "error"});
				reject();
			});
		});
	};
	
	var _success = function () {
		if (window.parent && (typeof window.parent.setDefTabFromIframe == "function")) {
			window.parent.setDefTabFromIframe();
		}
	};
	
	if ($("#btn-split").hasClass("l-btn-disabled")) {
		return;
	}
	$("#btn-split").linkbutton("disable");
	
	var execAry = GV.OEOREList.getChecked().filter(function(row) {
		return row.TExecRowID;
	}).map(function(row) {
		return row.TExecRowID;
	});
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_split)
		.then(function() {
			_success();
		}, function() {
			$("#btn-split").linkbutton("enable");
		});
}

/**
* 计算金额
*/
function calcAmount() {
	var amount = GV.OEOREList.getChecked().filter(function(row) {
		return (row.TPBORowID != "");
	}).reduce(function(total, cur) {
		return Number(total).add(cur.TAmt);
	}, 0);
	setValueById("amount", amount);
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
	
	GV.OEOREList.options().pageNumber = 1;   //跳转到第一页
	GV.OEOREList.clearChecked();
	GV.OEOREList.loadData({total: 0, rows: []});
}