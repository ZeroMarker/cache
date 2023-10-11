/*
红冲制单查询
*/
var RedFind = function(Fn) {
	$HUI.dialog('#FindWin', {
		height: gWinHeight,
		width: gWinWidth
	}).open();
	// 红冲科室
	var FRedLocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'FRedLoc',
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				FVendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				FVendorBox.reload(url);
			}
		}
	}));
	var FRedLocBox = $HUI.combobox('#FRedLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRedLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	// 供应商
	var FVendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var FVendorBox = $HUI.combobox('#FVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			FQuery();
		}
	});
	function FQuery() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.RedLoc)) {
			$UI.msg('alert', '红冲科室不能为空!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(RedDetailGrid);
		RedMainGrid.load({
			ClassName: 'web.DHCSTMHUI.RedOffset',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#FClearBT', {
		onClick: function() {
			FClear();
		}
	});
	var FClear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(RedMainGrid);
		$UI.clear(RedDetailGrid);
		// /设置初始值 考虑使用配置
		var LocId = $('#RedLoc').combobox('getValue');
		var LocDesc = $('#RedLoc').combobox('getText');
		var Dafult = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			RedLoc: { RowId: LocId, Description: LocDesc },
			AuditFlag: 'N'
		};
		$UI.fillBlock('#FindConditions', Dafult);
	};
	$UI.linkbutton('#FSelectBT', {
		onClick: function() {
			var Row = RedMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的红冲单!');
				return;
			}
			Fn(Row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});
	var RedMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '红冲单号',
			field: 'RedNo',
			width: 150
		}, {
			title: '红冲科室',
			field: 'RedLoc',
			width: 150
		}, {
			title: '供应商',
			field: 'Vendor',
			width: 150
		}, {
			title: '创建人',
			field: 'CreateUser',
			width: 100
		}, {
			title: '创建日期',
			field: 'CreateDate',
			width: 100
		}, {
			title: 'CompFlag',
			field: 'CompFlag',
			width: 100,
			hidden: true
		}
	]];

	var RedMainGrid = $UI.datagrid('#RedMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.RedOffset',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: RedMainCm,
		showBar: true,
		singleSelect: false,
		onSelect: function(index, row) {
			RedDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.RedOffsetItm',
				QueryName: 'QueryDetail',
				query2JsonStrict: 1,
				Parref: row.RowId,
				rows: 99999
			});
		},
		onDblClickRow: function(index, row) {
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				RedMainGrid.selectRow(0);
			}
		}
	});

	var RedDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 160
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 180
		}, {
			title: '批次id',
			field: 'Inclb',
			width: 70,
			hidden: true
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 90
		}, {
			title: '有效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '单位',
			field: 'Uom',
			width: 80
		}, {
			title: '红冲数量',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '新进价',
			field: 'NewRp',
			width: 60,
			align: 'right'
		}, {
			title: '新售价',
			field: 'NewSp',
			width: 60,
			align: 'right'
		}, {
			title: '新进价金额',
			field: 'NewRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '新售价金额',
			field: 'NewSpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '原进价',
			field: 'OldRp',
			width: 60,
			align: 'right'
		}, {
			title: '原售价',
			field: 'OldSp',
			width: 60,
			align: 'right'
		}, {
			title: '原进价金额',
			field: 'OldRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '原售价金额',
			field: 'OldSpAmt',
			width: 100,
			align: 'right'
		}
	]];
	var RedDetailGrid = $UI.datagrid('#RedDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.RedOffsetItm',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: RedDetailCm,
		showBar: true,
		onClickRow: function(index, row) {
			RedDetailGrid.commonClickRow(index, row);
		}
	});
	FClear();
	FQuery();
};