// �̵����
var init = function() {
	// =======================������ʼ��start==================
	
	// ����
	var LocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	if (InStkTkParamObj.AllLoc == 'Y') {
		LocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	}
	$HUI.combobox('#FLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#FStkTkComp', {
		data: [{ 'RowId': '', 'Description': 'ȫ��' }, { 'RowId': 'N', 'Description': 'δ���' }, { 'RowId': 'Y', 'Description': '�����' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	// ===========================������ʼend===========================
	// ======================tbar�����¼�start=========================
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
		ParamsObj.FInstComp = 'Y';
		ParamsObj.FAdjComp = 'N';
		ParamsObj.FInputFlag = 'Y';
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		$UI.clear(InstItmGrid);
		$UI.clear(InstDetailGrid);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	// ȡ�����
	$UI.linkbutton('#CancelCompleteBT', {
		onClick: function() {
			CancelComplete();
		}
	});
	function CancelComplete() {
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
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'jsStkCancelComplete',
			Inst: row.RowId
		}, function(jsonData) {
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// ȷ�����
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
		if (row.StkTkCompFlag == 'Y') {
			$UI.msg('alert', '�̵㵥�Ѿ��������!');
			return;
		}
		var clName = '';
		var mName = '';
		if (row.InputType == 1) {
			clName = 'web.DHCSTMHUI.INStkTkItmWd';
			mName = 'jsCompleteWd';
		} else if (row.InputType == 2) {
			clName = 'web.DHCSTMHUI.InStkTkInput';
			mName = 'jsCompleteInput';
		} else if (row.InputType == 3) {
			clName = 'web.DHCSTMHUI.INStkTkItmTrack';
			mName = 'jsCompleteItmTrack';
		}
		showMask();
		$.cm({
			ClassName: clName,
			MethodName: mName,
			Inst: row.RowId,
			UserId: gUserId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// ����
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		var DefaultData = {
			FLoc: gLocObj,
			FStartDate: DateFormatter(new Date()),
			FEndDate: DateFormatter(new Date()),
			FInstComp: 'Y',
			FStkTkComp: 'N',
			FAdjComp: 'N'
		};
		$UI.fillBlock('#Conditions', DefaultData);
	}
	// �������ʻ�����Ϣ
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
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			QueryName: 'CollectItmCountQty',
			query2JsonStrict: 1,
			Inst: row.RowId
		});
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
			width: 80
		}, {
			title: '����',
			field: 'LocDesc',
			width: 150
		}, {
			title: '�������',
			field: 'CompFlag',
			width: 80,
			hidden: true
		}, {
			title: 'ʵ�����',
			field: 'StkTkCompFlag',
			width: 80,
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
			width: 80,
			hidden: true
		}, {
			title: '��־',
			field: 'ManaFlag',
			width: 80,
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
			title: '¼������',
			field: 'InputType',
			width: 100,
			formatter: InputTypeFormatter
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
			width: 80,
			align: 'right'
		}, {
			title: '��ֵ��־',
			field: 'HVFlag',
			width: 80
		}
	]];
	var MasterGrid = $UI.datagrid('#MasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
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
	// ===========================================���ʻ���============================
	var DetailGridCm = [[
		{
			title: 'Inst',
			field: 'Inst',
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
			field: 'FreezeQty',
			width: 100,
			align: 'right'
		}, {
			title: 'ʵ������',
			field: 'CountQty',
			width: 100,
			align: 'right'
		}, {
			title: '���½���',
			field: 'LastRp',
			width: 100,
			align: 'right'
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			QueryName: 'CollectItmCountQty',
			query2JsonStrict: 1
		},
		columns: DetailGridCm,
		sortName: 'InciCode',
		sortOrder: 'asc',
		fitColumns: true,
		onSelect: function(index, row) {
			loadInstItmGrid();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#DetailGrid').datagrid('selectRow', 0);
			}
		}
	});
	function loadInstItmGrid() {
		var Detailrow = $('#DetailGrid').datagrid('getSelected');
		if (isEmpty(Detailrow)) {
			$UI.msg('alert', '��ѡ������!');
			return;
		}
		if (isEmpty(Detailrow.InciId)) {
			$UI.msg('alert', '��������!');
			return;
		}
		InstDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'QueryItmTkWdDetail',
			Inst: Detailrow.Inst,
			Inci: Detailrow.InciId,
			rows: 99999
		});
		InstItmGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'QueryItmTkWd',
			Inst: Detailrow.Inst,
			Inci: Detailrow.InciId,
			rows: 99999
		});
	}
	// =============================���λ���=======================================
	var InstItmGridCm = [[
		{
			title: 'Insti',
			field: 'Insti',
			width: 100,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 100,
			hidden: true
		}, {
			title: '����',
			field: 'BatNo',
			width: 100
		}, {
			title: 'Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			title: '��λ',
			field: 'FreezeUomDesc',
			width: 80
		}, {
			title: '��������',
			field: 'FreezeQty',
			width: 100,
			align: 'right'
		}, {
			title: 'ʵ������',
			field: 'CountQty',
			width: 100,
			align: 'right'
		}
	]];
	var InstItmGrid = $UI.datagrid('#InstItmGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'QueryItmTkWd'
		},
		pagination: false,
		columns: InstItmGridCm
	});
	// ====================������ϸ=====================
	var InstDetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 100
		}, {
			title: 'Inclb',
			field: 'Inclb',
			hidden: true,
			width: 100
		}, {
			title: '����',
			field: 'BatNo',
			width: 100
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			title: '��λ',
			field: 'CountUom',
			width: 80
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
			width: 100
		}, {
			title: 'ʵ����',
			field: 'CountUserName',
			width: 100
		}
	]];
	var InstDetailGrid = $UI.datagrid('#InstDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'QueryItmTkWdDetail'
		},
		columns: InstDetailGridCm,
		pagination: false
	});
	Clear();
	Query();
};
$(init);