function TransQuery(Incil, Date) {
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#FindConditions');
			var Params = JSON.stringify(ParamsObj);
			FDetailInfoGrid.load({
				ClassName: 'web.DHCSTMHUI.LocItmTransMove',
				MethodName: 'LocItmStkMoveDetail',
				ParamStr: Params,
				INCIL: Incil
			});
		}
	});
	var DetailInfoCm = [[
		{
			title: 'TrId',
			field: 'TrId',
			width: 50,
			align: 'left',
			sortable: true,
			hidden: true
		}, {
			title: 'ҵ��RowId',
			field: 'TrPointer',
			width: 50,
			hidden: true
		}, {
			title: '����',
			field: 'TrDate',
			width: 150,
			sortable: true
		}, {
			title: '����Ч��',
			field: 'BatExp',
			width: 150
		}, {
			title: '��λ',
			field: 'PurUom',
			width: 50
		}, {
			title: '��ֵ����',
			field: 'HVBarCode',
			width: 200
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 70,
			align: 'right'
		}, {
			title: '����',
			field: 'Rp',
			width: 70,
			align: 'right'
		}, {
			title: '��������',
			field: 'EndQtyUom',
			width: 70
		}, {
			title: '���ν���',
			field: 'EndQtyUomInclb',
			width: 70
		}, {
			title: '����',
			field: 'TrQtyUom',
			width: 80,
			align: 'right'
		}, {
			title: '���۽��',
			field: 'RpAmt',
			align: 'right',
			width: 100
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			align: 'right',
			width: 100
		}, {
			title: '�����',
			field: 'TrNo',
			width: 100
		}, {
			title: '������',
			field: 'TrAdm',
			width: 70
		}, {
			title: 'ժҪ',
			field: 'TrMsg',
			width: 150
		}, {
			title: '������(����)',
			field: 'EndRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '������(�ۼ�)',
			field: 'EndSpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��Ӧ��',
			field: 'Vendor',
			width: 120
		}, {
			title: '��������',
			field: 'Manf',
			width: 120
		}, {
			title: '������',
			field: 'OperateUser',
			width: 60
		}
	]];
	var FDetailInfoGrid = $UI.datagrid('#FDetailInfoGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmTransMove',
			MethodName: 'LocItmStkMoveDetail'
		},
		columns: DetailInfoCm,
		showBar: true,
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	$HUI.dialog('#TransMoveInfoWin', {
		height: gWinHeight,
		width: gWinWidth,
		onOpen: function() {
			var DefaultData = {
				StartDate: Date,
				EndDate: Date
			};
			$UI.fillBlock('#FindConditions', DefaultData);
			var ParamsObj = $UI.loopBlock('#FindConditions');
			var Params = JSON.stringify(ParamsObj);
			FDetailInfoGrid.load({
				ClassName: 'web.DHCSTMHUI.LocItmTransMove',
				MethodName: 'LocItmStkMoveDetail',
				ParamStr: Params,
				INCIL: Incil
			});
		}
	}).open();
}