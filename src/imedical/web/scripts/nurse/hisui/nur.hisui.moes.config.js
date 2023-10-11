/// Creator:      EH
/// CreatDate:    2021-04-09
/// Description:  门急诊输液设置 8.5
/// start -> assigned -> loc -> waiting -> hosp -> setting -> waiting -> waited

/// 初始化
var init = function() {
	Object.assign(GV, {
		_CLASSNAME: 'Nur.HISUI.MOES.Config',
		_MAINTABLE: 'CF_NUR_MOES.MainModule',
		_LOCTYPE: 'E,OR',
		_ASSIGNED: true
	});
	Object.assign($HUI.locpanel(), {
		onSelect: function() {
			moduleGridOnFindClick();
			windowGridOnFindClick();
			$HUI.settingpanel().find();
		}
	});
	$.waitUntil('GV._HOSPID', function() {
	    initPageDom();
		initEvent();
	});
};
$(init);

function initEvent() {
	/// 1.科室列表
	/// 2.模块列表
	$('#moduleGridSaveBtn').bind('click', moduleGridOnSaveClick);
	/// 3.窗口列表
	$('#windowGridSaveBtn').bind('click', windowGridOnSaveClick);
	/// 4.全局设置
	/// 4.6.升级设置
}
function initPageDom() {
	/// 1.科室列表
	/// 2.模块列表
	$HUI.datagrid('#moduleGrid', {
		url: '',
		columns: [[
			{ field: 'code', title: '模块代码', width: 120 },
			{ field: 'name', title: '模块名称', width: 120, editor: getTextEditor() },
			{ field: 'activeFlag', title: '是否启用', width: 100, formatter: getBoxFormatter('flag'),
		        editor: getBoxEditor('flag')
		    },
		    { field: 'sort', title: '显示顺序', width: 100, editor: getTextEditor() },
		    { field: 'image', title: '图标', width: 180, editor: getTextEditor() }
		]],
		fitColumns: false,
		idField: 'code',
		singleSelect: true,
		onDblClickRow: gridOnDblClickRow('moduleGrid')
	});
	/// 3.窗口列表
	$HUI.datagrid('#windowGrid', {
		url: '',
		columns: [[
			{ field: 'code', title: '窗口代码', width: 120 },
			{ field: 'name', title: '窗口名称', width: 120, editor: getTextEditor() },
			{ field: 'activeFlag', title: '是否启用', width: 100, formatter: getBoxFormatter('flag'),
		        editor: getBoxEditor('flag')
		    },
		    { field: 'sort', title: '显示顺序', width: 100, editor: getTextEditor() }
		]],
		fitColumns: false,
		idField: 'code',
		singleSelect: true,
		onDblClickRow: gridOnDblClickRow('windowGrid')
	});
	/// 4.全局设置
	getData({
			MethodName: 'Init',
			dataType: 'text'
		}, function(init) {
		$HUI.settingpanel().create();
	});
}
/// 1.科室列表
/// 2.模块列表
function moduleGridOnFindClick() {
	return gridOnFindClick('moduleGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function() {
		return getParams(['hospID', 'locID'], 'FindModule');
	})();
}
function moduleGridOnSaveClick() {
	return gridOnSaveClick('moduleGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function(row) {
		return getParams(['hospID', 'locID', 'code', 'name', 'activeFlag', 'sort'], null, 'SaveModule', null, row);
	})();
}
/// 3.窗口列表
function windowGridOnFindClick() {
	return gridOnFindClick('windowGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function() {
		return getParams(['hospID', 'locID'], 'FindWindow');
	})();
}
function windowGridOnSaveClick() {
	return gridOnSaveClick('windowGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function(row) {
		return getParams(['hospID', 'locID', 'code', 'name', 'activeFlag', 'sort'], null, 'SaveWindow', null, row);
	})();
}
/// 4.全局设置
/// 4.5.输液备注
function INVTextClick() {
	$('#INVTextPop').window('open');
	/// window需要先open，否则滚动条有问题
	$HUI.datagrid('#INVTextGrid', {
		url: '',
		columns: [[
			{ field: 'INVTextType', title: '文本类型', width: 100, formatter: getBoxFormatter(GV['_OtherSets']['INVTextType']),
				editor: getBoxEditor(GV['_OtherSets']['INVTextType'])
			},
			{ field: 'INVTextCode', title: '文本代码', width: 140, editor: getTextEditor() },
			{ field: 'INVTextName', title: '文本名称', width: 140, editor: getTextEditor() },
			{ field: 'activeFlag', title: '是否启用', width: 100, formatter: getBoxFormatter('flag', true),
		        editor: getBoxEditor('flag', true)
		    },
		    { field: 'sort', title: '显示顺序', width: 100, editor: getTextEditor() },
		    { field: 'ID', title: 'ID', width: 50, hidden: true }
		]],
		fitColumns: false,
		idField: 'ID',
		singleSelect: true,
		onDblClickRow: gridOnDblClickRow('INVTextGrid'),
		onBeginEdit: cellPinyinEdit('INVTextGrid', 1, 2)
	});
}
function INVTextGridOnAddClick() {
	return gridOnAddClick('INVTextGrid');
}
