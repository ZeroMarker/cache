/**
 * FileName: dhcbill.ipbill.depositlist.js
 * Author: ZhYW
 * Date: 2019-03-23
 * Description: 住院押金明细
 */

$(function () {
	initQueryMenu();
	initDepositList();
});

function initQueryMenu() {
	//押金类型
	$HUI.combobox("#depositType", {
		panelHeight: 'auto',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryGrpDepType&ResultSetType=array',
		method: 'GET',
		editable: false,
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function(param) {
			param.groupId = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onLoadSuccess: function(data) {
			$(this).combobox("clear");
			if (CV.DepositType && $.hisui.getArrayItem(data, "id", CV.DepositType)) {
				$("#depositType").combobox("select", CV.DepositType);
			}
		},
		onSelect: function(rec) {
			loadDepositList();
		}
	});
}

function initDepositList() {
	$HUI.datagrid("#depositList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		className: "web.DHCIPBillDeposit",
		queryName: "FindDeposit",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TPrtDate", "Tbbackdate", "TDepositTypeDR", "TDepositTypeCode", "TAutoFlag", "TReRcptNo", "TLostRegDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TDepRowId", "TPaymodeDR", "TPrtStatus", "TUserDR", "TFootId", "TInitPrtRowId", "TStrikeInvPrtId", "TLostRegistDR"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TPrtTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TPrtDate + " " + value;
					};
				}
				if (cm[i].field == "TStatus") {
					cm[i].styler = function(value, row, index) {
						if ([1, 4].indexOf(+row.TPrtStatus) == -1) {
							return "color: #FF0000;";
						}
					};
				}
				if (cm[i].field == "TFootFlag") {
					cm[i].formatter = function (value, row, index) {
					   	if (value) {
						   	var color = (value == "Y") ? "#21ba45" : "#f16e57";
							return "<font color=\"" + color + "\">" + ((value == "Y") ? $g("是") : $g("否")) + "</font>";
						}
					};
				}
				if (cm[i].field == "TPayedFlag") {
					cm[i].formatter = function (value, row, index) {
					   	if (value) {
							return (value == "Y") ? $g("已结") : $g("未结");
						}
					};
				}
				if (cm[i].field == "Tbbackflag") {
					cm[i].formatter = function (value, row, index) {
					   	if (value) {
						   	var color = (value == "Y") ? "#21ba45" : "#f16e57";
							return "<font color=\"" + color + "\">" + ((value == "Y") ? $g("是") : $g("否")) + "</font>";
						}
					};
				}
				if (cm[i].field == "Tbbacktime") {
					cm[i].formatter = function (value, row, index) {
						return row.Tbbackdate + " " + value;
					};
				}
				if (cm[i].field == "TIsLostReg") {
					cm[i].formatter = function (value, row, index) {
					    if (row.TDepRowId) {
							return (row.TLostRegistDR > 0) ? $g("是") : $g("否");
						}
					};
				}
				if (cm[i].field == "TLostRegTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TLostRegDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["TPrtTime", "Tbbacktime", "TLostRegTime"]) != -1) {
						cm[i].width = 155;
					}
				}
			}
		}
	});
}

/**
 * 加载押金Grid数据
 */
function loadDepositList() {
	var queryParams = {
		ClassName: "web.DHCIPBillDeposit",
		QueryName: "FindDeposit",
		adm: getParam("EpisodeID"),
		depositType: getValueById("depositType")
	}
	loadDataGridStore("depositList", queryParams);
}