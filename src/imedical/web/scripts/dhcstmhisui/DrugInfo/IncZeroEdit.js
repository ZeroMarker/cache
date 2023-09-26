/**
 * �����־����
 */
 function HospZeroStkEdit() {
	var Inci=$('#Inci' ).val()
	if(isEmpty(Inci)){
		$UI.msg('alert','����ѡ��Ҫά���Ŀ����!')
		return;
	}
	var Clear=function(){
		$UI.clear(IncZeroEditGrid);
	}
	
	$HUI.dialog('#IncZeroEdit').open()
	function IncZeroEditSave(){
		var Detail=IncZeroEditGrid.getChangesData();
		if (Detail === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Detail)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCIncHosp',
			MethodName: 'Save',
			Inci: Inci,
			ListData: JSON.stringify(Detail)
		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				IncZeroEditGrid.commonReload();
				GetDetail(Inci);
			}else{
				$UI.msg('error',jsonData.msg);		
			}
		});
	}
	var IncZeroEditCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: 'Ժ��',
			field: 'HospDesc',
			width:150
		},{
			title: '�����־',
			field: 'Zero',
			width:100,
			editor:{type:'checkbox',options:{on:'Y',off:'N'}}
		}
	]];
	
	var IncZeroEditGrid = $UI.datagrid('#IncZeroEditGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCIncHosp',
			QueryName: 'Select',
			Inci:Inci
		},		
		lazy:false,
		toolbar:[{
		text: '����',
		iconCls: 'icon-save',
		handler: function () {
			IncZeroEditSave();
		}}],
		columns: IncZeroEditCm,
		onClickCell: function(index, filed ,value){	
			IncZeroEditGrid.commonClickCell(index,filed,value);
		}
	})
	Clear()
}