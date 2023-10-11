/// Creator:      EH
/// CreatDate:    2021-04-09
/// Description:  �ƶ��������� 8.5
/// start -> assigned -> loc -> waiting -> hosp -> setting -> waiting -> waited

/// ��ʼ��
var init = function() {
	Object.assign(GV, {
		_SettingFromCSP: true,
		_ASSIGNED: true
	});
	Object.assign($HUI.locpanel(), {
		onSelect: function() {
			messageGridOnFindClick();
			IVDInsertOrderFlag();
			$HUI.settingpanel().find();
			blockGridOnFindClick();
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
	var centerPanel = $('#blockGrid').parent().parent().parent().parent().parent().parent();
	var blockHeight = centerPanel.height()/3;
	centerPanel.layout('panel', 'north').panel('resize', { height: blockHeight });
	centerPanel.layout('panel', 'south').panel('resize', { height: blockHeight });
	centerPanel.layout('resize');
}
function initEvent() {
	/// 1.�����б�
	/// 2.ģ���б�
	$('#moduleGridSaveBtn').bind('click', moduleGridOnSaveClick);
	/// 3.��Ϣ�б�
	$('#messageGridSaveBtn').bind('click', messageGridOnSaveClick);
	/// 4.ȫ������
	/// 4.5.���Ӵ���
	$('#barcodeLinkBtn').bind('click', barcodeLinkOnClick);
	$('#upgradeLinkBtn').bind('click', upgradeLinkOnClick);
	$('#nuremrLinkBtn').bind('click', nuremrLinkOnClick);
	$('#insertemrLinkBtn').bind('click', insertemrLinkOnClick);
	$('#standardizationLinkBtn').bind('click', standardizationLinkOnClick);
	$('#bloodTransfusionSystemLinkBtn').bind('click', bloodTransfusionSystemLinkOnClick);
	$('#patientsHandoverSystemLinkBtn').bind('click', patientsHandoverSystemLinkOnClick);
	/// 5.�ֿ��б�
	$('#blockGridSaveBtn').bind('click', blockGridOnSaveClick);
	$('#blockGridAddBtn').bind('click', blockGridOnAddClick);
	$('#blockGridDeleteBtn').bind('click', blockGridOnDeleteClick);
}
function initPageDom() {
	/// 1.�����б�
	/// 2.ģ���б�
	$HUI.datagrid('#moduleGrid', {
		url: '',
		columns: [[
			{ field: 'code', title: 'ģ�����', width: 180 },
			{ field: 'name', title: 'ģ������', width: 120, editor: getTextEditor() },
			{ field: 'activeFlag', title: '�Ƿ�����', width: 100, formatter: getBoxFormatter('flag'),
		        editor: getBoxEditor('flag')
		    },
		    { field: 'sort', title: '��ʾ˳��', width: 100, editor: getTextEditor() },
		    { field: 'blockCode', title: '�ֿ�����', width: 100, formatter: getBoxFormatter([], true),
		        editor: getBoxEditor([], true)
		    }
		]],
		fitColumns: false,
		idField: 'code',
		singleSelect: true,
		onDblClickRow: gridOnDblClickRow('moduleGrid')
	});
	/// 3.��Ϣ�б�
	$HUI.datagrid('#messageGrid', {
		url: '',
		columns: [[
			{ field: 'code', title: '��Ϣ����', width: 100 },
			{ field: 'name', title: '��Ϣ����', width: 100, editor: getTextEditor() },
			{ field: 'activeFlag', title: '�Ƿ�����', width: 80, formatter: getBoxFormatter('flag'),
		        editor: getBoxEditor('flag')
		    },
		    { field: 'sort', title: '��ʾ˳��', width: 80, editor: getTextEditor() },
		    { field: 'remindFlag', title: '�Ƿ���ʾ', width: 80, formatter: getBoxFormatter('flag', true),
		        editor: getBoxEditor('flag', true)
		    },
		    { field: 'soundFlag', title: '��������', width: 80, formatter: getBoxFormatter('flag', true),
		        editor: getBoxEditor('flag', true)
		    },
		    { field: 'vibrateFlag', title: '������', width: 80, formatter: getBoxFormatter('flag', true),
		        editor: getBoxEditor('flag', true)
		    },
		    { field: 'toModule', title: '��ת����', width: 150, editor: {
				type: 'combobox',
				options: {
					panelWidth: 150,
					valueField: 'code',
					idField: 'code',
					textField: 'name',
					mode: 'remote',
					url: $URL + '?q=1&ClassName=' + GV._CLASSNAME + '&QueryName=FindToModule&ResultSetType=array&hospID=' + getHospID(),
					formatter: function(row) {
						return '<div style="display:flex;margin:-3px 0px -3px -5px"><div style="width:120px;border-right:#ddd 1px solid;border-bottom:#ddd 1px solid;padding:3px 0px 3px 5px">' + row.name + '</div></div>';
					}
				}
			}, formatter: function(value, row, index) {
				return getData(getParams(['ClassName', 'dataType', 'configFlag', 'hospID', 'locID'], null, 'GetToModuleName', { code: value }), false);
			} },
		    { field: 'sheetCode', title: '��ת����', width: 230, editor: {
				type: 'combobox',
				options: {
					panelWidth: 230,
					valueField: 'code',
					idField: 'code',
					textField: 'name',
					mode: 'remote',
					url: $URL + '?q=1&ClassName=' + GV._CLASSNAME + '&QueryName=FindSheet&ResultSetType=array&hospID=' + getHospID(),
					formatter: function(row) {
						return '<div style="display:flex;margin:-3px 0px -3px -5px"><div style="width:100px;border-right:#ddd 1px solid;border-bottom:#ddd 1px solid;padding:3px 0px 3px 5px">' + row.code + '</div><div style="width:100px;border-right:#ddd 1px solid;border-bottom:#ddd 1px solid;padding:3px 0px 3px 5px">' + row.name + '</div></div>';
					}
				}
			}, formatter: function(value, row, index) {
				return getData(getParams(['ClassName', 'dataType', 'configFlag', 'hospID', 'locID'], null, 'GetSheetName', { code: value }), false);
			} },
		    { field: 'notifyType', title: '��ʾ��ʽ', width: 100, editor: getEditor('box'
		    	,[{ value: 1, desc: '֪ͨ��' }, { value: 2, desc: '����' }]
		    	, true, false
		    	), formatter: getBoxDataFormatter('messageGrid', 9) },
		    { field: 'listType', title: 'չʾ��ʽ', width: 100, editor: getEditor('box'
		    	,[{ value: 'list', desc: '�б�' }, { value: 'grid', desc: '����' }]
		    	, true, false
		    	), formatter: getBoxDataFormatter('messageGrid', 10) },
		    { field: 'closeFlag', title: '�Ƿ�չ��', width: 100, formatter: getBoxFormatter('flag', true),
		        editor: getBoxEditor('flag', true)
		    }
		]],
		fitColumns: false,
		idField: 'code',
		singleSelect: true,
		onDblClickRow: gridOnDblClickRow('messageGrid')
	});
	/// 4.ȫ������
	$('#IVDInsertOrderFlag\\.1').combobox({
	    valueField: 'ID',
		textField: 'name',
	    defaultFilter: 4,
	    panelWidth: 'auto',
		onShowPanel: function() {
			var panel = $(this).combobox('panel');
			panel.css('display', 'inline-block');
			var maxHeight = parseInt($(this).combobox('options').panelMaxHeight);
			if (panel.height() > maxHeight) {
				panel.height(maxHeight);
			}
		}
	});
	$('#IVCInsertOrderFlag\\.1').combobox({
	    valueField: 'ID',
		textField: 'name',
	    defaultFilter: 4,
	    panelWidth: 'auto',
		onShowPanel: function() {
			var panel = $(this).combobox('panel');
			panel.css('display', 'inline-block');
			var maxHeight = parseInt($(this).combobox('options').panelMaxHeight);
			if (panel.height() > maxHeight) {
				panel.height(maxHeight);
			}
		}
	});
	/// 5.ģ���б�
	$HUI.datagrid('#blockGrid', {
		url: '',
		columns: [[
			{ field: 'code', title: '�ֿ����', width: 150, editor: getTextEditor(false, true) },
			{ field: 'name', title: '�ֿ�����', width: 100, editor: getTextEditor(false, true) },
			{ field: 'activeFlag', title: '�Ƿ�����', width: 100, formatter: getBoxFormatter('flag'),
		        editor: getBoxEditor('flag')
		    },
		    { field: 'sort', title: '��ʾ˳��', width: 100, editor: getTextEditor() },
		    { field: 'levelCode', title: '�ֿ鼶��', width: 100, hidden: true },
		    { field: 'ID', title: 'ID', width: 100, hidden: true }
		]],
		fitColumns: false,
		idField: 'code',
		singleSelect: true,
		onDblClickRow: gridOnDblClickRow('blockGrid'),
		onLoadSuccess: function(data) {
			var rows = data.rows;
			var options = $('#moduleGrid').datagrid('options');
			var column = options.columns[0][4];
			if (GV['_BlockData'] != rows) {
				column.formatter = getBoxFormatter(rows, true);
				column.editor = getBoxEditor(rows, true);
				GV['_BlockData'] = rows;
			}
		}
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
		return getParams(['dataType', 'hospID', 'locID', 'code', 'name', 'activeFlag', 'sort', 'blockCode'], null, 'SaveModule', null, row);
	})();
}
/// 3.��Ϣ�б�
function messageGridOnFindClick() {
	return gridOnFindClick('messageGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function() {
		return getParams(['hospID', 'locID'], 'FindMessage');
	})();
}
function messageGridOnSaveClick() {
	return gridOnSaveClick('messageGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function(row) {
		return getParams(['dataType', 'hospID', 'locID', 'code', 'name', 'activeFlag', 'sort', 'remindFlag', 'soundFlag', 'vibrateFlag', 'toModule', 'sheetCode', 'notifyType', 'listType', 'closeFlag'], null, 'SaveMessage', null, row);
	})();
}
/// 4.ȫ������
/// 4.4.��Һ��ע
function INVTextClick() {
	$('#INVTextPop').window('open');
	$('#INVTextGridAddBtn').bind('click', INVTextGridOnAddClick);
	/// window��Ҫ��open�����������������
	$HUI.datagrid('#INVTextGrid', {
		url: '',
		columns: [[
			{ field: 'INVTextType', title: '�ı�����', width: 100, formatter: getBoxFormatter(GV['GlobalSetting']['INVTextType']),
				editor: getBoxEditor(GV['GlobalSetting']['INVTextType'])
			},
			{ field: 'INVTextCode', title: '�ı�����', width: 140, editor: getTextEditor() },
			{ field: 'INVTextName', title: '�ı�����', width: 140, editor: getTextEditor() },
			{ field: 'showFlag', title: '�Ƿ�����', width: 100, formatter: getBoxFormatter('flag', true),
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
function IVDInsertOrderFlag() {
	getData(getParams(['ClassName', 'ResultSetType', 'configFlag', 'hospID'], 'FindArcim', null, {
		type: '!R,L,X,M,P'
	}), function(data) {
		$('#IVDInsertOrderFlag\\.1').combobox('loadData', data);
		$('#IVCInsertOrderFlag\\.1').combobox('loadData', data);
	});
}
function INVTextGridOnAddClick() {
	return gridOnAddClick('INVTextGrid');
}
/// 4.5.���Ӵ���
function linkPopOpenDialog(id, csp, hosp, loc, fn) {
	var win = $('#linkPop').window({
		title: getButtonText(id),
		iconCls: getButtonIconCls(id),
		width: document.body.offsetWidth - 120,
		height: document.body.offsetHeight - 20,
		onBeforeClose: fn
	}).window('center').window('open');
	var iframe = document.getElementById('linkPopFrame');
	var url = csp;
	if (hosp) {
		var add = url.indexOf('?') == -1 ? '?' : '&';
		url += add + 'SelectHospID=' + getHospID();
	}
	if (loc) {
		var add = url.indexOf('?') == -1 ? '?' : '&';
		url += add + 'SelectLocID=' + getLocID();
	}
	iframe.src = url;
	return win;
}
function barcodeLinkOnClick() {
	linkPopOpenDialog('barcodeLinkBtn', 'nur.hisui.mnis.config.barcode.csp', true);
}
function upgradeLinkOnClick() {
	linkPopOpenDialog('upgradeLinkBtn', 'nur.hisui.mnis.config.upgrade.csp', true);
}
function nuremrLinkOnClick() {
	linkPopOpenDialog('nuremrLinkBtn', 'nur.hisui.mnis.config.nuremr.csp', true, true);
}
function insertemrLinkOnClick() {
	linkPopOpenDialog('insertemrLinkBtn', 'nur.hisui.mnis.config.insertemr.csp', true, true);
}
function standardizationLinkOnClick() {
	linkPopOpenDialog('standardizationLinkBtn', 'nur.hisui.mnis.config.standardization.csp', false, false, function() {
		$HUI.settingpanel().createStandardizationDomAndFind();
	});
}
function bloodTransfusionSystemLinkOnClick() {
	linkPopOpenDialog('bloodTransfusionSystemLinkBtn', 'nur.hisui.mnis.h8d5p.config.csp?menu=business%2Fmenu%2Fblood%20transfusion%20system*%5Bendpoint%3Dentry%2Creference%3Dcatalog%7Ctab%5D', true, true);
}
function patientsHandoverSystemLinkOnClick() {
	linkPopOpenDialog('patientsHandoverSystemLinkBtn', 'nur.hisui.mnis.h8d5p.config.csp?menu=business%2Fmenu%2Fpatient%20handover%20system*%5Bendpoint%3Dentry%2Creference%3Dcatalog%7Ctab%5D', true, true);
}
/// 5.�ֿ��б�
function blockGridOnFindClick() {
	setTimeout(moduleGridOnFindClick, 100);
	return gridOnFindClick('blockGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function() {
		return getParams(['hospID', 'locID'], 'FindBlock');
	})();
}
function blockGridOnSaveClick() {
	return gridOnSaveClick('blockGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function(row) {
		return getParams(['dataType', 'hospID', 'locID', 'code', 'name', 'activeFlag', 'sort'], null, 'SaveBlock', null, row);
	}, blockGridOnFindClick)();
}
function blockGridOnAddClick() {
	if (getNullFlag() == 'Y') { return false; }
	return gridOnAddClick('blockGrid');
}
function blockGridOnDeleteClick() {
	if (getNullFlag() == 'Y') { return false; }
	$.messager.confirm("��ʾ", "ȷ��ɾ��������¼?", function (r) {
		if (r) {
			return gridOnDeleteClick('blockGrid', null, function(row) {
				return getParams(['dataType', 'hospID', 'locID', 'code', 'ID'], null, 'DeleteBlock', null, row);
			}, blockGridOnFindClick)();
		}
	});
}
