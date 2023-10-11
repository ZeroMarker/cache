
$(function(){
	var recordId =getParam("recordId");	
	//��ʼ���ϴ�����
  	initLoadify(recordId);
  	
  	initDatagrid(recordId);
  	
  	///������ʾʱ��Ĭ����ʾ����
	reloadImg(recordId);

	///��ʼ��ͼƬ��ʾ����
	initShowImg();
}) 
function initDatagrid(recordId){
	var columns=[[
    	{ field: 'ATTRID',align: 'center', title: 'ID',width:50,hidden:true},
    	{ field: 'ATTRDate',align: 'center', title: $g('�ϴ�����'),width:50},
    	{ field: 'ATTRTime',align: 'center', title: $g('�ϴ�ʱ��'),width:50},
    	{ field: 'ATTRUser',align: 'center', title: $g('�ϴ���'),width:50},
    	{ field: 'ATTRFileName',align: 'center', title: $g('�ļ�����'),width:100,formatter:ShowFile}
    
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
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
		rowStyler:function(index,rowData){
			
		},
		onLoadSuccess:function(data){
		
		}
	});		
}
//����  �ļ�
function ShowFile(value, rowData, rowIndex)
{   
	var FileUrl=rowData.FileUrl;         // �ļ�url
	var ATTRFileName=rowData.ATTRFileName; // �ļ���
	html = "<a href='#' onclick=\"LoadFile('"+FileUrl+"')\">"+ATTRFileName+"</a>";
    return html;
    
}
/// �ļ� �鿴
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
		buttonText:$g("�ϴ��ļ�"),
		fileObjName:"FileStream",
		formData:{"fileName":fileName},
		removeCompleted:true,
		'uploader': "dhcadv.upload.csp?dirname=\\dhcAdvEvt\\picture\\"+curdate+"\\", //'websys.file.utf8.csp',
	    'swf': '../scripts/dhcadvEvt/jqueryplugins/uploadify/uploadify.swf',
	    'fileTypeExts':'*',  // '*.gif; *.jpg; *.png; *.jpeg; *.doc; *.docx; *.pdf', �������ϴ�����
	    height:30,   
	    width:100,
	    auto:true,
	    'onUploadComplete' : function(file) {           //��ÿ���ļ��ϴ����ʱ���������۳ɹ����ǳ����������֪���ϴ��ɹ����ǳ�����ʹ�� onUploadSuccess��onUploadError �¼���
	       
	    },
	    'onUploadSuccess' : function(file, data, response) {
			var imgUrl = $.parseJSON(data).fileFullName;
			var ip = $.parseJSON(data).ip;
			var params = recordId+"^"+imgUrl+"^"+UserId;
			runClassMethod("web.DHCADVFile","saveUrl",{'Params':params},function(ret){
				if(ret==0){
					$.messager.alert($g("��ʾ"),$g("�������ݳɹ�")+"��");
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
	    'multi': true                                 //Ĭ��ֵtrue���Ƿ�������ļ��ϴ���
    });
}

///���¼���ͼƬ
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
		$.messager.alert($g("��ʾ"),$g("δѡ������")+"��");
		return;
	}
	$.messager.confirm($g("��ʾ"),$g("ȷ��ɾ��ѡ��������")+"��",function(r){
		if(!r) return;
		$m({
			ClassName:"web.DHCADVFile",
			MethodName:"deleteUrl",
			ID:rowData[0].ATTRID
		},function(ret){
			var tp=(ret==0?$g("ɾ���ɹ�"):$g("ʧ��")+ret)
			$.messager.alert($g("��ʾ"),tp);
			reloadImg(recordId);
			loadDatagrid(recordId);
			return;
		});
	})
	
}
