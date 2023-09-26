// 名称:库存报损单审核
//保存参数值的object
var InScrapParamObj = GetAppPropValue('DHCSTINSCRAPM');
var init = function() {
	var ClearMain=function(){
		$UI.clearBlock('#Conditions');
		$UI.clear(INScrapAuditGrid);
		$UI.clear(INScrapAuditDetailGrid);
		DafultValue()
		$UI.fillBlock('#Conditions',DafultValue)
	}	
//Grid 列 comboxData
	var SupLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
//按钮相关操作
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			$UI.clear(INScrapAuditDetailGrid);
			var ParamsObj=$UI.loopBlock('#Conditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg('alert','开始日期不能为空!');
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','截止日期不能为空!');
				return;
			}
			if(isEmpty(ParamsObj.SupLoc)){
				$UI.msg('alert','供应科室不能为空!');
				return;
			}
			var Params=JSON.stringify(ParamsObj);
			$UI.setUrl(INScrapAuditGrid)
			INScrapAuditGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINScrap',
				QueryName: 'DHCINSpM',
				Params:Params
			});
		}
	});
	$UI.linkbutton('#AduitBT',{
		onClick:function(){
			var Row=INScrapAuditGrid.getSelected()
			if(isEmpty(Row)){
				$UI.msg('alert','请选择报损单!');
				return;
			}			
			var Params=JSON.stringify(addSessionParams({Inscrap:Row.RowId}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINScrap',
				MethodName: 'Audit',
				Params:Params
				
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$UI.clear(INScrapAuditGrid);
					$UI.clear(INScrapAuditDetailGrid);
					INScrapAuditGrid.commonReload();
				}else{
					$UI.msg('error',jsonData.msg);		
				}
			});
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			ClearMain();
		}
	});	
	$UI.linkbutton('#PrintBT',{
		onClick:function(){
			var SelectedRow = INScrapAuditGrid.getSelected();
			if(isEmpty(SelectedRow)){
				$UI.msg('alert',"没有需要打印的单据!");
				return;
			}
			var Inscrap = SelectedRow['RowId'];
			PrintINScrap(Inscrap);
		}
	});
	var INScrapAuditGridCm = [[
	{
		title:"RowId",
		field:'RowId',
		hidden:true
	},{
		title:"报损单号",
		field:'No',
		width:180,
		align:'center',
		sortable:true   
	},{
		title:"科室名称",
		field:'LocDesc',
		width:150
	},{
		title:"制单人",
		field:'UserName',
		width:100,
		align:'left',
		sortable:true
	},{
		title:"制单日期",
		field:'Date',
		width:100,
		align:'left',
		sortable:true
	},{
		title:"制单时间",
		field:'Time',
		width:100,
		align:'left',
		sortable:true
	},{
		title:"完成标志",
		field:'Completed',
		width:80,
		align:'center',
		formatter: BoolFormatter
	},{
		title:"审核标志",
		field:'ChkFlag',
		width:80,
		align:'center',
		formatter: BoolFormatter
	},{
		title:"审核人",
		field:'ChkUserName',
		width:100
	},{
		title:"审核日期",
		field:'ChkDate',
		width:100
	},{
		title:"审核时间",
		field:'ChkTime',
		width:100
	},{
		title:"进价金额",
		field:'RpAmt',
		align: 'right',
		width:100
	},{
		title:"售价金额",
		field:'SpAmt',
		align: 'right',
		width:100
	}
]];
	var INScrapAuditGrid = $UI.datagrid('#INScrapAuditGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrap',
			QueryName: 'DHCINSpM'
		},
		columns: INScrapAuditGridCm,
		showBar: true,
		onSelect:function(index, row){
			$UI.setUrl(INScrapAuditDetailGrid)
			INScrapAuditDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
				QueryName: 'DHCINSpD',
				Inscrap:row.RowId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				INScrapAuditGrid.selectRow(0);
			}
		}
	})
	var INScrapAuditDetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		},{
			title:"批次RowId",
			field:'Inclb',
			width:150,
			hidden: true
		},{
			title:"Incil",
			field:'Incil',
			width:150,
			hidden: true
		},{
			title:"物资代码",
			field:'InciCode',
			width:100
		},{
			title:"物资名称",
			field:'InciDesc',
			width:200,
			editor:'text'
		},{
			title:"高值标志",
			field:'HVFlag',
			width:60,
			hidden:true
		},{
			title:"批号~效期",
			field:'BatExp',
			width:150
		},{
			title:"厂商",
			field:'Manf',
			width:200
		},{
			title:"报损数量",
			field:'Qty',
			width:100,
			align:'right'
		},{
			title:"单位rowid",
			field:'PurUomId',
			width:100,
			hidden:true
		},{
			title:"单位",
			field:'PurUomDesc',
			width:100
		},{
			title:"售价",
			field:'Sp',
			align: 'right',
			width:100
		},{
			title:"售价金额",
			field:'SpAmt',
			align: 'right',
			width:100
		},{
			title:"进价",
			field:'Rp',
			align: 'right',
			width:100
		},{
			title:"进价金额",
			field:'RpAmt',
			align: 'right',
			width:100
		}
	]];
	var INScrapAuditDetailGrid = $UI.datagrid('#INScrapAuditDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
			QueryName: 'DHCINSpD',
			rows: 99999
		},
		pagination:false,
		columns: INScrapAuditDetailGridCm
	})
	/*--设置初始值--*/
	var DafultValue=function(){
		var StDate = DateAdd(new Date(), 'd', parseInt(-7));
		var DafultValue={
			RowId:"",
			SupLoc:gLocObj,
			StartDate:DateFormatter(StDate),
			EndDate:DateFormatter(new Date()),
			Audit:"N"
		}
		$UI.fillBlock('#Conditions',DafultValue)
	}
	DafultValue()
}
$(init);