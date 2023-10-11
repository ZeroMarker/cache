// 名称:收费类型维护
// 编写日期:2018-8-9
var init = function() {
	var HospId = gHospId;
	var TableName = 'DHC_ItmChargeType';
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
		var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		ItmChargeTypeGrid.load({
			ClassName: 'web.DHCSTMHUI.ItmChargeType',
			QueryName: 'SelectAll',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			ItmChargeTypeGrid.commonAddRow();
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var Rows = ItmChargeTypeGrid.getChangesData();
			if (Rows === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			$.cm({
				ClassName: 'web.DHCSTMHUI.ItmChargeType',
				MethodName: 'Save',
				Main: MainObj,
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					ItmChargeTypeGrid.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	var ItmChargeTypeCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '代码',
			field: 'Code',
			width: 300,
			fitColumns: true,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '描述',
			field: 'Description',
			width: 300,
			fitColumns: true,
			editor: { type: 'validatebox', options: { required: true }}
		}
	]];
	
	var ItmChargeTypeGrid = $UI.datagrid('#ItmChargeTypeList', {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ItmChargeType',
			QueryName: 'SelectAll',
			query2JsonStrict: 1
		},
		columns: ItmChargeTypeCm,
		toolbar: '#ItmChargeTypeTB',
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickRow: function(index, row) {
			ItmChargeTypeGrid.commonClickRow(index, row);
		}
	});
	InitHosp();
};
$(init);