/**
 * FileName: dhcbill.ipbill.chequeback.js
 * Anchor: ZhYW
 * Date: 2020-01-02
 * Description: 支票到账
 */

var GV = {};

$(function () {
	initQueryMenu();
	initChequeList();
});

function initQueryMenu() {
	var defDate = getDefStDate(0);
	$(".datebox-f").datebox("setValue", defDate);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadChequeList();
		}
	});

	$HUI.linkbutton("#btn-insert", {
		onClick: function () {
			insertClick();
		}
	});
	
	$HUI.linkbutton("#btn-update", {
		onClick: function () {
			updateClick();
		}
	});
	
	//支付方式
	$HUI.combobox("#paymode", {
		panelHeight: 'auto',
		blurValidValue: true,
		valueField: 'id',
		textField: 'text',
		data: [{id: '支票', text: '支票'},
		       {id: '银行卡', text: '银行卡'},
			   {id: '汇票', text: '汇票'},
			   {id: '信用卡', text: '信用卡'}
		]
	});
	
	//是否到账
	$HUI.combobox("#backFlag", {
		panelHeight: 'auto',
		blurValidValue: true,
		valueField: 'id',
		textField: 'text',
		data: [{id: '0', text: '是'},
		       {id: '1', text: '否'}
		]
	});
}

function initChequeList() {
	GV.ChequeList = $HUI.datagrid("#chequeList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		data: [],
		columns:[[{title: '登记号', field: 'Tregno', width: 100},
				  {title: '姓名', field: 'Tname', width: 100},
				  {title: '交款日期', field: 'Tcreatdate', width: 100},
				  {title: '交款时间', field: 'Tcreattime', width: 100},
				  {title: '收据号', field: 'Trcptno', width: 100},
				  {title: '支付方式', field: 'Tpaymode', width: 100},
				  {title: '金额', field: 'Tsum', width: 100, align: 'right'},
				  {title: '状态', field: 'Tstatus', width: 80},
				  {title: '帐号', field: 'Tcardno', width: 100},
				  {title: '银行', field: 'Tbank', width: 100},
				  {title: '单位', field: 'Tcompany', width: 100},
				  {title: '收款员', field: 'Tmoneyuser', width: 100},
				  {title: '是否到账', field: 'TFlagId', width: 80,
					formatter: function (value, row, index) {
						return (value === '0') ? '<font color="#21ba45">是</font>' : '<font color="#f16e57">否</font>';
					}
				  },
				  {title: '操作员', field: 'Tuser', width: 100},
				  {title: '操作日期', field: 'Tdate', width: 100},
				  {title: '操作时间', field: 'Ttime', width: 100},
				  {title: '修改人', field: 'Tupdateuser', width: 100},
				  {title: '修改日期', field: 'Tupddate', width: 100},
				  {title: '修改时间', field: 'Tupdatetime', width: 100},
				  {title: '备注', field: 'Tnote', width: 100},
				  {title: 'Trowid', field: 'Trowid', hidden: true},
				  {title: 'Tbankbrowid', field: 'Tbankbrowid', hidden: true}
			]],
		onSelect: function(index, row) {
			selectRowHandler(index, row);
		}
	});
}

function selectRowHandler(index, row) {
	setValueById("paymode", row.Tpaymode);
	setValueById("remark", row.Tnote);
	setValueById("cardNo", row.Tcardno);
	setValueById("backFlag", row.TFlagId);
}

function loadChequeList() {
	var queryParams = {
		ClassName: "web.UDHCJFBankback",
		QueryName: "moneydetail",
		stdate: getValueById("stDate"), 
		enddate: getValueById("endDate"),
		cardno: getValueById("cardNo"),
		paymode: getValueById("paymode"),
		payflag: getValueById("backFlag"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("chequeList", queryParams);
}

/**
* 到账
*/
function insertClick() {
	var row = GV.ChequeList.getSelected();
	if (!row) {
		$.messager.popover({msg: '请选择支票信息', type: 'info'});
		return;
	}
	
	var rowId = row.Trowid;
	if (!rowId) {
		$.messager.popover({msg: '请选择支票信息', type: 'info'});
		return;
	}
	var bankRowId = row.Tbankbrowid;
	if (bankRowId) {
		$.messager.popover({msg: '已经有支票到账信息不能再到账', type: 'info'});
		return;
	}
	var backFlag = getValueById("backFlag");
	if (!backFlag) {
		$.messager.popover({msg: '到账标志不能为空', type: 'info'});
		return;
	}
	if (row.Tstatus != "正常") {
		$.messager.popover({msg: '非正常押金不能到账', type: 'info'});
		return;
	}
	var remark = getValueById("remark");
	var depRowId = rowId;
	var invRowId = "";
	var str = depRowId + "^" + invRowId + "^" + backFlag + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + remark;
	$.messager.confirm("确认", "确认保存？", function(r) {
		if (r) {
			$.m({
				ClassName: "web.UDHCJFBankback",
				MethodName: "insertbankb",
				str: str
			}, function(rtn) {
				if (rtn == 0) {
					$.messager.popover({msg: '保存成功', type: 'success'});
					GV.ChequeList.reload();
				}else {
					$.messager.popover({msg: '保存失败：' + rtn, type: 'error'});
				}
			});
		}
	});
}

/**
* 修改
*/
function updateClick() {
	var row = GV.ChequeList.getSelected();
	if (!row) {
		$.messager.popover({msg: '请选择支票信息', type: 'info'});
		return;
	}
	var bankRowId = row.Tbankbrowid;
	if (!bankRowId) {
		$.messager.popover({msg: '没有支票到账信息不能修改', type: 'info'});
		return;
	}
	var backFlag = getValueById("backFlag");
	if (!backFlag) {
		$.messager.popover({msg: '到账标志不能为空', type: 'info'});
		return;
	}
	var remark = getValueById("remark");
	var str = bankRowId + "^" + backFlag + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + remark;
	$.messager.confirm("确认", "确认修改？", function(r) {
		if (r) {
			$.m({
				ClassName: "web.UDHCJFBankback",
				MethodName: "updatebankb",
				str: str
			}, function(rtn) {
				if (rtn == 0) {
					$.messager.popover({msg: '修改成功', type: 'success'});
					GV.ChequeList.reload();
				}else {
					$.messager.popover({msg: '修改失败：' + rtn, type: 'error'});
				}
			});
		}
	});
}