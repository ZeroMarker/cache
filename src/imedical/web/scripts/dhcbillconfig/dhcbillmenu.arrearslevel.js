/*
 * FileName: dhcbillmenu.arrearslevel.js
 * User: TangTao
 * Date: 2014-04-10
 * Function: 欠费控制级别
 * Description:
 */

var lastIndex = "";
var EditIndex = -1;

$(function () {
	initGrid();

	if (BDPAutDisableFlag('BtnArrAdd')) {
		$('#BtnArrAdd').hide();
	}
	if (BDPAutDisableFlag('BtnArrUpdate')) {
		$('#BtnArrUpdate').hide();
	}
	if (BDPAutDisableFlag('BtnArrDelete')) {
		$('#BtnArrDelete').hide();
	}
	if (BDPAutDisableFlag('BtnArrSave')) {
		$('#BtnArrSave').hide();
	}
	
	var tableName = "Bill_Com_ArrearsLevel";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#Hospital").combobox({
		panelHeight: 150,
		width: 300,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox("select", PUBLIC_CONSTANT.SESSION.HOSPID);
		},
		onChange: function(newValue, oldValue) {
			initLoadGrid();
		}
	});
});

function initGrid() {
	var ctrlData = [{
			value: 'N',
			text: '不允许'
		}, {
			value: 'Y',
			text: '允许'
		}
	];

	//初始化Columns
	var CateColumns = [[{
				field: 'JFALCode',
				title: '级别名称',
				width: 120,
				editor: 'text',
				sortable: true,
				resizable: true,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				field: 'JFALDesc',
				title: '级别描述',
				width: 150,
				editor: 'text',
				sortable: true,
				resizable: true
			}, {
				field: 'JFALType',
				title: '级别类型',
				width: 100,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + "?ClassName=DHCBILLConfig.DHCBILLArrears&QueryName=FindALType&ResultSetType=array",
						valueField: 'TALTypeCode',
						textField: 'TALTypeDesc',
						required: true
					}
				}
			}, {
				field: 'JFALOrderEntry',
				title: '是否允许录入医嘱',
				width: 150,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'value',
						textField: 'text',
						data: ctrlData
					}
				}
			}, {
				field: 'JFALOrderExecute',
				title: '是否允许执行医嘱',
				width: 150,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'value',
						textField: 'text',
						data: ctrlData
					}
				}
			}, {
				field: 'JFALLimitPrice',
				title: '允许录入和执行医嘱限价',
				width: 200,
				editor: 'text',
				sortable: true,
				resizable: true
			}, {
				field: 'JFALFlag',
				title: '是否允许发药',
				width: 120,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'value',
						textField: 'text',
						data: ctrlData
					}
				}
			}, {
				field: 'JFALOrdCatReverse',
				title: '是否允许医嘱分类反向',
				width: 150,
				sortable: true,
				resizable: true,
				hidden: true,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'value',
						textField: 'text',
						data: ctrlData
					}
				}
			}, {
				field: 'JFALTtpe1',
				title: 'JFALTtpe1',
				hidden: true
			}, {
				field: 'JFALOrderEntry1',
				title: 'JFALOrderEntry1',
				hidden: true
			}, {
				field: 'JFALOrderExecute1',
				title: 'JFALOrderExecute1',
				hidden: true
			}, {
				field: 'JFALFlag1',
				title: 'JFALFlag1',
				hidden: true
			}, {
				field: 'JFALOrdCatReverse1',
				title: 'JFALOrdCatReverse1',
				hidden: true
			}, {
				field: 'JFALRowID',
				title: 'JFALRowID',
				hidden: true
			}, {
				field: 'Operate',
				title: '控制级别内医嘱分类',
				width: 150,
				align: 'center',
				formatter: function(value, row, index) {
					return '<img onclick="openWinView(\'' + row.JFALRowID + '\',' + '\'' + row.JFALHospId + '\')" src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png" style="cursor:pointer">';
				}
			}, {
				field: 'JFALHospId',
				title: 'JFALHospId',
				width: 150,
				hidden: true
			}
		]];

	//初始化DataGrid
	$("#tArrearsLevel").datagrid({
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		columns: CateColumns,
		toolbar: '#tToolBar',
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
}

function initLoadGrid() {
	var queryParams = {
		ClassName: "DHCBILLConfig.DHCBILLArrears",
		QueryName: "FindArrearsLevel",
		HospId: getValueById("Hospital")
	};
	loadDataGridStore("tArrearsLevel", queryParams);
}

$('#BtnArrAdd').bind('click', function () {
	lastIndex = $('#tArrearsLevel').datagrid('getRows').length - 1;
	$('#tArrearsLevel').datagrid('selectRow', lastIndex);
	var selected = $('#tArrearsLevel').datagrid('getSelected');
	if (selected) {
		if (typeof(selected.JFALRowID) == "undefined") {
			$.messager.popover({msg: "不能同时添加多条", type: "info"});
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.popover({msg: "一次只能修改一条记录", type: "info"});
		return;
	}
	$('#tArrearsLevel').datagrid('appendRow', {
		JFALCode: '',
		JFALDesc: '',
		JFALType: '',
		JFALOrderEntry: '',
		JFALOrderExecute: '',
		JFALLimitPrice: '',
		JFALFlag: '',
		JFALOrdCatReverse: ''
	});
	lastIndex = $('#tArrearsLevel').datagrid('getRows').length - 1;
	$('#tArrearsLevel').datagrid('selectRow', lastIndex);
	$('#tArrearsLevel').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
});

$('#BtnArrUpdate').bind('click', function () {
	var selected = $('#tArrearsLevel').datagrid('getSelected');
	if (selected) {
		var thisIndex = $('#tArrearsLevel').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.popover({msg: "一次只能修改一条记录", type: "info"});
			return;
		}
		$('#tArrearsLevel').datagrid('beginEdit', thisIndex);
		$('#tArrearsLevel').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#tArrearsLevel').datagrid('getSelected');

		var thisEd = $('#tArrearsLevel').datagrid('getEditor', {
				index: EditIndex,
				field: 'JFALType'
			});
		$(thisEd.target).combobox('select', selected.JFALTtpe1);
		var thisEd = $('#tArrearsLevel').datagrid('getEditor', {
				index: EditIndex,
				field: 'JFALOrderEntry'
			});
		$(thisEd.target).combobox('select', selected.JFALOrderEntry1);
		var thisEd = $('#tArrearsLevel').datagrid('getEditor', {
				index: EditIndex,
				field: 'JFALOrderExecute'
			});
		$(thisEd.target).combobox('select', selected.JFALOrderExecute1);
		var thisEd = $('#tArrearsLevel').datagrid('getEditor', {
				index: EditIndex,
				field: 'JFALFlag'
			});
		$(thisEd.target).combobox('select', selected.JFALFlag1);
		var thisEd = $('#tArrearsLevel').datagrid('getEditor', {
				index: EditIndex,
				field: 'JFALOrdCatReverse'
			});
		$(thisEd.target).combobox('select', selected.JFALOrdCatReverse1);
	}
});

$('#BtnArrSave').bind('click', function () {
	$('#tArrearsLevel').datagrid('acceptChanges');
	var selected = $('#tArrearsLevel').datagrid('getSelected');
	if (selected) {
		// selected.JFALRowID为undefined，说明是新建项目，调用保存接口
		if (typeof(selected.JFALRowID) == "undefined") {
			var CateStr = "^" + selected.JFALCode + "^" + selected.JFALDesc + "^" + selected.JFALType;
			CateStr = CateStr + "^" + selected.JFALOrderEntry + "^" + selected.JFALOrderExecute + "^" + selected.JFALLimitPrice;
			CateStr = CateStr + "^" + selected.JFALFlag + "^" + "Y" + "^" + getValueById("Hospital");
			if ((typeof(selected.JFALCode) == "undefined") || (selected.JFALCode == "") || (typeof(selected.JFALType) == "undefined") || (selected.JFALType == "")) {
				$.messager.popover({msg: "级别名称，级别类型为空，不允许添加", type: "info"});
				EditIndex = -1;
				initLoadGrid();
				return;
			}
			if ((typeof(selected.JFALType) == "undefined") || (selected.JFALType == "")) {
				$.messager.popover({msg: "控制权限为空，不允许添加", type: "info"});
				EditIndex = -1;
				initLoadGrid();
				return;
			}
			if ((typeof(selected.JFALOrderEntry) == "undefined") || (selected.JFALOrderEntry == "") || (typeof(selected.JFALOrderExecute) == "undefined") || (selected.JFALOrderExecute == "")) {
				$.messager.popover({msg: "控制权限为空，不允许添加", type: "info"});
				EditIndex = -1;
				initLoadGrid();
				return;
			}
			//if((typeof(selected.JFALFlag) == "undefined") || (selected.JFALFlag == "") || (typeof(selected.JFALOrdCatReverse) == "undefined") || (selected.JFALOrdCatReverse == "")){
			if ((typeof(selected.JFALFlag) == "undefined") || (selected.JFALFlag == "")) {
				$.messager.popover({msg: "控制权限为空，不允许添加", type: "info"});
				EditIndex = -1;
				initLoadGrid();
				return;
			}
			$.cm({
				ClassName: "DHCBILLConfig.DHCBILLArrears",
				MethodName: "InsertArrearsLevel",
				LevelInfo: CateStr,
				Guser: PUBLIC_CONSTANT.SESSION.USERID
			}, function (rtn) {
				if (rtn == 0) {
					$.messager.alert('提示', "保存成功", 'success');
				} else {
					$.messager.alert('提示', "保存失败，错误代码：" + rtn, 'error');
				}
				EditIndex = -1;
				initLoadGrid();
			});
		} else {
			$('#tArrearsLevel').datagrid('selectRow', EditIndex);
			var selected = $('#tArrearsLevel').datagrid('getSelected');
			var CateStr = selected.JFALRowID + "^" + selected.JFALCode + "^" + selected.JFALDesc + "^" + selected.JFALType;
			CateStr = CateStr + "^" + selected.JFALOrderEntry + "^" + selected.JFALOrderExecute + "^" + selected.JFALLimitPrice;
			CateStr = CateStr + "^" + selected.JFALFlag + "^" + "Y" + "^" + getValueById("Hospital");
			if ((typeof(selected.JFALCode) == "undefined") || (selected.JFALCode == "") || (typeof(selected.JFALType) == "undefined") || (selected.JFALType == "")) {
				$.messager.popover({msg: "级别名称，级别类型为空，不允许修改", type: "info"});
				EditIndex = -1;
				initLoadGrid();
				return;
			}
			if ((typeof(selected.JFALType) == "undefined") || (selected.JFALType == "")) {
				$.messager.popover({msg: "控制权限为空，不允许修改", type: "info"});
				EditIndex = -1;
				initLoadGrid();
				return;
			}
			if ((typeof(selected.JFALOrderEntry) == "undefined") || (selected.JFALOrderEntry == "") || (typeof(selected.JFALOrderExecute) == "undefined") || (selected.JFALOrderExecute == "")) {
				$.messager.popover({msg: "控制权限为空，不允许修改", type: "info"});
				EditIndex = -1;
				initLoadGrid();
				return;
			}
			if ((typeof(selected.JFALFlag) == "undefined") || (selected.JFALFlag == "")) {
				$.messager.popover({msg: "控制权限为空，不允许修改", type: "info"});
				EditIndex = -1;
				initLoadGrid();
				return;
			}
			$.cm({
				ClassName: "DHCBILLConfig.DHCBILLArrears",
				MethodName: "UpdateArrearsLevel",
				LevelInfo: CateStr,
				Guser: PUBLIC_CONSTANT.SESSION.USERID
			}, function (rtn) {
				if (rtn == 0) {
					$.messager.alert('提示', '修改成功', 'success');
				} else {
					$.messager.alert('提示', '修改失败，错误代码：' + rtn, 'error');
				}
				EditIndex = -1;
				initLoadGrid();
			});
		}
	}
});

$("#BtnArrDelete").bind('click', function () {
	var selected = $('#tArrearsLevel').datagrid('getSelected');
	if (!selected) {
		$.messager.popover({msg: "请选择要删除的记录", type: "info"});
		return;
	}
	$.messager.confirm('确认', '您确认想要删除记录吗？', function (r) {
		if (!r) {
			return;
		}
		var selected = $("#tArrearsLevel").datagrid('getSelected');
		if (selected) {
			if (typeof(selected.JFALRowID) != "undefined") {
				var CateStr = selected.JFALRowID + "^" + selected.JFALCode + "^" + selected.JFALDesc + "^" + selected.JFALType;
				CateStr = CateStr + "^" + selected.JFALOrderEntry + "^" + selected.JFALOrderExecute + "^" + selected.JFALLimitPrice;
				CateStr = CateStr + "^" + selected.JFALFlag + "^" + selected.JFALOrdCatReverse;
				$.cm({
					ClassName: "DHCBILLConfig.DHCBILLArrears",
					MethodName: "DeleteArrearsLevel",
					LevelInfo: CateStr,
					Guser: PUBLIC_CONSTANT.SESSION.USERID
				}, function (rtn) {
					if (rtn == 0) {
						$.messager.alert('提示', '删除成功', 'success');
					} else {
						$.messager.alert('提示', '删除失败，错误代码：' + rtn, 'error');
					}
					initLoadGrid("");
				});
			}
		}
	});
});

$('#BtnArrFind').bind('click', function () {
	EditIndex = -1;
	initLoadGrid("");
});

function openWinView(JFALRowID, JFALHospID) {
	if (!(+JFALRowID > 0) || !(+JFALHospID > 0)) {
		return;
	}
	websys_showModal({
		url: 'dhcbillmenu.arrearsordcat.csp?&JFALRowID=' + JFALRowID + '&JFALHospID=' + JFALHospID,
		title: '控制级别内医嘱分类',
		iconCls: 'icon-w-list',
		width: 650,
		height: 500
	});
}