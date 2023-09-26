/*库存报警(按消耗量)*/
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
	var StkQtyCm = [[
		 {
			title : "incil",
			field : 'incil',
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
		}, {
			title : '单位',
			field : 'StkUom',
			width : 70
		}, {
			title : '可用库存',
			field : 'AvaQty',
			width : 170,
			align: 'right'
		}, {
			title : "日消耗量",
			field : 'OneDspQty',
			width : 170,
			align: 'right'
		}, {
			title : "需求量",
			field : 'ReqQty',
			width : 100,
			align: 'right'
		}, {
			title : "厂商",
			field : 'Manf',
			width : 100
		}	
	]];
	
	var ParamsObj=$UI.loopBlock('#Conditions')
	var StockQtyGrid = $UI.datagrid('#StockQtyGrid', {
		lazy:true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmStkQtyWarn',
			MethodName: 'jsLocItmQtyDspWarn'
		},
		columns: StkQtyCm,
		singleSelect:false,
		showBar: true,
		onClickCell: function(index, filed ,value){
			StockQtyGrid.commonClickCell(index,filed,value);
		}

	})
	function Query(){
		var ParamsObj=$UI.loopBlock('#Conditions')
		if(isEmpty(ParamsObj.PhaLoc)){
			$UI.msg('alert','科室不能为空!');
			return;
		}	
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','请选择开始日期!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','请选择截止日期!');
			return;
		}
		if(isEmpty(ParamsObj.UseDays)){
			$UI.msg('alert','请填写使用天数!');
			return;
		}
		var Params=JSON.stringify(ParamsObj);
		$UI.setUrl(StockQtyGrid)
		StockQtyGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmStkQtyWarn',
			MethodName: 'jsLocItmQtyDspWarn',
			StrPar:Params
		})
	}
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(StockQtyGrid);
		var Dafult={
			StartDate:DateFormatter(new Date()),
			EndDate:DateFormatter(new Date()),
			PhaLoc:gLocObj,
			UseDays:30,
			DispQtyFlag:'Y'
					}
		$UI.fillBlock('#Conditions',Dafult);
	
	}
	Clear();
	}	
	
$(init);