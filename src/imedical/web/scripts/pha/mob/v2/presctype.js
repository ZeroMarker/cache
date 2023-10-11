/**
 * ģ��:     ��������ά��
 * ��д����: 2020-20-20
 * ��д��:   Huxt
 * pha.in.v3.mob.presctype.csp
 * scripts/pha/mob/v2/presctype.js
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
	InitGridPrescType();
	InitGridCMPrescType();
	$('#btnAdd').on("click", AddNewRow);
	$('#btnSave').on("click", SavePrescType);
	$('#btnDelete').on("click", DelPrescType);
	$('#btnSaveType').on("click", SaveCMPrescType);
});

// �䷽����
function InitGridPrescType() {
	var columns = [
		[{
				field: "phpt",
				title: 'phpt',
				hidden: true
			}, {
				field: 'phptCode',
				title: '���ʹ���',
				width: 225,
				sortable: 'true',
				editor: {
					type: 'validatebox',
					options: {
						required: true,
						onEnter: function () {
							PHA_GridEditor.Next();
						}
					}
				}
			}, {
				field: 'phptDesc',
				title: '��������',
				width: 225,
				editor: {
					type: 'validatebox',
					options: {
						required: true,
						onEnter: function () {
							PHA_GridEditor.Next();
						}
					}
				}
			}, {
				field: 'phptDefault',
				title: 'Ĭ������',
				width: 100,
				sortable: 'true',
				align: 'center',
				hidden: true, // ûɶ��,��ʱȥ����
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				},
				formatter: FormatterYes
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.PrescType.Query',
			QueryName: 'HerbPrescType'
		},
		columns: columns,
		toolbar: "#gridPrescTypeBar",
		isAutoShowPanel: true,
		editFieldSort: ["phptCode", "phptDesc"],
		onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: "gridPrescType",
				index: index,
				field: field
			});
		},
		onClickRow: function (index, rowData) {
			$(this).datagrid('endEditing');
			QueryCMPrescType();
		}
	};
	PHA.Grid("gridPrescType", dataGridOption);
}

// ��ҩ���������б� (ȡҽ��վ)
function InitGridCMPrescType() {
	var columns = [
		[{
				field: 'tSelect',
				checkbox: true
			}, {
				field: 'cmptCode',
				title: '����',
				width: 225
			}, {
				field: 'cmptDesc',
				title: '����',
				width: 225
			}, {
				field: 'cmptActive',
				title: '�Ƿ����',
				width: 80,
				sortable: 'true',
				align: 'center',
				formatter: FormatterYes
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.PrescType.Query',
			QueryName: 'CMPrescType'
		},
		singleSelect: false,
		columns: columns,
		toolbar: "#gridCMPrescTypeBar",
		onLoadSuccess: function(data) {
			var rowsData = data.rows;
			if (!rowsData || rowsData.length == 0) {
				return;
			}
			var checkedRows = 0;
			for (var i = 0; i < rowsData.length; i++) {
				var rowData = rowsData[i];
				if (rowData.checkedFlag == "Y") {
					$('#gridCMPrescType').datagrid('selectRow', i);
					checkedRows = checkedRows + 1;
				}
			}
			if (checkedRows != rowsData.length) {
				$('#gridCMPrescType').prev().find('.datagrid-header-check').children().eq(0).removeAttr('checked');
			}
		}
	};
	PHA.Grid("gridCMPrescType", dataGridOption);
}

// ��ѯ
function Query() {
	$('#gridPrescType').datagrid('load', {
		ClassName: 'PHA.MOB.PrescType.Query',
		QueryName: 'HerbPrescType'
	});
}

// ������
function AddNewRow() {
	PHA_GridEditor.Add({
		gridID: 'gridPrescType',
		field: 'phptCode',
		rowData: {
			phptDefault: 'N'
		}
	});
}

// ����ά�����䷽����
function SavePrescType() {
	$('#gridPrescType').datagrid('endEditing');
	// ��ȡ����
	var gridChanges = $('#gridPrescType').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		$.messager.alert("��ʾ", "û����Ҫ���������", "warning");
		return;
	}
	// ��ֵ֤
	var chkRetStr = PHA_GridEditor.CheckValues('gridPrescType');
	if (chkRetStr != "") {
		PHA.Popover({
			msg: chkRetStr,
			type: "alert"
		});
		return;
	}
	// �ظ�����֤
	var chkRetStr = PHA_GridEditor.CheckDistinct({
		gridID: 'gridPrescType',
		fields: ['phptCode']
	});
	if (chkRetStr != "") {
		PHA.Popover({
			msg: chkRetStr,
			type: "alert"
		});
		return;
	}
	// ����
	var pJsonStr = JSON.stringify(gridChanges);
	var saveRet = tkMakeServerCall("PHA.MOB.PrescType.Save", "SaveMulti", pJsonStr);
	var saveArr = saveRet.split("^");
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		$.messager.alert("��ʾ", saveInfo, "warning");
		return;
	}
	$.messager.popover({
		msg: "����ɹ�!",
		type: "success",
		timeout: 1000
	});
	Query();
}

// ɾ��ά�����䷽����
function DelPrescType() {
	var gridSelect = $('#gridPrescType').datagrid("getSelected");
	if (gridSelect == null) {
		$.messager.alert("��ʾ", "��ѡ����Ҫɾ���ļ�¼!", "warning");
		return;
	}
	$.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function (r) {
		if (r) {
			var phpt = gridSelect.phpt || "";
			if (phpt == "") {
				var rowIndex = $('#gridPrescType').datagrid('getRowIndex', gridSelect);
				$('#gridPrescType').datagrid("deleteRow", rowIndex);
			} else {
				var delRet = tkMakeServerCall("PHA.MOB.PrescType.Save", "Delete", phpt);
				var delRetArr = delRet.split('^');
				if (delRetArr[0] < 0) {
					$.messager.alert("��ʾ", delRetArr[1], (delRetArr[0] == "-1") ? "warning" : "error");
					return;
				}
				$.messager.popover({
					msg: "ɾ���ɹ�!",
					type: "success",
					timeout: 1000
				});
				Query();
				QueryCMPrescType();
			}
		}
	})
}

// ˢ�����б�
function QueryCMPrescType() {
	var gridSelect = $('#gridPrescType').datagrid("getSelected") || {};
	var pJsonStr = JSON.stringify(gridSelect);
	$('#gridCMPrescType').datagrid('load', {
		ClassName: 'PHA.MOB.PrescType.Query',
		QueryName: 'CMPrescType',
		pJsonStr: pJsonStr,
		gLocId: SessionLoc
	});
}

// ��������Ĵ�������
function SaveCMPrescType() {
	var gridSelect = $("#gridPrescType").datagrid("getSelected");
	if (gridSelect == null) {
		$.messager.popover({
			msg: "����ѡ�������Ҫά�����䷽����!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var phpt = gridSelect.phpt;
	
	var gridDetailChecked = $("#gridCMPrescType").datagrid("getChecked");
	var pJsonStr = JSON.stringify(gridDetailChecked);
	
	var saveRet = tkMakeServerCall("PHA.MOB.PrescType.Save", "SaveItmMulti", phpt, pJsonStr);
	var saveArr = saveRet.split("^");
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		$.messager.alert("��ʾ", saveInfo, "warning");
		return;
	}
	$.messager.popover({
		msg: "����ɹ�!",
		type: "success",
		timeout: 1000
	});
	QueryCMPrescType();
}

// ��ʽ��
function FormatterYes(value, row, index) {
	if (value == "Y") {
		return PHA_COM.Fmt.Grid.Yes.Chinese;
	} else {
		return PHA_COM.Fmt.Grid.No.Chinese;
	}
}
