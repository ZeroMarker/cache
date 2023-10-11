
var init = function() {
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(DetailGrid);
		$UI.clear(MasterGrid);
		var ParamsObj = $UI.loopBlock('Conditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj['ToLoc'])) {
			$UI.msg('alert', '库房不可为空!');
			return;
		}
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '截止日期不能小于开始日期!');
			return;
		}
		ParamsObj['DateType'] = '1';
		var Params = JSON.stringify(ParamsObj);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('Conditions');
			$UI.clear(DetailGrid);
			$UI.clear(MasterGrid);
			SetDefaValues();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var SelectedRow = MasterGrid.getSelected();
			if (isEmpty(SelectedRow)) {
				$UI.msg('alert', '请选择需要打印的单据!');
				return;
			}
			var RowId = SelectedRow['RowId'];
			PrintInIsTrfBC(RowId);
		}
	});

	var FrLoc = $HUI.combobox('#FrLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ Type: 'All', Element: 'FrLoc' })),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var FrLoc = record['RowId'];
			var ToLoc = $('#ToLoc').combobox('getValue');
			$HUI.combotree('#ScgId').setFilterByLoc(FrLoc, ToLoc);
		}
	});
	
	var ToLoc = $HUI.combobox('#ToLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ Type: 'Login', Element: 'ToLoc' })),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var ToLoc = record['RowId'];
			var FrLoc = $('#FrLoc').combobox('getValue');
			$HUI.combotree('#ScgId').setFilterByLoc(FrLoc, ToLoc);
		}
	});
	$('#ToLoc').combobox('setValue', session['LOGON.CTLOCID']);
	
	var Status = $('#Status').simplecombobox({
		data: [
			{ RowId: '10', Description: '未完成' },
			{ RowId: '11', Description: '已完成' },
			{ RowId: '20', Description: '出库审核不通过' },
			{ RowId: '21', Description: '出库审核通过' },
			{ RowId: '30', Description: '拒绝接收' },
			{ RowId: '31', Description: '已接收' }
		]
	});

	var MasterCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			hidden: true,
			width: 60
		}, {
			title: '单号',
			field: 'InitNo',
			align: 'left',
			width: 150,
			sortable: true
		}, {
			title: '退库科室',
			field: 'FrLocDesc',
			width: 150,
			sortable: true
		}, {
			title: '库房',
			field: 'ToLocDesc',
			width: 150
		}, {
			title: '请求单号',
			field: 'ReqNo',
			width: 150
		}, {
			title: '制单时间',
			field: 'InitDateTime',
			width: 150
		}, {
			title: '出库类型',
			field: 'OperateTypeDesc',
			width: 80
		}, {
			title: '单据状态',
			field: 'StatusCode',
			width: 70
		}, {
			title: '制单人',
			field: 'UserName',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 100
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 100
		}, {
			title: '进销差',
			field: 'MarginAmt',
			align: 'right',
			width: 100
		}, {
			title: '备注',
			field: 'Remark',
			width: 150
		}
	]];

	var MasterGrid = $UI.datagrid('#MasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			query2JsonStrict: 1
		},
		columns: MasterCm,
		showBar: true,
		onSelect: function(index, row) {
			var Init = row['RowId'];
			var ParamsObj = { Init: Init, InitType: 'T' };
			$UI.clear(DetailGrid);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
				QueryName: 'DHCINIsTrfD',
				query2JsonStrict: 1,
				Params: JSON.stringify(ParamsObj),
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				MasterGrid.selectRow(0);
			}
		}
	});

	var DetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 180
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: '高值条码',
			field: 'HVBarCode',
			width: 150
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 200
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '批次库存',
			field: 'InclbQty',
			align: 'right',
			width: 80
		}, {
			title: '出库数量',
			field: 'Qty',
			align: 'right',
			width: 80
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 50
		}, {
			title: '进价',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '售价',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 80
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 80
		}, {
			title: '灭菌批号',
			field: 'SterilizedBat',
			width: 160
		}, {
			title: '请求数量',
			field: 'ReqQty',
			align: 'right',
			width: 80
		}, {
			title: '请求方库存',
			field: 'ReqLocStkQty',
			align: 'right',
			width: 100
		}, {
			title: '占用数量',
			field: 'InclbDirtyQty',
			align: 'right',
			width: 100
		}, {
			title: '可用数量',
			field: 'InclbAvaQty',
			align: 'right',
			width: 100
		}
	]];

	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: DetailCm,
		showBar: true,
		remoteSort: false
	});
	
	// 设置缺省值
	function SetDefaValues() {
		$('#ToLoc').combobox('setValue', gLocId);
		$('#StartDate').datebox('setValue', DefaultStDate());
		$('#EndDate').datebox('setValue', DefaultEdDate());
	}
	
	SetDefaValues();
	Query();
};
$(init);