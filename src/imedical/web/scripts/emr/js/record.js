$(function(){
    if (isShowPatInfo === "Y") {
        getPatinentInfo();	
	}
	loadNavPage();
    GetDisease();
	initResource(); //初始化其它资源区内容
	if (isOpenEvent == "Y"){
		getEvent();
		window.setInterval("getEvent()",600000);
	}
	
	setDataToEventLog(); //自动记录登录电子病历系统的日志
	if (pageAttribute.DefaultForm == "Edit")
	{
		loadRecordEidtPage();	
	}
	$('a').attr('href','#');
	checkWholePrivilege();
	if (isShowCompleteSymbol == "Y")
	{
		setCompleteMessage();
	}
});

//加载导航页签
function loadNavPage()
{
    var libRecord = '<iframe id = "framnav" frameborder="0" src="emr.record.library.csp" style=" width:100%; height:100%;scrolling:no;"></iframe>';
    addTab("content","tabnav","导航",libRecord,false,false);	
}

//加载病历编辑页签
function loadRecordEidtPage()
{
	var content = '<iframe id = "framRecord" scrolling="no" frameborder="0" src="emr.record.edit.csp" style="width:100%;height:100%;"></iframe>';	    
	addTab("content","tabRecord","病历",content,true,true);	
}

function loadRecordGroupEditPage()
{
	var content = '<iframe id = "framRecord" scrolling="no" frameborder="0" src="emr.record.group.edit.csp" style="width:100%;height:100%;"></iframe>';	    
	addTab("content","tabGroupRecord","批量创建病历",content,true,true);	
	
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
            SetPatientInfo(PatientInfo);
        } 
    });
}
//设置患者信息
function SetPatientInfo(patientInfo) {
	var splitor = '&nbsp&nbsp|&nbsp&nbsp';
	var htmlStr = '&nbsp';
	htmlStr += '<span class="spancolorleft">床号:</span><span class="spancolor">'
			+ patientInfo[0].disBed + '</span>';

	if (HasPatEncryptLevel == "Y")
	{
		SecCode = patientInfo[0].SecCode;

		htmlStr += splitor
			+ '<span class="spancolorleft">病人密级:</span> <span class="spancolor">'
			+ patientInfo[0].SecAlias + '</span>';

		htmlStr += splitor
			+ '<span class="spancolorleft">病人级别:</span> <span class="spancolor">'
			+ patientInfo[0].EmployeeFunction + '</span>';
	}
		
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
			+ '<span class="spancolorleft">病人ID:</span> <span class="spancolor">'
			+ patientInfo[0].papmiNo + '</span>';
			
	htmlStr += splitor
			+ '<span class="spancolorleft">病案号:</span><span class="spancolor">'
			+ patientInfo[0].ipRecordNo + '</span>';

	htmlStr += splitor
			+ '<span class="spancolorleft">付费方式:</span><span class="spancolor">'
			+ patientInfo[0].payType + '</span>';
			
	htmlStr += splitor
			+ '<span class="spancolorleft">入院日期:</span> <span class="spancolor">'
			+ patientInfo[0].admDate + '</span>';
			
	htmlStr += splitor
			+ '<span class="spancolorleft">诊断:</span> <span class="spancolor">'
			+ patientInfo[0].mainDiagnos + '</span>';
			
	htmlStr += splitor
			+ '<span class="spancolorleft">科室:</span> <span class="spancolor">'
			+ patientInfo[0].dept + '</span>';	
	htmlStr += splitor
			+ '<span class="spancolorleft">入院次数:</span> <span class="spancolor">'
			+ patientInfo[0].inTimes + '</span>';	
	$('#patientInfo').append(htmlStr);
	jQuery("#patientInfo").css("display", "inline-block");
	jQuery("#tool-disease").css("display", "block");
}

//病历编辑/////////////////////////////////////////////////////////////////////////////////////////
//操作文档
function operateRecord(tabParam)
{
	recordParam = tabParam;
	var tabs = $('#content').tabs('tabs');
	var result = IsTabExitById(tabs,"tabGroupRecord");
	if (result[0]) $('#content').tabs('close',result[1]);
	var result = IsTabExitById(tabs,"tabRecord");
	if (!result[0])
	{
		loadRecordEidtPage();
	}
	else
	{
		$('#content').tabs('select', result[1]);
		window.frames["framRecord"].InitDocument(tabParam);
	}
}

///批量创建
function openGroupRecord(tabParam)
{
	var tabs = $('#content').tabs('tabs');
	var result = IsTabExitById(tabs,"tabRecord");
	if (result[0]) $('#content').tabs('close',result[1]);
	var result = IsTabExitById(tabs,"tabGroupRecord");
	if (!result[0])
	{
		loadRecordGroupEditPage();
		$(window.frames["framRecord"]).load(function(){ 
		 	window.frames["framRecord"].g_groupTempParam = tabParam.slice();
			window.frames["framRecord"].operateDocument(tabParam[0]);
		});  		
	}
	else
	{
		$('#content').tabs('select', result[1]);
		window.frames["framRecord"].g_groupTempParam = tabParam.slice();
		window.frames["framRecord"].operateDocument(tabParam[0]);
	}
}

///打开接口病历
function openInterfaceRecord(Id,Name,src)
{
	var tabs = $('#content').tabs('tabs');
	var tabId = "tab"+Id
	var result = IsTabExitById(tabs,tabId);
	if (!result[0])
	{	
	   	src = src.replace(/\[patientID\]/g, patientID);
		src = src.replace(/\[episodeID\]/g, episodeID);
		src = src.replace(/\[mradm\]/g, mradm);
		src = src.replace(/\[regNo\]/g, regNo);
		src = src.replace(/\[medicare\]/g, medicare);
		src = src.replace(/\[userID\]/g, userID);
		src = src.replace(/\[userCode\]/g, userCode);
		src = src.replace(/\[ctLocID\]/g, userLocID);
		src = src.replace(/\[ctLocCode\]/g, userLocCode);
		src = src.replace(/\[ssGroupID\]/g, ssgroupID);
		var content = '<iframe id ="iframe'+Id+'" frameborder="0" src="'+src+'" style="width:100%;height:100%;"></iframe>'
		addTab("content",tabId,Name,content,true);
	}
	else
	{
		$('#content').tabs('select', result[1]);
	}
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
				 $("#printViewMessage").empty();
		     }   
        },
        onSelect:function(title,index){
	    	var param = {"action":"reflashKBNode","bindKBBaseID":"","titleCode":""}; 
	    	eventDispatch(param)
	    	if ((index == 0)&&(recordParam))
	    	{
		    	var categoryId = recordParam["categoryId"]
		    	if (categoryId != "")
		    	{
					if((typeof window.frames["framnav"].frames["framCategory"])=="undefined")return
			    	///重新加载当前目录导航数据
			    	window.frames["framnav"].frames["framCategory"].reLoadNav(categoryId);
			    }
		    }
		    var tab = $('#content').tabs('getTab',index);
		    var id = tab[0].id.substring(3);
		    if (recordParam!=null)
		    {
			    if ((recordParam.IsActive == "N")&&(!isNaN(id))){
				    recordParam.IsActive = "";
				    window.frames["iframe"+id].Reload();
			    }
		    }
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
	else if (param["action"] == "replaceComposite")  
	{
		//替换知识库节点
		eventReplaceComposite(param);
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
	else if(param["action"] == "SAVE_SECTION")
	{
		if (!window.frames["framRecord"]) return "";
		return window.frames["framRecord"].saveSection(param.args);	
	}
	else if(param["action"] == "CREATE_DOCUMENT_BY_INSTANCE")
	{
		operateRecord(param.args);
	}
	else if(param["action"] == "GET_DOCUMENT_CONTEXT")
	{
		if (!window.frames["framRecord"]) return "";
		return window.frames["framRecord"].getDocumentContext();
	}
	else if(param["action"] == "CHECK_DOCUMENT_MODIFY")
	{
		if (!window.frames["framRecord"]) return "";
		return window.frames["framRecord"].getModifyStatus(param.args.InstanceID||"");
	}
	else
	{
		if (!window.frames["framRecord"]) return "";
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

///替换知识库节点
function eventReplaceComposite(commandParam)
{
	if (!window.frames["framRecord"]) return;
	window.frames["framRecord"].replaceComposite(commandParam["NodeID"]);
}

///判断当前光标在文档中的位置
function getElementContext(position)
{
	if (!window.frames["framRecord"]) return;
	var result = window.frames["framRecord"].getElementContext(position);
	return result;
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

///判断当前文档的只读状态
function getReadOnlyStatus()
{
	if (!window.frames["framRecord"]) return;
	var result = window.frames["framRecord"].getReadOnlyStatus().ReadOnly;
	return result;
}

///设置工具条件状态
function eventSetToolbar(commandParam)
{
	if(!commandParam.status) return;
	if(commandParam.status["canSave"] == 1)
	{
		setSaveStatus('enable');
		$('#save').attr('reason','');
	}
	else
	{
		setSaveStatus('disable');
		$('#save').attr('reason',commandParam.status["cantSaveReason"]);
	}
	if(commandParam.status["canPrint"] == 1)
	{
		setPrintStatus('enable');
		$('#print').attr('reason','');
	}
	else
	{
		setPrintStatus('disable');
        	$('#print').attr('reason',commandParam.status["cantPrintReason"]);
	}
	if(commandParam.status["canDelete"] == 1)
	{
		setDeleteStatus('enable');
		$('#delete').attr('reason','');
	}
	else
	{
		setDeleteStatus('disable');
		$('#delete').attr('reason',commandParam.status["cantDeleteReason"]);
	}
	
	if(commandParam.status["canReference"] == 1)
	{
		setReference('enable');
		$('#reference').attr('reason','');
	}
	else
	{
		setReference('disable');
		$('#reference').attr('reason',commandParam.status["cantReferenceReason"]);
	}
	if(commandParam.status["canExport"] == 1)
	{
		setExportDocumnet('enable');
		$('#export').attr('reason','');
	}
	else
	{
		setExportDocumnet('disable');
		$('#export').attr('reason',commandParam.status["cantExportReason"]);
	}
	if(commandParam.status["canViewRevise"] == 1)
	{
		setViewRevision('enable');
		$('#viewRevision').attr('reason','');
	}
	else
	{
		setViewRevision('disable');
		$('#viewRevision').attr('reason',commandParam.status["cantViewReviseReason"]);
	}	
	if(commandParam.status["canCommit"] == 1)
	{
		setCommitStatus('enable');
		$('#confirmRecordCompleted').attr('reason','');
	}
	else
	{
		setCommitStatus('disable');
		$('#confirmRecordCompleted').attr('reason',commandParam.status["cantCommitReason"]);
	}
	if(commandParam.status["canApplyEdit"] == 1)
	{
		setApplyeditDocumnet('enable');
		$('#applyedit').attr('reason','');
	}
	else
	{
		setApplyeditDocumnet('disable');
		$('#applyedit').attr('reason',commandParam.status["cantApplyEditReason"]);
	}
	if(commandParam.status["canUnLock"] == 1)
	{
		setUnLockStatus('enable');
		$('#unLock').attr('reason','');
	}
	else
	{
		setUnLockStatus('disable');
		$('#unLock').attr('reason',commandParam.status["cantUnLockReason"]);
	}
}

function sendCopyCutData(param)
{
	if (!window.frames["framclipboard"]) return;
	window.frames["framclipboard"].setContent(param.content);
}


window.onbeforeunload = function(){    
	if (window.frames["framRecord"] && window.frames["framRecord"].length >0)
	{
		var result = window.frames["framRecord"].savePrompt("");
		if (result == "cancel") return false;
		window.frames["framRecord"].unLockDocumnet();
	}
	window.close();
}

////event
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
						text = text + '<span class="eventList"  id='+d[i].EventType+'><img src="../scripts/emr/image/icon/'+d[i].EventType+'.png"/>';	
						text = text + '<div class="helper">'+d[i].PromptMessage+'</div></span>';
						
					}
					text = text + '</marquee>';
					$("#event").html(text);		
				}
				else
				{
					var d = eval(d);
					var text = '<div class="wrap">';
					for (var i=0;i<d.length;i++)
					{
						text = text + '<span class="eventList" id="'+d[i].EventType+'"><img src="../scripts/emr/image/icon/'+d[i].EventType+'.png"/>';	
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

$("#event .eventList").live("click",function(){
	var eventType = $(this)[0].id;
	var returnValues = "";
	returnValues = window.showModalDialog("emr.event.csp?EpisodeID="+episodeID+"&EventType="+eventType,window,"dialogHeight:500px;dialogWidth:700px;resizable:no;status:no");
	if (!returnValues && returnValues.length != 0)
	{
		var Values = eval("("+returnValues+")");
		if ((Values == "")||(Values == undefined)) return;
		operateRecord(Values);
	}
});

//自动记录登录电子病历系统的日志
function setDataToEventLog()
{
	if (IsSetToLog == "Y")
	{
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

///检查送病案室操作权限
function checkWholePrivilege()
{	
	var toolbarPrivilege = getPrivilege("ToolbarPrivilege","","","");
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

//设置病历全部完成提交人等信息提示
function setCompleteMessage()
{
	if (episodeID == "") return;
	var result = ""
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmRecordStatus",
					"Method":"GetAdmRecordStatusMessage",			
					"p1":episodeID
				},
			success : function(d) {
				if (d != "")
				{
					result = "该患者的病历已送至病案室(" + d + ")";
				}
			},
			error : function(d) { }
		});	
	var span = $("<span></span>");
	$(span).html(result);
	$("#complete").html(span);
}