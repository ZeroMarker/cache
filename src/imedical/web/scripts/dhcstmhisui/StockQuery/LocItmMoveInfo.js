/*库存动销查询*/
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
	
	$UI.linkbutton('#PrintBT',{
		onClick:function(){
			Print();
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
			title : '入库单位',
			field : 'PurUom',
			width : 70
		}, {
			title : '库存量',
			field : 'CurStkQty',
			width : 70,
			align: 'right'
		}, {
			title : "出数量",
			field : 'OutQty',
			width : 70,
			align: 'right'
		}, {
			title : "入数量",
			field : 'InQty',
			width : 100,
			align: 'right'
		}, {
			title : "出金额",
			field : 'SumOutAmt',
			width : 100,
			align: 'right'
		}, {
			title : "出进价金额",
			field : 'SumOutRpAmt',
			width : 100,
			align: 'right'
		}, {
			title : "入金额",
			field : 'SumInAmt',
			width : 100,
			align: 'right'
		}, {
			title : "入进价金额",
			field : 'SumInRpAmt',
			width : 100,
			align: 'right'
		}, {
			title : "厂商",
			field : 'Manf',
			width : 100
		}, {
			title : "货位",
			field : 'SbDesc',
			width : 100
		}
	]];
	
	var ParamsObj=$UI.loopBlock('#Conditions')
	var StockQtyGrid = $UI.datagrid('#StockQtyGrid', {
		lazy:true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmMoveInfo',
			QueryName: 'LocItmMoveInfo'
		},
		columns: StkQtyCm,
		singleSelect:false,
		showBar: true,
		onClickCell: function(index, filed ,value){
			StockQtyGrid.commonClickCell(index,filed,value);
		}
	})
	function Query(){
		var ParamsObj=$UI.loopBlock('#Conditions');
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
		var Params=JSON.stringify(ParamsObj);
		StockQtyGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmMoveInfo',
			QueryName: 'LocItmMoveInfo',
			StrPar:Params
		});
	}
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(StockQtyGrid);
		var Dafult={
			StartDate: DateFormatter(new Date()),
			EndDate:DateFormatter(new Date()),
			PhaLoc:gLocObj
		};
		$UI.fillBlock('#Conditions',Dafult);
	}
	Clear();
}

function Print(){
	var ParamsObj=$UI.loopBlock('#Conditions');
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
	var Params=JSON.stringify(addSessionParams(ParamsObj));
	var RaqName = 'DHCSTM_HUI_LocItmMoveInfo_Common.raq';
	var fileName = "{" + RaqName + "(StrPar=" + Params + ")}";
	DHCCPM_RQDirectPrint(fileName);
	/*var Params=JSON.stringify(ParamsObj);
	StrPar=encodeUrlStr(Params)
	var RaqName = 'DHCSTM_HUI_LocItmMoveInfo_Common.raq';
	var fileName = "{" + RaqName + "(StrPar=" + StrPar + ")}";
	transfileName=TranslateRQStr(fileName);
	DHCCPM_RQPrint(transfileName);*/
}
	
$(init);