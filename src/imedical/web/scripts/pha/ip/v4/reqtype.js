/**
 * 名称:	 住院移动药房-领药类型维护
 * 编写人:	 yunhaibao
 * 编写日期: 2020-4-03
 */
var GRID_PRTTYPE;
$(function () {
	InitDict();
	InitGridDict();
	InitGridReqType();
	InitGridDrugGroup();
	$('#btnAdd').on('click', function () {
		var loc = $('#conPhaLoc').combobox('getValue') || '';
		if (loc === '') {
			PHA.Popover({
				msg: '请先选择药房！',
				type: 'alert'
			});
			return;
		}
		$('#gridReqType').datagrid('addNewRow', {
			defaultRow: {
				loc: loc
			}
		});
		QueryDrugGroup();
	});
	$('#btnSave').on('click', Save);
	$('#btnDelete').on('click', Delete);
	$('#btnSaveItm').on('click', SaveItm);
	$('#btnFind').on('click', QueryReqType);
	$('#btnHelp').on('click', ShowHelp);
	
	QueryDrugGroup();
});

function InitDict() {
	PHA.ComboBox('conPhaLoc', {
		url: PHA_STORE.Pharmacy('IP').url,
		width: 223,
		editable: false,
		panelHeight: 'auto',
		onLoadSuccess: function (data) {
			$(this).combobox('selectDefault', session['LOGON.CTLOCID']);
		},
		onSelect: function () {
			$('#gridReqType').datagrid('clear');
			$('#gridDrugGroup').datagrid('clear');
			QueryReqType();
			QueryDrugGroup();
		}
	});
}
function InitGridDict() {
	GRID_PRTTYPE = PHA.EditGrid.ComboBox({
		required: true,
		tipPosition: 'top',
		url: PHA_STORE.ComDictionaryAsCode('IPReqType').url,
		panelHeight: 'auto',
		editable: false
	});
}

function InitGridReqType() {
	var columns = [
		[{
				field: 'prt',
				title: 'prt',
				width: 100,
				hidden: true
			}, {
				field: 'prtCode',
				title: '代码',
				width: 100,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				field: 'prtDesc',
				title: '名称',
				width: 130,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				field: 'prtTypeDesc',
				title: '名称描述',
				width: 100,
				hidden: true
			}, {
				field: 'prtType',
				title: '类型',
				width: 100,
				editor: GRID_PRTTYPE,
				descField: 'prtTypeDesc',
				formatter: function (value, row, index) {
					return row.prtTypeDesc;
				}
			}, {
				field: 'prtColor',
				title: '背景色',
				width: 100,
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			}, {
				field: 'colorPre',
				title: '预览',
				width: 70,
				styler: function (value, rowData) {
					var prtColor = rowData.prtColor || '';
					if (prtColor !== '') {
						return 'background-color:' + prtColor;
					}
				}
			}, {
				field: 'loc',
				title: 'loc',
				width: 150,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		pagination: false,
		columns: columns,
		fitColumns: true,
		toolbar: '#gridReqTypeBar',
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('endEditing');
			if ($(this).datagrid('options').editIndex == undefined) {
				QueryDrugGroup();
			}
		},
		onDblClickRow: function (rowIndex, rowData) {
			$(this).datagrid('beginEditRow', {
				rowIndex: rowIndex,
				editField: 'prtCode'
			});
		}
	};
	PHA.Grid('gridReqType', dataGridOption);
}
function InitGridDrugGroup() {
	var columns = [
		[{
				field: 'prti',
				title: 'prti',
				width: 100,
				hidden: true
			}, {
				field: 'itmChk',
				checkbox: true
			}, {
				field: 'sdg',
				title: 'sdg',
				width: 300,
				hidden: true
			}, {
				field: 'sdgCode',
				title: '代码',
				width: 100
			}, {
				field: 'sdgDesc',
				title: '名称',
				width: 300
			}, {
				field: 'otherPrtDesc',
				title: 'otherPrtDesc',
				width: 300,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		pagination: false,
		columns: columns,
		fitColumns: true,
		toolbar: '#gridDrugGroupBar',
		singleSelect: false,
		onCheck: function (rowIndex, rowData) {
			if (rowData.otherPrtDesc != '') {
				$(this).datagrid('uncheckRow', rowIndex);
				PHA.Popover({
					msg: rowData.sdgDesc + ' 已关联 ' + rowData.otherPrtDesc,
					type: 'alert'
				});
			}
		},
		onSelect: function (rowIndex, rowData) {
			if (rowData.otherPrtDesc != '') {
				$(this).datagrid('unselectRow', rowIndex);
				PHA.Popover({
					msg: rowData.sdgDesc + ' 已关联 ' + rowData.otherPrtDesc,
					type: 'alert'
				});
			}
		},
		onLoadSuccess: function (data) {
			$(this).datagrid('uncheckAll');
			var row0Data = data.rows[0];
			if (row0Data) {
				var rows = $(this).datagrid('getRows');
				var rowsLen = rows.length;
				for (var index = rowsLen - 1; index >= 0; index--) {
					var rowData = rows[index];
					var prti = rowData.prti;
					if (prti != '') {
						$(this).datagrid('checkRow', index);
					}
				}
			}
		}
	};
	PHA.Grid('gridDrugGroup', dataGridOption);
}

function Delete() {
	var gridSelect = $('#gridReqType').datagrid('getSelected') || '';
	if (gridSelect === '') {
		PHA.Popover({
			msg: '请先选中需要删除的记录',
			type: 'alert',
			timeout: 1000
		});
		return;
	}
	PHA.ConfirmPrompt('删除提示', '您正在操作 <span style="color:red;font-weight:bold">删除</span>', function () {
		var rowID = gridSelect.prt || '';
		var rowIndex = $('#gridReqType').datagrid('getRowIndex', gridSelect);
		if (rowID != '') {
			var dataArr = [];
			dataArr.push(rowID);

			var retJson = $.cm({
				ClassName: 'PHA.IP.Data.Api',
				MethodName: 'HandleInAll',
				pClassName: 'PHA.IP.ReqType.Save',
				pMethodName: 'Delete',
				pJsonStr: JSON.stringify(dataArr)
			}, false);
			if (retJson.success === 'false') {
				PHA.Alert('提示', retJson.message, 'warning');
			} else {
				PHA.Popover({
					msg: '删除成功!',
					type: 'success'
				});
				QueryReqType();
			}
		} else {
			$('#gridReqType').datagrid('deleteRow', rowIndex);
		}
		QueryDrugGroup();
	});
}
function Save() {
	var $gridReqType = $('#gridReqType');
	if ($gridReqType.datagrid('endEditing') === false) {
		PHA.Popover({
			msg: '请先完成必填项数据',
			type: 'alert'
		});
		return;
	}
	var gridChanges = $gridReqType.datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		PHA.Popover({
			msg: '没有需要保存的数据',
			type: 'alert'
		});
		return;
	}

	var repeatObj = $gridReqType.datagrid('checkRepeat', [['prtDesc']]);
	if (typeof repeatObj.pos === 'number') {
		PHA.Popover({
			msg: '第' + (repeatObj.pos + 1) + '、' + (repeatObj.repeatPos + 1) + '行:' + repeatObj.titleArr.join('、') + '重复',
			type: 'alert'
		});
		return;
	}

	var dataArr = [];
	for (var i = 0; i < gridChangeLen; i++) {
		var iData = gridChanges[i];
		if ($gridReqType.datagrid('getRowIndex', iData) < 0) {
			continue;
		}
		var iJson = {
			prt: iData.prt,
			prtCode: iData.prtCode,
			prtDesc: iData.prtDesc,
			prtType: iData.prtType,
			prtColor: iData.prtColor,
			loc: iData.loc
		};
		dataArr.push(iJson);
	}
	var retJson = $.cm({
		ClassName: 'PHA.IP.Data.Api',
		MethodName: 'HandleInAll',
		pClassName: 'PHA.IP.ReqType.Save',
		pMethodName: 'SaveHandler',
		pJsonStr: JSON.stringify(dataArr)
	}, false);
	if (retJson.success === 'N') {
		var msg = PHAIP_COM.DataApi.Msg(retJson);
		PHA.Alert('提示', msg, 'warning');
	} else {
		PHA.Popover({
			msg: '保存成功!',
			type: 'success'
		});
		$gridReqType.datagrid('reload');
	}
}

function SaveItm() {
	var $gridReqType = $('#gridReqType');
	var gridReqTypeSelect = $gridReqType.datagrid('getSelected');
	if (gridReqTypeSelect === null) {
		PHA.Popover({
			msg: '请先选择领药类型',
			type: 'alert'
		});
		return;
	}
	var prt = gridReqTypeSelect.prt || '';
	if (prt === '') {
		PHA.Popover({
			msg: '请先保存您选择领药类型',
			type: 'alert'
		});
		return;
	}
	var $gridDrugGroup = $('#gridDrugGroup');
	var gridRows = $gridDrugGroup.datagrid('getRows');
	var gridChecked = $gridDrugGroup.datagrid('getChecked');
	var dataArr = [];
	for (var i = 0; i < gridRows.length; i++) {
		var chkFlag = '';
		var rowData = gridRows[i];
		if (gridChecked.indexOf(rowData) >= 0) {
			chkFlag = 'Y';
		} else {
			chkFlag = 'N';
		}
		var iJson = {
			prt: prt,
			prti: rowData.prti || '',
			sdg: rowData.sdg || '',
			chkFlag: chkFlag
		};
		dataArr.push(iJson);
	}
	var retJson = $.cm({
		ClassName: 'PHA.IP.Data.Api',
		MethodName: 'HandleInAll',
		pClassName: 'PHA.IP.ReqType.Save',
		pMethodName: 'SaveItmHandler',
		pJsonStr: JSON.stringify(dataArr)
	}, false);
	$gridDrugGroup.datagrid('reload');
	
	if (retJson.success === 'N') {
		PHA.Alert('提示', PHAIP_COM.DataApi.Msg(retJson), 'warning');
		return;
	}
	PHA.Popover({
		msg: '保存成功!',
		type: 'success'
	});
}

function QueryReqType() {
	var loc = $('#conPhaLoc').combobox('getValue') || '';
	if (loc === '') {
		PHA.Popover({
			msg: '请先选择药房！',
			type: 'alert'
		});
		$('#gridReqType').datagrid('clear');
		return;
	}
	var pJson = {
		loc: loc
	};
	$('#gridReqType').datagrid('options').url = $URL;
	$('#gridReqType').datagrid('query', {
		ClassName: 'PHA.IP.ReqType.Query',
		QueryName: 'PHAIPReqType',
		rows: 9999,
		pJsonStr: JSON.stringify(pJson)
	});
}

function QueryDrugGroup() {
	var gridSelect = $('#gridReqType').datagrid('getSelected');
	var prt = '';
	if (gridSelect != null) {
		prt = gridSelect.prt || '';
	}
	var pJson = {
		prt: prt,
		hosp: session['LOGON.HOSPID']
	};
	$('#gridDrugGroup').datagrid('options').url = $URL;
	$('#gridDrugGroup').datagrid('query', {
		ClassName: 'PHA.IP.ReqType.Query',
		QueryName: 'DHCStkDrugGroup',
		rows: 9999,
		pJsonStr: JSON.stringify(pJson)
	});
}

// 显示帮助信息
function ShowHelp(){
	var winId = "helpWin";
	var winContentId = winId + "_" + "content";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: 400,
			height: 390,
			modal: true,
			title: '参考背景色',
			iconCls: 'icon-w-list',
			content: "<div id='" + winContentId + "'style='margin:10px;'></div>",
			closable: true
		});
		$('#' + winContentId).width($('#' + winContentId).parent().width() - 20);
		$('#' + winContentId).height($('#' + winContentId).parent().height() - 20);
		
		var colorArr = ['#F24F4B', '#FF9751', '#F1C516', '#2AC665', '#10B2C8', '#1044C8', '#A849CB', '#6557D3'];
		var helpHtml = '';
		helpHtml += '<table style="margin-left:100px;">';
		for (var i = 0; i < colorArr.length; i++) {
			var iColor = colorArr[i];
			helpHtml += '<tr style="height:40px;">';
			helpHtml += '<td><div style="background-color:' + iColor + ';height:30px;width:80px;border-radius:4px;">' + '&nbsp;' + '</div><td>';
			helpHtml += '<td>' + '&nbsp;&nbsp; ' + iColor +  '<td>';
			helpHtml += '</tr>';
		}
		helpHtml += '</table>';
		$('#' + winContentId).html(helpHtml);
	}
	$('#' + winId).dialog('open');
}