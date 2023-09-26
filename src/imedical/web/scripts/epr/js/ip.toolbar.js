var mainpage = parent.parent;
var framRecord = mainpage.editPage;
var frameNav = mainpage.navPage;
var framResource = parent.frames["framResource"];
//屏蔽工具栏的右键(右键刷新会导致按钮状态不对)
document.oncontextmenu = function(){
	return false;
}

$(function(){
	///显示隐藏工具栏///////////////////////
	$('#toolbar').tabs({
		onSelect:function(title,index){
			if ($("#toolbar").height() <=36)
			{
				$("#toolbar").height("auto");
				parent.hideToolbar("show");
			}
		}
	});
	$(".fold").click(function(){
		if ($("#toolbar").height() <=35)
		{
			$("#toolbar").height("auto");
			parent.hideToolbar("show");
			$("#toolbar .fold").removeClass("down");
			$("#toolbar .fold").addClass("up");
		}
		else
		{
			$("#toolbar").height("35px");
			parent.hideToolbar("hide");
			$("#toolbar .fold").removeClass("up");
			$("#toolbar .fold").addClass("down");
		}
	});		
	
	//控制工具栏字体段落格式等按钮的显示和隐藏
	setToolBarFontView();

	//设置下拉字号框
	setFontSizeData();
	setToolBarStatus("disable");
	setOtherButtonPrivilege();
	initToolbar();
	if (isOpenEvent == "Y")
	{
		getEvent();
		window.setInterval("getEvent()",600000);
	}
});

function initToolbar()
{ 
	if (position == "card")
	{
		$('#toolbar').tabs('close','操作');
		$('#toolbar').tabs('close','编辑');
		$('#toolbar').tabs('close','表格');
		$('#toolbar').tabs('close','其他');
	}
	else
	{
		$('#divrtnrecord').css('display','none');
	}
}

//设置字体数据源
function setFontData()
{
	var json=[{"value":"宋体","name":"宋体"},
	          {"value":"仿宋","name":"仿宋"},
	          {"value":"楷体","name":"楷体"},
	          {"value":"黑体","name":"黑体"}
	         ]
	$('#font').combobox({
		data : json ,                       
		valueField:'value',                        
		textField:'name'
	});	
	$('#font').combobox('setValue',json[0].value)     
}
//设置字体大小数据源
function setFontSizeData()
{
	var json=[{"value":"12pt","name":"小四号","selected":"true"},
	          {"value":"10.5pt","name":"五号"},
		  {"value":"42pt","name":"初号"},
		  {"value":"36pt","name":"小初号"},
	          {"value":"31.5pt","name":"大一号"},
	          {"value":"28pt","name":"一号"},
	          {"value":"21pt","name":"二号"},
	          {"value":"18pt","name":"小二号"},
	          {"value":"16pt","name":"三号"},
	          {"value":"14pt","name":"四号"},
	          {"value":"9pt","name":"小五号"},
	          {"value":"8pt","name":"六号"},
	          {"value":"6.875pt","name":"小六号"},
	          {"value":"5.25pt","name":"七号"},
	          {"value":"4.5pt","name":"八号"},
	          {"value":"5pt","name":"5"},
	          {"value":"5.5pt","name":"5.5"},
	          {"value":"6.5pt","name":"6.5"},
	          {"value":"7.5pt","name":"7.5"},
	          {"value":"8.5pt","name":"8.5"},
	          {"value":"9.5pt","name":"9.5"},
	          {"value":"10pt","name":"10"},
	          {"value":"11pt","name":"11"}
	         ]
	var fontsize=$HUI.combobox("#fontsize",{
		valueField:"value",
		textField:"name",
		editable:true,
		selectOnNavigation:true,
		enterNullValueClear:false,
		panelHeight:'48',
		data:json
	})
	$('#fontsize').combobox({
		onSelect:function(record){
			strJson = {action:"FONT_SIZE",args:record.value};
			doExecute(strJson);
			}
		})	         		
}
//设置工具条状态
function setToolBarStatus(flag)
{
	setSaveStatus(flag);
	setPrintStatus(flag);
	setDeleteStatus(flag);
	setExportDocumnet(flag);
	setReference(flag);
	setApplyeditDocumnet(flag);
	//setUnLockStatus(flag);
	setRevisionStatus(flag);
}
//设置病历无关按钮状态
function setOtherButtonPrivilege()
{
	var toolbarPrivilege = getPrivilege("","ToolbarPrivilege",episodeID,patientID);
	if (toolbarPrivilege.canCommit == "0")
	{
		setCommitStatus('disable');
		$('#confirmRecordCompleted').attr('reason',toolbarPrivilege.cantCommitReason);
	}
	else
	{
		setCommitStatus('enable');
		$('#confirmRecordCompleted').attr('reason','');
	}
	initConfirmRecord();
	if (toolbarPrivilege.canTransfer == "0")
	{
		setTransferStatus('disable');
		$('#recordtransfer').attr('reason',toolbarPrivilege.cantTransferReason);
	}
	else
	{
		setTransferStatus('enable');
		$('#recordtransfer').attr('reason','');
	}
}

///设置操作权限
function setActionPrivilege(commandParam)
{
	if(!commandParam) return;
	if(commandParam.canSave == 1)
	{
		setSaveStatus('enable');
		$('#save').attr('reason','');
	}
	else
	{
		setSaveStatus('disable');
		$('#save').attr('reason',commandParam.cantSaveReason);
	}
	if(commandParam.canPrint == 1)
	{
		setPrintStatus('enable');
		$('#print').attr('reason','');
        $('#printOne').attr('reason','');
	}
	else
	{
		setPrintStatus('disable');
		$('#print').attr('reason',commandParam.cantPrintReason);
        $('#printOne').attr('reason',commandParam.cantPrintReason);
	}
	if(commandParam.canDelete == 1)
	{
		setDeleteStatus('enable');
		$('#delete').attr('reason','');
	}
	else
	{
		setDeleteStatus('disable');
		$('#delete').attr('reason',commandParam.cantDeleteReason);
	}
	
	if(commandParam.canReference == 1)
	{
		setReference('enable');
		$('#reference').attr('reason','');
	}
	else
	{
		setReference('disable');
		$('#reference').attr('reason',commandParam.cantReferenceReason);
	}
	if(commandParam.canExport == 1)
	{
		setExportDocumnet('enable');
		$('#export').attr('reason','');
	}
	else
	{
		setExportDocumnet('disable');
		$('#export').attr('reason',commandParam.cantExportReason);
	}	
	if(commandParam.canApplyEdit == 1)
	{
		setApplyeditDocumnet('enable');
		$('#applyedit').attr('reason','');
	}
	else
	{
		setApplyeditDocumnet('disable');
		$('#applyedit').attr('reason',commandParam.cantApplyEditReason);
	}
	if(commandParam.canUnLock == 1)
	{
		setUnLockStatus('enable');
		$('#unLock').attr('reason','');
	}
	else
	{
		setUnLockStatus('disable');
		$('#unLock').attr('reason',commandParam.cantUnLockReason);
	}
}

///Desc:是否可编辑
function setSaveStatus(flag)
{
	$('#font').combobox(flag);
	$('#fontsize').combobox(flag);
	$('#bold').linkbutton(flag);
	$('#italic').linkbutton(flag);
	$('#underline').linkbutton(flag);
	$('#strike').linkbutton(flag);
	$('#super').linkbutton(flag);
	$('#sub').linkbutton(flag);
	$('#alignjustify').linkbutton(flag);
	$('#alignleft').linkbutton(flag);
	$('#aligncenter').linkbutton(flag);
	$('#alignright').linkbutton(flag);
	$('#indent').linkbutton(flag);
	$('#unindent').linkbutton(flag);
	$('#cut').linkbutton(flag);
	$('#paste').linkbutton(flag);
	$('#undo').linkbutton(flag);
	$('#redo').linkbutton(flag);	
	$('#save').linkbutton(flag);
	$('#binddatareload').linkbutton(flag);
	$('#spechars').linkbutton(flag);
	$('#clipboard').linkbutton(flag);
	$('#fontcolor').linkbutton(flag);
	$('#recording').linkbutton(flag);
	$('#silverLocation').linkbutton(flag);
	$('#image').linkbutton(flag);
	$('#tooth').linkbutton(flag);
	
	$('#insertTable').linkbutton(flag);
	$('#deleteTable').linkbutton(flag);
	$('#insertRow').linkbutton(flag);
	$('#insertCol').linkbutton(flag);
	$('#deleteRow').linkbutton(flag);
	$('#deleteCol').linkbutton(flag);
	$('#splitCells').linkbutton(flag);
	//根据插件类型 隐藏或显示对应的按钮
	if(framRecord.pluginType == "GRID"){
		$("#insertTable").css('display','none');
		$("#deleteTable").css('display','none');
		$("#insertRow").css('display','none');
		$("#insertCol").css('display','none');
		$("#deleteRow").css('display','none');
		$("#deleteCol").css('display','none');
		$("#splitCells").css('display','none');
	}else{
		$("#insertTable").css('display','block');
		$("#deleteTable").css('display','block');
		$("#insertRow").css('display','block');
		$("#insertCol").css('display','block');
		$("#deleteRow").css('display','block');
		$("#deleteCol").css('display','block');
		$("#splitCells").css('display','block');
	}
}
///Desc:是否可打印
function setPrintStatus(flag)
{
	$('#print').linkbutton(flag);
	$('#printView').linkbutton(flag);
	$('#autoprint').linkbutton(flag);
    $('#printOne').linkbutton(flag);
}
///Desc:是否可删除
function setDeleteStatus(flag)
{
	$('#delete').linkbutton(flag);
}
///书写对比
function setReference(flag)
{
	$('#reference').linkbutton(flag);
}
///是否可导出
function setExportDocumnet(flag)
{
	$('#export').linkbutton(flag);	
}

///Desc:是否可送病案室
function setCommitStatus(flag)
{
	$('#confirmRecordCompleted').linkbutton(flag);
}

//设置病历转移状态(原来在代码中的只有主管医师可用放到脚本中处理)
function setTransferStatus(flag)
{
	$('#recordtransfer').linkbutton(flag);
}

//设置查看留痕按钮状态
function setRevisionStatus(flag)
{
	$('#revision').linkbutton(flag);
}



//文档对照
document.getElementById("reference").onclick = function(){
	var instanceID= "";
    if(framRecord.param != "")
	{
		 instanceID = framRecord.param.id;
	}
	var url= "emr.ip.tool.reference.csp?EpisodeID="+episodeID+"&InstanceID="+ instanceID;
	if(setRecordReferencePresentation == "Y"){
	    var reference = "<iframe id='framReference'  frameborder='0' src='"+url+"' style='width:100%; height:100%;scrolling:no;'></iframe>" ;
	    framRecord.addTabs("reference","病历参考",reference,true); 
	}
	else
	{
		var xpwidth=window.screen.width-10;
		var xpheight=window.screen.height-75;
		window.open(url,'reference','width='+xpwidth+',height='+xpheight+',top=0,left=0'); 
	}
};

//添加收藏
document.getElementById("favoritesPlus").onclick = function(){
	//病历操作记录需要数据 start
	var categoryId = "";
	var templateId = "";
	if (framRecord.param != "")
	{
		categoryId = framRecord.param.categoryId;
		templateId = framRecord.param.templateId;
	}
	//病历操作记录需要数据 end
	//记录用户(收藏病历)行为
    AddActionLog(userID,userLocID,"FavoritesAdd",""); 
    var arr = {"userId":userID,"userLocId":userLocID};
	var tempFrame = "<iframe id='iframeFavAdd' scrolling='auto' frameborder='0' src='emr.fav.add.csp?EpisodeID="+episodeID+"&InstanceID="+ framRecord.param.id+"&categoryId="+categoryId+"&templateId="+templateId+ "' style='width:450px; height:450px; display:block;'></iframe>";
	parent.createModalDialog("dialogFavAdd","特殊字符","454","490","iframeFavAdd",tempFrame,favAddCallback,arr);
};
//添加收藏回调记录日志
function favAddCallback(returnValue,arr)
{
	var UserID = arr.userId;
	var UserLocID = arr.userLocId;
    //记录用户(收藏病历.取消)行为
    if (returnValue == "FavoritesAdd.Cancel")
    AddActionLog(UserID,UserLocID,"FavoritesAdd.Cancel",""); 
    else if (returnValue == "FavoritesAdd.Commit")
    AddActionLog(UserID,UserLocID,"FavoritesAdd.Commit","");
}

//病历收藏夹
document.getElementById("favorites").onclick = function(){
	
	//记录用户(整理收藏)行为
    AddActionLog(userID,userLocID,"FavoritesView",""); 
	setFavoritesLog();
	var xpwidth=window.screen.width-600;
	var xpheight=window.screen.height-420;
	var arr = {"userId":userID,"userLocId":userLocID};
	//window.showModalDialog("emr.fav.favorite.csp","","dialogHeight:"+xpheight+"px ;dialogWidth:"+xpwidth+"px ;resizable:yes;center:yes;status:no");
	var tempFrame = "<iframe id='iframeFavorite' scrolling='auto' frameborder='0' src='emr.fav.favorite.csp' style='width:"+xpwidth+"px; height:"+xpheight+"px; display:block;'></iframe>";
	parent.createModalDialog("dialogFavorite","收藏夹",xpwidth+4,xpheight+40,"iframeFavorite",tempFrame,favoriteCallback,arr);
};
//收藏夹回调记录日志
function favoriteCallback(returnValue,arr)
{
	var userId = arr.userId;
	var userLocId = arr.userLocId;
    //记录用户(整理收藏.页面关闭)行为
    AddActionLog(userId,userLocId,"FavoritesView.Page.Close","");
}
//手工解锁
document.getElementById("unLock").onclick = function(){
	if (!framRecord) return;
	framRecord.btnUnLock();
};

//字体
$('#font').combobox({
	onSelect: function (record) {
		strJson = {action:"FONT_FAMILY",args:record.value};
		doExecute(strJson);		
	}
});

//字号
$('#fontSize').combobox({
	onSelect: function(record){
		strJson = {action:"FONT_SIZE",args:record.value};
		doExecute(strJson);		
	}
});

//设置字体颜色   start
$("#fontcolor").colorpicker({
});
//打开/关闭颜色选择器
document.getElementById("fontcolor").onclick = function(){
	if (colorpanelshow == "1")
	{
		$("#colorpanel").hide();
		colorpanelshow = "0";
	}
	else if (colorpanelshow == "0")
	{
		$("#colorpanel").show();
		colorpanelshow = "1";
	}
};
//将字体颜色传给编辑器
function setFontColor(color){
	strJson = {action:"FONT_COLOR",args:color}; 
 	doExecute(strJson);	
};
//设置字体颜色   end

//设置粗体
document.getElementById("bold").onclick = function(){
 	strJson = {action:"BOLD",args:{path:""}}; 
 	doExecute(strJson);	
};

//设置斜体
document.getElementById("italic").onclick = function(){
 	strJson = {action:"ITALIC",args:""}; 
 	doExecute(strJson);	
};

//设置下划线
document.getElementById("underline").onclick = function(){
 	strJson = {action:"UNDER_LINE",args:""};
 	doExecute(strJson);	
};

//删除线
document.getElementById("strike").onclick = function(){
 	strJson = {action:"STRIKE",args:""};
 	doExecute(strJson);	
};

//设置上标
document.getElementById("super").onclick = function(){
 	strJson = {action:"SUPER",args:""};
 	doExecute(strJson);	
};

//设置下标
document.getElementById("sub").onclick = function(){
 	strJson = {action:"SUB",args:""};
 	doExecute(strJson);	
};

//设置两端对齐
document.getElementById("alignjustify").onclick = function(){
 	strJson = {action:"ALIGN_JUSTIFY",args:""}; 
 	doExecute(strJson);	
};

//设置左对齐
document.getElementById("alignleft").onclick = function(){
 	strJson = {action:"ALIGN_LEFT",args:""}; 
 	doExecute(strJson);	
};

//设置居中对齐
document.getElementById("aligncenter").onclick = function(){
 	strJson = {action:"ALIGN_CENTER",args:""}; 
 	doExecute(strJson);	
};

//设置右对齐
document.getElementById("alignright").onclick = function(){
 	strJson = {action:"ALIGN_RIGHT",args:""}; 
 	doExecute(strJson);	
};

//设置缩进
document.getElementById("indent").onclick = function(){
 	strJson = {action:"INDENT",args:""};
 	doExecute(strJson);	
};

//设置反缩进
document.getElementById("unindent").onclick = function(){
 	strJson = {action:"UNINDENT",args:""};  
 	doExecute(strJson);	
};

//剪切
document.getElementById("cut").onclick = function(){
 	strJson = {action:"CUT",args:""};  
 	doExecute(strJson);	
};

//复制
document.getElementById("copy").onclick = function(){
 	strJson = {action:"COPY",args:""};  
 	doExecute(strJson);	
};

//粘贴
document.getElementById("paste").onclick = function(){
 	strJson = {action:"PASTE",args:""};  
 	doExecute(strJson);	
};

//撤销
document.getElementById("undo").onclick = function(){
 	strJson = {action:"UNDO",args:""}; 
 	doExecute(strJson);	
};

//重做
document.getElementById("redo").onclick = function(){
 	strJson = {action:"REDO",args:""}; 
 	doExecute(strJson);	
};

//特殊字符
document.getElementById("spechars").onclick = function(){
	if (!framRecord) return;
	var tempFrame = "<iframe id='iframeSpechars' scrolling='auto' frameborder='0' src='emr.ip.tool.spechars.csp' style='width:510px; height:428px; display:block;'></iframe>";
	parent.createModalDialog("dialogSpechars","特殊字符","514","468","iframeSpechars",tempFrame,framRecord.insertStyleText,"");
};

//牙位图
document.getElementById("tooth").onclick = function(){
	
	if (!framRecord) return;
	var tempFrame = "<iframe id='iframeTooth' scrolling='auto' frameborder='0' src='emr.ip.tool.tooth.csp' style='width:1040px; height:438px; display:block;'></iframe>";
	parent.createModalDialog("dialogTooth","牙位图","1060","475","iframeTooth",tempFrame,toothCallBack,"");
};
//牙位图回调
function toothCallBack(returnValue,arr)
{
	if (returnValue != "") framRecord.insertTooth("new",returnValue); 
}

//保存
document.getElementById("save").onclick = function(){
	if (!framRecord) return;	
	if (!framRecord) return;						
	framRecord.saveDocument(); 
};

//打印
document.getElementById("print").onclick = function(){
	if (!framRecord) return;						
	framRecord.printDocument();	
};

//自动续打
document.getElementById("autoprint").onclick = function(){
	if (!framRecord) return;
	framRecord.autoPrintDocument();	
}

//单独打印
document.getElementById("printOne").onclick = function(){
	if (!framRecord) return;						
	framRecord.printOneDocument();	
};

//删除文档
document.getElementById("delete").onclick = function(){
	if (!framRecord) return;						
	framRecord.deleteDocument();
}

//刷新绑定数据
document.getElementById("binddatareload").onclick = function(){
	if (!framRecord) return;
	//获取当前活动文档的instanceID
	var instanceID = framRecord.getDocumentContext().InstanceID; 						
	framRecord.refreshReferenceData(instanceID,"false"); 
}

//导出病历
document.getElementById("export").onclick = function(){
	if (!framRecord) return;						
	framRecord.exportDocument(); 
}

//剪贴板
document.getElementById("clipboard").onclick = function(){
	var clipboard = "<iframe id='framclipboard' src='emr.ip.tool.clipboard.csp' style='width:100%; height:100%;border:0;scrolling:no;margin:0px;padding:0;overflow:hidden;'></iframe>"				
	framRecord.addTabs("clipboard","剪贴板",clipboard,true); 

};

//语音录入病历
document.getElementById("recording").onclick = function(){
	if (!framRecord) return;
	if ($("#recording").attr("flag") && $("#recording").attr("flag")=="false")	
	{
		$("#recording").attr("flag",true);
		$("#recording").attr("title","开启语音录入");
		framRecord.setASRVoiceStatus(false,productName);
	}
	else
	{
		$("#recording").attr("flag",false);
		$("#recording").attr("title","关闭语音录入");
		framRecord.setASRVoiceStatus(true,productName);
	}	 
}

//打开病历转移窗口
function doRecordTransfer()
{
	var tempFrame = "<iframe id='iframeRecordTransfer' scrolling='auto' frameborder='0' src='emr.ip.recordtransfer.csp?EpisodeID="+episodeID+ "' style='width:352px; height:470px; display:block;'></iframe>";
	parent.createModalDialog("dialogRecordTransfer","病历转移","354","510","iframeRecordTransfer",tempFrame,"","");
}

//执行命令
function doExecute(strJson)
{
	if (!framRecord) return;						
	framRecord.cmdDoExecute(strJson); 	
}

//控制工具栏字体段落格式等按钮的显示和隐藏
function setToolBarFontView()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSysOption",
			"Method":"GetOptionValueByName2",
			"p1":"DisableFont",
			"p2":""
		},
		success: function(d){
			if (d == "") return;
			strs = d.split(","); //字符分割
			for (i=0;i<strs.length;i++ )
			{
				if (document.getElementById(strs[i]) != null)
				{
					if (strs[i] == "font")
					{
						document.getElementById("fontSpan").style.display="none";
					}
					else
					{
						document.getElementById(strs[i]).style.display="none";
					}
				}	
			} 	
		},
		error: function(d){alert("error");}
	});
}

//定位到上次书写位置
document.getElementById("silverLocation").onclick = function(){
	strJson = {"action":"GOTO_LAST_MODIFY_POSITION","args":""}; 
 	doExecute(strJson);	
}

//打印预览
document.getElementById("printView").onclick = function(){
	if (!framRecord) return;
	if (framRecord.getModifyStatus("").Modified == "True")
	{
		var text = '文档正在编辑，请保存后开启预览，是否保存？';
		mainpage.$.messager.confirm("操作提示", text, function (data) { 
			if(data) {
				framRecord.saveDocument();
			}else {
				return;
			}
		});
		return "";
	} 
	if ($("#printView").attr("flag") && $("#printView").attr("flag")=="false")	
	{
		$("#printView").attr("flag",true);
		$("#printView").attr("title","开启打印预览");
		$("#printView span .l-btn-text").text("预览");
		framRecord.setPreviewDocumentState(false);	
		//$("#printView").css("background","url('../scripts/emr/image/toolbar/printView.png') no-repeat center center");
	}
	else
	{
		$("#printView").attr("flag",false);
		$("#printView").attr("title","关闭打印预览");
		$("#printView span .l-btn-text").text("关闭预览");
		framRecord.setPreviewDocumentState(true);
		//$("#printView").css("background","url('../scripts/emr/image/toolbar/printViewClose.jpg') no-repeat center center");	
	}	
	//取文档信息
	var documentContext = framRecord.getDocumentContext("");
	//设置当前文档操作权限
	framRecord.setPrivelege(documentContext);
}

///确认病历全部完成/////////////////////////////////////////////////////////////
//初始化送病案室状态
function initConfirmRecord()
{
	$("#confirmRecordCompleted").attr("flag",true);
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmRecordStatus",
					"Method":"GetAdmRecordStatus",			
					"p1":episodeID
				},
			success: function (data){
				if (data == "1")
				{ 
					$("#confirmRecordCompleted").attr("flag",false);
					if (isEnableRevokeComplete == "N")
					{
						$("#confirmRecordCompleted").attr("title","已送病案室");
						$("#confirmRecordCompleted span .l-btn-text").text("已送病案室");
						$("#confirmRecordCompleted").css("width","105px");
					}
					else
					{
						$("#confirmRecordCompleted").attr("title","撤销送病案室");
						$("#confirmRecordCompleted span .l-btn-text").text("撤销送病案室");
						$("#confirmRecordCompleted").css("width","115px");
					}
					$("#confirmRecordCompleted").css("line-height","2");
					$("#confirmRecordCompleted").css("text-align","center");
				}else {
					$("#confirmRecordCompleted").attr("title","确认病历全部完成");
					$("#confirmRecordCompleted span .l-btn-text").text("送病案室");
					$("#confirmRecordCompleted").css("width","90px");
					$("#confirmRecordCompleted").css("line-height","2");
					$("#confirmRecordCompleted").css("text-align","center");
				}
			}
		});	
}

//送病案室点击事件
function changeRecordFinishedStatus()
{
	if ($("#confirmRecordCompleted").attr("flag") && $("#confirmRecordCompleted").attr("flag")=="false")	
	{
		if (isEnableRevokeComplete == "N") return;
		var tipMsg = "是否确认撤销送病案室?";
		mainpage.$.messager.confirm("提示",tipMsg, function (r) {
			if (!r) return;
			revokeConfirmRecord();
		});
	}
	else
	{
		confirmRecordFinished();
	}	
}

//确认病历全部完成
function confirmRecordFinished()
{
	//有修改必须保存后，才可确认病历全部完成
	if (framRecord && framRecord.length >0)
	{
		var result = framRecord.savePrompt("");
		if ((result != "")&&(result != "save")) return;
	}
	
	var qualityResult = qualityConfirmDocument();
	if (qualityResult) return; 
	
	var tipMsg = "确认病历全部完成后将无法修改病历，是否确认提交?";
	mainpage.$.messager.confirm("提示",tipMsg, function (r) {
		if (!r) return;
		submitRemarks();
		//获取确认病历全部完成是否成功
		var completeResult = getCompleteResult();
		if (completeResult == true)
		{
			parent.$.messager.alert("提示信息", "确认病历全部完成成功", 'info');
		}
		else 
		{
			parent.$.messager.alert("提示信息", "确认病历全部完成失败");
			return;
		}
		parent.window.location.reload();
	});
}

//确认病历全部完成
function getCompleteResult()
{
	var result = false;
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmRecordStatus",
					"Method":"ConfirmRecordFinished",			
					"p1":episodeID,
					"p2":userID
				},
			success: function (data){
				if (data == "1") 
				{
					result = true;
					$("#confirmRecordCompleted").attr("flag",false);
					if (isEnableRevokeComplete == "N")
					{
						$("#confirmRecordCompleted").attr("title","已送病案室");
						$("#confirmRecordCompleted span .l-btn-text").text("已送病案室");
						$("#confirmRecordCompleted").css("width","105px");
					}
					else
					{
						$("#confirmRecordCompleted").attr("title","撤销送病案室");
						$("#confirmRecordCompleted span .l-btn-text").text("撤销送病案室");
						$("#confirmRecordCompleted").css("width","115px");
					}
					$("#confirmRecordCompleted").css("line-height","2");
					$("#confirmRecordCompleted").css("text-align","center");
				}
			}
		});	
	return result;
}


//撤销病历送病案室状态
function revokeConfirmRecord()
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmRecordStatus",
					"Method":"RevokeConfirmRecord",			
					"p1":episodeID,
					"p2":userID
				},
			success: function (data){
				var result = data;
				if (result == "1") 
				{
					$("#confirmRecordCompleted").attr("flag",true);
					$("#confirmRecordCompleted").attr("title","确认病历全部完成");
					$("#confirmRecordCompleted span .l-btn-text").text("送病案室");
					$("#confirmRecordCompleted").css("width","90px");
					$("#confirmRecordCompleted").css("line-height","2");
					$("#confirmRecordCompleted").css("text-align","center");
					parent.$.messager.alert("提示信息", "撤销送病案室成功", 'info');
					parent.window.location.reload();
				}
				else
				{
					if (result.substring(2)!= "")
					{
						parent.$.messager.alert("提示信息", result.substring(2));	
					}
					else
					{
						parent.$.messager.alert("提示信息", "病案归档撤销失败");
					}
				}
			}
		});	
}

function qualityConfirmDocument()
{
	var result =  false;
	//病历质控
	var eventType = "ConfirmRecord^" + ssgroupID + "^" + userLocID; 
	var qualityData = qualityCheck(episodeID,"","",eventType)
	if (qualityData.total > 0)
	{
		var controlType = qualityData.ControlType;
		var quality = "<iframe id='framclipboard' src='dhc.epr.quality.runtimequalitylist.csp?EpisodeID="+episodeID+"&EventType="+eventType+"&TemplateID=&key="+qualityData.key+"' style='width:98%; height:98%;border:0;margin:0px;padding:5px;overflow:hidden;' scrolling=no></iframe>"			
		framRecord.addTabs("quality","质控提示",quality,true); 
		if (controlType == "0") 
		{
			result = true;
			mainpage.$("#nav").css("display","none");
			mainpage.$("#editor").css("display","block");
			return result;
		}
	}
	return result;
}

//质控
function qualityCheck(episodeId,instanceId,templateId,eventType)
{
	var result = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"Stream",
					"Class":"EMRservice.HISInterface.QualityInterface",
					"Method":"QualityInterfaceCheck",			
					"p1":episodeId,
					"p2":eventType,
					"p3":templateId,
					"p4":instanceId
				},
			success: function(d) {
					if (d != "")
					{
						result = jQuery.parseJSON(d);
					}
			},
			error : function(d) { alert("GetSummery error");}
		});	
	return result;	
}

//打开图库窗口
document.getElementById("image").onclick = function(){
	if (!framRecord) return;
	var xpwidth = window.screen.width-400;
	var xpheight = window.screen.height-400;
	//showDialogImage("图库",xpwidth+4,xpheight+40,"<iframe id='iframeImage' scrolling='auto' frameborder='0' src='emr.ip.tool.image.csp' style='width:"+xpwidth+"px; height:"+xpheight+"px; display:block;'></iframe>")
	var tempFrame = "<iframe id='iframeImage' scrolling='auto' frameborder='0' src='emr.ip.tool.image.csp' style='width:"+xpwidth+"px; height:"+xpheight+"px; display:block;'></iframe>";
	parent.createModalDialog("dialogImage","图库",xpwidth+4,xpheight+40,"iframeImage",tempFrame,imageCallBack,"");
}
//图库回调
function imageCallBack(returnValue,arr)
{
	if (returnValue) framRecord.insertIMG(returnValue); 
}

///事件助手消息
function getEvent()
{
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.eventData.cls",
		async: true,
		data: {
			"EpisodeID": episodeID,
			"Action": "GetMessage"
		},
		success: function(d) {
			if (d != "")
			{
				if(moveText == "Y")
				{
					var d = eval(d);
					var text = '<marquee onmouseover="this.stop()" onmouseout="this.start()" scrollamount="2">';
					for (var i=0;i<d.length;i++)
					{
						text = text + '<span class="message"  id='+d[i].EventType+'><img src="../scripts/emr/image/icon/'+d[i].EventType+'.png"/>';	
						text = text + '<div class="helper">'+d[i].PromptMessage+'</div></span>';
						
					}
					text = text + '</marquee>';
					$("#event").html(text);		
				}
				else
				{
					var d = eval(d);
					var text = '<div class="message">';
					for (var i=0;i<d.length;i++)
					{
						text = text + '<span class="message" id="'+d[i].EventType+'"><img src="../scripts/emr/image/icon/'+d[i].EventType+'.png"/>';	
						text = text + '<div class="helper">'+d[i].PromptMessage+'</div></span>';
					}
					text = text + '</div>';
					$("#event").html(text);	
				}
			}
		},
		error : function(d) { alert(" error");}
	});
}
function sendCopyCutData(content)
{
	if (!window.frames["framclipboard"]) return;
	window.frames["framclipboard"].setContent(content);
}

$("#event").on('click',".message",function(){
	var eventType = $(this)[0].id;

	var returnValues = "";
	if (eventType!="")
	{
		var tempFrame = "<iframe id='iframeEvent' scrolling='auto' frameborder='0' src='emr.ip.event.csp?EpisodeID="+episodeID+"&EventType="+eventType+"' style='width:594px; height:480px; display:block;'></iframe>";
		parent.createModalDialog("dialogEvent","事件弹窗","614","520","iframeEvent",tempFrame,eventCallBack,"");
	}
});
//事件回调函数
function eventCallBack(returnValue,arr)
{
	if (typeof(returnValue) != "undefined" && returnValue != "")
	{
		var values = eval("("+returnValue+")");
		if (values.length <=0) return;
		mainpage.operateRecord(values);
	}
	getEvent();
}

///是否可申请自动审批
function setApplyeditDocumnet(flag)
{
	$('#applyedit').linkbutton(flag);	
}

//申请自动审批
function applyeditOnclick()
{
	if (!framRecord) return;
	framRecord.applyedit();
}

///Desc:是否可手工解锁
function setUnLockStatus(flag)
{
	$('#unLock').linkbutton(flag);
}

//插入表格
document.getElementById("insertTable").onclick = function(){
 	strJson = {action:"TOOL_BAR_INSERT_TABLE",args:{path:""}}; 
 	doExecute(strJson);	
};

//删除表格
document.getElementById("deleteTable").onclick = function(){
 	strJson = {action:"TOOL_BAR_DELETE_TABLE",args:{path:""}}; 
 	doExecute(strJson);	
};


//插入行
document.getElementById("insertRow").onclick = function(){
 	strJson = {action:"TOOL_BAR_INSERT_ROW",args:{path:""}}; 
 	doExecute(strJson);	
};

//删除行
document.getElementById("deleteRow").onclick = function(){
 	strJson = {action:"TOOL_BAR_DELETE_ROW",args:{path:""}}; 
 	doExecute(strJson);	
};

//插入列
document.getElementById("insertCol").onclick = function(){
 	strJson = {action:"TOOL_BAR_INSERT_COL",args:{path:""}}; 
 	doExecute(strJson);	
};

//删除列
document.getElementById("deleteCol").onclick = function(){
 	strJson = {action:"TOOL_BAR_DELETE_COL",args:{path:""}}; 
 	doExecute(strJson);	
};

//拆分单元格
document.getElementById("splitCells").onclick = function(){
 	strJson = {action:"TOOL_BAR_SPLIT_CELLS",args:{path:""}}; 
 	doExecute(strJson);	
};

//开启关闭留痕
document.getElementById("revision").onclick = function(){
	setRevision();	
};


//设置书写状态
function setNoteState(status)
{
	strJson = {action:"SET_NOTE_STATE",args:status};
	doExecute(strJson);	
}

//回到导航
function getNav()
{
	mainpage.gotoNav();
}

///回到病历
function getEdit()
{
	mainpage.gotoEdit();
}

///初始化工栏状态
function initToolbarStatus()
{
	//初始化语音录入
	$("#recording").attr("flag",true);
	$("#recording").attr("title","开启语音录入");
	
	//初始化打印预览
	$("#printView").attr("flag",true);
	$("#printView").attr("title","开启打印预览");
    $("#printView span .l-btn-text").text("预览");
		
    //初始化留痕信息
    initRevision();
	if (!framRecord.plugin()) return;
	framRecord.setPreviewDocumentState(false);
	framRecord.setASRVoiceStatus(false,productName);
}

///初始化留痕信息
function initRevision()
{
	setRevisionStatus('enable');
	if (!framRecord) return;
	var status = false;
	var text = "显示留痕";
    var icon = "icon-big-open-eye";
	var value = getUserConfigData(userID,userLocID,"Revision");
	$("#revision span .l-btn-icon").removeClass("icon-big-close-eye");
    if (value == "TRUE")
	{
		text = "隐藏留痕";
		status = true; 
		icon = "icon-big-close-eye";
		$("#revision span .l-btn-icon").removeClass("icon-big-open-eye");		
	}
 	$("#revision span .l-btn-text").text(text);
 	$("#revision span .l-btn-icon").addClass(icon);
 	framRecord.viewRevision(status);	
}

///显示关闭留痕
function setRevision()
{
	if (!framRecord) return;
	var value = "FALSE";
	var status = false;
	var text = "显示留痕";
	var icon = "icon-big-open-eye";
	$("#revision span .l-btn-icon").removeClass("icon-big-close-eye");
 	if ($("#revision span .l-btn-text").text() != "隐藏留痕")
	{
		text = "隐藏留痕";
		status = true;
		value = "TRUE";
		icon = "icon-big-close-eye";
		$("#revision span .l-btn-icon").removeClass("icon-big-open-eye");
	}
 	$("#revision span .l-btn-text").text(text);
 	$("#revision span .l-btn-icon").addClass(icon);
 	framRecord.viewRevision(status);	
 	//用户个人设置开启关闭留痕
 	if (isSaveUserConfig == "Y"){
	 	addUserConfigData(userID,userLocID,"Revision",value) 	
	}
}

//打开申请权限窗口
document.getElementById("authRequest").onclick = function(){
	var tempFrame = "<iframe id='iframeRequest' scrolling='auto' frameborder='0' src='emr.auth.request.csp?EpisodeID="+ episodeID + "&PatientID=" + patientID + "' style='width:1100px; height:575px; display:block;'></iframe>";
	parent.createModalDialog("authRequest","申请授权","1104","615","iframeRequest",tempFrame,"","");
}

function showDiaglog(title,width,height,content)
{
	mainpage.showDiaglog(title,width,height,content);
}
var messageObj="";
var titleText ="";
function topCenter(obj){
	if (!framRecord) return;
	if ((typeof($('#'+ obj.id).attr('reason')) == "undefined")||($('#'+ obj.id).attr('reason')== "")) return;
	if (typeof(obj) == "undefined") return;
	if (messageObj!=""){
		window.document.body.removeChild(messageObj);
		messageObj="";
	}
	var pos = obj.getBoundingClientRect();
	var right = pos.right
	var top = pos.top
	titleText = $('#'+ obj.id).attr('title');
	$('#'+ obj.id).attr('title',"");
	var message = $('#'+ obj.id).attr('reason');
	messageObj=document.createElement("DIV")
	messageObj.innerText=message;
	messageObj.id="messageText";
	messageObj.style.top=top+"px";
	messageObj.style.left=right+"px";
	window.document.body.appendChild(messageObj);
}
function topDel(obj){
	if (typeof(obj) == "undefined") return;
	if(titleText!=""){
		$('#'+ obj.id).attr('title',titleText);
		titleText="";
	}
	if(messageObj!=""){
		window.document.body.removeChild(messageObj);
		messageObj="";
	}
}
//调用归档统计扫描项目数目页面
function submitRemarks()
{
	if (isSubmitRemarks != "Y") return;
	var tempFrame = "<iframe id='iframeSubmitRemarks' scrolling='auto' frameborder='0' src='../csp/dhc.epr.fs.submitremarks.csp?EpisodeID=" + episodeID + "' style='width:460px; height:540px; display:block;'></iframe>";
	parent.createModalDialog("dialogSubmitRemarks","","464","580","iframeSubmitRemarks",tempFrame,"","");
}

//增加诊断行(GRID编辑器)
document.getElementById("addDiagRow").onclick = function(){
 	strJson = {action:"ADD_GRID_ROW",args:{"RowType":"Diag"}}; 
 	doExecute(strJson);	
};

//增加手术行(GRID编辑器)
document.getElementById("addOperRow").onclick = function(){
 	strJson = {action:"ADD_GRID_ROW",args:{"RowType":"Oper"}}; 
 	doExecute(strJson);	
};
