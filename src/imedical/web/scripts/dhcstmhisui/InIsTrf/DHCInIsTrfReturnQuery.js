
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
		ParamsObj['DateType'] = '1';
		// ParamsObj['Comp'] = 'Y';
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.ToLoc) && isEmpty(ParamsObj.FrLoc)) {
			$UI.msg('alert', '库房或科室不能为空!');
			return;
		}
		if ((!isEmpty(StartDate)) && (!isEmpty(EndDate)) && compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '截止日期不能小于开始日期!');
			return;
		}
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
			PrintInIsTrfReturn(RowId);
		}
	});
	$UI.linkbutton('#PrintHVColBT', {
		onClick: function() {
			var SelectedRow = MasterGrid.getSelected();
			if (isEmpty(SelectedRow)) {
				$UI.msg('alert', '请选择需要打印的单据!');
				return;
			}
			var RowId = SelectedRow['RowId'];
			PrintInIsTrfReturnHVCol(RowId);
		}
	});
	$UI.linkbutton('#ConfirmBT', {
		onClick: function() {
			var SelectedRow = MasterGrid.getSelected();
			if (isEmpty(SelectedRow)) {
				$UI.msg('alert', '请选择需要确认的单据!');
				return;
			}
			var RowId = SelectedRow['RowId'];
			var ConfirmFlag = SelectedRow['ConfirmFlag'];
			var InitNo = SelectedRow['InitNo'];
			if (ConfirmFlag == 'Y') {
				$UI.msg('alert', InitNo + '该单据已确认!');
				return;
			}
			Confirm(RowId);
		}
	});

	function Confirm(RowId) {
		var Params = JSON.stringify({ RowIdStr: RowId });
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsConfirm',
			Params: Params
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('alert', jsonData.msg);
			}
		}, false);
	}

	var InitFrLocParams, InitToLocParams;
	if (InitParamObj['DefaReturnLoc'] == '0') {		// 库房使用
		InitFrLocParams = JSON.stringify(addSessionParams({
			Type: 'Trans',
			Element: 'FrLoc'
		}));
		InitToLocParams = JSON.stringify(addSessionParams({
			Type: 'Login',
			Element: 'ToLoc'
		}));
	} else {	// 临床使用
		InitFrLocParams = JSON.stringify(addSessionParams({
			Type: 'Login',
			Element: 'FrLoc',
			LoginLocType: 2
		}));
		InitToLocParams = JSON.stringify(addSessionParams({
			Type: 'Trans',
			Element: 'ToLoc'
		}));
	}
	var ToLoc = $HUI.combobox('#ToLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ InitToLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			if (InitParamObj['DefaReturnLoc'] == '0') {
				var ToLocId = record['RowId'];
				$('#FrLoc').combobox('clear');
				$('#FrLoc').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
				+ JSON.stringify(addSessionParams({
					Type: 'Trans',
					LocId: ToLocId,
					TransLocType: 'T'
				})));
			}
		}
	});
	var FrLoc = $HUI.combobox('#FrLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params=' + InitFrLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			if (InitParamObj['DefaReturnLoc'] == '1') {
				var FrLocId = record['RowId'];
				$('#ToLoc').combobox('clear');
				$('#ToLoc').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
				+ JSON.stringify(addSessionParams({
					Type: 'Trans',
					LocId: FrLocId,
					TransLocType: 'F',
					Element: 'ToLoc'
				})));
				var DefaInfo = tkMakeServerCall('web.DHCSTMHUI.DHCTransferLocConf', 'GetDefLoc', FrLocId, gGroupId);
				var ToLocId = DefaInfo.split('^')[0], ToLocDesc = DefaInfo.split('^')[1];
				if (ToLocId && ToLocDesc) {
					AddComboData($('#ToLoc'), ToLocId, ToLocDesc);
					$('#ToLoc').combobox('setValue', ToLocId);
				}
			}
		}
	});

	var HandlerParams = function() {
		var ScgId = $('#ScgId').combotree('getValue');
		var FrLoc = $('#FrLoc').combobox('getValue');
		var ToLoc = $('#ToLoc').combobox('getValue');
		var Obj = { StkGrpRowId: ScgId, StkGrpType: 'M', Locdr: ToLoc, ToLoc: FrLoc, BDPHospital: gHospId };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	
	var MasterCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
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
		}, {
			title: '打印标记',
			field: 'PrintFlag',
			formatter: BoolFormatter,
			align: 'center',
			width: 100
		}, {
			title: '确认标记',
			field: 'ConfirmFlag',
			formatter: BoolFormatter,
			align: 'center',
			width: 100
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
			width: 50,
			hidden: true
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
			title: '国家医保编码',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '国家医保名称',
			field: 'MatInsuDesc',
			width: 160
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
		if (InitParamObj['DefaReturnLoc'] == '0') {
			$('#ToLoc').combobox('setValue', gLocId);
		} else {
			$('#FrLoc').combobox('setValue', gLocId);
		}
		$('#StartDate').datebox('setValue', DefaultStDate());
		$('#EndDate').datebox('setValue', DefaultEdDate());
	}
	
	SetDefaValues();
	Query();
};
$(init);