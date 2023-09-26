var init = function () {
	var IsBdData = [{ "RowId":"Y", "Description":"是"},{ "RowId":"N", "Description":"否"}]
	var NotUseFlagData = [{ "RowId":"Y", "Description":"是"},{ "RowId":"N", "Description":"否"}]
	var IsBdCombox = {
		type: 'combobox',
		options: {
			data: IsBdData,
			valueField: 'RowId',
			textField: 'Description'
		}
	}
	
	var NotUseFlagCombox = {
		type: 'combobox',
		options: {
			data: NotUseFlagData,
			valueField: 'RowId',
			textField: 'Description'
		}
	}

	var MachineTypeDataSearch =[{'RowId':'','Description':'全部'},{'RowId':'sterilizer','Description':'灭菌器'},{'RowId':'washer','Description':'清洗机'}]
	var MachineTypeBoxSearch = $HUI.combobox('#MachineType', {
		data:MachineTypeDataSearch,
		valueField: 'RowId',
		textField: 'Description'
	});
	var machineTypeBoxComboxSearch = {
		type: 'combobox',
		options: {
			data: MachineTypeDataSearch,
			valueField: 'RowId',
			textField: 'Description',
			required:true
		}
	} 
	
	var MachineTypeData =[{'RowId':'sterilizer','Description':'灭菌器'},{'RowId':'washer','Description':'清洗机'}]
	var MachineTypeBox = $HUI.combobox( {
		data:MachineTypeData,
		valueField: 'RowId',
		textField: 'Description'
	});
	var machineTypeBoxCombox = {
		type: 'combobox',
		options: {
			data: MachineTypeData,
			valueField: 'RowId',
			textField: 'Description',
			required:true
		}
	} 	
	
	///灭菌车下拉数据
	var AllSterCarBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllSterCar&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = MachineInfoGrid.getRows();
				var row = rows[MachineInfoGrid.editIndex];
				row.SterCarName = record.Description;
			}
		}
	};
	
	///灭菌方式下拉数据
	var TempTypeCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterType&ResultSetType=array&isSter=Y',
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = MachineInfoGrid.getRows();
				var row = rows[MachineInfoGrid.editIndex];
				row.TempTypeDesc = record.Description;
			}
		}
	};

	
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			var Params = JSON.stringify($UI.loopBlock('MachineTB'));
			MachineInfoGrid.load({
				ClassName: 'web.CSSDHUI.System.MachineConfig',
				QueryName: 'QueryMachineInfo',
				Params: Params
			});
		}
	});
	$UI.linkbutton('#AddBT',{ 
		onClick:function(){
			MachineInfoGrid.commonAddRow();
		}
	});
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			$UI.clearBlock('MachineTB');
			$UI.clear(MachineInfoGrid);
		}
	});
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			var Rows=MachineInfoGrid.getChangesData();
			if(isEmpty(Rows)){
				//$UI.msg('alert','没有需要保存的信息!');
				return;
		}
			$.cm({
				ClassName: 'web.CSSDHUI.System.MachineConfig',
				MethodName: 'SaveMachineInfo',
				Params: JSON.stringify(Rows)
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					MachineInfoGrid.reload();
				}else{
					$UI.msg('error',jsonData.msg);
				 }
			});
		}
	});
	$UI.linkbutton('#DeleteBT',{ 
		onClick:function(){
			MachineInfoGrid.commonDeleteRow();
			var rowMachine = $('#MachineInfoGrid').datagrid('getSelected');
			if(!isEmpty(rowMachine)&&!isEmpty(rowMachine.RowId)){
				$UI.msg('alert','已维护机器数据只能停用,不能删除');
			}
			//Delete();
		}
	});
	function Delete(){
		var Rows=MachineInfoGrid.getSelectedData()
		if(isEmpty(Rows)){
			//$UI.msg('alert','没有选中的信息!')
			return;
		}
		$.messager.confirm("操作提示","您确定要执行删除操作吗？",function(data){
			if(data){
				$.cm({
					ClassName: 'web.CSSDHUI.System.MachineConfig',
					MethodName: 'DeleteMachineInfo',
					Params: JSON.stringify(Rows)
					},function(jsonData){
						if(jsonData.success==0){
							$UI.msg('success',jsonData.msg);
							MachineInfoGrid.reload()
						}else{
						 	$UI.msg('error',jsonData.msg);
						}
					});
			}
		});
	}
	$UI.linkbutton('#ReloadBT',{ 
		onClick:function(){
			MachineConfigSyn();
		}
	});
	var MachineInfoGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			width: 10,
			hidden: true
		},{
			title: '代码',
			field: 'Key',
			width: 100,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title:'别名',
			field:'Alias',
			width:100,
			editor:{type:'validatebox',options:{required:true}}
		},{
			title: '机器号',
			align:'right',
			field: 'MachineNum',
			width: 100,
			editor:{type:'validatebox',options:{required:true}}	
		}, {
			title: '机器类型',
			field: 'MachineType',
			width: 100,
			formatter: CommonFormatter(machineTypeBoxCombox,'MachineType','MachineTypeDesc'),
			editor:machineTypeBoxCombox
		},{
			title: '温度类型',
			align:'center',
			field: 'TempType',
			width:100,
			formatter: CommonFormatter(TempTypeCombox, 'TempType', 'TempTypeDesc'),
			editor: TempTypeCombox
		},{
			title: '灭菌车',
			align:'center',
			field: 'SterCar',
			width:150,
			formatter: CommonFormatter(AllSterCarBox, 'SterCar', 'SterCarName'),
			editor: AllSterCarBox
		},{
			title: '装载数量',
			field: 'LoadNum',
			align: 'right',
			width: 100,
			editor: {type: 'numberbox'}
		}, {
			title: '厂商',
			field: 'Manufacture',
			width:150,
			editor:{type:'validatebox',options:{}}
		}, {
			title: '数据路径',
			field: 'DataPath',
			width:300,
			editor:{type:'validatebox',options:{}}
		}, {
			title: '扩展类型',
			field: 'ExtType',
			width:150,
			editor:{type:'validatebox',options:{}}
		},{
			title:'是否BD测试',
			align:'center',
			field:'IsBd',
			width:100,
			formatter: CommonFormatter(IsBdCombox,'IsBd','IsBdDesc'),
			editor:IsBdCombox
		},{
			title: '是否启用',
			align:'center',
			field: 'NotUseFlag',
			width:100,
			formatter: CommonFormatter(NotUseFlagCombox, 'NotUseFlag', 'NotUseFlagDesc'),
			editor: NotUseFlagCombox
		}
	]];
	function MachineConfigSyn(){
		$.cm({
			ClassName: 'web.CSSDHUI.System.MachineConfig',
			MethodName: 'MachineConfigSyn'
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success','参考值同步成功！');
				MachineInfoGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	};
	var MachineInfoGrid = $UI.datagrid('#MachineInfoGrid', {
		lazy:false,
		queryParams: {
			ClassName: 'web.CSSDHUI.System.MachineConfig',
			QueryName: 'QueryMachineInfo'
		},
		columns: MachineInfoGridCm,
		//deleteRowParams: {
			//ClassName: 'web.CSSDHUI.System.MachineConfig',
			//MethodName: 'DeleteMachineInfo'
		//},
		toolbar: '#MachineTB',
//		toolbar:[{
//            text: '参考值',
//            iconCls: 'icon-reload',
//            handler: function () {
//                MachineConfigSyn();
//        }}],

		onClickCell: function (index, filed, value) {
			MachineInfoGrid.commonClickCell(index, filed);
		}
	});
}
$(init);