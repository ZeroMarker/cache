/// Creator:      EH
/// CreatDate:    2021-04-09
/// Description:  �ż�����Һ���� 8.5
/// start -> assigned -> loc -> waiting -> hosp -> setting -> waiting -> waited

/// ��ʼ��
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
	/// 1.�����б�
	/// 2.ģ���б�
	$('#moduleGridSaveBtn').bind('click', moduleGridOnSaveClick);
	/// 3.�����б�
	$('#windowGridSaveBtn').bind('click', windowGridOnSaveClick);
	/// 4.ȫ������
	/// 4.6.��������
}
function initPageDom() {
	/// 1.�����б�
	/// 2.ģ���б�
	$HUI.datagrid('#moduleGrid', {
		url: '',
		columns: [[
			{ field: 'code', title: 'ģ�����', width: 120 },
			{ field: 'name', title: 'ģ������', width: 120, editor: getTextEditor() },
			{ field: 'activeFlag', title: '�Ƿ�����', width: 100, formatter: getBoxFormatter('flag'),
		        editor: getBoxEditor('flag')
		    },
		    { field: 'sort', title: '��ʾ˳��', width: 100, editor: getTextEditor() },
		    { field: 'image', title: 'ͼ��', width: 180, editor: getTextEditor() }
		]],
		fitColumns: false,
		idField: 'code',
		singleSelect: true,
		onDblClickRow: gridOnDblClickRow('moduleGrid')
	});
	/// 3.�����б�
	$HUI.datagrid('#windowGrid', {
		url: '',
		columns: [[
			{ field: 'code', title: '���ڴ���', width: 120 },
			{ field: 'name', title: '��������', width: 120, editor: getTextEditor() },
			{ field: 'activeFlag', title: '�Ƿ�����', width: 100, formatter: getBoxFormatter('flag'),
		        editor: getBoxEditor('flag')
		    },
		    { field: 'sort', title: '��ʾ˳��', width: 100, editor: getTextEditor() }
		]],
		fitColumns: false,
		idField: 'code',
		singleSelect: true,
		onDblClickRow: gridOnDblClickRow('windowGrid')
	});
	/// 4.ȫ������
	getData({
			MethodName: 'Init',
			dataType: 'text'
		}, function(init) {
		$HUI.settingpanel().create();
	});
}
/// 1.�����б�
/// 2.ģ���б�
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
/// 3.�����б�
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
/// 4.ȫ������
/// 4.5.��Һ��ע
function INVTextClick() {
	$('#INVTextPop').window('open');
	/// window��Ҫ��open�����������������
	$HUI.datagrid('#INVTextGrid', {
		url: '',
		columns: [[
			{ field: 'INVTextType', title: '�ı�����', width: 100, formatter: getBoxFormatter(GV['_OtherSets']['INVTextType']),
				editor: getBoxEditor(GV['_OtherSets']['INVTextType'])
			},
			{ field: 'INVTextCode', title: '�ı�����', width: 140, editor: getTextEditor() },
			{ field: 'INVTextName', title: '�ı�����', width: 140, editor: getTextEditor() },
			{ field: 'activeFlag', title: '�Ƿ�����', width: 100, formatter: getBoxFormatter('flag', true),
		        editor: getBoxEditor('flag', true)
		    },
		    { field: 'sort', title: '��ʾ˳��', width: 100, editor: getTextEditor() },
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
