/**
 * FileName: dhcbill.ipbill.paymentmonad.js
 * Author: Suhuide
 * Date: 2018-06-28
 * Modify: ZhYW 2019-07-12
 * Description: 住院押金催款单
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkMin: {    //校验最小值
	    validator: function(value) {
		    return ((value == "-") || (value > -1000000000));
		},
		message: $g("金额输入过小")
	},
	checkMax: {    //校验最大值
	    validator: function(value) {
		    return ((value == "-") || (value < 1000000000));
		},
		message: $g("金额输入过大")
	}
});

var initQueryMenu = function () {
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadPaymentMonadList();
		}
	});
	
	$HUI.linkbutton("#btn-export", {
		onClick: function () {
			exportClick();
		}
	});
	
	$HUI.linkbutton("#btn-print", {
		onClick: function () {
			printClick();
		}
	});
	
	$HUI.linkbutton("#btn-print2", {
		onClick: function () {
			print2Click();
		}
	});
	
	$HUI.combobox("#menu-ward", {
		panelHeight: 180,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryWard&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		value: PUBLIC_CONSTANT.SESSION.WARDID,
		blurValidValue: true,
		defaultFilter: 5,
		filter: function(q, row) {
			var opts = $(this).combobox("options");
			var mCode = false;
			if (row.contactName) {
				mCode = row.contactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			return mCode || mValue;
		}
	});
	
	$HUI.combobox("#menu-insType", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryAdmReason&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		onBeforeLoad: function (param) {
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
}

var initListGrid = function () {
	GV.ListGrid = $HUI.datagrid("#paymentmonadList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		idField: 'TAdm',
		className: "web.UDHCJFCKD",
		queryName: "QryPatientList",
		onColumnsLoad: function(cm) {
			cm.unshift({field: 'ck', checkbox: true});   //往数组开始位置增加一项
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TDept", "TAdm"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TBalAmt") {
					cm[i].styler = function(value, row, index) {
						if (value < 0) {
							return "color:#FF0000;";
						}
					}
				}
				if (cm[i].field == "TMrDiagnos") {
					cm[i].showTip = true;
					cm[i].tipWidth = 180;
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["TSex", "TAge", "TBedCode"]) != -1) {
						cm[i].width = 50;
					}
					if (cm[i].field == "TAdmDatTime") {
						cm[i].width = 155;
					}
					if (cm[i].field == "TMrDiagnos") {
						cm[i].width = 180;
					}
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFCKD",
			QueryName: "QryPatientList",
			wardId: getValueById("menu-ward") || "",
			balance: getValueById("menu-balance"),
			episodeId: CV.EpisodeID,
			insTypeId: getValueById("menu-insType") || "",
			selAdmStr: ""
		},
		onLoadSuccess: function (data) {
			$(this).datagrid("clearChecked");
		}
	});
}

function loadPaymentMonadList() {
	if (!checkData()) {
		return;
	}
	var queryParams = {
		ClassName: "web.UDHCJFCKD",
		QueryName: "QryPatientList",
		wardId: getValueById("menu-ward") || "",
		balance: getValueById("menu-balance"),
		episodeId: CV.EpisodeID,
		insTypeId: getValueById("menu-insType") || "",
		selAdmStr: ""
	};
	loadDataGridStore("paymentmonadList", queryParams);
}

/**
 * 导出催款单明细
 * @method exportClick
 * @author Suhuide
 */
function exportClick() {
	if (!checkData()) {
		return;
	}
	var wardId = getValueById("menu-ward") || "";
	var balance = getValueById("menu-balance");
	var episodeId = CV.EpisodeID;
	var insTypeId = getValueById("menu-insType") || "";
	var selAdmStr = "";
	var fileName = "DHCBILL-IPBILL-YJCKD.rpx&wardId=" + wardId + "&balance=" + balance + "&episodeId=" + episodeId + "&insTypeId=" + insTypeId + "&selAdmStr=" + selAdmStr;
	var maxWidth = $(window).width() * 0.8;
	var maxHeight = $(window).height() * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

/**
 * 打印催款单信息
 * @method printClick
 * @author Suhuide
 */
function printClick() {
	if (!checkData()) {
		return;
	}
	var selAdmStr = getCheckedAdmStr();
	if (!selAdmStr) {
		$.messager.popover({msg: "请选择要打印的催款明细", type: "info"});
		return;
	}
	var wardId = getValueById("menu-ward") || "";
	var balance = getValueById("menu-balance");
	var episodeId = CV.EpisodeID;
	var insTypeId = getValueById("menu-insType") || "";
	var fileName = "DHCBILL-IPBILL-YJCKD1.rpx&wardId=" + wardId + "&balance=" + balance + "&episodeId=" + episodeId + "&insTypeId=" + insTypeId + "&selAdmStr=" + selAdmStr;
	var maxWidth = $(window).width() * 0.8;
	var maxHeight = $(window).height() * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

function print2Click() {
	if (!checkData()) {
		return;
	}
	var selAdmStr = getCheckedAdmStr();
	if (!selAdmStr) {
		$.messager.popover({msg: "请选择要打印的催款明细", type: "info"});
		return;
	}
	var wardId = getValueById("menu-ward") || "";
	var balance = getValueById("menu-balance");
	var episodeId = CV.EpisodeID;
	var insTypeId = getValueById("menu-insType") || "";
	var fileName = "DHCBILL-IPBILL-YJCKD2.rpx&wardId=" + wardId + "&balance=" + balance + "&episodeId=" + episodeId + "&insTypeId=" + insTypeId + "&selAdmStr=" + selAdmStr;
	var maxWidth = $(window).width() * 0.8;
	var maxHeight = $(window).height() * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

function getCheckedAdmStr() {
    return GV.ListGrid.getChecked().map(function (row) {
        return row.TAdm;
    }).join("^");
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

$(function () {
	initQueryMenu();
	initListGrid();
});