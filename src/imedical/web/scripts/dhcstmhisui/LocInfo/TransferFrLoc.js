function setTransferFrLoc(LocStr, Hospid, Type) {
	$HUI.dialog('#TransferFrLoc', { width: gWinWidth, height: gWinHeight }).open();
	
	var Clear = function() {
		$UI.clear(TransferFrLocGrid);
		$UI.clear(LocGrid);
	};
	$UI.linkbutton('#LocGridSearchBT', {
		onClick: function() {
			LocGridSearch();
		}
	});
	function LocGridSearch() {
		var SessionParmas = addSessionParams({ Hospital: Hospid });
		var Paramsobj = $UI.loopBlock('LocGridTB');
		Paramsobj.Type = Type;// ���ù�������F,���ý��տ���T
		Paramsobj.Loc = LocStr;
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		LocGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
			QueryName: 'NotTransferFrLoc',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	function TransferFrLocGridSearch() {
		var SessionParmas = addSessionParams({ Hospital: Hospid });
		var Paramsobj = $UI.loopBlock('LocGridTB');
		Paramsobj.Type = Type;// ���ù�������F,���ý��տ���T
		Paramsobj.Loc = LocStr;
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		TransferFrLocGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
			QueryName: 'TransferLoc',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#TransferFrLocGridSaveBT', {
		onClick: function() {
			TransferFrLocSave();
		}
	});
	
	function TransferFrLocSave() {
		var Detail = TransferFrLocGrid.getChangesData();
		if (Detail === false) {	// δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Detail)) {	// ��ϸ����
			$UI.msg('alert', 'û����Ҫ�������ϸ!');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
			MethodName: 'SaveDefat',
			Rows: JSON.stringify(Detail)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				TransferFrLocGridSearch();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var TransferFrLocGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '����',
			field: 'Code',
			width: 180
		}, {
			title: '����',
			field: 'Description',
			width: 180
		}, {
			title: 'Ĭ��ֵ',
			field: 'DefaultFlag',
			width: 80,
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

	var TransferFrLocGrid = $UI.datagrid('#TransferFrLocGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
			QueryName: 'TransferLoc',
			query2JsonStrict: 1
		},
		toolbar: '#TransferFrLocGridTB',
		columns: TransferFrLocGridCm,
		onDblClickRow: function(index, row) {
			var Rows = TransferFrLocGrid.getSelectedData();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
				MethodName: 'Delete',
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					LocGridSearch();
					TransferFrLocGridSearch();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		onClickRow: function(index, row) {
			TransferFrLocGrid.commonClickRow(index, row);
		}
	});
	var LocGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '����',
			field: 'Code',
			width: 200
		}, {
			title: '����',
			field: 'Description',
			width: 200
		}
	]];
			
	var LocGrid = $UI.datagrid('#LocGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
			QueryName: 'NotTransferFrLoc',
			query2JsonStrict: 1
		},
		toolbar: '#LocGridTB',
		fitColumns: true,
		columns: LocGridCm,
		onDblClickRow: function(index, row) {
			var Obj = {};
			Obj.Type = Type;
			Obj.ConLoc = row.RowId;
			// Obj.GroupId= gGroupId;
			Obj.Loc = LocStr;
			var Params = JSON.stringify(Obj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
				MethodName: 'JsInsert',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					LocGridSearch();
					TransferFrLocGridSearch();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	Clear();
	LocGridSearch();
	TransferFrLocGridSearch();
}