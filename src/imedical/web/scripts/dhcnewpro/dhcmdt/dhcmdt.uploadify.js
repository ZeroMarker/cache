
var LINK_CSP = "dhcapp.broker.csp";

$(function(){
	initPage();
	
	//初始化复选框
	initRadio();
	
	//初始化上传工具
  	//initLoadify();
  	initAtta()  	
  	
  	initDatagrid();
  	
  	///界面显示时候默认显示数据
	reloadImg();

	///初始化图片显示工具
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
    	{ field: 'MPCDDate',align: 'left', title: '上传日期',width:50},
    	{ field: 'MPCDTime',align: 'left', title: '上传时间',width:50},
    	{ field: 'MPCDUser',align: 'left', title: '上传人',width:50},
    	{ field: 'MPCDType',align: 'left', title: '上传类型',width:50},
    	{ field: 'MPCDFileName',align: 'left', title: '文件名称',width:100}
    
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
		PCLID:MdtCstID,
		Type:getTypeDesc()
	})		
}

/// 
function initLoadify(){
	if(MdtCstID==""){
		$.messager.alert("提示","MDT会诊ID不能为空,请选择会诊记录后重试！","error",function(){
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
		buttonText:$g("上传文件"),
		fileObjName:"FileStream",
		formData:{"CSPSESSIONID":SessionID,"PatCheckLevID":MdtCstID,"fileName":fileName,"fileNamePress":fileNamePress,"LgHospID":LgHospID}, //hxy 2020-04-21
		removeCompleted:true,
	    'swf': '../scripts/dhcnewpro/plugins/uploadify/uploadify.swf',
	    'uploader': "dhcmdt.file.csp?dirname="+dirname+"&MWToken="+websys_getMWToken(),
	    'fileTypeExts':'*.gif; *.jpg; *.png;',  //*.pdf; *.doc;
	    height:30,   
	    width:100,
	    auto:true,
	    'onUploadComplete' : function(file) {           //在每个文件上传完成时触发，无论成功还是出错。如果你想知道上传成功还是出错，请使用 onUploadSuccess和onUploadError 事件。
	       
	    },'onUploadSuccess' : function(file, data, response) {
		    var retDate = $.parseJSON(data);
		    if(!retDate.fileFullName){
				$.messager.alert("上传失败",retDate.msg);
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
	    'multi': true                                 //默认值true，是否允许多文件上传。
    });	
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
			ClassName:"web.DHCMDTFile",
			MethodName:"deleteUrl",
			ID:rowData[0].MPCDID
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



///重新加载图片
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

////新文件上传
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
					$.messager.confirm('确认','此文件已上传，是否重新上传？',function(r){
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
					$.messager.alert("上传失败",retDate.msg);
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
			callback(false,'没有指定文件路径')
		}
		return false;
	}
	if (!files || !files[0]) {
		if (typeof callback=='function'){
			callback(false,'没有选择文件')
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
		if (ret.fileFullName){ //上传成功
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
			callback(false,'文件上传失败')
		}
	});
	
	return a;
}
