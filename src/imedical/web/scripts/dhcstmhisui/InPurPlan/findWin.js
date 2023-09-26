var FindWin=function(Fn){
	$HUI.dialog('#FindWin').open()
	
	/*--按钮功能--*/
	$UI.linkbutton('#FQueryBT',{
		onClick:function(){
			$UI.clear(PurMainGrid);
			$UI.clear(PurDetailGrid);
			var ParamsObj=$UI.loopBlock('#FindConditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg("alert","开始日期不能为空");
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg("alert","截止日期不能为空");
				return;
			}
			if(isEmpty(ParamsObj.PurLoc)){
				$UI.msg("alert","采购科室不能为空");
				return;
			}
			ParamsObj.AuditFlag="N"
			var Params=JSON.stringify(ParamsObj);
			PurMainGrid.load({
				ClassName: 'web.DHCSTMHUI.INPurPlan',
				QueryName: 'Query',
				Params:Params
			});
		}
	});
	
	$UI.linkbutton('#FSelectBT',{
		onClick:function(){
			FSelect()
		}
	});
	function FSelect(){
		var Row=PurMainGrid.getSelected()
		if(isEmpty(Row)){
			$UI.msg("alert","请选择要选取的采购计划单");
			return;
		}
		Fn(Row.RowId);
		$HUI.dialog('#FindWin').close();
	}
	$UI.linkbutton('#FClearBT',{
		onClick:function(){
			FDafult()
		}
	});
	
	/*--绑定控件--*/
	var FPurLocBox = $HUI.combobox('#FPurLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PurLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var FVendorBox = $HUI.combobox('#FVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams=function(){
		var StkScg=$("#FStkScg").combotree('getValue');
		var PurLoc=$("#FPurLoc").combo('getValue');
		var Obj={StkGrpRowId:StkScg,StkGrpType:"M",Locdr:PurLoc};
		return Obj
	}
	$("#FInciDesc").lookup(InciLookUpOp(HandlerParams,'#FInciDesc','#FInci'));
	
	var CompBox = $HUI.combobox('#FCompFlag', {
		data:[{'RowId':'','Description':'全部'},{'RowId':'N','Description':'未完成'},{'RowId':'Y','Description':'已完成'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	/*--Grid--*/
	var PurDetailCm = [[{
			title:"RowId",
			field:'RowId',
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
			title:"售价",
			field:'Sp',
			width:100,
			align:'right'
		}, {
			title:"进价金额",
			field:'RpAmt',
			width:100,
			align:'right'
		}, {
			title:"售价金额",
			field:'SpAmt',
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
			title:"请求科室",
			field:'ReqLocDesc',
			width:100
		}, {
			title:"请求科室库存",
			field:'StkQty',
			width:100,
			align:'right'
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
	
	var PurDetailGrid = $UI.datagrid('#PurDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlanItm',
			QueryName: 'Query'
		},
		columns: PurDetailCm,
		sortName: 'RowId',
		sortOrder: 'Desc'
	})
	
	var PurMainCm = [[{
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
			title:"订单审批",
			field:'PoFlag',
			width:100
		}, {
			title:"采购单完成",
			field:'CompFlag',
			width:100,
			align:'right'
		}, {
			title:"拒绝原因",
			field:'RefuseCase',
			width:100,
			align:'right'
		}
	]];
	
	var PurMainGrid = $UI.datagrid('#PurMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			QueryName: 'Query'
		},
		columns: PurMainCm,
		/*toolbar:[{
			text: '选取',
			iconCls: 'icon-accept',
			handler: function () {
				FSelect();
			}
		}],*/
		onSelect:function(index, row){
			PurDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INPurPlanItm',
				QueryName: 'Query',
				PurId: row.RowId
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				PurMainGrid.selectRow(0);
			}
		},
		onDblClickRow:function(index, row){
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	})
	
	/*--设置初始值--*/
	var FDafult=function(){
		$UI.clearBlock('#FindConditions');
		$UI.clear(PurMainGrid);
		$UI.clear(PurDetailGrid);
		///设置初始值 考虑使用配置
		var FDafultValue={
			StartDate:DefaultStDate(),
			EndDate:DefaultEdDate(),
			PurLoc:gLocObj,
			CompFlag:'N'
		}
		$UI.fillBlock('#FindConditions',FDafultValue)
	}
	FDafult()
}