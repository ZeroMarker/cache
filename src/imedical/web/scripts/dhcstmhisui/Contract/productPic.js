
function UpLoader(){
	uploader.clear();
	uploader.reset();
	var select=ContractGrid.getSelected();
	if(isEmpty(select)){
		$UI.msg('alert','��ѡ��Ҫ�ϴ�ͼƬ�ĺ�ͬ!')
		return
	}
	var Params={ConRowId:select.RowId,Type:'Contrack'};
	Params=JSON.stringify(addSessionParams(Params));
	uploader.setParams(Params)
	$HUI.dialog('#UpLoader').open()
	uploader.refresh();
	$UI.linkbutton('#UpLoadPicBT',{
		onClick:function(){
			uploader.upload();
		}	
	});	
}