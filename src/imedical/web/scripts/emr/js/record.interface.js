$(function(){
	maxWindow();
	getPatinentInfo();	
	GetDisease();
	initResource(); //初始化其它资源区内容
	setDataToEventLog(); //自动记录登录电子病历系统的日志
	operateRecord(recordParam);
});

//最大化窗口
function maxWindow()
{
	if (window.screen) { //判断浏览器是否支持window.screen判断浏览器是否支持screen 
		var myw = screen.availWidth; //定义一个myw，接受到当前全屏的宽 
		var myh = screen.availHeight; //定义一个myw，接受到当前全屏的高 
		window.moveTo(0, 0); //把window放在左上脚 
		window.resizeTo(myw, myh); //把当前窗体的长宽跳转为myw和myh 
	} 
}

//增加tab标签
function addTab(ctrlId,tabId,tabTitle,content,closable,selected)
{
	$('#'+ctrlId).tabs('add',{
	    id:       tabId ,
		title:    tabTitle,
		content:  content,
		closable: closable,
		selected: selected	
   });	
}

//患者信息///////////////////////////////////////////////////////////////////////////////////////
//加载患者信息
function getPatinentInfo()
{
	$.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.patientInfo.cls", 
        data: "action=GetPatientInfo"+ "&patientID=" +patientID+ "&EpisodeID=" +episodeID, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) {
	       PatientInfo = eval(data); 
           setPatientInfo(PatientInfo);
        } 
    });
}
//设置患者信息
function setPatientInfo(patientInfo) {
	var splitor = '&nbsp&nbsp|&nbsp&nbsp';
	var htmlStr = '&nbsp<span class="spancolorleft">登记号:</span> <span class="spancolor">'
			+ patientInfo[0].papmiNo + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">病案号:</span><span class="spancolor">'
			+ patientInfo[0].ipRecordNo + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">床号:</span><span class="spancolor">'
			+ patientInfo[0].disBed + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">姓名:</span> <span class="spancolor">'
			+ patientInfo[0].name + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">性别:</span> <span class="spancolor">'
			+ patientInfo[0].gender + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">年龄:</span> <span class="spancolor">'
			+ patientInfo[0].age + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">付费方式:</span><span class="spancolor">'
			+ patientInfo[0].payType + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">入院日期:</span> <span class="spancolor">'
			+ patientInfo[0].admDate + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">诊断:</span> <span class="spancolor">'
			+ patientInfo[0].mainDiagnos + '</span>';
	$('#patientInfo').append(htmlStr);
	jQuery("#patientInfo").css("display", "inline-block");
	jQuery("#tool-disease").css("display", "block");
}

//病历编辑/////////////////////////////////////////////////////////////////////////////////////////
//打开文档
function operateRecord(tabParam)
{
	recordParam = tabParam;
	var tabs = $('#content').tabs('tabs');
	var result = IsTabExitById(tabs,"tabRecord");
	if (!result[0])
	{
		var content = '<iframe id = "framRecord" scrolling="no" frameborder="0" src="emr.record.edit.csp" style="width:100%;height:100%;"></iframe>';	    
		addTab("content","tabRecord","病历",content,true,false);
		
	}else
	{
		$('#content').tabs('select', result[1]);
		window.frames["framRecord"].InitDocument(tabParam);
	}
}

//增加文档内容及导航标签
function addContentTab(id,title,content,closable)
{
   $('#content').tabs('add',{
	    id:       id ,
		title:    title,
		content:  content,
		closable: closable
   });	
}

//判断tab是否存在
function IsTabExitById(tabs,id)
{
	var result = [false,0]
	for(var i=0; i<tabs.length; i++){
		if (tabs[i].panel('options').id == id)
		{
			result = [true,i];
		} 
	}
	return result;
}

$(function(){
	$('#content').tabs({
		onBeforeClose:function(title,index){
			var tab = $('#content').tabs('getTab',index);
			if (tab.id == "tabRecord") recordParam = "";
		     if (window.frames["framRecord"] && window.frames["framRecord"].length >0)
	     	 {
		     	 var result = window.frames["framRecord"].savePrompt("");
		     	 if (result == "cancel") return false;
		     	 window.frames["framRecord"].unLockDocumnet();
				 initToolbarStatus();
				 setToolBarStatus("disable");
				 $("#reference").removeAttr("flag");
		     }   
        },
        onSelect:function(title,index){
	    	var param = {"action":"reflashKBNode","bindKBBaseID":"","titleCode":""}; 
	    	eventDispatch(param)
        }
	});	
});

//资源区/////////////////////////////////////////////////////////////////////////
//初始化资源区
function initResource()
{
	var kbTree = "<iframe id='framKBTree' frameborder='0' src='emr.resource.kbtree.csp' style='width:100%; height:100%;scrolling:no;margin:0px;'></iframe>"				
	addTab("resources","tabKBTree","知识库",kbTree,false,true);
	resourceScheme = getResourceScheme();
	for(i=0;i<resourceScheme.length;i++ ){
		var content = "<iframe id='fram" + resourceScheme[i].id + "' frameborder='0' src='' style='width:100%; height:100%;scrolling:no;margin:0px;'></iframe>"	
		addTab("resources","tab"+resourceScheme[i].id,resourceScheme[i].title,content,false,false);
	}	
}
//资源区scheme
function getResourceScheme()
{
	strXml = convertToXml(resourceScheme);
    var objResourceScheme = new Array();
    $(strXml).find("resource>item").each(function(){
	    var id = $(this).find("id").text();
	    var title = $(this).find("title").text();
	    var source = $(this).find("source").text();
	    var width = $(this).find("width").text();
	    objResourceScheme.push({id:id,title:title,source:source,width:width})
    });
    return objResourceScheme;
}

//添加资源区
function addResourceTab(id,title,content,closable)
{
   if($('#resources').tabs('exists',title)){
   	   $('#resources').tabs('select',title);
   }else{	
	   $('#resources').tabs('add',{
		    id: id,
			title: title,
			content: content,
			closable: closable
	   });
   }	
}

//点击tab改变资源区大小
$(function(){
	$("#resources").tabs({
		onSelect: function(title,index){
			var tab = $('#resources').tabs('getTab',index);
			var width = 300;
			if(tab[0].id != "tabKBTree")
			{
				if (resourceScheme[index-1])
				{
					width = parseInt(resourceScheme[index-1].width);
					var tbIframe = $("#"+tab[0].id+" iframe:first-child");
					if (tbIframe.attr("src") == "")
					{
						tbIframe.attr("src",resourceScheme[index-1].source);
					}
				}
			}
			$('.easyui-layout').layout('panel', 'east').panel('resize',{width:width});
			$('.easyui-layout').layout('resize');
		}
	});
});


//事件处理///////////////////////////////////////////////////////////////////////////////////////
//主窗体事件派发
function eventDispatch(param)
{
	if (param["action"] == "reflashKBNode")          
	{
		//根据绑定值刷新知识库
		eventReflashKBNode(param);
	}
	else if (param["action"] == "appendComposite")  
	{
		//追加复合元素(知识库)
		eventAppendComposite(param);
	}
	else if (param["action"] == "focusDocument")    
	{
		//定位文档
		eventFocusDocument(param);
	}
	else if(param["action"] == "insertText")   
	{
		//插入文本
		eventInsertText(param);
	}
	else if (param["action"] == "setToolbar")
	{
		//设置工具条件
		eventSetToolbar(param);
	}
	
}
//刷新知识库
function eventReflashKBNode(commandParam)
{
	if ((!window.frames["framKBTree"].GetKBNodeByTreeID)||(!commandParam)) return;
	window.frames["framKBTree"].GetKBNodeByTreeID(commandParam);
}

///追加复合元素
function eventAppendComposite(commandParam)
{
	if (!window.frames["framRecord"]) return;
	window.frames["framRecord"].appendComposite(commandParam["NodeID"]);
}

///定位文档
function eventFocusDocument(commandParam)
{	
	if (!window.frames["framRecord"]) return;
	window.frames["framRecord"].focusDocument(commandParam["InstanceID"],commandParam["path"],commandParam["actionType"]); 	
}

///重新加载文档
function eventInsertText(commandParam)
{
	if (!window.frames["framRecord"]) return;
	window.frames["framRecord"].insertText(commandParam["text"]); 
}
///设置工具条件状态
//主窗体事件派发
function eventDispatch(param)
{
	if (param["action"] == "reflashKBNode")          
	{
		//根据绑定值刷新知识库
		eventReflashKBNode(param);
	}
	else if (param["action"] == "appendComposite")  
	{
		//追加复合元素(知识库)
		eventAppendComposite(param);
	}
	else if (param["action"] == "focusDocument")    
	{
		//定位文档
		eventFocusDocument(param);
	}
	else if(param["action"] == "insertText")   
	{
		//插入文本
		eventInsertText(param);
	}
	else if (param["action"] == "setToolbar")
	{
		//设置工具条件
		eventSetToolbar(param);
	}
	else if (param["action"] == "sendCopyCutData")
	{
		sendCopyCutData(param);
	}
	else if (param["action"] == "INSERT_STYLE_TEXT_BLOCK")
	{
		if (!window.frames["framRecord"]) return;
		window.frames["framRecord"].cmdDoExecute(param);	
	}
	
}
//刷新知识库
function eventReflashKBNode(commandParam)
{
	if ((!window.frames["framKBTree"].GetKBNodeByTreeID)||(!commandParam)) return;
	window.frames["framKBTree"].GetKBNodeByTreeID(commandParam);
}

///追加复合元素
function eventAppendComposite(commandParam)
{
	if (!window.frames["framRecord"]) return;
	window.frames["framRecord"].appendComposite(commandParam["NodeID"]);
}

///定位文档
function eventFocusDocument(commandParam)
{	
	if (!window.frames["framRecord"]) return;
	window.frames["framRecord"].focusDocument(commandParam["InstanceID"],commandParam["path"],commandParam["actionType"]); 	
}

///重新加载文档
function eventInsertText(commandParam)
{
	if (!window.frames["framRecord"]) return;
	window.frames["framRecord"].insertText(commandParam["text"]); 
}

///设置工具条件状态
function eventSetToolbar(commandParam)
{
	if(!commandParam.status) return;
	if(commandParam.status["canSave"] == 1)
	{
		setSaveStatus('enable');
	}
	else
	{
		setSaveStatus('disable');
	}
	if(commandParam.status["canPrint"] == 1)
	{
		setPrintStatus('enable');
	}
	else
	{
		setPrintStatus('disable');
	}
	if(commandParam.status["canDelete"] == 1)
	{
		setDeleteStatus('enable');
	}
	else
	{
		setDeleteStatus('disable');
	}
	if(commandParam.status["canReference"] == 1)
	{
		setReference('enable');
	}
	else
	{
		setReference('disable');
	}
	if(commandParam.status["canExport"] == 1)
	{
		setExportDocumnet('enable');
	}
	else
	{
		setExportDocumnet('disable');
	}
	if(commandParam.status["canViewRevise"] == 1)
	{
		setViewRevision('enable');
	}
	else
	{
		setViewRevision('disable');
	}	
}

function sendCopyCutData(param)
{
	if (!window.frames["framclipboard"]) return;
	window.frames["framclipboard"].setContent(param.content);
}

//自动记录登录电子病历系统的日志
function setDataToEventLog()
{
	if (IsSetToLog == "Y")
	{
		var ipAddress = getIpAddress();
		var ModelName = "EMR.Login";
		var Condition = "";
		//alert("ok");
		Condition = Condition + '{"patientID":"' + patientID + '",';
		Condition = Condition + '"episodeID":"' + episodeID + '",';
		Condition = Condition + '"userName":"' + userName + '",';
		Condition = Condition + '"userID":"' + userID + '",';
		Condition = Condition + '"ipAddress":"' + ipAddress + '"}';
		var ConditionAndContent = Condition;
		//alert(ConditionAndContent);
		$.ajax({ 
			type: "POST", 
			url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
			data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + SecCode
		});
	}
}

window.onbeforeunload = function(){    
	if (window.frames["framRecord"])
	{
		var result = window.frames["framRecord"].savePrompt("");
		if (result == "cancel") return false;
		window.frames["framRecord"].unLockDocumnet();
	}
	window.close();
}

///检查送病案室操作权限
function checkWholePrivilege()
{	
	var toolbarPrivilege = getPrivilege("ToolbarPrivilege","","","");
	if(toolbarPrivilege.canCommit == "0")
	{
		setCommitStatus('disable');
	}
	else
	{
		setCommitStatus('enable');
	}
}

///脚本权限
function getPrivilege(type,instanceId,templateId,docId)
{
	var result = "0";
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.privilege.cls",
		async: false,
		data: {
			"EpisodeID":  episodeID,
			"PatientID":  patientID,
			"InstanceID": instanceId,
			"TemplateID": templateId,
			"DocID":	  docId,
			"Type":       type
		},
		success: function(d) {
			if (d != "") result = eval("("+d+")");
		},
		error : function(d) { alert(action + " error");}
	});
	return result;	
}