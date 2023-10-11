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
		$.messager.alert('��ʾ',"δ��ȡ�����Ƽ�¼,������.","info");
		return false;		
	}
	var PicObj=$HUI.filebox("#Pic");
	var PicName=PicObj.options().oldValue;
    if(PicName.indexOf("^")>-1){
		$.messager.alert('��ʾ',PicName+"ͼƬ���Ʋ��˰���ϵͳ�޶��ַ�'^'.","info");
		return false; 
	}
	var FileObj =PicObj.files();
	if (FileObj.length>10) {
		$.messager.alert('��ʾ',"һ���ϴ�ͼƬ���ܴ���10��.","info");
		return false; 
	}else if (FileObj.length==0) {
		$.messager.alert('��ʾ',"��ѡ����Ҫ�ϴ���ͼƬ.","info");
		return false; 
	}
	$.messager.progress({
	    title:"��ʾ",
	    msg:"���Ե�,�����ϴ�����....",
	    text:"�ϴ���..."
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
						if(ret=="-100"){ret="����ͼƬ����ʧ��!"}
						else if(ret=="-101"){ret="���±���ͼƬ���ʧ��!"}
						$.messager.alert('��ʾ',PicName+"�ϴ�ʧ��,"+ret,"warning");
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
		var AllowImgFileSize = 10485760; //�ϴ�ͼƬ���ֵ(��λ�ֽ�)�� 1 M = 1048576 B ������2M�ϴ�ʧ��
		var imgUrlBase64;
		var base64Img="";
		if (file) {
			var fname=file.name.toLowerCase();
			if(!/.(gif|jpg|jpeg|png|gif|jpg|png)$/.test(fname)){
				$.messager.progress('close');
	            $.messager.alert('��ʾ',"�ϴ�ͼƬ���ͱ�����.gif,jpeg,jpg,png�е�һ��!","info");
	            return false;
	        }
			//���ļ���Data URL��ʽ����ҳ��  
			imgUrlBase64 = reader.readAsDataURL(file);
			reader.onload = function (e) {
				if (AllowImgFileSize != 0 && AllowImgFileSize < reader.result.length) {
					$.messager.progress('close');
					$.messager.alert('��ʾ',picname+"���ϴ�������10M��ͼƬ��","info");
					return false;
				}else{
					base64Img=reader.result;
					callback.call(this, base64Img,file);
					return true;
				}
			}
		}else{
			$.messager.progress('close');
			$.messager.alert('��ʾ',picname+"��ȡ�ļ�����!","warning");
			return false;
		}
		return true;
	}catch(e){
		$.messager.progress('close');
		$.messager.alert('��ʾ',picname+e.message,"error");
		return false;
	}
}