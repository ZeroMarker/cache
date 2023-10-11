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
		$UI.clear(DetailGrid);
		var DefaultData = {
			FLoc: gLocObj,
			FStartDate: DateFormatter(new Date()),
			FEndDate: DateFormatter(new Date()),
			FExcludeNew: 'Y',
			FInstComp: 'Y',
			FStkTkComp: 'Y',
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
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	// ȷ��
	$UI.linkbutton('#CompleteBT', {
		onClick: function() {
			Complete();
		}
	});
	
	function Complete() {
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '��ѡ������!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '��������!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTkAdj',
			MethodName: 'jsStkTkAdj',
			Inst: row.RowId,
			UserId: gUserId
		}, function(jsonData) {
			if (jsonData.success >= 0) {
				var AdjId = jsonData.rowid;
				if (AdjId == '') {
					$UI.msg('success', '�̵�ȷ�ϳɹ������δ�����仯');
				} else {
					$UI.msg('success', jsonData.msg);
				}
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// ��ӡ
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			Print();
		}
	});
	function Print() {
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '��ѡ������!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '��������!');
			return;
		}
		PrintINStk(row.RowId, 0);
	}
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			$UI.confirm('�����ʻ�Ĳ�ɾ���󣬱��β����̵㣬�������̵㣡', 'warning', '', DeletInstkstkItm, '', '', '����', false);
		}
	});
	function DeletInstkstkItm() {
		var row = $('#DetailGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '��ѡ������!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '��������!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			MethodName: 'DeleteItm',
			insti: row.RowId
		}, function(jsonData) {
			if (jsonData == 0) {
				$UI.msg('success', 'ɾ���ɹ���');
				loadDetailGrid();
			} else {
				$UI.msg('error', 'ɾ��ʧ�ܣ�');
			}
		});
	}
	// ������ϸ
	function loadDetailGrid() {
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '��ѡ������!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '��������!');
			return;
		}
		var ParamsObj = $UI.loopBlock('DetailConditions');
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm',
			query2JsonStrict: 1,
			Inst: row.RowId,
			Others: Params
		});
	}
	
	$HUI.radio("[name='StatFlag']", {
		onChecked: function(e, value) {
			loadDetailGrid();
		}
	});
	
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
			title: '����',
			field: 'LocDesc',
			width: 100
		}, {
			title: '�������',
			field: 'CompFlag',
			width: 100,
			formatter: function(value, row, index) {
				if (row.CompFlag == 'Y') {
					return '�����';
				} else {
					return 'δ���';
				}
			}
		}, {
			title: 'ʵ�����',
			field: 'StkTkCompFlag',
			width: 100,
			formatter: function(value, row, index) {
				if (row.StkTkCompFlag == 'Y') {
					return '�����';
				} else {
					return 'δ���';
				}
			}
		}, {
			title: '�������',
			field: 'AdjCompFlag',
			width: 100,
			formatter: function(value, row, index) {
				if (row.AdjCompFlag == 'Y') {
					return '�����';
				} else {
					return 'δ���';
				}
			}
		}, {
			title: '��־',
			field: 'ManaFlag',
			width: 70,
			hidden: true
		}, {
			title: '���̵�λ',
			field: 'FreezeUomId',
			width: 100,
			formatter: function(value, row, index) {
				if (row.FreezeUomId == 1) {
					return '��ⵥλ';
				} else {
					return '������λ';
				}
			}
		}, {
			title: '���̽��',
			field: 'SumFreezeRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: 'ʵ�̽��',
			field: 'SumCount1RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '������',
			field: 'SumVariance1RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�����ñ�־',
			field: 'NotUseFlag',
			width: 100
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
			title: '¼������',
			field: 'InputType',
			width: 100,
			formatter: InputTypeFormatter
		}, {
			title: '��ӡ��־',
			field: 'PrintFlag',
			width: 100
		}, {
			title: '��ͽ���',
			field: 'MinRp',
			width: 100,
			align: 'right'
		}, {
			title: '��߽���',
			field: 'MaxRp',
			width: 100,
			align: 'right'
		}, {
			title: '�����',
			field: 'RandomNum',
			width: 100,
			align: 'right'
		}, {
			title: '��ֵ��־',
			field: 'HVFlag',
			width: 100
		}
	]];
	var MasterGrid = $UI.datagrid('#MasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'DHCSTINStkTk',
			query2JsonStrict: 1
		},
		columns: MasterGridCm,
		onSelect: function(index, row) {
			loadDetailGrid();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#MasterGrid').datagrid('selectRow', 0);
			}
		}
	});
	var DetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 50
		}, {
			title: 'Inclb',
			field: 'Inclb',
			hidden: true,
			width: 50
		}, {
			title: 'InciId',
			field: 'InciId',
			hidden: true,
			width: 50
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
			field: 'ManfDesc',
			width: 100
		}, {
			title: '����',
			field: 'Barcode',
			width: 100
		}, {
			title: '��������',
			field: 'FreezeQty',
			width: 100,
			align: 'right'
		}, {
			title: '���ÿ��',
			field: 'AvaQty',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'FreezeDate',
			width: 100
		}, {
			title: '����ʱ��',
			field: 'FreezeTime',
			width: 100
		}, {
			title: 'ʵ������',
			field: 'CountQty',
			width: 100,
			align: 'right'
		}, {
			title: 'ʵ������',
			field: 'CountDate',
			width: 100
		}, {
			title: 'ʵ��ʱ��',
			field: 'CountTime',
			width: 80
		}, {
			title: 'ʵ����',
			field: 'CountUserId',
			hidden: true
		}, {
			title: 'ʵ����',
			field: 'CountUserName',
			width: 100
		}, {
			title: '��������',
			field: 'VarianceQty',
			width: 100,
			align: 'right'
		}, {
			title: '��ǰ���',
			field: 'StkQty',
			width: 100,
			align: 'right'
		}, {
			title: '��λ',
			field: 'UomId',
			hidden: true
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 60
		}, {
			title: '����',
			field: 'BatchNo',
			width: 100
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			title: '������־',
			field: 'AdjFlag',
			width: 70,
			hidden: true
		}, {
			title: '��λ��',
			field: 'StkBinDesc',
			width: 60
		}, {
			title: '����',
			field: 'Rp',
			width: 60,
			align: 'right'
		}, {
			title: '���̽��',
			field: 'FreezeRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: 'ʵ�̽��',
			field: 'CountRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '������',
			field: 'VarianceRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '����',
			field: 'StkScgDesc',
			width: 100
		}, {
			title: '��Ӧ��',
			field: 'VendorDesc',
			width: 100
		}, {
			title: '������',
			field: 'StkCatDesc',
			width: 100
		}, {
			title: '������',
			field: 'SpecDesc',
			width: 70,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm',
			query2JsonStrict: 1
		},
		columns: DetailGridCm
	});
	Clear();
	Query();
};
$(init);