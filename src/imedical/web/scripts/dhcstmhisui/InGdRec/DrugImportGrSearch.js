/*
入库单制单查询
*/
var DrugImportGrSearch=function(Fn){
	$HUI.dialog('#FindWin').open();
	var Clear=function(){
		$UI.clearBlock('#FindConditions');
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		///设置初始值 考虑使用配置
		var LocId = $("#RecLoc").combobox('getValue');
		var LocDesc = $("#RecLoc").combobox('getText');
		var Dafult={
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			FRecLoc: {RowId: LocId, Description: LocDesc},
			AuditFlag:"N",
			HVFlag:"N"
		};
		$UI.fillBlock('#FindConditions', Dafult);
	}
	var FRecLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
//	var FRecLocBox = $HUI.combobox('#FRecLoc', {
//			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FRecLocParams,
//			valueField: 'RowId',
//			textField: 'Description'
//	});
	$("#FRecLoc").lookup({
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetCTLoc',
			Params: FRecLocParams
		}
	});
	var FVendorBoxParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
//	var FVendorBoxBox = $HUI.combobox('#FVendorBox', {
//			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+FVendorBoxParams,
//			valueField: 'RowId',
//			textField: 'Description'
//	});
	$("#FVendorBox").lookup({
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetVendor',
			Params: FVendorBoxParams
		}
	});
	$UI.linkbutton('#FQueryBT',{
		onClick:function(){
			FQuery();
		}
	});
	function FQuery(){
		var ParamsObj=$UI.loopBlock('#FindConditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','开始日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','截止日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.FRecLoc)){
			$UI.msg('alert','入库科室不能为空!');
			return;
		}
		var Params=JSON.stringify(ParamsObj);
		$UI.clear(InGdRecDetailGrid);
		InGdRecMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			Params:Params
		});
	}
	
	$UI.linkbutton('#FClearBT',{
		onClick:function(){
			Clear();
		}
	});
	$UI.linkbutton('#FReturnBT',{
		onClick:function(){
			var Row=InGdRecMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert','请选择要返回的入库单!');
			}
			Fn(Row.IngrId);
			$HUI.dialog('#FindWin').close();
		}
	});
	var InGdRecMainCm = [[{
			title : "RowId",
			field : 'IngrId',
			width : 100,
			hidden : true
		}, {
			title : "入库单号",
			field : 'IngrNo',
			width : 120
		}, {
			title : "供应商",
			field : 'Vendor',
			width : 200
		}, {
			title : '订购科室',
			field : 'ReqLocDesc',
			width : 150
		}, {
			title : '创建人',
			field : 'CreateUser',
			width : 70
		}, {
			title : '创建日期',
			field : 'CreateDate',
			width : 90
		}, {
			title : '采购员',
			field : 'PurchUser',
			width : 70
		}, {
			title : "入库类型",
			field : 'IngrType',
			width : 80
		}, {
			title : "完成标志",
			field : 'Complete',
			width : 70
		}, {
			title : "进价金额",
			field : 'RpAmt',
			width : 100,
			align : 'right'
		}, {
			title : "售价金额",
			field : 'SpAmt',
			width : 100,
			align : 'right'
		}
	]];

	var InGdRecMainGrid = $UI.datagrid('#InGdRecMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query'
		},
		columns: InGdRecMainCm,
		onSelect:function(index, row){
			InGdRecDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				Parref: row.IngrId
			});
		},
		onDblClickRow:function(index, row){
			Fn(row.IngrId);
			$HUI.dialog('#FindWin').close();
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				InGdRecMainGrid.selectRow(0);
			}
		}
	});

	var InGdRecDetailCm = [[{
			title : "RowId",
			field : 'RowId',
			width : 100,
			hidden : true
		}, {
			title : '物资代码',
			field : 'IncCode',
			width : 80
		}, {
			title : '物资名称',
			field : 'IncDesc',
			width : 230
		}, {
			title : "厂商",
			field : 'Manf',
			width : 180
		}, {
			title : "批号",
			field : 'BatchNo',
			width : 90
		}, {
			title : "有效期",
			field : 'ExpDate',
			width : 100
		}, {
			title : "单位",
			field : 'IngrUom',
			width : 80
		}, {
			title : "数量",
			field : 'RecQty',
			width : 80,
			align : 'right'
		}, {
			title : "进价",
			field : 'Rp',
			width : 60,
			align : 'right'
		}, {
			title : "售价",
			field : 'Sp',
			width : 60,
			align : 'right'
		}, {
			title : "发票号",
			field : 'InvNo',
			width : 80
		}, {
			title : "发票日期",
			field : 'InvDate',
			width : 100
		}, {
			title : "进价金额",
			field : 'RpAmt',
			width : 100,
			align : 'right'
		}, {
			title : "售价金额",
			field : 'SpAmt',
			width : 100,
			align : 'right'
		}
	]];

	var InGdRecDetailGrid = $UI.datagrid('#InGdRecDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail'
		},
		columns: InGdRecDetailCm
	});
	Clear();
	FQuery();
}