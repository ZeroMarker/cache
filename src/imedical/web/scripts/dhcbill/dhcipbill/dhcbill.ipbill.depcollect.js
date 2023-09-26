/**
 * FileName: dhcbill.ipbill.depcollect.js
 * Anchor: ZhYW
 * Date: 2019-12-06
 * Description: 预交金汇总
 */

var GV = {};

$(function () {
	initQueryMenu();
	initDepList();
});

function initQueryMenu() {
	var today = getDefStDate(0);
	$(".datebox-f").datebox("setValue", today);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadDepList();
		}
	});
	
	//操作员
	$HUI.combobox("#guser", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCJFDepositSearch&QueryName=FindIPCashier&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
	
	//支付方式
	$HUI.combobox("#paymode", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCOPOtherLB&QueryName=ReadCTPayMode&ResultSetType=array',
		valueField: 'CTPM_RowId',
		textField: 'CTPM_Desc',
		defaultFilter: 4
	});
}

function initDepList() {
	$HUI.datagrid("#depList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		columns:[[{title: '患者姓名', field: 'Tpatname', width: 100},
				  {title: '登记号', field: 'Tregno', width: 100},
				  {title: '收据号', field: 'Trcptno', width: 100},
				  {title: '金额', field: 'Tpayamt', align: 'right', width: 150},
				  {title: '支付方式', field: 'Tpaymode', width: 150},
				  {title: '收据状态', field: 'Tstatus', width: 100},
				  {title: '收费时间', field: 'Tprtdate', width: 150,
				  	formatter: function (value, row, index) {
						return value + " " + row.Tprttime;
					}
				  },
				  {title: '交账日期', field: 'Thanddate', width: 100},
				  {title: '收费员', field: 'Tuser', width: 100},
				  {title: 'Trowid', field: 'Trowid', hidden: true},
				  {title: '科室', field: 'Tadmloc', width: 100},
				  {title: '支票号', field: 'Tchequeno', width: 100}
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFDepositSearch",
			QueryName: "FindUserDepLIst",
			stDate: getValueById("stDate"),
			endDate: getValueById("endDate"),
			userId: getValueById("guser") || "",
			flag: getValueById("isRefRcpt"),
			paymId: getValueById("paymode") || "",
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		},
		rowStyler: function (index, row) {
			if ((row.Tpatname.indexOf("小计") != -1) || (row.Tpatname.indexOf("合计") != -1)) {
				return 'font-weight: bold';
			}
		}
	});
}

function loadDepList() {
	var queryParams = {
		ClassName: "web.UDHCJFDepositSearch",
		QueryName: "FindUserDepLIst",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		userId: getValueById("guser") || "",
		flag: getValueById("isRefRcpt") ? 1 : 0,
		paymId: getValueById("paymode") || "",
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("depList", queryParams);
}