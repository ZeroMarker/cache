var InPurPlanMouldWin = function(SelectFn, CreateFn) {
	$HUI.dialog('#MouldWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
	
	$UI.linkbutton('#FMouldQueryBT', {
		onClick: function() {
			MouldQuery();
		}
	});
	
	function MouldQuery() {
		$UI.clear(MouldPurMainGrid);
		$UI.clear(MouldPurDetailGrid);
		var ParamsObj = $UI.loopBlock('#FindMouldConditions');
		if (isEmpty(ParamsObj['PurLoc'])) {
			$UI.msg('alert', '�ɹ����Ҳ���Ϊ��!');
			return;
		}
		ParamsObj['MouldFlag'] = 'Y';
		var Params = JSON.stringify(ParamsObj);
		MouldPurMainGrid.load({
			ClassName: 'web.DHCSTMHUI.INPurPlanMould',
			QueryName: 'QueryMould',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#FMouldClearBT', {
		onClick: function() {
			MouldDefaultData();
		}
	});
	$UI.linkbutton('#FMouldSelectBT', {
		onClick: function() {
			var Row = MouldPurMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ���ص�ģ��!');
				return;
			}
			SelectFn(Row.RowId);
			$HUI.dialog('#MouldWin').close();
		}
	});
	$UI.linkbutton('#FMouldCreateBT', {
		onClick: function() {
			var Row = MouldPurMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ���ص�ģ��!');
				return;
			}
			var DetailRows = MouldPurDetailGrid.getSelections();
			if (isEmpty(DetailRows)) {
				$UI.msg('alert', '��ѡ����Ҫ�Ƶ���ģ����ϸ����!');
				return;
			}
			var InppiArr = [];
			$.each(DetailRows, function(index, row) {
				var Inppi = row['RowId'];
				InppiArr.push(Inppi);
			});
			var InppiIdStr = InppiArr.join('^');
			CreateFn(Row['RowId'], InppiIdStr);
			$HUI.dialog('#MouldWin').close();
		}
	});
	
	$HUI.combobox('#FMouldPurLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PurLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var MouldPurDetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 60,
			hidden: true
		}, {
			title: '����',
			field: 'InciCode',
			width: 100
		}, {
			title: '����',
			field: 'InciDesc',
			width: 100
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '������',
			field: 'SpecDesc',
			width: 100,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '�ɹ�����',
			field: 'Qty',
			width: 100,
			align: 'right'
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 100
		}, {
			title: '����',
			field: 'Rp',
			width: 100,
			align: 'right'
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '��Ӧ��',
			field: 'VendorDesc',
			width: 100
		}, {
			title: '������',
			field: 'CarrierDesc',
			width: 100
		}, {
			title: '�������',
			field: 'MaxQty',
			width: 100,
			align: 'right'
		}, {
			title: '�������',
			field: 'MinQty',
			width: 100,
			align: 'right'
		}
	]];
	
	var MouldPurDetailGrid = $UI.datagrid('#MouldPurDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlanItm',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: MouldPurDetailCm,
		singleSelect: false,
		pagination: false,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				MouldPurDetailGrid.selectAll();
			}
		}
	});
	
	var MouldPurMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '�ƻ�����',
			field: 'PurNo',
			width: 100
		}, {
			title: '�ɹ�����',
			field: 'PurLoc',
			width: 100
		}, {
			title: '�Ƶ�����',
			field: 'CreateDate',
			width: 150
		}, {
			title: '�Ƶ���',
			field: 'CreateUser',
			width: 100
		}, {
			title: '�ɹ������',
			field: 'CompFlag',
			width: 100,
			align: 'right'
		}
	]];
	
	var MouldPurMainGrid = $UI.datagrid('#MouldPurMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlanMould',
			QueryName: 'QueryMould',
			query2JsonStrict: 1
		},
		columns: MouldPurMainCm,
		onSelect: function(index, row) {
			MouldPurDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INPurPlanItm',
				QueryName: 'Query',
				query2JsonStrict: 1,
				PurId: row.RowId,
				rows: 9999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				MouldPurMainGrid.selectRow(0);
			}
		}
		//		,
		//		onDblClickRow:function(index, row){
		//			Fn(row.RowId);
		//			$HUI.dialog('#FindWin').close();
		//		}
	});
	
	function MouldDefaultData() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(MouldPurMainGrid);
		$UI.clear(MouldPurDetailGrid);
		var LocObj = { RowId: $('#PurLoc').combobox('getValue'), Descirption: $('#PurLoc').combobox('getText') };
		// Ĭ��������Ŀ���
		var FDefaultDataValue = {
			PurLoc: LocObj
		};
		$UI.fillBlock('#FindMouldConditions', FDefaultDataValue);
	}
	MouldDefaultData();
	MouldQuery();
};