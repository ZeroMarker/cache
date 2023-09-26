var init = function() {
	var SCGData = [{ "RowId":"MM", "Description":"ҽ�ò���"},{ "RowId":"MO", "Description":"���ڲ���"},{ "RowId":"MR", "Description":"�Լ�"},{ "RowId":"MF", "Description":"�̶��ʲ�"}]
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
			text: '��ѯ',
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
			text: '����',
			iconCls: 'icon-add',
			handler: function(){
				StkCatGroupGrid.commonAddRow();
			}
		}, {
			text: '����',
			iconCls: 'icon-save',
			handler: function () {
				var Rows=StkCatGroupGrid.getChangesData();
				if (Rows === false){	//δ��ɱ༭����ϸΪ��
					return;
				}
				if (isEmpty(Rows)){	//��ϸ����
					$UI.msg("alert", "û����Ҫ�������ϸ!");
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
			title: '����',
			field: 'Code',
			width:100,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '����',
			field: 'Description',
			width:150,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '�ۼ۱���',
			field: 'SpReq',
			width:130,
			align:'center',
			formatter:BoolFormatter,
			editor:{type:'checkbox',options:{on:'Y',off:'N'}}
		}, {
			title: '����',
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
			text: '����',
			iconCls: 'icon-add',
			handler: function(){
				var Selected = StkCatGroupGrid.getSelected();
				if(isEmpty(Selected)){
					$UI.msg('alert','��ѡ��Ҫ����������!');
					return;
				}
				var PRowId = Selected.RowId;
				if(isEmpty(PRowId)){
					$UI.msg('alert','���ȱ���Ҫά���ĵ�λ!');
					return;
				}
				StkCatGrid.commonAddRow();
			}
		}, {
			text: '����',
			iconCls: 'icon-save',
			handler: function () {
				var Rows = StkCatGrid.getChangesData();
				var Selected = StkCatGroupGrid.getSelected();
				var PRowId = Selected.RowId;
				if (Rows === false){	//δ��ɱ༭����ϸΪ��
					return;
				}
				if (isEmpty(Rows)){	//��ϸ����
					$UI.msg("alert", "û����Ҫ�������ϸ!");
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
			text: 'ɾ��',
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
			title: '����',
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