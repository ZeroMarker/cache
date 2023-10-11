/*
 * FileName: dhcbillmenu.arrearsmoney.js
 * User: TangTao
 * Date: 2014-04-10
 * Description: 非绿色通道欠费额度
 */

var thisJFAMType = "";
var thisJFAMALDr = "";
var thisJFAMOperator1 = "";
var thisJFAMOperator2 = "";
var winlastIndex = "";
var winEditIndex = -1;

$(function () {
	initArrearsMoneyGrid();
	if (BDPAutDisableFlag('winAdd')) {
		$('#winAdd').hide();
	}
	if (BDPAutDisableFlag('winUpdate')) {
		$('#winUpdate').hide();
	}
	if (BDPAutDisableFlag('winDelete')) {
		$('#winDelete').hide();
	}
	if (BDPAutDisableFlag('winSave')) {
		$('#winSave').hide();
	}
});

function initArrearsMoneyGrid() {
	// 初始化Columns
	var winCateColumns = [[{
				field: 'winJFAMTypeDesc',
				title: '额度类型',
				width: 100,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL,
						valueField: 'winMoneyTypeCode',
						textField: 'winMoneyTypeDesc',
						required: true,
						onBeforeLoad: function (param) {
							param.ClassName = "DHCBILLConfig.DHCBILLArrears";
							param.QueryName = "FindMoneyType";
							param.ResultSetType = "array";
						},
						onSelect: function (rec) {
							if (rec) {
								thisJFAMType = rec.winMoneyTypeCode;
							}
						}
					}
				}
			}, {
				field: 'winJFAMALDesc',
				title: '控制级别',
				width: 100,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL,
						valueField: 'JFALRowID',
						textField: 'JFALCode',
						required: true,
						onBeforeLoad: function (param) {
							param.ClassName = "DHCBILLConfig.DHCBILLArrears";
							param.QueryName = "FindArrearsLevel";
							param.ResultSetType = "array";
							param.HospId = winJFAHospID;
						},
						onSelect: function (rec) {
							if (rec) {
								thisJFAMALDr = rec.JFALRowID;
							}
						}
					}
				}
			}, {
				field: 'winJFAMOperator1',
				title: '操作符1',
				width: 100,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						panelHeight: 100,
						editable: false,
						valueField: 'value',
						textField: 'value',
						required: true,
						data: [{value: '>='},
			   				   {value: '>'}
			   				  ],
						onSelect: function (rec) {
							if (rec) {
								thisJFAMOperator1 = rec.value;
							}
						}
					}
				}
			}, {
				field: 'winJFAMMoneyFrom',
				title: '金额1',
				width: 100,
				align: 'right',
				sortable: true,
				resizable: true,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				field: 'winJFAMOperator2',
				title: '操作符2',
				width: 100,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						panelHeight: 100,
						editable: false,
						valueField: 'value',
						textField: 'value',
						required: true,
						data: [{value: '<='},
			   				   {value: '<'}
			   				   ],
						onSelect: function (rec) {
							if (rec) {
								thisJFAMOperator2 = rec.value;
							}
						}
					}
				}
			}, {
				field: 'winJFAMMoneyTo',
				title: '金额2',
				width: 100,
				align: 'right',
				sortable: true,
				resizable: true,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				field: 'winJFAMFeeRate',
				title: '费用比例',
				width: 100,
				editor: 'text',
				sortable: true,
				resizable: true
			}, {
				field: 'winJFARowID',
				title: 'winJFARowID',
				hidden: true
			}, {
				field: 'winJFAMALDr',
				title: 'winJFAMALDr',
				hidden: true
			}, {
				field: 'winJFAMType',
				title: 'winJFAMType',
				hidden: true
			}, {
				field: 'winJFAMRowID',
				title: 'winJFAMRowID',
				hidden: true
			}, {
				field: 'winJFAMOperatorDr1',
				title: 'winJFAMOperatorDr1',
				hidden: true
			}, {
				field: 'winJFAMOperatorDr2',
				title: 'winJFAMOperatorDr2',
				hidden: true
			}
		]];

	// 初始化DataGrid
	$('#tArrearsMoney').datagrid({
		fit: true,
		bodyCls: 'panel-body-gray',
		striped: true,
		singleSelect: true,
		fitColumns: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		columns: winCateColumns,
		toolbar: '#wintToolBar',
		url: $URL,
		queryParams: {
			ClassName: "DHCBILLConfig.DHCBILLArrears",
			QueryName: "FindArrearsMoney",
			JFARowID: winJFARowID
		},
		onLoadSuccess: function (data) {
			winEditIndex = -1;
		}
	});
}

function initWinLoadGrid() {
	var queryParams = {
		ClassName: "DHCBILLConfig.DHCBILLArrears",
		QueryName: "FindArrearsMoney",
		JFARowID: winJFARowID
	};
	loadDataGridStore("tArrearsMoney", queryParams);
}

$('#winAdd').bind('click', function () {
	//$('#tArrearsMoney').datagrid('endEdit', winlastIndex);
	winlastIndex = $('#tArrearsMoney').datagrid('getRows').length - 1;
	$('#tArrearsMoney').datagrid('selectRow', winlastIndex);
	var selected = $('#tArrearsMoney').datagrid('getSelected');
	if (selected) {
		if (typeof(selected.winJFAMRowID) == "undefined") {
			$.messager.alert('提示', "不能同时添加多条", 'info');
			return;
		}
	}
	if ((winEditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#tArrearsMoney').datagrid('appendRow', {
		winJFAMTypeDesc: '',
		winJFAMALDesc: '',
		winJFAMOperator1: '',
		winJFAMMoneyFrom: '',
		winJFAMOperator2: '',
		winJFAMMoneyTo: '',
		winJFAMFeeRate: ''
	});
	winlastIndex = $('#tArrearsMoney').datagrid('getRows').length - 1;
	$('#tArrearsMoney').datagrid('selectRow', winlastIndex);
	$('#tArrearsMoney').datagrid('beginEdit', winlastIndex);
	winEditIndex = winlastIndex;
});

$('#winUpdate').bind('click', function () {
	var selected = $('#tArrearsMoney').datagrid('getSelected');
	if (selected) {
		var thisIndex = $('#tArrearsMoney').datagrid('getRowIndex', selected);
		if ((winEditIndex != -1) && (winEditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#tArrearsMoney').datagrid('beginEdit', thisIndex);
		winEditIndex = thisIndex;
		var thisEd = $('#tArrearsMoney').datagrid('getEditor', {
				index: winEditIndex,
				field: 'winJFAMTypeDesc'
			});
		$(thisEd.target).combobox('select', selected.winJFAMType);
		var thisEd = $('#tArrearsMoney').datagrid('getEditor', {
				index: winEditIndex,
				field: 'winJFAMALDesc'
			});
		$(thisEd.target).combobox('select', selected.winJFAMALDr);
		var thisEd = $('#tArrearsMoney').datagrid('getEditor', {
				index: winEditIndex,
				field: 'winJFAMOperator1'
			});
		$(thisEd.target).combobox('select', selected.winJFAMOperatorDr1);
		var thisEd = $('#tArrearsMoney').datagrid('getEditor', {
				index: winEditIndex,
				field: 'winJFAMOperator2'
			});
		$(thisEd.target).combobox('select', selected.winJFAMOperatorDr2);
		thisJFAMType = selected.winJFAMType;
		thisJFAMALDr = selected.winJFAMALDr;
		thisJFAMOperator1 = selected.winJFAMOperatorDr1;
		thisJFAMOperator2 = selected.winJFAMOperatorDr2;
	}
});

$('#winSave').bind('click', function () {
	if (!checkData()) {
		return;
	}
	$('#tArrearsMoney').datagrid('selectRow', winEditIndex);
	var selected = $('#tArrearsMoney').datagrid('getSelected');
	if (selected) {
		// selected.winJFAMRowID为undefined，说明是新建项目，调用保存接口
		if ((selected.winJFAMRowID == "") || (typeof(selected.winJFAMRowID) == "undefined")) {
			$('#tArrearsMoney').datagrid('acceptChanges');
			if ((thisJFAMType == "") || (thisJFAMALDr == "") || (thisJFAMOperator1 == "") || (thisJFAMOperator2 == "")) {
				$.messager.alert('提示', "必填数据不能为空，不允许保存", 'info');
				winEditIndex = -1;
				thisJFAMType = "";
				thisJFAMALDr = "";
				thisJFAMOperator1 = "";
				thisJFAMOperator2 = "";
				initWinLoadGrid();
				return;
			};
			if (isNaN(selected.winJFAMMoneyFrom) || isNaN(selected.winJFAMMoneyTo)) {
				$.messager.alert('提示', "金额不是数字，不允许保存", 'info');
				winEditIndex = -1;
				thisJFAMType = "";
				thisJFAMALDr = "";
				thisJFAMOperator1 = "";
				thisJFAMOperator2 = "";
				initWinLoadGrid();
				return;
			}
			var ArrearsStr = winJFARowID + "^" + "" + "^" + selected.winJFAMTypeDesc + "^" + selected.winJFAMALDesc + "^" + selected.winJFAMOperator1 + "^" + selected.winJFAMOperator2;
			var ArrearsStr = ArrearsStr + "^" + selected.winJFAMMoneyFrom + "^" + selected.winJFAMMoneyTo + "^" + selected.winJFAMFeeRate;
			$.m({
				ClassName: "DHCBILLConfig.DHCBILLArrears",
				MethodName: "InsertArrearsMoney",
				ArrMoneyInfo: ArrearsStr,
				Guser: PUBLIC_CONSTANT.SESSION.USERID
			}, function (rtn) {
				if (rtn == 0) {
					$.messager.alert('提示', "保存成功!", 'success');
				} else if (rtn == -100) {
					$.messager.alert('提示', "控制等级重复", 'info');
				} else {
					$.messager.alert('提示', "保存失败，错误代码：" + rtn, 'error');
				}
				winEditIndex = -1;
				thisJFAMType = "";
				thisJFAMALDr = "";
				thisJFAMOperator1 = "";
				thisJFAMOperator2 = "";
				initWinLoadGrid();
			});
		} else {
			$('#tArrearsMoney').datagrid('selectRow', winEditIndex);
			var selected = $('#tArrearsMoney').datagrid('getSelected');
			if ((thisJFAMType == "") || (thisJFAMALDr == "") || (thisJFAMOperator1 == "") || (thisJFAMOperator2 == "")) {
				$.messager.alert('提示', "必填数据不能为空，不允许保存", 'info');
				winEditIndex = -1;
				thisJFAMType = "";
				thisJFAMALDr = "";
				thisJFAMOperator1 = "";
				thisJFAMOperator2 = "";
				initWinLoadGrid();
				return;
			};
			var thisEd = $('#tArrearsMoney').datagrid('getEditor', {
					index: winEditIndex,
					field: 'winJFAMTypeDesc'
				});
			var thisJFAMType = $(thisEd.target).combobox('getValue');
			var thisEd = $('#tArrearsMoney').datagrid('getEditor', {
					index: winEditIndex,
					field: 'winJFAMALDesc'
				});
			var thisJFAMALDr = $(thisEd.target).combobox('getValue');
			var thisEd = $('#tArrearsMoney').datagrid('getEditor', {
					index: winEditIndex,
					field: 'winJFAMOperator1'
				});
			var thisJFAMOperator1 = $(thisEd.target).combobox('getValue');
			var thisEd = $('#tArrearsMoney').datagrid('getEditor', {
					index: winEditIndex,
					field: 'winJFAMOperator2'
				});
			var thisJFAMOperator2 = $(thisEd.target).combobox('getValue');

			$('#tArrearsMoney').datagrid('acceptChanges');
			if (isNaN(selected.winJFAMMoneyFrom) || isNaN(selected.winJFAMMoneyTo)) {
				$.messager.alert('提示', "金额不是数字，不允许保存", 'info');
				winEditIndex = -1;
				thisJFAMType = "";
				thisJFAMALDr = "";
				thisJFAMOperator1 = "";
				thisJFAMOperator2 = "";
				initWinLoadGrid();
				return;
			}
			var ArrearsStr = winJFARowID + "^" + selected.winJFAMRowID + "^" + thisJFAMType + "^" + thisJFAMALDr + "^" + thisJFAMOperator1 + "^" + thisJFAMOperator2;
			var ArrearsStr = ArrearsStr + "^" + selected.winJFAMMoneyFrom + "^" + selected.winJFAMMoneyTo + "^" + selected.winJFAMFeeRate;
			$.m({
				ClassName: "DHCBILLConfig.DHCBILLArrears",
				MethodName: "UpdateArrearsMoney",
				ArrMoneyInfo: ArrearsStr,
				Guser: PUBLIC_CONSTANT.SESSION.USERID
			}, function (rtn) {
				if (rtn == 0) {
					$.messager.alert('提示', "修改成功", 'success');
				} else if (rtn == -100) {
					$.messager.alert('提示', "控制等级重复", 'info');
				} else {
					$.messager.alert('提示', "修改失败，错误代码：" + rtn, 'error');
				}
				winEditIndex = -1;
				thisJFAMType = "";
				thisJFAMALDr = "";
				thisJFAMOperator1 = "";
				thisJFAMOperator2 = "";
				initWinLoadGrid();
			});
		}
	}
});

$('#winDelete').bind('click', function () {
	var selected = $('#tArrearsMoney').datagrid('getSelected');
	if (!selected) {
		$.messager.alert('提示', "请选择要删除的记录", 'info');
		return;
	}
	$.messager.confirm('确认', '您确认想要删除记录吗？', function (r) {
		if (r) {
			var selected = $('#tArrearsMoney').datagrid('getSelected');
			if (selected) {
				if (typeof(selected.winJFAMRowID) != "undefined") {
					if (thisJFAMType == "") {
						thisJFAMType = selected.winJFAMType;
					}
					if (thisJFAMALDr == "") {
						thisJFAMALDr = selected.winJFAMALDr;
					}
					if (thisJFAMOperator1 == "") {
						thisJFAMOperator1 = selected.winJFAMOperatorDr1;
					}
					if (thisJFAMOperator2 == "") {
						thisJFAMOperator2 = selected.winJFAMOperatorDr2;
					}

					var ArrearsStr = winJFARowID + "^" + selected.winJFAMRowID + "^" + thisJFAMType + "^" + thisJFAMALDr + "^" + thisJFAMOperator1 + "^" + thisJFAMOperator2;
					var ArrearsStr = ArrearsStr + "^" + selected.winJFAMMoneyFrom + "^" + selected.winJFAMMoneyTo + "^" + selected.winJFAMFeeRate;
					$.m({
						ClassName: "DHCBILLConfig.DHCBILLArrears",
						MethodName: "DeleteArrearsMoney",
						ArrMoneyInfo: ArrearsStr,
						Guser: PUBLIC_CONSTANT.SESSION.USERID,
						HospID: PUBLIC_CONSTANT.SESSION.HOSPID
					}, function (rtn) {
						if (rtn == 0) {
							$.messager.alert('提示', "删除成功", 'success');
						} else {
							$.messager.alert('提示', "删除失败，错误代码：" + rtn, 'error');
						}
						initWinLoadGrid();
					});
				}
			}
		}
	});
});

$('#winFind').bind('click', function () {
	winEditIndex = -1;
	initWinLoadGrid();
	thisJFAMType = "",
	thisJFAMALDr = "",
	thisJFAMOperator1 = "",
	thisJFAMOperator2 = "";
});

/**
* 验证数据合法性
*/
function checkData() {
	var bool = true;
	$(".validatebox-text").each(function(index, item) {
		if (!$(this).validatebox("isValid")) {
			$(this).focus();
			bool = false;
			return false;
		}
	});
	return bool;
}