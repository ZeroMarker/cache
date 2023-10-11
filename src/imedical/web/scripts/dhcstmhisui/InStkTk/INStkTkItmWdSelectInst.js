var init = function() {
	// =======================������ʼ��start==================
	// ����
	var LocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	if (InStkTkParamObj.AllLoc == 'Y') {
		LocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	}
	var LocBox = $HUI.combobox('#FLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	// ===========================������ʼend===========================
	// ======================tbar�����¼�start=========================
	// ����
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MasterGrid);
		var DefaultData = {
			FLoc: gLocObj,
			FStartDate: DateFormatter(new Date()),
			FEndDate: DateFormatter(new Date()),
			FInstComp: 'Y',
			FStkTkComp: 'N',
			FAdjComp: 'N'
		};
		$UI.fillBlock('#Conditions', DefaultData);
	};
	// ��ѯ
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('Conditions');
		var StartDate = ParamsObj.FStartDate;
		var EndDate = ParamsObj.FEndDate;
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
		$UI.clear(MasterGrid);
		var Params = JSON.stringify(ParamsObj);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	// ѡȡ
	$UI.linkbutton('#CompleteBT', {
		onClick: function() {
			SelectHandler();
		}
	});
	function SelectHandler() {
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '��ѡ������!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '��ѡ��һ������!');
			return;
		}
		SelectModel(row, Select);
	}
	
	function Select(SelectModel, InstWin) {
		var row = $('#MasterGrid').datagrid('getSelected');
		var InstId = row.RowId;
		var PhaLoc = row.LocId;
		if (isEmpty(PhaLoc)) {
			$UI.msg('alert', '��ѡ�����!');
			return;
		}
		// ��ת����Ӧ��¼�����
		if (SelectModel == 1) {
			var UrlStr = 'dhcstmhui.instktkitmwd.csp?RowId=' + InstId + '&LocId=' + PhaLoc + '&InstwWin=' + InstWin;
			Common_AddTab('ʵ��-�������', UrlStr);
		} else if (SelectModel == 2) {
			var UrlStr = 'dhcstmhui.instktkinput.csp?RowId=' + InstId + '&LocId=' + PhaLoc + '&InstwWin=' + InstWin;
			Common_AddTab('ʵ��-Ʒ�����', UrlStr);
		} else if (SelectModel == 3) {
			var UrlStr = 'dhcstmhui.instktkitmtrack.csp?RowId=' + InstId + '&LocId=' + PhaLoc + '&InstwWin=' + InstWin;
			Common_AddTab('ʵ��-��ֵɨ��', UrlStr);
		}
	}
	
	// ======================tbar�����¼�end============================
	
	var MasterGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 50
		}, {
			title: '�̵㵥��',
			field: 'InstNo',
			width: 150
		}, {
			title: '��������',
			field: 'FreezeDate',
			width: 100
		}, {
			title: '����ʱ��',
			field: 'FreezeTime',
			width: 100
		}, {
			title: '�̵����',
			field: 'LocId',
			hidden: true
		}, {
			title: '�̵����',
			field: 'LocDesc',
			width: 150
		}, {
			title: '�������',
			field: 'CompFlag',
			width: 100,
			hidden: true
		}, {
			title: 'ʵ�����',
			field: 'StkTkCompFlag',
			width: 100,
			hidden: true
		}, {
			title: '�������',
			field: 'AdjCompFlag',
			width: 80,
			hidden: true
		}, {
			title: '�ص��ע��־',
			field: 'ManaFlag',
			width: 100,
			hidden: true
		}, {
			title: '���̵�λ',
			field: 'FreezeUomId',
			width: 80,
			formatter: function(value, row, index) {
				if (row.FreezeUomId == 1) {
					return '��ⵥλ';
				} else {
					return '������λ';
				}
			}
		}, {
			title: '¼������',
			field: 'InputType',
			width: 100,
			formatter: InputTypeFormatter
		}, {
			title: '����������',
			field: 'IncludeNotUse',
			width: 100,
			hidden: true
		}, {
			title: '��������',
			field: 'OnlyNotUse',
			width: 80,
			hidden: true
		}, {
			title: '�����ñ�־',
			field: 'NotUseFlag',
			width: 90,
			align: 'left'
		}, {
			title: '��ֵ��־',
			field: 'HVFlag',
			width: 80
		}, {
			title: '����',
			field: 'StkScgDesc',
			width: 100
		}, {
			title: '������',
			field: 'StkCatDesc',
			width: 100
		}, {
			title: '��ʼ��λ��',
			field: 'FrSbDesc',
			width: 100
		}, {
			title: '������λ��',
			field: 'ToSbDesc',
			width: 100
		}, {
			title: '��ӡ��־',
			field: 'PrintFlag',
			width: 80,
			hidden: true
		}, {
			title: '��ͽ���',
			field: 'MinRp',
			width: 80,
			align: 'right'
		}, {
			title: '��߽���',
			field: 'MaxRp',
			width: 80,
			align: 'right'
		}, {
			title: '�����',
			field: 'RandomNum',
			width: 70,
			align: 'right'
		}
	]];
	var MasterGrid = $UI.datagrid('#MasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			query2JsonStrict: 1
		},
		columns: MasterGridCm,
		onDblClickRow: function(index, row) {
			SelectHandler();
		},
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	Clear();
	Query();
};
$(init);