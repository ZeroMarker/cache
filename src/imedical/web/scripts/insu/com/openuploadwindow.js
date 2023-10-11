/*
*
*�ļ����ƣ�insu/com/openuploadwindow.js
*����˵����ͨ���ϴ�����
*�޸�����������  2023-01-03
*/




/// ����˵�����ϴ��ļ����ڴ򿪣����߲�ѯ���ϴ����ļ� 
/// ���˵���� ProofType �ϴ��ļ����ͣ����ֵ��н��ж��壩
///            TargetRecDr     ��������Dr
///            OpenMode  ��ģʽ 0-->�ϴ�ģʽ 1-->�����鿴�Ѿ��ϴ��ļ�ģʽ
///  		   fileMaxSize  �����ļ���С          ��λM (Ĭ��Ϊ2)
///  		   FileExtStrs  ���ϴ��ļ�����  "txt,png,jpg,..."(Ĭ��ΪͼƬ��ʽ)
///  		   ProoFileMaxNum ����ϴ��ļ�����    (Ĭ��Ϊ5)
/// �޸������� ���� 2023-01-04 ������
function OpenUploadFileWindow(ProofType, TargetRecDr, OpenMode,fileMaxSize,FileExtStrs,ProoFileMaxNum, ExtStr){
	
	if($('#UploadFileWindow').length==0){
		$('#UploadFileWindow').empty();
		
		var UploadFileWindowHtml="<div  id='UploadFileWindow' style='padding:10px;overflow:hidden;'>";
		UploadFileWindowHtml=UploadFileWindowHtml+"<iframe style='width:100%;height:100%;border:0;overflow:hidden;' src=''></iframe>";
		UploadFileWindowHtml=UploadFileWindowHtml+"</div>";
		
		$UploadFileWindow=$(UploadFileWindowHtml);
		$("body").append($UploadFileWindow);     //���ӵ�ҳ��
	}
	
	var titleInfo="�ϴ��ļ�";
	if(OpenMode=="1"){
		titleInfo="����Ԥ��"; 
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



/// ����˵�����ϴ��ļ����ڴ򿪣����߲�ѯ���ϴ����ļ�
/// ���˵���� ProofType �ϴ��ļ����ͣ����ֵ��н��ж��壩 
///            TargetRecDr     ��������Dr
///            OpenMode  ��ģʽ 0-->�ϴ�ģʽ 1-->�����鿴�Ѿ��ϴ��ļ�ģʽ
///  		   fileMaxSize  �����ļ���С          ��λM (Ĭ��Ϊ2)
///  		   FileExtStrs  ���ϴ��ļ�����  "txt,png,jpg,..."(Ĭ��ΪͼƬ��ʽ)
///  		   ProoFileMaxNum ����ϴ��ļ�����    (Ĭ��Ϊ5)
///			   CallBackFun   ԭҳ��ص����� 
/// �޸������� ���� 2023-01-04 ������
function OpenUploadFileWindowNew(ProofType, TargetRecDr, OpenMode,fileMaxSize,FileExtStrs,ProoFileMaxNum, CallBackFun, ExtStr){

	var ObjResultObj=[];	
	new Promise(function(resolve, reject) {
		
		if($('#UploadFileWindow').length==0){
			$('#UploadFileWindow').empty();
		
			var UploadFileWindowHtml="<div id='UploadFileWindow' style='padding:10px;overflow:hidden;'>";
			UploadFileWindowHtml=UploadFileWindowHtml+"<iframe style='width:100%;height:100%;border:0;overflow:hidden;' src=''></iframe>";
			UploadFileWindowHtml=UploadFileWindowHtml+"</div>";
		
			$UploadFileWindow=$(UploadFileWindowHtml);
			$("body").append($UploadFileWindow);     //���ӵ�ҳ��
			$("body").append("<div id='WinRtnData' style='padding:10px;display:none;'></div>");     //���ӵ�ҳ��
		}
	
		var titleInfo="�ϴ��ļ�";
		if(OpenMode=="1"){
			titleInfo="����Ԥ��";
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
			CallBackFun(dataRtn);   //promise ��ʽ�ص�ԭҳ�淽��
		}
	});
	return ObjResultObj;
}


 
