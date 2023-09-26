var InPurPlanMouldWin = function(SelectFn, CreateFn){
	$HUI.dialog('#MouldWin').open();
	
	$UI.linkbutton('#FMouldQueryBT',{
		onClick:function(){
			MouldQuery();
		}
	});
	
	function MouldQuery(){
		$UI.clear(MouldPurMainGrid);
		$UI.clear(MouldPurDetailGrid);
		var ParamsObj=$UI.loopBlock('#FindMouldConditions');
		if(isEmpty(ParamsObj['PurLoc'])){
			$UI.msg("alert","采购科室不能为空!");
			return;
		}
		ParamsObj['MouldFlag'] = 'Y';
		var Params = JSON.stringify(ParamsObj);
		MouldPurMainGrid.load({
			ClassName: 'web.DHCSTMHUI.INPurPlanMould',
			QueryName: 'QueryMould',
			Params: Params
		});
	}
	
	$UI.linkbutton('#FMouldClearBT',{
		onClick:function(){
			MouldDafult();
		}
	});
	$UI.linkbutton('#FMouldSelectBT', {
		onClick: function () {
			var Row = MouldPurMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的模板!');
				return;
			}
			SelectFn(Row.RowId);
			$HUI.dialog('#MouldWin').close();
		}
	});
	$UI.linkbutton('#FMouldCreateBT', {
		onClick: function(){
			var Row = MouldPurMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的模板!');
				return;
			}
			var DetailRows = MouldPurDetailGrid.getSelections();
			if(isEmpty(DetailRows)){
				$UI.msg('alert', '请选择需要制单的模板明细数据!');
				return;
			}
			var InppiArr = [];
			$.each(DetailRows, function(index, row){
				var Inppi = row['RowId'];
				InppiArr.push(Inppi);
			});
			var InppiIdStr = InppiArr.join('^');
			CreateFn(Row['RowId'], InppiIdStr);
			$HUI.dialog('#MouldWin').close();
		}
	});
	
	$HUI.combobox('#FMouldPurLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PurLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var MouldPurDetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title:"RowId",
			field:'RowId',
			width:60,
			hidden:true
		}, {
			title:"代码",
			field:'InciCode',
			width:100
		}, {
			title:"名称",
			field:'InciDesc',
			width:100
		},{
			title:"规格",
			field:'Spec',
			width:100
		}, {
			title:"具体规格",
			field:'SpecDesc',
			width:100
		}, {
			title:"采购数量",
			field:'Qty',
			width:100,
			align:'right'
		}, {
			title:"单位",
			field:'UomDesc',
			width:100
		}, {
			title:"进价",
			field:'Rp',
			width:100,
			align:'right'
		}, {
			title:"进价金额",
			field:'RpAmt',
			width:100,
			align:'right'
		}, {
			title:"厂商",
			field:'ManfDesc',
			width:100
		}, {
			title:"供应商",
			field:'VendorDesc',
			width:100
		}, {
			title:"配送商",
			field:'CarrierDesc',
			width:100
		}, {
			title:"库存上限",
			field:'MaxQty',
			width:100,
			align:'right'
		}, {
			title:"库存下限",
			field:'MinQty',
			width:100,
			align:'right'
		}
	]];
	
	var MouldPurDetailGrid = $UI.datagrid('#MouldPurDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlanItm',
			QueryName: 'Query'
		},
		columns: MouldPurDetailCm,
		singleSelect: false,
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				MouldPurDetailGrid.selectAll();
			}
		}
	})
	
	var MouldPurMainCm = [[{
			title:"RowId",
			field:'RowId',
			hidden:true
		}, {
			title:"计划单号",
			field:'PurNo',
			width:100
		}, {
			title:"采购科室",
			field:'PurLoc',
			width:100
		}, {
			title:"制单日期",
			field:'CreateDate',
			width:150
		}, {
			title:"制单人",
			field:'CreateUser',
			width:100
		}, {
			title:"采购单完成",
			field:'CompFlag',
			width:100,
			align:'right'
		}
	]];
	
	var MouldPurMainGrid = $UI.datagrid('#MouldPurMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlanMould',
			QueryName: 'QueryMould'
		},
		columns: MouldPurMainCm,
		onSelect:function(index, row){
			MouldPurDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INPurPlanItm',
				QueryName: 'Query',
				PurId: row.RowId
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				MouldPurMainGrid.selectRow(0);
			}
		}
//		,
//		onDblClickRow:function(index, row){
//			Fn(row.RowId);
//			$HUI.dialog('#FindWin').close();
//		}
	});
	
	function MouldDafult(){
		$UI.clearBlock('#FindConditions');
		$UI.clear(MouldPurMainGrid);
		$UI.clear(MouldPurDetailGrid);
		var LocObj = {RowId : $('#PurLoc').combobox('getValue'), Descirption : $('#PurLoc').combobox('getText')};
		//默认主界面的科室
		var FDafultValue = {
			PurLoc: LocObj
		};
		$UI.fillBlock('#FindMouldConditions',FDafultValue);
	}
	MouldDafult();
	MouldQuery();
}