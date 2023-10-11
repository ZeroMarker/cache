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
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#StkGrpId').setFilterByLoc(LocId);
		},
		onChange: function(e) {
			init(e);
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

	function init(LocId) {
		var StkBinParams = JSON.stringify(addSessionParams({ LocDr: LocId }));
		var StkBinBox = $HUI.combobox('#StkBin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params=' + StkBinParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	}
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
			width: 70,
			align: 'right',
			styler: function(value, row, index) {
				if (value > row.MaxQty) {
					return 'color:white;background:' + GetColorHexCode('red');
				} else if (value < row.MinQty) {
					return 'color:white;background:' + GetColorHexCode('green');
				}
			}
		}, {
			title: '�������',
			field: 'MaxQty',
			width: 70,
			align: 'right'
		}, {
			title: '�������',
			field: 'MinQty',
			width: 100,
			align: 'right'
		}, {
			title: '��׼���',
			field: 'RepQty',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'Manf',
			width: 100
		}, {
			title: '������',
			field: 'IncscDesc',
			width: 100
		}
	]];
	
	var ParamsObj = $UI.loopBlock('#Conditions');
	var StockQtyGrid = $UI.datagrid('#StockQtyGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmStkQtyWarn',
			MethodName: 'jsLocItmStkQtyLimitWarn'
		},
		columns: StkQtyCm,
		singleSelect: false,
		showBar: true,
		onClickRow: function(index, row) {
			StockQtyGrid.commonClickRow(index, row);
		},
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			$.each(data.rows, function(index, row) {
				ChangeColor(StockQtyGrid, index, 'incil', row);
			});
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}

	});
	function ChangeColor(Grid, RowIndex, Field, row) {
		var Incil = Grid.getRows()[RowIndex][Field];
		var ColorField = 'AvaQty';
		var AvaQty = row['AvaQty'];
		var MaxQty = row['MaxQty'];
		var MinQty = row['MinQty'];
		if (parseFloat(AvaQty) > MaxQty) {
			SetGridBgColor(Grid, RowIndex, Field, 'red', ColorField);
		}
		if (parseFloat(AvaQty) < MinQty) {
			SetGridBgColor(Grid, RowIndex, Field, 'green', ColorField);
		}
	}
	
	function Query() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		if (isEmpty(ParamsObj.PhaLoc)) {
			$UI.msg('alert', '���Ҳ���Ϊ��!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		StockQtyGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmStkQtyWarn',
			MethodName: 'jsLocItmStkQtyLimitWarn',
			StrPar: Params
		});
	}
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(StockQtyGrid);
		var DefaultData = { PhaLoc: gLocObj
		};
		$UI.fillBlock('#Conditions', DefaultData);
	}
	function SetElementBgColor() {
		if (HISUIStyleCode === 'lite') {
			$('#UpeerLimit').css('background-color', '#FF3D3D');
			$('#BelowLimit').css('background-color', '#28BA05');
		}
	}
	Clear();
	Query();
	SetElementBgColor();
};
	
$(init);