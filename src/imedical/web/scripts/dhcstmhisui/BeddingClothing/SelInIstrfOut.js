var SelInIsTrfOut = function(Fn) {
	$HUI.dialog('#TransWin', { width: gWinWidth, height: gWinHeight }).open();
	
	$UI.linkbutton('#TransQueryBT', {
		onClick: function() {
			FindTransQuery();
		}
	});
	function FindTransQuery() {
		$UI.clear(TransDetailGrid);
		$UI.clear(TransMasterGrid);
		var ParamsObj = $UI.loopBlock('#TransConditions');
		ParamsObj.FrLoc = $('#InitToLoc').combobox('getValue');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.FrLoc)) {
			$UI.msg('alert', '�ⷿ����Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.Status)) {
			ParamsObj.Status = '31';
		}
		var Params = JSON.stringify(ParamsObj);
		TransMasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#TransSaveBT', {
		onClick: function() {
			var Row = TransMasterGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ����ĵ���!');
			}
			Params = JSON.stringify(addSessionParams({ Init: Row.RowId }));
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				MethodName: 'jsCreateInIsTrf',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					Fn(jsonData.rowid);
					$HUI.dialog('#TransWin').close();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	function Clear() {
		$UI.clearBlock('#TransConditions');
		$UI.clear(TransMasterGrid);
		$UI.clear(TransDetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#TransConditions', DefaultData);
	}
	
	TransLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var TransLocBox = $HUI.combobox('#TransLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + TransLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var TransMasterCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '����',
			field: 'InitNo',
			align: 'left',
			editor: 'text',
			width: 150,
			sortable: true
		}, {
			title: '��Դ����',
			field: 'FrLocDesc',
			width: 150,
			sortable: true
		}, {
			title: '���տ���',
			field: 'ToLocDesc',
			width: 150
		}, {
			title: '�Ƶ�ʱ��',
			field: 'InitDateTime',
			width: 150
		}, {
			title: '����',
			field: 'ScgDesc',
			width: 150
		}
	]];
	
	var TransMasterGrid = $UI.datagrid('#TransMasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			query2JsonStrict: 1
		},
		columns: TransMasterCm,
		onSelect: function(index, row) {
			var Init = row['RowId'];
			var ParamsObj = { Init: Init, InitType: 'T' };
			$UI.clear(TransDetailGrid);
			TransDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
				QueryName: 'DHCINIsTrfD',
				query2JsonStrict: 1,
				Params: JSON.stringify(ParamsObj)
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				TransMasterGrid.selectRow(0);
			}
		}
	});
	var TransDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 120
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 180
		}, {
			title: 'ת������',
			field: 'Qty',
			align: 'right',
			width: 80
		}, {
			title: '���',
			field: 'Spec',
			width: 80
		}, {
			title: '����~Ч��',
			field: 'BatExp',
			width: 200
		}, {
			title: '��������',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '���ο��',
			field: 'InclbQty',
			align: 'right',
			width: 80
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 50
		}, {
			title: '����',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '�ۼ�',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: '���۽��',
			field: 'RpAmt',
			align: 'right',
			width: 80
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			align: 'right',
			width: 80
		}, {
			title: 'ռ������',
			field: 'InclbDirtyQty',
			align: 'right',
			width: 100
		}, {
			title: '��������',
			field: 'InclbAvaQty',
			align: 'right',
			width: 100
		}
	]];

	var TransDetailGrid = $UI.datagrid('#TransDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			query2JsonStrict: 1
		},
		columns: TransDetailCm,
		remoteSort: false
	});
	
	Clear();
	FindTransQuery();
};