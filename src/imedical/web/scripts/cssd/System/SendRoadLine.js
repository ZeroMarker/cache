///下收下送线路维护
///wxj 2019-04-09
var init = function (){
	var SystemBox = $HUI.combobox('#System', {
		data:[{'RowId':'','Description':'全部'},{'RowId':'1','Description':'消毒供应管理系统'},{'RowId':'2','Description':'卫生材料管理系统'},{'RowId':'3','Description':'敷料管理系统'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var StoreLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var StoreLocCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+StoreLocParams,
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			onSelect:function(record){
				var rows =SendLineGrid.getRows();
				var row = rows[SendLineGrid.editIndex];
				row.StoreLocDesc=record.Description;
			},
			onShowPanel:function(){
				$(this).combobox('reload')
			}
		}
	};
	var UserCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetUser&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect:function(record){
				var rows =SendLineGrid.getRows();
				var row = rows[SendLineGrid.editIndex];
				row.SendUserName=record.Description;
			},
			onShowPanel:function(){
				$(this).combobox('reload');
			}
		}
	};
	var LocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var LocCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+LocParams,
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			onSelect:function(record){
				var rows = LocGrid.getRows();
				var row = rows[LocGrid.editIndex];
				row.LocDesc=record.Description;
			},
			onShowPanel:function(){
				$(this).combobox('reload');
			}
		}
	}
	var systemData =[{'RowId':'1','Description':'消毒供应管理系统'},{'RowId':'2','Description':'卫生材料管理系统'},{'RowId':'3','Description':'敷料管理系统'}]
	var systemCombox = {
		type: 'combobox',
		options: {
			data: systemData,
			valueField: 'RowId',
			textField: 'Description'
		}
	} 
	$UI.linkbutton('#SearchBT',{ 
		onClick:function(){
			var Params = JSON.stringify($UI.loopBlock('LineTB'));
			SendLineGrid.load({
				ClassName: 'web.CSSDHUI.System.SendRoadLine',
				QueryName: 'SelectSendLine',
				Params: Params,
				rows:999
			});
			$UI.clear(LocGrid);
		}
	});
	$UI.linkbutton('#ClearBT',{ 
		onClick:function(){
			$UI.clearBlock('BorderLine');
			$UI.clear(SendLineGrid);
			$UI.clear(LocGrid);
			$('#System').combobox("setValue","");
		}
	});
	$UI.linkbutton('#AddBT',{ 
		onClick:function(){
			SendLineGrid.commonAddRow();
			DeflocGrp("");
		}
	});
	$UI.linkbutton('#SaveBT',{ 
		onClick:function(){
			var Rows=SendLineGrid.getChangesData();
			if(isEmpty(Rows)){
				//$UI.msg('alert','没有需要保存的信息!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.SendRoadLine',
				MethodName: 'Save',
				Params: JSON.stringify(Rows)
			},function(jsonData){
				$UI.msg('success',jsonData.msg);
				if(jsonData.success==0){
					SendLineGrid.reload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	
	$UI.linkbutton('#DeleteBT',{ 
		onClick:function (){
			SendLineGrid.commonDeleteRow();
			Delete();
		}
	});
	function Delete(){
		var Rows=SendLineGrid.getSelectedData()
		if(isEmpty(Rows)){
			//$UI.msg('alert','没有选中的信息!')
			return;
		}
		$.messager.confirm("操作提示","您确定要执行删除操作吗？",function(data){
			if(data){
				$.cm({
					ClassName: 'web.CSSDHUI.System.SendRoadLine',
					MethodName: 'Delete',
					Params: JSON.stringify(Rows)
					},function(jsonData){
						if(jsonData.success==0){
							$UI.msg('success',jsonData.msg);
							SendLineGrid.reload()
						}else{
						 	$UI.msg('error',jsonData.msg);
						}
					});
			}
		});
	}
	
	
	var SendLineGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			width:10,
			hidden: true
		}, {
			title: '系统',
			field: 'System',
			width:150,
			formatter: CommonFormatter(systemCombox,'System','SystemDesc'),
			editor:systemCombox
		}, {
			title: '仓库',
			field: 'StockLocId',
			formatter: CommonFormatter(StoreLocCombox,'StoreLocId','StoreLocDesc'),
			editor:StoreLocCombox,
			width:200
		}, {
			title: '楼号',
			align:'right',
			field: 'FloorCode',
			width:100,
			editor:{type:'numberbox',options:{required:true}}
		}, {
			title: '线路编号',
			align:'right',
			field: 'LineCode',
			width:100,
			editor:{type:'numberbox',options:{required:true}}
		}, {
			title: '线路描述',
			field: 'LineDesc',
			width:150,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '负责人',
			field: 'SendUserId',
			width:200,
			formatter: CommonFormatter(UserCombox, 'SendUserId', 'SendUserName'),
			editor: UserCombox
		}
	]];
	var SendLineGrid = $UI.datagrid('#SendLineGrid', {
		lazy:false,
		queryParams: {
			ClassName: 'web.CSSDHUI.System.SendRoadLine',
			QueryName: 'SelectSendLine'
		},
		columns: SendLineGridCm,
		pagination: false,
		remoteSort: false,
		onLoadSuccess:function(data){
			if(data.rows.length>0){
				$('#SendLineGrid').datagrid("selectRow", 0)
				var Row=SendLineGrid.getRows()[0]
				var Id = Row.RowId;
				DeflocGrp(Id);
		 	}
		},
		//sortName: 'RowId',
		//sortOrder: 'Desc',
		onClickCell: function(index, filed ,value){
			var Row=SendLineGrid.getRows()[index]
			var Id = Row.RowId;
			if(!isEmpty(Id)){
				DeflocGrp(Id);
			}
			SendLineGrid.commonClickCell(index,filed);
		}
	})
	
	var LocGridCm = [[{
			title: 'Rowid',
			field: 'Rowid',
			width:10,
			hidden: true
		},{
			title: '代码',
			field: 'LocCode', 
			width:200
		},{
			title: '描述',
			field: 'LocId',
			width:200,
			formatter: CommonFormatter(LocCombox,'LocId','LocDesc'),
			editor:LocCombox
		}
	]];
	var LocGrid = $UI.datagrid('#LocGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.SendRoadLine',
			QueryName: 'SelectLineDetail'
		},
		showAddSaveDelItems:true,
		columns: LocGridCm,
		fitColumns: true,
		pagination: false,
		remoteSort: false,
		saveDataFn:function(){//保存明细
			var Rows = LocGrid.getChangesData();
			if(isEmpty(Rows)){
				//$UI.msg('alert','没有需要保存的信息!');
				return;
			}
			var Selected = SendLineGrid.getSelected();
			var PRowId = Selected.RowId;
			$.cm({
				ClassName: 'web.CSSDHUI.System.SendRoadLine',
				MethodName: 'SaveDetail',
				Parref: PRowId,
				Params: JSON.stringify(Rows)
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success', jsonData.msg);
					LocGrid.reload();
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		beforeAddFn:function(){
			var rowMain = $('#SendLineGrid').datagrid('getSelected');
			if(isEmpty(rowMain)){
				$UI.msg('alert','请选择线路维护!');
				return false;
			}
		},
		beforeDelFn:function(){
			var rowLoc = $('#LocGrid').datagrid('getSelected');
			if(!isEmpty(rowLoc)){
				if (!isEmpty(rowLoc.Rowid)) {
					var Rows=LocGrid.getSelectedData();
					$.cm({
						ClassName:'web.CSSDHUI.System.SendRoadLine',
						MethodName:'DeleteDetail',
						Params:JSON.stringify(Rows)
					},function(jsonData){
						if(jsonData.success==0){
							//$UI.msg('success', jsonData.msg);
							$('#LocGrid').datagrid('reload');
						}else{
							$UI.msg('error', jsonData.msg);
						}
					});	
				}
			}else{
				$UI.msg('alert','请选择要删除的单据!');
				return false;
			}
		},
		onClickCell: function(index, field ,value){
			LocGrid.commonClickCell(index,field);
		}
	});
	
	function DeflocGrp(Id) {
		LocGrid.load({
			ClassName: 'web.CSSDHUI.System.SendRoadLine',
			QueryName: 'SelectLineDetail',
			Parref:Id,
			rows:999
		});
	}
}
$(init);