///Descript:   �����Ķ�
///Creator:    psc
///CreateDate: 2020-03-10
var UPLOADER;
var CURRENTID = "";
var fileStr = "";
var delIdStr = "";
var UpLoadFLAG = false;
var RetryFile = null;
$(function(){
	InitDocList();
	loadUploader();
	$.cm({	
		ClassName: "PHA.CPW.ViewDoc.Query", 
		MethodName: "GetDate"
		}, 
		function(AppPropData){
			$("#stDate").datebox("setValue", AppPropData.stDate);
			$("#endDate").datebox("setValue", AppPropData.endDate);
		}
	);
	$('#title,#keywords,#author').on('keypress', function(event) {
        if (event.keyCode == "13") {
	        queryList();
        }
	})
})
/**
 * ��ʼ���б�
 */
function InitDocList(){
	var opts = {
		toolbar: '#toolDocBar',
		url: LINK_CSP,
		queryParams: {
			ClassName: "PHA.CPW.ViewDoc.Query",	
			MethodName: "QueryDocList"
		},
		fit: true,
		rownumbers: true,
		toolbar:'#docListToolbar',
		headerCls: 'panel-header-gray',
		iconCls:'icon-book-green',
		border:true,
		title:'�����Ķ�',
		columns: [[
			{field:"rowId",			title:'rowId',		hidden:true},
			{field:'title',			title:'����',		width:200},
			{field:'author',		title:'����',		width:100},
			{field:'docDate',		title:'��������',	width:100},
			{field:'docs',			title:'�����ļ�',	width:220,
				styler: function (value,row,index){
					return 'color:blue;'
				}
			},
			{field:'itmIdstr',		title:'�ӱ�id��',	hidden:true},
			{field:'uploadUser',	title:'�ϴ���',		width:150},
			{field:'uploadUserDR',	title:'�ϴ���id',	hidden:true},
			{field:'upDateTime',	title:'�ϴ�ʱ��',	width:180},
			{field:'content',		title:'��Ҫ����',	width:300},
			{field:'keywords',		title:'�ؼ���',		width:100},
			{field:'references',	title:'�������',	width:100},
			{field:'remark',		title:'��ע',		width:100},
		]],
		pageSize: 50,  
		pageList: [50,100,300],  
	    singleSelect: true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination: true
	}
	PHA.Grid("docList", opts);
}

//��ѯ�ϴ����ļ�
function queryList(){
	var stDate = $('#stDate').datebox('getValue');   
	var endDate = $('#endDate').datebox('getValue'); 
	var author = $("#author").val();
	var title = $("#title").val();
	var keywords = $("#keywords").val();
	var params = stDate +"^"+ endDate +"^"+ author +"^"+ title +"^"+ keywords;
	$('#docList').datagrid("load", {
		ClassName: "PHA.CPW.ViewDoc.Query",	
		MethodName: "QueryDocList",
		params: params 
	})
}
//��ȡ��������
function getParams(){
	var title = $("#txtTitle").val();
	if(title == ""){
		PHA.Popover({ showType: "show", msg: "���ⲻ��Ϊ�գ�", type: 'alert' });
		return null;
	}
	if($('#tdUPLOAD').has("div").length === 0){
		PHA.Popover({
			showType: "show",
			msg: "�������ϴ�һ���ļ���",
			type: 'alert'
		});
		return;
	}
	var author = $("#txtAuthor").val();
	var remark = $("#txtRemark").val();
	var docDate = $('#docDate').datebox('getValue'); 
	var keywords = $("#txtKeywords").val();
	if(keywords == ""){
		PHA.Popover({ showType: "show", msg: "��������дһ���ؼ��֣�", type: 'alert' });
		return null;
	}
	var content = $("#content").val();
	if(content == ""){
		PHA.Popover({ showType: "show", msg: "��Ҫ���ݲ���Ϊ�գ�", type: 'alert' });
		return null;
	}
	var liters = $("#liters").val();
	var partUser = $("#partuser").val();
	return 	CURRENTID + "^"+ title +"^"+ author +"^"+ docDate +"^"+ keywords +"^"+ content +"^"+ liters +"^"+ remark +"^"+ gUserID;
}
//��������
function saveData(){
	var params = getParams();
	if(params === null){
		return;
	}
	var dataStr = params +"^"+ fileStr;
	$.post( LINK_CSP, {
			ClassName: "PHA.CPW.ViewDoc.OperTab",	
			MethodName: "SaveData",
			params: dataStr
		},function(ret){
			if(ret == 0){
				PHA.Popover({
					showType: "show",
					msg: "����ɹ���",
					type: 'success'
				});
				deleteById();
				fileStr = "";
				closeNewWin();
				queryList();
			}else{
				var fileArr = fileStr.split("$");
				var delFile = ""; 
				for(var i in fileArr){
					delFile = delFile == ""? fileArr[i].split("%")[1] : delFile + "$" + fileArr[i].split("%")[1];
				}
				$cm({	//�ϴ�ʧ�ܣ�ɾ�����ϴ��ļ�
					ClassName: "PHA.CPW.ViewDoc.OperTab",
					MethodName: "deleteDoc",
					fileNameStr: delFile,
					locId: gLocId,
					dataType: "text"
				},function(retData) {})
				PHA.Popover({
					showType: "show",
					msg: ret.split("^")[1],
					type: 'error'
				});
			}
		}
	)
}
/**
 * �򿪻Ự��
 */
function openNewWin(code){
	var opts = {
		title: code == "N"? "�½��������Ķ���" : "�������Ķ���",
		collapsible: false,
		border: false,
		modal: true,
		iconCls:'icon-w-paper',
		closed: "true",
		//width: 1190,
		//height: $(window).height() * 0.73,	
		onOpen: function(){
			if(code != "V"){
			    $("#winAdd input").attr("disabled",false);
		    	$("#winAdd textarea").attr("disabled",false);
		    	$("#docDate").combo('enable');
		    	$("#PHA_UPLOAD_BtnAdd").show();
			}else{
				$("#winAdd input").attr("disabled",true);
				$("#winAdd textarea").attr("disabled",true);
				$("#docDate").combo('disable');
				$("#PHA_UPLOAD_BtnAdd").hide();
			}
		    if(code == "N"){
				return;	
			}
			delIdStr = "";
			fileStr = "";
			seeDocInfo(code);
		},
		onBeforeClose: function(){
			$("#winAdd input").val("");
		    $("#winAdd textarea").val("");
		    $("#tdUPLOAD").empty();
		}
	}
	$('#winAdd').dialog(opts);
	$('#winAdd').dialog('open');
}
/**
 * �޸ļ�¼
 */
function modefiRecord(){
	var data = $('#docList').datagrid('getSelected');
	if(data == null){
		PHA.Popover({
			showType: "show",
			msg: "��ѡ��һ����Ҫ�޸ĵ�����",
			type: 'alert'
		});	
		return false;	
	}
	if(data.uploadUserDR !== session['LOGON.USERID']){
		PHA.Popover({
			showType: "show",
			msg: "��û�д�Ȩ�ޣ�",
			type: 'alert'
		});
		return;
	}
	CURRENTID = data.rowId;
	openNewWin("M");
}
/**
 * �رջỰ��
 */
function closeNewWin(){
	$('#winAdd').dialog('close');
	$("#tdUPLOAD div").remove();
}

/**
 * ���ؼ�¼����
 */
function seeDocInfo(code){
	var data = $('#docList').datagrid('getSelected');
	if(data == null){
		return false;	
	}
	$("#txtTitle").val(data.title);
	$("#txtAuthor").val(data.author);
	$("#txtRemark").val(data.remark || "");
	$('#docDate').datebox('setValue', data.docDate||""); 
	$("#txtKeywords").val(data.keywords || "");
	$("#content").val(data.content || "");
	$("#liters").val(data.references);
	
	var docsIdArr = data.itmIdstr.split(",");
	var docsArr = data.docs.split(",");
	if(code == "V"){
		icon = "icon-download";	
	}else{
		icon = "icon-no";	
	}
	for(var i = 0; i < docsArr.length; i++){
		var $listStr = $('<div class="pha-col"></div>');
		var downA = '<a class="hisui-linkbutton" data-options="plain:true,iconCls:\''+ icon +'\'" id='+ docsIdArr[i] +' name="dowFile"/></a>';
		$downA = $(downA).linkbutton({
			text: docsArr[i] 
		}); 
		$listStr.append($downA);
		$("#tdUPLOAD").append($listStr);
	}
	$("a[name='dowFile']").on('click', function(e){
		if(code == "V"){
			downloadDoc(this.id)
		}else{
			delIdStr = delIdStr === "" ? this.id : delIdStr +"^"+ delIdStr; 
			$(e.target).closest("div").remove();
		}
	})
}
/**
 * �޸ļ�¼ʱɾ���ļ�
 */
function deleteById(){
	if(delIdStr === ""){
		return;
	}		
	$cm({	
		ClassName: "PHA.CPW.ViewDoc.OperTab",
		MethodName: "deleteDocById",
		drItm: delIdStr,
		locId: gLocId,
		dataType: "text"
	},function(ret) {
		if(ret != "0"){
			PHA.Popover({
				showType: "show",
				msg: ret,
				type: 'error'
			});
			return false;
		}else{
			return true;
		}
		delIdStr = "";
	});	
}
/**
 * �½��ļ���¼
 */
function addNewRec(){
	CURRENTID = "";
	openNewWin("N");
}
/**
 * ����ļ���¼
 */
function viewDocRec(){
	var data = $('#docList').datagrid('getSelected');
	if(data == null){
		PHA.Popover({
			showType: "show",
			msg: "����ѡ��һ����Ҫ���������",
			type: 'alert'
		});
		return false;	
	}
	openNewWin("V");
}
/**
 * �����ļ���¼����������ļ������ض����
 */
function downloadDocRec(){
	var data = $('#docList').datagrid('getSelected');
	if(data == null){
		PHA.Popover({
			showType: "show",
			msg: "����ѡ��һ����Ҫ���ص�����",
			type: 'alert'
		});
		return false;	
	}
	var itmIdstr = data.itmIdstr;
	if(itmIdstr == ""){
		return;	
	}
	var itmIdArr = itmIdstr.split(",");
	for(var i = 0; i < itmIdArr.length; i++){
		downloadDoc(itmIdArr[i]);
	}
}
/**
 * �����ļ�
 */
function downloadDoc(drItmId){
	$cm({	
		ClassName: "PHA.CPW.ViewDoc.Query",
		MethodName: "GetDocPath",
		drItm: drItmId,
		locId: gLocId,
		dataType: "text"
	},function(ret) {
		if(ret != ""){
			var httpHref = window.location.href;
			var httpPre = 'http://'
			if (httpHref.indexOf('https')>=0){
				httpPre = 'https://'
			}
			var modelA = document.createElement('a');
			modelA.id = "docList";
			modelA.href = httpPre + ret;
			modelA.click();
			//websys_createWindow( httpPre + ret, '_blank');
		}else{
			PHA.Popover({
				showType: "show",
				msg: "�ļ�·��������",
				type: 'alert'
			});	
		}
	});	
}

/**
 * ɾ���ļ�
 */
function deleteDoc(){
	var data = $('#docList').datagrid('getSelected');
	if(data == null){
		PHA.Popover({
			showType: "show",
			msg: "����ѡ��һ����Ҫɾ��������",
			type: 'alert'
		});
		return false;	
	}
	var rowId = data.rowId;
	if(data.uploadUserDR !== session['LOGON.USERID']){
		PHA.Popover({
			showType: "show",
			msg: "��û�д�Ȩ�ޣ�",
			type: 'alert'
		});
		return;
	}
	if(!rowId){ return; }
	$.messager.confirm("ɾ��", "ȷ��ɾ����������?", function (r) {
		if (r) {
			$cm({	
				ClassName: "PHA.CPW.ViewDoc.OperTab",
				MethodName: "deleteData",
				drRowId: rowId,
				locId: gLocId,
				userId: session['LOGON.USERID'],
				dataType: "text"
			},function(ret) {
				if(ret == 0){
					PHA.Popover({
						showType: "show",
						msg: "ɾ���ɹ���",
						type: 'success'
					});
					queryList();
				}else{
					PHA.Popover({
						showType: "show",
						msg: ret,
						type: 'error'
					});
				}
			})
		} else {
			return;
		}
	});
}
/**
 * ����UPLOADER
 */
function loadUploader(){
	UPLOADER = WebUploader.create({
		auto: false,
	    swf: '../scripts/pha/plugins/webuploader/dist/Uploader.swf',
	    server: "pha.com.v1.upload.csp",
		pick: {
			id: "#PHA_UPLOAD_BtnAdd",
			innerHTML: '<a id="UPLOAD_BtnAdd" class="hisui-linkbutton" data-options="iconCls:\'icon-w-file\'" style="margin-left: -15px;">'+$g("����ļ�")+'</a>',
			multiple: true 
		},
		accept: {
		    title: 'Files',
		    extensions: '*',
		    mimeTypes: '*'
		},
	    chunked: true,
	    method: 'POST',
	    
	});
	$("#UPLOAD_BtnAdd").linkbutton();
	UPLOADER.on('fileQueued', function (file) {
		var $listStr = $('<div class="pha-col"></div>');
		var $a = $('<a class="hisui-linkbutton" data-options="plain:true,iconCls:\'icon-no\'" fileid='+ file.id +' name="btnDelFile"/></a>');
		$a.prependTo($listStr)
			.linkbutton({
				text: file.name
			})
			.on('click', function(e){
				$(e.target).closest("div").remove();
				UPLOADER.removeFile(file);
				UPLOADER.refresh();
			});
		$listStr.appendTo("#tdUPLOAD");
		UpLoadFLAG = true;
		UPLOADER.refresh();
	});
	UPLOADER.on('uploadSuccess', function(file, res){
		var realName,tmpStr;
		if(res._raw.split("^")[0] == 0){
			realName = res._raw.split("^")[1];
			tmpStr = file.name + "%" + realName;
			fileStr = fileStr==""? tmpStr : fileStr +"$"+ tmpStr;
			UPLOADER.removeFile(file);		//��ֹ�ظ��ϴ�
			UpLoadFLAG = false;
		}else if(res._raw.split("^")[0] < 0){
			$.messager.alert("��ʾ", res._raw.split("^")[1], "error");	//�˴��籨��ȴ�ʱ��ϳ������ô�����ʾ
			RetryFile = file;
		}
		UPLOADER.refresh();
	});
	UPLOADER.on('uploadFinished', function(){
		if(fileStr !== ""){
			saveData();
		}
		$.messager.progress("close");
		UPLOADER.refresh();
	});
	UPLOADER.on( 'uploadError', function(file) {
		PHA.Popover({
			showType: "show",
			msg: "�ļ��ϴ�ʧ�ܣ�",
			type: 'error'
		});
	});	
}

function SaveDataBtn(){
	var dataStr = getParams();
	if(!dataStr){
		return;	
	}
	if(UpLoadFLAG === true){
		$.messager.progress({
			title: "��ʾ",
			msg: '�����ϴ�',
			text: '�ϴ���....'
		});
		UPLOADER.options.formData = {
			sessionLocId: session['LOGON.CTLOCID'],
			uploadType: "Ftp"
		}
		if(RetryFile !== null){
			UPLOADER.retry(RetryFile);	
		}
		UPLOADER.upload();
	}else{
		saveData();
	}
}
