var FindWin = function(Fn,HvFlag){
	if(HvFlag == typeof(undefined)){
		HvFlag = '';
	}
	$HUI.dialog('#FindWin').open()
	$UI.linkbutton('#FQueryBT',{
		onClick:function(){
			Query();
		}	
	});
	function Query(){
			$UI.clear(INScrapMainGrid);
			$UI.clear(INScrapDetailGrid);
			var ParamsObj=$UI.loopBlock('#FindConditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg('alert','开始日期不能为空!');
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','截止日期不能为空!');
				return;
			}
			if(isEmpty(ParamsObj.SupLoc)){
				$UI.msg('alert','科室不能为空!');
				return;
			}
			ParamsObj.HvFlag=HvFlag
			var Params=JSON.stringify(ParamsObj);
			$UI.setUrl(INScrapMainGrid)
			INScrapMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINScrap',
				QueryName: 'DHCINSpM',
				Params:Params
			});
	}
	$UI.linkbutton('#FComBT',{
		onClick:function(){
			var Row=INScrapMainGrid.getSelected()
			if(isEmpty(Row)){
				$UI.msg('alert','请选择要返回的报损单!');
				return;
			}
			Fn(Row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});
	$UI.linkbutton('#FClearBT',{
		onClick:function(){
			Dafult();
		}
	});
	var FSupLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var FSupLocBox = $HUI.combobox('#FSupLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FSupLocParams,
			valueField: 'RowId',
			textField: 'Description'
		});		
	var INScrapMainCm=[[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		},{
			title: '报损单号',
			field: 'No',
			width: 150
		},{
			title: '科室',
			field: 'LocDesc',
			width: 150
	
		},{
			title: "报损日期",
			field: 'Date',
			width: 150
		},{
			title: "原因",
			field: 'ReasonDesc',
			width: 150
			
		},{
			title: "完成状态",
			field: 'Completed',
			width: 100,
			align:'center',
			formatter: BoolFormatter
		},{
			title: "审核状态",
			field: 'ChkFlag',
			width: 100,
			align:'center',
			formatter: BoolFormatter
		},{
			title: "备注",
			field: 'Remark',
			width: 200
		}
	
	]];
	var INScrapMainGrid = $UI.datagrid('#INScrapMainGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrap',
			QueryName: 'DHCINSpM'
		},
		columns: INScrapMainCm,
		onSelect:function(index, row){
			$UI.setUrl(INScrapDetailGrid)
			INScrapDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
				QueryName: 'DHCINSpD',
				Inscrap: row.RowId
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				INScrapMainGrid.selectRow(0);
			}
		},
		onDblClickRow:function(index,row){
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	})

	var INScrapDetailCm=[[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		},{
			title: '批次RowId',
			field: 'Inclb',
			width:150,
			hidden:true
		},{
			title: '物资RowId',
			field: 'Incil',
			width:150,
			hidden:true
		},{
			title: '物资代码',
			field: 'InciCode',
			width: 72
		},{
			title: '物资名称',
			field: 'InciDesc',
			width: 140
		},{
			title: '高值条码',
			field: 'HVBarCode',
			width: 150
		},{
			title: "批次~效期",
			field: 'BatExp',
			width: 150
		},{
			title: "厂商",
			field: 'Manf',
			width: 150
		},{
			title: "报损数量",
			field: 'Qty',
			width: 72
		},{
			title:'单位',
			field:'PurUomDesc',
			width:80
		},{
			title:'进价',
			field:'Rp',
			width:80
		},{
			title:'进价金额',
			field:'RpAmt',
			width:80
		},{
			title:'规格',
			field:'Spec',
			width:80
		},{
			title:'售价',
			field:'Sp',
			width:80
		},{
			title:'售价金额',
			field:'SpAmt',
			width:80
		},{
			title:'批价',
			field:'Pp',
			width:80
		},{
			title:'批价金额',
			field:'PpAmt',
			width:80
		},{
			title:'批次可用库存',
			field:'AvaQty',
			width:80
		}
	]];

	var INScrapDetailGrid = $UI.datagrid('#INScrapDetailGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
			QueryName: 'DHCINSpD'
		},
		columns: INScrapDetailCm
	})
	/*--设置初始值--*/
	var Dafult=function(){
		var StDate = DateAdd(new Date(), 'd', parseInt(-7));
		$UI.clearBlock('#FindConditions');
		$UI.clear(INScrapMainGrid);
		$UI.clear(INScrapDetailGrid);
		///设置初始值 考虑使用配置
		var DafultValue={
			StartDate:DateFormatter( StDate),
			EndDate:DateFormatter(new Date()),
			SupLoc:gLocObj,
			Audit: "N"
		}
		$UI.fillBlock('#FindConditions',DafultValue) //填充
	}
	Dafult();
	Query();
}

