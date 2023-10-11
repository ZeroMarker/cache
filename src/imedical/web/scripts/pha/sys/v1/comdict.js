/**
 * ����:	 ҩ������-ϵͳ����-���������ֵ�ά��
 * ��д��:	 yunhaibao
 * ��д����: 2019-08-16
 */
PHA_COM.App.Csp = 'pha.sys.v1.comdict.csp';
PHA_COM.App.Name = 'SYS.COMDICT';
var COMDICT_ROW = $.cm({
	ClassName: 'PHA.SYS.ComDict.Query',
	MethodName: 'GetRowData',
	code: COMCODE
}, false);

$(function () {
	InitDict();
	InitGridComDictType();
	InitGridComDictTypeVal();
	InitEvents();
	if (COMCODE !== '' && COMDICT_ROW.scdiType === undefined) {
		PHA.Alert('��ܰ��ʾ', '��ͨ���ֵ�ά������������û�д����ʹ��롾' + COMCODE + '��������ά��', 'info');
		$('.messager-button').css('visibility', 'hidden');
		return;
	}
	if (COMDICT_ROW.scdiType !== undefined) {
		$('#lyMain').layout('panel', 'west').panel('close');
		$('#lyMain').layout('resize');
		$('#panelMain').panel('setTitle', COMDICT_ROW.scdiTypeDesc);
	}
	PHA_UX.Translate({
		buttonID: 'btnTranslateVal',
		gridID: 'gridComDictTypeVal',
		idField: 'scdiId',
		sqlTableName: 'DHC_StkComDictionary'
	});
	setTimeout(Query, 100);
});

// �����ֵ�
function InitDict() {
	PHA.SearchBox('conQText', {
		width: 400,
		searcher: Query,
		placeholder: '���������ʹ��롢���ƻ��߼�ƴ����...'
	});

	PHA.SearchBox('conQTextVal', {
		width: 400,
		searcher: QueryVal,
		placeholder: '����������ֵ���롢���ƻ��߼�ƴ����...'
	});
}

// ��� - ����
function InitGridComDictType() {
	var columns = [
		[{
				field: 'oldScdiType',
				title: '�����ʹ���',
				width: 200,
				hidden: true
			}, {
				field: 'scdiType',
				title: '���ʹ���',
				width: 200,
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
				field: 'scdiTypeDesc',
				title: '��������',
				width: 400,
				editor: {
					type: 'validatebox',
					options: {
						required: true,
						onEnter: function () {
							PHA_GridEditor.Next();
						}
					}
				}
			}
		]
	];
	var dataGridOption = {
		url: '',
		fitColumns: true,
		columns: columns,
		shrinkToFit: true,
		isAutoShowPanel: true,
		editFieldSort: ['scdiType', 'scdiTypeDesc'],
		toolbar: '#gridComDictTypeBar',
		enableDnd: false,
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('endEditing');
			QueryVal();
		},
		onDblClickCell: function (rowIndex, field, value) {
			PHA_GridEditor.Edit({
				gridID: 'gridComDictType',
				index: rowIndex,
				field: field
			});
		},
		onLoadSuccess: function (data) {
			if (data.total > 0) {
				$('#gridComDictType').datagrid('selectRow', 0);
				QueryVal();
			}
		}
	};
	PHA.Grid('gridComDictType', dataGridOption);
}

// ��� - ����ֵ
function InitGridComDictTypeVal() {
	var columns = [
		[{
				field: 'scdiId',
				title: 'scdiId',
				hidden: true,
				width: 100
			}, {
				field: 'scdiCode',
				title: '����ֵ����',
				width: 200,
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
				field: 'scdiDesc',
				title: '����ֵ����',
				width: 250,
				editor: {
					type: 'validatebox',
					options: {
						required: true,
						onEnter: function () {
							PHA_GridEditor.Next();
						}
					}
				}
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.SYS.ComDict.Query',
			QueryName: 'ComDictTypeVal'
		},
		columns: columns,
		shrinkToFit: true,
		toolbar: '#gridComDictTypeValBar',
		isAutoShowPanel: true,
		editFieldSort: ['scdiCode', 'scdiDesc'],
		enableDnd: false,
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('endEditing');
		},
		onDblClickCell: function (rowIndex, field, value) {
			PHA_GridEditor.Edit({
				gridID: 'gridComDictTypeVal',
				index: rowIndex,
				field: field
			});
		}
	};
	PHA.Grid('gridComDictTypeVal', dataGridOption);
}

// �¼�
function InitEvents() {
	$('#btnAdd').on('click', Add);
	$('#btnSave').on('click', Save);
	$('#btnDelete').on('click', Delete);
	$('#btnExport').on('click', Export);
	$('#btnImport').on('click', Import);

	$('#btnAddVal').on('click', AddVal);
	$('#btnSaveVal').on('click', SaveVal);
	$('#btnDeleteVal').on('click', DeleteVal);
}

// ��ѯ
function Query() {
	if (COMDICT_ROW.scdiType !== undefined) {
		$('#gridComDictType').datagrid('loadData', {
			total: 1,
			rows: [COMDICT_ROW]
		});
	} else {
		var QText = $('#conQText').searchbox('getValue') || '';
		$('#gridComDictType').datagrid('options').url = $URL;
		$('#gridComDictType').datagrid('query', {
			ClassName: 'PHA.SYS.ComDict.Query',
			QueryName: 'ComDictType',
			QText: QText
		});
	}
}
// ���
function Add() {
	PHA_GridEditor.Add({
		gridID: 'gridComDictType',
		field: 'scdiType'
	});
}
// ����
function Save() {
	$('#gridComDictType').datagrid('endEditing');
	// ��ֵ֤
	var chkRetStr = PHA_GridEditor.CheckValues('gridComDictType');
	if (chkRetStr != '') {
		PHA.Popover({
			msg: chkRetStr,
			type: 'alert'
		});
		return;
	}
	// �ظ�����֤
	var chkRetStr = PHA_GridEditor.CheckDistinct({
		gridID: 'gridComDictType',
		fields: ['scdiType']
	});
	if (chkRetStr != '') {
		PHA.Popover({
			msg: chkRetStr,
			type: 'alert'
		});
		return;
	}
	// ��֤�Ƿ�ı�
	var gridChanges = $('#gridComDictType').datagrid('getChanges');
	var gridDelChanges = $('#gridComDictType').datagrid('getChanges', 'deleted');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		PHA.Popover({
			msg: 'û����Ҫ���������',
			type: 'alert'
		});
		return;
	}
	// ����
	var jsonDataStr = JSON.stringify(gridChanges);
	var saveRet = $.cm({
		ClassName: 'PHA.SYS.ComDict.Save',
		MethodName: 'SaveMulti',
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('��ʾ', saveInfo, saveVal);
		return;
	}
	PHA.Popover({
		msg: '����ɹ�',
		type: 'success'
	});
	$('#gridComDictType').datagrid('reload');
}
// ɾ��
function Delete() {
	var selectedRow = $('#gridComDictType').datagrid('getSelected') || '';
	if (selectedRow == '') {
		PHA.Popover({
			msg: '����ѡ����Ҫɾ���ļ�¼!',
			type: 'alert'
		});
		return;
	}
	var oldScdiType = selectedRow.oldScdiType || '';
	PHA.Confirm('ɾ����ʾ', '��ȷ��ɾ����?</br>���ݿ����ѱ�ʹ��,���������!', function () {
		if (oldScdiType == '') {
			var rowIndex = $('#gridComDictType').datagrid('getRowIndex', selectedRow);
			$('#gridComDictType').datagrid('deleteRow', rowIndex);
			return;
		}
		var retStr = $.cm({
			ClassName: 'PHA.SYS.ComDict.Save',
			MethodName: 'Delete',
			scdiType: oldScdiType,
			dataType: 'text'
		}, false);
		var retArr = retStr.split('^');
		var retVal = retArr[0];
		var retInfo = retArr[1];
		if (retVal < 0) {
			PHA.Alert('��ʾ', retInfo, 'warning');
			return;
		}
		PHA.Popover({
			msg: 'ɾ���ɹ�!',
			type: 'success'
		});
		Query();
	});
}

// ��ѯֵ
function QueryVal() {
	var seletedRow = $('#gridComDictType').datagrid('getSelected') || '';
	if (seletedRow == '') {
		return;
	}
	var scdiType = seletedRow.oldScdiType || '';
	var QText = $('#conQTextVal').searchbox('getValue') || '';
	$('#gridComDictTypeVal').datagrid('query', {
		InputStr: scdiType,
		QText: QText
	});
}
// ���ֵ
function AddVal() {
	var seletedRow = $('#gridComDictType').datagrid('getSelected') || '';
	if (seletedRow == '') {
		PHA.Popover({
			msg: '����ѡ���ֵ�����!',
			type: 'alert'
		});
		return;
	}
	var scdiType = seletedRow.oldScdiType || '';
	if (scdiType == '') {
		PHA.Popover({
			msg: '�ֵ�����δ����!',
			type: 'alert'
		});
		return;
	}
	PHA_GridEditor.Add({
		gridID: 'gridComDictTypeVal',
		field: 'scdiCode'
	});
}
// ����ֵ
function SaveVal() {
	$('#gridComDictTypeVal').datagrid('endEditing');
	var seletedRow = $('#gridComDictType').datagrid('getSelected') || '';
	if (seletedRow == '') {
		PHA.Popover({
			msg: '��ѡ���ֵ�����!',
			type: 'alert'
		});
		return;
	}
	var scdiType = seletedRow.oldScdiType || '';
	var scdiTypeDesc = seletedRow.scdiTypeDesc || '';
	// ��ֵ֤
	var chkRetStr = PHA_GridEditor.CheckValues('gridComDictTypeVal');
	if (chkRetStr != '') {
		PHA.Popover({
			msg: chkRetStr,
			type: 'alert'
		});
		return;
	}
	// �ظ�����֤
	var chkRetStr = PHA_GridEditor.CheckDistinct({
		gridID: 'gridComDictTypeVal',
		fields: ['scdiCode']
	});
	if (chkRetStr != '') {
		PHA.Popover({
			msg: chkRetStr,
			type: 'alert'
		});
		return;
	}
	// ��֤�Ƿ�ı�
	var gridChanges = $('#gridComDictTypeVal').datagrid('getChanges');
	var gridDelChanges = $('#gridComDictTypeVal').datagrid('getChanges', 'deleted');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		PHA.Popover({
			msg: 'û����Ҫ���������',
			type: 'alert'
		});
		return;
	}
	var jsonDataArr = [];
	for (var i = 0; i < gridChangeLen; i++) {
		var oneData = gridChanges[i];
		oneData.scdiType = scdiType;
		oneData.scdiTypeDesc = scdiTypeDesc;
		jsonDataArr.push(oneData);
	}
	// ����
	var jsonDataStr = JSON.stringify(jsonDataArr);
	var saveRet = $.cm({
		ClassName: 'PHA.SYS.ComDict.Save',
		MethodName: 'SaveValMulti',
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('��ʾ', saveInfo, saveVal);
		return;
	}
	PHA.Popover({
		msg: '����ɹ�',
		type: 'success'
	});
	QueryVal();
}
// ɾ��ֵ
function DeleteVal() {
	var selectedRow = $('#gridComDictTypeVal').datagrid('getSelected') || '';
	if (selectedRow == '') {
		PHA.Popover({
			msg: '����ѡ����Ҫɾ���ļ�¼!',
			type: 'alert'
		});
		return;
	}
	var scdiId = selectedRow.scdiId || '';
	PHA.Confirm('ɾ����ʾ', '��ȷ��ɾ����?</br>���ݿ����ѱ�ʹ��,���������!', function () {
		if (scdiId == '') {
			var rowIndex = $('#gridComDictTypeVal').datagrid('getRowIndex', selectedRow);
			$('#gridComDictTypeVal').datagrid('deleteRow', rowIndex);
			return;
		}
		var retStr = $.cm({
			ClassName: 'PHA.SYS.ComDict.Save',
			MethodName: 'DeleteVal',
			Id: scdiId,
			dataType: 'text'
		}, false);
		var retArr = retStr.split('^');
		var retVal = retArr[0];
		var retInfo = retArr[1];
		if (retVal < 0) {
			PHA.Alert('��ʾ', retInfo, 'warning');
			return;
		}
		PHA.Popover({
			msg: 'ɾ���ɹ�!',
			type: 'success'
		});
		QueryVal();
	});
}

function Export() {
	var QText = $('#conQText').searchbox('getValue') || '';
	var typeRows = $.cm({
		ClassName: 'PHA.SYS.ComDict.Query',
		QueryName: 'ComDictType',
		ResultSetType: 'array',
		QText: QText,
		page: 1,
		rows: 9999
	}, false);
	
	var retJson = [];
	for (var i = 0; i < typeRows.length; i++) {
		var typeRow = typeRows[i];
		var valArr = $.cm({
			ClassName: "PHA.SYS.ComDict.Query",
			QueryName: "ComDictTypeVal",
			ResultSetType: 'array',
			InputStr: typeRow.scdiType
		}, false);
		
		for (var j = 0; j < valArr.length; j++) {
			var jVal = valArr[j];
			var rowData = {};
			rowData.scdiType = typeRow.scdiType;
			rowData.scdiTypeDesc = typeRow.scdiTypeDesc;
			rowData.scdiCode = jVal.scdiCode;
			rowData.scdiDesc = jVal.scdiDesc;
			retJson.push(rowData);
		}
	}
	var txtStr = JSON.stringify(retJson);
	var blob = new Blob([txtStr], {type: "text/plain;charset=utf-8"});
	saveAs(blob, "ComDict.txt");
}

function Import() {
	PHA_COM.ImportFile({
		suffixReg: /^(.txt)$/,
		charset: 'utf-8'
	}, function(txt){
		var jsonObj = null;
		var jsonTxt = txt;
		try {
			jsonObj = eval('(' + txt + ')');
			jsonTxt = JSON.stringify(jsonObj);
		} catch(e) {
			PHA.Alert('��ܰ��ʾ', 'txt�ļ������ݸ�ʽ�������ݸ�ʽֻ��Ϊjson��', 'error');
			return;
		}
		
		var errInfo = '';
		var errCnt = 0;
		var successCnt = 0;
		for (var i = 0; i < jsonObj.length;i++) {
			var iData = jsonObj[i];
			var iText = iData.scdiType + '^' + iData.scdiTypeDesc + '^' + iData.scdiCode + '^' + iData.scdiDesc;
			var importRet = tkMakeServerCall("PHA.SYS.ComDict.Save", "InitSimple", iText);
			var importRetArr = importRet.split('^');
			if (importRetArr[0] < 0) {
				if (errInfo == '') {
					errInfo = importRetArr[1];
				} else {
					errInfo += '<br/>' + importRetArr[1];
				}
				errCnt = errCnt + 1;
				continue;
			}
			successCnt = successCnt + 1;
		}
		PHA.Alert('��ܰ��ʾ', '�������, �ɹ�:' + successCnt + ',ʧ��:' + errCnt + '<br/>' + errInfo, 'success');
		
		Query();
	});	
}