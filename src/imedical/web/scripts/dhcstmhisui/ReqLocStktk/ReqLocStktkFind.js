var FindWin = function(Fn) {
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(StkMainGrid);
		$UI.clear(StkDetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			StkLoc: gLocObj
		};
		$UI.fillBlock('#FindConditions', DefaultData);
	};
	$HUI.dialog('#FindWin', { width: gWinWidth, height: gWinHeight }).open();
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#FindConditions');
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.StkLoc)) {
				$UI.msg('alert', '���Ҳ���Ϊ��!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$UI.clear(StkDetailGrid);
			StkMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
				QueryName: 'QueryMaster',
				query2JsonStrict: 1,
				StrParam: Params
			});
		}
	});
	$UI.linkbutton('#FComBT', {
		onClick: function() {
			var Row = StkMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ���ص��̵㵥!');
				return;
			}
			Fn(Row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});
	$UI.linkbutton('#FClearBT', {
		onClick: function() {
			Clear();
		}
	});

	var FStkLocParams = JSON.stringify(addSessionParams({ Type: INREQUEST_LOCTYPE }));
	var FStkLocBox = $HUI.combobox('#FStkLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FStkLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var StkMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '�����̵㵥��',
			field: 'SubSTNo',
			width: 150
		}, {
			title: '�ⷿ',
			field: 'CreateLocDesc',
			width: 150
		}, {
			title: '�̵����',
			field: 'StkTkLocDesc',
			width: 100
		}, {
			title: '�Ƶ���',
			field: 'CreateUser',
			width: 70
		}, {
			title: '����',
			field: 'CreateDate',
			width: 90,
			align: 'right'
		}, {
			title: 'ʱ��',
			field: 'CreateTime',
			width: 80,
			align: 'right'
		}, {
			title: '�������״̬',
			field: 'Completed',
			width: 60
		}, {
			title: 'ʵ�����״̬',
			field: 'CountCompleted',
			width: 60
		}, {
			title: '�������״̬',
			field: 'AdjCompleted',
			width: 60
		}
	]];
	
	var StkMainGrid = $UI.datagrid('#StkMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
			QueryName: 'QueryMaster',
			query2JsonStrict: 1
		},
		columns: StkMainCm,
		onSelect: function(index, row) {
			StkDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
				QueryName: 'QueryDetail',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onDblClickRow: function(index, row) {
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				StkMainGrid.selectRow(0);
			}
		}
	});
	
	var StkDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: 'Incil',
			field: 'Incil',
			hidden: true,
			width: 80
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 120
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '��������',
			field: 'FreezeQty',
			width: 100,
			align: 'right'
		}, {
			title: '��λ',
			field: 'PUomDesc',
			width: 80
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��ע',
			field: 'Remarks',
			width: 100
		}
	]];
	
	var StkDetailGrid = $UI.datagrid('#StkDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCReqLocStktk',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1
		},
		columns: StkDetailCm
	});
	
	Clear();
	$('#FQueryBT').click();
};