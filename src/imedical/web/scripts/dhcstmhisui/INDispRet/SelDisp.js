var FrLocId = '';
var SelDisp = function(Fn, HVFlag) {
	if (HVFlag == undefined) {
		HVFlag = '';
	}
	$HUI.dialog('#DispWin', { width: gWinWidth, height: gWinHeight }).open();
	var LocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'LocId',
		LoginLocType: 2
	}));
	var LocBox = $HUI.combobox('#FrLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			FrLocId = record['RowId'];
			$('#ToLoc').combobox('clear');
			$('#ToLoc').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
				+ JSON.stringify(addSessionParams({
					Type: 'LeadLoc',
					LocId: FrLocId,
					Element: 'ToLoc'
				})));
		}
	});
	FrLocId = $('#FrLoc').combobox('getValue');
	// 接收科室
	var ToLocParams = JSON.stringify(addSessionParams({
		Type: 'LeadLoc',
		LocId: FrLocId,
		Element: 'ReqLoc'
	}));
	var ToLocBox = $HUI.combobox('#ToLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ToLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var DispMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '单号',
			field: 'IndsNo',
			width: 150
		}, {
			title: '接收科室',
			field: 'ReqLoc',
			width: 150
		}, {
			title: '领用人',
			field: 'RecUser',
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
			field: 'DispMode',
			width: 100,
			formatter: function(value, row, index) {
				if (value == 1) {
					return '个人';
				} else {
					return '专业组';
				}
			}
		}, {
			title: '单据备注',
			field: 'Remark',
			width: 100
		}
	]];
	var DispMasterGrid = $UI.datagrid('#DispMasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			QueryName: 'DHCINDisp',
			query2JsonStrict: 1
		},
		columns: DispMainCm,
		onSelect: function(index, row) {
			$UI.clear(DispDetailGrid);
			DispDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINDispItm',
				QueryName: 'DHCINDispItm',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				DispMasterGrid.selectRow(0);
			}
		}
	});

	var DispDetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 50,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
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
			title: '高值条码',
			field: 'HVBarCode',
			width: 200
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 100
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '发放数量',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80
		}, {
			title: '进价',
			field: 'Rp',
			width: 80,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 200
		}, {
			title: '物品备注',
			field: 'Remark',
			width: 100
		}, {
			title: '可退数量',
			field: 'AvaRetQty',
			width: 80,
			align: 'right'
		}, {
			title: '已退占用',
			field: 'DisRetQty',
			width: 80,
			align: 'right',
			hidden: true
		}
	]];
	var DispDetailGrid = $UI.datagrid('#DispDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispItm',
			QueryName: 'DHCINDispItm',
			query2JsonStrict: 1
		},
		columns: DispDetailCm
	});

	$UI.linkbutton('#FDispQueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#FDispConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '起始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.LocId)) {
			$UI.msg('alert', '请选择发放科室!');
			return;
		}
		var AuditFlag = 'Y';
		var ParamsObject = $.extend(ParamsObj, { HVFlag: HVFlag, AuditFlag: AuditFlag });
		var Params = JSON.stringify(ParamsObject);
		$UI.clear(DispMasterGrid);
		$UI.clear(DispDetailGrid);
		DispMasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			QueryName: 'DHCINDisp',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#FDispClearBT', {
		onClick: function() {
			FDispClear();
		}
	});
	// 选取
	$UI.linkbutton('#FDispSelBT', {
		onClick: function() {
			var Row = DispMasterGrid.getSelected();
			var DetailObj = DispDetailGrid.getSelections();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要退回的发放单!');
				return;
			}
			var DetailNewObj = [];
			var DspiStr = '';
			for (var i = 0; i < DetailObj.length; i++) {
				var InciCode = DetailObj[i].InciCode;
				var AvaRetQty = DetailObj[i].AvaRetQty;
				if (AvaRetQty <= 0) {
					$UI.msg('alert', InciCode + '可退数量小于或等于0!');
					return;
				}
				if (DspiStr = '') {
					DspiStr = DetailObj[i].RowId;
				} else {
					DspiStr = DspiStr + '^' + DetailObj[i].RowId;
				}
			}
			var Params = JSON.stringify(addSessionParams({ Dsp: Row.RowId, DspiStr: DspiStr }));
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDispRet',
				MethodName: 'jsSaveByDisp',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					Fn(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
			$HUI.dialog('#DispWin').close();
		}
	});

	function FDispClear() {
		$UI.clearBlock('#FDispConditions');
		$UI.clear(DispMasterGrid);
		$UI.clear(DispDetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			LocId: gLocId
		};
		$UI.fillBlock('#FDispConditions', DefaultData);
	}

	FDispClear();
	Query();
};