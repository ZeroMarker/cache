var FindRetWin = function() {
	$HUI.dialog('#FindRetWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
	
	/* --��ť����--*/
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			$UI.clear(AlDispRetMainGrid);
			$UI.clear(AlDispRetDetailGrid);
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
			AlDispRetMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCInMatRet',
				QueryName: 'QueryInMatDispRetMain',
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
			var Row = AlDispRetMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫѡȡ�ķ��ŵ�');
				return;
			}
			
			PrintDispRet(Row.RowId);
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
	var AlDispRetDetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '�������',
			field: 'AdmLocDesc',
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
		}, {
			title: '����',
			field: 'PatName',
			width: 60
		}, {
			title: '����',
			field: 'BedNo',
			width: 60
		}, {
			title: '��������',
			field: 'DispDate',
			width: 150
		}, {
			title: '����ʱ��',
			field: 'DispTime',
			width: 150
		}
	]];
	
	var AlDispRetDetailGrid = $UI.datagrid('#AlDispRetDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCInMatRet',
			QueryName: 'QueryInMatDispRetItm',
			query2JsonStrict: 1
		},
		columns: AlDispRetDetailGridCm,
		showBar: true
	});
	
	var AlDispRetMainGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 80
		}, {
			title: '�˻ص���',
			field: 'DispRetNo',
			width: 100
		}, {
			title: '����',
			field: 'LocDesc',
			width: 100
		}, {
			title: '����',
			field: 'WardLocDesc',
			width: 100
		}, {
			title: '�˻�����',
			field: 'Date',
			width: 100
		}, {
			title: '�˻�ʱ��',
			field: 'Time',
			width: 150
		}, {
			title: '�˻���',
			field: 'UserName',
			width: 100
		}
	]];
	
	var AlDispRetMainGrid = $UI.datagrid('#AlDispRetMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCInMatRet',
			QueryName: 'QueryInMatDispRetMain',
			query2JsonStrict: 1
		},
		columns: AlDispRetMainGridCm,
		showBar: true,
		onSelect: function(index, row) {
			AlDispRetDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCInMatRet',
				QueryName: 'QueryInMatDispRetItm',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				AlDispRetMainGrid.selectRow(0);
			}
		}
	});
	
	/* --���ó�ʼֵ--*/
	var FDefaultData = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(AlDispRetMainGrid);
		$UI.clear(AlDispRetDetailGrid);
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