///wfg
///图片上传功能
function UpLoader(PackageRowId,PackageName){
	uploader.clear();
	uploader.reset();
	if(isEmpty(PackageRowId)){
		$UI.msg('alert','请选择要上传图片的消毒包!')
		return
	}
	var Params={PackageRowId:PackageRowId,PackageName:PackageName,Type:'Package'};
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
///wfg
///图片浏览上传功能，点击添加图片按钮弹出框效果
function ViewPicUpLoader(PackageRowId,PackageName){
	uploader.clear();
	uploader.reset();
	if(isEmpty(PackageRowId)){
		$UI.msg('alert','请选择要上传图片的消毒包!')
		return
	}
	
	$HUI.dialog('#ViewPic').open()
	uploader.refresh();
	$UI.linkbutton('#UpLoadViewPicBT',{
		onClick:function(){
			var PackageRowId = $("#pkgRowid").val();
			var PackageName = $("#pkgName").val();
			var Param={PackageRowId:PackageRowId,PackageName:PackageName,Type:'Package'};
			Params=JSON.stringify(addSessionParams(Param));
			alert(Params);
			uploader.setParams(Params)
			uploader.upload();
			uploader.callback(Param);
			//setTimeout(ViewPic(PackageRowId),5000);
		}	
	});
	
	//setTimeout(GetPackagePic(PackageRowId),3000);
	
}