/*呆滞品报警查询*/
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
			title : "inclb",
			field : 'inclb',
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
			field : 'stkUom',
			width : 70
		}, {
			title : '可用库存',
			field : 'avaQty',
			width : 70,
			align: 'right'
		}, {
			title : "批次库存",
			field : 'stkQty',
			width : 70,
			align: 'right'
		}, {
			title : "售价",
			field : 'sp',
			width : 100,
			align: 'right'
		}, {
			title : "批号",
			field : 'batNo',
			width : 100
		}, {
			title : "效期",
			field : 'expDate',
			width : 100
		}, {
			title : "厂商",
			field : 'manf',
			width : 100
		}, {
			title : "供应商",
			field : 'vendor',
			width : 100
		}, {
			title : "货位",
			field : 'sbDesc',
			width : 100
		}, {
			title : "最新入库日期",
			field : 'LastImpDate',
			width : 100
		}, {
			title : "最新出库日期",
			field : 'LastTrOutDate',
			width : 100
		}, {
			title : "最新转入日期",
			field : 'LastTrInDate',
			width : 100
		}, {
			title : "最新住院消耗日期",
			field : 'LastIpDate',
			width : 120
		}, {
			title : "最新门诊消耗日期",
			field : 'LastOpDate',
			width : 120
		}
	]];
	
	var ParamsObj=$UI.loopBlock('#FindConditions');
	var StockQtyGrid = $UI.datagrid('#StockQtyGrid', {
		lazy:true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmSluggishGoods',
			QueryName: 'LocItmSluggishGoods'
		},
		columns: StkQtyCm,
		singleSelect:false,
		showBar: true,
		onClickCell: function(index, filed ,value){
			StockQtyGrid.commonClickCell(index,filed,value);
		}
	})
	function Query(){
		var ParamsObj=$UI.loopBlock('#FindConditions');
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','开始日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','截止日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.PhaLoc)){
			$UI.msg('alert','科室不能为空!');
			return;
		}
		
		var ParamObj=$UI.loopBlock('#Conditions');
		var TransTypeArr = [];
		if(ParamObj.GFlag!=''){
			TransTypeArr.push(ParamObj.GFlag+'$'+ParamObj.GQty);
		}
		if(ParamObj.TFlag!=''){
			TransTypeArr.push(ParamObj.TFlag+'$'+ParamObj.TQty);
		}
		if(ParamObj.KFlag!=''){
			TransTypeArr.push(ParamObj.KFlag+'$'+ParamObj.KQty);
		}
		if(isEmpty(TransTypeArr)){
			$UI.msg('alert','请选择业务类型!');
			return;
		}
		var TransType = TransTypeArr.join();
		var Params=JSON.stringify(ParamsObj);
		StockQtyGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmSluggishGoods',
			QueryName: 'LocItmSluggishGoods',
			Params:Params,
			BusinessTypes:TransType
		});
	}
	function Clear() {
		$UI.clearBlock('#FindConditions');
		$UI.clearBlock('#Conditions');
		$UI.clear(StockQtyGrid);
		var Dafult={
			StartDate: DateFormatter(new Date()),
			EndDate:DateFormatter(new Date()),
			PhaLoc:gLocObj
		};
		$UI.fillBlock('#FindConditions',Dafult);
		$UI.fillBlock('#Conditions',{TFlag: true});
	}
	Clear();
}
$(init);