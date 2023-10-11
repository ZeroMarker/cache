var init = function() {
	var HospId = gHospId;
	var TableName = 'DHC_STOrigin';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr, OriginGrid, Query);
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
		var Paramsobj = $UI.loopBlock('OriginTB');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		OriginGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCSTOrigin',
			QueryName: 'SelectAll',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			OriginGrid.commonAddRow();
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var Rows = OriginGrid.getChangesData();
			if (Rows === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCSTOrigin',
				MethodName: 'Save',
				Main: MainObj,
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					OriginGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('OriginTB');
			$UI.clear(OriginGrid);
		}
	});

	var OriginCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '代码',
			field: 'Code',
			width: 150,
			editor: {
				type: 'validatebox',
				options: {
					tipPosition: 'bottom',
					required: true
				}
			}
		}, {
			title: '描述',
			field: 'Description',
			width: 200,
			editor: {
				type: 'validatebox',
				options: {
					tipPosition: 'bottom',
					required: true
				}
			}
		}
	]];

	var OriginGrid = $UI.datagrid('#OriginList', {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCSTOrigin',
			QueryName: 'SelectAll',
			query2JsonStrict: 1
		},
		columns: OriginCm,
		toolbar: '#OriginTB',
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickRow: function(index, row) {
			OriginGrid.commonClickRow(index, row);
		}
	});
	InitHosp();
};
$(init);