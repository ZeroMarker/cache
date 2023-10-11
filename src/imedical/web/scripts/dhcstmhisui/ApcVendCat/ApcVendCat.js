var init = function() {
	var HospId = gHospId;
	var TableName = 'APC_VendCat';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr, VendorCatGrid);
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
		var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		VendorCatGrid.load({
			ClassName: 'web.DHCSTMHUI.APCVendCat',
			QueryName: 'GetVendorCat',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$('#AddBT').on('click', function() {
		VendorCatGrid.commonAddRow();
	});
	$('#SaveBT').on('click', function() {
		var Rows = VendorCatGrid.getChangesData();
		var OtherParams = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		if (Rows === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.APCVendCat',
			MethodName: 'Save',
			Params: JSON.stringify(Rows),
			OtherParams: OtherParams
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				VendorCatGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	});

	var VendorCatCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '代码',
			field: 'Code',
			width: 200,
			editor: {
				type: 'validatebox',
				options: {
					required: true,
					tipPosition: 'bottom'
				}
			}
		}, {
			title: '描述',
			field: 'Description',
			width: 300,
			editor: {
				type: 'validatebox',
				options: {
					required: true,
					tipPosition: 'bottom'
				}
			}
		}
	]];
	var VendorCatGrid = $UI.datagrid('#VendorCatGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.APCVendCat',
			QueryName: 'GetVendorCat',
			query2JsonStrict: 1
		},
		columns: VendorCatCm,
		toolbar: '#VendorCatBT',
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickRow: function(index, row) {
			VendorCatGrid.commonClickRow(index, row);
		}
	});
	InitHosp();
};
$(init);