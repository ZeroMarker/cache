
$(function(){
	//初始化复选框
	initRadio();
	//初始化上传工具
  	//initLoadify();
  	
  	initDatagrid();
  	
  	///界面显示时候默认显示数据
	reloadImg();

	///初始化图片显示工具
	initShowImg();
	
	//初始化上传图片
  	initFile();

}) 

//文件上传
function initFile(){
	if(PCLRowID==""){
		$.messager.alert("提示","分诊ID不能为空,请选择分诊记录后重试！","error",function(){
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
						//alert("成功！");
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
    	{ field: 'PCDDate',align: 'center', title: '上传日期',width:50},
    	{ field: 'PCDTime',align: 'center', title: '上传时间',width:50},
    	{ field: 'PCDUser',align: 'center', title: '上传人',width:50},
    	{ field: 'PCDType',align: 'center', title: '上传类型',width:50},
    	{ field: 'PCDFileName',align: 'center', title: '文件名称',width:100}
    
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
		loadMsg: $g('正在加载信息...'),
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
		$.messager.alert("提示","分诊ID不能为空,请选择分诊记录后重试！","error",function(){
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
		buttonText:$g("上传文件"),
		fileObjName:"FileStream",
		formData:{"CSPSESSIONID":SessionID,"PatCheckLevID":PCLRowID,"fileName":fileName,"fileNamePress":fileNamePress,"LgHospID":LgHospID}, //hxy 2020-04-21
		removeCompleted:true,
	    'swf': '../scripts/dhcnewpro/plugins/uploadify/uploadify.swf',
	    'uploader': "dhcem.file.csp?dirname="+dirname,
	    'fileTypeExts':'*.gif; *.jpg; *.png',
	    height:30,   
	    width:100,
	    auto:true,
	    'onUploadComplete' : function(file) {           //在每个文件上传完成时触发，无论成功还是出错。如果你想知道上传成功还是出错，请使用 onUploadSuccess和onUploadError 事件。
	       
	    },'onUploadSuccess' : function(file, data, response) {
			var imgUrl = $.parseJSON(data).fileFullName;
			var params = PCLRowID+"^"+imgUrl+"^"+fileTypeDesc+"^"+UserId;
			runClassMethod("web.DHCEMFile","saveUrl",{'Params':params},function(ret){
				if(ret==0){
					//alert("保存数据成功！");
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
	    'multi': true                                 //默认值true，是否允许多文件上传。
    });	
}

///重新加载图片
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
	   fileTypeDesc = "急救单";
	}
	 if(fileType=="2"){
	   fileTypeDesc = "救助单";
	}
	 if(fileType=="3"){
	   fileTypeDesc = "接警单";
	}
	return 	fileTypeDesc;
}


function deleteImg(){

	var rowData = $("#uploadTable").datagrid("getSelections");	
	if(!rowData.length){
		$.messager.alert("提示","未选中数据！");
		return;
	}
	$.messager.confirm("提示","确定删除选中数据吗?",function(r){
		if(!r) return;
		
		$("#Loading").fadeIn("fast");
		
		$m({
			ClassName:"web.DHCEMFile",
			MethodName:"deleteUrl",
			ID:rowData[0].PCDID
		},function(ret){
			$("#Loading").fadeOut("fast");
			var tp=(ret==0?"删除成功!":"失败!"+ret)
			$.messager.alert("提示",tp);
			reloadImg();
			loadDatagrid();
			return;
		});
	})
	
}
