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
			barcodeGridSheetData();
			barcodeGridOnFindClick();
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
	$('#barcodeGridFindBtn').bind('click', barcodeGridOnFindClick);
	$('#barcodeGridSaveBtn').bind('click', barcodeGridOnSaveClick);
}
function initPageDom() {
	/// 1.�����б�
	/// code,name,prefix,symbol,length,fn,sheetID,comment
	$HUI.datagrid('#barcodeGrid', {
		url: '',
		columns: [[
			{ field: 'code', title: '����', width: 100 },
			{ field: 'name', title: '����', width: 100 },
			{ field: 'prefix', title: '����ǰ׺', width: 100, editor: getTextEditor() },
			{ field: 'symbol', title: '�����־', width: 100, editor: getTextEditor() },
			{ field: 'digit', title: '�ı�����', width: 100, editor: {
				type: 'numberbox',
				options: {
					min: 0,
					max: 255
				}
			} },
			{ field: 'fn', title: 'У�鷽��', width: 300, editor: getTextEditor() },
			{ field: 'sheetID', title: '��������', width: 230 ,editor: getTextEditor(), formatter: function(value, row, index) {
				var div = '';
				var split = (value || '').split(',');
			    var data = GV['_SheetData'] || [];
			    for (var i = 0; i < split.length; i++) {
				    var text = split[i];
					for (var j = 0; j < data.length; j++) {
						if (data[j].ID == split[i]) {
							text = data[j].name;
							break;
						}
					}
					div += (div != '') ? ',' : '';
					div += text;
				}
				return div;
			} },
			{ field: 'conversion', title: 'ת������', width: 300, editor: getTextEditor() },
			{ field: 'comment', title: 'ע��', width: 240, editor: getTextEditor() },
		]],
		fitColumns: false,
		idField: 'code',
		singleSelect: true,
		onDblClickRow: gridOnDblClickRow('barcodeGrid', null, function(index, row) {
			if (['LAB', 'MED', 'INF', 'INJ'].indexOf(String(row.code)) == -1) {
				var editor = $('#barcodeGrid').datagrid('getEditor', { 'index': index, field: 'sheetID' });
				$(editor.target).combobox('disable');
			}
		})
	});
	var bbar = '<div style="margin:10px"><table>';
	bbar += '<tr style="height:28px"><td nowrap=nowrap style="border:none">����ǰ׺��</td><td nowrap=nowrap style="border:none;padding-left:10px"><div style="display:flex">���磺<div style="padding-left:10px">��MED����REG�����ᱻȥ��</div></div></td></tr>';
	bbar += '<tr style="height:28px"><td nowrap=nowrap style="border:none">�����־��</td><td nowrap=nowrap style="border:none;padding-left:10px"><div style="display:flex">���磺<div style="padding-left:10px">��=<����-����!�������ᱻȥ��</div></div></td></tr>';
	bbar += '<tr style="height:28px"><td nowrap=nowrap style="border:none">�ı����ȣ�</td><td nowrap=nowrap style="border:none;padding-left:10px">�������ͼ�������λ����ͬ���޷���Ϊ��������</td></tr>';
	bbar += '<tr style="height:28px"><td nowrap=nowrap style="border:none">У�鷽����</td><td nowrap=nowrap style="border:none;padding-left:10px"><div style="display:flex">���磺<div style="padding-left:10px"><div style="height:25px;display:flex"><div style="width:128px">�����š�</div>��$o(^SSU(""SSUSR"",0,""SSUSR_Initials"",$$ALPHAUP^SSUTIL4(barcode),""""))\'=""""��</div><div style="height:25px;display:flex"><div style="width:128px">���������롱</div>��$o(^OEORD(0,""EpisNo"",barcode,""""))\'=""""��</div><div style="height:25px;display:flex"><div style="width:128px">��ִ�е���CQSYD��</div>��##class(Nur.MNIS.Service.Barcode).IsOnExecutionList(barcode,""CQSYD"",hospID)��</div></div></div></td></tr>';
	bbar += '<tr style="height:28px"><td nowrap=nowrap style="border:none">�������ݣ�</td><td nowrap=nowrap style="border:none;padding-left:10px">����ҽ�����֣����ߵĹ�ϵ</td></tr>';
	bbar += '<tr style="height:28px"><td nowrap=nowrap style="border:none">ת��������</td><td nowrap=nowrap style="border:none;padding-left:10px"><div style="display:flex">���磺<div style="padding-left:10px"><div style="height:25px;display:flex"><div style="width:128px">�����š�</div>��$o(^SSU(""SSUSR"",0,""SSUSR_Initials"",$$ALPHAUP^SSUTIL4(barcode),""""))��</div><div style="height:25px;display:flex"><div style="width:128px">���������롱</div>��##class(Nur.MNIS.Service.Barcode).LabNO2OrdID(barcode)��</div><div style="height:25px;display:flex"><div style="width:128px">��סԺ�š�</div>��##class(Nur.MNIS.Service.Barcode).MrNO2RegNO(barcode,hospID)��</div></div></div></td></tr>';
	bbar += '</table></div><div style="margin-left:10px">���ֶηǱ�����������ǲ��ҵĹ�ϵ��ֻ�������������������������²Ż����ת������</div>';
	$('#barcodeGridBbar').html(bbar);
}
function barcodeGridSheetData() {
	var data = getData(getParams(['ClassName', 'ResultSetType', 'configFlag', 'hospID', 'locID'], 'FindSheet'), false);
	GV['_SheetData'] = data;
	$('#barcodeGrid').datagrid('options').columns[0][6].editor = {
		type: 'combobox',
		options: {
			panelWidth: 230,
			multiple: true,
			valueField: 'ID',
			idField: 'ID',
			textField: 'name',
			/*mode: 'remote',
			url: $URL + '?q=1&ClassName=' + GV._CLASSNAME + '&QueryName=FindSheet&ResultSetType=array&hospID=' + getHospID(),
			onLoadSuccess: function(data) {
				GV['_SheetData'] = data;
			},*/
			mode: 'local',
			data: data,
			formatter: function(row) {
				return '<div style="display:flex;margin:-3px 0px -3px -5px"><div style="width:100px;border-right:#ddd 1px solid;border-bottom:#ddd 1px solid;padding:3px 0px 3px 5px">' + row.code + '</div><div style="width:100px;border-right:#ddd 1px solid;border-bottom:#ddd 1px solid;padding:3px 0px 3px 5px">' + row.name + '</div></div>';
			}
		}
	};
}
function barcodeGridOnFindClick() {
	return gridOnFindClick('barcodeGrid', null, function() {
		return getParams(['hospID', 'locID'], 'FindBarcode');
	})();
}
function barcodeGridOnSaveClick() {
	return gridOnSaveClick('barcodeGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function(row) {
		var fn = row.fn;
		var conversion = row.conversion;
		var comment = row.comment;
		fn = fn.split('^').join('%5E');
		fn = fn.split('/').join('%2F');
		conversion = conversion.split('^').join('%5E');
		conversion = conversion.split('/').join('%2F');
		comment = comment.split('^').join('%5E');
		comment = comment.split('/').join('%2F');
		var params = {
			fn: fn,
			conversion: conversion,
			comment: comment
		};
		return getParams(['dataType', 'hospID', 'locID', 'code', 'name', 'prefix', 'symbol', 'digit', 'sheetID'], null, 'SaveBarcode', params, row);
	})();
}
