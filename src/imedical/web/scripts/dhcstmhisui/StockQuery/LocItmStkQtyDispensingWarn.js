/* 库存报警(按消耗量)*/
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
	var PhaLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PhaLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var StkQtyCm = [[
		{
			title: 'incil',
			field: 'incil',
			width: 60,
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
			width: 200
		}, {
			title: '单位',
			field: 'StkUom',
			width: 70
		}, {
			title: '可用库存',
			field: 'AvaQty',
			width: 170,
			align: 'right'
		}, {
			title: '日消耗量',
			field: 'OneDspQty',
			width: 170,
			align: 'right'
		}, {
			title: '需求量',
			field: 'ReqQty',
			width: 100,
			align: 'right'
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 100
		}
	]];
	
	var ParamsObj = $UI.loopBlock('#Conditions');
	var StockQtyGrid = $UI.datagrid('#StockQtyGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmStkQtyWarn',
			MethodName: 'jsLocItmQtyDspWarn'
		},
		columns: StkQtyCm,
		fitColumns: true,
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
	function Query() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.PhaLoc)) {
			$UI.msg('alert', '科室不能为空!');
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
		if (isEmpty(ParamsObj.UseDays)) {
			$UI.msg('alert', '使用天数不能为空!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		StockQtyGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmStkQtyWarn',
			MethodName: 'jsLocItmQtyDspWarn',
			StrPar: Params
		});
	}
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(StockQtyGrid);
		var DefaultData = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			PhaLoc: gLocObj,
			UseDays: 30,
			DispQtyFlag: 'Y'
		};
		$UI.fillBlock('#Conditions', DefaultData);
	}
	Clear();
};
	
$(init);