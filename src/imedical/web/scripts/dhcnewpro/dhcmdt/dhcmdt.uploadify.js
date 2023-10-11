
var LINK_CSP = "dhcapp.broker.csp";

$(function(){
	initPage();
	
	//��ʼ����ѡ��
	initRadio();
	
	//��ʼ���ϴ�����
  	//initLoadify();
  	initAtta()  	
  	
  	initDatagrid();
  	
  	///������ʾʱ��Ĭ����ʾ����
	reloadImg();

	///��ʼ��ͼƬ��ʾ����
	initShowImg();
}) 

function initPage(){
	if(SeeCstType==1){
		$("#contentLayout").hide();
		$("#imgDiv").remove();
		$(".onlyImgDiv").attr("id","imgDiv")
		$(".onlyImgDiv").show();
		return;
	}	
}


function initRadio(){
	
	$HUI.radio("[name='uploadType']",{
        onChecked:function(e,value){
            initLoadify();
			loadDatagrid();
        }
    });
}

function initDatagrid(){
	var columns=[[
    	{ field: 'MPCDID',align: 'left', title: 'ID',width:50,hidden:true},
    	{ field: 'MPCDDate',align: 'left', title: '�ϴ�����',width:50},
    	{ field: 'MPCDTime',align: 'left', title: '�ϴ�ʱ��',width:50},
    	{ field: 'MPCDUser',align: 'left', title: '�ϴ���',width:50},
    	{ field: 'MPCDType',align: 'left', title: '�ϴ�����',width:50},
    	{ field: 'MPCDFileName',align: 'left', title: '�ļ�����',width:100}
    
 	]]; 

 	$("#uploadTable").datagrid({
		url:LINK_CSP+"?ClassName=web.DHCMDTFile&MethodName=GetUploadList"+"&MWToken="+websys_getMWToken(),
		toolbar:'#toolbar',
		queryParams:{
			PCLID:MdtCstID,
			Type:1
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
		PCLID:MdtCstID,
		Type:getTypeDesc()
	})		
}

/// 
function initLoadify(){
	if(MdtCstID==""){
		$.messager.alert("��ʾ","MDT����ID����Ϊ��,��ѡ������¼�����ԣ�","error",function(){
			parent.websys_showModal('close');
		});
		return;
	}
	var fileName="";
	var fileNamePress = "##class(web.DHCMDTFile).GetSaveImgName("+MdtCstID+")";
	var d = new Date();
	var curr_date = d.getDate();
    var curr_month = d.getMonth() + 1; 
    var curr_year = d.getFullYear();
    var curdate = curr_year+""+curr_month+""+curr_date;
	var fileTypeDesc = getTypeDesc();
	var dirname="\\dhcmdt\\"+curdate+"\\"+fileTypeDesc+"\\"
	FTPFOLDERNAME==""?"":dirname="\\"+FTPFOLDERNAME+dirname
	$("#uploadify").uploadify({
		buttonClass:"uploadify-button-a",
		buttonText:$g("�ϴ��ļ�"),
		fileObjName:"FileStream",
		formData:{"CSPSESSIONID":SessionID,"PatCheckLevID":MdtCstID,"fileName":fileName,"fileNamePress":fileNamePress,"LgHospID":LgHospID}, //hxy 2020-04-21
		removeCompleted:true,
	    'swf': '../scripts/dhcnewpro/plugins/uploadify/uploadify.swf',
	    'uploader': "dhcmdt.file.csp?dirname="+dirname+"&MWToken="+websys_getMWToken(),
	    'fileTypeExts':'*.gif; *.jpg; *.png;',  //*.pdf; *.doc;
	    height:30,   
	    width:100,
	    auto:true,
	    'onUploadComplete' : function(file) {           //��ÿ���ļ��ϴ����ʱ���������۳ɹ����ǳ����������֪���ϴ��ɹ����ǳ�����ʹ�� onUploadSuccess��onUploadError �¼���
	       
	    },'onUploadSuccess' : function(file, data, response) {
		    var retDate = $.parseJSON(data);
		    if(!retDate.fileFullName){
				$.messager.alert("�ϴ�ʧ��",retDate.msg);
				return;  	 
			}
			var imgUrl = retDate.fileFullName;
			var params = MdtCstID+"^"+imgUrl+"^"+fileTypeDesc+"^"+UserId;
			runClassMethod("web.DHCMDTFile","saveUrl",{'Params':params},function(ret){
				if(ret==0){
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
			ClassName:"web.DHCMDTFile",
			MethodName:"deleteUrl",
			ID:rowData[0].MPCDID
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



///���¼���ͼƬ
function reloadImg(){
	if (!MdtCstID){
		return;
	}
	
	var fileTypeDesc = getTypeDesc();

	runClassMethod("web.DHCMDTFile","GetUrlByPclID",{"PCLID":MdtCstID,"Type":fileTypeDesc,"LgHospID":LgHospID},function(data){ //hxy 2020-04-16 LgHospID
		$("#imgDiv").empty();
		dataArr=data.split("$");
		if(dataArr[0].length<10){
			$("#imgDiv").append('<img src="../scripts/dhcnewpro/images/no-file.png" style="width:98%;height:97%">');	
			return;
		}
		for(var i=0;i<dataArr.length;i++){
			$("#imgDiv").append(dataArr[i]);	
		}
		initShowImg();
	},'text')
}

////���ļ��ϴ�
function initAtta(){
	var fileMap={}; 
	function initFileInput(){
		$('#file-atta').remove(); 
		$('body').append('<input type="file" id="file-atta" name="file-atta"  style="position:absolute;top:-1000px;" />');
		$('#file-atta').off('change').change(function(){
			var fileName=this.value;
			
			if (fileName.indexOf('\\')>-1) fileName=fileName.split('\\').pop();
			if (fileName.indexOf('/')>-1) fileName=fileName.split('/').pop();
			
			var files=this.files;
			if (files && files[0] && fileName){
				debugger
				if( !fileMap[fileName]) {
					startUpload(files,fileName);
				}else{
					$.messager.confirm('ȷ��','���ļ����ϴ����Ƿ������ϴ���',function(r){
						if(r){
							startUpload(files,fileName);
						}else{
							initFileInput();
						}
					})
				}
			}
			
		})
	}
	initFileInput();
	$('#btn-atta').append('<label class="filebox-label" for="file-atta"></label>');

	
	
	function startUpload(files,fileName){
		$('#btn-atta').linkbutton('disable');
		//$('#file-atta').attr('disable','disable');
		GV.disableSend();
		
		bsp_sys_ajaxUploadFile(files,{dir:GV.dir},function(succ,url,retDate){
			if(succ){
				if(!retDate.fileFullName){
					$.messager.alert("�ϴ�ʧ��",retDate.msg);
					return;  	 
				}
				var fileTypeDesc=getTypeDesc()
				var imgUrl = retDate.fileFullName;
				var params = MdtCstID+"^"+imgUrl+"^"+fileTypeDesc+"^"+UserId;
				runClassMethod("web.DHCMDTFile","saveUrl",{'Params':params},function(ret){
					if(ret==0){
						reloadImg();
						loadDatagrid();
					}	
				},'text')
							
			}else{
				$.messager.popover({msg:url,type:'error'})
			}
			$('#btn-atta').linkbutton('enable');
			initFileInput();
			GV.enableSend();
			
		})
	}
	$('#atta-tr').on('click','.atta-item .remove',function(){
		var attaItem=$(this).parent();
		var fileName=attaItem.data('fileName')
		attaItem.remove();
		delete fileMap[fileName];
	})
	GV.getAtta=function(){
		var surlArr=[];
		$('.atta-item').each(function(ind,itm){
			surlArr.push($(this).data('attaUrl'));
		});
		var surl = surlArr.join(",");
		return surl;	
	}
	GV.clearAtta=function(){
		$('.atta-item').remove();
		fileMap={};
	}
}
function bsp_sys_ajaxUploadFile(files,options,callback){
	var dir=options.dir;
	if (!dir) {
		if (typeof callback=='function'){
			callback(false,'û��ָ���ļ�·��')
		}
		return false;
	}
	if (!files || !files[0]) {
		if (typeof callback=='function'){
			callback(false,'û��ѡ���ļ�')
		}
		return false;
	}
	
	var fileNamePress = "##class(web.DHCMDTFile).GetSaveImgName("+MdtCstID+")";
	var formData = new FormData();
	formData.append('FileStream', files[0]);
	formData.append('dirname',dir);
	formData.append('act','upload');
	formData.append('LgHospID',LgHospID);
	formData.append('fileNamePress',fileNamePress);
	var a=$.ajax({
	    url: 'dhcmdt.filenew.csp',
	    type: 'POST',
	    cache: false,
	    dataType:'text',
	    data: formData,
	    processData: false,
	    contentType: false
	}).done(function(ret) {
		try{
			ret=$.parseJSON(ret);	
		}catch(e){
			ret={fileFullName:'',msg:e.message}
		}
		if (ret.fileFullName){ //�ϴ��ɹ�
			if (typeof callback=='function'){
				callback(true,ret.fileFullName,ret)
			}
		}else{
			if (typeof callback=='function'){
				callback(false,ret.msg||'',ret)
			}
		}
	}).fail(function(res) {
		//console.log(res);
		if (typeof callback=='function'){
			callback(false,'�ļ��ϴ�ʧ��')
		}
	});
	
	return a;
}
