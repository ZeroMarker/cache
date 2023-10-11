
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
    	{ field: 'ATTRDate',align: 'center', title: $g('上传日期'),width:50},
    	{ field: 'ATTRTime',align: 'center', title: $g('上传时间'),width:50},
    	{ field: 'ATTRUser',align: 'center', title: $g('上传人'),width:50},
    	{ field: 'ATTRFileName',align: 'center', title: $g('文件名称'),width:100,formatter:ShowFile}
    
 	]]; 
 	$("#uploadTable").datagrid({
		url:LINK_CSP+"?ClassName=web.DHCADVFile&MethodName=GetUploadList",
		toolbar:'#toolbar',
		queryParams:{
			RecordId:recordId,
			LgHospID:LgHospID
			
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
//操作  文件
function ShowFile(value, rowData, rowIndex)
{   
	var FileUrl=rowData.FileUrl;         // 文件url
	var ATTRFileName=rowData.ATTRFileName; // 文件名
	html = "<a href='#' onclick=\"LoadFile('"+FileUrl+"')\">"+ATTRFileName+"</a>";
    return html;
    
}
/// 文件 查看
function LoadFile(FileUrl){
	window.open(FileUrl)
}

function loadDatagrid(recordId){
	$("#uploadTable").datagrid("load",{
		RecordId:recordId,
		LgHospID:LgHospID
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
		buttonText:$g("上传文件"),
		fileObjName:"FileStream",
		formData:{"fileName":fileName},
		removeCompleted:true,
		'uploader': "dhcadv.upload.csp?dirname=\\dhcAdvEvt\\picture\\"+curdate+"\\", //'websys.file.utf8.csp',
	    'swf': '../scripts/dhcadvEvt/jqueryplugins/uploadify/uploadify.swf',
	    'fileTypeExts':'*',  // '*.gif; *.jpg; *.png; *.jpeg; *.doc; *.docx; *.pdf', 不控制上传类型
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
					$.messager.alert($g("提示"),$g("保存数据成功")+"！");
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

	runClassMethod("web.DHCADVFile","GetUrlByRedID",{"recordId":recordId,"LgHospID":LgHospID},function(data){
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
		$.messager.alert($g("提示"),$g("未选中数据")+"！");
		return;
	}
	$.messager.confirm($g("提示"),$g("确定删除选中数据吗")+"？",function(r){
		if(!r) return;
		$m({
			ClassName:"web.DHCADVFile",
			MethodName:"deleteUrl",
			ID:rowData[0].ATTRID
		},function(ret){
			var tp=(ret==0?$g("删除成功"):$g("失败")+ret)
			$.messager.alert($g("提示"),tp);
			reloadImg(recordId);
			loadDatagrid(recordId);
			return;
		});
	})
	
}
