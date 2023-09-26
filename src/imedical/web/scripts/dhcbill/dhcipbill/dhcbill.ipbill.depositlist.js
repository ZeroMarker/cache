/**
 * FileName: dhcbill.ipbill.depositlist.js
 * Anchor: ZhYW
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
		url: $URL + '?ClassName=web.DHCIPBillDeposit&QueryName=FindGrpDepType&ResultSetType=array',
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
			var defDeType = getParam("DepositType");
			if (defDeType) {
				$.each(data, function (index, item) {
					if (item.id == defDeType) {
						$("#depositType").combobox("select", defDeType);
						return false;
					}
				});
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
		striped: true,
		bodyCls: 'panel-header-gray',
		fitColumns: true,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		toolbar: '#toolbar',
		columns:[[{title: '收款时间', field: 'Tprtdate', width: 150,
					formatter: function (value, row, index) {
						if (value) {
							return value + " " + row.Tprttime;
						}
					}
				  },
				  {title: '金额', field: 'Tpayamt', align: 'right', width: 100},
				  {title: 'TPaymodeDR', field: 'TPaymodeDR', hidden: true},
				  {title: '支付方式', field: 'Tpaymode', width: 80},
				  {title: '状态', field: 'Tprtstatus', hidden: true},
				  {title: '收据状态', field: 'TStatus', width: 100,
				   	styler: function(value, row, index) {
						if (("^1^4^").indexOf("^" + row.Tprtstatus + "^") == -1) {
							return 'color: #FF0000;';
						}
					}
				   },
				  {title: 'TArrcpId', field: 'TArrcpId', hidden: true},
				  {title: '收据号', field: 'Trcptno', width: 120},
				  {title: '收款员', field: 'Tadduser', width: 100},
				  {title: '支票号', field: 'Tcardno', width: 70},
				  {title: '单位', field: 'Tcompany', width: 70},
				  {title: '银行', field: 'Tbank', width: 70},
				  {title: 'TjkDR', field: 'TjkDR', hidden: true},
				  {title: '是否结账', field: 'Tjkflag', width: 80,
					formatter: function (value, row, index) {
						if (value) {
							return (value == "Y") ? "<font color='#21ba45'>是</font>" : "<font color='#f16e57'>否</font>";
						}
					}
				  },
				  {title: '押金类型', field: 'TDepositType', width: 100},
				  {title: '结算状态', field: 'Tpaystatus', width: 80}
			]]
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