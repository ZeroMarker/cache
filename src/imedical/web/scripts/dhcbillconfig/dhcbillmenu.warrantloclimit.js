/*
 * FileName: dhcbillmenu.warrantloclimit.js
 * User: xiongwang
 * Date: 2017-08-18
 * Function: 担保额度设置
 * Description: 
 */

var lastIndex = "";
var EditIndex = -1;
var thisLocRowid = "";
var thisAdmReasonid = "";
var thisJFWLLTimeLimitType = "";

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
	
	var tableName = "Bill_Com_WarrantLocLimit";
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
			//加载科室
			var url = $URL + "?ClassName=DHCBILLConfig.DHCBILLWarrant&QueryName=FindLoc&ResultSetType=array&hospId=" + newValue;
			$("#tTBLocCombo").combobox("clear").combobox("reload", url);
			//加载患者类型
			var url = $URL + "?ClassName=DHCBILLConfig.DHCBILLWarrant&QueryName=FindAdmReason&ResultSetType=array&HospId=" + newValue;
			$("#tTBAdmReasonCombo").combobox("clear").combobox("reload", url);
			//加载datagrid数据
			initLoadGrid();
		}
	});
	
	//科室
	$("#tTBLocCombo").combobox({
		valueField: 'LocRowid',
        textField: 'LocDesc',
		defaultFilter: 4,
		selectOnNavigation: false,
        onBeforeLoad: function(param) {
	    	$.extend(param, {desc: ""});
			return true;
		},
		onSelect: function(rec) {
			initLoadGrid();
		},
		onChange: function(newValue, oldValue) {
			if (!newValue) {
				initLoadGrid();
			}
		}
	});
	
	//患者类型
	$("#tTBAdmReasonCombo").combobox({
		valueField: 'RowID',
        textField: 'READesc',
		defaultFilter: 4,
		selectOnNavigation: false,
        onBeforeLoad: function(param) {
	       	$.extend(param, {Code: "", Desc: ""});
			return true;
		},
		onSelect: function(rec) {
			initLoadGrid();
		},
		onChange: function(newValue, oldValue) {
			if (!newValue) {
				initLoadGrid();
			}
		}
	});
});

function initGrid() {
	var CateColumns = [[{
				field: 'JFWLLLocDesc',
				title: '科室',
				width: 250,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + "?ClassName=DHCBILLConfig.DHCBILLWarrant&QueryName=FindLoc&ResultSetType=array",
						valueField: 'LocRowid',
						textField: 'LocDesc',
						defaultFilter: 4,
						onBeforeLoad: function (param) {
							$.extend(param, {desc: "", hospId: getValueById("hospital")});
							return true;
						},
						onSelect: function (rec) {
							if (rec) {
								thisLocRowid = rec.LocRowid;   //获取选中的就诊类型ID
							}
						}
					}
				}
			}, {
				field: 'JFWLLAdmReasonDesc',
				title: '病人类型',
				width: 150,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + "?ClassName=DHCBILLConfig.DHCBILLWarrant&QueryName=FindAdmReason&ResultSetType=array",
						valueField: 'RowID',
						textField: 'READesc',
						defaultFilter: 4,
						onBeforeLoad: function (param) {
							$.extend(param, {Code: "", Desc: "", HospId: getValueById("hospital")});
							return true;
						},
						onSelect: function (rec) {
							if (rec) {
								thisAdmReasonid = rec.RowID;
							}
						}
					}
				}
			}, {
				field: 'JFWLLTimeLimitTypeDesc',
				title: '时限类型',
				width: 100,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'id',
						textField: 'name',
						editable: false,
						data: [{
								id: 'D',
								name: '按天'
							}, {
								id: 'H',
								name: '按时'
							}
						],
						onSelect: function (rec) {
							thisJFWLLTimeLimitType = rec.id;
						}
					}
				}
			}, {
				field: 'JFWLLTimeLimit',
				title: '时限',
				width: 100,
				sortable: true,
				resizable: true,
				editor: {
					type: 'numberbox',
					options: {
						min: 0
					}
				}
			}, {
				field: 'JFWLLLimitAmount',
				title: '默认限额',
				width: 100,
				sortable: true,
				resizable: true,
				editor: {
					type: 'numberbox',
					options: {
						min: 0,
						precision: 2
					}
				}
			}, {
				field: 'JFWLLRowID',
				title: 'JFWLLRowID',
				hidden: true
			}, {
				field: 'JFWLLLocDR',
				title: 'JFWLLLocDR',
				hidden: true
			}, {
				field: 'JFWLLAdmReasonDR',
				title: 'JFWLLAdmReasonDR',
				hidden: true
			}, {
				field: 'JFWLLTimeLimitType',
				title: 'JFWLLTimeLimitType',
				hidden: true
			}
		]];

	// 初始化DataGrid
	$('#tWarrantLocLimit').datagrid({
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
			thisLocRowid = "",
			thisAdmReasonid = "",
			thisJFWLLTimeLimitType = "";
			EditIndex = -1;
		}
	});
}

function initLoadGrid() {
	var Loc = getValueById("tTBLocCombo");
	var AdmReason = getValueById("tTBAdmReasonCombo");
	var HospId = getValueById("hospital");
	var ExpStr = Loc + "^" + AdmReason + "^" + HospId;
	var queryParams = {
		ClassName: "DHCBILLConfig.DHCBILLWarrant",
		QueryName: "FindWarantLocLimit",
		ExpStr: ExpStr
	};
	loadDataGridStore("tWarrantLocLimit", queryParams);
}

$('#BtnAdd').bind('click', function () {
	lastIndex = $('#tWarrantLocLimit').datagrid('getRows').length - 1;
	$('#tWarrantLocLimit').datagrid('selectRow', lastIndex);
	var selected = $('#tWarrantLocLimit').datagrid('getSelected');
	if (selected) {
		if (typeof(selected.JFWLLRowID) == "undefined") {
			$.messager.alert('提示', "不能同时添加多条", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#tWarrantLocLimit').datagrid('appendRow', {
		JFWLLLocDesc: '',
		JFWLLAdmReasonDesc: '',
		JFWLLTimeLimitType: ''
	});
	lastIndex = $('#tWarrantLocLimit').datagrid('getRows').length - 1;
	$('#tWarrantLocLimit').datagrid('selectRow', lastIndex);
	$('#tWarrantLocLimit').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
});

$('#BtnUpdate').bind('click', function () {
	var selected = $('#tWarrantLocLimit').datagrid('getSelected');
	if (selected) {
		var thisIndex = $('#tWarrantLocLimit').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		thisLocRowid = selected.JFWLLLocDR;
		thisAdmReasonid = selected.JFWLLAdmReasonDR;
		thisJFWLLTimeLimitType = selected.JFWLLTimeLimitType;

		$('#tWarrantLocLimit').datagrid('beginEdit', thisIndex);
		$('#tWarrantLocLimit').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#tWarrantLocLimit').datagrid('getSelected');

		var thisEd = $('#tWarrantLocLimit').datagrid('getEditor', {
				index: EditIndex,
				field: 'JFWLLLocDesc'
			});
		$(thisEd.target).combobox('select', selected.JFWLLLocDR);
	}
});

$('#BtnSave').bind('click', function () {
	$('#tWarrantLocLimit').datagrid('acceptChanges');
	$('#tWarrantLocLimit').datagrid('selectRow', EditIndex);
	var selected = $('#tWarrantLocLimit').datagrid('getSelected');
	if (selected) {
		// selected.JFALERowID为undefined，说明是新建项目，调用保存接口
		if ((typeof(selected.JFWLLRowID) == "undefined") || (typeof(selected.JFWLLRowID) == "")) {
			var CateStr = "^" + thisLocRowid + "^" + thisAdmReasonid + "^" + thisJFWLLTimeLimitType + "^" + selected.JFWLLTimeLimit + "^" + selected.JFWLLLimitAmount;
			if (((typeof(thisLocRowid) == "undefined") || (thisLocRowid == "")) && ((typeof(thisAdmReasonid) == "undefined") || (thisAdmReasonid == ""))) {
				$.messager.alert('提示', "科室和病人类型不能同时为空，不允许添加", 'info');
				initLoadGrid();
				return;
			}
			if ((typeof(selected.JFWLLLimitAmount) == "undefined") || (selected.JFWLLLimitAmount == "")) {
				$.messager.alert('提示', "默认限额为空，不允许添加", 'info');
				initLoadGrid();
				return;
			}
			if ((((typeof(thisJFWLLTimeLimitType) == "undefined") || (thisJFWLLTimeLimitType == "")) && (selected.JFWLLTimeLimit != "undefined" && (selected.JFWLLTimeLimit != ""))) || (((typeof(thisJFWLLTimeLimitType) != "undefined") && (thisJFWLLTimeLimitType != "")) && (selected.JFWLLTimeLimit == "undefined" || (selected.JFWLLTimeLimit == "")))) {
				$.messager.alert('提示', "限制时限类型和时限必须同时有值或同时为空，不允许添加", 'info');
				initLoadGrid();
				return;
			}
			$.m({
				ClassName: "DHCBILLConfig.DHCBILLWarrant",
				MethodName: "InsertWarrantLocLimit",
				LocLimitInfo: CateStr,
				Guser: PUBLIC_CONSTANT.SESSION.USERID,
				HospID: getValueById("hospital")
			}, function(rtn) {
				if (rtn == "0") {
					$.messager.alert('提示', "保存成功", 'success');
				} else {
					$.messager.alert('提示', "保存失败，错误代码：" + rtn, 'error');
				}
				initLoadGrid();
			});
		} else {
			$('#tWarrantLocLimit').datagrid('selectRow', EditIndex);
			var selected = $('#tWarrantLocLimit').datagrid('getSelected');
			var CateStr = selected.JFWLLRowID + "^" + thisLocRowid + "^" + thisAdmReasonid + "^" + thisJFWLLTimeLimitType + "^" + selected.JFWLLTimeLimit + "^" + selected.JFWLLLimitAmount;
			if (((typeof(thisLocRowid) == "undefined") || (thisLocRowid == "")) && ((typeof(thisAdmReasonid) == "undefined") || (thisAdmReasonid == ""))) {
				$.messager.alert('提示', "科室和病人类型不能同时为空，不允许修改", 'info');
				initLoadGrid();
				return;
			}
			if (((typeof(selected.JFWLLLimitAmount) == "undefined") || (selected.JFWLLLimitAmount == ""))) {
				$.messager.alert('提示', "默认限额为空，不允许修改", 'info');
				initLoadGrid();
				return;
			}
			if ((((typeof(thisJFWLLTimeLimitType) == "undefined") || (thisJFWLLTimeLimitType == "")) && (selected.JFWLLTimeLimit != "undefined" && (selected.JFWLLTimeLimit != ""))) || (((typeof(thisJFWLLTimeLimitType) != "undefined") && (thisJFWLLTimeLimitType != "")) && (selected.JFWLLTimeLimit == "undefined" || (selected.JFWLLTimeLimit == "")))) {
				$.messager.alert('提示', "限制时限类型和时限必须同时有值或同时为空，不允许添加", 'info');
				initLoadGrid();
				return;
			}
			$.m({
				ClassName: "DHCBILLConfig.DHCBILLWarrant",
				MethodName: "UpdateWarrantLocLimit",
				LocLimitInfo: CateStr,
				Guser: PUBLIC_CONSTANT.SESSION.USERID,
				HospID: getValueById("hospital")
			}, function(rtn) {
				if (rtn == "0") {
					$.messager.alert('提示', "修改成功", 'success');
				} else {
					$.messager.alert('提示', "修改失败，错误代码：" + rtn, 'error');
				}
				initLoadGrid();
			});
		}
	}
});

$('#BtnDelete').bind('click', function () {
	var selected = $('#tWarrantLocLimit').datagrid('getSelected');
	if (!selected) {
		$.messager.alert('提示', "请选择要删除的记录", 'info');
		return;
	}
	$.messager.confirm('确认', '您确认想要删除记录吗？', function (r) {
		if (r) {
			var selected = $('#tWarrantLocLimit').datagrid('getSelected');
			if (selected) {
				if ((typeof(selected.JFWLLRowID) != "undefined") || (typeof(selected.JFWLLRowID) != "")) {
					var CateStr = selected.JFWLLRowID + "^" + selected.JFWLLLocDR + "^" + selected.JFWLLAdmReasonDR + "^" + selected.JFWLLTimeLimitType;
					CateStr = CateStr + "^" + selected.JFWLLTimeLimit + "^" + selected.JFWLLLimitAmount;
					$.m({
						ClassName: "DHCBILLConfig.DHCBILLWarrant",
						MethodName: "DeleteWarrantLocLimit",
						LocLimitInfo: CateStr,
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
		}
	});
});

$('#BtnFind').bind('click', function () {
	initLoadGrid();
});
