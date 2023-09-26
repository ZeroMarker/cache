var FtpParamObj = GetAppPropValue('CSSDFTPFILEM')
var tmpl = "<li class='imgbox'><img id=${RowId} data-original=http://"+FtpParamObj.FtpHttpSrc+"${PicSrc} src=http://"+FtpParamObj.FtpHttpSrc+"${PicSrc} alt=${ImgType}></li>" +
			"<div style='text-align:center'>${ImgType}</div>";
function showPics( data ) {
	$('#PicsList').empty();
	//$("#largeImg").empty();
	$('#showimg').empty();
	$.tmpl(tmpl, data ).appendTo( "#PicsList" );
	$("#PicsList").each(function(){
		var i=$(this);
		var p=i.find("li");
		var l=p.find("img");
		srci=l.attr("src");
		$("#showimg").attr("src",srci);
		p.click(function(){
			if(!!$(this).hasClass("selectedpic")){
				$(this).removeClass("selectedpic");
			}else{
				$(this).addClass("selectedpic").siblings("li").removeClass("selectedpic");
			}
		var imgsrc=GetSrcSelected();
		//$("#showimg").css("background-image","url("+imgsrc+")").css(" background-repeat","no-repeat").css('background-size','100% 100%');
		$("#showimg").attr("src",imgsrc);
	})
	})
}
$("#showimg").click(function(){
	$('#showimg').viewer({zIndex:9999999999999});
})
function GetPackagePic(PackageRowId){
	$.cm({
		ClassName: 'web.CSSDHUI.PackageInfo.Package',
		MethodName: 'GetPackageImageInfo',
		PackageRowId: PackageRowId
	},function(jsonData){
		showPics(jsonData);
	});	
}
function ViewPic(PackageRowId,PackageName){
	$("#pkgRowid").val(PackageRowId);
	$("#pkgName").val(PackageName);
	$("#showimg").attr("src","");
	if(isEmpty(PackageRowId)){
		$UI.msg('alert','请选择要浏览的图片的消毒包!');
		return;
	}
	
	function ViewPicUpLoader(){
		var PackageRowId = $("#pkgRowid").val();
		var PackageName = $("#pkgName").val();
		uploader.clear();
		uploader.reset();
		if(isEmpty(PackageRowId)){
			$UI.msg('alert','请选择要上传图片的消毒包!');
			return;
		}
		var Params={PackageRowId:PackageRowId,PackageName:PackageName,Type:'Package'};
		Params=JSON.stringify(addSessionParams(Params));
		uploader.setParams(Params);
		uploader.refresh();
		uploader.upload();
		setTimeout(GetPackagePic(PackageRowId),3000);
		
	}
	///图片浏览上传功能点击实现
	///$('#UpLoadViewPicBT').on('click', ViewPicUpLoader);
	///wfg
	///图片浏览上传功能，点击添加图片按钮弹出框效果
	
	
	$('#DeletePicBT').on('click', DeletePic);
	function DeletePic(){    //删除图片
		var PkgRowId = $("#pkgRowid").val();
		var RowId=GetIdSelected();
		if(isEmpty(RowId)){
			$UI.msg('alert','请选择要删除的图片!');
			return;
		}
		$.cm({
			ClassName: 'web.CSSDHUI.PackageInfo.Package',
			MethodName: 'DelPackageImageInfo',
			docRowId: RowId
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success','删除成功!');
				$('#PicsList').empty();
				$("#showimg").attr("src","");
				GetPackagePic(PkgRowId);	
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});			
		
	}
	
	function GetIdSelected(){
		var id="";
		$("#PicsList .selectedpic").each(function(){
			var i=$(this);
			var p=i.find("img");
			id=p.attr("id");
		})
		return id;
	}
	//获取选择缩略图的图片地址
	function GetSrcSelected(){
		var src=""
		$("#PicsList .selectedpic").each(function(){
			var i=$(this);
			var p=i.find("img");
			src=p.attr("src");
		})
		return src;
	}
	
	
	GetPackagePic(PackageRowId);
	$HUI.dialog('#ViewPic',{
		onBeforeClose:function(){
			$('#PicsList').empty();
			//$("#largeImg").empty();
			$('#showimg').empty();
			$('#PicsList').viewer('destroy');
		}
	})
	$HUI.dialog('#ViewPic').open();
	$('#showimg').empty();
}