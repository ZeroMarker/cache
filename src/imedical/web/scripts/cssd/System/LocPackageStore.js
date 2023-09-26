var init = function () {
	var PhaLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PhaLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var PackageBox = $HUI.combobox('#Package', {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackage&ResultSetType=array&typeDetial=2',
			valueField: 'RowId',
			textField: 'Description'
	});
	var LocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var LocCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+LocParams,
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			onSelect:function(record){
				var rows =PackageStoreGrid.getRows();
				var row = rows[PackageStoreGrid.editIndex];
				row.LocDesc=record.Description;
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	};
	var PackageCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackage&ResultSetType=array&typeDetial=2',
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			onSelect:function(record){
				var rows =PackageStoreGrid.getRows();
				var row = rows[PackageStoreGrid.editIndex];
				row.PackageDesc=record.Description;
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	};
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			var Params = JSON.stringify($UI.loopBlock('PackageTB'));
			PackageStoreGrid.load({
				ClassName: 'web.CSSDHUI.System.LocPackageStock',
				QueryName: 'GetLocPackageStock',
				Params: Params
			});
		}
	});
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			$UI.clearBlock('PackageTB');
			$UI.clear(PackageStoreGrid);
		}
	});
	$UI.linkbutton('#AddBT',{ 
		onClick:function(){
			PackageStoreGrid.commonAddRow();
		}
	});
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			var Rows=PackageStoreGrid.getChangesData();
			if(isEmpty(Rows)){
				//$UI.msg('alert','没有需要保存的信息!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.LocPackageStock',
				MethodName: 'Save',
				Params: JSON.stringify(Rows)
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					PackageStoreGrid.reload();
				}else{
					$UI.msg('error',jsonData.msg);
				 }
			});
		}
	});
	$UI.linkbutton('#DeleteBT',{ 
		onClick:function(){
			PackageStoreGrid.commonDeleteRow();
			Delete();
		}
	});
	function Delete(){
		var Rows=PackageStoreGrid.getSelectedData()
		if(isEmpty(Rows)){
			//$UI.msg('alert','没有选中的信息!')
			return;
		}
		$.messager.confirm("操作提示","您确定要执行删除操作吗？",function(data){
			if(data){
				$.cm({
					ClassName: 'web.CSSDHUI.System.LocPackageStock',
					MethodName: 'Delete',
					Params: JSON.stringify(Rows)
					},function(jsonData){
						if(jsonData.success==0){
							$UI.msg('success',jsonData.msg);
							PackageStoreGrid.reload()
						}else{
						 	$UI.msg('error',jsonData.msg);
						}
					});
			}
		});
	}
	
		
	
	var PackageStoreGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		},{
			title: '科室名称',
			field: 'LocId',
			width: 200,
			formatter: CommonFormatter(LocCombox,'LocId','LocDesc'),
			editor:LocCombox
		}, {
			title: '消毒包名称',
			field: 'PackageId',
			width: 250,
			formatter: CommonFormatter(PackageCombox, 'PackageId','PackageDesc'),
			editor: PackageCombox	
		}, {
			title: '定额',
			align:'right',
			field: 'NormQty',
			width: 100,
			editor:{type:'numberbox',options:{required:true,min:1}}
		}, {
			title: '现有库存',
			align:'right',
			field: 'CurQty',
			width: 100,
			editor:{type:'numberbox',options:{required:true,min:1}}
		}
	]];
	var PackageStoreGrid = $UI.datagrid('#PackageStoreGrid', {
		lazy:false,
		queryParams: {
			ClassName: 'web.CSSDHUI.System.LocPackageStock',
			QueryName: 'GetLocPackageStock'
		},
		columns: PackageStoreGridCm,
		//deleteRowParams: {
			//ClassName: 'web.CSSDHUI.System.LocPackageStock',
			//MethodName: 'Delete'
		//},
		toolbar: '#PackageTB',
		//sortName: 'RowId',
		//sortOrder: 'Desc',
		onClickCell: function (index, filed, value) {
			PackageStoreGrid.commonClickCell(index, filed);
		}
	});
}
$(init);