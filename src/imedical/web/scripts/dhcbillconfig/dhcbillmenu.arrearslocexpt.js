/*
 * FileName: dhcbillmenu.arrearslocexpt.js
 * User: TangTao
 * Date: 2014-04-10
 * Function: 欠费管理不受控制登陆科室
 * Description:
 */

var lastIndex = "";
var EditIndex = -1;
var thisLocRowid = "";

$(function () {
	initGrid();
	if (BDPAutDisableFlag('BtnAdd')) {
		$('#BtnAdd').hide();
	}
	if (BDPAutDisableFlag('BtnSave')) {
		$('#BtnSave').hide();
	}
	if (BDPAutDisableFlag('BtnUpdate')) {
		$('#BtnUpdate').hide();
	}
	if (BDPAutDisableFlag('BtnDelete')) {
		$('#BtnDelete').hide();
	}
	
	var tableName = "Bill_Com_ArrearsLocExcept";
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
		selectOnNavigation: false,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			initLoadGrid();
		}
	});
});

function initGrid() {
	//初始化Columns
	var CateColumns = [[{
				field: 'JFALELocDesc',
				title: '科室',
				width: 250,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + "?ClassName=DHCBILLConfig.DHCBILLArrears&QueryName=FindLoc&ResultSetType=array",
						valueField: 'LocRowid',
						textField: 'LocDesc',
						mode: 'remote',
						required: true,
						onBeforeLoad: function (param) {
							$.extend(param, {
										desc: param.q,
										hospId: getValueById('Hospital')
									});
							return true;
						},
						onSelect: function (rec) {
							if (rec) {
								thisLocRowid = rec.LocRowid;  //获取选中的就诊类型ID
							}
						}
					}
				}
			}, {
				field: 'JFALEDateFrom',
				title: '开始日期',
				width: 200,
				editor: 'datebox',
				sortable: true,
				resizable: true
			}, {
				field: 'JFALEDateTo',
				title: '结束日期',
				width: 200,
				editor: 'datebox',
				sortable: true,
				resizable: true
			}, {
				field: 'JFALERowID',
				title: 'JFALERowID',
				hidden: true
			}, {
				field: 'JFALELocDR',
				title: 'JFALELocDR',
				hidden: true
			}
		]];

	// 初始化DataGrid
	$('#tArrearsLocExpt').datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: false,
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
		QueryName: "FindArrearsLocExpt",
		HospId: getValueById("Hospital")
	};
	loadDataGridStore("tArrearsLocExpt", queryParams);
}

$('#BtnAdd').bind('click', function () {
	lastIndex = $('#tArrearsLocExpt').datagrid('getRows').length - 1;
	$('#tArrearsLocExpt').datagrid('selectRow', lastIndex);
	var selected = $('#tArrearsLocExpt').datagrid('getSelected');
	if (selected) {
		if (typeof(selected.JFALERowID) == "undefined") {
			$.messager.alert('提示', '不能同时添加多条', 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', '一次只能修改一条记录!', 'info');
		return;
	}
	$('#tArrearsLocExpt').datagrid('appendRow', {
		JFALELocDesc: '',
		JFALEDateFrom: '',
		JFALEDateTo: ''
	});
	lastIndex = $('#tArrearsLocExpt').datagrid('getRows').length - 1;
	$('#tArrearsLocExpt').datagrid('selectRow', lastIndex);
	$('#tArrearsLocExpt').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
});

$('#BtnUpdate').bind('click', function () {
	var selected = $('#tArrearsLocExpt').datagrid('getSelected');
	if (selected) {
		var thisIndex = $('#tArrearsLocExpt').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		thisLocRowid = selected.JFALELocDR;
		$('#tArrearsLocExpt').datagrid('beginEdit', thisIndex);
		$('#tArrearsLocExpt').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#tArrearsLocExpt').datagrid('getSelected');

		var thisEd = $('#tArrearsLocExpt').datagrid('getEditor', {
				index: EditIndex,
				field: 'JFALELocDesc'
			});
		$(thisEd.target).combobox('select', selected.JFALELocDR);
	}
});

$('#BtnSave').bind('click', function () {
	$('#tArrearsLocExpt').datagrid('acceptChanges');
	$('#tArrearsLocExpt').datagrid('selectRow', EditIndex);
	var selected = $('#tArrearsLocExpt').datagrid('getSelected');
	if (selected) {
		// selected.JFALERowID为undefined，说明是新建项目，调用保存接口
		if (typeof(selected.JFALERowID) == "undefined") {
			var CateStr = "^" + thisLocRowid + "^" + selected.JFALEDateFrom + "^" + selected.JFALEDateTo;
			if ((typeof(thisLocRowid) == "undefined") || (thisLocRowid == "") || (typeof(selected.JFALEDateFrom) == "undefined") || (selected.JFALEDateFrom == "")) {
				$.messager.alert('提示', "科室或开始日期为空，不允许添加", 'info');
				thisLocRowid = "";
				EditIndex = -1;
				initLoadGrid();
				return;
			}
			$.cm({
				ClassName: "DHCBILLConfig.DHCBILLArrears",
				MethodName: "InsertArrearsLocExpt",
				LocExptInfo: CateStr,
				Guser: PUBLIC_CONSTANT.SESSION.USERID,
				HospID: getValueById("Hospital")
			}, function (rtn) {
				if (rtn == "0") {
					$.messager.alert('提示', "保存成功", 'success');
				} else {
					$.messager.alert('提示', "保存失败，错误代码：" + rtn, 'error');
				}
				thisLocRowid = "";
				EditIndex = -1;
				initLoadGrid();
			});
		} else {
			$('#tArrearsLocExpt').datagrid('selectRow', EditIndex);
			var selected = $('#tArrearsLocExpt').datagrid('getSelected');
			var CateStr = selected.JFALERowID + "^" + thisLocRowid + "^" + selected.JFALEDateFrom + "^" + selected.JFALEDateTo;
			if ((typeof(thisLocRowid) == "undefined") || (thisLocRowid == "") || (typeof(selected.JFALEDateFrom) == "undefined") || (selected.JFALEDateFrom == "")) {
				$.messager.alert('提示', "级别名称，级别类型为空，不允许修改", 'info');
				thisLocRowid = "";
				EditIndex = -1;
				initLoadGrid();
				return;
			}
			$.cm({
				ClassName: "DHCBILLConfig.DHCBILLArrears",
				MethodName: "UpdateArrearsLocExpt",
				LocExptInfo: CateStr,
				Guser: PUBLIC_CONSTANT.SESSION.USERID
			}, function (rtn) {
				if (rtn == "0") {
					$.messager.alert('提示', "修改成功", 'success');
				} else {
					$.messager.alert('提示', "修改失败，错误代码：" + rtn, 'error');
				}
				thisLocRowid = "";
				EditIndex = -1;
				initLoadGrid();
			});
		}
	}
});

$('#BtnDelete').bind('click', function () {
	var selected = $('#tArrearsLocExpt').datagrid('getSelected');
	if (!selected) {
		$.messager.alert('提示', "请选择要删除的记录", 'info');
		return;
	}
	$.messager.confirm('确认', '您确认想要删除记录吗？', function (r) {
		if (r) {
			var selected = $('#tArrearsLocExpt').datagrid('getSelected');
			if (selected) {
				if (typeof(selected.JFALERowID) != "undefined") {
					var CateStr = selected.JFALERowID + "^" + selected.JFALCode + "^" + selected.JFALDesc + "^" + selected.JFALType;
					CateStr = CateStr + "^" + selected.JFALOrderEntry + "^" + selected.JFALOrderExecute + "^" + selected.JFALLimitPrice;
					CateStr = CateStr + "^" + selected.JFALFlag + "^" + selected.JFALOrdCatReverse;
					$.cm({
						ClassName: "DHCBILLConfig.DHCBILLArrears",
						MethodName: "DeleteArrearsLocExpt",
						LocExptInfo: CateStr,
						Guser: PUBLIC_CONSTANT.SESSION.USERID
					}, function (rtn) {
						if (rtn == "0") {
							$.messager.alert('提示', "删除成功", 'success');
						} else {
							$.messager.alert('提示', "删除失败,错误代码:" + rtn, 'error');
						}
						initLoadGrid("");
					});
				}
			}
		}
	});
});

$('#BtnFind').bind('click', function () {
	EditIndex = -1;
	initLoadGrid("");
});
function selectHospCombHandle(){
	initLoadGrid("");
}
