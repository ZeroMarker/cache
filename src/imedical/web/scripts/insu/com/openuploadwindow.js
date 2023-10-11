/*
*
*文件名称：insu/com/openuploadwindow.js
*功能说明：通用上传测试
*修改履历：巩鑫  2023-01-03
*/




/// 功能说明：上传文件窗口打开，或者查询已上传的文件 
/// 入参说明： ProofType 上传文件类型（在字典中进行定义）
///            TargetRecDr     所属数据Dr
///            OpenMode  打开模式 0-->上传模式 1-->仅仅查看已经上传文件模式
///  		   fileMaxSize  单个文件大小          单位M (默认为2)
///  		   FileExtStrs  可上传文件类型  "txt,png,jpg,..."(默认为图片格式)
///  		   ProoFileMaxNum 最多上传文件数量    (默认为5)
/// 修改履历： 巩鑫 2023-01-04 新做成
function OpenUploadFileWindow(ProofType, TargetRecDr, OpenMode,fileMaxSize,FileExtStrs,ProoFileMaxNum, ExtStr){
	
	if($('#UploadFileWindow').length==0){
		$('#UploadFileWindow').empty();
		
		var UploadFileWindowHtml="<div  id='UploadFileWindow' style='padding:10px;overflow:hidden;'>";
		UploadFileWindowHtml=UploadFileWindowHtml+"<iframe style='width:100%;height:100%;border:0;overflow:hidden;' src=''></iframe>";
		UploadFileWindowHtml=UploadFileWindowHtml+"</div>";
		
		$UploadFileWindow=$(UploadFileWindowHtml);
		$("body").append($UploadFileWindow);     //增加到页面
	}
	
	var titleInfo="上传文件";
	if(OpenMode=="1"){
		titleInfo="附件预览"; 
	}
	
	var RootPath="/imedical/web/";   
	 
	var url=RootPath+"csp/insu/com/uploadfile.csp";
	var InputParam="?ProofType="+ProofType+"&TargetRecDr="+TargetRecDr+"&OpenMode="+OpenMode;
	InputParam=InputParam+"&fileMaxSize="+fileMaxSize+"&FileExtStrs="+FileExtStrs+"&ProoFileMaxNum="+ProoFileMaxNum;
	var encodesrc=url+InputParam;
	//alert("encodesrc="+encodesrc);
	
	$('#UploadFileWindow iframe').attr("src",encodesrc);
	$('#UploadFileWindow').window({ 
		iconCls: "icon-w-img",
		modal:true,
		title:titleInfo, 
		width: 900,
        height: 520,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		onClose:function(){
			
		}
	});
	$('#UploadFileWindow').window('open');

}



/// 功能说明：上传文件窗口打开，或者查询已上传的文件
/// 入参说明： ProofType 上传文件类型（在字典中进行定义） 
///            TargetRecDr     所属数据Dr
///            OpenMode  打开模式 0-->上传模式 1-->仅仅查看已经上传文件模式
///  		   fileMaxSize  单个文件大小          单位M (默认为2)
///  		   FileExtStrs  可上传文件类型  "txt,png,jpg,..."(默认为图片格式)
///  		   ProoFileMaxNum 最多上传文件数量    (默认为5)
///			   CallBackFun   原页面回调方法 
/// 修改履历： 巩鑫 2023-01-04 新做成
function OpenUploadFileWindowNew(ProofType, TargetRecDr, OpenMode,fileMaxSize,FileExtStrs,ProoFileMaxNum, CallBackFun, ExtStr){

	var ObjResultObj=[];	
	new Promise(function(resolve, reject) {
		
		if($('#UploadFileWindow').length==0){
			$('#UploadFileWindow').empty();
		
			var UploadFileWindowHtml="<div id='UploadFileWindow' style='padding:10px;overflow:hidden;'>";
			UploadFileWindowHtml=UploadFileWindowHtml+"<iframe style='width:100%;height:100%;border:0;overflow:hidden;' src=''></iframe>";
			UploadFileWindowHtml=UploadFileWindowHtml+"</div>";
		
			$UploadFileWindow=$(UploadFileWindowHtml);
			$("body").append($UploadFileWindow);     //增加到页面
			$("body").append("<div id='WinRtnData' style='padding:10px;display:none;'></div>");     //增加到页面
		}
	
		var titleInfo="上传文件";
		if(OpenMode=="1"){
			titleInfo="附件预览";
		}
	
		var RootPath="/imedical/web/";  
	 
		var url=RootPath+"csp/insu/com/uploadfile.csp";
		var InputParam="?ProofType="+ProofType+"&TargetRecDr="+TargetRecDr+"&OpenMode="+OpenMode;
		InputParam=InputParam+"&fileMaxSize="+fileMaxSize+"&FileExtStrs="+FileExtStrs+"&ProoFileMaxNum="+ProoFileMaxNum;
		var encodesrc=url+InputParam;
		$('#UploadFileWindow iframe').attr("src",encodesrc);
		$('#UploadFileWindow iframe').attr("src",encodesrc);
		$('#UploadFileWindow').window({
			title:titleInfo,
			modal:true,
			width: 900,
       	 	height: 520,

			collapsible:false,
			minimizable:false,
			maximizable:false,
			onClose:function(){
				ObjResultObj=JSON.parse($("#WinRtnData").text());
				resolve(ObjResultObj);
			}
		});
		$('#UploadFileWindow').window('open');
	
	}).then(function(dataRtn){
		if(typeof(CallBackFun)=="function"){
			CallBackFun(dataRtn);   //promise 方式回调原页面方法
		}
	});
	return ObjResultObj;
}


 
