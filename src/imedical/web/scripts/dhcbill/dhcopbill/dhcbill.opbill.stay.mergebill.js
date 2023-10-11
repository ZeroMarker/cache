/**
 * FileName: dhcbill.opbill.stay.mergebill.js
 * Author: ZhYW
 * Date: 2022-01-04
 * Description: 急诊留观结算合并账单
 */

$(function () {
	initQueryMenu();
	initBillList();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-merge", {
		onClick: function () {
			mergeClick();
		}
	});
}

function initBillList() {
	GV.BillList = $HUI.datagrid("#billList", {
		fit: true,
		bodyCls: 'panel-header-gray',
		selectOnCheck: false,
		checkOnSelect: false,
		striped: true,
		rownumbers: true,
		pageSize: 999999999,
		columns: [[{title: 'ck', field: 'ck', checkbox: true},
				   {title: '账单开始日期', field: 'dateFrom', width: 100},
				   {title: '账单结束日期', field: 'dateTo', width: 100},
				   {title: '总金额', field: 'totalAmt', width: 100, align: 'right'},
				   {title: '折扣金额', field: 'discAmt', width: 100, align: 'right'},
				   {title: '记账金额', field: 'payorAmt', width: 100, align: 'right'},
				   {title: '自付金额', field: 'patShareAmt', width: 100, align: 'right'},
				   {title: 'billId', field: 'billId', hidden: true}
			]],
		url: $URL,
		queryParams: {
			ClassName: "BILL.OP.BL.IntBill",
			QueryName: "QryBillList",
			adm: CV.EpisodeID,
			rows: 999999999
		},
		onLoadSuccess: function (data) {
			disableById("btn-merge");
			if (data.total == 2) {
				$(this).datagrid("checkAll");
			}
		},
		onCheck: function(index, row) {
			ctrlAbleMerge();
		},
		onUncheck: function(index, row) {
			ctrlAbleMerge();
		},
		onCheckAll: function(rows) {
			ctrlAbleMerge();
		},
		onUncheckAll: function(rows) {
			ctrlAbleMerge();
		}
	});
}

function ctrlAbleMerge() {
	if (GV.BillList.getChecked().length == 2) {
		enableById("btn-merge");
		return;
	}
	disableById("btn-merge");
}

/**
* 合并账单
*/
function mergeClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!CV.EpisodeID) {
				$.messager.popover({msg: "患者不存在", type: "info"});
				return reject();
			}
			if (billIdAry.length != 2) {
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认合并账单？", function(r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _merge = function() {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "BILL.OP.BL.IntBill",
				MethodName: "MergeBill",
				fBillId: billIdAry[1],
				tBillId: billIdAry[0],    //将账单号小的作为目标账单
				userId: PUBLIC_CONSTANT.SESSION.USERID
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.alert("提示", "合并账单成功", "success", function() {
						return resolve();
					});
					return;
				}
				$.messager.popover({msg: "合并账单失败：" + (myAry[1] || myAry[0]), type: "error"});
				reject();
			});
		});
	};
	
	var _success = function() {
		GV.BillList.reload();
		websys_showModal("options").callbackFun();
		var notPayedNum = getNotPayedBillNum();
		if (!(notPayedNum > 1)) {
			websys_showModal("close");
		}
	};

	if ($("#btn-merge").linkbutton("options").disabled) {
		return;
	}
	$("#btn-merge").linkbutton("disable");
	
	var billIdAry = GV.BillList.getChecked().map(function(row) {
		return row.billId;
	}).sort(function(a,b) {
		return a - b;
	});
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_merge)
		.then(function() {
			_success();
			$("#btn-merge").linkbutton("enable");
		}, function () {
			$("#btn-merge").linkbutton("enable");
		});
}

function getNotPayedBillNum() {
	return $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "JudgeBillNum", Adm: CV.EpisodeID}, false);
}