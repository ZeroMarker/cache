
$(function(){
	var recordId =getParam("recordId");	
	//初始化上传工具
  	initLoadify(recordId);
  	
  	initDatagrid(recordId);
  	
  	///界面显示时候默认显示数据
	reloadImg(recordId);

	///初始化图片显示工具
	initShowImg();
}) 




function initDatagrid(recordId){
	var columns=[[
    	{ field: 'ATTRID',align: 'center', title: 'ID',width:50,hidden:true},
    	{ field: 'ATTRDate',align: 'center', title: '上传日期',width:50},
    	{ field: 'ATTRTime',align: 'center', title: '上传时间',width:50},
    	{ field: 'ATTRUser',align: 'center', title: '上传人',width:50},
    	{ field: 'ATTRFileName',align: 'center', title: '文件名称',width:100}
    
 	]]; 
 	$("#uploadTable").datagrid({
		url:LINK_CSP+"?ClassName=web.DHCADVFile&MethodName=GetUploadList",
		toolbar:'#toolbar',
		queryParams:{
			RecordId:recordId,
			
		},
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		rowStyler:function(index,rowData){
			
		},
		onLoadSuccess:function(data){
		
		}
	});		
}

function loadDatagrid(recordId){
	$("#uploadTable").datagrid("load",{
		RecordId:recordId,
	})		
}

/// 
function initLoadify(recordId){
	var fileName="";
	//var fileNamePress = "##class(web.DHCEMFile).GetSaveImgName("+PCLRowID+")";
	var d = new Date();
	var curr_date = d.getDate();
    var curr_month = d.getMonth() + 1; 
    var curr_year = d.getFullYear();
    var curdate = curr_year+""+curr_month+""+curr_date;
	//var fileTypeDesc ="123";
	$("#uploadify").uploadify({
		buttonClass:"uploadify-button-a",
		buttonText:"上传图片",
		fileObjName:"FileStream",
		formData:{"fileName":fileName},
		removeCompleted:true,
		'uploader': "dhcadv.upload.csp?dirname=\\dhcAdvEvt\\picture\\"+curdate+"\\", //'websys.file.utf8.csp',
	    'swf': '../scripts/dhcadvEvt/jqueryplugins/uploadify/uploadify.swf',
	    'fileTypeExts':'*.gif; *.jpg; *.png',
	    height:30,   
	    width:100,
	    auto:true,
	    'onUploadComplete' : function(file) {           //在每个文件上传完成时触发，无论成功还是出错。如果你想知道上传成功还是出错，请使用 onUploadSuccess和onUploadError 事件。
	       
	    },
	    'onUploadSuccess' : function(file, data, response) {
			var imgUrl = $.parseJSON(data).fileFullName;
			var ip = $.parseJSON(data).ip;
			var params = recordId+"^"+imgUrl+"^"+UserId;
			runClassMethod("web.DHCADVFile","saveUrl",{'Params':params},function(ret){
				if(ret==0){
					$.messager.alert("提示","保存数据成功！");
					reloadImg(recordId);
					loadDatagrid(recordId);
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
function reloadImg(recordId){
	if (!recordId){
		return;
	}
	//var fileTypeDesc = getTypeDesc();

	runClassMethod("web.DHCADVFile","GetUrlByRedID",{"recordId":recordId},function(data){
		$("#imgDiv").empty();
		dataArr=data.split("$");
		for(var i=0;i<dataArr.length;i++){
			$("#imgDiv").append(dataArr[i]);	
		}
		initShowImg();
	},'text')
}


function deleteImg(){
    var recordId =getParam("recordId");	
	var rowData = $("#uploadTable").datagrid("getSelections");	
	if(!rowData.length){
		$.messager.alert("提示","未选中数据！");
		return;
	}
	$.messager.confirm("提示","确定删除选中数据吗?",function(r){
		if(!r) return;
		$m({
			ClassName:"web.DHCADVFile",
			MethodName:"deleteUrl",
			ID:rowData[0].ATTRID
		},function(ret){
			var tp=(ret==0?"删除成功!":"失败!"+ret)
			$.messager.alert("提示",tp);
			reloadImg(recordId);
			loadDatagrid(recordId);
			return;
		});
	})
	
}
