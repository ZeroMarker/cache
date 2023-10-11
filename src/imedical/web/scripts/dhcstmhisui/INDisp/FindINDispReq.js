var SelReqWin = function(Fn, DispLoc) {
	$HUI.dialog('#SelReqWin', {
		height: gWinHeight,
		width: gWinWidth
	}).open();
	var LocParams = JSON.stringify(addSessionParams({
		Type: 'LeadLoc',
		LocId: DispLoc
	}));
	var LocBox = $HUI.combobox('#ToLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$('#ReqGrpList').combobox('clear');
			$('#ReqGrpList').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetLocGrp&ResultSetType=Array&Params='
				+ JSON.stringify({
					SubLoc: LocId
				})
			);
		}
	});
	// 专业组
	var GrpListBox = $HUI.combobox('#ReqGrpList', {
		url: '',
		valueField: 'RowId',
		textField: 'Description'
	});

	var MainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '单号',
			field: 'DsrqNo',
			width: 150
		}, {
			title: '接收科室',
			field: 'LocDesc',
			width: 150
		}, {
			title: '领用人',
			field: 'ReqUser',
			width: 100
		}, {
			title: '专业组',
			field: 'GrpDesc',
			width: 100
		}, {
			title: '制单日期',
			field: 'CreateDate',
			width: 100
		}, {
			title: '制单时间',
			field: 'CreateTime',
			width: 100
		}, {
			title: '发放类型',
			field: 'ReqMode',
			width: 100,
			formatter: function(value, row, index) {
				if (value == 1) {
					return '个人';
				} else {
					return '专业组';
				}
			}
		}, {
			title: '备注',
			field: 'Remark',
			width: 100
		}, {
			title: '状态',
			field: 'Status',
			width: 100,
			formatter: MainStatusFormatter
		}
	]];
	function MainStatusFormatter(value) {
		var status = value;
		if (value == 'C') {
			status = '已处理';
		} else if (value == 'O') {
			status = '待处理';
		} else if (value == 'X') {
			status = '已取消';
		} else if (value == 'R') {
			status = '已拒绝';
		}
		return status;
	}
	var MainGrid = $UI.datagrid('#ReqMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispReq',
			QueryName: 'DHCINDispReq',
			query2JsonStrict: 1
		},
		columns: MainCm,
		onSelect: function(index, row) {
			$UI.clear(DetailGrid);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
				QueryName: 'DHCINDispReqItm',
				query2JsonStrict: 1,
				Parref: row.RowId,
				rows: 9999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				MainGrid.selectRow(0);
			}
		}
	});

	var ToolBar = [{
		text: '拒绝',
		iconCls: 'icon-audit-x',
		handler: function() {
			var Rows = DetailGrid.getChecked();
			if (Rows.length <= 0) {
				$UI.msg('alert', '请选择要拒绝的明细!');
				return;
			}
			$UI.confirm('您将要拒绝单据,是否继续?', '', '', DenyReqItm);
		}
	}];
	var DetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: 'IncId',
			field: 'IncId',
			width: 50,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 150
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '请领数量',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '发放科室库存',
			field: 'StkQty',
			width: 100,
			align: 'right'
		}, {
			title: '已制单数量',
			field: 'DispMadeQty',
			width: 100,
			align: 'right'
		}, {
			title: '已发放数量',
			field: 'DispedQty',
			width: 100,
			align: 'right'
		}, {
			title: '发放数量',
			field: 'DispQty',
			width: 100,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					tipPosition: 'bottom',
					required: true,
					precision: GetFmtNum('FmtQTY')
				}
			}
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80
		}, {
			title: '进价',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'SpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 200
		}, {
			title: '备注',
			field: 'Remark',
			width: 100
		}, {
			title: '状态',
			field: 'Status',
			width: 100,
			formatter: DetailStatusFormatter
		}
	]];
	function DetailStatusFormatter(value) {
		var status = value;
		if (value == 'G') {
			status = '未发放';
		} else if (value == 'D') {
			status = '已发放';
		} else if (value == 'X') {
			status = '已取消';
		} else if (value == 'R') {
			status = '已拒绝';
		}
		return status;
	}
	var DetailGrid = $UI.datagrid('#ReqDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
			QueryName: 'DHCINDispReqItm',
			query2JsonStrict: 1
		},
		columns: DetailCm,
		pagination: false,
		toolbar: ToolBar,
		singleSelect: false,
		checkOnSelect: false,
		onClickRow: function(index, row) {
			DetailGrid.commonClickRow(index, row);
		}
	});

	$UI.linkbutton('#ReqQueryBT', {
		onClick: function() {
			ReqQuery();
		}
	});
	function ReqQuery() {
		var ParamsObj = $UI.loopBlock('#ReqConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '起始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.LocId)) {
			$UI.msg('alert', '请选择接收科室!');
			return;
		}
		//	ParamsObj.Status = "O";
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		MainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINDispReq',
			QueryName: 'DHCINDispReq',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#ReqClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#ReqSelectBT', {
		onClick: function() {
			SaveDispByReq();
		}
	});
	$UI.linkbutton('#ReqDenyBT', {
		onClick: function() {
			var Row = MainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择请领单!');
				return;
			}
			$UI.confirm('您将要拒绝单据,是否继续?', '', '', DenyReq);
		}
	});
	function DenyReq() {
		var Row = MainGrid.getSelected();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDispReq',
			MethodName: 'DenyReq',
			Dsrq: Row.RowId
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Clear();
				MainGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function DenyReqItm(Params) {
		var Row = MainGrid.getSelected();
		var Params = DetailGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
			MethodName: 'DenyReqItm',
			Dsrq: Row.RowId,
			Params: JSON.stringify(Params)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				DetailGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function SaveDispByReq() {
		if (!DetailGrid.endEditing()) {
			return;
		}
		var SelectedRow = MainGrid.getSelected();
		if (isEmpty(SelectedRow)) {
			$UI.msg('alert', '请选择请领单!');
			return;
		}
		var Main = JSON.stringify(SelectedRow);
		var Rows = DetailGrid.getChecked();
		if (Rows.length <= 0) {
			$UI.msg('alert', '请选择请领单明细!');
			return;
		}
		for (var i = 0; i < Rows.length; i++) {
			var InciDesc = Rows[i].InciDesc;
			var StkQty = Rows[i].StkQty;	// 库存
			if (isEmpty(Rows[i].DispQty) || Rows[i].DispQty <= 0) {
				$UI.msg('alert', '请输入' + InciDesc + '的发放数量!');
				return;
			}
			if (Number(Rows[i].DispQty) > Number(StkQty)) {
				$UI.msg('alert', InciDesc + '的发放数量大于库存,请修改!');
				return;
			}
		}
		var Detail = DetailGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			MethodName: 'SaveDispByReq',
			Main: Main,
			Detail: JSON.stringify(Detail),
			UserId: gUserId,
			DispLoc: DispLoc
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Fn(jsonData.rowid);
				$HUI.dialog('#SelReqWin').close();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function Clear() {
		$UI.clearBlock('#ReqConditions');
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			LocId: $('#LocId').combo('getValue'),
			CompFlag: 'Y'
		};
		$UI.fillBlock('#ReqConditions', DefaultData);
	}

	Clear();
	ReqQuery();
};