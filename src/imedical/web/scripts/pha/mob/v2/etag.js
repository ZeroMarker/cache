/**
 * @Description: �ƶ�ҩ�� - ���ӱ�ǩ(ҩ����)��ѯ
 * @Creator:     Huxt 2021-03-05
 * @Csp:         pha.mob.v2.etag.csp
 * @Js:          pha/mob/v2/etag.js
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
	// ��ʼ��
	InitDict();
	InitGridETag();

	// �¼���
	$('#etagID').on('keypress', function (e) {
		if (e.keyCode == 13) {
			QueryETag();
		}
	});
	$('#etagBarCode').on('keypress', function (e) {
		if (e.keyCode == 13) {
			QueryETag();
		}
	});
	$('#txtBarCode').focus();

	$('#btnFind').on("click", QueryETag);
	$('#btnClear').on("click", Clear);
	$('#btnCancel').on("click", Cancel);
	$('#btnExport').on("click", ExportXls);
	$('#btnImport').on("click", ImportXls);
	$('#btnAdd').on("click", Add);
	$('#btnSave').on("click", Save);
	$('#btnDelete').on("click", Delete);
})

// ��ʼ����
function InitDict() {
	$("#etagStat").combobox({
		valueField: 'RowId',
		textField: 'Description',
		placeholder: 'ѡ��״̬...',
		width: '12em',
		editable: false,
		panelHeight: 'auto',
		data: [{
				RowId: 0,
				Description: 'ȫ��'
			}, {
				RowId: 1,
				Description: '��'
			}, {
				RowId: 2,
				Description: '����'
			}, {
				RowId: 3,
				Description: '����'
			}
		]
	});
	$("#etagStat").combobox("setValue", 0);
}

// ��ʼ�����
function InitGridETag() {
	var columns = [[{
				field: 'tSelect',
				checkbox: true
			}, {
				field: 'piet',
				title: 'piet',
				width: 80,
				hidden: true
			}, {
				field: 'pietID',
				title: '��ǩID',
				width: 150,
				editor: GridEditors.textbox
			}, {
				field: 'pietBarCode',
				title: '��ǩ�����',
				width: 90,
				editor: GridEditors.textbox
			}, {
				field: 'pietColor',
				title: '��ǩ��ɫ',
				width: 80,
				align: 'center',
				editor: GridEditors.pietColor
			}, {
				field: 'pietColorVal',
				title: '��ɫֵ',
				width: 80,
				align: 'center',
				editor: GridEditors.pietColor,
				styler: function (value, rowData, rowIndex) {
					if (!value) {
						return;
					}
					return 'background-color:' + value;
				}
			}, {
				field: 'pietState',
				descField: 'pietStateDesc',
				title: '��ǩ״̬',
				width: 80,
				align: 'center',
				editor: GridEditors.pietState,
				formatter: function (value, rowData, index) {
					return rowData.pietStateDesc;
				}
			}, {
				field: 'pietAppType',
				descField: 'pietAppTypeDesc',
				title: 'Ӧ�ó���',
				width: 80,
				editor: GridEditors.pietAppType,
				formatter: function (value, rowData, index) {
					return rowData.pietAppTypeDesc;
				}
			}, {
				field: 'pietPrescNo',
				title: '��ǰ����������',
				width: 150,
				align: 'center',
				editor: GridEditors.textbox
			}, {
				field: 'pietPlace',
				title: '��ǩλ��',
				width: 100,
				editor: GridEditors.textbox
			}, {
				field: 'pietType',
				descField: 'pietTypeDesc',
				title: '��ǩ����',
				width: 140,
				editor: GridEditors.pietType,
				formatter: function (value, rowData, index) {
					return rowData.pietTypeDesc;
				}
			}, {
				field: 'pietBattery',
				title: '��ǩ����',
				width: 80,
				align: 'center',
				editor: GridEditors.textbox
			}, {
				field: 'pietActiveTime',
				title: '����ʱ��(��ʱ��)',
				width: 155,
				align: 'center'
			}, {
				field: 'pietDeactiveTime',
				title: 'ͣ��ʱ��(���ʱ��)',
				width: 155,
				align: 'center'
			}, {
				field: 'pietCreateTime',
				title: '����ʱ��',
				width: 155,
				align: 'center'
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.ETag.Query',
			QueryName: 'ETag',
		},
		columns: columns,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		pagination: true,
		toolbar: '#gridETagBar',
		isAutoShowPanel: false,
		editFieldSort: ["pietID", "pietBarCode", "pietColor", "pietColorVal", "pietState", "pietAppType", "pietPrescNo", "pietPlace", "pietType", "pietBattery"],
		onSelect: function (rowIndex, rowData) {},
		onClickRow: function () {
			PHA_GridEditor.End("gridETag");
		},
		onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: "gridETag",
				index: index,
				field: field
			});
		},
		onLoadSuccess: function (data) {
			$('#etagBarCode').val("");
			$('#etagBarCode').focus();
			$('#gridETag').siblings('.datagrid-view2').find('.datagrid-header-check').children().eq(0).prop("checked", false);
			PHA_GridEditor.End("gridETag");
		}
	};
	PHA.Grid("gridETag", dataGridOption);
}

// ��ѯ
function QueryETag() {
	var formDataArr = PHA.DomData("#gridETagBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	var pJsonStr = JSON.stringify(formData);

	$('#gridETag').datagrid('query', {
		pJsonStr: pJsonStr
	});
}

// ����
function Clear(){
	PHA.DomData("#gridETagBar", {
		doType: 'clear'
	});
	$('#etagStat').combobox('setValue', '0');
	$('#etagID').val('');
	$('#etagBarCode').val('');
	$('#gridETag').datagrid('clear');
}

// ����
function Add() {
	PHA_GridEditor.Add({
		gridID: 'gridETag',
		field: 'pietID',
		rowData: {}
	});
}

// ����
function Save() {
	// ��ȡ���ݷ����ı����
	$('#gridETag').datagrid('endEditing');
	var changesData = $('#gridETag').datagrid('getChanges');
	if (changesData == null || changesData.length == 0) {
		PHA.Popover({
			msg: '����δ�����ı�,����Ҫ����!',
			type: "info"
		});
		return;
	}
	
	// ȷ������
	var newChangesData = [];
	for (var i = 0; i < changesData.length; i++) {
		var oneRowData = changesData[i];
		oneRowData.rowIndex = GetGridRowIndex('gridETag', oneRowData) + 1;
		newChangesData.push(oneRowData);
	}
	var pJsonStr = JSON.stringify(newChangesData);

	// ���浽��̨
	var retStr = tkMakeServerCall("PHA.MOB.ETag.Save", "SaveMulti", pJsonStr);
	var retArr = retStr.split("^");
	if (retArr[0] < 0) {
		$.messager.alert("��ʾ", retArr[1], "warning");
		return;
	}
	$.messager.popover({
		msg: "����ɹ�!",
		type: "success",
		timeout: 1000
	});
	QueryETag();
}

// ɾ��
function Delete() {
	// ѭ��ɾ��
	var checkedItems = $('#gridETag').datagrid('getChecked');
	if (!checkedItems || checkedItems.length == 0) {
		PHA.Popover({
			msg: 'δ��ѡ��Ҫɾ�������ݣ�',
			type: "alert"
		});
		return;
	}
	
	$.messager.confirm('ȷ����ʾ', 'ȷ��ɾ����ѡ��������', function (r) {
		if (r) {
			for (var i = 0; i < checkedItems.length; i++) {
				var oneItem = checkedItems[i];
				var piet = oneItem.piet || "";
				if (piet == "") {
					var rowIndex = $('#gridETag').datagrid('getRowIndex', oneItem);
					var rowData = $('#gridETag').datagrid('getRows')[rowIndex];
					$('#gridETag').datagrid("deleteRow", rowIndex);
				} else {
					var delRet = tkMakeServerCall("PHA.MOB.ETag.Save", "Delete", piet);
					var delRetArr = delRet.split('^');
					if (delRetArr[0] < 0) {
						$.messager.alert("��ʾ", delRetArr[1], (delRetArr[0] == "-1") ? "warning" : "error");
						return;
					}
				}
			}
			// ��ʾ
			$.messager.popover({
				msg: "ɾ���ɹ�!",
				type: "success",
				timeout: 1000
			});
			QueryETag();
		}
	});
}

// ȡ������(���ýӿ�)
function Cancel() {
	var newCheckedItems = [];
	var checkedItems = $('#gridETag').datagrid('getChecked');
	for (var i = 0; i < checkedItems.length; i++) {
		var oneItem = checkedItems[i];
		var pietID = oneItem.pietID || "";
		var pietPrescNo = oneItem.pietPrescNo || "";
		if (pietPrescNo == "") {
			continue;
		}
		newCheckedItems.push({
			pietID: pietID,
			pietPrescNo: pietPrescNo
		});
	}
	if (newCheckedItems.length == 0) {
		$.messager.popover({
			msg: "δ��ѡ��Ҫȡ���󶨴����ı�ǩ�����߹�ѡ�ı�ǩδ�󶨴���!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var pJsonStr = JSON.stringify(newCheckedItems);

	var retStr = tkMakeServerCall("PHA.MOB.ETag.Save", "CancelMulti", pJsonStr);
	var retArr = retStr.split("^");
	if (retArr[0] < 0) {
		$.messager.alert("��ʾ", retArr[1], "warning");
		return;
	}
	$.messager.popover({
		msg: "ȡ���ɹ�!",
		type: "success",
		timeout: 1000
	});
	QueryETag();
}

// ���������ݻ�ȡ�к�
function GetGridRowIndex(_id, _rowData) {
	var rowIndex = $('#' + _id).datagrid('getRowIndex', _rowData);
	return rowIndex;
}

// ����ģ��
var Xlsx_title = {
	pietID: "��ǩID",
	pietBarCode: "��ǩ����",
	pietColor: "��ǩ��ɫ",
	pietColorVal: "��ɫֵ",
	pietState: "����/��/����",
	pietAppType: "����/�豸",
	pierPrescNo: "��ǰ����������",
	pietPlace: "��ǩλ��",
	pietType: "��ǩ����",
	pietBattery: "��ǩ����"
};

function ExportXls() {
	var Xlsx_data = [{
		pietID: "04960f02ac5c84",
		pietBarCode: "M7394",
		pietColor: "��ɫ",
		pietColorVal: "#ff00ff00",
		pietState: "����/��/����",
		pietAppType: "����/�豸",
		pierPrescNo: "",
		pietPlace: "",
		pietType: "�����ǩ/��ͨ���ӱ�ǩ",
		pietBattery: ""
	}];
	var fileName = "���ӱ�ǩ����ģ��.xlsx";
	PHA_COM.ExportFile(Xlsx_title, Xlsx_data, fileName);
}

// ��������
function ImportXls() {
	PHA_COM.ImportFile({
		suffixReg: /^(.xls)|(.xlsx)$/
	}, function (data, file) {
		// �������
		var Xlsx_title_tmp = {};
		for (var k in Xlsx_title) {
			var title_Desc = Xlsx_title[k];
			Xlsx_title_tmp[title_Desc] = k;
		}

		// ��ȡ����
		var newData = [];
		for (var i = 0; i < data.length; i++) {
			var oneRow = data[i];
			var newOneRow = {};
			for (var j in oneRow) {
				if (Xlsx_title_tmp[j]) {
					newOneRow[Xlsx_title_tmp[j]] = oneRow[j];
				}
			}
			newData.push(newOneRow);
		}
		var pJsonStr = JSON.stringify(newData);

		// ���浽��̨
		var retStr = tkMakeServerCall("PHA.MOB.ETag.Save", "ImportData", pJsonStr);
		var retArr = retStr.split("^");
		if (retArr[0] < 0) {
			$.messager.alert("��ʾ", retArr[1], "warning");
			return;
		}
		$.messager.popover({
			msg: "����ɹ�!",
			type: "success",
			timeout: 1000
		});
		QueryETag();
	});
}

/*
 * Grid Editors for this page
 */
var GridEditors = {
	// �ı�
	textbox: {
		type: 'validatebox',
		options: {
			onEnter: function () {
				PHA_GridEditor.Next();
			}
		}
	},
	pietColor: {
		type: 'validatebox',
		options: {
			onEnter: function () {
				PHA_GridEditor.Next();
			}
		}
	},
	pietState: {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			url: $URL + '?ResultSetType=array&ClassName=PHA.MOB.ETag.Query&QueryName=ComboData&type=State',
			onBeforeLoad: function (param) {
				param.QText = param.q;
			},
			onShowPanel: function () {
				PHA_GridEditor.Show();
			},
			onHidePanel: function () {
				PHA_GridEditor.Next();
			}
		}
	},
	pietAppType: {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			url: $URL + '?ResultSetType=array&ClassName=PHA.MOB.ETag.Query&QueryName=ComboData&type=AppType',
			onBeforeLoad: function (param) {
				param.QText = param.q;
			},
			onShowPanel: function () {
				PHA_GridEditor.Show();
			},
			onHidePanel: function () {
				PHA_GridEditor.Next();
			}
		}
	},
	pietType: {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			url: $URL + '?ResultSetType=array&ClassName=PHA.MOB.ETag.Query&QueryName=ComboData&type=Type',
			onBeforeLoad: function (param) {
				param.QText = param.q;
			},
			onShowPanel: function () {
				PHA_GridEditor.Show();
			},
			onHidePanel: function () {
				PHA_GridEditor.Next();
			}
		}
	}
}
