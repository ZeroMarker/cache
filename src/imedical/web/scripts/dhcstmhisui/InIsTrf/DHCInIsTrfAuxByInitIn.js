
var init = function() {
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});
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
			PrintInIsTrf(RowId);
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
			PrintInIsTrf(RowId);
		}
	});
	
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var SelectedRow = MasterGrid.getSelected();
			if (isEmpty(SelectedRow)) {
				$UI.msg('alert', '请选择需要出库的单据!');
				return;
			}
			var ToLoc = $('#ToLoc').combobox('getValue');
			if (isEmpty(ToLoc)) {
				$UI.msg('alert', '科室不可为空!');
				return;
			}
			var InitToLoc = $('#AuxToLoc').combobox('getValue');
			if (isEmpty(InitToLoc)) {
				$UI.msg('alert', '接收科室不可为空!');
				return;
			}
			if (ToLoc == InitToLoc) {
				$UI.msg('alert', '出库科室不允许与接收科室相同!');
				return;
			}
			var InitScg = SelectedRow['ScgId'];
			var HvFlag = SelectedRow['IsHVFlag'];
			var MainObj = { InitFrLoc: ToLoc, InitToLoc: InitToLoc, InitComp: 'N', InitState: '10', InitUser: gUserId,
				InitScg: InitScg };
			var Main = JSON.stringify(addSessionParams(MainObj));
			var Rows = DetailGrid.getSelections();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择需要出库的明细!');
				return;
			}
			
			var DetailArr = [];
			for (var i = 0, Len = Rows.length; i < Len; i++) {
				var Row = Rows[i];
				var Inclb = Row['Inclb'], UomId = Row['UomId'], OperQty = Row['OperQty'], HVBarCode = Row['HVBarCode'];
				var InitiData = { RowId: '', Inclb: Inclb, UomId: UomId, Qty: OperQty, HVBarCode: HVBarCode };
				DetailArr.push(InitiData);
			}
			var Detail = JSON.stringify(DetailArr);
			if (Detail === false) {
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				MethodName: 'jsSave',
				Main: Main,
				Detail: Detail
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.clear(DetailGrid);
					$UI.msg('success', jsonData.msg);
					var InitId = jsonData.rowid;
					if (HvFlag == 'N') {
						var UrlStr = 'dhcstmhui.dhcinistrf.csp?RowId=' + InitId;
					} else {
						var UrlStr = 'dhcstmhui.dhcinistrfhv.csp?RowId=' + InitId;
					}
					Common_AddTab('出库', UrlStr);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
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
	
	var AuxToLoc = $HUI.combobox('#AuxToLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ Type: 'All', Element: 'AuxToLoc' })),
		valueField: 'RowId',
		textField: 'Description'
	});

	var MasterCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 60,
			hidden: true
		}, {
			title: '单号',
			field: 'InitNo',
			align: 'left',
			width: 150,
			sortable: true
		}, {
			title: '出库科室',
			field: 'FrLocDesc',
			width: 150,
			sortable: true
		}, {
			title: '接收科室',
			field: 'ToLocDesc',
			width: 150
		}, {
			title: '请求单号',
			field: 'ReqNo',
			width: 150
		}, {
			title: '制单时间',
			field: 'InitDateTime',
			width: 160
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
			width: 100
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
			// var ParamsObj = {Init:Init, InitType:'T'};
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
				QueryName: 'InitToLocDetail',
				query2JsonStrict: 1,
				Init: Init,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				MasterGrid.selectRow(0);
			}
		}
	});

	function Query() {
		$UI.clear(DetailGrid);
		$UI.clear(MasterGrid);
		var ParamsObj = $UI.loopBlock('Conditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
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

	var DetailCm = [[
		{
			field: 'Check',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 60,
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
			saveCol: true,
			width: 150
		}, {
			title: 'Inclb',
			field: 'Inclb',
			saveCol: true,
			width: 100,
			hidden: true
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
			title: '接收数量',
			field: 'Qty',
			align: 'right',
			width: 80
		}, {
			title: '业务数量',
			field: 'OperQty',
			saveCol: true,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			},
			width: 80
		}, {
			title: '单位Id',
			field: 'UomId',
			saveCol: true,
			width: 50,
			hidden: true
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
			QueryName: 'InitToLocDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: DetailCm,
		showBar: true,
		remoteSort: false,
		singleSelect: false,
		onBeforeSelect: function(index, row) {
			var Qty = Number(row['Qty']);
			var AvaQty = Number(row['InclbAvaQty']);
			var OperQty = Math.min(Qty, AvaQty);
			if (OperQty <= 0) {
				$UI.msg('alert', '可用数量不足!');
				return;
			}
		},
		onCheck: function(index, row) {
			var Qty = Number(row['Qty']);
			var AvaQty = Number(row['InclbAvaQty']);
			var OperQty = Math.min(Qty, AvaQty);
			row['OperQty'] = OperQty;
			$(this).datagrid('refreshRow', index);
		},
		onUncheck: function(index, row) {
			row['OperQty'] = '';
			$(this).datagrid('refreshRow', index);
		},
		onCheckAll: function(rows) {
			for (var i = 0; i < rows.length; i++) {
				var row = rows[i];
				var Qty = Number(row['Qty']);
				var AvaQty = Number(row['InclbAvaQty']);
				var OperQty = Math.min(Qty, AvaQty);
				row['OperQty'] = OperQty;
				var RowIndex = $(this).datagrid('getRowIndex', row);
				$(this).datagrid('refreshRow', RowIndex);
			}
		},
		onUncheckAll: function(rows) {
			for (var i = 0; i < rows.length; i++) {
				var row = rows[i];
				row['OperQty'] = '';
				var RowIndex = $(this).datagrid('getRowIndex', row);
				$(this).datagrid('refreshRow', RowIndex);
			}
		}
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