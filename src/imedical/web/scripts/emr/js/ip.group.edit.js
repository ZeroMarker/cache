var resource = "";
var resourceFlag = false;
$(function(){
	//toolbar = window.frames["framRecordTool"];
	//resource = window.frames["framResource"];
	resource = document.getElementById("framResource").contentWindow; 

	initRecordToolbar();
	initResource();
	
    //设置病历导航宽度
    resize("病历导航",navWidth);
    $('#navtab').tabs({
        onSelect:function(title,index){
            if (title == "病历导航")
            {
                width = navWidth;
            }
            else if (title == "质控提示")
            {
                width = qualityWidth;
            }
            else if (title == "病历参考")
            {
                width = refWidth;
            }else if (title == "病历资源"){
                if (!resourceFlag)
                {
                    //首次进入资源区，添加fit:true属性
                    resource.$('#resources').tabs({'fit':true});
                    resourceFlag = true;
                }
                //先获取医生上次操作资源区宽度
                var value = getUserConfigData(userID,userLocID,"RESOURCEWIDTH");
                if (value !="")
                {
                    width = value;  
                }
                else
                {
                    width = resWidth;
                }
            }
            resize(title,width);
        }
    }); 
},0);

function getResourceWidth()
{
    var selectTitle = $('#navtab').tabs('getSelected').panel('options').title;
	if ((selectTitle == "病历导航")||(selectTitle == "质控提示"))
		return "";      //如果当前选中页为病历导航页或者质控提示，则不记录宽度到用户习惯表中
    
	return $("#main").layout('panel','west').panel('options').width; //获取资源区宽度
}

function resize(title,width)
{
    if (typeof(width) == "undefined"){
        return;
    }
    if ((!resourceFlag)&&(title=="")){
        return;
    }
	$("#main").layout('panel','west').panel('resize',{width:width}); //设置north panel 新高度
	$('#main').layout('resize');
}

//初始化资源区
function initResource()
{
	$("#framResource").attr("src","emr.ip.resource.csp?EpisodeID="+episodeID);
}

//关闭病历页面事件
function savePrompt(instanceID)
{
	var returnValues = "";
	///退出保存检查
	if (plugin())
	{
		if (getModifyStatus(instanceID).Modified == "True")
		{
			var documentContext = getDocumentContext(instanceID);
			
			//增加判定如果无保存权限，则退出保存检查
			if (documentContext.privelege.canSave != "1") return returnValues;

			var text = '病历 "' +documentContext.Title.DisplayName + '" 有修改是否保存';
			if (confirm(text))
			{
				saveDocument();
				alert("病历已保存");
				returnValues = "save";
				return returnValues;
			}
			else
			{
				returnValues = "unsave";
				return returnValues;
			}
		} 
	} 	
	return returnValues;
}

//病历是否可切换或销毁编辑器（目前只判断打印和加载是否完成）
function canBreake()
{
	var returnValues = "true";
	///退出保存检查
	if (plugin())
	{
		var breakState = getBreakState();
		if (breakState.result == "OK")
		{
			returnValues = breakState.BreakState;
		} 
	} 	
	return returnValues;
}

///检查加载病历权限
function checkLoadPrivilege(tempParam,sendflag)
{
	var flag = false;
	var loadPrivilege = getPrivilege(tempParam,"LoadPrivilege",episodeID,patientID);
	//权限判断
	if (loadPrivilege.canView == "0")
	{
		if (sendflag) setMessage('您没有权限查看 "'+tempParam.text+' "'+loadPrivilege.cantViewReason,'forbid');
		flag = true;
		return flag;
	}
}

///检查新建病历权限
function checkCreatePrivilege(tempParam,sendflag)
{
	var flag = false;
	var loadPrivilege = getPrivilege(tempParam,"CreatePrivilege",episodeID,patientID);
	//权限判断
	if (loadPrivilege.canNew == "0")
	{
		if (sendflag) setMessage('您没有权限创建 "' +tempParam.text+ ' "'+loadPrivilege.cantNewReason,'forbid');
		flag = true;
		return flag;
	}
}

///检查操作病历权限
function checkActionPrivilege(tempParam)
{
	var actionPrivilege = getPrivilege(tempParam,"ActionPrivilege",episodeID,patientID);
	return actionPrivilege;
}

//将提示消息发送到消息提示区
function setMessage(message,type)
{
	var tmptype = "info";
	if (type == "alert")
	{
		tmptype = "success";
	}
	else if(type == "forbid")
	{
		tmptype = "error";
	}	
	else if (type == "warning")
	{
		tmptype = "alert"
	}
	top.$.messager.popover({msg: message,type:tmptype,timeout:messageScheme[type],style:{top:20,left:document.documentElement.clientWidth/2}});	
}


//向主界面发信息
function setlockdocument(message)
{
	var messages = message.split("|");
	var span = $("<span></span>");
	if (messages.length>1)
	{
	   	$(span).html("该病历正被编辑:("+messages[1]+"|"+messages[6]+"|"+messages[5]+"|"+messages[3]+"|"+messages[2]+")");
	   	$(span).attr({"userCode":messages[0],"userName":messages[1],"ip":messages[3],"lockId":messages[4]});
		$("#lock").html(span);
		$("#lock").show();
	}
	else
	{
		$("#lock").html(span);
		$("#lock").hide();
	}
}

function getConfig()
{
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: '../EMRservice.Ajax.eventData.cls',
		async: true,
		data: {
			"Action": "CriticalValueConfig",
			"EpisodeID": episodeId
		},
		success: function(d) {
			if (d != "")
			{
				var data = eval("("+d+")");
				$("#title").attr({"DocID":data.DocID,"CategoryID":data.CategoryID,"TemplateId":data.TemplateId});
				$("#title").attr({"IsLeadframe":data.IsLeadframe,"IsMutex":data.IsMutex});
				$("#title").attr({"ChartItemType":data.ChartItemType,"PluginType":data.PluginType});
				for (var i=0;i<data.TitleCodes.length;i++)
				{
					$("#title").append('<option value ="'+data.TitleCodes[i].TitleCode+'">'+data.TitleCodes[i].TitleDesc+'</option>');
				}
			}
		},
		error : function(d) { alert(" error");}
	});
}

//加锁
function lockDocument(groupParam)
{
	if (groupParam == "") groupParam = param;
	if (groupParam == "") return;
	lockinfo = lock(groupParam.actionType,groupParam.categoryId,groupParam.emrDocId,groupParam.id,groupParam.templateId); 	
}

//解锁
function unLockDocumnet()
{
	if (isEnableEditMultiRecord == "false")
	{
		unLockAllInstance(userID,episodeID,param.emrDocId);
		$("#lock").hide(); 
	}
	else
	{
		if (lockinfo != "" && typeof(lockinfo.LockID) != "undefined")
		{
			unLock(lockinfo.LockID);
			if (lockinfo.LockID == "")
			{ 
				$("#lock").hide(); 
			}
		}
	}
}

function btnUnLock()
{
	var lockcode = $("#lock span").attr("userCode");
	var lockname = $("#lock span").attr("userName");
	var lockId = $("#lock span").attr("lockId");
	if (lockcode != undefined )
	{
		top.$.messager.confirm("提示信息", "确定解锁吗?", function (r) {
			if (!r) 
			{
				return ;
			} 
			else
			{
				if (lockcode != userCode)
				{
					var arr = {"lockId":lockId};
					var iframeContent = "<iframe id='iframeLock' scrolling='auto' frameborder='0' src='emr.userverification.csp?UserID="+lockcode+"&UserName="+base64encode(utf16to8(encodeURI(lockname)))+"&openWay=group"+"&MWToken="+getMWToken()+"' style='width:240px; height:200px; display:block;'></iframe>";
					createModalDialog("lockDialog","手工解锁","250","240","iframeLock",iframeContent,lockCallBack,arr)
				}
				else
				{
					btnUnLockContent(lockId);
				}
			}
		});
	}
}

//手工解锁模态框
function lockCallBack(returnValue,arr)
{
	var lockId = "";
	if (typeof(arr.lockId) != "undefined")
	{
		lockId = arr.lockId;
	}
	if (returnValue == "1")
	{
		btnUnLockContent(lockId);
	}
	else if(returnValue == "0")
	{
		top.$.messager.alert("提示信息", "密码验证失败", 'info');
	}
}

function btnUnLockContent(lockId)
{
	if (unLock(lockId)=="1")
	{
		setReadOnly(false,"");
		lockDocument("");
		$("#lock").hide();
	}
	else
	{
		top.$.messager.alert("提示信息", "解锁失败", 'info');
	}
}

///隐藏或显示工具栏
function hideToolbar(status)
{
	if (status == "hide")
	{
		$('#editor').layout('panel', 'north').panel('resize',{height:35});
	}
	else
	{
		$('#editor').layout('panel', 'north').panel('resize',{height:110});
	}
	$('#editor').layout('resize');
}

function addTabs(id,title,content,closable)
{
   if($("#navtab").tabs("exists",title)){
   	    $("#navtab").tabs("select",title);
	    var tab = $("#navtab").tabs('getSelected');  
		$("#navtab").tabs('update', {
			tab: tab,
			options: {
				content: content
			}
		});
		tab.panel('refresh');
   }else{	
	   $("#navtab").tabs("add",{
		    id: id,
			title: title,
			content: content,
			closable: closable
	   });
   }
   
}

function closeTab(name)
{
	$("#navtab").tabs("close",name);
}

function operateDocument(temparam)
{
	getListRecord(temparam.args.spreading.groupCode);
	InitDocument(temparam)
	
}

window.onunload = function(){  
	unLockDocumnet();
}  

//点击首页按钮关闭病历页面事件
function IsSavePrompt(instanceID)
{
    var returnValues = "";
    parent.setSysMenuDoingSth(""); 
    ///退出保存检查
    if (plugin())
    {
        var modifyStatus = getModifyStatus(instanceID);
        if (modifyStatus.Modified == "True")
        {
            var displayName = "";
            if ((typeof(modifyStatus.InstanceID) != "undefined")&&(modifyStatus.InstanceID.length>0))
            {
                for (i=0;i<modifyStatus.InstanceID.length;i++ )
                {
                    var documentContext = getDocumentContext(modifyStatus.InstanceID[i]);
                    
                    //增加判定如果无保存权限，则退出保存检查
                    if (documentContext.privelege.canSave != "1") return returnValues;
                    
                    if (displayName != "") {displayName = displayName + " "}
                    displayName = displayName + documentContext.Title.NewDisplayName;
                }
            }
            
            var text = '病历 "' +displayName + '" 有修改是否保存';
            var dialogID = "SavePromptDialog";
            var tempFrame = "<iframe id='iframeSavePrompt' scrolling='auto' frameborder='0' src='emr.ip.prompt.csp?DialogID="+dialogID+"&PromptText="+text+"&MWToken="+getMWToken()+"' style='width:100%;height:100%;display:block;'></iframe>"
            createModalDialog(dialogID,"保存提示","350","150","iframeSavePrompt",tempFrame,doPrompt);
            returnValues = "1";
        }
    }
    return returnValues;
}

function doPrompt(result){
    if (result == "save")
    {
        saveDocument();
    }else if(result == "unsave")
    {
        resetModifyState(param.id,"false");
    }else
    {
        return;
    }
    var breakState = canBreake();
    if (breakState == "false") return;
    parent.showNav();
}
