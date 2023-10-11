/**
 * Desc:    ���������ֵ�ά��
 * Creator: Huxt 2019-09-11
 * csp:		pha.in.v3.mob.presctypedict.csp
 * js:		scripts/pha/mob/v2/presctypedict.js
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
	InitGridPrescType();

	$('#btnFind').on("click", Query);
	$('#btnAdd').on("click", AddNewRow);
	$('#btnSave').on("click", Save);
	$('#btnDelete').on("click", Delete);
});

// ��ʼ�����
function InitGridPrescType() {
	var columns = [
		[{
				field: 'pipt',
				title: 'pipt',
				width: 100,
				hidden: true
			}, {
				field: 'piptCode',
				title: '���ʹ���',
				width: 200,
				sortable: true,
				align: 'left',
				editor: GridEditors.validatebox
			}, {
				field: 'piptDesc',
				title: '��������',
				width: 225,
				align: 'left',
				editor: GridEditors.validatebox
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.TypeDict.Query',
			QueryName: 'TypeDict'
		},
		columns: columns,
		rownumbers: true,
		toolbar: "#gridPrescTypeBar",
		editFieldSort: ["piptCode", "piptDesc"],
		onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: "gridPrescType",
				index: index,
				field: field
			});
		},
		onClickRow: function (rowIndex, rowData) {
			PHA_GridEditor.End("gridPrescType");
		}
	};
	PHA.Grid("gridPrescType", dataGridOption);
}

// ��ѯ
function Query() {
	$('#gridPrescType').datagrid("reload");
}

// ������
function AddNewRow() {
	PHA_GridEditor.Add({
		gridID: 'gridPrescType',
		field: 'piptCode'
	});
}

// ����
function Save() {
	$('#gridPrescType').datagrid('endEditing');

	var gridChanges = $('#gridPrescType').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		$.messager.alert("��ʾ", "û����Ҫ���������", "warning");
		return;
	}
	var chkRetStr = PHA_GridEditor.CheckValues('gridPrescType');
	if (chkRetStr != "") {
		$.messager.popover({
			msg: chkRetStr,
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var pJsonStr = JSON.stringify(gridChanges);

	var saveRet = tkMakeServerCall("PHA.MOB.TypeDict.Save", "SaveMulti", pJsonStr);
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

// ɾ��
function Delete() {
	var gridSelect = $('#gridPrescType').datagrid("getSelected");
	if (gridSelect == null) {
		$.messager.alert("��ʾ", "��ѡ����Ҫɾ���ļ�¼!", "warning");
		return;
	}

	$.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function (r) {
		if (r) {
			var pipt = gridSelect.pipt || "";
			if (pipt == "") {
				var rowIndex = $('#gridPrescType').datagrid('getRowIndex', gridSelect);
				$('#gridPrescType').datagrid("deleteRow", rowIndex);
			} else {
				var delRet = tkMakeServerCall("PHA.MOB.TypeDict.Save", "Delete", pipt);
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
			}
		}
	});
}


/*
 * Grid Editors for this page
 */
var GridEditors = {
	// �ı�
	validatebox: {
		type: 'validatebox',
		options: {
			required: true,
			onEnter: function () {
				PHA_GridEditor.Next();
			}
		}
	}
}