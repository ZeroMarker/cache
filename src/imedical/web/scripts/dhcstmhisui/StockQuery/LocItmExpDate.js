// 效期报警
var CodeMainParamObj = GetAppPropValue('DHCSTDRUGMAINTAINM');
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
	var HandlerParams = function() {
		var ScgId = $('#StkGrpId').combotree('getValue');
		var Obj = { StkGrpRowId: ScgId, StkGrpType: 'M', BDPHospital: gHospId };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	
	var StockQtyCm = [[
		{
			title: 'inclb',
			field: 'inclb',
			width: 80,
			hidden: true
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
		}, {
			title: '失效天数',
			field: 'warnDays',
			align: 'right',
			width: 100
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
			title: '具体规格',
			field: 'SpecDesc',
			width: 70,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '批号',
			field: 'batNo',
			width: 120
		}, {
			title: '效期',
			field: 'expDate',
			width: 100
		}, {
			title: '库存',
			field: 'stkQty',
			width: 100,
			align: 'right'
		}, {
			title: '单位',
			field: 'stkUom',
			width: 100
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 100
		}, {
			title: '库存分类',
			field: 'IncscDesc',
			width: 100
		}, {
			title: '货位',
			field: 'sbDesc',
			width: 100
		}, {
			title: '最新入库供应商',
			field: 'lastvendorName',
			width: 100
		}
	]];
	
	var StockQtyGrid = $UI.datagrid('#StockQtyGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmExpDate',
			QueryName: 'LocItmBatOfExp',
			query2JsonStrict: 1
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
				ChangeColor(StockQtyGrid, index, 'inclb', row);
			});
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	function ChangeColor(Grid, RowIndex, Field, row) {
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
		var RestMonArr = [];
		if (ParamsObj.ZeroMonth == 'Y') {
			RestMonArr.push('0');
		}
		
		if (ParamsObj.OneMonth == 'Y') {
			RestMonArr.push('1');
		}
		if (ParamsObj.TwoMonth == 'Y') {
			RestMonArr.push('2');
		}
		if (ParamsObj.ThreeMonth == 'Y') {
			RestMonArr.push('3');
		}
		if (ParamsObj.FourMonth == 'Y') {
			RestMonArr.push('4');
		}
		if (ParamsObj.FiveMonth == 'Y') {
			RestMonArr.push('5');
		}
		if (ParamsObj.SixMonth == 'Y') {
			RestMonArr.push('6');
		}
		if (ParamsObj.SevenMonth == 'Y') {
			RestMonArr.push('7');
		}
		if (ParamsObj.EightMonth == 'Y') {
			RestMonArr.push('8');
		}
		if (ParamsObj.NineMonth == 'Y') {
			RestMonArr.push('9');
		}
		if (ParamsObj.TenMonth == 'Y') {
			RestMonArr.push('10');
		}
		if (ParamsObj.ElevenMonth == 'Y') {
			RestMonArr.push('11');
		}
		if (ParamsObj.TwelveMonth == 'Y') {
			RestMonArr.push('12');
		}
		if (ParamsObj.Normal == 'Y') {
			RestMonArr.push('13');
		}
		var RestMon = RestMonArr.join();
		StockQtyGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmExpDate',
			QueryName: 'LocItmBatOfExp',
			query2JsonStrict: 1,
			Params: Params,
			RestMon: RestMon
		});
	}
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(StockQtyGrid);
		var DefaultData = {
			PhaLoc: gLocObj,
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
	Query();
	SetElementBgColor();
};
$(init);