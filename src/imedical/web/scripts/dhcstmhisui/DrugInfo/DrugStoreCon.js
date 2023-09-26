
function GetStoreCon(){
	var Inci=$('#Inci' ).val()
	if(isEmpty(Inci)){
		$UI.msg('alert','请先选择要维护的库存项!')
		return;
	}	
	var Clear=function(){
		$UI.clearBlock('#StoreConEdit');
	}
	$HUI.dialog('#StoreConEdit').open()
	function FillStoreCon(){
		$.cm({
		ClassName: 'web.DHCSTMHUI.ITMSTORECON',
		MethodName: 'Select',
		Inci:Inci
		},function(jsonData){
			$UI.fillBlock('#StoreConEdit',jsonData);
		});	
	}
	
	$UI.linkbutton('#StoreConSaveBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#StoreConEdit')
			var Params=JSON.stringify(ParamsObj);
			$.cm({
			ClassName: 'web.DHCSTMHUI.ITMSTORECON',
			MethodName: 'Save',
			ListData: Params,
			Inci:Inci
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					GetDetail(Inci);
				}else{
					$UI.msg('error',jsonData.msg);		
				}
			});	
		}	
	});	
	Clear();
	FillStoreCon();
}