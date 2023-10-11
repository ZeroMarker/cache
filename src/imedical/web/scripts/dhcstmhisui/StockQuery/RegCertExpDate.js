// 注册证效期报警
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

	var StockQtyCm = [[
		{
			title: 'inci',
			field: 'inci',
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
			title: '生产厂家',
			field: 'Manf',
			hidden: true,
			width: 70
		}, {
			title: '库存分类',
			field: 'IncscDesc',
			width: 70
		}, {
			title: '注册证号',
			field: 'RegCertNo',
			width: 100
		}, {
			title: '注册证效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '失效天数',
			field: 'WarnDays',
			width: 100,
			align: 'right'
		}, {
			title: '距离过期月份',
			field: 'month',
			align: 'right',
			width: 100,
			formatter: function(value, row, index) {
				if (value == '0') {
					return '已过期';
				} else if (value == '13') {
					return '大于12个月';
				} else {
					return value + '个月';
				}
			},
			styler: function(value, row, index) {
				if (value != '13') {
					return 'color:white';
				}
			}
		}
	]];
	var ParamsObj = $UI.loopBlock('#Conditions');
	var StockQtyGrid = $UI.datagrid('#StockQtyGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.RegCertExpDate',
			MethodName: 'jsRegCertOfExp'
		},
		columns: StockQtyCm,
		singleSelect: false,
		showBar: true,
		onClickRow: function(index, row) {
			StockQtyGrid.commonClickRow(index, row);
		},
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			$.each(data.rows, function(index, row) {
				ChangeColor(StockQtyGrid, index, 'inci', row);
			});
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}

	});
	function ChangeColor(Grid, RowIndex, Field, row) {
		var Incil = Grid.getRows()[RowIndex][Field];
		var ColorField = 'month';
		var Month = row['month'];
		Month = parseInt(Month);
		SetGridBgColor(Grid, RowIndex, Field, 'month' + Month, ColorField);
	}
	function Query() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		if (isEmpty(ParamsObj.PhaLoc)) {
			$UI.msg('alert', '科室不能为空!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		var RestMon = null;
		if (ParamsObj.ZeroMonth == 'Y') {
			if (RestMon == null) {
				RestMon = 0;
			} else {
				RestMon = RestMon + ',' + 0;
			}
		}
		
		if (ParamsObj.OneMonth == 'Y') {
			if (RestMon == null) {
				RestMon = 1;
			} else {
				RestMon = RestMon + ',' + 1;
			}
		}
		if (ParamsObj.TwoMonth == 'Y') {
			if (RestMon == null) {
				RestMon = 2;
			} else {
				RestMon = RestMon + ',' + 2;
			}
		}
		if (ParamsObj.ThreeMonth == 'Y') {
			if (RestMon == null) {
				RestMon = 3;
			} else {
				RestMon = RestMon + ',' + 3;
			}
		}
		if (ParamsObj.FourMonth == 'Y') {
			if (RestMon == null) {
				RestMon = 4;
			} else {
				RestMon = RestMon + ',' + 4;
			}
		}
		if (ParamsObj.FiveMonth == 'Y') {
			if (RestMon == null) {
				RestMon = 5;
			} else {
				RestMon = RestMon + ',' + 5;
			}
		}
		if (ParamsObj.SixMonth == 'Y') {
			if (RestMon == null) {
				RestMon = 6;
			} else {
				RestMon = RestMon + ',' + 6;
			}
		}
		if (ParamsObj.SevenMonth == 'Y') {
			if (RestMon == null) {
				RestMon = 7;
			} else {
				RestMon = RestMon + ',' + 7;
			}
		}
		if (ParamsObj.EightMonth == 'Y') {
			if (RestMon == null) {
				RestMon = 8;
			} else {
				RestMon = RestMon + ',' + 8;
			}
		}
		if (ParamsObj.NineMonth == 'Y') {
			if (RestMon == null) {
				RestMon = 9;
			} else {
				RestMon = RestMon + ',' + 9;
			}
		}
		if (ParamsObj.TenMonth == 'Y') {
			if (RestMon == null) {
				RestMon = 10;
			} else {
				RestMon = RestMon + ',' + 10;
			}
		}
		if (ParamsObj.ElevenMonth == 'Y') {
			if (RestMon == null) {
				RestMon = 11;
			} else {
				RestMon = RestMon + ',' + 11;
			}
		}
		if (ParamsObj.TwelveMonth == 'Y') {
			if (RestMon == null) {
				RestMon = 12;
			} else {
				RestMon = RestMon + ',' + 12;
			}
		}
		if (ParamsObj.Normal == 'Y') {
			if (RestMon == null) {
				RestMon = 13;
			} else {
				RestMon = RestMon + ',' + 13;
			}
		}
		StockQtyGrid.load({
			ClassName: 'web.DHCSTMHUI.RegCertExpDate',
			MethodName: 'jsRegCertOfExp',
			StrPar: Params,
			RestMon: RestMon
		});
	}
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(StockQtyGrid);
		var DefaultData = { PhaLoc: gLocObj,
			EndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#Conditions', DefaultData);
	}
	function SetElementBgColor() {
		if (HISUIStyleCode === 'lite') {
			$('#month0').css('background-color', '#EE0F0F');
			$('#month1').css('background-color', '#FFB300');
			$('#month2').css('background-color', '#F68300');
			$('#month3').css('background-color', '#CF8A3B');
			$('#month4').css('background-color', '#67E14A');
			$('#month5').css('background-color', '#12AA2C');
			$('#month6').css('background-color', '#1A8700');
			$('#month7').css('background-color', '#339EFF');
			$('#month8').css('background-color', '#007BE9');
			$('#month9').css('background-color', '#0059A8');
			$('#month10').css('background-color', '#F17AE9');
			$('#month11').css('background-color', '#A863F8');
			$('#month12').css('background-color', '#A346C4');
		}
	}
	Clear();
	SetElementBgColor();
};
$(init);