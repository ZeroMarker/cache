/**
 * Desc:    ��ҩ·��ά��
 * Creator: Huxt 2019-09-11
 * csp:		csp/pha.in.v3.mob.sendloc.csp
 * js:		scripts/pha/mob/v2/sendloc.js
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
PHA_COM.Param.PageRows = 99999;
$(function () {
	InitDict();
	InitGridPhLoc();
	InitGridSendLoc();
	InitGridWardLoc();

	$('#btnFind').on('click', function () {
		QueryCom();
	});
	$('#btnSave').on('click', Save);
	$('#btnDelete').on('click', Delete);
	$('#btnSaveAllWard').on('click', SaveAllWard);
	$('#wardLocCon').on('keydown', function (e) {
		if (e.keyCode == 13) {
			QueryCom();
		}
	});
});

// ��ʼ�� - ��
function InitDict() {
	PHA.SearchBox("phLocAlias", {
		width: 265,
		searcher: QueryPhLoc,
		placeholder: "�������ƴ�����ƻس���ѯ..."
	});
	PHA.SearchBox("wardLocAlias", {
		width: 265,
		searcher: QueryWardLoc,
		placeholder: "�������ƴ�����ƻس���ѯ..."
	});

}

// ��ʼ�� - ��ʼ��ҩ������
function InitGridPhLoc() {
	var columns = [
		[{
				field: 'RowId',
				title: 'RowId',
				width: 100,
				hidden: true
			}, {
				field: 'Description',
				title: 'ҩ������',
				width: 100
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.STORE.Org',
			QueryName: 'CTLoc',
			TypeStr: 'D',
			HospId: session['LOGON.HOSPID'],
			page: 1,
			rows: PHA_COM.Param.PageRows
		},
		columns: columns,
		toolbar: "#gridPhLocBar",
		rownumbers: true,
		fitColumns: true,
		pagination: false,
		onSelect: function (rowIndex, rowData) {
			$('#phLocDesc').val(rowData.Description);
			QuerySendLoc();
			QueryWardLoc();
		},
		onLoadSuccess: function (data) {
			if (data.total > 0) {
				$('#gridPhLoc').datagrid('selectRow', 0);
			}
		}
	};
	PHA.Grid("gridPhLoc", dataGridOption);
}

// ��ʼ�� - ��ҩ���ұ��
function InitGridSendLoc() {
	var columns = [
		[{
				field: 'phsl',
				title: 'phsl',
				width: 100,
				hidden: true
			}, {
				field: 'phLocId',
				title: 'phLocId',
				width: 100,
				hidden: true
			}, {
				field: 'phLocDesc',
				title: 'ҩ��',
				width: 100,
				hidden: true
			}, {
				field: 'wardLocId',
				title: 'wardLocId',
				width: 100,
				hidden: true
			}, {
				field: 'wardLocDesc',
				title: '���տ���/����',
				width: 250
			}, {
				field: 'sendFlag',
				title: '�Ƿ���ҩ',
				width: 100,
				align: 'center',
				editor: GridEditors.checkbox,
				formatter: function (value, row, index) {
					if (value == 'Y') {
						return PHA_COM.Fmt.Grid.Yes.Chinese;
					} else {
						return PHA_COM.Fmt.Grid.No.Chinese;
					}
				}
			}, {
				field: 'wardQue',
				title: '��ʾ���',
				width: 100,
				editor: GridEditors.validatebox
			}, {
				field: 'sendFreqDesc',
				title: '��ҩƵ������',
				width: 100,
				editor: GridEditors.validatebox
			},
			{
				field: 'sendFreqFac',
				title: '��ҩƵ��ϵ��',
				width: 100,
				editor: GridEditors.validatebox
			}, {
				field: 'sendFac',
				title: '����ϵ��',
				width: 100,
				editor: GridEditors.validatebox
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.SendLoc.Query',
			QueryName: 'PHSenLoc',
			QText: '',
			pJsonStr: '',
			page: 1,
			rows: PHA_COM.Param.PageRows
		},
		columns: columns,
		toolbar: "#gridSendLocBar",
		pagination: false,
		pageSize: 9999,
		rownumbers: true,
		fitColumns: true,
		editFieldSort: ["sendFlag", "wardQue", "sendFreqDesc", "sendFreqFac", "sendFac"],
		onClickRow: function (rowIndex, rowData) {},
		onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: "gridSendLoc",
				index: index,
				field: field
			});
		},
		onClickRow: function (rowIndex, rowData) {
			PHA_GridEditor.End("gridSendLoc");
		}
	};
	PHA.Grid("gridSendLoc", dataGridOption);
}

// ��ʼ�� - �������
function InitGridWardLoc() {
	var columns = [
		[{
				field: 'RowId',
				title: 'RowId',
				width: 100,
				hidden: true
			}, {
				field: 'wardOperate',
				title: '����',
				width: 20,
				align: 'center',
				formatter: function (value, rowData, rowIndex) {
					return '<img title="���տ���/��������ά����" onclick="AddToSendLoc()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" style="border:0px;cursor:pointer">';
				}
			}, {
				field: 'Description',
				title: '����/����',
				width: 100
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.SendLoc.Query',
			QueryName: 'NotUsedWard',
			page: 1,
			rows: PHA_COM.Param.PageRows,
			pJsonStr: JSON.stringify({
				TypeStr: 'D,W',
				HospId: session['LOGON.HOSPID']
			})
		},
		columns: columns,
		toolbar: "#gridWardLocBar",
		rownumbers: true,
		fitColumns: true,
		pagination: false,
		onClickRow: function (rowIndex, rowData) {},
		onClickRow: function (rowIndex, rowData) {}
	};
	PHA.Grid("gridWardLoc", dataGridOption);
}

// ��ѯ - ҩ��
function QueryPhLoc() {
	var phLocAlias = $("#phLocAlias").searchbox("getValue") || "";
	$('#gridPhLoc').datagrid("reload", {
		ClassName: 'PHA.STORE.Org',
		QueryName: 'CTLoc',
		TypeStr: 'D',
		HospId: session['LOGON.HOSPID'],
		QText: phLocAlias,
		page: 1,
		rows: PHA_COM.Param.PageRows
	});
}

// ��ѯ - ��ά���Ĳ���
function QuerySendLoc() {
	var selPhLocData = $('#gridPhLoc').datagrid("getSelected");
	var phLocId = selPhLocData ? selPhLocData.RowId : "";
	var wardLocCon = $("#wardLocCon").val();
	var pJson = {
		phLocId: phLocId
	}
	var pJsonStr = JSON.stringify(pJson);
	$('#gridSendLoc').datagrid("reload", {
		ClassName: 'PHA.MOB.SendLoc.Query',
		QueryName: 'PHSenLoc',
		QText: wardLocCon,
		pJsonStr: pJsonStr,
		page: 1,
		rows: PHA_COM.Param.PageRows
	});
}

// ��ѯ - δά���Ĳ���
function QueryWardLoc() {
	var selPhLocData = $('#gridPhLoc').datagrid("getSelected");
	var phLocId = selPhLocData ? selPhLocData.RowId : "";
	var wardLocAlias = $("#wardLocAlias").searchbox("getValue") || "";
	var pJson = {
		TypeStr: 'D,W',
		HospId: session['LOGON.HOSPID'],
		phLocId: phLocId
	}
	var pJsonStr = JSON.stringify(pJson);
	$('#gridWardLoc').datagrid("reload", {
		ClassName: 'PHA.MOB.SendLoc.Query',
		QueryName: 'NotUsedWard',
		QText: wardLocAlias,
		pJsonStr: JSON.stringify(pJson),
		page: 1,
		rows: PHA_COM.Param.PageRows
	});
}

// ��ѯ
function QueryCom() {
	var selPhLocData = $('#gridPhLoc').datagrid("getSelected");
	var phLocId = selPhLocData ? selPhLocData.RowId : "";
	if (phLocId == "") {
		$.messager.popover({
			msg: "������ѡ��ҩ����",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	QuerySendLoc();
	QueryWardLoc();
}

// ����
function Save() {
	$('#gridSendLoc').datagrid('endEditing');
	// ��ȡ����
	var gridChanges = $('#gridSendLoc').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		$.messager.alert("��ʾ", "û����Ҫ���������", "warning");
		return;
	}
	// ���ֵ
	var chkRetStr = PHA_GridEditor.CheckValues('gridSendLoc');
	if (chkRetStr != "") {
		$.messager.popover({
			msg: chkRetStr,
			type: "alert",
			timeout: 1000
		});
		return;
	}
	// �������Ƿ��ظ�
	var chkRetStr = PHA_GridEditor.CheckDistinct({
		gridID: 'gridSendLoc',
		isCheckNull: false,
		fields: ['wardQue']
	});
	if (chkRetStr != "") {
		$.messager.popover({
			msg: "��ʾ���: " + chkRetStr,
			type: "alert",
			timeout: 1000
		});
		return;
	}
	
	var pJsonStr = JSON.stringify(gridChanges);
	var saveRet = tkMakeServerCall("PHA.MOB.SendLoc.Save", "SaveMulti", pJsonStr);
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
	QueryCom();
}

// ɾ��
function Delete() {
	var gridSelect = $('#gridSendLoc').datagrid("getSelected");
	if (gridSelect == null) {
		$.messager.alert("��ʾ", "��ѡ����Ҫɾ���ļ�¼!", "warning");
		return;
	}

	$.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function (r) {
		if (r) {
			var phsl = gridSelect.phsl || "";
			if (phsl == "") {
				var rowIndex = $('#gridSendLoc').datagrid('getRowIndex', gridSelect);
				var rowData = $('#gridSendLoc').datagrid('getRows')[rowIndex];
				$('#gridSendLoc').datagrid("deleteRow", rowIndex);
				$('#gridWardLoc').datagrid('appendRow', {
					RowId: rowData.wardLocId,
					Description: rowData.wardLocDesc,
				});
			} else {
				var delRet = tkMakeServerCall("PHA.MOB.SendLoc.Save", "Delete", phsl);
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
				QueryCom();
			}
		}
	});
}

// �������еĳ������
function SaveAllWard() {
	var selPhLocData = $('#gridPhLoc').datagrid("getSelected");
	var phLocId = selPhLocData ? selPhLocData.RowId : "";
	if (phLocId == "") {
		$.messager.popover({
			msg: "��ѡ��ҩ��!",
			type: "info",
			timeout: 1000
		});
		return;
	}
	var phLocDesc = selPhLocData.Description;

	$.messager.confirm('ȷ�϶Ի���', 'ȷ������<b>���в���</b>Ϊ<b>' + phLocDesc + '</b>�Ľ��տ�����', function (r) {
		if (r) {
			var retStr = tkMakeServerCall("PHA.MOB.SendLoc.Save", "SaveAllWard", phLocId);
			var retArr = retStr.split("^");
			if (retArr[0] < 0) {
				$.messager.alert("��ʾ", "����ʧ��:" + retArr[1], "warning");
				return;
			}
			$.messager.popover({
				msg: "����ɹ�!",
				type: "success",
				timeout: 1000
			});
			QueryCom();
		}
	})
}

// �Ҳ���ӵ�
function AddToSendLoc(wardLocId) {
	// ��ȡҩ��
	var selPhLocData = $('#gridPhLoc').datagrid("getSelected");
	var phLocId = selPhLocData ? selPhLocData.RowId : "";
	if (phLocId == "") {
		$.messager.popover({
			msg: "��ѡ��ҩ��!",
			type: "info",
			timeout: 1000
		});
		return;
	}
	var phLocDesc = selPhLocData.Description;

	// ��ȡ��������
	var $target = $(event.target);
	var rowIndex = $target.closest('tr[datagrid-row-index]').attr('datagrid-row-index');
	var rowData = $('#gridWardLoc').datagrid('getRows')[rowIndex];
	var wardLocId = rowData.RowId;
	var wardLocDesc = rowData.Description;

	// ����һ��
	var newRowData = {
		phLocId: phLocId,
		phLocDesc: phLocDesc,
		wardLocId: wardLocId,
		wardLocDesc: wardLocDesc
	}
	PHA_GridEditor.Add({
		gridID: 'gridSendLoc',
		field: 'wardQue',
		rowData: newRowData,
		checkRow: true
	});

	// ɾ��һ��
	$('#gridWardLoc').datagrid('deleteRow', rowIndex);
}

/*
 * Grid Editors for this page
 */
var GridEditors = {
	// �ı�
	validatebox: {
		type: 'validatebox',
		options: {
			onEnter: function () {
				PHA_GridEditor.Next();
			}
		}
	},
	// �ı���
	checkbox: {
		type: 'icheckbox',
		options: {
			on: 'Y',
			off: 'N'
		}
	}
}

// ��ʾ��ʾ����
function ShowHelpTips() {
	if ($('#winHelpTips').length == 0) {
		var helpHtmlStr = '';
		helpHtmlStr += '<div style="margin:10px;">';
		helpHtmlStr += '<p><b>סԺҩ����ҩ·��������ҩ��</b></p>';
		helpHtmlStr += '<p>&nbsp;&nbsp;&nbsp;&nbsp;1����Ҫ���͵�����������</p>';
		helpHtmlStr += '<p>&nbsp;&nbsp;&nbsp;&nbsp;2��סԺ�ƶ�ҩ��������ʾ�Ĳ�����˳��</p>';
		helpHtmlStr += '<br/>';
		helpHtmlStr += '<p><b>��ҩ����ҩ·��������ҩ��</b></p>';
		helpHtmlStr += '<p>&nbsp;&nbsp;&nbsp;&nbsp;1����ҩ��(��ҩ) -> ��ҩ��(����) -> ���ţ�</p>';
		helpHtmlStr += '<p>&nbsp;&nbsp;&nbsp;&nbsp;2����ҩ��(��ҩ) -> ��ҩ�� -> ��ҩ��(����) -> ���ţ�</p>';
		helpHtmlStr += '<p>&nbsp;&nbsp;&nbsp;&nbsp;3����ҩ��(��ҩ) -> �������� -> �������գ�</p>';
		helpHtmlStr += '<p>&nbsp;&nbsp;&nbsp;&nbsp;4����ҩ��(��ҩ) -> ��ҩ�� -> �������� -> �������ա�</p>';
		helpHtmlStr += '</div>';

		$('<div id="winHelpTips"></div>').appendTo('body');
		$('#winHelpTips').dialog({
			width: 420,
			height: 300,
			modal: true,
			title: '���տ���/����ά������',
			iconCls: 'icon-w-list',
			content: helpHtmlStr,
			closable: true
		});
	}
	$('#winHelpTips').dialog('open');
}
