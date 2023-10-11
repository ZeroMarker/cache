/**
 * FileName: dhcbill.opbill.stay.intpay.itm.js
 * Author: ZhYW
 * Date: 2021-12-20
 * Description: 急诊留观结算拆分账单
 */

$(function () {
	initQueryMenu();
	initPBOList();
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
		url: $URL + "?ClassName=BILL.OP.BL.IntBill&QueryName=QryARCItmMast&ResultSetType=array&billId=" + CV.BillID,
		multiple: true,
		mode: 'remote',
		method: 'get',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		selectOnNavigation: false,
		onBeforeLoad: function (param) {
			param.desc = param.q;
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
		url: $URL + "?ClassName=BILL.OP.BL.IntBill&QueryName=QryOrdItm&billId=" + CV.BillID,
		mode: 'remote',
		method: 'get',
		delay: 200,
		lazy: true,
		idField: 'oeitm',
		textField: 'arcimDesc',
		pagination: true,
		multiple: true,
		selectOnNavigation: false,
		columns: [[{field: 'ck', title: 'ck', checkbox: true},
				   {field: 'arcimDesc', title: '医嘱', width: 200},
			 	   {field: 'ordDate', title: '医嘱日期', width: 100},
			       {field: 'oeitm', title: '医嘱ID', width: 80}
		  ]],
		onBeforeLoad: function (param) {
			param.desc = param.q;
		}
	});
}

function initPBOList() {
	GV.PBOList = $HUI.datagrid("#pboList", {
		fit: true,
		border: true,
		bodyCls: 'panel-header-gray',
		selectOnCheck: false,
		checkOnSelect: false,
		striped: true,
		rownumbers: true,
		pageSize: 999999999,
		className: "BILL.OP.BL.IntBill",
		queryName: "QryPBOList",
		onColumnsLoad: function(cm) {
			cm.unshift({field: 'ck', checkbox: true});   //往数组开始位置增加一项
			for (var i = (cm.length-1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["oeitm", "pboRowId"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (!cm[i].width) {
					cm[i].width = 150;
					if ($.inArray(cm[i].field, ["arcimDesc"]) != -1) {
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

function loadPBOList() {
	var ordCatAry = $("#ordCat").combobox("getValues");
	var ordCatStr = ordCatAry.join("^");
	var ordSubCatAry = $("#ordSubCat").combobox("getValues");
	var ordSubCatStr = ordSubCatAry.join("^");
	var arcimAry = $("#arcim").combobox("getValues");
	var arcimStr = arcimAry.join("^");
	var ordItemAry = $("#ordItem").combogrid("getValues");
	var ordItemStr = ordItemAry.join("^");

	var queryParams = {
		ClassName: "BILL.OP.BL.IntBill",
		QueryName: "QryPBOList",
		billId: CV.BillID,
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		ordCatStr: ordCatStr,
		ordSubCatStr: ordSubCatStr,
		arcimStr: arcimStr,
		oeitmStr: ordItemStr,
		sessionStr: getSessionStr(),
		rows: 999999999
	}
	loadDataGridStore("pboList", queryParams);
}

function findClick() {
	loadPBOList();
}

/**
* 拆分账单
*/
function splitClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!CV.BillID) {
				$.messager.popover({msg: "账单不存在", type: "info"});
				return reject();
			}
			if (pboAry.length == 0) {
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
				ClassName: "BILL.OP.BL.IntBill",
				MethodName: "RINBILL",
				billId: CV.BillID,
				userId: PUBLIC_CONSTANT.SESSION.USERID,
				pboList: pboAry
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.alert("提示", "拆分账单成功", "success", function() {
						return resolve();
					});
					return;
				}
				$.messager.popover({msg: "拆分账单失败：" + (myAry[1] || myAry[0]), type: "error"});
				reject();
			});
		});
	};
	
	var _success = function() {
		if (window.parent && (typeof window.parent.setDefTabFromIframe == "function")) {
			window.parent.setDefTabFromIframe();
		}
	};
	
	if ($("#btn-split").linkbutton("options").disabled) {
		return;
	}
	$("#btn-split").linkbutton("disable");
	
	var pboAry = GV.PBOList.getChecked().filter(function(row) {
		return row.pboRowId;
	}).map(function(row) {
		return row.pboRowId;
	});
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_split)
		.then(function() {
			_success();
			$("#btn-split").linkbutton("enable");
		}, function () {
			$("#btn-split").linkbutton("enable");
		});
}

/**
* 计算金额
*/
function calcAmount() {
	var amount = GV.PBOList.getChecked().filter(function(row) {
		return (row.pboRowId != "");
	}).reduce(function(total, cur) {
		return Number(total).add(cur.amt);
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
		ClassName: "BILL.OP.BL.IntBill",
		QueryName: "QryOrdItm",
		billId: "",
		desc: ""
	});

	$("#pboList").datagrid("clearChecked").datagrid("load", {
		ClassName: "BILL.OP.BL.IntBill",
		QueryName: "QryPBOList",
		billId: "",
		stDate: "",
		endDate: "",
		ordCatStr: "",
		ordSubCatStr: "",
		arcimStr: "",
		oeitmStr: ""
	});
}