/*
 * FileName: dhcbillmenu.printarcitmcat.js
 * User: TangTao
 * Date: 2014-04-10
 * Function: 打印医嘱项子类设置
 * Description:
 */

var lastIndex = "";
var EditIndex = -1;
var thisArcCatDr = "";

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
	
	var tableName = "Bill_IP_PrtArcimCat";
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
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			initLoadGrid("");
		}
	});
});

function initGrid() {
	// 初始化Columns
	var ActiveType = [{
			id: 'Y',
			name: 'Yes'
		}, {
			id: 'N',
			name: 'No'
		}
	];

	var CateColumns = [[{
				field: 'TCatDesc',
				title: '医嘱子类',
				width: 300,
				editor: 'text',
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLOthConfig&QueryName=FindArcCat&ResultSetType=array',
						valueField: 'TQRowid',
						textField: 'TQCatDesc',
						required: true,
						multiple: true,
						onBeforeLoad: function (param) {
							$.extend(param, {HospId: getValueById("Hospital")});
							return true;
						},
						onSelect: function (rec) {
							if (rec) {
								thisArcCatDr = rec.TQRowid
							}
						}
					}
				}
			}, {
				field: 'TFlag',
				title: '打印医嘱项',
				width: 100,
				editor: 'text',
				sortable: true,
				resizable: true,
				hidden: true,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'id',
						textField: 'name',
						data: ActiveType
					}
				}
			}, {
				field: 'TCatRowid',
				title: 'TCatRowid',
				hidden: true
			}, {
				field: 'TLinkRowid',
				title: 'TLinkRowid',
				hidden: true
			}
		]];

	// 初始化DataGrid
	$('#tPrintItmCat').datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		data: [],
		columns: CateColumns,
		toolbar: '#tToolBar',
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
}

function initLoadGrid() {
	var queryParams = {
		ClassName: "DHCBILLConfig.DHCBILLOthConfig",
		QueryName: "FindPrintItmCat",
		HospId: getValueById("Hospital")
	};
	loadDataGridStore("tPrintItmCat", queryParams);
}

$('#BtnAdd').bind('click', function () {
	//$('#tPrintItmCat').datagrid('endEdit', lastIndex);
	lastIndex = $('#tPrintItmCat').datagrid('getRows').length - 1;
	$('#tPrintItmCat').datagrid('selectRow', lastIndex);
	var selected = $('#tPrintItmCat').datagrid('getSelected');
	if (selected) {
		if (typeof(selected.TLinkRowid) == "undefined") {
			$.messager.alert('提示', "不能同时添加多条", 'info');
			return;
		}
	}
	$('#tPrintItmCat').datagrid('appendRow', {
		TCatDesc: ''
	});
	lastIndex = $('#tPrintItmCat').datagrid('getRows').length - 1;
	$('#tPrintItmCat').datagrid('selectRow', lastIndex);
	$('#tPrintItmCat').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
});

$('#BtnSave').bind('click', function () {
	//$('#tPrintItmCat').datagrid('acceptChanges');
	$('#tPrintItmCat').datagrid('selectRow', EditIndex);
	var selected = $('#tPrintItmCat').datagrid('getSelected');
	if (selected) {
		var thisEd = $('#tPrintItmCat').datagrid('getEditor', {
				index: EditIndex,
				field: 'TCatDesc'
			});
		var CateStr = $(thisEd.target).combobox('getValues');
		CateStr = "" + CateStr + "";
		if ((selected.TLinkRowid == "") || (typeof(selected.TLinkRowid) == "undefined")) {
			if (CateStr == "") {
				$.messager.alert('提示', "数据为空，不允许添加", 'info');
				lastIndex = "",
				EditIndex = -1;
				initLoadGrid();
				return;
			}
			var RefStr = "^" + CateStr + "^" + "Y";
			$.cm({
				ClassName: "DHCBILLConfig.DHCBILLOthConfig",
				MethodName: "InsertPrintArcItmCat",
				InsertInfo: RefStr,
				Guser: PUBLIC_CONSTANT.SESSION.USERID,
				HospID: getValueById("Hospital")
			}, function(rtn) {
				var myAry = rtn.split('^');
				switch(myAry[0]) {
				case '0':
					$.messager.alert('提示', "保存成功", 'success');
					break;
				case '-1003':
					$.messager.alert('提示', "保存失败：" + myAry[1], 'error');
					break;
				default:
					$.messager.alert('提示', "保存失败，错误代码：" + myAry[0], 'error');
				}
				lastIndex = "",
				EditIndex = -1;
				initLoadGrid();
			});
		}
	}
});

$('#BtnDelete').bind('click', function () {
	var selected = $('#tPrintItmCat').datagrid('getSelected');
	if (selected) {
		if (typeof(selected.TLinkRowid) != "undefined") {
			$.messager.confirm('确认', '您确认想要删除记录吗？', function (r) {
				if (r) {
					var selected = $('#tPrintItmCat').datagrid('getSelected');
					if (selected) {
						if (typeof(selected.TLinkRowid) != "undefined") {
							var RefStr = selected.TLinkRowid;
							$.cm({
								ClassName: "DHCBILLConfig.DHCBILLOthConfig",
								MethodName: "DeletePrintArcItmCat",
								InsertInfo: RefStr,
								Guser: PUBLIC_CONSTANT.SESSION.USERID
							}, function (rtn) {
								if (rtn == '0') {
									$.messager.alert('提示', "删除成功", 'success');
								} else {
									$.messager.alert('提示', "删除失败，错误代码：" + rtn, 'error');
								}
								initLoadGrid();
							});
						}
					}
				}
			});
		}
	} else {
		$.messager.alert('提示', '请选择一条记录', 'info');
	}
});

$('#BtnFind').bind('click', function () {
	$('#tPrintItmCat').datagrid('rejectChanges');
	EditIndex = -1;
	
	initLoadGrid();
});
