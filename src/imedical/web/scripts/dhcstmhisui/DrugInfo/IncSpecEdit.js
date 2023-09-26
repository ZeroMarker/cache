function IncSpecEdit() {
	var Inci=$('#Inci' ).val()
	if(isEmpty(Inci)){
		$UI.msg('alert','请先选择要维护的库存项!')
		return;
	}
	var Clear=function(){
		$UI.clear(IncSpecEditGrid);
	}
	
	$HUI.dialog('#IncSpecEdit').open()
	function IncSpecEditSave(){
		var Detail=IncSpecEditGrid.getChangesData();
		if (Detail === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(Detail)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INCALIAS',
			MethodName: 'SaveSpec',
			Inci: Inci,
			ListData: JSON.stringify(Detail)
		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				IncSpecEditGrid.commonReload();
			}else{
				$UI.msg('error',jsonData.msg);		
			}
		});
	}
	var IncSpecEditCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '具体规格',
			field: 'Spec',
			width:250,
			editor:{type:'validatebox',options:{required:true}}
		}
	]];
	
	var IncSpecEditGrid = $UI.datagrid('#IncSpecEditGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INCALIAS',
			QueryName: 'SelectSpec',
			Inci:Inci
		},
		deleteRowParams:{
			ClassName:'web.DHCSTMHUI.INCALIAS',
			MethodName:'DeleteSpec'
		},		
		lazy:false,
		toolbar:[{
		text: '保存',
		iconCls: 'icon-save',
		handler: function () {
			IncSpecEditSave();
		}}],
		showAddDelItems:true,
		columns: IncSpecEditCm,
		onClickCell: function(index, filed ,value){	
			IncSpecEditGrid.commonClickCell(index,filed,value);
		}
	})
	Clear()
}