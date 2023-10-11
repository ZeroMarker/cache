$(document).ready(function(){
	Init();
	InitEvent();
	//PageHandle();
})

function Init(){
	
}
function InitEvent(){
	$('#picupload').click(function() {
		UploadPicFile();
	})
	document.onkeydown = Page_OnKeyDown;
}

function Page_OnKeyDown(e){
	//防止在空白处敲退格键，界面自动回退到上一个界面
	if (!websys_cancelBackspace(e)) return false;
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;   
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }  
    if (e){
        var ctrlKeyFlag=e.ctrlKey;
    }else{
        var ctrlKeyFlag=window.event.ctrlKey;
    }
    if (ctrlKeyFlag){
        if (event.keyCode == 83){ //保存医嘱
            UpdateClickHandler();
        }
        return false;
    }
}

function UploadPicFile(){
	var DCRRowId=$("#DCRRowId").val();
	if(DCRRowId==""){
		$.messager.alert('提示',"未获取到治疗记录,请重试.","info");
		return false;		
	}
	var PicObj=$HUI.filebox("#Pic");
	var PicName=PicObj.options().oldValue;
    if(PicName.indexOf("^")>-1){
		$.messager.alert('提示',PicName+"图片名称不宜包含系统限定字符'^'.","info");
		return false; 
	}
	var FileObj =PicObj.files();
	if (FileObj.length>10) {
		$.messager.alert('提示',"一次上传图片不能大于10张.","info");
		return false; 
	}else if (FileObj.length==0) {
		$.messager.alert('提示',"请选择需要上传的图片.","info");
		return false; 
	}
	$.messager.progress({
	    title:"提示",
	    msg:"请稍等,正在上传保存....",
	    text:"上传中..."
    })
    var eachCount=0;
	$.each(FileObj, function(index, FilePath){
		if((!FilePath)||(typeof(FilePath)=="undefined")){
	    }else {
		    convertImgToBase64(FilePath,function(base64Img,file){
		    	if(base64Img!=""){
			    	var DCRRowId=$("#DCRRowId").val();
					var PicName=file.name;
				    var ret=$.cm({
						ClassName:"DHCDoc.DHCDocCure.Record",
						MethodName:"SaveRecordPic",
						'DCRRowID':DCRRowId,
						'PicName':PicName,
						'PicData':base64Img,
						'UserID':session['LOGON.USERID'],
						dataType:"text"
					},false)
					if (ret!=0){
						if(ret=="-100"){ret="保存图片数据失败!"}
						else if(ret=="-101"){ret="更新保存图片标记失败!"}
						$.messager.alert('提示',PicName+"上传失败,"+ret,"warning");
					}
					eachCount++;
					if(eachCount==FileObj.length){
						AfterUpload();	
					}else{
						$.messager.progress('close');	
					}
		    	}
		    });
	    }
	})
	function AfterUpload(){
		$.messager.progress('close');
		if (websys_showModal("options")) {
			websys_showModal('options').CureRecordDataGridLoad();	
		}
		PicObj.clear();	
	}
}

function convertImgToBase64(file,callback){
	try{
		var reader = new FileReader();
		var AllowImgFileSize = 10485760; //上传图片最大值(单位字节)（ 1 M = 1048576 B ）超过2M上传失败
		var imgUrlBase64;
		var base64Img="";
		if (file) {
			var fname=file.name.toLowerCase();
			if(!/.(gif|jpg|jpeg|png|gif|jpg|png)$/.test(fname)){
				$.messager.progress('close');
	            $.messager.alert('提示',"上传图片类型必须是.gif,jpeg,jpg,png中的一种!","info");
	            return false;
	        }
			//将文件以Data URL形式读入页面  
			imgUrlBase64 = reader.readAsDataURL(file);
			reader.onload = function (e) {
				if (AllowImgFileSize != 0 && AllowImgFileSize < reader.result.length) {
					$.messager.progress('close');
					$.messager.alert('提示',picname+"请上传不大于10M的图片！","info");
					return false;
				}else{
					base64Img=reader.result;
					callback.call(this, base64Img,file);
					return true;
				}
			}
		}else{
			$.messager.progress('close');
			$.messager.alert('提示',picname+"获取文件错误!","warning");
			return false;
		}
		return true;
	}catch(e){
		$.messager.progress('close');
		$.messager.alert('提示',picname+e.message,"error");
		return false;
	}
}