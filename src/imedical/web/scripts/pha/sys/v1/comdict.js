/**
 * 名称:	 药房公共-系统管理-公共类型字典维护
 * 编写人:	 yunhaibao
 * 编写日期: 2019-08-16
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
		PHA.Alert('温馨提示', '「通用字典维护」的数据中没有此类型代码【' + COMCODE + '】，请先维护', 'info');
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

// 条件字典
function InitDict() {
	PHA.SearchBox('conQText', {
		width: 400,
		searcher: Query,
		placeholder: '请输入类型代码、名称或者简拼检索...'
	});

	PHA.SearchBox('conQTextVal', {
		width: 400,
		searcher: QueryVal,
		placeholder: '请输入类型值代码、名称或者简拼检索...'
	});
}

// 表格 - 类型
function InitGridComDictType() {
	var columns = [
		[{
				field: 'oldScdiType',
				title: '老类型代码',
				width: 200,
				hidden: true
			}, {
				field: 'scdiType',
				title: '类型代码',
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
				title: '类型名称',
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

// 表格 - 类型值
function InitGridComDictTypeVal() {
	var columns = [
		[{
				field: 'scdiId',
				title: 'scdiId',
				hidden: true,
				width: 100
			}, {
				field: 'scdiCode',
				title: '类型值代码',
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
				title: '类型值名称',
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

// 事件
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

// 查询
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
// 添加
function Add() {
	PHA_GridEditor.Add({
		gridID: 'gridComDictType',
		field: 'scdiType'
	});
}
// 保存
function Save() {
	$('#gridComDictType').datagrid('endEditing');
	// 验证值
	var chkRetStr = PHA_GridEditor.CheckValues('gridComDictType');
	if (chkRetStr != '') {
		PHA.Popover({
			msg: chkRetStr,
			type: 'alert'
		});
		return;
	}
	// 重复行验证
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
	// 验证是否改变
	var gridChanges = $('#gridComDictType').datagrid('getChanges');
	var gridDelChanges = $('#gridComDictType').datagrid('getChanges', 'deleted');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		PHA.Popover({
			msg: '没有需要保存的数据',
			type: 'alert'
		});
		return;
	}
	// 保存
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
		PHA.Alert('提示', saveInfo, saveVal);
		return;
	}
	PHA.Popover({
		msg: '保存成功',
		type: 'success'
	});
	$('#gridComDictType').datagrid('reload');
}
// 删除
function Delete() {
	var selectedRow = $('#gridComDictType').datagrid('getSelected') || '';
	if (selectedRow == '') {
		PHA.Popover({
			msg: '请先选中需要删除的记录!',
			type: 'alert'
		});
		return;
	}
	var oldScdiType = selectedRow.oldScdiType || '';
	PHA.Confirm('删除提示', '您确定删除吗?</br>数据可能已被使用,请谨慎操作!', function () {
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
			PHA.Alert('提示', retInfo, 'warning');
			return;
		}
		PHA.Popover({
			msg: '删除成功!',
			type: 'success'
		});
		Query();
	});
}

// 查询值
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
// 添加值
function AddVal() {
	var seletedRow = $('#gridComDictType').datagrid('getSelected') || '';
	if (seletedRow == '') {
		PHA.Popover({
			msg: '请先选中字典类型!',
			type: 'alert'
		});
		return;
	}
	var scdiType = seletedRow.oldScdiType || '';
	if (scdiType == '') {
		PHA.Popover({
			msg: '字典类型未保存!',
			type: 'alert'
		});
		return;
	}
	PHA_GridEditor.Add({
		gridID: 'gridComDictTypeVal',
		field: 'scdiCode'
	});
}
// 保存值
function SaveVal() {
	$('#gridComDictTypeVal').datagrid('endEditing');
	var seletedRow = $('#gridComDictType').datagrid('getSelected') || '';
	if (seletedRow == '') {
		PHA.Popover({
			msg: '请选择字典类型!',
			type: 'alert'
		});
		return;
	}
	var scdiType = seletedRow.oldScdiType || '';
	var scdiTypeDesc = seletedRow.scdiTypeDesc || '';
	// 验证值
	var chkRetStr = PHA_GridEditor.CheckValues('gridComDictTypeVal');
	if (chkRetStr != '') {
		PHA.Popover({
			msg: chkRetStr,
			type: 'alert'
		});
		return;
	}
	// 重复行验证
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
	// 验证是否改变
	var gridChanges = $('#gridComDictTypeVal').datagrid('getChanges');
	var gridDelChanges = $('#gridComDictTypeVal').datagrid('getChanges', 'deleted');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		PHA.Popover({
			msg: '没有需要保存的数据',
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
	// 保存
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
		PHA.Alert('提示', saveInfo, saveVal);
		return;
	}
	PHA.Popover({
		msg: '保存成功',
		type: 'success'
	});
	QueryVal();
}
// 删除值
function DeleteVal() {
	var selectedRow = $('#gridComDictTypeVal').datagrid('getSelected') || '';
	if (selectedRow == '') {
		PHA.Popover({
			msg: '请先选中需要删除的记录!',
			type: 'alert'
		});
		return;
	}
	var scdiId = selectedRow.scdiId || '';
	PHA.Confirm('删除提示', '您确定删除吗?</br>数据可能已被使用,请谨慎操作!', function () {
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
			PHA.Alert('提示', retInfo, 'warning');
			return;
		}
		PHA.Popover({
			msg: '删除成功!',
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
			PHA.Alert('温馨提示', 'txt文件中数据格式错误，数据格式只能为json！', 'error');
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
		PHA.Alert('温馨提示', '导入完成, 成功:' + successCnt + ',失败:' + errCnt + '<br/>' + errInfo, 'success');
		
		Query();
	});	
}