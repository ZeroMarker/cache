var init = function() {
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	// 发放科室
	var DispLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'DispLoc' }));
	var DispLocBox = $HUI.combobox('#DispLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + DispLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	// 接收科室
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'ReqLoc' }));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$('#UserList').combobox('clear');
			$('#GrpList').combobox('clear');
			$('#UserList').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
				+ JSON.stringify({
					LocDr: LocId
				}));
			$('#GrpList').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetLocGrp&ResultSetType=Array&Params='
				+ JSON.stringify({
					SubLoc: LocId
				}));
		}
	});
	// 类组
	$('#StkGrp').stkscgcombotree({
		onSelect: function(node) {
			$.cm({
				ClassName: 'web.DHCSTMHUI.Common.Dicts',
				QueryName: 'GetStkCat',
				ResultSetType: 'array',
				StkGrpId: node.id
			}, function(data) {
				StkCatBox.clear();
				StkCatBox.loadData(data);
			});
		}
	});
	// 库存分类
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	// 物资名称
	var HandlerParams = function() {
		var Scg = $('#StkGrp').combotree('getValue');
		var Loc = $('#DispLoc').combo('getValue');
		var Obj = { StkGrpRowId: Scg, StkGrpType: 'M', Locdr: Loc };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	// 专业组
	var GrpListBox = $HUI.combobox('#GrpList', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			var ReqLocId = $('#ReqLoc').combo('getValue');
			if (ReqLocId == '') {
				$UI.msg('alert', '请先选择接收科室');
				return;
			}
			GrpListBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetLocGrp&ResultSetType=array&Params=' + JSON.stringify({ SubLoc: ReqLocId });
			GrpListBox.reload(url);
		}
	});
	// 领用人
	var UserListBox = $HUI.combobox('#UserList', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			var ReqLocId = $('#ReqLoc').combo('getValue');
			if (ReqLocId == '') {
				$UI.msg('alert', '请先选择接收科室');
				return;
			}
			UserListBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array&Params=' + JSON.stringify({ LocDr: ReqLocId });
			UserListBox.reload(url);
		}
	});

	// 发放列表
	var MainCm = [[
		{
			title: 'Inci',
			field: 'Inci',
			width: 50,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: '品牌',
			field: 'Brand',
			width: 80
		}, {
			title: '型号',
			field: 'Model',
			width: 80
		}, {
			title: '发放数量',
			field: 'QtyUom',
			width: 100,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '收费标志',
			field: 'ChargeFlag',
			width: 80,
			formatter: function(value, row, index) {
				if (value == 'Y') {
					return '是';
				} else {
					return '否';
				}
			}
		}
	]];
	var MainGrid = $UI.datagrid('#MainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.SubLocMatStat',
			QueryName: 'INDispStat',
			query2JsonStrict: 1
		},
		columns: MainCm,
		showBar: true,
		fitColumns: true,
		onSelect: function(index, row) {
			$UI.clear(DetailGrid);
			var ParamsObj = $UI.loopBlock('#Conditions');
			ParamsObj.Inci = row.Inci;
			var Params = JSON.stringify(ParamsObj);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.SubLocMatStat',
				QueryName: 'INDispDetailStat',
				query2JsonStrict: 1,
				Params: Params
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				MainGrid.selectRow(0);
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
			title: '业务类型',
			field: 'Type',
			width: 80,
			formatter: function(value, row, index) {
				if (value == 'C') {
					return '发放';
				} else if (value == 'L') {
					return '退回';
				} else {
					return value;
				}
			}
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 100
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '规格',
			field: 'Spec',
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
			title: '发放单号',
			field: 'IndsNo',
			width: 200
		}, {
			title: '发放日期',
			field: 'DispDate',
			width: 100
		}, {
			title: '请领单号',
			field: 'DsrqNo',
			width: 200
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.SubLocMatStat',
			QueryName: 'INDispDetailStat',
			query2JsonStrict: 1
		},
		columns: DetailCm,
		showBar: true
	});
	// 领用列表
	var ReqMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '业务类型',
			field: 'Type',
			width: 80,
			formatter: function(value, row, index) {
				if (value == 'C') {
					return '发放';
				} else if (value == 'L') {
					return '退回';
				} else {
					return value;
				}
			}
		}, {
			title: '领用日期',
			field: 'DispDate',
			width: 100
		}, {
			title: '领用人',
			field: 'Receiver',
			width: 100
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 100
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
			title: '领用数量',
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
			title: '发放单号',
			field: 'IndsNo',
			width: 100
		}, {
			title: '发放日期',
			field: 'DispDate',
			width: 100
		}, {
			title: '请领单号',
			field: 'DsrqNo',
			width: 100
		}
	]];
	var ReqMainGrid = $UI.datagrid('#ReqMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.SubLocMatStat',
			QueryName: 'INDispDetailStat',
			query2JsonStrict: 1
		},
		columns: ReqMainCm,
		showBar: true
	});
	// 发放公支

	$HUI.tabs('#tabs', {
		onSelect: function(title) {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var Params = JSON.stringify(ParamsObj);
			if (title == '发放列表') {
				MainGrid.load({
					ClassName: 'web.DHCSTMHUI.SubLocMatStat',
					QueryName: 'INDispStat',
					query2JsonStrict: 1,
					Params: Params
				});
			} else if (title == '领用列表') {
				ReqMainGrid.load({
					ClassName: 'web.DHCSTMHUI.SubLocMatStat',
					QueryName: 'INDispDetailStat',
					query2JsonStrict: 1,
					Params: Params
				});
			} else if (title == '发放公支') {
				Params = encodeUrlStr(Params);
				var url = PmRunQianUrl + '?reportName=DHCSTM_HUI_SubLocDispAllotStat.raq&Params=' + Params;
				var currTab = $('#tabs').tabs('getSelected');
				$('#tabs').tabs('update', {
					tab: currTab,
					options: {
						content: CreateFrame(url)
					}
				});
			} else if (title == '发放消耗明细') {
				Params = encodeUrlStr(Params);
				var url = PmRunQianUrl + '?reportName=DHCSTM_HUI_SubLocDispAndOeori.raq&Params=' + Params;
				var currTab = $('#tabs').tabs('getSelected');
				$('#tabs').tabs('update', {
					tab: currTab,
					options: {
						content: CreateFrame(url)
					}
				});
			} else if (title == '按物资') {
				Params = encodeUrlStr(Params);
				var url = PmRunQianUrl + '?reportName=DHCSTM_HUI_LocDispStatAll_INCI_Common.raq&Params=' + Params;
				var currTab = $('#tabs').tabs('getSelected');
				$('#tabs').tabs('update', {
					tab: currTab,
					options: {
						content: CreateFrame(url)
					}
				});
			} else if (title == '按库存分类') {
				Params = encodeUrlStr(Params);
				var url = PmRunQianUrl + '?reportName=DHCSTM_HUI_LocDispStatAll_STKCAT_Common.raq&Params=' + Params;
				var currTab = $('#tabs').tabs('getSelected');
				$('#tabs').tabs('update', {
					tab: currTab,
					options: {
						content: CreateFrame(url)
					}
				});
			} else if (title == '按接收科室') {
				Params = encodeUrlStr(Params);
				var url = PmRunQianUrl + '?reportName=DHCSTM_HUI_LocDispStatAll_RecLoc.raq&Params=' + Params;
				var currTab = $('#tabs').tabs('getSelected');
				$('#tabs').tabs('update', {
					tab: currTab,
					options: {
						content: CreateFrame(url)
					}
				});
			} else if (title == '供应商汇总') {
				Params = encodeUrlStr(Params);
				var url = PmRunQianUrl + '?reportName=DHCSTM_HUI_LocDispStatAll_VendorSum.raq&Params=' + Params;
				var currTab = $('#tabs').tabs('getSelected');
				$('#tabs').tabs('update', {
					tab: currTab,
					options: {
						content: CreateFrame(url)
					}
				});
			}
		}
	});

	function Query() {
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		$UI.clear(ReqMainGrid);
		var ParamsObj = $UI.loopBlock('#Conditions');
		var Params = JSON.stringify(ParamsObj);
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
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
		/* if (isEmpty(ParamsObj.DispLoc)) {
			$UI.msg('alert', '科室不能为空!');
			return;
		}*/
		var currTab = $('#tabs').tabs('getSelected');
		var index = $('#tabs').tabs('getTabIndex', currTab);
		if (index == 0) {
			MainGrid.load({
				ClassName: 'web.DHCSTMHUI.SubLocMatStat',
				QueryName: 'INDispStat',
				query2JsonStrict: 1,
				Params: Params
			});
		} else if (index == 1) {
			ReqMainGrid.load({
				ClassName: 'web.DHCSTMHUI.SubLocMatStat',
				QueryName: 'INDispDetailStat',
				query2JsonStrict: 1,
				Params: Params
			});
		} else if (index == 2) {
			Params = encodeUrlStr(Params);
			var url = PmRunQianUrl + '?reportName=DHCSTM_HUI_SubLocDispAllotStat.raq&Params=' + Params;
			$('#tabs').tabs('update', {
				tab: currTab,
				options: {
					content: CreateFrame(url)
				}
			});
		} else if (index == 3) {
			Params = encodeUrlStr(Params);
			var url = PmRunQianUrl + '?reportName=DHCSTM_HUI_SubLocDispAndOeori.raq&Params=' + Params;
			$('#tabs').tabs('update', {
				tab: currTab,
				options: {
					content: CreateFrame(url)
				}
			});
		}
	}

	function Clear() {
		$UI.clearBlock('#Conditions');
		$('#DispLoc').combobox('setValue', gLocId);
		$('#StartDate').datebox('setValue', DateFormatter(new Date()));
		$('#EndDate').datebox('setValue', DateFormatter(new Date()));
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		$UI.clear(ReqMainGrid);
	}

	Clear();
};
$(init);