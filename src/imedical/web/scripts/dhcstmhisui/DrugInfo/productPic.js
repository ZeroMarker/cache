
function UpLoader(){
	uploader.clear();
	uploader.reset();
	var Inci=$('#Inci').val();
	if(isEmpty(Inci)){
		$UI.msg('alert','请选择要上传图片的库存项!')
		return
	}
	var Params={Inci:Inci,Type:'Inci'};
	Params=JSON.stringify(addSessionParams(Params));
	uploader.setParams(Params)
	$HUI.dialog('#UpLoader').open()
	uploader.refresh();
	$UI.linkbutton('#UpLoadPicBT',{
		onClick:function(){
			var count=0;
			$("#PicList").each(function(){
				var i=$(this);
				var p=i.find("img");
				count=p.length;
			})
			if (count<=0){
				$UI.msg('alert','没有需要上传的图片！')
 				return false;
			}
			uploader.upload();
		}	
	});	
}