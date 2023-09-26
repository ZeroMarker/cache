﻿/**
 * FileName: dhcbill.opbill.dailycollectlist.js
 * Anchor: ZhYW
 * Date: 2018-03-12
 * Description: 门诊日结汇总列表
 */

$(function () {
	var columnAry = [{field: 'ck', checkbox: true},
					 {title: 'TUserId', field: 'TUserId', hidden: true},
					 {title: '结账人', field: 'TUserName', width: 100},
					 {title: '结账日期', field: 'TDate', width: 100},
					 {title: '结账时间', field: 'TTime', width: 100},
					 {title: '结账号', field: 'TRowId', width: 100},
					 {title: '开始日期', field: 'TStDate', width: 100},
					 {title: '开始时间', field: 'TStTime', width: 100},
					 {title: '结束日期', field: 'TEndDate', width: 100},
					 {title: '结束时间', field: 'TEndTime', width: 100},
					 {title: '接收号', field: 'TReceId', width: 100},
					 {title: '预交金总张数', field: 'TAccPreNum', width: 100},
					 {title: '预交金总金额', field: 'TAccPreSum', align: 'right', width: 110, formatter: formatAmt},
					 {title: '预交金收款张数', field: 'TNorAccPreNum', width: 110},
					 {title: '预交金收款金额', field: 'TNorAccPreSum', align: 'right', width: 110, formatter: formatAmt},
					 {title: '预交金退费张数', field: 'TRefAccPreNum', width: 110},
					 {title: '预交金退费金额', field: 'TRefAccPreSum', align: 'right', width: 110, formatter: formatAmt},
					 {title: '发票总张数', field: 'TInvNum', width: 100},
					 {title: '发票总金额', field: 'TInvSum', align: 'right', width: 100, formatter: formatAmt},
					 {title: '发票总号段', field: 'TInvNoStr'},
					 {title: '作废发票张数', field: 'TParkInvNum', width: 100},
					 {title: '作废发票金额', field: 'TParkInvSum', align: 'right', width: 100, formatter: formatAmt},
					 {title: '作废发票号码', field: 'TParkInvNoStr'},
					 {title: '红冲发票张数', field: 'TRefInvNum', width: 100},
					 {title: '红冲发票金额', field: 'TRefInvSum', align: 'right', width: 100, formatter: formatAmt},
					 {title: '红冲发票号码', field: 'TRefInvNoStr'},
					 {title: '跳号发票数量', field: 'TVoidInvNum', width: 100},
					 {title: '跳号发票号码', field: 'TVoidInvNoStr'}
			];

	if (GV.ReceFlag != 1) {
		var str = 'ck^TReceId';    //不显示的列
		$.each(columnAry, function (index, column) {
			if (column) {
				if (str.indexOf(column.field) != -1) {
					columnAry.splice($.inArray(column, columnAry), 1);
				}
			}
		});
	}

	$HUI.datagrid("#collectList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		checkOnSelect: false,
		selectOnCheck: false,
		fitColumns: false,
		autoRowHeight: false,
		url: $URL,
		pagination: true,
		rownumbers: true,
		pageSize: 100,
		pageList: [100, 200],
		columns: [columnAry],
		toolbar: [],
		idField: 'TRowId',
		queryParams: {
			ClassName: "web.DHCOPBillDailyCollect",
			QueryName: "FindDailyCollect",
			stDate: getParam('stDate'),
			endDate: getParam('endDate'),
			guserStr: getParam('guserStr'),
			receId: getParam('receId'),
			receFlag: getParam('receFlag'),
			hospDR: getParam('hospDR'),
			groupDR: getParam('groupDR')
		},
		onLoadSuccess: function (data) {
			var hasDisabledRow = false;
			$.each(data.rows, function (index, row) {
				if (!row.TReceId) {
					return true;
				}
				hasDisabledRow = true;
				$("#collectList").parent().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = hasDisabledRow;
			});
			//有disabled行时,表头也disabled
			$("#collectList").parent().find(".datagrid-header-row input:checkbox")[0].disabled = hasDisabledRow;
		},
		onDblClickRow: function (index, row) {
			scanHandinDetails(row);
		}
	});
});

function getCheckedFootIdStr() {
	var rows = $('#collectList').datagrid('getChecked');
	var myAry = new Array();
	$.each(rows, function (index, row) {
		if (row) {
			var footId = row.TRowId;
			if (footId) {
				myAry.push(footId);
			}
		}
	});
	var footIdStr = myAry.join('^');
	return footIdStr;
}

function scanHandinDetails(row) {
	var footId = row.TRowId;
	if (footId == "") {
		return;
	}
	var stDate = row.TStDate;
	var stTime = row.TStTime;
	var endDate = row.TEndDate;
	var endTime = row.TEndTime;
	var guser = row.TUserId;
	var receId = row.TReceId;
	var url = 'dhcbill.dailymaintabs.csp?&businessType=OPD' + '&stDate=' + stDate + '&stTime=' + stTime;
	url += '&endDate=' + endDate + '&endTime=' + endTime + '&footId=' + footId;
	url += '&receId=' + receId + '&guser=' + guser + '&linkFlag=Y';
	websys_showModal({
		url: url,
		title: '日结明细',
		iconCls: 'icon-w-list',
		height: '85%',
		width: '90%'
	});
}