var FindWin = function(Fn) {
	$HUI.dialog('#FindWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
	
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(RequestMainGrid);
		$UI.clear(RequestDetailGrid);
		
		var LocId = $('#ReqLoc').combobox('getValue');
		var LocDesc = $('#ReqLoc').combobox('getText');
		var ReqTypeId = $('#ReqType').combobox('getValue');
		var ReqTypeDesc = $('#ReqType').combobox('getText');
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			AllTransfer: 'Y',
			PartTransfer: 'Y',
			NoTransfer: 'Y',
			ReqLoc: { RowId: LocId, Description: LocDesc },
			HvFlag: gHVInRequest ? 'Y' : 'N',
			ReqType: { RowId: ReqTypeId, Description: ReqTypeDesc }
		};
		$UI.fillBlock('#FindConditions', DefaultData);
	};
	
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.ReqLoc)) {
			$UI.msg('alert', '������Ҳ���Ϊ��!');
			return;
		}
		$UI.clear(RequestDetailGrid);
		$UI.clear(RequestMainGrid);
		var Params = JSON.stringify(ParamsObj);
		RequestMainGrid.load({
			ClassName: 'web.DHCSTMHUI.INRequest',
			QueryName: 'INReqM',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#FComBT', {
		onClick: function() {
			var Row = RequestMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ���ص�����!');
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
	var FReqTypeBox = $HUI.combobox('#FReqType', {
		data: [{ 'RowId': 'O', 'Description': '��ʱ����' }, { 'RowId': 'C', 'Description': '����ƻ�' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var FReqLocParams = JSON.stringify(addSessionParams({ Type: INREQUEST_LOCTYPE, Element: 'FReqLoc' }));
	var FReqLocBox = $HUI.combobox('#FReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var FSupLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'FSupLoc' }));
	var FSupLocBox = $HUI.combobox('#FSupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FSupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var RequestMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '���󵥺�',
			field: 'ReqNo',
			width: 150
		}, {
			title: '��������',
			field: 'PatientName',
			width: 120
		}, {
			title: '������',
			field: 'Medicare',
			width: 150
		}, {
			title: '������',
			field: 'ToLocDesc',
			width: 150
		}, {
			title: '��������',
			field: 'FrLocDesc',
			width: 100
		}, {
			title: '������',
			field: 'UserName',
			width: 70
		}, {
			title: '����',
			field: 'Date',
			width: 90
		}, {
			title: 'ʱ��',
			field: 'Time',
			width: 80
		}, {
			title: '���״̬',
			field: 'Complete',
			width: 60,
			align: 'center'
		}, {
			title: '����״̬',
			field: 'Status',
			width: 80,
			formatter: function(value) {
				var status = '';
				if (value == 0) {
					status = 'δת��';
				} else if (value == 1) {
					status = '����ת��';
				} else if (value == 2) {
					status = 'ȫ��ת��';
				}
				return status;
			}
		}, {
			title: '��ע',
			field: 'Remark',
			width: 100
		}
	]];
	
	var RequestMainGrid = $UI.datagrid('#RequestMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INRequest',
			QueryName: 'INReqM',
			query2JsonStrict: 1
		},
		columns: RequestMainCm,
		showBar: true,
		onSelect: function(index, row) {
			var ParamsObj = { RefuseFlag: 1 };
			var Params = JSON.stringify(ParamsObj);
			RequestDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INReqItm',
				QueryName: 'INReqD',
				query2JsonStrict: 1,
				Req: row.RowId,
				Params: Params
			});
		},
		onDblClickRow: function(index, row) {
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	
	var RequestDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
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
			title: '��ע',
			field: 'ReqRemarks',
			width: 100
		}, {
			title: '�Ƿ�ܾ�',
			field: 'RefuseFlag',
			width: 60,
			align: 'center'
		}
	]];
	
	var RequestDetailGrid = $UI.datagrid('#RequestDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INReqItm',
			QueryName: 'INReqD',
			query2JsonStrict: 1
		},
		columns: RequestDetailCm,
		showBar: true
	});
	
	Clear();
	Query();
};