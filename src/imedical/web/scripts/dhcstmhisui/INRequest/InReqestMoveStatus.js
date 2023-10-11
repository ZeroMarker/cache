var init = function() {
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(RequestMainGrid);
		$UI.clear(RequestDetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			ReqLoc: gLocObj
		};
		$UI.fillBlock('#Conditions', DefaultData);
	};
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.ReqLoc)) {
			$UI.msg('alert', '������Ҳ���Ϊ��!');
			return;
		}
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
		$UI.clear(RequestMainGrid);
		$UI.clear(RequestDetailGrid);
		RequestMainGrid.load({
			ClassName: 'web.DHCSTMHUI.INRequestQuery',
			QueryName: 'INReq',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: INREQUEST_LOCTYPE, Element: 'ReqLoc' }));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var ReqLoc = record['RowId'];
			var SupLoc = $('#SupLoc').combobox('getValue');
			$HUI.combotree('#Scg').setFilterByLoc(SupLoc, ReqLoc);
		}
	});
	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'SupLoc' }));
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var SupLoc = record['RowId'];
			var ReqLoc = $('#ReqLoc').combobox('getValue');
			$HUI.combotree('#Scg').setFilterByLoc(SupLoc, ReqLoc);
		}
	});
	var RequestMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '��������',
			field: 'ReqType',
			width: 100,
			formatter: function(v) {
				if (v == 'O') { return '��ʱ����'; }
				if (v == 'C') { return '����ƻ�'; }
				return '����';
			}
		}, {
			title: '���󵥺�',
			field: 'ReqNo',
			width: 200
		}, {
			title: '������',
			field: 'ToLocDesc',
			width: 150
		}, {
			title: '��������',
			field: 'FrLocDesc',
			width: 150
		}, {
			title: '������',
			field: 'UserName',
			width: 70
		}, {
			title: '���������',
			field: 'AuditUser',
			width: 95
		}, {
			title: '��Ӧ�������',
			field: 'AuditUserProv',
			width: 95
		}, {
			title: '����',
			field: 'ReqDate',
			width: 90,
			align: 'right'
		}, {
			title: 'ʱ��',
			field: 'ReqTime',
			width: 80,
			align: 'right'
		}, {
			title: '���״̬',
			field: 'Complete',
			width: 80,
			formatter: BoolFormatter
		}, {
			title: 'ת��״̬',
			field: 'TransStatus',
			width: 80,
			align: 'right',
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
			RequestDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINReqItmMoveStatus',
				QueryName: 'QueryReqDetail',
				query2JsonStrict: 1,
				Req: row.RowId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				RequestMainGrid.selectRow(0);
			}
		}
	});
	
	var RequestDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
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
			title: '������Ϣ',
			field: 'initinfo',
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
			title: '���ת���Ƿ�ܾ�',
			field: 'RefuseFlag',
			width: 120,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '�������',
			field: 'RD',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '��������������',
			field: 'RA',
			width: 150,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '���󵥹�Ӧ��������',
			field: 'EA',
			width: 150,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '�ɹ������',
			field: 'PD',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '�ɹ���������',
			field: 'PA',
			width: 120,
			align: 'center'
		}, {
			title: '�������',
			field: 'POD',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '����������',
			field: 'POA',
			width: 100,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '����Ƶ����',
			field: 'IMD',
			width: 100,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '��ⵥ������',
			field: 'IMA',
			width: 120,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '�����Ƶ����',
			field: 'ID',
			width: 120,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '����������',
			field: 'IO',
			width: 120,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '�ܾ��������',
			field: 'IIR',
			width: 120,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '�������',
			field: 'II',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}
	]];
	
	var RequestDetailGrid = $UI.datagrid('#RequestDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINReqItmMoveStatus',
			QueryName: 'QueryReqDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: RequestDetailCm,
		showBar: true
	});
	
	Clear();
	Query();
};
$(init);