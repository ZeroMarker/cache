var resource = "";
$(function(){
	//toolbar = window.frames["framRecordTool"];
	//resource = window.frames["framResource"];
	resource = document.getElementById("framResource").contentWindow; 
	if (autoSave["switch"] == "on")
	{
		window.setInterval("eventSave()",autoSave.interval);
	}
	initRecordToolbar();
    switchRecord();
    initResource();
    if(showNav == "Y")
    {
	   initquickNav(); 
	}
	else
	{
		$("#main").layout('remove','west');
	}
    $('#newMain').layout('panel','east').panel({
        onResize: function(width, height){
            var selectTitle = resource.$('#resources').tabs('getSelected').panel('options').title;
            if (selectTitle == "病历参考"){
                if ((width != undefined)&&(width != ""))
                {
                    addUserConfigData(userID,userLocID,"REFERENCEWIDTH",width);
                }
            }
        }
    });
},0);

//切换病历
function switchRecord()
{
    var tabParam = parent.setting.tabParam;
    if (tabParam != undefined && tabParam != "")
    {
        InitDocument(tabParam);
    }
}

function getResourceWidth()
{
	var length = $('#newMain').layout('panel','east').length;
    if(length>0)
    {
		var selectTitle = resource.$('#resources').tabs('getSelected').panel('options').title;
	    if ((selectTitle == "病历参考")||(selectTitle == "质控提示")){
	        return "";      //如果当前选中页为病历参考页或者质控提示，则不记录宽度到用户习惯表中
	    }
	    return $("#newMain").layout('panel','east').panel('options').width; //获取资源区宽度	
	}

}

function resize(title,panelWidth)
{
    var width = panelWidth || 320;
    if (title == "质控提示")
    {
        width = qualityWidth;
    }else if (title == "病历参考")
    {
        //先获取医生上次操作病历参考宽度
		var value = getUserConfigData(userID,userLocID,"REFERENCEWIDTH");
		if (value !="")
		{
			width = value;	
		}
		else
		{
			width = refWidth;
		};
    }else if (title == "病历资源"){
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
    $("#newMain").layout('panel','east').panel('resize',{width:width});
    $('#newMain').layout('resize');
}

//初始化资源区
function initResource()
{
	$("#framResource").attr("src","emr.ip.resource.csp?EpisodeID="+episodeID);
}

//关闭病历页面事件,saveType为保存操作类型(同步或异步),默认异步
function savePrompt(instanceID,saveType)
{
	var returnValues = "";
	
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
			
			returnValues = window.confirm(text);
			if (returnValues)
			{
				returnValues = "save"
				saveDocument(saveType);
				setSysMenuDoingSth(""); 
				alert("病历已保存");
				
			}
			else
			{
				returnValues = "unsave"
				return returnValues;
			}
		} 
	} 		
	return returnValues;
}
//关闭tab前判断是否保存的时调用
function closeTabSavePrompt(instanceID,saveType)
{
	var returnValues = false;
	setSysMenuDoingSth(""); 
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
			returnValues = text;
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
		if ((typeof(igridFlag) == "undefined")||(typeof(iwordFlag) == "undefined"))
		{
			returnValues = "false"
		}
		else
		{
			var breakState = getBreakState();
			if (breakState.result == "OK")
			{
				returnValues = breakState.BreakState;
			} 
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
		var text = tempParam.text || tempParam.titleName;
		if (sendflag) setMessage('您没有权限创建 "' +text+ ' "'+loadPrivilege.cantNewReason,'forbid');
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
function setMessage(message,type,site)
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
	var topValue = 20;
	var leftValue = document.documentElement.clientWidth/2;
	if(site){
		topValue = site.top||topValue;
		leftValue = site.left||leftValue;
		}	
	parentWin.$.messager.popover({msg: emrTrans(message),type:tmptype,timeout:messageScheme[type],style:{top:topValue,left:leftValue}});	
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
		parentWin.$.messager.confirm("提示信息", "确定解锁吗?", function (r) {
			if (!r) 
			{
				return ;
			} 
			else
			{
				if (lockcode != userCode)
				{
					var tempFrame = "<iframe id='iframeLock' scrolling='auto' frameborder='0' src='emr.ip.userverification.csp?UserID="+lockcode+"&UserName="+base64encode(utf16to8(encodeURI(lockname)))+"&openWay=group"+"&MWToken="+getMWToken()+"' style='width:240px; height:210px; display:block;'></iframe>"
					createModalDialog("lockDialog","手工解锁","270","250","iframeLock",tempFrame,doLock,lockId)
				}
				else
				{
					btnUnLockContent(lockId);
				}
				
			} 
		});
	}
}

//手工解锁
function doLock(returnValue,arr)
{
	if (returnValue == "1")
	{
		btnUnLockContent(arr);
	}
	else if(returnValue == "0")
	{
		parentWin.$.messager.alert("提示信息", "密码验证失败", 'info');
	}
}


function btnUnLockContent(lockId)
{
	if (unLock(lockId)=="1")
	{
		setReadOnly(false,"",false);
		lockDocument("");
		$("#lock").hide();
		var documentContext = getDocumentContext("");
		//设置当前文档操作权限
		setPrivelege(documentContext);
	}
	else
	{
		parentWin.$.messager.alert("提示信息", "解锁失败", 'info');
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
		$('#editor').layout('panel', 'north').panel('resize',{height:100});
	}
	$('#editor').layout('resize');
}

function addTabs(id,title,content,closable)
{
	var length = $('#newMain').layout('panel','east').length;
    if(length==0)
    {
	    openResourceTab();
	}
	if(resource.$('#resources').tabs("exists",title)){
        resource.$('#resources').tabs("select",title);
        var tab = resource.$('#resources').tabs('getSelected');  
        resource.$('#resources').tabs('update', {
            tab: tab,
            options: {
                content: content
            }
        });
        tab.panel('refresh');
   }else{
       resource.$('#resources').tabs("add",{
            id: id,
            title: title,
            content: content,
            closable: closable
       });
   }
   
}

function closeTab(name)
{
	var length = $('#newMain').layout('panel','east').length;
    if(length==0)
    {
	    openResourceTab();
	}
	resource.$("#resources").tabs("close",name);
}

//点击首页按钮关闭病历页面事件
function IsSavePrompt(instanceID)
{
    var returnValues = "";
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
        setSysMenuDoingSth("");
        resetModifyState(param.id,"false");
    }else
    {
        setSysMenuDoingSth(emrTrans('请先保存病历！'));
        return;
    }
    var breakState = canBreake();
    if (breakState == "false") return;
    parent.showNav();
}

//刷新平台菜单
function reloadMenu(instanceId){
    if(parent.parent.reloadMenu != undefined){
        var reloadParam = {
            reloadCurrentMenu:true,
            instance:instanceId
        };
        parent.parent.reloadMenu(reloadParam);
    }
}

function setSysMenuDoingSth(sthmsg) {
    if ('undefined' != typeof dhcsys_getmenuform) {
        if ('undefined' != typeof dhcsys_getmenuform()) {
            var DoingSth = dhcsys_getmenuform().DoingSth || '';
            if ('' != DoingSth)
                DoingSth.value = sthmsg || '';
        }
    }
}

//平台触发病历保存操作，需要在头菜单弹出病历修改，是否保存的confirm实现
function savePromptByHIS()
{
	///退出保存检查
	if (plugin())
	{
		var documentContext = getDocumentContext();
					
		//增加判定如果无保存权限，则退出保存检查
		if (documentContext.privelege.canSave != "1")
			return ;

		saveDocument("sync");
	}	
}

//向头菜单设置回调函数，平台判断变量为function时，弹出confirm页面，用以实现病历有修改，离开页面时提示是否保存
function setDoingSthSureCallback(flag) {
	var win = websys_getMenuWin();
	if (flag)
	{
		// 点击确定时调用
		win.DoingSthSureCallback = function(){
			savePromptByHIS();
	        var win = websys_getMenuWin()
			win.DoingSthSureCallback = "";
			win.DoingSthCancelCallback = "";
			setSysMenuDoingSth("");
		}
		// 点击不保存时调用
		win.DoingSthCancelCallback = function(){
			var win = websys_getMenuWin()
			win.DoingSthSureCallback = "";
			win.DoingSthCancelCallback = "";
			setSysMenuDoingSth("");
			clearDocument();
		};
	}
	else
	{
		win.DoingSthSureCallback = "";
		win.DoingSthCancelCallback = "";
	}
}

///获取病历参考的宽度
function getReferenceWidth()
{
	var length = $('#newMain').layout('panel','east').length;
    if(length>0)
    {
		var selectTitle = resource.$('#resources').tabs('getSelected').panel('options').title;
	    
	    if ((selectTitle == "病历导航")||(selectTitle == "质控提示")||(selectTitle == "病历资源"))
			return "";      //如果当前选中页为病历导航页或者质控提示，则不记录宽度到用户习惯表中
	    
	    return $("#newMain").layout('panel','east').panel('options').width; //获取资源区宽度 
	}

}
