var FindWin = function() {
	$HUI.dialog('#FindWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();

	/* --��ť����--*/
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			$UI.clear(AlDispMainGrid);
			$UI.clear(AlDispDetailGrid);
			var ParamsObj = $UI.loopBlock('#FindConditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(StartDate)) {
				$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(EndDate)) {
				$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
				return;
			}
			if (compareDate(StartDate, EndDate)) {
				$UI.msg('alert', '��ֹ���ڲ���С�ڿ�ʼ����!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			AlDispMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
				QueryName: 'QueryInMatDispMain',
				query2JsonStrict: 1,
				Params: Params
			});
		}
	});
	
	$UI.linkbutton('#FClearBT', {
		onClick: function() {
			FDefaultData();
		}
	});
	
	$UI.linkbutton('#FPrintBT', {
		onClick: function() {
			var Row = AlDispMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫѡȡ�ķ��ŵ�');
				return;
			}
			
			PrintDisp(Row.RowId);
		}
	});
	
	/* --�󶨿ؼ�--*/
	var Params = JSON.stringify(addSessionParams());
	$HUI.combobox('#FWardLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetWardLoc&ResultSetType=array&Params=' + Params,
		valueField: 'RowId',
		textField: 'Description'
	});
	/* --Grid--*/
	var AlDispDetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 80
		}, {
			title: '�������',
			field: 'AdmLocDesc',
			width: 100
		}, {
			title: '����',
			field: 'BedNo',
			width: 100
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 100
		}, {
			title: '����id',
			field: 'InciId',
			width: 100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 100
		}, {
			title: '���',
			field: 'Spec',
			width: 100,
			align: 'right'
		}, {
			title: '��λ',
			field: 'Stkbin',
			width: 100
		}, {
			title: '����',
			field: 'Qty',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}
	]];
	
	var AlDispDetailGrid = $UI.datagrid('#AlDispDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
			QueryName: 'QueryInMatDispItm',
			query2JsonStrict: 1
		},
		columns: AlDispDetailGridCm,
		showBar: true
	});
	
	var AlDispMainGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '���ŵ���',
			field: 'DispNo',
			width: 100
		}, {
			title: '����',
			field: 'WardLocDesc',
			width: 100
		}, {
			title: '��������',
			field: 'Date',
			width: 100
		}, {
			title: '����ʱ��',
			field: 'Time',
			width: 150
		}, {
			title: '������',
			field: 'UserName',
			width: 100
		}
	]];
	
	var AlDispMainGrid = $UI.datagrid('#AlDispMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
			QueryName: 'QueryInMatDispMain',
			query2JsonStrict: 1
		},
		columns: AlDispMainGridCm,
		showBar: true,
		onSelect: function(index, row) {
			AlDispDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
				QueryName: 'QueryInMatDispItm',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				AlDispMainGrid.selectRow(0);
			}
		}
	});
	
	/* --���ó�ʼֵ--*/
	var FDefaultData = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(AlDispMainGrid);
		$UI.clear(AlDispDetailGrid);
		// /���ó�ʼֵ ����ʹ������
		var FDefaultDataValue = {
			StartDate: DateAdd(new Date(), 'd', parseInt(-7)),
			EndDate: new Date()
		};
		$UI.fillBlock('#FindConditions', FDefaultDataValue);
	};
	FDefaultData();
	$('#FQueryBT').click();
};