var init = function(){
	var DepartmentComData = $.cm({
		ClassName: 'web.DHCSTMHUI.Common.Dicts',
		QueryName: 'GetCTLoc',
		ResultSetType: 'array'
	},false);
	var DepartmentCombox = {
		type: 'combobox',
		options: {
			data: DepartmentComData,
			valueField: 'RowId',
			textField: 'Description'
		}
	}
	$UI.linkbutton('#SearchBT', {
		onClick: function(){
			Query();
		}
	});
	function Query(){
		var Params = JSON.stringify($UI.loopBlock('DepartmentTB'));
			DepartmentGrid.load({
			ClassName: 'web.DHCSTMHUI.DepartmentCompare',
			QueryName: 'SelectAll',
			Params: Params
		});
	}
	
	$UI.linkbutton('#AddBT', {
		onClick: function(){
			DepartmentGrid.commonAddRow();
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function(){
			var Rows=DepartmentGrid.getChangesData();
			if (Rows === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DepartmentCompare',
				MethodName: 'Save',
				Params: JSON.stringify(Rows)
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success', jsonData.msg);
					DepartmentGrid.reload();
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#DeleteBT', {
		onClick: function(){
			var Rows = DepartmentGrid.getSelections();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DepartmentCompare',
				MethodName: 'Delete',
				Params: JSON.stringify(Rows)
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					DepartmentGrid.reload();
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	
	var DepartmentCm=[[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		},{
			title:'名称',
			field:'LocId',
			formatter: CommonFormatter(DepartmentCombox,'LocId','LocDesc'),
			width:200,
			editor:DepartmentCombox
		},{
			title:'HIS科室代码',
			field:'HISCode',
			width:200,
			editor:{type:'validatebox',options:{required:true}}
		},{
			title:'HIS科室名称',
			field:'HISDesc',
			width:300,
			editor:{type:'validatebox',options:{required:true}}
		}
	]];
	
	var DepartmentGrid = $UI.datagrid('#Department',{
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DepartmentCompare',
			QueryName: 'SelectAll'
		},
		columns: DepartmentCm,
		toolbar: '#DepartmentTB',
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickCell: function(index, filed ,value){
			DepartmentGrid.commonClickCell(index,filed);
		}
	});
	
	Query();
}
$(init);