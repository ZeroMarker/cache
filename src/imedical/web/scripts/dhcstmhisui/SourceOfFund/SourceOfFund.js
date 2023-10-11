// ����:�ʽ���Դά��
// ��д����:2018-8-9

var init = function() {
	var HospId = gHospId;
	var TableName = 'DHC_SourceOfFund';
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
		Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		SourceOfFundGrid.load({
			ClassName: 'web.DHCSTMHUI.SourceOfFund',
			QueryName: 'SelectAll',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			SourceOfFundGrid.commonAddRow();
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var Rows = SourceOfFundGrid.getChangesData();
			if (Rows === false) {	// δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(Rows)) {	// ��ϸ����
				$UI.msg('alert', 'û����Ҫ�������ϸ!');
				return;
			}
			var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			$.cm({
				ClassName: 'web.DHCSTMHUI.SourceOfFund',
				MethodName: 'Save',
				Main: MainObj,
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					SourceOfFundGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	var SourceOfFundCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '����',
			field: 'Code',
			width: 300,
			fitColumns: true,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '����',
			field: 'Description',
			width: 300,
			fitColumns: true,
			editor: { type: 'validatebox', options: { required: true }}
		}
	]];
	
	var SourceOfFundGrid = $UI.datagrid('#SourceOfFundList', {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.SourceOfFund',
			QueryName: 'SelectAll',
			query2JsonStrict: 1
		},
		columns: SourceOfFundCm,
		toolbar: '#SourceOfFundTB',
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickRow: function(index, row) {
			SourceOfFundGrid.commonClickRow(index, row);
		}
	});
	InitHosp();
};
$(init);