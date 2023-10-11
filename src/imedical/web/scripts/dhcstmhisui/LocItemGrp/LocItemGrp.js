var init = function() {
	var HospId = gHospId;
	var TableName = 'DHC_LocItemGrp';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				Query();
			};
		}
		Query();
	}
	function Query() {
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('FCondition');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		ItemGrpMasterGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItemGrp',
			QueryName: 'QueryItemGrp',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	var ActiveStatusComBox = $HUI.combobox('#ActiveStatus', {
		valueField: 'RowId',
		textField: 'Description',
		multiple: false,
		panelHeight: 'auto',
		data: [
			{ 'RowId': '', 'Description': 'ȫ��' },
			{ 'RowId': 'Y', 'Description': '�Ѽ���' },
			{ 'RowId': 'N', 'Description': 'δ����' }
		]
		
	});
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			ItemGrpMasterGrid.commonAddRow();
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var listData = ItemGrpMasterGrid.getChangesData();
			if (listData === false) {	// δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(listData)) {	// ��ϸ����
				$UI.msg('alert', 'û����Ҫ�������ϸ!');
				return;
			}
			var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			$.cm({
				ClassName: 'web.DHCSTMHUI.LocItemGrp',
				MethodName: 'Save',
				Main: MainObj,
				listData: JSON.stringify(listData)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					ItemGrpMasterGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	var ItemGrpMasterGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: '����',
			field: 'Code',
			width: 300,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '����',
			field: 'Desc',
			width: 300,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '��ע',
			field: 'Remark',
			width: 300,
			editor: 'text'
		}, {
			title: '�����־',
			field: 'ActiveFlag',
			width: 100,
			align: 'center',
			editor: {
				type: 'checkbox',
				options: {
					on: 'Y',
					off: 'N'
				}
			},
			formatter: BoolFormatter
		}
	]];
	
	var ItemGrpMasterGrid = $UI.datagrid('#ItemGrpMasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItemGrp',
			QueryName: 'QueryItemGrp',
			query2JsonStrict: 1
		},
		columns: ItemGrpMasterGridCm,
		toolbar: '#ItemGrpMasterGridTB',
		onClickRow: function(index, row) {
			ItemGrpMasterGrid.commonClickRow(index, row);
		}
	});
	InitHosp();
};
$(init);