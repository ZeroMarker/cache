/*
 * FileName:	dhcbillmenu.refdepositreason.js
 * User:		TangTao
 * Date:		2014-04-10
 * Function:	退押金原因设置
 * Description:
 */

$(function () {
	initGrid();
	if (BDPAutDisableFlag("BtnAdd")) {
		$("#BtnAdd").hide();
	}
	if (BDPAutDisableFlag("BtnUpdate")) {
		$("#BtnUpdate").hide();
	}
	if (BDPAutDisableFlag("BtnSave")) {
		$("#BtnSave").hide();
	}
	var rtn=GetUserAuthorize();
	if(rtn!='Y'){
		$("#BtnAdd").hide();
		$("#BtnUpdate").hide();
		$("#BtnSave").hide();
	}
});

var lastIndex = "";
var EditIndex = -1;

function initGrid() {
	// 初始化Columns
	var ActiveType = [{
			id: 'Y',
			name: '正常'
		}, {
			id: 'N',
			name: '停止'
		}
	];

	var CateColumns = [[{
				field: 'TRefCode',
				title: '代码',
				width: 120,
				sortable: true,
				resizable: true,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				field: 'TRefDesc',
				title: '退押金原因',
				width: 200,
				sortable: true,
				resizable: true,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				field: 'TRefStdate',
				title: '开始日期',
				width: 200,
				editor: 'datebox',
				sortable: true,
				resizable: true
			}, {
				field: 'TRefEnddate',
				title: '结束日期',
				width: 200,
				editor: 'datebox',
				sortable: true,
				resizable: true
			}, {
				field: 'TRefflagdesc',
				title: '有效标志',
				hidden: true,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'id',
						textField: 'name',
						//required: true,
						data: ActiveType
					}
				}
			}, {
				field: 'TRowid',
				title: 'TRowid',
				hidden: true
			}, {
				field: 'TRefflag',
				title: 'TRefflag',
				hidden: true
			}
		]];

	// 初始化DataGrid
	$('#tRefDepRea').datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: CateColumns,
		toolbar: '#tToolBar',
		url: $URL,
		queryParams: {
			ClassName: "DHCBILLConfig.DHCBILLOthConfig",
			QueryName: "FindDepRefReason"
		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
}

function initLoadGrid() {
	var queryParams = {
		ClassName: "DHCBILLConfig.DHCBILLOthConfig",
		QueryName: "FindDepRefReason"
	};
	loadDataGridStore("tRefDepRea", queryParams);
}

$("#BtnAdd").bind('click', function () {
	//$('#tRefDepRea').datagrid('endEdit', lastIndex);
	lastIndex = $('#tRefDepRea').datagrid('getRows').length - 1;
	$('#tRefDepRea').datagrid('selectRow', lastIndex);
	var selected = $('#tRefDepRea').datagrid('getSelected');
	if (selected) {
		if (typeof(selected.TRowid) == "undefined") {
			$.messager.alert('提示', "不能同时添加多条", "info");
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", "info");
		return;
	}
	$("#tRefDepRea").datagrid("appendRow", {
		TRefCode: '',
		TRefDesc: '',
		TRefStdate: '',
		TRefEnddate: '',
		TRefflagdesc: ''
	});
	lastIndex = $('#tRefDepRea').datagrid('getRows').length - 1;
	$('#tRefDepRea').datagrid('selectRow', lastIndex);
	$('#tRefDepRea').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
});

$("#BtnUpdate").bind('click', function () {
	var selected = $('#tRefDepRea').datagrid('getSelected');
	if (selected) {
		var thisIndex = $('#tRefDepRea').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#tRefDepRea').datagrid('beginEdit', thisIndex);
		EditIndex = thisIndex;
	}
});

$('#BtnSave').bind('click', function () {
	$('#tRefDepRea').datagrid('acceptChanges');
	var selected = $('#tRefDepRea').datagrid('getSelected');
	if (selected) {
		if ((selected.TRowid == "") || (typeof(selected.TRowid) == "undefined")) {
			if ((selected.TRefCode == "") || (selected.TRefDesc == "") || (selected.TRefStdate == "")) {
				$.messager.alert('提示', "数据为空，不允许添加", 'info');
				lastIndex = "";
				EditIndex = -1;
				initLoadGrid();
				return;
			}
			var RefStr = "^" + selected.TRefCode + "^" + selected.TRefDesc + "^" + selected.TRefStdate + "^" + selected.TRefEnddate + "^" + selected.TRefflagdesc
				$.cm({
					ClassName: "DHCBILLConfig.DHCBILLOthConfig",
					MethodName: "InsertRefDepReason",
					RefInfo: RefStr,
					Guser: PUBLIC_CONSTANT.SESSION.USERID,
					HospID: PUBLIC_CONSTANT.SESSION.HOSPID
				}, function (rtn) {
					if (+rtn == 0) {
						$.messager.alert('提示', "保存成功", 'success');
					} else {
						$.messager.alert('提示', "保存失败，错误代码：" + rtn, 'error');
					}
					lastIndex = "";
					EditIndex = -1;
					initLoadGrid();
				});
		} else {
			$('#tRefDepRea').datagrid('selectRow', EditIndex);
			var selected = $('#tRefDepRea').datagrid('getSelected');
			var RefStr = selected.TRowid + "^" + selected.TRefCode + "^" + selected.TRefDesc + "^" + selected.TRefStdate + "^" + selected.TRefEnddate + "^" + selected.TRefflagdesc
				if ((selected.TRefCode == "") || (selected.TRefDesc == "") || (selected.TRefStdate == "")) {
					$.messager.alert('提示', "数据为空，不允许添加", 'info');
					lastIndex = "";
					EditIndex = -1;
					initLoadGrid();
					return;
				}
				$.cm({
					ClassName: "DHCBILLConfig.DHCBILLOthConfig",
					MethodName: "UpdateRefDepReason",
					RefInfo: RefStr,
					Guser: PUBLIC_CONSTANT.SESSION.USERID,
					HospID: PUBLIC_CONSTANT.SESSION.HOSPID
				}, function (rtn) {
					if (+rtn == 0) {
						$.messager.alert('提示', "修改成功", 'success');
					} else {
						$.messager.alert('提示', "修改失败，错误代码：" + rtn, 'error');
					}
					lastIndex = "";
					EditIndex = -1;
					initLoadGrid();
				});
		}
	}
});

$('#BtnFind').bind('click', function () {
	EditIndex = -1;
	initLoadGrid();
});
