/// Creator:      EH
/// CreatDate:    2021-09-01
/// Description:  移动护理病历 8.5
/// start -> assigned -> loc -> waiting -> hosp -> waited

/// 初始化
var init = function() {
	Object.assign(GV, {
		_ASSIGNED: true
	});
	Object.assign($HUI.locpanel(), {
		onSelect: function() {
			filterGridOnFindClick();
			folderGridOnFindClick();
		}
	});
	$.waitUntil('GV._HOSPID', function() {
	    initPageDom();
		initEvent();
	});
	$(window).resize(resizePanel);
	resizePanel();
};
$(init);

function resizePanel() {
	var centerPanel = $('#filterPanel').parent().parent();
	var centerHeight = centerPanel.height() / 3;
	centerPanel.layout('panel', 'north').panel('resize', { height: centerHeight });
	centerPanel.layout('panel', 'south').panel('resize', { height: centerHeight });
	centerPanel.layout('resize');
}
function initEvent() {
	/// 1.科室列表
	/// 2.筛选列表
	$('#filterGridSaveBtn').bind('click', filterGridOnSaveClick);
	$('#filterGridAddBtn').bind('click', filterGridOnAddClick);
	$('#filterGridDeleteBtn').bind('click', filterGridOnDeleteClick)
	/// 4.目录列表
	$('#folderGridSaveBtn').bind('click', folderGridOnSaveClick);
	$('#folderGridAddBtn').bind('click', folderGridOnAddClick);
	$('#folderGridDeleteBtn').bind('click', folderGridOnDeleteClick)
	/// 3.模板列表
	$('#templateGridSaveBtn').bind('click', templateGridOnSaveClick);
	$('#templateGridAddBtn').bind('click', templateGridOnAddClick);
	$('#templateGridDeleteBtn').bind('click', templateGridOnDeleteClick)
}
function initPageDom() {
	/// 1.科室列表
	/// 2.筛选列表
	$HUI.datagrid('#filterGrid', {
		url: '',
		columns: [[
			{ field: 'code', title: '模板代码', width: 200, editor: getTextEditor(false, true) },
			{ field: 'name', title: '模板名称', width: 200, editor: getTextEditor(false, true) },
			{ field: 'activeFlag', title: '是否启用', width: 100, formatter: getBoxFormatter('flag'),
		        editor: getBoxEditor('flag')
		    },
		    { field: 'sort', title: '显示顺序', width: 100, editor: getTextEditor() },
		    { field: 'ID', title: 'ID', width: 100, hidden: true }
		]],
		fitColumns: false,
		idField: 'code',
		singleSelect: true,
		onDblClickRow: gridOnDblClickRow('filterGrid'),
		onBeforeLoad: function(param) {
			GV['_FilterLoad'] = false;
		},
		onLoadSuccess: function(data) {
			var rows = data.rows;
			var options = $('#templateGrid').datagrid('options');
			var column = options.columns[0][1];
			if (GV['_FilterData'] != rows) {
				column.formatter = getBoxFormatter(rows, false);
				column.editor = getBoxEditor(rows, false, true);
				GV['_FilterData'] = rows;
				GV['_FilterLoad'] = true;
				if (GV['_FilterData'] && GV['_FolderLoad']) {
					setTimeout(templateGridOnFindClick, 0);
				}
			}
		}
	});
	/// 4.目录列表
	$HUI.datagrid('#folderGrid', {
		url: '',
		columns: [[
			{ field: 'code', title: '目录代码', width: 200, editor: getTextEditor(false, true) },
			{ field: 'name', title: '目录名称', width: 200, editor: getTextEditor(false, true) },
			{ field: 'activeFlag', title: '是否启用', width: 100, formatter: getBoxFormatter('flag'),
		        editor: getBoxEditor('flag')
		    },
		    { field: 'sort', title: '显示顺序', width: 100, editor: getTextEditor() },
		    { field: 'ID', title: 'ID', width: 100, hidden: true }
		]],
		fitColumns: false,
		idField: 'code',
		singleSelect: true,
		onDblClickRow: gridOnDblClickRow('folderGrid'),
		onBeforeLoad: function(param) {
			GV['_FolderLoad'] = false;
		},
		onLoadSuccess: function(data) {
			var rows = data.rows;
			var options = $('#templateGrid').datagrid('options');
			var column = options.columns[0][0];
			if (GV['_FolderData'] != rows) {
				column.formatter = getBoxFormatter(rows, false);
				column.editor = getBoxEditor(rows, false, true);
				GV['_FolderData'] = rows;
				GV['_FolderLoad'] = true;
				if (GV['_FilterData'] && GV['_FolderLoad']) {
					setTimeout(templateGridOnFindClick, 0);
				}
			}
		}
	});
	/// 3.模块列表
	$HUI.datagrid('#templateGrid', {
		url: '',
		columns: [[
			{ field: 'folderCode', title: '目录', width: 120, formatter: getBoxFormatter([], false),
		        editor: getBoxEditor([], false, true)
		    },
			{ field: 'filterCode', title: '模板', width: 120, formatter: getBoxFormatter([], false),
		        editor: getBoxEditor([], false, true)
		    },
			{ field: 'name', title: '显示名称', width: 120, editor: getTextEditor() },
		    { field: 'ID', title: 'ID', width: 100, hidden: true },
		    { field: 'dateItem', title: '日期字段', width: 120, editor: getTextEditor() },
		    { field: 'timeItem', title: '时间字段', width: 120, editor: getTextEditor() },
		    { field: 'valueItem', title: '分值字段', width: 120, editor: getTextEditor() },
		    { field: 'userItem', title: '用户字段', width: 120, editor: getTextEditor() }
		]],
		fitColumns: false,
		idField: 'code',
		singleSelect: true,
		onDblClickRow: gridOnDblClickRow('templateGrid')
	});
}
/// 1.科室列表
/// 2.筛选列表
function filterGridOnFindClick() {
	return gridOnFindClick('filterGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function() {
		return getParams(['hospID', 'locID'], 'FindFilter');
	})();
}
function filterGridOnSaveClick() {
	return gridOnSaveClick('filterGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function(row) {
		return getParams(['dataType', 'hospID', 'locID', 'code', 'name', 'activeFlag', 'sort'], null, 'SaveFilter', null, row);
	}, filterGridOnFindClick)();
}
function filterGridOnAddClick() {
	if (getNullFlag() == 'Y') { return false; }
	return gridOnAddClick('filterGrid');
}
function filterGridOnDeleteClick() {
	return gridOnDeleteClick('filterGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function(row) {
		return getParams(['dataType', 'hospID', 'locID', 'code', 'ID'], null, 'DeleteFilter', null, row);
	}, filterGridOnFindClick)();
}
/// 4.目录列表
function folderGridOnFindClick() {
	return gridOnFindClick('folderGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function() {
		return getParams(['hospID', 'locID'], 'FindFolder');
	})();
}
function folderGridOnSaveClick() {
	return gridOnSaveClick('folderGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function(row) {
		return getParams(['dataType', 'hospID', 'locID', 'code', 'name', 'activeFlag', 'sort'], null, 'SaveFolder', null, row);
	}, folderGridOnFindClick)();
}
function folderGridOnAddClick() {
	if (getNullFlag() == 'Y') { return false; }
	return gridOnAddClick('folderGrid');
}
function folderGridOnDeleteClick() {
	return gridOnDeleteClick('folderGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function(row) {
		return getParams(['dataType', 'hospID', 'locID', 'code', 'ID'], null, 'DeleteFolder', null, row);
	}, folderGridOnFindClick)();
}
/// 4.目录列表
function templateGridOnFindClick() {
	return gridOnFindClick('templateGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function() {
		return getParams(['hospID', 'locID'], 'FindTemplate');
	})();
}
function templateGridOnSaveClick() {
	return gridOnSaveClick('templateGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function(row) {
		return getParams(['dataType', 'hospID', 'locID', 'filterCode', 'folderCode', 'name'
			, 'dateItem', 'timeItem', 'valueItem', 'userItem'
			], null, 'SaveTemplate', null, row);
	}, templateGridOnFindClick)();
}
function templateGridOnAddClick() {
	if (getNullFlag() == 'Y') { return false; }
	return gridOnAddClick('templateGrid');
}
function templateGridOnDeleteClick() {
	return gridOnDeleteClick('templateGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function(row) {
		return getParams(['dataType', 'hospID', 'locID', 'filterCode', 'folderCode', 'ID'], null, 'DeleteTemplate', null, row);
	}, templateGridOnFindClick)();
}
