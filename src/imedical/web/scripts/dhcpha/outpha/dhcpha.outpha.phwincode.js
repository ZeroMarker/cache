/**
 * ģ��:    ����ҩ��
 * ��ģ��:  ҩ�����ڶ���
 * ��д����:2017-11-20
 * ��д��:  yunhaibao
 */
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
$(function () {
	InitDict();
	InitGrid();
	$("#btnClear").on('click', ClearHandler);
	$("#btnAdd").on('click', AddHandler);
	$("#btnUpdate").on('click', UpdateHandler);
	$("#btnSearch").on('click', SearchHandler);
});

var CtLocEditor = {
	type: 'combobox',
	options: {
		panelHeight: "300",
		valueField: "RowId",
		textField: "Desc",
		mode: "remote",
		url: 'DHCST.COMMONPHA.ACTION.csp' + '?action=GetCtLocDs',
		onHidePanel: function () {
			var locId = $(this).combobox("getValue");
			var winSelect = $("#grid-phwin").datagrid('getSelected');
			if (winSelect == null) {
				$.messager.alert("��ʾ", "����ѡ��ҩ������!", "info")
				return;
			}
			var phwId = winSelect.TPhwid;
			var saveRet = tkMakeServerCall("PHA.OP.CfDispWin.OperTab", "InsertPhwLoc", phwId, locId);
			var retCode = saveRet.split("^")[0];
			var retMessage = saveRet.split("^")[1];
			if (retCode != 0) {
				$.messager.alert('��ʾ', retMessage, "warning");
				return;
			} else {
				$.messager.alert('��ʾ', "ָ���������ӳɹ�!", "info");
				$('#grid-locwin').datagrid('reload');
			}
		}
	}
}

/// ��ʼ���ֵ�
function InitDict() {
	var options = {
		width: 'auto',
		panelWidth: 'auto',
		url: commonOutPhaUrl + '?action=GetUserAllLocDs&gUserId=' + session['LOGON.USERID']
	}
	$('#cmbPhLoc').dhcphaEasyUICombo(options);
	var options = {
		width: 'auto',
		panelWidth: 'auto',
		url: commonOutPhaUrl + '?action=GetWinType'
	}
	$('#cmbPhWinType').dhcphaEasyUICombo(options);
}

/// ��ʼ������
function InitGrid() {
	///���ڶ���
	var gridColumns = [
		[{
				field: 'TLocDesc',
				title: 'ҩ������',
				width: 200
			}, {
				field: 'TWinType',
				title: '��������',
				width: 150
			}, {
				field: 'TWinDesc',
				title: '��������',
				width: 200
			}, {
				field: 'TSureFlag',
				title: 'Ĭ��',
				width: 150,
				width: 75,
				align: 'center',
				formatter: function (value, row, index) {
					if (value == "��") {
						return '<i class="fa fa-check" aria-hidden="true" style="color:#17A05D;font-size:18px"></i>';
					}
				}
			}, {
				field: 'TNoUseFlag',
				title: '��Ч',
				width: 150,
				width: 75,
				align: 'center',
				formatter: function (value, row, index) {
					if (value == "��") {
						return '<i class="fa fa-check" aria-hidden="true" style="color:#17A05D;font-size:18px"></i>';
					}
				}
			}, {
				field: 'TPhlid',
				title: 'TPhlid',
				width: 150,
				hidden: true
			}, {
				field: 'TPhwid',
				title: 'TPhwid',
				width: 150,
				hidden: true
			}, {
				field: 'TLocId',
				title: 'TLocId',
				width: 150,
				hidden: true
			}, {
				field: 'TWinTypeId',
				title: 'TWinTypeId',
				width: 150,
				hidden: true
			}

		]
	];

	var options = {
		ClassName: 'PHA.OP.CfDispWin.Query',
		QueryName: 'FindPhWin',
		fitColumns: false,
		columns: gridColumns,
		rownumbers: true,
		singleSelect: true,
		striped: true,
		title: "ҩ������",
		onSelect: function (rowIndex, rowData) {
			$("#cmbPhLoc").combobox('setValue', rowData.TLocId);
			$("#cmbPhLoc").combobox('setText', rowData.TLocDesc);
			$("#cmbPhWinType").combobox('setValue', rowData.TWinTypeId);
			$("#txtPhWinDesc").val(rowData.TWinDesc);
			$("#chkDefault").prop("checked", rowData.TSureFlag == '��' ? true : false);
			$("#chkNoUse").prop("checked", rowData.TNoUseFlag == '��' ? true : false);
			$('#grid-locwin').datagrid({
				queryParams: {
					StrParams: rowData.TPhwid
				}
			});
		},
		onLoadSuccess: function () {
			$('#grid-locwin').datagrid('loadData', {
				total: 0,
				rows: []
			});
			$('#grid-locwin').datagrid('options').queryParams.params = "";
		}
	}
	$('#grid-phwin').dhcstgrideu(options);
	// ����ָ������
	var gridColumns = [
		[{
			field: 'THandler',
			title: "<a href='#' onclick='AddWinLoc()'><i class='fa fa-plus' aria-hidden='true' style='color:#17A05D;font-size:18px'></i></a>",
			width: 50,
			align: 'center',
			formatter: function (value, row, index) {
				return "<a href='#' onclick='DeleteWinLoc(" + index + ")'><i class='fa fa-minus' aria-hidden='true' style='color:#DE5145;font-size:18px'></i></a>";
			}
		}, {
			field: 'Tloc',
			title: '����',
			editor: CtLocEditor,
			width: 200
		}, {
			field: 'Trowid',
			title: 'Trowid',
			width: 200,
			hidden: true
		}, {
			field: 'TLocId',
			title: 'TLocId',
			width: 200,
			hidden: true
		}]
	];

	var options = {
		ClassName: 'PHA.OP.CfDispWin.Query',
		QueryName: 'GetLocWin',
		fitColumns: true,
		columns: gridColumns,
		singleSelect: true,
		striped: true,
		title: "ָ������",
		pagination: false
	}
	$('#grid-locwin').dhcstgrideu(options);
}

function ClearHandler() {
	$("#cmbPhLoc").combobox('setValue', "");
	$("#cmbPhWinType").combobox('setValue', "");
	$("#txtPhWinDesc").val("");
	$("#chkDefault").prop("checked", false);
	$("#chkNoUse").prop("checked", false);
	$('#grid-phwin').datagrid({
		queryParams: {
			StrParams: ""
		}
	});
}

/// ��ȡ����
function QueryParams(getType) {
	var params = "";
	var locId = $("#cmbPhLoc").combobox('getValue');
	if ((getType != "") && (locId == "")) {
		$.messager.alert('��ʾ', "ҩ�����Ʋ���Ϊ��!", "warning");
		return "";
	}
	var winTypeId = $("#cmbPhWinType").combobox('getValue');
	if ((getType != "") && (winTypeId == "")) {
		$.messager.alert('��ʾ', "�������Ͳ���Ϊ��!", "warning");
		return "";
	}
	var winDesc = $("#txtPhWinDesc").val();
	if ((getType != "") && (winDesc == "")) {
		$.messager.alert('��ʾ', "�������Ʋ���Ϊ��!", "warning");
		return "";
	}
	var defaultFlag = $("#chkDefault").prop("checked") == true ? '1' : '0';
	var nouseFlag = $("#chkNoUse").prop("checked") == true ? '1' : '0';
	params = locId + "^" + winTypeId + "^" + winDesc + "^" + defaultFlag + "^" + nouseFlag;
	return params;
}

function AddHandler() {
	var params = QueryParams(1);
	if (params == "") {
		return;
	}
	var paramsArr = params.split("^");
	var saveRet = tkMakeServerCall("PHA.OP.CfDispWin.OperTab", "Insert", paramsArr[0], paramsArr[2], paramsArr[3], paramsArr[4], paramsArr[1], session['LOGON.USERID']);
	var retCode = saveRet.split("^")[0];
	var retMessage = saveRet.split("^")[1];
	if (retCode != 0) {
		$.messager.alert('��ʾ', retMessage, "warning");
		return;
	} else {
		$.messager.alert('��ʾ', "���ӳɹ�!", "info");
		$("#grid-phwin").datagrid("reload");
	}
}

function UpdateHandler() {
	var seletcted = $("#grid-phwin").datagrid("getSelected");
	if (seletcted == null) {
		$.messager.alert('��ʾ', "����ѡ�����޸ĵ���!", "warning");
		return;
	}
	var params = QueryParams(1);
	if (params == "") {
		return;
	}
	var ctLocId = seletcted.TLocId;
	var phLocId = seletcted.TPhlid;
	var rowId = seletcted.TPhwid;
	var paramsArr = params.split("^");
	if (ctLocId != paramsArr[0]) {
		$.messager.alert('��ʾ', "�������޸�ҩ��!", "warning");
		return;
	}
	var saveRet = tkMakeServerCall("PHA.OP.CfDispWin.OperTab", "Update", rowId, paramsArr[2], paramsArr[3], paramsArr[4], paramsArr[1], session['LOGON.USERID']);
	var retCode = saveRet.split("^")[0];
	var retMessage = saveRet.split("^")[1];
	if (retCode != 0) {
		$.messager.alert('��ʾ', retMessage, "warning");
		return;
	} else {
		$.messager.alert('��ʾ', "�޸ĳɹ�!", "info");
		$("#grid-phwin").datagrid("reload");
	}
}

function SearchHandler() {
	var params = QueryParams("");
	$('#grid-phwin').datagrid({
		queryParams: {
			StrParams: params
		}
	});
}

function AddWinLoc() {
	var row = $('#grid-locwin').datagrid('getData').rows[0];
	if (row) {
		if (row.Trowid == "") {
			return;
		}
	}
	$("#grid-locwin").datagrid('insertRow', {
		index: 0,
		row: {
			Tloc: '',
			Trowid: '',
			TLocId: ''
		}
	});
	$("#grid-locwin").datagrid('beginEdit', 0);
}

function DeleteWinLoc(rowIndex) {
	$.messager.confirm('��ʾ', '��ȷ��ɾ����', function (r) {
		if (r) {
			var locWinData = $("#grid-locwin").datagrid('getData').rows[rowIndex];
			var locWinId = locWinData.Trowid;
			var delRet = tkMakeServerCall("PHA.OP.CfDispWin.OperTab", "DeletePhwLoc", locWinId);
			var retCode = delRet.split("^")[0];
			var retMessage = delRet.split("^")[1];
			if (retCode != 0) {
				$.messager.alert('��ʾ', retMessage, "warning");
				return;
			} else {
				$.messager.alert('��ʾ', "ɾ��ָ�����ҳɹ�!", "info");
				$("#grid-locwin").datagrid('reload');
			}
		}
	});
}