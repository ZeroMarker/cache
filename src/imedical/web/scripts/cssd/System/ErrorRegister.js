//错误信息登记界面js
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
	/*var packageParams=JSON.stringify(addSessionParams());
	$HUI.lookup('#package', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Common.Dicts',
			QueryName: 'GetPackage',
			typeDetial:'1,2,7'
			//Params:packageParams
		}
	});*/
	var typeDetial = "1,2,7";
	var PackageBox = $HUI.combobox('#package', {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackage&ResultSetType=array&typeDetial=' + typeDetial,
			valueField: 'RowId',
			textField: 'Description'
		});
	///灭菌方式下拉数据
	var TempTypeCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterType&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onLoadSuccess: function (data) {
			},
			onSelect: function (record) {
				var rows = ErrorRegistorGrid.getRows();
				var row = rows[ErrorRegistorGrid.editIndex];
				row.SCleanMethodName = record.Description;
			}
		}
	};
	///清洗方式下拉数据
	var CleanTypeBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCleanType&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onLoadSuccess: function (data) {
			},
			onSelect: function (record) {
				var rows = ErrorRegistorGrid.getRows();
				var row = rows[ErrorRegistorGrid.editIndex];
				row.SCleanMethodName = record.Description;
			}
		}
	};
	//默认日期设置
	var Dafult={
		FDate:DateFormatter(new Date())
	}
	$UI.fillBlock('#ErrorRegistorTB',Dafult)

	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			var Params = JSON.stringify($UI.loopBlock('ErrorRegistorTB'));
			ErrorRegistorGrid.load({
				ClassName: "web.CSSDHUI.System.ErrorRegistror",
				QueryName: "SelectAll",
				Params:Params
			});
		}
	});
	$UI.linkbutton('#AddBT',{ 
		onClick:function(){
            ErrorRegistorGrid.commonAddRow();
		}
	});
	//保存单据
    $UI.linkbutton('#SaveBT',{ 
        onClick:function(){
            saveMast()
        }
    });
	//导出单据
    $UI.linkbutton('#ExportBT',{ 
        onClick:function(){
            exportAll()
        }
    });
	var ParamsTB = JSON.stringify($UI.loopBlock('ErrorRegistorTB'));
    function saveMast(ParamsObj){
		var Rows=ErrorRegistorGrid.getChangesData();
		if(isEmpty(Rows)){
			//$UI.msg('alert','没有需要保存的信息!');
			return;
		}
        $.cm({
				ClassName: 'web.CSSDHUI.System.ErrorRegistror',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Params2: ParamsTB
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					ErrorRegistorGrid.reload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
    }
	$UI.linkbutton('#DeleteBT',{ 
		onClick:function(){
			ErrorRegistorGrid.commonDeleteRow();
			Delete();
		}
	});
	function Delete(){
		var Rows=ErrorRegistorGrid.getSelectedData()
		if(isEmpty(Rows)){
			//$UI.msg('alert','没有选中的信息!')
			return;
		}
		$.messager.confirm("操作提示","您确定要执行删除操作吗？",function(data){
			if(data){
				$.cm({
					//ClassName: 'web.CSSDHUI.System.VenderConfig',
					//MethodName: 'DeleteVenderInfo',
					//Params: JSON.stringify(Rows)
					},function(jsonData){
						if(jsonData.success==0){
							$UI.msg('success',jsonData.msg);
							ErrorRegistorGrid.reload()
						}else{
						 	$UI.msg('error',jsonData.msg);
						}
					});
			}
		});
	}
	
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			$UI.clearBlock('ErrorRegistorTB');
			$UI.clear(ErrorRegistorGrid);
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
    var ErrorRegistorCm = [[
			{
				title: 'RowId',
				field: 'RowId',
				align: 'left',
				width:100,
				hidden: true
			},{
				title: 'TransDr',
				field: 'TransDr',
				align: 'left',
				width:100,
				hidden: true
			}, {
				title: '清洗机号',
				field: 'CleanMachineNo',
				align: 'left',
				width:80,
				sortable: true
			}, {
				title: '灭菌器号',
				field: 'SterMachineNo',
				align: 'left',
				width:80,
				sortable: true
			}, {
				title: '日期',
				field: 'ErrorDate',
				align: 'left',
				width:100,
				sortable: true
			}, {
				title: '时间',
				field: 'ErrorTime',
				align: 'left',
				width:100,
				sortable: true
			},{
				title: '消毒包名称',
				field: 'PackageName',
				align: 'left',
				width:150,
				sortable: true
			},{
				title: '清洗人Dr',
				field: 'CleanUser',
				align: 'left',
				width:100,
				hidden: true
			},{
				title: '清洗人',
				field: 'CleanUserName',
				align: 'left',
				width:100,
				sortable: true
			},{
				title: '清洗方式DR',
				field: 'CleanMethodDR',
				align: 'left',
				width:100,
				hidden: true
			},{
				title: '清洗方式',
				field: 'CleanMethodName',
				align: 'left',
				width:100,
				sortable: true
			},{
				title: '清洗单号',
				field: 'CleanNo',
				align: 'left',
				width:130,
				sortable: true
			},{
				title: '灭菌人DR',
				field: 'SterUser',
				align: 'left',
				width:100,
				hidden: true
			},{
				title: '灭菌人',
				field: 'SterUserName',
				align: 'left',
				width:100,
				sortable: true
			},{
				title: '灭菌单号',
				field: 'SterNo',
				align: 'left',
				width:120,
				sortable: true
			},{
				title: '灭菌方式DR',
				field: 'SterMethodDr',
				align: 'left',
				width:100,
				hidden: true
			},{
				title: '灭菌方式',
				field: 'SterMethodName',
				align: 'left',
				width:100,
				sortable: true
			},{
				title: '更正清洗方式',
				field: 'SCleanMethodDr',
				align: 'left',
				width:100,
				sortable: true,
				formatter: CommonFormatter(CleanTypeBox, 'SCleanMethodDr', 'SCleanMethodName'),
				editor: CleanTypeBox
			},{
				title: '更正灭菌方式',
				field: 'SSterMethodDr',
				align: 'left',
				width:100,
				sortable: true,
				formatter: CommonFormatter(TempTypeCombox, 'SSterMethodDr', 'SSterMethodName'),
				editor: TempTypeCombox
			},{
				title: '更正人',
				field: 'UpdateUserName',
				align: 'left',
				width:100,
				sortable: true
			},{
				title: '备注',
				field: 'Remark',
				align: 'left',
				width:100,
				sortable: true,
				editor:{type:'validatebox'}
			}
		]];
		
    var ErrorRegistorGrid = $UI.datagrid('#ErrorRegistorGrid', {
        queryParams: {
			ClassName: "web.CSSDHUI.System.ErrorRegistror",
			QueryName: "SelectAll",
			Params:ParamsTB
        },
		lazy:false,
        columns: ErrorRegistorCm,
		showBar:true,
		showSaveItems: true,
		saveDataFn: function(){
			saveMast();
		},
		//toolbar: '#ErrorRegistorTB',
		onClickCell: function (index, filed, value) {
			ErrorRegistorGrid.commonClickCell(index, filed);
		}
    });

}
$(init);