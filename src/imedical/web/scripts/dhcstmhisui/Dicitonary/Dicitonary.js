var init = function() {
	var HospId = gHospId;
	var TableName = 'CT_HRP_MAT.ComDictValue';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				Query();
			};
		} else {
			HospId = gHospId;
		}
		Query();
	}
	function Query() {
		var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		$UI.clear(DictTypeGrid);
		$UI.clear(DictValGrid);
		DictTypeGrid.load({
			ClassName: 'web.DHCSTMHUI.ComDictionary',
			QueryName: 'GetDictType',
			query2JsonStrict: 1
		});
	}
	var DictTypeCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '���ʹ���',
			field: 'DITypeCode',
			width: 150,
			fitColumns: true,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '��������',
			field: 'DITypeDesc',
			width: 150,
			fitColumns: true,
			editor: { type: 'validatebox', options: { required: true }}
		}
	]];
	var DictTypeGrid = $UI.datagrid('#DictTypeGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ComDictionary',
			QueryName: 'GetDictType',
			query2JsonStrict: 1
		},
		columns: DictTypeCm,
		showAddSaveDelItems: true,
		checkField: 'DITypeCode',
		fitColumns: true,
		toolbar: [{
			text: 'ˢ��',
			iconCls: 'icon-reload',
			handler: function() {
				Query();
			}
		}],
		onClickRow: function(index, row) {
			var TypeCode = row.DITypeCode;
			if (!isEmpty(TypeCode)) {
				$UI.clear(DictValGrid);
				var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId, TypeCode: TypeCode }));
				if (!isEmpty(TypeCode)) {
					$UI.clear(DictValGrid);
					DictValGrid.load({
						ClassName: 'web.DHCSTMHUI.ComDictionary',
						QueryName: 'GetDictVal',
						query2JsonStrict: 1,
						Params: Params
					});
				}
			}
			DictTypeGrid.commonClickRow(index, row);
		},
		onBeforeCellEdit: function(index, field) {
			var RowData = $(this).datagrid('getRows')[index];
			if (field == 'DITypeCode' && !isEmpty(RowData['RowId'])) {
				return false;
			}
		},
		saveDataFn: function() {
			CheckBeforeSaveType();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	function CheckBeforeSaveType() {
		var Rows = DictTypeGrid.getChangesData();
		if (Rows === false) {	// δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Rows)) {	// ��ϸ����
			$UI.msg('alert', 'û����Ҫ�������ϸ!');
			return;
		}
		var ExistNewRow = false;
		for (var i = 0, Len = Rows.length; i < Len; i++) {
			if (isEmpty(Rows[i]['RowId'])) {
				ExistNewRow = true;
				break;
			}
		}
		var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		var DetailObj = JSON.stringify(Rows);
		if (ExistNewRow) {
			$UI.confirm('�������뽫�����޸�,�Ƿ����?', '', '', SaveType);
		} else {
			SaveType();
		}
	}
	function SaveType() {
		var Rows = DictTypeGrid.getChangesData();
		var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		var DetailObj = JSON.stringify(Rows);
		$.cm({
			ClassName: 'web.DHCSTMHUI.ComDictionary',
			MethodName: 'jsSave',
			Type: 'DictType',
			Main: MainObj,
			Detail: DetailObj
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var DictValCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '����ֵ����',
			field: 'DIValCode',
			width: 100,
			fitColumns: true,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '����ֵ����',
			field: 'DIValDesc',
			width: 150,
			fitColumns: true,
			editor: { type: 'validatebox', options: { required: true }}
		}
	]];
	var DictValGrid = $UI.datagrid('#DictValGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ComDictionary',
			QueryName: 'GetDictVal',
			query2JsonStrict: 1
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.ComDictionary',
			MethodName: 'jsDelete'
		},
		columns: DictValCm,
		showAddSaveDelItems: true,
		fitColumns: true,
		onClickCell: function(index, field, value) {
			DictValGrid.commonClickCell(index, field);
		},
		beforeAddFn: function() {
			var Row = DictTypeGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ����ά�����ֵ�����!');
				return false;
			}
			var TypeRowId = Row.RowId;
			if (isEmpty(TypeRowId)) {
				$UI.msg('alert', '��ѡ����ά�����ֵ�����!');
				return;
			}
		},
		saveDataFn: function() {
			SaveDetail();
		}
	});
	function SaveDetail() {
		var Rows = DictValGrid.getChangesData();
		if (Rows === false) {	// δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Rows)) {	// ��ϸ����
			$UI.msg('alert', 'û����Ҫ�������ϸ!');
			return;
		}
		var Selected = DictTypeGrid.getSelected();
		if (isEmpty(Selected)) {
			$UI.msg('alert', '��ѡ��Ҫά�����ֵ�����!');
			return;
		}
		var DITypeCode = Selected.DITypeCode;
		if (isEmpty(DITypeCode)) {
			$UI.msg('alert', '�ֵ����ʹ��벻����Ϊ��!');
			return;
		}
		var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId, DITypeCode: DITypeCode }));
		var DetailObj = JSON.stringify(Rows);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.ComDictionary',
			MethodName: 'jsSave',
			Type: 'DictVal',
			Main: MainObj,
			Detail: DetailObj
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				DictValGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	InitHosp();
};
$(init);