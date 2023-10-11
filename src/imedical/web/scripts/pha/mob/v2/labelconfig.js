/**
 * Desc:    ����ҩ��ǩά��
 * Creator: Huxt 2019-09-11
 * Js: 		scripts/pha/mob/v2/labelconfig.js
 * csp:		pha.in.v3.mob.labelconfig.csp
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
$(function () {
	InitDict();
	InitGridLabelInci();
	$('#btnFind').on("click", Query);
	// $('#btnClear').on("click", Clear);

	$('#btnAdd').on("click", Add);
	$('#btnSave').on("click", Save);
	$('#btnDelete').on("click", Delete);

	$('#inciText').on('keydown', function (e) {
		if (e.keyCode == 13) {
			Query();
		}
	})
});

// ��ʼ�� - ���ֵ�
function InitDict() {
	$('#type').combobox({
		valueField: 'RowId',
		textField: 'Description',
		placeholder: '����...',
		panelHeight: 'auto',
		data: [{
				RowId: "OP",
				Description: "����"
			}, {
				RowId: "IP",
				Description: "סԺ"
			}
		],
		onSelect: function (record) {
			Query();
		},
		onChange: function (newValue, oldValue) {
			if (newValue == "") {
				Query();
			}
		}
	});

	InitHospCombo();
}

// ��ʼ�����
function InitGridLabelInci() {
	var columns = [
		[{
				field: 'pilc',
				title: 'pilc',
				width: 100,
				hidden: true
			}, {
				field: 'type',
				title: 'type',
				width: 100,
				sortable: 'true',
				align: 'center',
				hidden: true
			}, {
				field: 'typeDesc',
				title: '����',
				width: 90,
				sortable: 'true',
				align: 'center'
			}, {
				field: 'inciCode',
				title: 'ҩƷ����',
				width: 200,
				sortable: 'true'
			}, {
				field: 'inci',
				title: 'ҩƷId',
				width: 50,
				sortable: 'true',
				hidden: true
			}, {
				title: "ҩƷ����",
				field: "inciDesc",
				descField: 'inciDesc',
				width: 300,
				align: "left",
				editor: GridEditors.inci,
				formatter: function (value, rowData, index) {
					return rowData.inciDesc;
				}
			}, {
				field: 'inciSpec',
				title: '���',
				width: 120,
				sortable: 'true'
			}, {
				field: 'activeFlag',
				title: '�Ƿ񼤻�',
				width: 90,
				sortable: 'true',
				align: 'center',
				editor: GridEditors.activeFlag,
				formatter: FormatterYes
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.LabelCfg.Query',
			QueryName: 'LabelConfig'
		},
		columns: columns,
		toolbar: "#gridLabelCfgBar",
		isAutoShowPanel: false,
		editFieldSort: ["inci", "activeFlag"],
		onClickRow: function (rowIndex, rowData) {},
		onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: "gridLabelCfg",
				index: index,
				field: field
			});
		}
	};
	PHA.Grid("gridLabelCfg", dataGridOption);
}

// ��ѯ
function Query() {
	var type = $('#type').combobox('getValue') || "";
	var inciText = $("#inciText").val() || "";
	$('#gridLabelCfg').datagrid("load", {
		ClassName: 'PHA.MOB.LabelCfg.Query',
		QueryName: 'LabelConfig',
		QText: inciText,
		pJsonStr: JSON.stringify({
			type: type
		}),
		HospId: HospId
	});
}

// ����
function Clear() {
	$('#gridLabelCfg').datagrid("clear");
	$('#type').combobox('setValue', '');
	$('#inciText').val('');
}

// ����
function Add() {
	var type = $('#type').combobox('getValue') || "";
	if (type == "") {
		$.messager.popover({
			msg: "����ѡ������!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var typeDesc = "";
	if (type == "OP") {
		typeDesc = "����";
	}
	if (type == "IP") {
		typeDesc = "סԺ";
	}
	// �������
	$('#gridLabelCfg').datagrid('insertRow', {
		index: 0,
		row: {
			type: type,
			typeDesc: typeDesc,
			activeFlag: 'Y'
		}
	});

	// ��ʼ�༭
	PHA_GridEditor.Edit({
		gridID: "gridLabelCfg",
		index: 0,
		field: 'inciDesc'
	});
}

// ����
function Save() {
	$('#gridLabelCfg').datagrid('endEditing');
	var gridChanges = $('#gridLabelCfg').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		$.messager.alert("��ʾ", "û����Ҫ���������", "warning");
		return;
	}
	// ��ֵ֤
	var chkRetStr = PHA_GridEditor.CheckValues('gridLabelCfg');
	if (chkRetStr != "") {
		$.messager.popover({
			msg: chkRetStr,
			type: "alert",
			timeout: 1000
		});
		return;
	}
	// ��֤�ظ�
	var chkRetStr = PHA_GridEditor.CheckDistinct({
		gridID: 'gridLabelCfg',
		fields: ['type', 'inci']
	});
	if (chkRetStr != "") {
		$.messager.popover({
			msg: chkRetStr,
			type: "alert",
			timeout: 1000
		});
		return;
	}
	// �����̨
	var pJsonStr = JSON.stringify(gridChanges);
	var saveRet = tkMakeServerCall("PHA.MOB.LabelCfg.Save", "SaveMulti", pJsonStr, HospId);
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
	var gridSelect = $('#gridLabelCfg').datagrid("getSelected");
	if (gridSelect == null) {
		$.messager.popover({
			msg: "��ѡ����Ҫɾ���ļ�¼!",
			type: "alert",
			timeout: 1000
		});
		return;
	}

	$.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function (r) {
		if (r) {
			var pilc = gridSelect.pilc || "";
			if (pilc == "") {
				var rowIndex = $('#gridLabelCfg').datagrid('getRowIndex', gridSelect);
				$('#gridLabelCfg').datagrid("deleteRow", rowIndex);
			} else {
				var delRet = tkMakeServerCall("PHA.MOB.LabelCfg.Save", "Delete", pilc);
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

function FormatterYes(value, row, index) {
	if (value == "Y") {
		return PHA_COM.Fmt.Grid.Yes.Chinese;
	} else {
		return PHA_COM.Fmt.Grid.No.Chinese;
	}
}

/*
 * Grid Editors for this page
 */
var GridEditors = {
	// ҩƷ
	inci: {
		type: 'combogrid',
		options: {
			regExp: /\S/,
			regTxt: '����Ϊ��!',
			idField: 'incRowId',
			textField: 'incDesc',
			placeholder: 'ҩƷ����...',
			pagination: true,
			pageList: [10, 20, 50],
			pageSize: 10,
			width: 400,
			panelWidth: 600,
			mode: 'remote',
			columns: [[{
						field: 'incRowId',
						title: 'incItmRowId',
						width: 80,
						sortable: true,
						hidden: true
					}, {
						field: 'incCode',
						title: 'ҩƷ����',
						width: 100,
						sortable: true
					}, {
						field: 'incDesc',
						title: 'ҩƷ����',
						width: 360,
						sortable: true
					}, {
						field: 'incSpec',
						title: '���',
						width: 100,
						sortable: true
					}
				]],
			url: $URL + "?ClassName=PHA.MOB.Dictionary&QueryName=IncItm",
			onBeforeLoad: function (param) {
				param.q = param.q || "";
				if (param.q == "") {
					var gridSelect = $('#gridLabelCfg').datagrid("getSelected") || {};
					param.q = gridSelect.inciDesc;
				}
				param.QText = param.q;
				param.filterText = param.q;
				param.HospId = HospId;
			},
			onSelect: function (index, row) {
				// ����ѡ�е���
				var gridSelect = $('#gridLabelCfg').datagrid("getSelected");
				if (gridSelect == null) {
					return;
				}
				var rowIndex = $('#gridLabelCfg').datagrid('getRowIndex', gridSelect);
				// ��ʱ -- ���򱨴�???
				setTimeout(function () {
					$('#gridLabelCfg').datagrid('updateRow', {
						index: rowIndex,
						row: {
							inci: row.incRowId,
							inciCode: row.incCode,
							inciSpec: row.incSpec
						}
					});
				}, 500);
			},
			onShowPanel: function () {
				PHA_GridEditor.Show();
			},
			onHidePanel: function () {
				PHA_GridEditor.Next();
			}
		}
	},
	// �Ƿ����
	activeFlag: {
		type: 'icheckbox',
		options: {
			on: 'Y',
			off: 'N'
		}
	}
}

function InitHospCombo() {
	var genHospObj = PHA_COM.GenHospCombo({
		tableName: 'PHAIP_LabelConfig'
	});
	if (typeof genHospObj === 'object') {
		genHospObj.options().onSelect = function (index, record) {
			var newHospId = record.HOSPRowId;
			if (newHospId != HospId) {
				HospId = newHospId;
				Query();
			}
		}
		genHospObj.options().onLoadSuccess = function (data) {
			Query();
		}
	}
}
