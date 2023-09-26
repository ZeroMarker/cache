//采购审核级别维护
//zhangxiao 20180521
var init = function() {
	var HospId=gHospId;
	var TableName="DHC_PlanStatus";
	function InitHosp() {
		var hospComp=InitHospCombo(TableName,gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			Query();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				Query();
			};
		}
	}
	function Query(){
		Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		DHCPlanStatusGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPlanStatus',
			QueryName: 'SelectAll',
			Params: Params
		});
	}
	
	$('#AddBT').on('click',function(){
		DHCPlanStatusGrid.commonAddRow();
	})
	$('#SaveBT').on('click',function(){
		var Rows=DHCPlanStatusGrid.getChangesData();
		if (Rows === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return;
		}
		var MainObj=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCPlanStatus',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				DHCPlanStatusGrid.reload();
			}else{
					 $UI.msg('error',jsonData.msg);
				 }
		}
		)
	})
	$('#DeleteBT').on('click',function(){
		var Rows=DHCPlanStatusGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCPlanStatus',
			MethodName: 'Delete',
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				DHCPlanStatusGrid.reload();
			}else{
					 $UI.msg('error',jsonData.msg);
				 }
		}
		)
	})
	var DHCPlanStatusCm=[[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		},{
			title: '代码',
			field: 'Code',
			width:100,
			editor:{type:'validatebox',options:{required:true}}
		},{
			title: '描述',
			field: 'Description',
			width:150,
			editor:{type:'validatebox',options:{required:true}}
		},{
			title: '最大金额',
			field: 'MaxAmt',
			width:100,
			align: 'right',
			editor:{type:'numberbox',options:{required:false}}
		}
	]]
	var DHCPlanStatusGrid = $UI.datagrid('#DHCPlanStatusList',{
		lazy:false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPlanStatus',
			QueryName: 'SelectAll'
		},
		columns: DHCPlanStatusCm,
		toolbar: '#DHCPlanStatusTB',
		sortName: 'RowId',
		sortOrder: 'ASC',
		onClickCell: function(index, filed ,value){
		DHCPlanStatusGrid.commonClickCell(index,filed)
		}
	})
	InitHosp();
}
$(init);