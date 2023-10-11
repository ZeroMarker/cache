
function OutReq(Fn) {
	$HUI.dialog('#OutReqWin', {
		height: gWinHeight,
		width: gWinWidth
	}).open();
	$HUI.combobox('#SelReqRecLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ Type: 'All' })),
		valueField: 'RowId',
		textField: 'Description'
	});
	var SelReqHandlerParams = function() {
		var ToLoc = $('#SelReqRecLoc').combobox('getValue');
		var Obj = { StkGrpType: 'M', ToLoc: ToLoc };
		return Obj;
	};
	$UI.linkbutton('#OutReqQueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#OutReqConditions');
			ParamsObj.Status = 31;
			ParamsObj.ToReturnFlag = 'Y';
			var Params = JSON.stringify(ParamsObj);
			$UI.clear(OutReqMasterGrid);
			$UI.clear(OutReqDetailGrid);
			OutReqMasterGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				QueryName: 'DHCINIsTrfM',
				query2JsonStrict: 1,
				Params: Params
			});
		}
	});
	var FrLoc = $HUI.combobox('#FrLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ Type: 'Login', Element: 'FrLoc' })),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$('#CreateUser').combobox('clear');
			$('#CreateUser').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
				+ JSON.stringify({ LocDr: LocId })
			);
		}
	});
	$('#FrLoc').combobox('setValue', session['LOGON.CTLOCID']);
	
	var ToLoc = $HUI.combobox('#ToLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ Type: 'All', Element: 'ToLoc' })),
		valueField: 'RowId',
		textField: 'Description'
	});
	// 清屏
	$UI.linkbutton('#OClearBT', {
		onClick: function() {
			$UI.clearBlock('OutReqConditions');
			$UI.clear(OutReqMasterGrid);
			$UI.clear(OutReqDetailGrid);
			OutReqDefa();
		}
	});
	// 选取
	$UI.linkbutton('#OComBT', {
		onClick: function() {
			var Row = OutReqMasterGrid.getSelected();
			var DetailObj = OutReqDetailGrid.getSelections();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的出库单!');
				return;
			}
			var DetailNewObj = [];
			var DetailId = '';
			for (var i = 0; i < DetailObj.length; i++) {
				if (DetailId == '') {
					DetailId = DetailObj[i].RowId;
				} else {
					DetailId = DetailId + '^' + DetailObj[i].RowId;
				}
			}
			var Params = JSON.stringify(addSessionParams({ Init: Row.RowId, DetailId: DetailId }));
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				MethodName: 'jsCreateInIsTrf',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					Fn(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
			$UI.clear(OutReqMasterGrid);
			$UI.clear(OutReqDetailGrid);
			// Fn(Row.RowId)
			$HUI.dialog('#OutReqWin').close();
		}
	});

	// 默认的时间
	function OutReqDefa() {
		var DefaultData = {
			StartDate: DateFormatter(DateAdd(new Date(), 'd', -7)),
			EndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#OutReqConditions', DefaultData);
	}

	var OutReqMasterCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: '单号',
			field: 'InitNo',
			align: 'left',
			width: 150,
			sortable: true
		}, {
			title: '出库库房',
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
	var OutReqMasterGrid = $UI.datagrid('#OutReqMasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			query2JsonStrict: 1
		},
		columns: OutReqMasterCm,
		onSelect: function(index, row) {
			var Init = row['RowId'];
			var ParamsObj = { Init: Init, InitType: 'T', ToReturnFlag: 'Y' };
			$UI.clear(OutReqDetailGrid);
			OutReqDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
				QueryName: 'DHCINIsTrfD',
				query2JsonStrict: 1,
				Params: JSON.stringify(ParamsObj)
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				OutReqMasterGrid.selectRow(0);
			}
		}
	});
	var OutReqDetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 80,
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

	var OutReqDetailGrid = $UI.datagrid('#OutReqDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			query2JsonStrict: 1
		},
		columns: OutReqDetailCm,
		singleSelect: false
	});
	OutReqDefa();
	$('#OutReqQueryBT').click();
}