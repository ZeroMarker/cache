/**
 * FileName: dhcbill.ipbill.depaccount.js
 * Anchor: ZhYW
 * Date: 2019-12-27
 * Description: 预交金账
 */

$(function () {
	initQueryMenu();
	initAccountList();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadAccountList();
		}
	});
	
	$HUI.linkbutton("#btn-handin", {
		onClick: function () {
			handinClick();
		}
	});
	
	$HUI.checkbox("#checkHand", {
		onChecked: function(e, value) {
			handChecked();
		},
		onUnchecked: function(e, value) {
			handUnchecked();
		}
	});
	
	getDate();
}

/**
* 取开始结束日期
*/
function getDate() {
	var stDate = $.m({ClassName: "web.UDHCJFAcount", MethodName: "getstdate", flag: CV.AccFlag, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
	setValueById("stDate", stDate);
	setValueById("endDate", CV.DefEndDate);
}

function initAccountList() {
	var toolbar = [{
			text: '打印',
			iconCls: 'icon-print',
			handler: function () {
				printClick();
			}
		}, {
			text: '打印明细',
			iconCls: 'icon-print',
			handler: function () {
				printDtlClick();
			}
		}
	];
	GV.AccountList = $HUI.datagrid("#accountList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		toolbar: toolbar,
		columns:[[{title: '日期', field: 'Tprtdate', width: 180},
				  {title: '摘要', field: 'Tpatinfo', width: 200},
				  {title: '借方', field: 'Tjfamt', align: 'right', width: 180},
				  {title: '贷方', field: 'Tdfamt', align: 'right', width: 180},
				  {title: '借/贷', field: 'Tjd', width: 120},
				  {title: '余额', field: 'Tremain', align: 'right', width: 180},
				  {title: 'Tjob', field: 'Tjob', hidden: true},
				  {title: '收回时间', field: 'Tshdate', width: 160,
					formatter: function (value, row, index) {
						return value + " " + row.Tshtime;
					}
				  }
			]]
	});
}

function loadAccountList() {
	var queryParams = {
		ClassName: "web.UDHCJFAcount",
		QueryName: "FindYjAcount",
		stdate: getValueById("stDate"),
		sttime: "",
		enddate: getValueById("endDate"),
		endtime: "",
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		jsflag: getValueById("checkHand") ? 1 : 0
	};
	loadDataGridStore("accountList", queryParams);
}

function handChecked() {
	enableById("stDate");
	disableById("btn-handin");
	$.m({
		ClassName: "web.UDHCJFAcount",
		MethodName: "getlastAcctInfo",
		Flag: CV.AccFlag,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(rtn) {
		var myAry = rtn.split("^");
		setValueById("stDate", myAry[0]);
		setValueById("endDate", myAry[1]);
	});
}

function handUnchecked() {
	disableById("stDate");
	enableById("btn-handin");
	getDate();
}

/**
* 结算
*/
function handinClick() {
	if (GV.AccountList.getData().total == 0) {
		$.messager.popover({msg: "请先查询后再结算", type: "info"});
		return;
	}
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var myAry = judgeDate();
	if (myAry[3] == "Y") {
		$.messager.popover({msg: "当日已经结算，不能再次结算", type: "info"});
		return;
	}
	if (myAry[4] != 0) {
		switch(myAry[4]) {
		case "-1":
			$.messager.popover({msg: "开始日期大于结束日期，不能结算", type: "info"});
			break;
		case "-2":
			$.messager.popover({msg: "不能结算到当天", type: "info"});
			break;
		default:
			$.messager.popover({msg: "错误代码：" + myAry[4], type: "info"});
		}
		return;
	}
	
	var job = GV.AccountList.getData().rows[0].Tjob;
	var acctInfo = stDate + "^" + endDate;
	$.messager.confirm("确认", "是否确认结算？", function(r) {
		if (r) {
			$.m({
				ClassName: "web.UDHCJFAcount",
				MethodName: "InsertRemain",
				adduser: PUBLIC_CONSTANT.SESSION.USERID,
				flag: CV.AccFlag,
				job: job,
				hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
				AcctInfo: acctInfo
			}, function(rtn) {
				switch(rtn) {
				case "0":
					$.messager.popover({msg: "结算成功", type: "success"});
					break;
				default:
					$.messager.popover({msg: "结算失败，错误代码：" + rtn, type: "error"});
				}
			});
		}
	});
}

function judgeDate() {
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var rtn = $.m({ClassName: "web.UDHCJFAcount", MethodName: "JudgeDate", flag: CV.AccFlag, stDate: stDate, endDate: endDate, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
	return rtn.split("^");
}

/**
* 打印
*/
function printClick() {
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var fileName = "DHCBILL-IPBILL-住院预交金账汇总.rpx&stDate=" + stDate + "&endDate=" + endDate + "&HOSPID=" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var maxHeight = $(window).height() * 0.8;
	var maxWidth = $(window).width() * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

/**
* 打印明细
*/
function printDtlClick() {
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var fileName = "DHCBILL-IPBILL-住院预交金账明细报表.rpx&stDate=" + stDate + "&endDate=" + endDate + "&HOSPID=" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var maxHeight = $(window).height() * 0.8;
	var maxWidth = $(window).width() * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}
