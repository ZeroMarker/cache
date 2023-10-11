findReqTemplateWin = function(FnMod, FnCre) {
	$HUI.dialog('#TemWin', {
		height: gWinHeight,
		width: gWinWidth
	}).open();
	
	var Clear = function() {
		$UI.clearBlock('#TConditions');
		$UI.clear(TRequestMainGrid);
		$UI.clear(TRequestDetailGrid);
		var HvFlag = gHVInRequest == '' ? '' : (gHVInRequest ? 'Y' : 'N');
		var LocId = $('#ReqLoc').combobox('getValue');
		var LocDesc = $('#ReqLoc').combobox('getText');
		var ReqTypeId = $('#ReqType').combobox('getValue');
		var ReqTypeDesc = $('#ReqType').combobox('getText');
		var DefaultData = {
			ReqLoc: { RowId: LocId, Description: LocDesc },
			ReqType: { RowId: ReqTypeId, Description: ReqTypeDesc },
			HvFlag: HvFlag
		};
		$UI.fillBlock('#TConditions', DefaultData);
	};
	
	$UI.linkbutton('#TQueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#TConditions');
		if (isEmpty(ParamsObj.ReqLoc)) {
			$UI.msg('alert', '������Ҳ���Ϊ��!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(TRequestMainGrid);
		$UI.clear(TRequestDetailGrid);
		TRequestMainGrid.load({
			ClassName: 'web.DHCSTMHUI.INRequestTemplate',
			QueryName: 'ReqTem',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#TModBT', {
		onClick: function() {
			var Row = TRequestMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ���ص�����!');
				return;
			}
			FnMod(Row.RowId);
			$HUI.dialog('#TemWin').close();
		}
	});
	$UI.linkbutton('#TCreBT', {
		onClick: function() {
			var Row = TRequestMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ���ص�����!');
				return;
			}
			var DetailRows = TRequestDetailGrid.getSelections();
			if (isEmpty(DetailRows)) {
				$UI.msg('alert', '��ѡ����Ҫ�Ƶ���ģ����ϸ����!');
				return;
			}
			var InrqiArr = [];
			$.each(DetailRows, function(index, row) {
				var Inrqi = row['RowId'];
				var Incidesc = row['Description'];
				var NoLocReqFlag = row['NoLocReqFlag'];
				if (NoLocReqFlag == 'Y') {
					$UI.msg('alert', Incidesc + '��ֹ����!');
				} else {
					InrqiArr.push(Inrqi);
				}
			});
			var ReqDetailIdStr = InrqiArr.join('^');
			if (isEmpty(InrqiArr)) {
				return false;
			}
			FnCre(Row.RowId, ReqDetailIdStr);
			$HUI.dialog('#TemWin').close();
		}
	});
	$UI.linkbutton('#TClearBT', {
		onClick: function() {
			Clear();
		}
	});
	var TReqTypeBox = $HUI.combobox('#TReqType', {
		data: [{ 'RowId': 'O', 'Description': '��ʱ����' }, { 'RowId': 'C', 'Description': '����ƻ�' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var TReqLocParams = JSON.stringify(addSessionParams({ Type: INREQUEST_LOCTYPE, Element: 'TReqLoc' }));
	var TReqLocBox = $HUI.combobox('#TReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + TReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var TSupLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'TSupLoc' }));
	var TSupLocBox = $HUI.combobox('#TSupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + TSupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var TRequestMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: 'ģ������(��ע)',
			field: 'Remark',
			width: 100
		}, {
			title: '��Ӧ����',
			field: 'SupLocDesc',
			width: 100
		}, {
			title: '���󵥺�',
			field: 'ReqNo',
			width: 180
		}, {
			title: '������',
			field: 'UserName',
			width: 70
		}, {
			title: '���״̬',
			field: 'Complete',
			width: 60,
			align: 'center',
			formatter: BoolFormatter
		}
	]];

	var TRequestMainGrid = $UI.datagrid('#TRequestMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INRequestTemplate',
			QueryName: 'ReqTem',
			query2JsonStrict: 1
		},
		columns: TRequestMainCm,
		onSelect: function(index, row) {
			var ParamsObj = { RefuseFlag: 1 };
			var Params = JSON.stringify(ParamsObj);
			TRequestDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INReqItm',
				QueryName: 'INReqD',
				query2JsonStrict: 1,
				Req: row.RowId,
				Params: Params
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});

	var TRequestDetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 80
		}, {
			title: '�Ƿ�ʹ��',
			field: 'NotUseFlag',
			width: 60,
			align: 'center'
		}, {
			title: '�Ƿ��ֹ����',
			field: 'NoLocReqFlag',
			width: 90,
			align: 'center'
		}, {
			title: '���ʴ���',
			field: 'Code',
			width: 120
		}, {
			title: '��������',
			field: 'Description',
			width: 150
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
			title: '��������',
			field: 'Manf',
			width: 100
		}, {
			title: '��������',
			field: 'Qty',
			width: 100,
			align: 'right'
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 80
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
			title: '����ע',
			field: 'ReqRemarks',
			width: 100
		}, {
			title: '�Ƿ�ܾ�',
			field: 'RefuseFlag',
			width: 60,
			align: 'center'
		}
	]];

	var TRequestDetailGrid = $UI.datagrid('#TRequestDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INReqItm',
			QueryName: 'INReqD',
			query2JsonStrict: 1
		},
		columns: TRequestDetailCm,
		singleSelect: false,
		onLoadSuccess: function(data) {
			$.each(data.rows, function(index, row) {
				var NotUseFlag = row['NotUseFlag'];
				var NoLocReqFlag = row['NoLocReqFlag'];
				if ((NotUseFlag == 'ͣ��') || (NoLocReqFlag == 'Y')) {
					var Color = '#FD930C';
					SetGridBgColor(TRequestDetailGrid, index, 'RowId', Color);
				}
			});
		}
	});

	Clear();
	Query();
};