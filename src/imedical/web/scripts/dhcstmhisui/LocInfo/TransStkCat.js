/**
 * ���� ����+������ �������ʵĹ�Ӧ�ֿ�
 * @param {} loc
 * @param {} locDesc
 */
function setTransStkCat(LocInfoGrid,Hospid){
	var select=LocInfoGrid.getSelected();
	if(isEmpty(select)){
		$UI.msg('alert','��ѡ�����!')
		return;
	}
	var Loc=select.LocId;
	var Clear=function(){
		$UI.clear(LocCatGrid);
		$UI.clear(LocGrid2);
		$UI.clear(CatGrid);
	}

	var LocCatGridAddBT = {
		iconCls: 'icon-save',
		text: '����',
		handler: function(){
			LocCatGridAdd();
		}
	};
	var LocCatGridDelBT = {
		iconCls: 'icon-cancel',
		text: 'ɾ��',
		handler: function(){
			LocCatGridDel();
		}
	};
	$UI.linkbutton('#LocGridSearchBT', {
		onClick: function () {
			var SessionParmas=addSessionParams({Hospital:Hospid});
			var Paramsobj=$UI.loopBlock('LocGridTB');
			var Params=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
			LocGrid2.load({
				ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
				QueryName: 'NotTransferFrLoc',
				Params: Params,
				Loc: Loc
			});
		}
	});
	$HUI.dialog('#LocCat').open()

	function LocCatGridAdd(){
		var select=LocGrid2.getSelected();
		if(isEmpty(select)){
			$UI.msg('alert','��ѡ�����!')
			return;
		}
		var ProLoc=select.RowId;
		var select=CatGrid.getSelected();
		if(isEmpty(select)){
			$UI.msg('alert','��ѡ�������!')
			return;
		}
		var Cat=select.RowId;
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
			MethodName: 'InsertStkCat',
			LocId:Loc,
			ProvLoc:ProLoc,
			IncscStr:Cat

		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				LocCatGrid.commonReload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	function LocCatGridDel(){
		var select=LocCatGrid.getSelectedData();
		if(isEmpty(select)){
			$UI.msg('alert','��ѡ�����!')
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
			MethodName: 'DeleteStkCat',
			Params:JSON.stringify(select)

		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				LocCatGrid.commonReload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	var LocCatGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '��������',
			field: 'Description',
			width:200
		}, {
			title: '����������',
			field: 'StkDescription',
			width:200
		}
	]];

	var LocCatGrid = $UI.datagrid('#LocCatGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
			QueryName: 'TransStkCat',
			Loc:select.LocId
		},
		lazy:false,
		toolbar:[LocCatGridAddBT,LocCatGridDelBT],
		columns: LocCatGridCm,
		onDblClickRow: function(index,row){
			var Rows = LocCatGrid.getSelectedData();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
				MethodName: 'Delete',
				Params: JSON.stringify(Rows)
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					LocCatGrid.reload();
					LocGrid2.reload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	})
	var LocGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '��������',
			field: 'Description',
			width:200
		}
	]];
	var SessionParmas=addSessionParams({Hospital:Hospid});
	var Paramsobj=$UI.loopBlock('LocGridTB');
	var Params1=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
	var LocGrid2 = $UI.datagrid('#LocGrid2', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
			QueryName: 'NotTransferFrLoc',
			Loc:Loc,
			Params:Params1
		},
		lazy:false,
		toolbar:'#LocGridTB',
		columns: LocGridCm,
		onDblClickRow: function(index,row){}
	})
	var CatGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '����������',
			field: 'Description',
			width:200
		}
	]];

	var CatGrid = $UI.datagrid('#CatGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
			QueryName: 'TransferStkLoc',
			Loc:Loc
		},
		lazy:false,
		columns: CatGridCm,
		onDblClickRow: function(index,row){}
	})
}
