/*
 * FileName: dhcbillmenu.epsiodeprice.js
 * User: TangTao
 * Date: 2014-04-10
 * Function: 病人就诊类型与标准价格
 * Description:
 */
 
var lastIndex = "";
var EditIndex = -1;

$(function () {
	initGrid();
	
	if (BDPAutDisableFlag('BtnAdd')) {
		$('#BtnAdd').hide();
	}
	if (BDPAutDisableFlag('BtnUpdate')) {
		$('#BtnUpdate').hide();
	}
	if (BDPAutDisableFlag('BtnDelete')) {
		$('#BtnDelete').hide();
	}
	if (BDPAutDisableFlag('BtnSave')) {
		$('#BtnSave').hide();
	}
	
	var tableName = "Bill_Com_TarEpisode";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#hospital").combobox({
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
			initLoadGrid();
		}
	});
});

function initGrid() {
	var PriceType = [{
			id: 'P0',
			name: 'Price'
		}, {
			id: 'P1',
			name: 'AlterPrice1'
		}, {
			id: 'P2',
			name: 'AlterPrice2'
		}
	];

	var CateColumns = [[{
				field: 'TEPRowid',
				title: 'TEPRowid',
				hidden: true
			}, {
				field: 'TEPESTDesc',
				title: '患者就诊子类型',
				width: 200,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + "?ClassName=DHCBILLConfig.DHCBILLSysType&QueryName=FindEpisodeSubType&ResultSetType=array",
						valueField: 'RowID',
						textField: 'SUBTDesc',
						required: true,
						onBeforeLoad: function (param) {
							param = $.extend(param, {
										Code: "",
										Desc: ""
									});
							return true;
						}
					}
				}
			}, {
				field: 'TEPPriceList',
				title: '标准价格',
				width: 150,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'id',
						textField: 'name',
						data: PriceType,
						required: true
					}
				}
			}, {
				field: 'TEPStartDate',
				title: '开始执行日期',
				width: 170,
				editor: 'datebox',
				sortable: true,
				resizable: true
			}, {
				field: 'TEPEndDate',
				title: '结束执行日期',
				width: 170,
				editor: 'datebox',
				sortable: true,
				resizable: true
			}, {
				field: 'TEPESTDR',
				title: 'TEPESTDR',
				hidden: true
			}, {
				field: 'TEPPriceListDr',
				title: 'TEPPriceListDr',
				hidden: true
			}
		]];

	// 初始化DataGrid
	$('#tTarCate').datagrid({
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
		ClassName: "DHCBILLConfig.DHCBILLSysType",
		QueryName: "FindTarEpisode",
		hospId: getValueById("hospital")
	};
	loadDataGridStore("tTarCate", queryParams);
}

$('#BtnAdd').bind('click', function () {
	lastIndex = $('#tTarCate').datagrid('getRows').length - 1;
	$('#tTarCate').datagrid('selectRow', lastIndex);
	var selected = $('#tTarCate').datagrid('getSelected');
	if (selected) {
		if (selected.TEPRowid == "") {
			$.messager.alert('提示', "不能同时添加多条!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#tTarCate').datagrid('appendRow', {
		TEPRowid: '',
		TEPESTDesc: '',
		TEPPriceList: '',
		TEPStartDate: '',
		TEPEndDate: ''
	});
	lastIndex = $('#tTarCate').datagrid('getRows').length - 1;
	$('#tTarCate').datagrid('selectRow', lastIndex);
	$('#tTarCate').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
});

$('#BtnUpdate').bind('click', function () {
	var selected = $('#tTarCate').datagrid('getSelected');
	if (selected) {
		var thisIndex = $('#tTarCate').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#tTarCate').datagrid('beginEdit', thisIndex);
		$('#tTarCate').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#tTarCate').datagrid('getSelected');

		var thisEd = $('#tTarCate').datagrid('getEditor', {
				index: EditIndex,
				field: 'TEPESTDesc'
			});
		$(thisEd.target).combobox('select', selected.TEPESTDR);
		var thisEd = $('#tTarCate').datagrid('getEditor', {
				index: EditIndex,
				field: 'TEPPriceList'
			});
		$(thisEd.target).combobox('select', selected.TEPPriceListDr);
	}
});

$('#BtnSave').bind('click', function () {
	$('#tTarCate').datagrid('acceptChanges');
	var selected = $('#tTarCate').datagrid('getSelected');
	if (selected) {
		// selected.TEPRowid为undefined，说明是新建项目，调用保存接口
		if (selected.TEPRowid == "") {
			if ((selected.TEPESTDesc == "undefined") || (selected.TEPPriceList == "undefined") || (selected.TEPESTDesc == "") || (selected.TEPPriceList == "")) {
				$.messager.alert('提示', "数据为空,不允许添加", 'info');
				initLoadGrid();
				return;
			}
			$.m({
				ClassName: "DHCBILLConfig.DHCBILLSysType",
				MethodName: "InsertTarEpisode",
				Price: selected.TEPPriceList,
				Episode: selected.TEPESTDesc,
				TepStDate: selected.TEPStartDate,
				TepEndDate: selected.TEPEndDate,
				User: PUBLIC_CONSTANT.SESSION.USERID,
				HospId: getValueById("hospital")
			}, function (rtn) {
				switch (rtn) {
				case '0':
					$.messager.alert('提示', '保存成功', 'success');
					break;
				case '-1001':
					$.messager.alert('提示', '病人就诊类型不存在，保存失败', 'error');
					break;
				case '-1002':
					$.messager.alert('提示', '标准价格不存在，保存失败', 'error');
					break;
				case '-1004':
					$.messager.alert('提示', '记录重复，保存失败', 'error');
					break;
				default:
					$.messager.alert('提示', '保存失败，错误代码：' + rtn, 'error');
				}
				initLoadGrid();
			});
		} else {
			$('#tTarCate').datagrid('selectRow', EditIndex);
			var selected = $('#tTarCate').datagrid('getSelected');
			if ((selected.TEPESTDesc == "undefined") || (selected.TEPPriceList == "undefined") || (selected.TEPESTDesc == "") || (selected.TEPPriceList == "")) {
				$.messager.alert('提示', "数据为空,不允许修改", 'info');
				initLoadGrid();
				return;
			}
			$.m({
				ClassName: "DHCBILLConfig.DHCBILLSysType",
				MethodName: "UpdateTarEpisode",
				TepRowid: selected.TEPRowid,
				Price: selected.TEPPriceList,
				Episode: selected.TEPESTDesc,
				TepStDate: selected.TEPStartDate,
				TepEndDate: selected.TEPEndDate,
				User: PUBLIC_CONSTANT.SESSION.USERID,
				HospId: getValueById("hospital")
			}, function (rtn) {
				switch (rtn) {
				case '0':
					$.messager.alert('提示', '修改成功', 'success');
					break;
				case '-1001':
					$.messager.alert('提示', '病人就诊类型不存在，修改失败', 'error');
					break;
				case '-1002':
					$.messager.alert('提示', '标准价格不存在，修改失败', 'error');
					break;
				case '-1004':
					$.messager.alert('提示', '记录重复，修改失败', 'error');
					break;
				default:
					$.messager.alert('提示', '修改失败，错误代码：' + rtn, 'error');
				}
				initLoadGrid();
			});
		}
	}
});

$('#BtnDelete').bind('click', function () {
	var selected = $('#tTarCate').datagrid('getSelected');
	if (!selected) {
		$.messager.alert('提示', '请选择要删除的记录', 'info');
		return;
	}
	if (selected.TEPRowid != "") {
		$.messager.confirm('确认', '您确认想要删除记录吗？', function (r) {
			if (r) {
				$.m({
					ClassName: "DHCBILLConfig.DHCBILLSysType",
					MethodName: "DeleteTarEpisode",
					RowID: selected.TEPRowid,
					User: PUBLIC_CONSTANT.SESSION.USERID
				}, function (rtn) {
					switch (rtn) {
					case '0':
						$.messager.alert('提示', "删除成功", 'success');
						break;
					case '-1001':
						$.messager.alert('提示', '病人就诊类型不存在，修改失败', 'error');
						break;
					case '-1002':
						$.messager.alert('提示', '标准价格不存在，修改失败', 'error');
						break;
					default:
						$.messager.alert('提示', '删除失败，错误代码：' + rtn, 'error');
					}
					initLoadGrid();
				});
			}
		});
	}
});

$('#BtnFind').bind('click', function () {
	initLoadGrid();
});

