var init = function() {
	var SCGData = [{ "RowId":"MM", "Description":"医用材料"},{ "RowId":"MO", "Description":"后勤材料"},{ "RowId":"MR", "Description":"试剂"},{ "RowId":"MF", "Description":"固定资产"}]
	var SCGCombox = {
		type: 'combobox',
		options: {
			data: SCGData,
			valueField: 'RowId',
			textField: 'Description'
		}
	}
	var CatComboxParams=JSON.stringify(addSessionParams({}));
	var CatCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.INCSTKCAT&QueryName=GetStkCat&ResultSetType=array&Params='+CatComboxParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote'
		}
	}
	/*$('#SearchBT').on('click',function(){
		StkCatGroupGrid.load({
			ClassName : 'web.DHCSTMHUI.INCSTKCAT',
			QueryName : 'SelectAll'
		})
	})
	$('#AddBT').on('click',function(){
		StkCatGroupGrid.commonAddRow();
	})
	$('#SaveBT').on('click',function(){
		var Rows = StkCatGroupGrid.getChangesData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INCSTKCAT',
			MethodName: 'Save',
			Params: JSON.stringify(Rows)
		},function(jsonData){
				if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				StkCatGroupGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		})
	})
	$('#DeleteBT').on('click',function(){
		var Rows = StkCatGroupGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INCSTKCAT',
			MethodName: 'Delete',
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				StkCatGroupGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
		
	})*/
var StkCatGroupTB = [{
			text: '查询',
			iconCls: 'icon-search',
			handler: function(){
				$UI.clear(StkCatGrid);
				StkCatGroupGrid.load({
					ClassName: 'web.DHCSTMHUI.INCSTKCAT',
					QueryName: 'SelectAll',
					Params: JSON.stringify(addSessionParams({}))
				});
			}
		},{
			text: '新增',
			iconCls: 'icon-add',
			handler: function(){
				StkCatGroupGrid.commonAddRow();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function () {
				var Rows=StkCatGroupGrid.getChangesData();
				if (Rows === false){	//未完成编辑或明细为空
					return;
				}
				if (isEmpty(Rows)){	//明细不变
					$UI.msg("alert", "没有需要保存的明细!");
					return;
				}
				var MainObj=JSON.stringify(addSessionParams({}))
				$.cm({
					ClassName: 'web.DHCSTMHUI.INCSTKCAT',
					MethodName: 'Save',
					Main: MainObj,
					Params: JSON.stringify(Rows),
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						StkCatGroupGrid.reload();
					}else{
						$UI.msg('error',jsonData.msg);
					 }
				});
			}
		}
	];

	var StkCatGroupCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '代码',
			field: 'Code',
			width:100,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '描述',
			field: 'Description',
			width:150,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '售价必填',
			field: 'SpReq',
			width:130,
			align:'center',
			formatter:BoolFormatter,
			editor:{type:'checkbox',options:{on:'Y',off:'N'}}
		}, {
			title: '归类',
			field: 'ScgSet',
			width:160,
			formatter: CommonFormatter(SCGCombox,'ScgSet','ScgSetDesc'),
			editor:SCGCombox
		}
	]];

	var StkCatGroupGrid = $UI.datagrid('#StkCatGroupGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INCSTKCAT',
			QueryName: 'SelectAll',
			Params: JSON.stringify(addSessionParams({}))
		},
		columns: StkCatGroupCm,
		fitColumns: true,
		toolbar: StkCatGroupTB,
		sortName: 'RowId',  
		sortOrder: 'Desc',   
		onClickCell: function(index, filed ,value){
			var Row=StkCatGroupGrid.getRows()[index]
			var Id = Row.RowId;
			if(!isEmpty(Id)){
				StkCat(Id);
			}	
			StkCatGroupGrid.commonClickCell(index,filed)
		}
	})	

	var StkCatBar = [{
			text: '新增',
			iconCls: 'icon-add',
			handler: function(){
				var Selected = StkCatGroupGrid.getSelected();
				if(isEmpty(Selected)){
					$UI.msg('alert','请选中要关联的类组!');
					return;
				}
				var PRowId = Selected.RowId;
				if(isEmpty(PRowId)){
					$UI.msg('alert','请先保存要维护的单位!');
					return;
				}
				StkCatGrid.commonAddRow();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function () {
				var Rows = StkCatGrid.getChangesData();
				var Selected = StkCatGroupGrid.getSelected();
				var PRowId = Selected.RowId;
				if (Rows === false){	//未完成编辑或明细为空
					return;
				}
				if (isEmpty(Rows)){	//明细不变
					$UI.msg("alert", "没有需要保存的明细!");
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.INCSTKCAT',
					MethodName: 'SaveRelation',
					StkGrpId: PRowId,
					Params: JSON.stringify(Rows)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						StkCatGrid.reload()
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}
		}, {
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function () {
				var Rows=StkCatGrid.getSelections()
				$.cm({
					ClassName:'web.DHCSTMHUI.INCSTKCAT',
					MethodName:'DeleteRelation',
					Params:JSON.stringify(Rows)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						StkCatGrid.reload()
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}
		}
	];
	var StkCatCm = [[{
			title: 'RelationId',
			field: 'RelationId',
			hidden: true
		},{
			title: '描述',
			field: 'StkCatId', 
			formatter: CommonFormatter(CatCombox,'StkCatId','StkCatDesc'),
			width:100,
			editor:CatCombox
		}
	]]; 

	var StkCatGrid = $UI.datagrid('#StkCatGrid', {
			url:'',
			queryParams: {
				ClassName: 'web.DHCSTMHUI.INCSTKCAT',
				MethodName: 'SelectRelationCat'
			},
			columns: StkCatCm,
			pagination:false,
			toolbar: StkCatBar,
			singleSelect:false,
			onClickCell: function(index, field ,value){
				var Row=StkCatGrid.getRows()[index]
				//alert("2="+Row.RelationId)
				if((field=='StkCatId')&&(!isEmpty(Row.RelationId))){
					return false;
				}
				StkCatGrid.commonClickCell(index,field)
			}
	});
	
	function StkCat(Id) {
		$UI.setUrl(StkCatGrid)
		StkCatGrid.load({
			ClassName: 'web.DHCSTMHUI.INCSTKCAT',
			MethodName: 'SelectRelationCat',
			StkGrpId:Id
		});
	}
	
}
$(init);