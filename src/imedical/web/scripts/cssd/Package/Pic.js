///wfg
///ͼƬ�ϴ�����
function UpLoader(PackageRowId,PackageName){
	uploader.clear();
	uploader.reset();
	if(isEmpty(PackageRowId)){
		$UI.msg('alert','��ѡ��Ҫ�ϴ�ͼƬ��������!')
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
///ͼƬ����ϴ����ܣ�������ͼƬ��ť������Ч��
function ViewPicUpLoader(PackageRowId,PackageName){
	uploader.clear();
	uploader.reset();
	if(isEmpty(PackageRowId)){
		$UI.msg('alert','��ѡ��Ҫ�ϴ�ͼƬ��������!')
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