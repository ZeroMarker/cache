/* ����Ʒ������ѯ*/
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
			title: 'inclb',
			field: 'inclb',
			width: 100,
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
			field: 'stkUom',
			width: 70
		}, {
			title: '���ÿ��',
			field: 'avaQty',
			width: 100,
			align: 'right'
		}, {
			title: '���ο��',
			field: 'stkQty',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'sp',
			width: 100,
			align: 'right'
		}, {
			title: '����',
			field: 'batNo',
			width: 100
		}, {
			title: 'Ч��',
			field: 'expDate',
			width: 100
		}, {
			title: '��������',
			field: 'manf',
			width: 150
		}, {
			title: '��Ӧ��',
			field: 'vendor',
			width: 150
		}, {
			title: '��λ',
			field: 'sbDesc',
			width: 100
		}, {
			title: '�����������',
			field: 'LastImpDate',
			width: 100
		}, {
			title: '���³�������',
			field: 'LastTrOutDate',
			width: 100
		}, {
			title: '����ת������',
			field: 'LastTrInDate',
			width: 100
		}, {
			title: '����סԺ��������',
			field: 'LastIpDate',
			width: 150
		}, {
			title: '����������������',
			field: 'LastOpDate',
			width: 150
		}
	]];
	
	var ParamsObj = $UI.loopBlock('#FindConditions');
	var StockQtyGrid = $UI.datagrid('#StockQtyGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmSluggishGoods',
			QueryName: 'LocItmSluggishGoods',
			query2JsonStrict: 1
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
	function Query() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
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
		var ParamObj = $UI.loopBlock('#Conditions');
		var TransTypeArr = [];
		if (ParamObj.GFlag != '') {
			TransTypeArr.push(ParamObj.GFlag + '$' + ParamObj.GQty);
		}
		if (ParamObj.TFlag != '') {
			TransTypeArr.push(ParamObj.TFlag + '$' + ParamObj.TQty);
		}
		if (ParamObj.KFlag != '') {
			TransTypeArr.push(ParamObj.KFlag + '$' + ParamObj.KQty);
		}
		if (isEmpty(TransTypeArr)) {
			$UI.msg('alert', '��ѡ��ҵ������!');
			return;
		}
		var TransType = TransTypeArr.join();
		var Params = JSON.stringify(ParamsObj);
		StockQtyGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmSluggishGoods',
			QueryName: 'LocItmSluggishGoods',
			query2JsonStrict: 1,
			Params: Params,
			BusinessTypes: TransType
		});
	}
	function Clear() {
		$UI.clearBlock('#FindConditions');
		$UI.clearBlock('#Conditions');
		$UI.clear(StockQtyGrid);
		var DefaultData = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			PhaLoc: gLocObj
		};
		$UI.fillBlock('#FindConditions', DefaultData);
		$UI.fillBlock('#Conditions', { TFlag: true });
	}
	Clear();
};
$(init);