//效期报警
var init = function() {
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	var PhaLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PhaLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#StkGrpId').stkscgcombotree({
		onSelect:function(node){
			$.cm({
				ClassName:'web.DHCSTMHUI.Common.Dicts',
				QueryName:'GetStkCat',
				ResultSetType:'array',
				StkGrpId:node.id
			},function(data){
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
			title : "inclb",
			field : 'inclb',
			width : 20,
			hidden : true
		}, {
			title : "距离过期月份",
			field : 'month',
			align: 'right',
			width : 100,
			formatter: function (value, row, index) {
				if (value == "0") {
					return "已过期";
				}else if (value == "13") {
					return "大于12个月";
				}else{
					return value+"个月";
				}
			},
			styler:function(value,row,index){
				if (value != "13") {
					return  'color:white';
				}
			}
		}, {
			title : "失效天数",
			field : 'warnDays',
			align: 'right',
			width : 100
		}, {
			title : "物资代码",
			field : 'InciCode',
			width : 120
		}, {
			title : "物资名称",
			field : 'InciDesc',
			width : 200
		}, {
			title : "规格",
			field : 'Spec',
			width : 200
		}, {
			title : '具体规格',
			field : 'SpecDesc',
			width : 70
		}, {
			title : '批号',
			field : 'batNo',
			width : 120
		}, {
			title : "效期",
			field : 'expDate',
			width : 100
		}, {
			title : "库存",
			field : 'stkQty',
			width : 100,
			align: 'right'
		}, {
			title : "单位",
			field : 'stkUom',
			width : 100
		}, {
			title : "厂商",
			field : 'Manf',
			width : 100
		}, {
			title : "库存分类",
			field : 'IncscDesc',
			width : 100
		}, {
			title : "货位",
			field : 'sbDesc',
			width : 100
		}, {
			title : "最新入库供应商",
			field : 'lastvendorName',
			width : 100
		}
	]];
	
	var StockQtyGrid = $UI.datagrid('#StockQtyGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmExpDate',
			QueryName: 'LocItmBatOfExp'
		},
		columns: StockQtyCm,
		singleSelect:false,
		showBar: true,
		onClickCell: function(index, filed ,value){
			StockQtyGrid.commonClickCell(index,filed,value);
		},
		onLoadSuccess: function(data){
			$.each(data.rows, function(index, row){
				ChangeColor(StockQtyGrid, index, 'inclb', row);
			});
		}
	});
	function ChangeColor(Grid, RowIndex, Field, row){
		var ColorField = 'month';
		var Month = row['month'];
		Month=parseInt(Month);
		switch(Month){
			case 0:
				var Color = '#EE4F38';
				SetGridBgColor(Grid, RowIndex, Field, Color, ColorField);
				break;
			case 1:
				var Color = '#FD930C';
				SetGridBgColor(Grid, RowIndex, Field, Color, ColorField);
				break;
			case 2:
				var Color = '#D17604';
				SetGridBgColor(Grid, RowIndex, Field, Color, ColorField);
				break;
			case 3:
				var Color = '#955606';
				SetGridBgColor(Grid, RowIndex, Field, Color, ColorField);
				break;
			case 4:
				var Color = '#8BE550';
				SetGridBgColor(Grid, RowIndex, Field, Color, ColorField);
				break;
			case 5:
				var Color = '#50B90C';
				SetGridBgColor(Grid, RowIndex, Field, Color, ColorField);
				break;
			case 6:
				var Color = '#328100';
				SetGridBgColor(Grid, RowIndex, Field, Color, ColorField);
				break;
			case 7:
				var Color = '#449BE3';
				SetGridBgColor(Grid, RowIndex, Field, Color, ColorField);
				break;
			case 8:
				var Color = '#0670C7';
				SetGridBgColor(Grid, RowIndex, Field, Color, ColorField);
				break;
			case 9:
				var Color = '#125891';
				SetGridBgColor(Grid, RowIndex, Field, Color, ColorField);
				break;
			case 10:
				var Color = '#D952D1';
				SetGridBgColor(Grid, RowIndex, Field, Color, ColorField);
				break;
			case 11:
				var Color = '#C10EB5';
				SetGridBgColor(Grid, RowIndex, Field, Color, ColorField);
				break;
			case 12:
				var Color = '#891083';
				SetGridBgColor(Grid, RowIndex, Field, Color, ColorField);
				break;
			default:
				break;
		}
	}
	
	function Query(){
		var ParamsObj=$UI.loopBlock('#Conditions');
		if(isEmpty(ParamsObj.PhaLoc)){
			$UI.msg('alert','科室不能为空!');
			return;
		}
		var Params=JSON.stringify(ParamsObj);
		var RestMonArr = [];
		if(ParamsObj.ZeroMonth=='Y'){
			RestMonArr.push('0');
		}
		
		if(ParamsObj.OneMonth=='Y'){
			RestMonArr.push('1');
		}
		if(ParamsObj.TwoMonth=='Y'){
			RestMonArr.push('2');
		}
		if(ParamsObj.ThreeMonth=='Y'){
			RestMonArr.push('3');
		}
		if(ParamsObj.FourMonth=='Y'){
			RestMonArr.push('4');
		}
		if(ParamsObj.FiveMonth=='Y'){
			RestMonArr.push('5');
		}
		if(ParamsObj.SixMonth=='Y'){
			RestMonArr.push('6');
		}
		if(ParamsObj.SevenMonth=='Y'){
			RestMonArr.push('7');
		}
		if(ParamsObj.EightMonth=='Y'){
			RestMonArr.push('8');
		}
		if(ParamsObj.NineMonth=='Y'){
			RestMonArr.push('9');
		}
		if(ParamsObj.TenMonth=='Y'){
			RestMonArr.push('10');
		}
		if(ParamsObj.ElevenMonth=='Y'){
			RestMonArr.push('11');
		}
		if(ParamsObj.TwelveMonth=='Y'){
			RestMonArr.push('12');
		}
		if(ParamsObj.Normal=='Y'){
			RestMonArr.push('13');
		}
		var RestMon = RestMonArr.join();
		StockQtyGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmExpDate',
			QueryName: 'LocItmBatOfExp',
			Params:Params,
			RestMon:RestMon
		});
	}
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(StockQtyGrid);
		var Dafult={
			PhaLoc:gLocObj,
			EndDate:DateFormatter(new Date())
		};
		$UI.fillBlock('#Conditions',Dafult);
	}
	Clear();
}
$(init);
