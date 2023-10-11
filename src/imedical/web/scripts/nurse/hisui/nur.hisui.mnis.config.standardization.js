/// Creator:      EH
/// CreatDate:    2021-06-17
/// Description:  标化设置
/// start -> assigned -> waited

/// 初始化
var init = function() {
	Object.assign(GV, {
		_ASSIGNED: true
	});
	initPageDom();
	initEvent();
	setTimeout(standardizationGridOnFindClick, 0);
};
$(init);

function initEvent() {
	$('#standardizationGridFindBtn').bind('click', standardizationGridOnFindClick);
	$('#standardizationGridSaveBtn').bind('click', standardizationGridOnSaveClick);
	$('#standardizationGridAddBtn').bind('click', standardizationGridOnAddClick);
	$('#standardizationGridAppendBtn').bind('click', standardizationGridOnAppendClick);
	$('#standardizationGridDeleteBtn').bind('click', standardizationGridOnDeleteClick);
}
function initPageDom() {
	var data = [{ id: 'datebox', desc: '日期' }, { id: 'timebox', desc: '时间' }, { id: 'texttime', desc: '天数+时间' }, { id: 'datetime', desc: '日期+时间' }, { id: 'numberbox', desc: '数字' }, { id: 'combobox', desc: '下拉选项' }, { id: 'textbox', desc: '文本' }, { id: 'checkbox', desc: '开关' }];
	$HUI.datagrid('#standardizationGrid', {
		url: '',
		columns: [[
			{ field: 'parref', title: 'parref', hidden: true },
			{ field: 'groupNo', title: '分组', width: 60, editor: getTextEditor(true),formatter: function(value, row, index) {
					var rows = $('#standardizationGrid').datagrid('getRows'), length = rows.length, v = '';
					if (row['groupNo'] != '') {
						if (index < length - 1) {
							var nextRow = rows[index + 1];
							if (row['groupNo'] == nextRow['groupNo']) v = '<div style="display:block;width:20px;height:100%;border-style:solid;border-color:#FF0000;border-width:0 0 0 1px">&nbsp;</div>';
							else v = '<div style="display:block;width:20px;height:50%;border-style:solid;border-color:#FF0000;border-width:0 0 1px 1px">&nbsp;</div>';
						} else v = '<div style="display:block;width:20px;height:50%;border-style:solid;border-color:#FF0000;border-width:0 0 1px 1px">&nbsp;</div>';
					} else {
						if (index < length - 1) {
							var nextRow = rows[index + 1];
							if (row['parref'] == nextRow['groupNo']) v = '<div style="display:block;width:20px;height:50%;border-style:solid;border-color:#FF0000;border-width:1px 0 0 1px">&nbsp;</div>';
						}
					}
					return v;
				} },
			{ field: 'serialNo', title: '序号', width: 60, editor: getTextEditor(true) },
			{ field: 'activeFlag', title: '启用标志', width: 70, formatter: getBoxFormatter('flag'),
		        editor: getBoxEditor('flag')
		    },
		    { field: 'elementID', title: '元素ID', width: 150, formatter: getTextFormatter(true),
		    	editor: getTextEditor(false, true)
		    },
			{ field: 'elementTitle', title: '元素标题', width: 190, formatter: getTextFormatter(true),
				editor: getTextEditor(false, true)
			},
			{ field: 'elementValue', title: '元素值', width: 140, formatter: getTextFormatter(true),
				editor: getTextEditor()
			},
			{ field: 'elementType', title: '元素类型', width: 120, formatter: getBoxFormatter(data, true),
		        editor: getBoxEditor(data, true)
		    },
			{ field: 'elementHTML', title: '元素内容', width: 210, formatter: getTextFormatter(true),
				editor: getTextEditor()
			},
			{ field: 'demandID', title: '需求序号', width: 90, editor: getTextEditor(true), hidden: true  },
			{ field: 'remarks', title: '备注', width: 180, formatter: getTextFormatter(true),
				editor: getTextEditor()
			},
			{ field: 'defaultFlag', title: '默认标志', width: 70, formatter: getBoxFormatter('flag'),
		        editor: getBoxEditor('flag')
		    },
		    { field: 'nullFlag', title: '空白标志', width: 70, formatter: getBoxFormatter('flag'),
		        editor: getBoxEditor('flag')
		    },
			{ field: 'frontEndFlag', title: '前台标志', width: 70, formatter: getBoxFormatter('flag'),
		        editor: getBoxEditor('flag')
		    },
			{ field: 'identificationType', title: '识别类型', width: 200, editor: getTextEditor() },
			{ field: 'identificationCode', title: '识别代码', width: 120, editor: getTextEditor() }
		]],
		fitColumns: false,
		idField: 'code',
		singleSelect: true,
		onDblClickRow: gridOnDblClickRow('standardizationGrid', null, function(index, row) {
			var editor;
			editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'groupNo' });
			$(editor.target).attr('disabled', true);
			editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'defaultFlag' });
			if (row.defaultFlag == 'Y') {
				$(editor.target).combobox('disable');
				editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'elementID' });
				$(editor.target).attr('disabled', true);
				editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'elementTitle' });
				$(editor.target).attr('disabled', true);
				editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'elementType' });
				$(editor.target).combobox('disable');
				editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'demandID' });
				$(editor.target).numberbox('disable');
				editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'nullFlag' });
				$(editor.target).combobox('disable');
				editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'frontEndFlag' });
				$(editor.target).combobox('disable');
				editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'identificationType' });
				$(editor.target).attr('disabled', true);
				editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'identificationCode' });
				$(editor.target).attr('disabled', true);
			}
			if (row.nullFlag != 'Y') {
				editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'elementValue' });
				$(editor.target).validatebox('options').required = true;
			}
		})
	});
}
function standardizationGridOnFindClick() {
	return gridOnFindClick('standardizationGrid', null, function() {
		return getParams([], 'FindStandardization');
	})();
}
function standardizationGridOnSaveClick() {
	return gridOnSaveClick('standardizationGrid', null, function(row) {
		return getParams(['dataType', 'parref', 'serialNo', 'activeFlag', 'defaultFlag', 'nullFlag', 'frontEndFlag', 'identificationType', 'identificationCode', 'elementID', 'elementType', 'elementHTML', 'demandID', 'elementTitle', 'elementValue', 'remarks'], null, 'SaveStandardization', null, row);
	})();
}
function standardizationGridOnAddClick() {
	return gridOnAddClick('standardizationGrid');
}
function standardizationGridOnAppendClick() {
	var selections = $('#standardizationGrid').datagrid('getSelections');
	if (selections.length == 0) {
		$.messager.popover({ msg: '请选择一条记录!', type: 'alert', timeout: 5000 });
		return;
	} else if (!selections[0].parref) {
		$.messager.popover({ msg: '只能选择已有的记录!', type: 'alert', timeout: 5000 });
		return;
	}
	var selection = selections[0], groupNo = selection['groupNo'] || selection['parref'];
	var rows = $('#standardizationGrid').datagrid('getRows'), index;
	for (var i = rows.length - 1; i >= 0; i--) {
		if (groupNo == (rows[i]['groupNo'] || rows[i]['parref'])) {
			index = i;
			break;
		}
	}
	selection = rows[index], index++;
	gridOnAddClick('standardizationGrid', null, index);
	var columns = $('#standardizationGrid').datagrid('options').columns[0], editor, title;
	for (var i = 0; i < columns.length; i++) {
		editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'groupNo' });
		$(editor.target).val(selection['groupNo'] || selection['parref']);
		editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'activeFlag' });
		$(editor.target).combobox('setValue', selection['activeFlag']);
		editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'elementID' });
		title = selection['elementID'];
		var k = title.length - 1;
		for (var j = k; j >= 0; j--) {
			var c = title.charCodeAt(j);
			if (!(c >= 48 && c <= 57)) {
				k = j;
				break;
			}
			if (j == 0) k = -1;
		}
		if (k != title.length - 1) {
			if (k != -1) title = title.substring(0, k + 1);
			else title = '';
		} else if (title.indexOf('_') > -1) {
			var tmp = title.split('_');
			tmp[tmp.length - 1] = '';
			title = tmp.join('-');
		} else title = '';
		$(editor.target).val(title);
		editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'elementTitle' });
		title = selection['elementTitle'];
		if (title.indexOf('-') > -1) {
			var tmp = title.split('-');
			if (tmp[tmp.length - 1] != '项目') tmp[tmp.length - 1] = '';
			title = tmp.join('-');
		} else title = '';
		$(editor.target).val(title);
		editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'elementType' });
		$(editor.target).combobox('setValue', selection['elementType']);
		editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'demandID' });
		$(editor.target).numberbox('setValue', selection['demandID']);
		editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'remarks' });
		$(editor.target).val(selection['remarks']);
		editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'defaultFlag' });
		$(editor.target).combobox('setValue', 'N');
		editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'nullFlag' });
		$(editor.target).combobox('setValue', selection['nullFlag']);
		editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'frontEndFlag' });
		$(editor.target).combobox('setValue', selection['frontEndFlag']);
		editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'identificationType' });
		$(editor.target).val(selection['identificationType']);
		editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'identificationCode' });
		$(editor.target).val(selection['identificationCode']);
		editor = $('#standardizationGrid').datagrid('getEditor', { 'index': index, field: 'elementID' });
		$(editor.target).focus();
	}
	$('#standardizationGrid').datagrid('validateRow', index);
}
function standardizationGridOnDeleteClick() {
	var msg = '', selectedRows = $('#standardizationGrid').datagrid('getSelections');
    selectedRows.forEach(function(row) {
	    if (row.defaultFlag == 'Y') {
			msg = '不能删除默认记录!';
			return;
		}
    });
    if (msg != '') {
		$.messager.popover({ msg: msg, type: 'alert', timeout: 5000 });
		return;
	}
	$.messager.confirm("提示", "确定删除该条记录?", function (r) {
		if (r) {
			return gridOnDeleteClick('standardizationGrid', null, function(row) {
				return getParams(['dataType', 'parref'], null, 'DeleteStandardization', null, row);
			})();
		}
	});
}
