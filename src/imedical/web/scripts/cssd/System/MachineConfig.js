var init = function () {
	var IsBdData = [{ "RowId":"Y", "Description":"��"},{ "RowId":"N", "Description":"��"}]
	var NotUseFlagData = [{ "RowId":"Y", "Description":"��"},{ "RowId":"N", "Description":"��"}]
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

	var MachineTypeDataSearch =[{'RowId':'','Description':'ȫ��'},{'RowId':'sterilizer','Description':'�����'},{'RowId':'washer','Description':'��ϴ��'}]
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
	
	var MachineTypeData =[{'RowId':'sterilizer','Description':'�����'},{'RowId':'washer','Description':'��ϴ��'}]
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
	
	///�������������
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
	
	///�����ʽ��������
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
				//$UI.msg('alert','û����Ҫ�������Ϣ!');
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
				$UI.msg('alert','��ά����������ֻ��ͣ��,����ɾ��');
			}
			//Delete();
		}
	});
	function Delete(){
		var Rows=MachineInfoGrid.getSelectedData()
		if(isEmpty(Rows)){
			//$UI.msg('alert','û��ѡ�е���Ϣ!')
			return;
		}
		$.messager.confirm("������ʾ","��ȷ��Ҫִ��ɾ��������",function(data){
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
			title: '����',
			field: 'Key',
			width: 100,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title:'����',
			field:'Alias',
			width:100,
			editor:{type:'validatebox',options:{required:true}}
		},{
			title: '������',
			align:'right',
			field: 'MachineNum',
			width: 100,
			editor:{type:'validatebox',options:{required:true}}	
		}, {
			title: '��������',
			field: 'MachineType',
			width: 100,
			formatter: CommonFormatter(machineTypeBoxCombox,'MachineType','MachineTypeDesc'),
			editor:machineTypeBoxCombox
		},{
			title: '�¶�����',
			align:'center',
			field: 'TempType',
			width:100,
			formatter: CommonFormatter(TempTypeCombox, 'TempType', 'TempTypeDesc'),
			editor: TempTypeCombox
		},{
			title: '�����',
			align:'center',
			field: 'SterCar',
			width:150,
			formatter: CommonFormatter(AllSterCarBox, 'SterCar', 'SterCarName'),
			editor: AllSterCarBox
		},{
			title: 'װ������',
			field: 'LoadNum',
			align: 'right',
			width: 100,
			editor: {type: 'numberbox'}
		}, {
			title: '����',
			field: 'Manufacture',
			width:150,
			editor:{type:'validatebox',options:{}}
		}, {
			title: '����·��',
			field: 'DataPath',
			width:300,
			editor:{type:'validatebox',options:{}}
		}, {
			title: '��չ����',
			field: 'ExtType',
			width:150,
			editor:{type:'validatebox',options:{}}
		},{
			title:'�Ƿ�BD����',
			align:'center',
			field:'IsBd',
			width:100,
			formatter: CommonFormatter(IsBdCombox,'IsBd','IsBdDesc'),
			editor:IsBdCombox
		},{
			title: '�Ƿ�����',
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
				$UI.msg('success','�ο�ֵͬ���ɹ���');
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
//            text: '�ο�ֵ',
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