//外来器械登记界面js
function deleteMain(mainRowId,PackageType){
	if (isEmpty(mainRowId)) {
		$UI.msg('alert','请选择要删除的单据!');
		return false;
	}
	$.messager.confirm("操作提示","您确定要执行删除操作吗？",function(data){	
		if(data){
			$.cm({
				ClassName:'web.CSSDHUI.PackageInfo.Package',
				MethodName:'DeleteMain',
				mainRowId:mainRowId,
				PackageType:PackageType
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$('#PackageList').datagrid('reload');
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
}

var init = function () {
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			var Params = JSON.stringify($UI.loopBlock('VenderTB'));
			VenderGrid.load({
				ClassName: "web.CSSDHUI.System.VenderConfig",
				QueryName: "QueryVenderInfo",
				Params:Params
			});
		}
	});
	$UI.linkbutton('#AddBT',{ 
		onClick:function(){
            VenderGrid.commonAddRow();
		}
	});
	//保存单据
    $UI.linkbutton('#SaveBT',{ 
        onClick:function(){
            saveMast()
        }
    });
    function saveMast(ParamsObj){
		var Rows=VenderGrid.getChangesData();
		if(isEmpty(Rows)){
			//$UI.msg('alert','没有需要保存的信息!');
			return;
		}
        $.cm({
				ClassName: 'web.CSSDHUI.System.VenderConfig',
				MethodName: 'SaveVenderInfo',
				Params: JSON.stringify(Rows)
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					VenderGrid.reload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
    }
	$UI.linkbutton('#DeleteBT',{ 
		onClick:function(){
			VenderGrid.commonDeleteRow();
			Delete();
		}
	});
	function Delete(){
		var Rows=VenderGrid.getSelectedData()
		if(isEmpty(Rows)){
			//$UI.msg('alert','没有选中的信息!')
			return;
		}
		$.messager.confirm("操作提示","您确定要执行删除操作吗？",function(data){
			if(data){
				$.cm({
					ClassName: 'web.CSSDHUI.System.VenderConfig',
					MethodName: 'DeleteVenderInfo',
					Params: JSON.stringify(Rows)
					},function(jsonData){
						if(jsonData.success==0){
							$UI.msg('success',jsonData.msg);
							VenderGrid.reload()
						}else{
						 	$UI.msg('error',jsonData.msg);
						}
					});
			}
		});
	}
	
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			$UI.clearBlock('VenderTB');
			$UI.clear(VenderGrid);
		}
	});
	
	var NotUseFlagData=[{
	            "RowId":"Y",
	            "Description":"是"
	        },{
	            "RowId":"N",
	            "Description":"否"   
	        }]
	        
	var NotUseFlagCombox= {
	    type: 'combobox',
	    options: {
	        data:NotUseFlagData,
	        valueField: 'RowId',
	        textField: 'Description',
	        editable:true
	    }
	};
    var VenderCm = [[
			{
				title: 'RowId',
				field: 'RowId',
				align: 'left',
				width:100,
				hidden: true
			}, {
				title: '厂商名称',
				field: 'Name',
				align: 'left',
				width:200,
				sortable: true,
				editor:{type:'validatebox',options:{required:true}}
			}, {
				title: '厂商代码',
				field: 'Code',
				align: 'left',
				width:150,
				sortable: true,
				editor:{type:'validatebox',options:{required:true}}
			}, {
				title: '配送人',
				field: 'SaleManName',
				align: 'left',
				width:150,
				sortable: true,
				editor:{type:'validatebox',options:{required:true}}
			}, {
				title: '电话',
				field: 'Telephone',
				align: 'left',
				width:150,
				sortable: true,
				editor:{type:'numberbox',options:{required:true}}
			},{
				title: '地址',
				field: 'Address',
				align: 'left',
				width:300,
				sortable: true,
				editor:{type:'validatebox'}
			},{
				title: '是否启用',
				field: 'IsStop',
				align: 'left',
				width:100,
				sortable: true,
				formatter: CommonFormatter(NotUseFlagCombox, 'IsStop', 'IsStopName'),
				editor: NotUseFlagCombox
			}
		]];
		
    var VenderGrid = $UI.datagrid('#VenderGrid', {
        queryParams: {
			ClassName: "web.CSSDHUI.System.VenderConfig",
			QueryName: "QueryVenderInfo"
        },
		lazy:false,
        columns: VenderCm,
		toolbar: '#VenderTB',
		onClickCell: function (index, filed, value) {
			VenderGrid.commonClickCell(index, filed);
		}
    });

}
$(init);