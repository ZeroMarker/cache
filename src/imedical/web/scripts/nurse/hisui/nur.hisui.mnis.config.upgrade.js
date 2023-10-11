/// Creator:      EH
/// CreatDate:    2021-06-17
/// Description:  ��������
/// start -> assigned -> hosp -> waited

/// ��ʼ��
var init = function() {
	Object.assign(GV, {
		_ASSIGNED: true
	});
	Object.assign($HUI.hospbar(), {
		onSelect: function() {
			setTimeout(upgradeGridOnFindClick, 100);
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
	$('#upgradeGridFindBtn').bind('click', upgradeGridOnFindClick);
	$('#upgradeGridSaveBtn').bind('click', upgradeGridOnSaveClick);
	$('#upgradeGridVersionBtn').bind('click', upgradeGridOnVersionClick);
	$('#hospitalWide').switchbox('options').onSwitchChange = hospitalWideOnClick;
}
function initPageDom() {
	/// 1.�����б�
	/// locID,locDesc,lastVersion,version,activeFlag
	$HUI.datagrid('#upgradeGrid', {
		url: '',
		columns: [[
			{ field: 'locID', title: 'locID', width: 50, hidden: true },
			{ field: 'locDesc', title: '��������', width: 300 },
			{ field: 'lastVersion', title: 'ǰһ���汾', width: 150 },
			{ field: 'version', title: '�汾', width: 150, editor: getTextEditor() },
			{ field: 'activeFlag', title: '�Ƿ�����', width: 100, formatter: getBoxFormatter('flag'),
		        editor: getBoxEditor('flag')
		    },
		]],
		fitColumns: false,
		idField: 'locID',
		singleSelect: true,
		onDblClickRow: gridOnDblClickRow('upgradeGrid')
	});
	var bbar = '<div style="margin:10px"><table>';
	bbar += '<tr style="height:28px"><td nowrap=nowrap style="border:none">���ص�ַ��</td><td nowrap=nowrap style="border:none;padding-left:10px"><div style="display:flex">���磺<div style="padding-left:10px"><div>��http://127.0.0.1/dthealth/web/MobileNurse.apk����127.0.0.1��ת����ecp��ַ</div><div>��https://192.168.0.1:57772/dhcmg/MobileNurse.apk�����̶���ַ</div><div>��192.168.0.1��</div></div></td></tr>';
	bbar += '</table></div>';
	$('#upgradeGridBbar').html(bbar);
}
function upgradeGridOnFindClick() {
	var downloadLink = getData(getParams(['dataType', 'hospID'], null, 'DownloadLink'), false);
	$('#downloadLink').val(downloadLink);
	return gridOnFindClick('upgradeGrid', null, function() {
		return getParams(['hospID', 'userType'], 'FindUpgrade', null, {
			type: GV._LOCTYPE
		});
	})();
}
function upgradeGridOnSaveClick() {
	getData(getParams(['dataType', 'hospID'], null, 'SaveDownloadLink', {
		locID: '',
		downloadLink: $('#downloadLink').val()
	}), false);
	return gridOnSaveClick('upgradeGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function(row) {
		return getParams(['dataType', 'hospID', 'locID', 'version', 'activeFlag'], null, 'SaveUpgrade', null, row);
	})();
}
function upgradeGridOnVersionClick() {
	var _grid = $('#upgradeGrid');
	var rows = _grid.datagrid('getRows');
	var version = $('#version').numberbox('getValue');
	for (var i = 0; i < rows.length; i++) {
		gridOnDblClickRow('upgradeGrid')(i);
		var editors = _grid.datagrid('getEditors', i);
		var versionEditor = editors[0].target;
		versionEditor.val(version);
	}
}
function hospitalWideOnClick() {
	var _grid = $('#upgradeGrid');
	var rows = _grid.datagrid('getRows');
	var hospitalWide = $('#hospitalWide').switchbox('getValue');
	var checked = hospitalWide ? 'Y' : 'N';
	for (var i = 0; i < rows.length; i++) {
		gridOnDblClickRow('upgradeGrid')(i);
		var editors = _grid.datagrid('getEditors', i);
		var versionEditor = editors[1].target;
		versionEditor.combobox('setValue',checked);
	}
}
