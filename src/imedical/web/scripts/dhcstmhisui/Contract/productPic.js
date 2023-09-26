
function UpLoader(){
	uploader.clear();
	uploader.reset();
	var select=ContractGrid.getSelected();
	if(isEmpty(select)){
		$UI.msg('alert','请选择要上传图片的合同!')
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