var FindWin=function(Fn){
	$HUI.dialog('#FindWin').open()
	
	/*--按钮功能--*/
	$UI.linkbutton('#FQueryBT',{
		onClick:function(){
			$UI.clear(PoMainGrid);
			$UI.clear(PoDetailGrid);
			var ParamsObj=$UI.loopBlock('#FindConditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg("alert","开始日期不能为空");
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg("alert","截止日期不能为空");
				return;
			}
			if(isEmpty(ParamsObj.PoLoc)){
				$UI.msg("alert","订单科室不能为空");
				return;
			}
			ParamsObj.ApproveFlag="N"
			var Params=JSON.stringify(ParamsObj);
			PoMainGrid.load({
				ClassName: 'web.DHCSTMHUI.INPO',
				QueryName: 'QueryMain',
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
		var Row=PoMainGrid.getSelected()
		if(isEmpty(Row)){
			$UI.msg("alert","请选择要选取的订单");
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
	var FPoLocBox = $HUI.combobox('#FPoLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PoLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var FVendorBox = $HUI.combobox('#FVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams=function(){
		var PoLoc=$("#FPoLoc").combo('getValue');
		var Obj={StkGrpRowId:"",StkGrpType:"M",Locdr:PoLoc};
		return Obj
	}
	$("#FInciDesc").lookup(InciLookUpOp(HandlerParams,'#FInciDesc','#FInci'));
	
	var CompBox = $HUI.combobox('#FCompFlag', {
		data:[{'RowId':'','Description':'全部'},{'RowId':'N','Description':'未完成'},{'RowId':'Y','Description':'已完成'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	/*--Grid--*/
	var PoDetailCm = [[{
			title:"RowId",
			field:'RowId',
			hidden:true
		}, {
			title:"物资RowId",
			field:'InciId',
			width:100,
			hidden:true
		}, {
			title:"代码",
			field:'InciCode',
			width:100
		},{
			title:"描述",
			field:'InciDesc',
			width:100
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
			title:"订购数量",
			field:'PurQty',
			width:100,
			align:'right'
		}, {
			title:"进价金额",
			field:'RpAmt',
			width:100,
			align:'right'
		}, {
			title:"到货数量",
			field:'ImpQty',
			width:100,
			align:'right'
		}, {
			title:"未到货数量",
			field:'AvaQty',
			width:100,
			align:'right'
		}, {
			title:"是否撤销",
			field:'CancleFlag',
			width:100
		}
	]];
	
	var PoDetailGrid = $UI.datagrid('#PoDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPOItm',
			QueryName: 'Query'
		},
		columns: PoDetailCm,
		sortName: 'RowId',
		sortOrder: 'Desc'
	})
	
	var PoMainCm = [[{
			title:"RowId",
			field:'RowId',
			hidden:true
		}, {
			title:"订单号",
			field:'PoNo',
			width:100
		}, {
			title:"订单科室",
			field:'PoLocDesc',
			width:100
		}, {
			title:"供应商",
			field:'VendorDesc',
			width:150
		}, {
			title:"订单状态",
			field:'PoStatus',
			width:100,
			formatter:function(value){
				var PoStatus='';
				if(value==0){
					PoStatus='未入库';
				}else if(value==1){
					PoStatus='部分入库';
				}else if(value==2){
					PoStatus='全部入库';
				}
				return PoStatus;
			}
		}, {
			title:"订单日期",
			field:'CreateDate',
			width:100
		}, {
			title:"完成",
			field:'CompFlag',
			width:100
		}
	]];
	
	var PoMainGrid = $UI.datagrid('#PoMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPO',
			QueryName: 'QueryMain'
		},
		columns: PoMainCm,
		/*toolbar:[{
			text: '选取',
			iconCls: 'icon-accept',
			handler: function () {
				FSelect();
			}
		}],*/
		onSelect:function(index, row){
			PoDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INPOItm',
				QueryName: 'Query',
				PoId: row.RowId
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				PoMainGrid.selectRow(0);
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
		$UI.clear(PoMainGrid);
		$UI.clear(PoDetailGrid);
		///设置初始值 考虑使用配置
		var FDafultValue={
			StartDate:DateAdd(new Date(), 'd', parseInt(-7)),
			EndDate:new Date(),
			PoLoc:gLocObj,
			CompFlag:'N'
		}
		$UI.fillBlock('#FindConditions',FDafultValue)
	}
	FDafult()
}