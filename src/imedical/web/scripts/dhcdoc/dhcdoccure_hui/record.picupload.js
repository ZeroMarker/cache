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
		$.messager.alert('提示',"未获取到治疗记录,请重试.");
		return false;		
	}
	var PicCount=5;
	for(i=1;i<=PicCount;i++){
		var TageName="Pic"+i;
		var PicName="图片"+i;
    	var FileObj =$HUI.filebox('#'+TageName).files();
    	var FilePath=FileObj[0];
    	//alert(!FilePath+",,,"+typeof(FilePath))
    	if((!FilePath)||(typeof(FilePath)=="undefined")){
			continue;
	    }
	    var PicName=$HUI.filebox('#'+TageName).options().oldValue;
	    var PicObj=$HUI.filebox('#'+TageName);
	    if(PicName.indexOf("^")>-1){
			$.messager.alert('提示',PicName+"图片名称不宜包含系统限定字符'^'.");
			continue; 
		}
    	convertImgToBase64(FilePath,function(base64Img,picobj){
	    	if(base64Img!=""){
		    	//base64Img=base64Img.split(",")[1]
		    	var DCRRowId=$("#DCRRowId").val();
		    	/*var onelen=50000;
				var loop=Math.ceil(base64Img.length/onelen)
				var base64ImgArr=new Array();
				for(var i=0;i<5;i++){
					base64ImgArr[i]=base64Img.substring(i*onelen,onelen)
				}*/
				var PicName=picobj.options().oldValue;
			    var ret=$.cm({
					ClassName:"DHCDoc.DHCDocCure.Record",
					MethodName:"SaveRecordPic",
					'DCRRowID':DCRRowId,
					'PicName':PicName,
					'PicData':base64Img,
					'UserID':session['LOGON.USERID'],
					dataType:"text"
				},false)
				//var ret=tkMakeServerCall("DHCDoc.DHCDocCure.Record","SaveRecordPic",DCRRowId,name,base64Img,session['LOGON.USERID'])
				if (ret!=0){
					if(ret=="-100"){ret="保存图片数据失败!"}
					else if(ret=="-101"){ret="更新保存图片标记失败!"}
					$.messager.alert('提示',PicName+"上传失败,"+ret);
				}else{
					$.messager.alert('提示',PicName+"上传成功");
					picobj.clear();
					websys_showModal('options').CureRecordDataGridLoad();	
					//websys_showModal("close");
				}
	    	}
	    },PicObj);
	}
}

function convertImgToBase64(file,callback,picobj){
	try{
		var reader = new FileReader();
		var AllowImgFileSize = 2100000; //上传图片最大值(单位字节)（ 2 M = 2097152 B ）超过2M上传失败
		var imgUrlBase64;
		var base64Img="";
		if (file) {
			if(!/.(gif|jpg|jpeg|png|gif|jpg|png)$/.test(file.name)){
	            $.messager.alert('提示',"上传图片类型必须是.gif,jpeg,jpg,png中的一种!");
	            return false;
	        }
			//将文件以Data URL形式读入页面  
			imgUrlBase64 = reader.readAsDataURL(file);
			reader.onload = function (e) {
				if (AllowImgFileSize != 0 && AllowImgFileSize < reader.result.length) {
					$.messager.alert('提示',picname+"请上传不大于2M的图片！");
					return false;
				}else{
					base64Img=reader.result;
					callback.call(this, base64Img,picobj);
					return true;
				}
			}
		}else{
			$.messager.alert('提示',picname+"获取文件错误!");
			return false;
		}
		return true;
	}catch(e){
		alert(picname+e.message)
		return false;
	}
}