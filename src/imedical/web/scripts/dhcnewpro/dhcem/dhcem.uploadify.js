
$(function(){
	//��ʼ����ѡ��
	initRadio();
	//��ʼ���ϴ�����
  	//initLoadify();
  	
  	initDatagrid();
  	
  	///������ʾʱ��Ĭ����ʾ����
	reloadImg();

	///��ʼ��ͼƬ��ʾ����
	initShowImg();
	
	//��ʼ���ϴ�ͼƬ
  	initFile();

}) 

//�ļ��ϴ�
function initFile(){
	if(PCLRowID==""){
		$.messager.alert("��ʾ","����ID����Ϊ��,��ѡ������¼�����ԣ�","error",function(){
			parent.websys_showModal('close');
		});
		return;
	}
	var fileTypeDesc = getTypeDesc();
	var myInput  = document.getElementById("myFile");
	myInput.onchange = function(){
    var file = this.files[0];
        if(!!file){
            var reader = new FileReader();
            //reader.readAsArrayBuffer(file);
            reader.readAsDataURL(file)
            reader.onload = function(){
                var binary = this.result;
                var PicName=$('#myFile').val();
                PicNameLen=PicName.split("\\").length;
                PicName=PicName.split("\\")[PicNameLen-1];
                //alert(binary) 
                var params = PCLRowID+"^"+PicName+"^"+fileTypeDesc+"^"+UserId+"^"+binary;
				runClassMethod("web.DHCEMFile","saveUrl",{'Params':params},function(ret){
					if(ret==0){
						//alert("�ɹ���");
						reloadImg();
						loadDatagrid();
					}	
				},'text')  
	        }
	    }
	}
	
}

function uploadPic(){
	 $('#myFile').click();
}

function initRadio(){
	
	$HUI.radio("[name='uploadType']",{
        onChecked:function(e,value){
	        initFile();
            //initLoadify();
			reloadImg();
			loadDatagrid();
        }
    });
}

function initDatagrid(){
	var columns=[[
    	{ field: 'PCDID',align: 'center', title: 'ID',width:50,hidden:true},
    	{ field: 'PCDDate',align: 'center', title: '�ϴ�����',width:50},
    	{ field: 'PCDTime',align: 'center', title: '�ϴ�ʱ��',width:50},
    	{ field: 'PCDUser',align: 'center', title: '�ϴ���',width:50},
    	{ field: 'PCDType',align: 'center', title: '�ϴ�����',width:50},
    	{ field: 'PCDFileName',align: 'center', title: '�ļ�����',width:100}
    
 	]]; 

 	$("#uploadTable").datagrid({
		url:LINK_CSP+"?ClassName=web.DHCEMFile&MethodName=GetUploadList",
		toolbar:'#toolbar',
		queryParams:{
			PCLID:PCLRowID,
			Type:getTypeDesc()
		},
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
		rowStyler:function(index,rowData){
			
		},
		onLoadSuccess:function(data){
		
		}
	});		
}

function loadDatagrid(){
	$("#uploadTable").datagrid("load",{
		PCLID:PCLRowID,
		Type:getTypeDesc()
	})		
}

/// 
function initLoadify(){
	if(PCLRowID==""){
		$.messager.alert("��ʾ","����ID����Ϊ��,��ѡ������¼�����ԣ�","error",function(){
			parent.websys_showModal('close');
		});
		return;
	}
	var fileName="";
	var fileNamePress = "##class(web.DHCEMFile).GetSaveImgName("+PCLRowID+")";
	var d = new Date();
	var curr_date = d.getDate();
    var curr_month = d.getMonth() + 1; 
    var curr_year = d.getFullYear();
    var curdate = curr_year+""+curr_month+""+curr_date;
	var fileTypeDesc = getTypeDesc();
	var dirname="\\patchecklev\\"+curdate+"\\"+fileTypeDesc+"\\"
	FTPFOLDERNAME==""?"":dirname="\\"+FTPFOLDERNAME+dirname
	$("#uploadify").uploadify({
		buttonClass:"uploadify-button-a",
		buttonText:$g("�ϴ��ļ�"),
		fileObjName:"FileStream",
		formData:{"CSPSESSIONID":SessionID,"PatCheckLevID":PCLRowID,"fileName":fileName,"fileNamePress":fileNamePress,"LgHospID":LgHospID}, //hxy 2020-04-21
		removeCompleted:true,
	    'swf': '../scripts/dhcnewpro/plugins/uploadify/uploadify.swf',
	    'uploader': "dhcem.file.csp?dirname="+dirname,
	    'fileTypeExts':'*.gif; *.jpg; *.png',
	    height:30,   
	    width:100,
	    auto:true,
	    'onUploadComplete' : function(file) {           //��ÿ���ļ��ϴ����ʱ���������۳ɹ����ǳ����������֪���ϴ��ɹ����ǳ�����ʹ�� onUploadSuccess��onUploadError �¼���
	       
	    },'onUploadSuccess' : function(file, data, response) {
			var imgUrl = $.parseJSON(data).fileFullName;
			var params = PCLRowID+"^"+imgUrl+"^"+fileTypeDesc+"^"+UserId;
			runClassMethod("web.DHCEMFile","saveUrl",{'Params':params},function(ret){
				if(ret==0){
					//alert("�������ݳɹ���");
					reloadImg();
					loadDatagrid();
				}	
			},'text')
		},
		'onUploadError' : function(file, errorCode, errorMsg, errorString) {
			//alert('The file ' + file.name + ' could not be uploaded: ' + errorString);
		},
		onComplete: function (evt, queueID, fileObj, response, data) {
				//alert(response);
		},
	    'multi': true                                 //Ĭ��ֵtrue���Ƿ�������ļ��ϴ���
    });	
}

///���¼���ͼƬ
function reloadImg(){
	if (!PCLRowID){
		return;
	}
	
	var fileTypeDesc = getTypeDesc();

	runClassMethod("web.DHCEMFile","GetUrlByPclID",{"PCLID":PCLRowID,"Type":fileTypeDesc,"LgHospID":LgHospID},function(data){ //hxy 2020-04-16 LgHospID
		$("#imgDiv").empty();
		dataArr=data.split("$");
		for(var i=0;i<dataArr.length;i++){
			$("#imgDiv").append(dataArr[i]);	
		}
		initShowImg();
	},'text')
}

///Return:1,2,3
function getTypeDesc(){
	var fileType=$("input[name='uploadType']:checked").val();
	if(fileType==undefined) fileType=1;
    return fileType;
    
    var fileTypeDesc="";
    if(fileType=="1"){
	   fileTypeDesc = "���ȵ�";
	}
	 if(fileType=="2"){
	   fileTypeDesc = "������";
	}
	 if(fileType=="3"){
	   fileTypeDesc = "�Ӿ���";
	}
	return 	fileTypeDesc;
}


function deleteImg(){

	var rowData = $("#uploadTable").datagrid("getSelections");	
	if(!rowData.length){
		$.messager.alert("��ʾ","δѡ�����ݣ�");
		return;
	}
	$.messager.confirm("��ʾ","ȷ��ɾ��ѡ��������?",function(r){
		if(!r) return;
		
		$("#Loading").fadeIn("fast");
		
		$m({
			ClassName:"web.DHCEMFile",
			MethodName:"deleteUrl",
			ID:rowData[0].PCDID
		},function(ret){
			$("#Loading").fadeOut("fast");
			var tp=(ret==0?"ɾ���ɹ�!":"ʧ��!"+ret)
			$.messager.alert("��ʾ",tp);
			reloadImg();
			loadDatagrid();
			return;
		});
	})
	
}
