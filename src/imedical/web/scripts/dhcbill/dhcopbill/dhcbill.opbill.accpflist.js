/**
 * FileName: dhcbill.opbill.accpflist.js
 * Author: ZhYW
 * Date: 2021-12-14
 * Description: 门诊预交金余额汇总查询
 */

$(function () {
	GenUserHospComp();
	initQueryMenu();
	initAccPFList();
});

function initQueryMenu () {
	$(".datebox-f").datebox("setValue", CV.DefDate);

	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadAccPFList();
		}
	});
}

function initAccPFList () {
	$HUI.datagrid("#accpfList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.UDHCACFinBRRSQuery",
		queryName: "ReadPFootList",
		onColumnsLoad: function(cm) {
			cm.push({title: '按收费员汇总', field: 'TPFRowID', width: 150,
				    formatter: function (value, row, index) {
						if (row.PFRowID) {
							return "<a href='javascript:;' onclick='colListByUser(" + JSON.stringify(row) + ")'>" + row.PFRowID + "</a>";
						}
					}
				   });
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TBDate", "TEDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "PFRowID") {
					cm[i].title = "导航号";
					cm[i].formatter = function (value, row, index) {
						if (value) {
							return "<a href='javascript:;' onclick='accPFDetail(" + JSON.stringify(row) + ")'>" + value + "</a>";
						}
					};
				}
				if (cm[i].field == "UserName") {
					cm[i].title = "汇总人员";
				}
				if (cm[i].field == "TBTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TBDate + " " + value;
					};
				}
				if (cm[i].field == "TETime") {
					cm[i].formatter = function (value, row, index) {
						return row.TEDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["TBTime", "TETime"]) != -1) {
						cm[i].width = 155;
					}
				}
			}
		}
	});
}

function loadAccPFList() {
	var queryParams = {
		ClassName: "web.UDHCACFinBRRSQuery",
		QueryName: "ReadPFootList",
		StDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		HospId: $HUI.combogrid("#_HospUserList").getValue()
	};
	loadDataGridStore("accpfList", queryParams);
}

function accPFDetail(row) {
	var url = "dhcbill.opbill.accpfdtl.csp?PFRowID=" + row.PFRowID;
	websys_showModal({
		url: url,
		title: $g('余额汇总合计'),
		iconCls: 'icon-w-list'
	});
}

function colListByUser(row) {
	var url = "dhcbill.opbill.accpfdtl.cashier.csp?PFRowID=" + row.PFRowID;
	websys_showModal({
		url: url,
		title: $g('按收费员汇总'),
		iconCls: 'icon-w-list'
	});
}