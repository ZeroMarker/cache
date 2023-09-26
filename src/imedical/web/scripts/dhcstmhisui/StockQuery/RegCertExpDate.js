//注册证效期报警
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
			})
		}
	});
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});

	var StockQtyCm = [[
		 {
			title : "inci",
			field : 'inci',
			width : 20,
			hidden : true
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
		},{
			title : '厂商',
			field : 'Manf',
			hidden : true,
			width : 70
		},{
			title : '库存分类',
			field : 'IncscDesc',
			width : 70
		}, {
			title : "注册证号",
			field : 'RegCertNo',
			width : 100
		}, {
			title : "注册证效期",
			field : 'ExpDate',
			width : 100
		}, {
			title : "失效天数",
			field : 'WarnDays',
			width : 100,
			align : 'right'
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
		}	
	]];
	var ParamsObj=$UI.loopBlock('#Conditions')
	var StockQtyGrid = $UI.datagrid('#StockQtyGrid', {
		lazy:true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.RegCertExpDate',
			MethodName: 'jsRegCertOfExp'
		},
		
		columns: StockQtyCm,
		singleSelect:false,
		showBar: true,
		onClickCell: function(index, filed ,value){
			StockQtyGrid.commonClickCell(index,filed,value);
		},
		onLoadSuccess: function(data){
			$.each(data.rows, function(index, row){
			ChangeColor(StockQtyGrid, index, 'inci',row);
			});
		}

	})
	function ChangeColor(Grid, RowIndex, Field,row){
		var Incil = Grid.getRows()[RowIndex][Field];
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
		var ParamsObj=$UI.loopBlock('#Conditions')
		if(isEmpty(ParamsObj.PhaLoc)){
			$UI.msg('alert','科室不能为空!');
			return;
		}	
		var Params=JSON.stringify(ParamsObj);
		var RestMon=null;
		if(ParamsObj.ZeroMonth=='Y'){
			if(RestMon==null){
				RestMon=0;
			}else{
				RestMon=RestMon+','+0;
			}
		}
		
		if(ParamsObj.OneMonth=='Y'){
			if(RestMon==null){
				RestMon=1;
			}else{
				RestMon=RestMon+','+1;
			}
		}
		if(ParamsObj.TwoMonth=='Y'){
			if(RestMon==null){
				RestMon=2;
			}else{
				RestMon=RestMon+','+2;
			}
		}
		if(ParamsObj.ThreeMonth=='Y'){
			if(RestMon==null){
				RestMon=3;
			}else{
				RestMon=RestMon+','+3;
			}
		}
		if(ParamsObj.FourMonth=='Y'){
			if(RestMon==null){
				RestMon=4;
			}else{
				RestMon=RestMon+','+4;
			}
		}
		if(ParamsObj.FiveMonth=='Y'){
			if(RestMon==null){
				RestMon=5;
			}else{
				RestMon=RestMon+','+5;
			}
		}
		if(ParamsObj.SixMonth=='Y'){
			if(RestMon==null){
				RestMon=6;
			}else{
				RestMon=RestMon+','+6;
			}
		}
		if(ParamsObj.SevenMonth=='Y'){
			if(RestMon==null){
				RestMon=7;
			}else{
				RestMon=RestMon+','+7;
			}
		}
		if(ParamsObj.EightMonth=='Y'){
			if(RestMon==null){
				RestMon=8;
			}else{
				RestMon=RestMon+','+8;
			}
		}
		if(ParamsObj.NineMonth=='Y'){
			if(RestMon==null){
				RestMon=9;
			}else{
				RestMon=RestMon+','+9;
			}
		}
		if(ParamsObj.TenMonth=='Y'){
			if(RestMon==null){
				RestMon=10;
			}else{
				RestMon=RestMon+','+10;
			}
		}
		if(ParamsObj.ElevenMonth=='Y'){
			if(RestMon==null){
				RestMon=11;
			}else{
				RestMon=RestMon+','+11;
			}
		}
		if(ParamsObj.TwelveMonth=='Y'){
			if(RestMon==null){
				RestMon=12;
			}else{
				RestMon=RestMon+','+12;
			}
		}
		if(ParamsObj.Normal=='Y'){
			if(RestMon==null){
				RestMon=13;
			}else{
				RestMon=RestMon+','+13;
			}
		}
		StockQtyGrid.load({
			ClassName: 'web.DHCSTMHUI.RegCertExpDate',
			MethodName: 'jsRegCertOfExp',
			StrPar:Params,
			RestMon:RestMon
		})
	}
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(StockQtyGrid);
		var Dafult={PhaLoc:gLocObj,
					EndDate:DateFormatter(new Date()),
					}
		$UI.fillBlock('#Conditions',Dafult);
	
	}
	Clear();
	}		
$(init);
