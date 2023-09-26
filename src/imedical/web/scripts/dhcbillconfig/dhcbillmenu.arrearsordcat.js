/*
 * FileName: dhcbillmenu.arrearsordcat.js
 * User: TangTao
 * Date: 2014-04-10
 * Function: 控制级别医嘱分类
 * Description:
 */
 
var winlastIndex = "";
var winEditIndex = -1;
var m_ArcItmCatDr = "";   //医嘱大类ID

$(function () {
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
	
	initArrearsOrdCatGrid();
});

function initArrearsOrdCatGrid() {
	// 初始化Columns
	var winCateColumns = [[{
				field: 'winJFAOCOrderCatDesc',
				title: '医嘱大类',
				width: 300,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLArrears&QueryName=FindOrdCat&ResultSetType=array&CateFlag=OrdCat',
						valueField: 'OrcRowid',
						textField: 'OrdCat',
						onBeforeLoad: function (param) {
							$.extend(param, {CateDr: "", HospId: winJFALHospID});
							return true;
						},
						onSelect: function (rec) {
							if (!rec) {
								return;
							}
							m_ArcItmCatDr = rec.OrcRowid;
							var thisEd = $('#tArrearsOrdCat').datagrid('getEditor', {
									index: winEditIndex,
									field: 'winJFAOCArcItmCatDesc'
								});
							$(thisEd.target).combobox('clear').combobox('reload');
						},
						onChange: function (newValue, oldValue) {
							if (!newValue) {
								var thisEd = $('#tArrearsOrdCat').datagrid('getEditor', {
										index: winEditIndex,
										field: 'winJFAOCArcItmCatDesc'
									});
								m_ArcItmCatDr = "";
								$(thisEd.target).combobox('clear').combobox('reload');
							}
						}
					}
				}
			}, {
				field: 'winJFAOCArcItmCatDesc',
				title: '医嘱子类',
				width: 300,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						width: 300,
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLArrears&QueryName=FindOrdCat&ResultSetType=array&CateFlag=ArcItmCat',
						valueField: 'OrcRowid',
						textField: 'OrdCat',
						onBeforeLoad: function (param) {
							$.extend(param, {CateDr: m_ArcItmCatDr, HospId:winJFALHospID});
							return true;
						}
					}
				}
			}, {
				field: 'winJFAOCOrderCat',
				title: 'winJFAOCOrderCat',
				hidden: true
			}, {
				field: 'winJFAOCArcItmCat',
				title: 'winJFAOCArcItmCat',
				hidden: true
			}, {
				field: 'winJFAOCRowID',
				title: 'winJFAOCRowID',
				hidden: true
			}
		]];

	// 初始化DataGrid
	$('#tArrearsOrdCat').datagrid({
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
			QueryName: "FindArrearsOrdCat",
			JFALRowID: winJFALRowID
		},
		onLoadSuccess: function (data) {
			winEditIndex = -1;
			m_ArcItmCatDr = "";
		}
	});
}

function initWinLoadGrid() {
	var queryParams = {
		ClassName: "DHCBILLConfig.DHCBILLArrears",
		QueryName: "FindArrearsOrdCat",
		JFALRowID: winJFALRowID
	};
	loadDataGridStore("tArrearsOrdCat", queryParams);
}

$('#winAdd').bind('click', function () {
	//$('#tArrearsOrdCat').datagrid('endEdit', winlastIndex);
	winlastIndex = $('#tArrearsOrdCat').datagrid('getRows').length - 1;
	$('#tArrearsOrdCat').datagrid('selectRow', winlastIndex);
	var selected = $('#tArrearsOrdCat').datagrid('getSelected');
	if (selected) {
		if (typeof(selected.winJFAOCRowID) == "undefined") {
			$.messager.alert('提示', "不能同时添加多条", 'info');
			return;
		}
	}
	if (winEditIndex >= 0) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#tArrearsOrdCat').datagrid('appendRow', {
		winJFAOCOrderCatDesc: '',
		winJFAOCArcItmCatDesc: ''
	});
	winlastIndex = $('#tArrearsOrdCat').datagrid('getRows').length - 1;
	$('#tArrearsOrdCat').datagrid('selectRow', winlastIndex);
	$('#tArrearsOrdCat').datagrid('beginEdit', winlastIndex);
	winEditIndex = winlastIndex;
});

$('#winUpdate').bind('click', function () {
	var selected = $('#tArrearsOrdCat').datagrid('getSelected');
	if (selected) {
		var thisIndex = $('#tArrearsOrdCat').datagrid('getRowIndex', selected);
		if ((winEditIndex != -1) && (winEditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#tArrearsOrdCat').datagrid('beginEdit', thisIndex);
		winEditIndex = thisIndex;
		var thisEd = $('#tArrearsOrdCat').datagrid('getEditor', {
				index: winEditIndex,
				field: 'winJFAOCOrderCatDesc'
			});
		$(thisEd.target).combobox('select', selected.winJFAOCOrderCat);
		var thisEd = $('#tArrearsOrdCat').datagrid('getEditor', {
				index: winEditIndex,
				field: 'winJFAOCArcItmCatDesc'
			});
		$(thisEd.target).combobox('select', selected.winJFAOCArcItmCat);
	}
});

$('#winSave').bind('click', function () {
	//$('#tArrearsOrdCat').datagrid('acceptChanges');
	$('#tArrearsOrdCat').datagrid('selectRow', winEditIndex)
	var selected = $('#tArrearsOrdCat').datagrid('getSelected');
	if (selected) {
		if ((selected.winJFAOCRowID == "") || (typeof(selected.winJFAOCRowID) == "undefined")) {
			var thisEd = $('#tArrearsOrdCat').datagrid('getEditor', {
					index: winEditIndex,
					field: 'winJFAOCOrderCatDesc'
				});
			var thisOrdCat = $(thisEd.target).combobox('getValue');
			var thisEd = $('#tArrearsOrdCat').datagrid('getEditor', {
					index: winEditIndex,
					field: 'winJFAOCArcItmCatDesc'
				});
			var thisArcCat = $(thisEd.target).combobox('getValue');
			if ((thisOrdCat == "") && (thisArcCat == "")) {
				$.messager.alert('提示', "医嘱大类和医嘱子类同时为空，不允许保存", 'info');
				winEditIndex = -1;
				initWinLoadGrid();
				return;
			};
			var ArrOrdCatStr = "" + "^" + thisOrdCat + "^" + thisArcCat + "^" + winJFALRowID;
			$.cm({
				ClassName: "DHCBILLConfig.DHCBILLArrears",
				MethodName: "InsertArrOrdCat",
				ArrOrdCatInfo: ArrOrdCatStr,
				Guser: PUBLIC_CONSTANT.SESSION.USERID
			}, function (rtn) {
				if (rtn == "0") {
					$.messager.alert('提示', "保存成功", 'success');
				} else {
					$.messager.alert('提示', "保存失败，错误代码：" + rtn, 'error');
				}
				winEditIndex = -1;
				initWinLoadGrid();
			});
		} else {
			$('#tArrearsOrdCat').datagrid('selectRow', winEditIndex);
			var selected = $('#tArrearsOrdCat').datagrid('getSelected');
			var thisEd = $('#tArrearsOrdCat').datagrid('getEditor', {
					index: winEditIndex,
					field: 'winJFAOCOrderCatDesc'
				});
			var thisOrdCat = $(thisEd.target).combobox('getValue');
			var thisEd = $('#tArrearsOrdCat').datagrid('getEditor', {
					index: winEditIndex,
					field: 'winJFAOCArcItmCatDesc'
				});
			var thisArcCat = $(thisEd.target).combobox('getValue');
			if ((thisOrdCat == "") && (thisArcCat == "")) {
				$.messager.alert('提示', "医嘱大类和医嘱子类同时为空，不允许保存", 'info');
				winEditIndex = -1;
				initWinLoadGrid();
				return;
			};
			var ArrOrdCatStr = selected.winJFAOCRowID + "^" + thisOrdCat + "^" + thisArcCat + "^" + winJFALRowID;
			$.cm({
				ClassName: "DHCBILLConfig.DHCBILLArrears",
				MethodName: "UpdateArrOrdCat",
				ArrOrdCatInfo: ArrOrdCatStr,
				Guser: PUBLIC_CONSTANT.SESSION.USERID
			}, function (rtn) {
				if (rtn == "0") {
					$.messager.alert('提示', "修改成功", 'success');
				} else {
					$.messager.alert('提示', "修改失败,错误代码:" + rtn, 'error');
				}
				winEditIndex = -1;
				initWinLoadGrid();
			});
		}
	}
});

$('#winDelete').bind('click', function () {
	var selected = $('#tArrearsOrdCat').datagrid('getSelected');
	if (!selected) {
		$.messager.alert('提示', "请选择要删除的记录", 'info');
		return;
	}
	$.messager.confirm('确认', '您确认想要删除记录吗？', function (r) {
		if (r) {
			var selected = $('#tArrearsOrdCat').datagrid('getSelected');
			if (selected) {
				if (typeof(selected.winJFAOCRowID) != "undefined") {
					var ArrOrdCatStr = selected.winJFAOCRowID + "^" + selected.winJFAOCOrderCat + "^" + selected.winJFAOCArcItmCat + "^" + winJFALRowID;
					$.cm({
						ClassName: "DHCBILLConfig.DHCBILLArrears",
						MethodName: "DeleteArrOrdCat",
						ArrOrdCatInfo: ArrOrdCatStr,
						Guser: PUBLIC_CONSTANT.SESSION.USERID
					}, function (rtn) {
						if (rtn == "0") {
							$.messager.alert('提示', "删除成功", 'success');
						} else {
							$.messager.alert('提示', "删除失败，错误代码:" + rtn, 'error');
						}
						initWinLoadGrid();
					});
				}
			}
		}
	});
});

$('#winFind').bind('click', function () {
	winlastIndex = "",
	winEditIndex = -1;
	initWinLoadGrid();
});