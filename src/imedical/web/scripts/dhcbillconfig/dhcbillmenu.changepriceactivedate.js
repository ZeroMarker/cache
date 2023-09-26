/*
 * FileName: dhcbillmenu.changepriceactivedate.js
 * User: TangTao
 * Date: 2014-04-10
 * Function: 调价生效日期设置
 * Description:
 */

var lastIndex = "";
var EditIndex = -1;
var thisHospDr = "";

$(function () {
	initGrid();
	if (BDPAutDisableFlag('BtnAdd')) {
		$('#BtnAdd').hide();
	}
	if (BDPAutDisableFlag('BtnDelete')) {
		$('#BtnDelete').hide();
	}
	if (BDPAutDisableFlag('BtnSave')) {
		$('#BtnSave').hide();
	}
	
	$("#hospital").combobox({
		panelHeight: 150,
		width: 300,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCloud&ResultSetType=array&desc=',
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		selectOnNavigation: false,
		onLoadSuccess: function(data) {
			$(this).combobox('select', session['LOGON.HOSPID']);
		},
		onChange: function(newValue, oldValue) {
			initLoadGrid();
		}
	});
});

function initGrid() {
	// 初始化Columns
	var CateColumns = [[{
				field: 'TConHospDesc',
				title: '医院名称(设置医院调价当天生效)',
				width: 300,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCloud&ResultSetType=array&desc=',
						valueField: 'HOSPRowId',
						textField: 'HOSPDesc',
						onSelect: function (rec) {
							thisHospDr = rec.HOSPRowId;
						}
					}
				}
			}, {
				field: 'TConHospRowID',
				title: 'TConHospRowID',
				hidden: true
			}
		]];

	// 初始化DataGrid
	$('#tChangeActive').datagrid({
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
		data: [],
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
}

function initLoadGrid() {
	var queryParams = {
		ClassName: "DHCBILLConfig.DHCBILLOthConfig",
		QueryName: "FindHospConfig",
		hospId: getValueById("hospital")
	};
	loadDataGridStore("tChangeActive", queryParams);
}

$('#BtnAdd').bind('click', function () {
	lastIndex = $('#tChangeActive').datagrid('getRows').length - 1;
	$('#tChangeActive').datagrid('selectRow', lastIndex);
	var selected = $('#tChangeActive').datagrid('getSelected');
	if (selected) {
		if (typeof(selected.TConHospRowID) == "undefined") {
			$.messager.alert('提示', "不能同时添加多条", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#tChangeActive').datagrid('appendRow', {
		TConHospDesc: ''
	});
	lastIndex = $('#tChangeActive').datagrid('getRows').length - 1;
	$('#tChangeActive').datagrid('selectRow', lastIndex);
	$('#tChangeActive').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
});

$('#BtnSave').bind('click', function () {
	var selected = $('#tChangeActive').datagrid('getSelected');
	if (selected) {
		if ((thisHospDr == "") || (typeof(thisHospDr) == "undefined")) {
			$.messager.alert('提示', "医院为空,不允许添加", 'info');
			EditIndex = -1;
			thisHospDr = "";
			initLoadGrid();
			return;
		}
		var HospStr = thisHospDr;
		$.cm({
			ClassName: "DHCBILLConfig.DHCBILLOthConfig",
			MethodName: "InsertHospConfig",
			HospStr: HospStr,
			Guser: PUBLIC_CONSTANT.SESSION.USERID
		}, function(rtn) {
			if (rtn == "0") {
				$.messager.alert('提示', "保存成功", 'success');
			} else {
				$.messager.alert('提示', "保存失败，错误代码：" + rtn, 'error');
			}
			EditIndex = -1;
			thisHospDr = "";
			initLoadGrid();
		});
	}
});

$('#BtnDelete').bind('click', function () {
	var selected = $('#tChangeActive').datagrid('getSelected');
	if (!selected) {
		$.messager.alert('提示', "请选择要删除的记录", 'info');
		return;
	}
	$.messager.confirm('确认', '您确认想要删除记录吗？', function (r) {
		if (r) {
			if ((selected.TConHospRowID != "") && (typeof(selected.TConHospRowID) != "undefined")) {
				var HospStr = selected.TConHospRowID;
				$.cm({
					ClassName: "DHCBILLConfig.DHCBILLOthConfig",
					MethodName: "DeleteHospConfig",
					HospStr: HospStr,
					Guser: PUBLIC_CONSTANT.SESSION.USERID
				}, function(rtn) {
					if (rtn == "0") {
						$.messager.alert('提示', "删除成功", 'success');
					} else {
						$.messager.alert('提示', "删除失败，错误代码：" + rtn, 'error');
					}
					initLoadGrid();
				});
			}
		}
	});
});

$('#BtnFind').bind('click', function () {
	EditIndex = -1;
	thisHospDr = "";
	initLoadGrid();
});
