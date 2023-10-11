/* 库存动销查询*/
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
	
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			Print();
		}
	});
	var PhaLocParams = JSON.stringify(addSessionParams({ Type: 'Login', CTType: 'W,E,OP' }));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PhaLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#StkGrpId').setFilterByLoc(LocId);
		}
	});
	$('#StkGrpId').stkscgcombotree({
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
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var ScgId = $('#StkGrpId').combotree('getValue');
		var Obj = { StkGrpRowId: ScgId, StkGrpType: 'M', BDPHospital: gHospId };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	var StkQtyCm = [[
		{
			title: 'incil',
			field: 'incil',
			width: 80,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: '单位',
			field: 'PurUom',
			width: 70
		}, {
			title: '期初库存',
			field: 'StartQty',
			width: 100,
			align: 'right'
		}, {
			title: '期初金额',
			field: 'StartRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '入数量',
			field: 'InQty',
			hidden: true,
			width: 100,
			align: 'right'
		}, {
			title: '入金额',
			field: 'SumInRpAmt',
			hidden: true,
			width: 100,
			align: 'right'
		}, {
			title: '出数量',
			field: 'OutQty',
			hidden: true,
			width: 70,
			align: 'right'
		}, {
			title: '出金额',
			field: 'SumOutRpAmt',
			hidden: true,
			width: 100,
			align: 'right'
		}, {
			title: '入库数量',
			field: 'RecQty',
			width: 100,
			align: 'right'
		}, {
			title: '入库金额',
			field: 'RecRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '退货数量',
			field: 'RetQty',
			width: 100,
			align: 'right'
		}, {
			title: '退货金额',
			field: 'RetRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '转入数量',
			field: 'TransInQty',
			width: 100,
			align: 'right'
		}, {
			title: '转入金额',
			field: 'TransInRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '转出数量',
			field: 'TransOutQty',
			width: 100,
			align: 'right'
		}, {
			title: '转出金额',
			field: 'TransOutRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '医嘱消耗数量',
			field: 'DispQty',
			width: 100,
			align: 'right'
		}, {
			title: '医嘱消耗金额',
			field: 'DispRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '停医嘱数量',
			field: 'DispReturnQty',
			width: 100,
			align: 'right'
		}, {
			title: '停医嘱金额',
			field: 'DispReturnRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '调整数量',
			field: 'AdjQty',
			width: 100,
			align: 'right'
		}, {
			title: '调整金额',
			field: 'AdjRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '报损数量',
			field: 'ScrapQty',
			width: 100,
			align: 'right'
		}, {
			title: '报损金额',
			field: 'ScrapRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '发放数量',
			field: 'InDispQty',
			width: 100,
			align: 'right'
		}, {
			title: '发放金额',
			field: 'InDispRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '发放退回数量',
			field: 'InDispRetQty',
			width: 100,
			align: 'right'
		}, {
			title: '发放退回金额',
			field: 'InDispRetRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '期末库存',
			field: 'CurStkQty',
			width: 100,
			align: 'right'
		}, {
			title: '期末金额',
			field: 'EndRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '库存分类',
			field: 'incscDesc',
			align: 'right',
			width: 120
		}
	]];
	var BatStkQtyCm = [[
		{
			title: 'inclb',
			field: 'inclb',
			width: 80,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: '单位',
			field: 'PurUom',
			width: 70
		}, {
			title: '期初库存',
			field: 'StartQty',
			width: 100,
			align: 'right'
		}, {
			title: '期初金额',
			field: 'StartRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '入数量',
			field: 'InQty',
			hidden: true,
			width: 100,
			align: 'right'
		}, {
			title: '入金额',
			field: 'SumInRpAmt',
			hidden: true,
			width: 100,
			align: 'right'
		}, {
			title: '出数量',
			field: 'OutQty',
			hidden: true,
			width: 70,
			align: 'right'
		}, {
			title: '出金额',
			field: 'SumOutRpAmt',
			hidden: true,
			width: 100,
			align: 'right'
		}, {
			title: '入库数量',
			field: 'RecQty',
			width: 100,
			align: 'right'
		}, {
			title: '入库金额',
			field: 'RecRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '退货数量',
			field: 'RetQty',
			width: 100,
			align: 'right'
		}, {
			title: '退货金额',
			field: 'RetRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '转入数量',
			field: 'TransInQty',
			width: 100,
			align: 'right'
		}, {
			title: '转入金额',
			field: 'TransInRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '转出数量',
			field: 'TransOutQty',
			width: 100,
			align: 'right'
		}, {
			title: '转出金额',
			field: 'TransOutRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '医嘱消耗数量',
			field: 'DispQty',
			width: 100,
			align: 'right'
		}, {
			title: '医嘱消耗金额',
			field: 'DispRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '停医嘱数量',
			field: 'DispReturnQty',
			width: 100,
			align: 'right'
		}, {
			title: '停医嘱金额',
			field: 'DispReturnRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '调整数量',
			field: 'AdjQty',
			width: 100,
			align: 'right'
		}, {
			title: '调整金额',
			field: 'AdjRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '报损数量',
			field: 'ScrapQty',
			width: 100,
			align: 'right'
		}, {
			title: '报损金额',
			field: 'ScrapRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '发放数量',
			field: 'InDispQty',
			width: 100,
			align: 'right'
		}, {
			title: '发放金额',
			field: 'InDispRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '发放退回数量',
			field: 'InDispRetQty',
			width: 100,
			align: 'right'
		}, {
			title: '发放退回金额',
			field: 'InDispRetRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '期末库存',
			field: 'CurStkQty',
			width: 100,
			align: 'right'
		}, {
			title: '期末金额',
			field: 'EndRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '库存分类',
			field: 'incscDesc',
			align: 'right',
			width: 120
		}, {
			title: '进价',
			field: 'Prp',
			align: 'right',
			width: 120
		}, {
			title: '售价',
			field: 'Psp',
			align: 'right',
			width: 120
		}, {
			title: '差价',
			field: 'Margin',
			align: 'right',
			width: 120
		}, {
			title: '调价损益(进价)',
			field: 'AspAmoutRpAmt',
			align: 'right',
			width: 120
		}, {
			title: '调价损益(售价)',
			field: 'AspAmoutSpAmt',
			align: 'right',
			width: 120
		}
	]];
	var ParamsObj = $UI.loopBlock('#Conditions');
	var StockQtyGrid = $UI.datagrid('#StockQtyGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmMoveInfo',
			QueryName: 'LocItmMoveInfo',
			query2JsonStrict: 1,
			totalFields: 'SumOutAmt,SumOutRpAmt,SumInAmt,SumInRpAmt,EndRpAmt,TransInRpAmt,TransOutRpAmt,DispRpAmt,DispReturnRpAmt,StartRpAmt,AdjRpAmt,RecRpAmt,RetRpAmt,ScrapRpAmt,InDispQty,InDispRpAmt,InDispRetQty,InDispRetRpAmt'
		},
		columns: StkQtyCm,
		singleSelect: false,
		showBar: true,
		onClickRow: function(index, row) {
			StockQtyGrid.commonClickRow(index, row);
		},
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var BatQtyGrid = $UI.datagrid('#BatQtyGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmMoveInfo',
			QueryName: 'LocItmMoveInfoBat',
			query2JsonStrict: 1,
			totalFields: 'SumOutAmt,SumOutRpAmt,SumInAmt,SumInRpAmt,EndRpAmt,TransInRpAmt,TransOutRpAmt,DispRpAmt,DispReturnRpAmt,StartRpAmt,AdjRpAmt,RecRpAmt,RetRpAmt,ScrapRpAmt,InDispQty,InDispRpAmt,InDispRetQty,InDispRetRpAmt'
		},
		columns: BatStkQtyCm,
		singleSelect: false,
		showBar: true,
		onClickRow: function(index, row) {
			BatQtyGrid.commonClickRow(index, row);
		}
	});
	$HUI.tabs('#LocMoveTab', {
		onSelect: function(title) {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		// ParamsObj.PhaLoc = ParamsObj.PhaLoc.join(','); 

		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.PhaLoc)) {
			$UI.msg('alert', '科室不能为空!');
			return;
		}
		if (ParamsObj.StartDate > ParamsObj.EndDate) {
			$UI.msg('alert', '起始日期不能大于截止日期!');
			return;
		}
		if ((ParamsObj.StartDate == ParamsObj.EndDate) && (ParamsObj.StartTime > ParamsObj.EndTime)) {
			$UI.msg('alert', '开始时间不能大于截止时间!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		var currTab = $('#LocMoveTab').tabs('getSelected');
		if (currTab.panel('options').title == '项目明细') {
			StockQtyGrid.load({
				ClassName: 'web.DHCSTMHUI.LocItmMoveInfo',
				QueryName: 'LocItmMoveInfo',
				query2JsonStrict: 1,
				totalFields: 'SumOutAmt,SumOutRpAmt,SumInAmt,SumInRpAmt,EndRpAmt,TransInRpAmt,TransOutRpAmt,DispRpAmt,DispReturnRpAmt,StartRpAmt,AdjRpAmt,RecRpAmt,RetRpAmt,ScrapRpAmt,InDispQty,InDispRpAmt,InDispRetQty,InDispRetRpAmt',
				StrPar: Params
			});
		}
		if (currTab.panel('options').title == '批次明细') {
			BatQtyGrid.load({
				ClassName: 'web.DHCSTMHUI.LocItmMoveInfo',
				QueryName: 'LocItmMoveInfoBat',
				query2JsonStrict: 1,
				totalFields: 'SumOutAmt,SumOutRpAmt,SumInAmt,SumInRpAmt,EndRpAmt,TransInRpAmt,TransOutRpAmt,DispRpAmt,DispReturnRpAmt,StartRpAmt,AdjRpAmt,RecRpAmt,RetRpAmt,ScrapRpAmt,InDispQty,InDispRpAmt,InDispRetQty,InDispRetRpAmt',
				StrPar: Params
			});
		}
	}
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(StockQtyGrid);
		var DefaultData = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			PhaLoc: gLocObj
		};
		$UI.fillBlock('#Conditions', DefaultData);
	}
	Clear();
};

function Print() {
	var ParamsObj = $UI.loopBlock('#Conditions');
	if (isEmpty(ParamsObj.StartDate)) {
		$UI.msg('alert', '开始日期不能为空!');
		return;
	}
	if (isEmpty(ParamsObj.EndDate)) {
		$UI.msg('alert', '截止日期不能为空!');
		return;
	}
	if (isEmpty(ParamsObj.PhaLoc)) {
		$UI.msg('alert', '科室不能为空!');
		return;
	}
	var Params = JSON.stringify(ParamsObj);
	StrPar = encodeUrlStr(Params);
	var RaqName = 'DHCSTM_HUI_LocItmMoveInfo_Common.raq';
	var fileName = '{' + RaqName + '(StrPar=' + StrPar + ')}';
	transfileName = TranslateRQStr(fileName);
	DHCCPM_RQPrint(transfileName);
}
	
$(init);