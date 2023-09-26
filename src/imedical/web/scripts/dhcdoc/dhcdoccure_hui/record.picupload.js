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
	//��ֹ�ڿհ״����˸���������Զ����˵���һ������
	if (!websys_cancelBackspace(e)) return false;
	//�������Backspace������  
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
        if (event.keyCode == 83){ //����ҽ��
            UpdateClickHandler();
        }
        return false;
    }
}
function UploadPicFile(){
	var DCRRowId=$("#DCRRowId").val();
	if(DCRRowId==""){
		$.messager.alert('��ʾ',"δ��ȡ�����Ƽ�¼,������.");
		return false;		
	}
	var PicCount=5;
	for(i=1;i<=PicCount;i++){
		var TageName="Pic"+i;
		var PicName="ͼƬ"+i;
    	var FileObj =$HUI.filebox('#'+TageName).files();
    	var FilePath=FileObj[0];
    	//alert(!FilePath+",,,"+typeof(FilePath))
    	if((!FilePath)||(typeof(FilePath)=="undefined")){
			continue;
	    }
	    var PicName=$HUI.filebox('#'+TageName).options().oldValue;
	    var PicObj=$HUI.filebox('#'+TageName);
	    if(PicName.indexOf("^")>-1){
			$.messager.alert('��ʾ',PicName+"ͼƬ���Ʋ��˰���ϵͳ�޶��ַ�'^'.");
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
					if(ret=="-100"){ret="����ͼƬ����ʧ��!"}
					else if(ret=="-101"){ret="���±���ͼƬ���ʧ��!"}
					$.messager.alert('��ʾ',PicName+"�ϴ�ʧ��,"+ret);
				}else{
					$.messager.alert('��ʾ',PicName+"�ϴ��ɹ�");
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
		var AllowImgFileSize = 2100000; //�ϴ�ͼƬ���ֵ(��λ�ֽ�)�� 2 M = 2097152 B ������2M�ϴ�ʧ��
		var imgUrlBase64;
		var base64Img="";
		if (file) {
			if(!/.(gif|jpg|jpeg|png|gif|jpg|png)$/.test(file.name)){
	            $.messager.alert('��ʾ',"�ϴ�ͼƬ���ͱ�����.gif,jpeg,jpg,png�е�һ��!");
	            return false;
	        }
			//���ļ���Data URL��ʽ����ҳ��  
			imgUrlBase64 = reader.readAsDataURL(file);
			reader.onload = function (e) {
				if (AllowImgFileSize != 0 && AllowImgFileSize < reader.result.length) {
					$.messager.alert('��ʾ',picname+"���ϴ�������2M��ͼƬ��");
					return false;
				}else{
					base64Img=reader.result;
					callback.call(this, base64Img,picobj);
					return true;
				}
			}
		}else{
			$.messager.alert('��ʾ',picname+"��ȡ�ļ�����!");
			return false;
		}
		return true;
	}catch(e){
		alert(picname+e.message)
		return false;
	}
}