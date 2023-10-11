/* ��汨��(��������)*/
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
			title: '���ʴ���',
			field: 'InciCode',
			width: 120
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 200
		}, {
			title: '���',
			field: 'Spec',
			width: 200
		}, {
			title: '��λ',
			field: 'StkUom',
			width: 70
		}, {
			title: '���ÿ��',
			field: 'AvaQty',
			width: 170,
			align: 'right'
		}, {
			title: '��������',
			field: 'OneDspQty',
			width: 170,
			align: 'right'
		}, {
			title: '������',
			field: 'ReqQty',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
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
			$UI.msg('alert', '���Ҳ���Ϊ��!');
			return;
		}
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���С�ڿ�ʼ����!');
			return;
		}
		if (isEmpty(ParamsObj.UseDays)) {
			$UI.msg('alert', 'ʹ����������Ϊ��!');
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