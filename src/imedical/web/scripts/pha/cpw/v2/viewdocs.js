///Descript:   文献阅读
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
 * 初始化列表
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
		title:'文献阅读',
		columns: [[
			{field:"rowId",			title:'rowId',		hidden:true},
			{field:'title',			title:'主题',		width:200},
			{field:'author',		title:'作者',		width:100},
			{field:'docDate',		title:'文献日期',	width:100},
			{field:'docs',			title:'包含文件',	width:220,
				styler: function (value,row,index){
					return 'color:blue;'
				}
			},
			{field:'itmIdstr',		title:'子表id串',	hidden:true},
			{field:'uploadUser',	title:'上传者',		width:150},
			{field:'uploadUserDR',	title:'上传者id',	hidden:true},
			{field:'upDateTime',	title:'上传时间',	width:180},
			{field:'content',		title:'主要内容',	width:300},
			{field:'keywords',		title:'关键字',		width:100},
			{field:'references',	title:'相关文献',	width:100},
			{field:'remark',		title:'备注',		width:100},
		]],
		pageSize: 50,  
		pageList: [50,100,300],  
	    singleSelect: true,
		loadMsg: '正在加载信息...',
		pagination: true
	}
	PHA.Grid("docList", opts);
}

//查询上传的文件
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
//获取界面数据
function getParams(){
	var title = $("#txtTitle").val();
	if(title == ""){
		PHA.Popover({ showType: "show", msg: "主题不能为空！", type: 'alert' });
		return null;
	}
	if($('#tdUPLOAD').has("div").length === 0){
		PHA.Popover({
			showType: "show",
			msg: "请至少上传一个文件！",
			type: 'alert'
		});
		return;
	}
	var author = $("#txtAuthor").val();
	var remark = $("#txtRemark").val();
	var docDate = $('#docDate').datebox('getValue'); 
	var keywords = $("#txtKeywords").val();
	if(keywords == ""){
		PHA.Popover({ showType: "show", msg: "请至少填写一个关键字！", type: 'alert' });
		return null;
	}
	var content = $("#content").val();
	if(content == ""){
		PHA.Popover({ showType: "show", msg: "主要内容不能为空！", type: 'alert' });
		return null;
	}
	var liters = $("#liters").val();
	var partUser = $("#partuser").val();
	return 	CURRENTID + "^"+ title +"^"+ author +"^"+ docDate +"^"+ keywords +"^"+ content +"^"+ liters +"^"+ remark +"^"+ gUserID;
}
//保存数据
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
					msg: "保存成功！",
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
				$cm({	//上传失败，删除已上传文件
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
 * 打开会话窗
 */
function openNewWin(code){
	var opts = {
		title: code == "N"? "新建【文献阅读】" : "【文献阅读】",
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
 * 修改记录
 */
function modefiRecord(){
	var data = $('#docList').datagrid('getSelected');
	if(data == null){
		PHA.Popover({
			showType: "show",
			msg: "请选择一条需要修改的数据",
			type: 'alert'
		});	
		return false;	
	}
	if(data.uploadUserDR !== session['LOGON.USERID']){
		PHA.Popover({
			showType: "show",
			msg: "您没有此权限！",
			type: 'alert'
		});
		return;
	}
	CURRENTID = data.rowId;
	openNewWin("M");
}
/**
 * 关闭会话窗
 */
function closeNewWin(){
	$('#winAdd').dialog('close');
	$("#tdUPLOAD div").remove();
}

/**
 * 加载记录数据
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
 * 修改记录时删除文件
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
 * 新建文件记录
 */
function addNewRec(){
	CURRENTID = "";
	openNewWin("N");
}
/**
 * 浏览文件记录
 */
function viewDocRec(){
	var data = $('#docList').datagrid('getSelected');
	if(data == null){
		PHA.Popover({
			showType: "show",
			msg: "请先选择一条需要浏览的数据",
			type: 'alert'
		});
		return false;	
	}
	openNewWin("V");
}
/**
 * 下载文件记录（包含多个文件就下载多个）
 */
function downloadDocRec(){
	var data = $('#docList').datagrid('getSelected');
	if(data == null){
		PHA.Popover({
			showType: "show",
			msg: "请先选择一条需要下载的数据",
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
 * 下载文件
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
				msg: "文件路径不存在",
				type: 'alert'
			});	
		}
	});	
}

/**
 * 删除文件
 */
function deleteDoc(){
	var data = $('#docList').datagrid('getSelected');
	if(data == null){
		PHA.Popover({
			showType: "show",
			msg: "请先选择一条需要删除的数据",
			type: 'alert'
		});
		return false;	
	}
	var rowId = data.rowId;
	if(data.uploadUserDR !== session['LOGON.USERID']){
		PHA.Popover({
			showType: "show",
			msg: "您没有此权限！",
			type: 'alert'
		});
		return;
	}
	if(!rowId){ return; }
	$.messager.confirm("删除", "确定删除该条数据?", function (r) {
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
						msg: "删除成功！",
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
 * 加载UPLOADER
 */
function loadUploader(){
	UPLOADER = WebUploader.create({
		auto: false,
	    swf: '../scripts/pha/plugins/webuploader/dist/Uploader.swf',
	    server: "pha.com.v1.upload.csp",
		pick: {
			id: "#PHA_UPLOAD_BtnAdd",
			innerHTML: '<a id="UPLOAD_BtnAdd" class="hisui-linkbutton" data-options="iconCls:\'icon-w-file\'" style="margin-left: -15px;">'+$g("添加文件")+'</a>',
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
			UPLOADER.removeFile(file);		//防止重复上传
			UpLoadFLAG = false;
		}else if(res._raw.split("^")[0] < 0){
			$.messager.alert("提示", res._raw.split("^")[1], "error");	//此处如报错等待时间较长所以用此种提示
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
			msg: "文件上传失败！",
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
			title: "提示",
			msg: '正在上传',
			text: '上传中....'
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
