/**
 * 零库存标志界面
 */
 function HospZeroStkEdit() {
	var Inci=$('#Inci' ).val()
	if(isEmpty(Inci)){
		$UI.msg('alert','请先选择要维护的库存项!')
		return;
	}
	var Clear=function(){
		$UI.clear(IncZeroEditGrid);
	}
	
	$HUI.dialog('#IncZeroEdit').open()
	function IncZeroEditSave(){
		var Detail=IncZeroEditGrid.getChangesData();
		if (Detail === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(Detail)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
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
			title: '院区',
			field: 'HospDesc',
			width:150
		},{
			title: '零库存标志',
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
		text: '保存',
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