/*
 * FileName: dhcbillmenu.arrears.js
 * User: TangTao
 * Date: 2014-04-10
 * Description: 非绿色通道欠费额度
 */

var lastIndex = "";
var EditIndex = -1;
var thisTJFAAdmReasonDr = "";
var thisTJFAEPSDr = "";
var thisTJFAAdmType = "";
var thisTJFADiaCatDr = "";
var thisTJFALocDr = "";
var thisTJFAWardDr = "";

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
	
	var tableName = "Bill_Com_Arrears";
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
			initLoadGrid(getValueById("ComboTD"));
		}
	});
	
	$("#ComboTD").combobox({
		valueField: 'TAdmCatRowid',
        textField: 'TAdmCatDesc',
        url: $URL + "?ClassName=DHCBILLConfig.DHCBILLArrears&QueryName=FindAdmCat&ResultSetType=array",
        value: 2,
		onSelect: function(rec) {
			initLoadGrid(rec.TAdmCatRowid);
		}
	});
});

function initGrid() {
	// 初始化Columns
	var CateColumns = [[{
				field: 'TJFAAdmReasonDesc',
				title: '收费类别',
				width: 200,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLSysType&QueryName=FindAdmReason&ResultSetType=array',
						valueField: 'RowID',
						textField: 'READesc',
						required: true,
						defaultFilter: 5,
						onBeforeLoad: function (param) {
							$.extend(param, {
										Code: "",
										Desc: "",
										HospId: getValueById("Hospital")
									});
							return true;
						},
						onSelect: function (rec) {
							if (rec) {
								thisTJFAAdmReasonDr = rec.RowID;
							}
						}
					}
				}
			}, {
				field: 'TJFAEPSDesc',
				title: '就诊子类型',
				width: 200,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLSysType&QueryName=FindEpisodeSubType&ResultSetType=array',
						valueField: 'RowID',
						textField: 'SUBTDesc',
						onBeforeLoad: function (param) {
							$.extend(param, {
										Code: "",
										Desc: ""
									});
							return true;
						},
						onSelect: function (rec) {
							if (rec) {
								thisTJFAEPSDr = rec.RowID;
							}
						}
					}
				}
			}, {
				field: 'TJFAAdmTypeDesc',
				title: '就诊类型',
				width: 200,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLArrears&QueryName=FindAdmType&ResultSetType=array',
						valueField: 'TAdmTypeCode',
						textField: 'TAdmTypeDesc',
						defaultFilter: 5,
						onSelect: function (rec) {
							if (rec) {
								thisTJFAAdmType = rec.TAdmTypeCode;
							}
						}
					}
				}
			}, {
				field: 'TJFADiaCatDesc',
				title: '病种',
				width: 200,
				sortable: true,
				resizable: true,
				hidden: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLArrears&QueryName=FindDiaCat&ResultSetType=array',
						valueField: 'TDiaCatRowid',
						textField: 'TDiaCatDesc',
						onSelect: function (rec) {
							if (rec) {
								thisTJFADiaCatDr = rec.TDiaCatRowid;
							}
						}
					}
				}
			}, {
				field: 'TJFALocDesc',
				title: '科室',
				width: 200,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLArrears&QueryName=FindAdmLoc&ResultSetType=array',
						valueField: 'TAdmLocRowid',
						textField: 'TAdmLocDesc',
						mode: 'remote',
						onBeforeLoad: function (param) {
							$.extend(param, {
										desc: param.q,
										hospId: getValueById('Hospital')
									});
							return true;
						},
						onSelect: function (rec) {
							if (rec) {
								thisTJFALocDr = rec.TAdmLocRowid
							}
						}
					}
				}
			}, {
				field: 'TJFAWardDesc',
				title: '病区',
				width: 200,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLArrears&QueryName=FindWard&ResultSetType=array',
						valueField: 'TWardRowid',
						textField: 'TWardDesc',
						mode: 'remote',
						onBeforeLoad: function (param) {
							$.extend(param, {
										desc: param.q,
										hospId: getValueById('Hospital')
									});
							return true;
						},
						onSelect: function (rec) {
							if (rec) {
								thisTJFAWardDr = rec.TWardRowid;
							}
						}
					}
				}
			}, {
				field: 'TJFARowID',
				title: 'TJFARowID',
				hidden: true
			}, {
				field: 'TJFAAdmReasonDr',
				title: 'TJFAAdmReasonDr',
				hidden: true
			}, {
				field: 'TJFAEPSDr',
				title: 'TJFAEPSDr',
				hidden: true
			}, {
				field: 'TJFAAdmType',
				title: 'TJFAAdmType',
				hidden: true
			}, {
				field: 'TJFADiaCatDr',
				title: 'TJFADiaCatDr',
				hidden: true
			}, {
				field: 'TJFALocDr',
				title: 'TJFALocDr',
				hidden: true
			}, {
				field: 'TJFAWardDr',
				title: 'TJFAWardDr',
				hidden: true
			}, {
				field: 'TJFAEHospDr',
				title: 'TJFAEHospDr',
				hidden: true
			}, {
				field: 'Operate',
				title: '欠费额度',
				width: 150,
				align: 'center',
				formatter: function(value, row, index) {
					return '<img onclick="OpenWinView(\'' + row.TJFARowID + '\',' + '\'' + row.TJFAEHospDr + '\')" src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png" style="cursor:pointer">';
				}
			}
		]];

	// 初始化DataGrid
	$('#tArrearsTable').datagrid({
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
			thisTJFAAdmReasonDr = "";
			thisTJFAEPSDr = "";
			thisTJFAAdmType = "";
			thisTJFADiaCatDr = "";
			thisTJFALocDr = "";
			thisTJFAWardDr = "";
		}
	});
}

function initLoadGrid(ComboTD) {
	var queryParams = {
		ClassName: "DHCBILLConfig.DHCBILLArrears",
		QueryName: "FindArrears",
		AdmCat: ComboTD,
		HospId: getValueById("Hospital")
	};
	loadDataGridStore("tArrearsTable", queryParams);
}

$('#BtnAdd').bind('click', function () {
	//$('#tArrearsTable').datagrid('endEdit', lastIndex);
	lastIndex = $('#tArrearsTable').datagrid('getRows').length - 1;
	$('#tArrearsTable').datagrid('selectRow', lastIndex);
	var selected = $('#tArrearsTable').datagrid('getSelected');
	if (selected) {
		if (typeof(selected.TJFARowID) == "undefined") {
			$.messager.alert('提示', "不能同时添加多条", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#tArrearsTable').datagrid('appendRow', {
		TJFAAdmReasonDesc: '',
		TJFAEPSDesc: '',
		TJFAAdmTypeDesc: '',
		TJFADiaCatDesc: '',
		TJFALocDesc: '',
		TJFAWardDesc: ''
	});
	lastIndex = $('#tArrearsTable').datagrid('getRows').length - 1;
	$('#tArrearsTable').datagrid('selectRow', lastIndex);
	$('#tArrearsTable').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
});

$('#BtnUpdate').bind('click', function () {
	var selected = $('#tArrearsTable').datagrid('getSelected');
	if (selected) {
		var thisIndex = $('#tArrearsTable').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#tArrearsTable').datagrid('beginEdit', thisIndex);
		EditIndex = thisIndex;
		var thisEd = $('#tArrearsTable').datagrid('getEditor', {
				index: EditIndex,
				field: 'TJFAAdmReasonDesc'
			});
		$(thisEd.target).combobox('select', selected.TJFAAdmReasonDr);
		var thisEd = $('#tArrearsTable').datagrid('getEditor', {
				index: EditIndex,
				field: 'TJFAEPSDesc'
			});
		$(thisEd.target).combobox('select', selected.TJFAEPSDr);
		var thisEd = $('#tArrearsTable').datagrid('getEditor', {
				index: EditIndex,
				field: 'TJFAAdmTypeDesc'
			});
		$(thisEd.target).combobox('select', selected.TJFAAdmType);
		var thisEd = $('#tArrearsTable').datagrid('getEditor', {
				index: EditIndex,
				field: 'TJFADiaCatDesc'
			});
		$(thisEd.target).combobox('select', selected.TJFADiaCatDr);
		var thisEd = $('#tArrearsTable').datagrid('getEditor', {
				index: EditIndex,
				field: 'TJFALocDesc'
			});
		$(thisEd.target).combobox('select', selected.TJFALocDr);
		var thisEd = $('#tArrearsTable').datagrid('getEditor', {
				index: EditIndex,
				field: 'TJFAWardDesc'
			});
		$(thisEd.target).combobox('select', selected.TJFAWardDr);

		thisTJFAAdmReasonDr = selected.TJFAAdmReasonDr;
		thisTJFAEPSDr = selected.TJFAEPSDr;
		thisTJFAAdmType = selected.TJFAAdmType;
		thisTJFADiaCatDr = selected.TJFADiaCatDr;
		thisTJFALocDr = selected.TJFALocDr;
		thisTJFAWardDr = selected.TJFAWardDr;
	}
});

$('#BtnSave').bind('click', function () {
	$('#tArrearsTable').datagrid('acceptChanges');
	var selected = $('#tArrearsTable').datagrid('getSelected');
	if (selected) {
		//selected.TJFARowID为undefined，说明是新建项目，调用保存接口
		var ComboTD = getValueById('ComboTD');
		if ((selected.TJFARowID == "") || (typeof(selected.TJFARowID) == "undefined")) {
			if ((thisTJFAAdmReasonDr == "") || (ComboTD == "")) {
				$.messager.alert('提示', "通道 或者 收费类别为空，不允许添加", 'info');
				initLoadGrid(ComboTD);
				return;
			};
			
			var ArrearsStr = "^" + ComboTD + "^" + thisTJFAEPSDr + "^" + thisTJFAAdmReasonDr + "^" + thisTJFAAdmType + "^" + thisTJFADiaCatDr;
			var ArrearsStr = ArrearsStr + "^" + thisTJFALocDr + "^" + thisTJFAWardDr;
			$.cm({
				ClassName: "DHCBILLConfig.DHCBILLArrears",
				MethodName: "InsertArrears",
				ArrearsInfo: ArrearsStr,
				Guser: PUBLIC_CONSTANT.SESSION.USERID,
				HospId: getValueById("Hospital")
			}, function (rtn) {
				if (rtn == 0) {
					$.messager.alert('提示', "保存成功", 'success');
				} else {
					$.messager.alert('提示', "保存失败，错误代码：" + rtn, 'error');
				}
				initLoadGrid(ComboTD);
			});
		} else {
			if (EditIndex == -1) {
				return;
			}
			$('#tArrearsTable').datagrid('selectRow', EditIndex);
			var selected = $('#tArrearsTable').datagrid('getSelected');
			if ((thisTJFAAdmReasonDr == "") || (ComboTD == "")) {
				$.messager.alert('提示', "通道 或者 收费类别为空，不允许修改", 'info');
				initLoadGrid(ComboTD);
				return;
			};

			thisTJFAAdmReasonDr = selected.TJFAAdmReasonDesc;
			thisTJFAEPSDr = selected.TJFAEPSDesc;
			thisTJFAAdmType = selected.TJFAAdmTypeDesc;
			thisTJFADiaCatDr = selected.TJFADiaCatDesc;
			thisTJFALocDr = selected.TJFALocDesc;
			thisTJFAWardDr = selected.TJFAWardDesc;
			var ArrearsStr = selected.TJFARowID + "^" + ComboTD + "^" + thisTJFAEPSDr + "^" + thisTJFAAdmReasonDr + "^" + thisTJFAAdmType + "^" + thisTJFADiaCatDr;
			var ArrearsStr = ArrearsStr + "^" + thisTJFALocDr + "^" + thisTJFAWardDr;

			$.cm({
				ClassName: "DHCBILLConfig.DHCBILLArrears",
				MethodName: "UpdateArrears",
				ArrearsInfo: ArrearsStr,
				Guser: PUBLIC_CONSTANT.SESSION.USERID
			}, function (rtn) {
				if (rtn == 0) {
					$.messager.alert('提示', "修改成功", 'success');
				} else {
					$.messager.alert('提示', "修改失败，错误代码：" + rtn, 'error');
				}
				initLoadGrid(ComboTD);
			});
		}
	}
});

$('#BtnDelete').bind('click', function () {
	var selected = $('#tArrearsTable').datagrid('getSelected');
	if (!selected) {
		$.messager.alert('提示', "请选择要删除的记录", 'info');
		return;
	}
	$.messager.confirm('确认', '您确认想要删除记录吗？', function (r) {
		if (!r) {
			return;
		}
		var selected = $('#tArrearsTable').datagrid('getSelected');
		if (selected) {
			if (typeof(selected.TJFARowID) != "undefined") {
				var ComboTD = getValueById('ComboTD');
				if (thisTJFAAdmReasonDr == "") {
					thisTJFAAdmReasonDr = selected.TJFAAdmReasonDesc;
				}
				if (thisTJFAEPSDr == "") {
					thisTJFAEPSDr = selected.TJFAEPSDesc;
				}
				if (thisTJFAAdmType == "") {
					thisTJFAAdmType = selected.TJFAAdmTypeDesc;
				}
				if (thisTJFADiaCatDr == "") {
					thisTJFADiaCatDr = selected.TJFADiaCatDesc;
				}
				if (thisTJFALocDr == "") {
					thisTJFALocDr = selected.TJFALocDesc;
				}
				if (thisTJFAWardDr == "") {
					thisTJFAWardDr = selected.TJFAWardDesc;
				}

				var ArrearsStr = selected.TJFARowID + "^" + ComboTD + "^" + thisTJFAEPSDr + "^" + thisTJFAAdmReasonDr + "^" + thisTJFAAdmType + "^" + thisTJFADiaCatDr;
				var ArrearsStr = ArrearsStr + "^" + thisTJFALocDr + "^" + thisTJFAWardDr;
				$.cm({
					ClassName: "DHCBILLConfig.DHCBILLArrears",
					MethodName: "DeleteArrears",
					ArrearsInfo: ArrearsStr,
					Guser: PUBLIC_CONSTANT.SESSION.USERID
				}, function (rtn) {
					if (rtn == 0) {
						$.messager.alert('提示', "删除成功", 'success');
					} else {
						$.messager.alert('提示', "删除失败，错误代码：" + rtn, 'error');
					}
					initLoadGrid(ComboTD);
				});
			}
		}
	});
});

$('#BtnFind').bind('click', function () {
	var ComboTD = getValueById('ComboTD');
	initLoadGrid(ComboTD);
});

function OpenWinView(JFARowID, JFAHospID) {
	if (!(+JFARowID > 0) || !(+JFAHospID > 0)) {
		return;
	}
	websys_showModal({
		url: 'dhcbillmenu.arrearsmoney.csp?&JFARowID=' + JFARowID + '&JFAHospID=' + JFAHospID,
		title: '欠费额度',
		iconCls: 'icon-w-list',
		width: 770,
		height: 500
	});
}
