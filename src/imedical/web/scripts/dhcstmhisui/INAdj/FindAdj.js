var FindWin = function(Fn,HvFlag){
	$HUI.dialog('#FindWin').open()
	$UI.linkbutton('#FQueryBT',{
		onClick:function(){
			FindQuery();
		}
	});
	if(HvFlag == undefined){
		HvFlag = '';
	}
	function FindQuery(){
		var ParamsObj=$UI.loopBlock('#FindConditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','开始日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','截止日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.AdjLoc)){
			$UI.msg('alert','科室不能为空!');
			return;
		}	
		ParamsObj.HVFlag=HvFlag;
		var Params=JSON.stringify(ParamsObj);
		$UI.setUrl(INAdjMainGrid)
		$UI.clear(INAdjDetailGrid)
		INAdjMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINAdj',
			QueryName: 'DHCINAdjM',
			Params:Params
		});
	}
	$UI.linkbutton('#FComBT',{
		onClick:function(){
			var Row=INAdjMainGrid.getSelected()
			if(isEmpty(Row)){
				$UI.msg('alert','请选择要返回的调整单!');
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
	var AdjLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var FAdjLocBox = $HUI.combobox('#FAdjLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+AdjLocParams,
			valueField: 'RowId',
			textField: 'Description'
		});		
	var INAdjMainCm=[[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		},{
			title: '调整单号',
			field: 'No',
			width: 150
		},{
			title: '科室',
			field: 'AdjLocDesc',
			width: 150
	
		},{
			title: "调整日期",
			field: 'AdjDate',
			width: 150
		},{
			title: "原因",
			field: 'ReasonDesc',
			width: 150
			
		},{
			title: "完成状态",
			field: 'Completed',
			width: 100	
		},{
			title: "审核状态",
			field: 'chkFlag',
			width: 100
		},{
			title: "备注",
			field: 'remarks',
			width: 200
		}
	
	]];
	var INAdjMainGrid = $UI.datagrid('#INAdjMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINAdj',
			QueryName: 'jsSelect'
		},
		columns: INAdjMainCm,
		onSelect:function(index, row){
			$UI.setUrl(INAdjDetailGrid)
			var Adjrowid = row['RowId'];
			var ParamsObj = {InAdj:Adjrowid};
			INAdjDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINAdjItm',
				QueryName: 'DHCINAdjD',
				Params: JSON.stringify(ParamsObj)
			});
		},
		onDblClickRow:function(index,row){
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				INAdjMainGrid.selectRow(0);
			}
		}
	})

	var INAdjDetailCm=[[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		},{
			title: 'Inclb',
			field: 'Inclb',
			width:150,
			hidden:true
		},{
			title: 'InciId',
			field: 'InciId',
			width:150,
			hidden:true
		},{
			title: '物资代码',
			field: 'Code',
			width: 72
		},{
			title: '物资名称',
			field: 'InciDesc',
			width: 140
		},{
			title: "批次~效期",
			field: 'BatExp',
			width: 150
		},{
			title: "厂商",
			field: 'ManfDesc',
			width: 150
		},{
			title: "调整数量",
			field: 'Qty',
			width: 72
		},{
			title:'单位',
			field:'uomDesc',
			width:80
		},{
			title:'单价',
			field:'Rp',
			width:80
		},{
			title:'金额',
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

	var INAdjDetailGrid = $UI.datagrid('#INAdjDetailGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINAdjItm',
			QueryName: 'DHCINAdjD'
		},
		columns: INAdjDetailCm,
		remoteSort: false
	})
	/*--设置初始值--*/
	var Dafult=function(){
		$UI.clearBlock('#FindConditions');
		$UI.clear(INAdjMainGrid);
		$UI.clear(INAdjDetailGrid);
		///设置初始值 考虑使用配置
		var DafultValue={
			StartDate:DateFormatter(new Date()),
			EndDate:DateFormatter(new Date()),
			AdjLoc:gLocObj,
			CompleteFlag : "N", 
			Audit : "N"
		}
		$UI.fillBlock('#FindConditions',DafultValue) //填充
	}
	Dafult();
	FindQuery();
}

