/**
 * ������Ŀ������Ȩ
 */
function setLocClaGrp(LocInfoGrid,Hospid){
	var select=LocInfoGrid.getSelected()
	if(isEmpty(select)){
		$UI.msg('alert','��ѡ�����!')
		return;
	}
	var Loc=select.LocId;
	$UI.linkbutton('#InciGridSearchBT', {
		onClick: function () {
			var SessionParmas=addSessionParams({Hospital:Hospid});
			var Paramsobj=$UI.loopBlock('InciGridTB');
			var Params=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
			InciGrid.load({
				ClassName: 'web.DHCSTMHUI.LocClaGrp',
				QueryName: 'QueryNotChoose',
				Params: Params,
				Loc: Loc
			});
		}
	});
	$HUI.dialog('#LocClaGrp').open()
	
	var LocClaGrpSave={
			text: '����',
			iconCls: 'icon-save',
			handler: function () {
				var Rows=LocClaGrpGrid.getChangesData();
				if (Rows === false){	//δ��ɱ༭����ϸΪ��
					return;
				}
				if (isEmpty(Rows)){	//��ϸ����
					$UI.msg("alert", "û����Ҫ�������ϸ!");
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.LocClaGrp',
					MethodName: 'Save',
					Loc:Loc,
					Params: JSON.stringify(Rows)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success',jsonData.msg);
						LocClaGrpGrid.reload();
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}
	};	
	var LocClaGrpGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '����',
			field: 'GrpCode',
			editor:{type:'validatebox',options:{required:true}},
			width:200
		}, {
			title: '����',
			field: 'GrpDesc',
			editor:{type:'validatebox',options:{required:true}},
			width:200
		}
	]];
	
	var LocClaGrpGrid = $UI.datagrid('#LocClaGrpGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocClaGrp',
			QueryName: 'Query',
			Loc:select.LocId
		},
		deleteRowParams:{
			ClassName:'web.DHCSTMHUI.LocClaGrp',
			MethodName:'Delete'
		},		
		lazy:false,
		toolbar:[LocClaGrpSave],
		showAddDelItems:true,
		columns: LocClaGrpGridCm,	
		onClickCell: function(index, filed ,value){
			LocClaGrpGrid.commonClickCell(index,filed);
			var Row=LocClaGrpGrid.getRows()[index]
			SelectInciGrid.load({
				ClassName: 'web.DHCSTMHUI.LocClaGrp',
				QueryName: 'QueryChoose',
				Parref:Row.RowId
			});	
		}
	})
	var SelectInciGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width:120
		}, {
			title: '��������',
			field: 'InciDesc',
			width:120
		}, {
			title: '���',
			field: 'Spec',
			width:120
		}
	]];
	
	var SelectInciGrid = $UI.datagrid('#SelectedInciGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocClaGrp',
			QueryName: 'QueryChoose'
		},
		toolbar:'#SelectInciGridTB',
		columns: SelectInciGridCm,
		onDblClickRow: function(index,row){
			$.cm({
				ClassName: 'web.DHCSTMHUI.LocClaGrp',
				MethodName: 'DeleteGrpInci',
				rowid:row.RowId
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					SelectInciGrid.reload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	})
	var InciGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InCode',
			width:80
		}, {
			title: '��������',
			field: 'InDesc',
			width:150
		}, {
			title: '���',
			field: 'InSpec',
			width:80
		}
	]];
	var SessionParmas=addSessionParams({Hospital:Hospid});
	var Paramsobj=$UI.loopBlock('InciGridTB');
	var Params1=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
	var InciGrid = $UI.datagrid('#InciGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocClaGrp',
			QueryName: 'QueryNotChoose',
			Loc:select.LocId,
			Params:Params1
		},		
		lazy:false,
		toolbar:'#InciGridTB',
		columns: InciGridCm,
		onDblClickRow: function(index,row){
			var Row = LocClaGrpGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert','��ѡ�������Ŀ��!')
				return
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.LocClaGrp',
				MethodName: 'AddGrpInci',
				grpid:Row.RowId,
				inci:row.RowId
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					InciGrid.reload();
					SelectInciGrid.reload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
				
		}
	})
}