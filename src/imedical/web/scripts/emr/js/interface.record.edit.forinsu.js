$(function(){
	maxWindow();
	initCategory();
	initResource();
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

//打开文档
function operateRecord(tabParam)
{
	if (tabParam == "")
	{
		return;
	}
	initDocument(tabParam);
	//自动记录病例操作日志
	CreateDocumentLog(tabParam,"EMR.Record.RecordNav.CreateRecord.Create");
}

//目录
function initCategory()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLClientCategoryForINSU",
			"Method":"GetCategoryList",			
			"p1":episodeID,
			"p2":DocInfo
		},
		success: function(d){
			if (d == "") return;
			var data = eval("("+d+")");
			setNewMenu(data.UnSaved);
			setRecordList(data.Saved);
			//取默认加载病历的参数
			if (data.UnSaved.length>0)
			{
				var obj = data.UnSaved[0].childs[0];
				var event = {};
				if ($(obj).attr("type") == "Operation")
				{
					var result = window.showModalDialog("emr.record.edit.operationlist.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&EventType=Operation","","dialogHeight:400px;dialogWidth:800px;resizable:yes;center:yes;minimize:yes;maximize:yes;");
					if ((result == "")||(result == undefined))
					{
						return;
					}
					else
					{
						event = {"event":{"EventType":result.type,"EventID":result.id}};
					}
				}
				var tabParam ={
					"id":"",
					"text":$(obj).attr("text"),
					"pluginType":$(obj).attr("pluginType"),
					"chartItemType":$(obj).attr("chartItemType"),
					"emrDocId":$(obj).attr("id"),
					"templateId":$(obj).attr("templateId"),
					"isLeadframe":$(obj).attr("isLeadframe"),
					"isMutex":$(obj).attr("isMutex"),
					"categoryId":$(obj).attr("categoryId"),
					"args":event,
					"actionType":"CREATE",
					"status":"NORMAL",
					"closable":true
				}; 	
				recordParam = tabParam;
			}
		},
		error: function(d){alert("error");}
	});
	if (defaultCollapse=="RECORDLIST")
	{
		$('#westList').accordion('select', 1)
	}
}

//加载新建目录
function setNewMenu(data)
{
	$('#InstanceNewItem').empty();
	for (var i=0;i<data.length;i++)
	{
		var content = $('<dl></dl>');
		$(content).append('<dt><a href="#">'+data[i].text+'</a></dt>');
		$(content).attr("id",data[i].id);
		var sub = $('<dd></dd>');
		var tData =  data[i].childs; 
		if (tData == "") continue;
		for (var j=0;j<tData.length;j++)
		{
			//判断客户端浏览器IE及其版本
			if ($.browser.msie && $.browser.version == '6.0')
			{
				var link = $('<a href="#" class="list"></a>');
			}else
			{
				var link = $('<p class="list"></p>');
			}
			$(link).attr({"id":tData[j].id,"text":tData[j].text,"isLeadframe":tData[j].isLeadframe});
			$(link).attr({"chartItemType":tData[j].chartItemType,"documentType":tData[j].pluginType});
			$(link).attr({"isMutex":tData[j].isMutex,"categoryId":data[i].id});
			$(link).attr({"templateId":tData[j].templateId,"type":data[i].type});
			$(link).append('<div class="doc">'+tData[j].text+'</div>');
			$(sub).append(link);
		}
		$(content).append(sub);
		$('#InstanceNewItem').append(content);
		//判断客户端浏览器IE版本
		if ($.browser.msie && $.browser.version == '6.0')
		{
			$('.doc').hover(function(){
				$(this).css("font-weight","bold");
			},function(){
				$(this).css("font-weight","normal");
			});
			$('.info').hover(function(){
				$(this).css("font-weight","bold");
			},function(){
				$(this).css("font-weight","normal");
			});
		}
	}		
}

//加载目录
function setRecordList(data)
{
	$('#InstanceTree').empty();
	$('#InstanceTree').attr("class","instance-item");
	for (var i=0;i<data.length;i++)
	{
		var li = $('<li class="green"></li>');
		$(li).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].isLeadframe});
		$(li).attr({"chartItemType":data[i].chartItemType,"documentType":data[i].documentType});           
		$(li).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":data[i].categoryId});			       
		$(li).attr({"templateId":data[i].templateId,"characteristic":data[i].characteristic,"emrNum":data[i].emrNum});
		var datetime = '<h3>'+data[i].happendate+'<span>'+data[i].happentime+'</span></h3>';
		var content = '<a href="#">'
							+'<DIV><H3>'+data[i].text+'</H3>'
						   	+'<P class=con><span>'+data[i].creator+'</span>&nbsp&nbsp<span id="status">'+data[i].status+'</span></P></DIV>';
					 +'</a>';
		//判断当前是否被打印过，若printstatus为空，未被打印过
		if (data[i].printstatus == "")
		{
			var Logflag = $('<input type="button" class=flag id="Logflag"></input>');
			$(Logflag).attr({"emrDocId":data[i].emrDocId,"emrNum":data[i].emrNum});
		}
		else
		{
			var Logflag = $('<input type="button" class=flag id="Logflag" style="border:#49A026;background-color:#49A026;color:#49A026"></input>');
			$(Logflag).attr({"emrDocId":data[i].emrDocId,"emrNum":data[i].emrNum});
		}
		$(li).append(datetime);
		$(li).append(content);	
		$(li).append(Logflag);
		$('#InstanceTree').append(li);   	
	}
}

//新建病历	
$('#InstanceNewItem>dl>dd>.list>.doc').live('click',function(){
	var obj = $(this).parent();
	var event = {};
	if ($(obj).attr("type") == "Operation")
	{
		var result = window.showModalDialog("emr.record.edit.operationlist.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&EventType=Operation","","dialogHeight:400px;dialogWidth:800px;resizable:yes;center:yes;minimize:yes;maximize:yes;");
		if ((result == "")||(result == undefined))
		{
			return;
		}
		else
		{
			event = {"event":{"EventType":result.type,"EventID":result.id}};
		}
	}
	var tabParam ={
		"id":"",
		"text":$(obj).text(),
		"pluginType":$(obj).attr("documentType"),
		"chartItemType":$(obj).attr("chartItemType"),
		"emrDocId":$(obj).attr("id"),
		"templateId":$(obj).attr("templateId"),
		"isLeadframe":$(obj).attr("isLeadframe"),
		"isMutex":$(obj).attr("isMutex"),
		"categoryId":$(obj).attr("categoryId"),
		"args":event,
		"actionType":"CREATE",
		"status":"NORMAL",
		"closable":true
	}; 	
	initDocument(tabParam);
	//自动记录病例操作日志
	CreateDocumentLog(tabParam,"EMR.Record.RecordNav.CreateRecord.Create");
});

///List类型打开病历
$("#InstanceTree.instance-item li").live('click',function(){
	var tempParam = {
		"id":$(this).attr("id"),
		"text":$(this).attr("text"),
		"pluginType":$(this).attr("documentType"),
		"chartItemType":$(this).attr("chartItemType"),
		"emrDocId":$(this).attr("emrDocId"),
		"templateId":$(this).attr("templateId"),
		"isLeadframe":$(this).attr("isLeadframe"),
		"characteristic":$(this).attr("characteristic"),
		"isMutex":$(this).attr("isMutex"),
		"categoryId":$(this).attr("categoryId"),
		"actionType":"LOAD",
		"status":"NORMAL",
		"closable":true
	};
	initDocument(tempParam);
	//自动记录病例操作日志
	openDocumentLog(tempParam,"EMR.Record.RecordNav.RecordDirectory.Open");
});

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

//关闭病历页面事件
function savePrompt()
{
	var returnValues = "";
	///退出保存检查
	if (plugin())
	{
		if (getModifyStatus().Modified == "True")
		{
			var text = '病历 "' +param.text + '" 有修改是否保存';
			//判断客户端浏览器IE及其版本
			if ($.browser.msie && $.browser.version == '6.0')
			{
				returnValues = window.showModalDialog("emr.prompt.csp",text,"dialogHeight:180px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
			}else
			{
				returnValues = window.showModalDialog("emr.prompt.csp",text,"dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
			}
			if (returnValues == "save")
			{
				saveDocument();
			}
			else if (returnValues == "cancel")
			{
				return returnValues;
			}
		} 
	} 	
	return returnValues;
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

///检查加载病历权限
function checkLoadPrivilege(tempParam,sendflag)
{
	var flag = false;
	var id = (tempParam.id == "undefined")? "":tempParam.id;
	var templateId = (tempParam.templateId == "undefined")? "":tempParam.templateId;
	var emrDocId = (tempParam.emrDocId == "undefined")? "":tempParam.emrDocId; 
	var loadPrivilege = getPrivilege("LoadPrivilege",id,templateId,emrDocId);
	//权限判断
	if (loadPrivilege.canView == "0")
	{
		if (sendflag) setMessage('您没有权限查看 "'+tempParam.text+'"','forbid');
		flag = true;
		return flag;
	}
}

///检查新建病历权限
function checkCreatePrivilege(tempParam,sendflag)
{
	var flag = false;
	var id = (tempParam.id == undefined)? "":tempParam.id;
	var templateId = (tempParam.templateId == undefined)? "":tempParam.templateId;
	var emrDocId = (tempParam.emrDocId == undefined)? "":tempParam.emrDocId;	
	var loadPrivilege = getPrivilege("CreatePrivilege",id,templateId,emrDocId);
	//权限判断
	if (loadPrivilege.canNew == "0")
	{
		if (sendflag) setMessage('您没有权限创建 "' +tempParam.text+ '"','forbid');
		flag = true;
		return flag;
	}
}

///检查操作病历权限
function checkActionPrivilege(tempParam)
{
	var id = (tempParam.id == undefined)? "":tempParam.id;
	var templateId = (tempParam.templateId == undefined)? "":tempParam.templateId;
	var emrDocId = (tempParam.emrDocId == undefined)? "":tempParam.emrDocId;	
	var actionPrivilege = getPrivilege("ActionPrivilege",id,templateId,emrDocId);
	return actionPrivilege;
}

///检查工具栏权限
function checkToolbarPrivilege()
{
	var actionPrivilege = checkActionPrivilege(param);
	var privelegeJson = {"action":"setToolbar","status":actionPrivilege};
	parent.eventDispatch(privelegeJson);
	if (actionPrivilege.canSave == "0")
	{
		setReadOnly(true,"");
	}
}

//将提示消息发送到消息提示区
function setMessage(message,type)
{
	var Height = "",Fontsize = "";
	if (messageScheme['height'] != undefined)
	{
		Height = messageScheme['height'];
	}else{
		Height = 29;
	}
	if (messageScheme['fontsize'] != undefined)
	{
		Fontsize = messageScheme['fontsize'];
	}else{
		Fontsize = 14;
	}
	if ($('#record').layout('panel', 'south').panel('options').height <=0)
	{
		$('#record').layout('panel', 'south').panel('resize',{height:Height});
		$('#record').layout('resize');
	}
	message = '<img src="../scripts/emr/image/icon/'+type+'.png" style="height:'+Height+'px"/><div class="'+type+'" style="height:'+Height+'px;font-size:'+Fontsize+'px">'+message+'</div>';
	$("#messageInfo").html(message);
	window.setTimeout("removeMessage()",messageScheme[type]);
}

//移除提示消息
function removeMessage()
{
	$("#messageInfo").empty();
	$('#record').layout('panel','south').panel('resize',{height:"0"});
	$('#record').layout('resize');
}

//初始化页面
function initDocument(tempParam)
{  
	
	//权限检查
	if (tempParam.actionType == "LOAD")
	{
		if (checkLoadPrivilege(tempParam,true)) return;      //加载病历权限
	}
	else
	{
		if(checkCreatePrivilege(tempParam,true)) return;     //创建病历权限
	}
	
	//解锁,保存提醒
	if (param != "")
	{	
		if (savePrompt() == "cancel") return;           //提醒保存病历
		if (lockinfo != "" && typeof(lockinfo.LockID) != "undefined")
		{         
			unLock(lockinfo.LockID);                        //解锁
		}
	}
	

	if ((param.status != tempParam.status)||(tempParam.status == "DELETE"))
	{
		param = "";
	}
    
	if (tempParam.actionType=="LOAD")
	{
		if (!doOpen(tempParam)) return; 
		
	}
	else
	{
		if (!doCreate(tempParam)) return; 	
	}
	
	param = tempParam;
}

function doCreate(tempParam)
{
	var result = true;
	pluginType = tempParam.pluginType
	//加载编辑器
	if (pluginType == "DOC")
	{
		if (!wordDoc(tempParam)) return false;
	}
	else if (pluginType == "GRID")
	{
		if (!girdDoc(tempParam)) return false;
	}
	else
	{
		setMessage("插件创建失败");
		return false;
	}
	if (tempParam.isLeadframe != "1")
	{
		result = doSignleCreate(tempParam);
	}
	else
	{
		result = doMultiplyCreate(tempParam);
	}
	return result;	
}

//单文档创建
function doSignleCreate(tempParam)
{
	var result = false;
	id = IsExitInstance(tempParam.emrDocId,tempParam.templateId);
	/*if (id != "0" && tempParam.chartItemType == "Single")
	{
		setMessage('已经创建该类型病历,不能再次创建!','forbid');
		return result;	
	}*/
	if ((param != "")&&(tempParam.emrDocId == param.emrDocId)&&(tempParam.chartItemType == "Single"))
	{
		setMessage('该类型病历正在创建,不能多次创建!','forbid');
		return result;		
	}
	/*if ((param != "")&&(tempParam.categoryId == param.categoryId)&&(param.isMutex == "1")&&(tempParam.isMutex == "1"))
	{
		setMessage('已经创建该类型病历,不能再次创建!','forbid');
		return result;
	}*/
	if (tempParam.pluginType == "DOC") setWorkEnvironment(tempParam);
	setPatientInfo(); 	                          
	var isMutex = (tempParam.isMutex=="1")?true:false;	
	var isGuideBox = (tempParam.isLeadframe == "1")?true:false;
	setDocTempalte(tempParam.emrDocId,isMutex,isGuideBox); //设置引导框
	createDocument(tempParam);
	result = true;
	return result;
}

///多文档加载
function doMultiplyCreate(tempParam)
{
	var result = false;
	if ((param != "")&&(tempParam.emrDocId == param.emrDocId))
	{
		if (tempParam.actionType == "CREATE")
		{
			focusDocument("GuideDocument","","First");
		}
		else
		{
			if (getModifyStatus().Modified == "True")
		 	{
		 	 	eventQuerySaveDocument();
		 	 	return false;
		 	}
			 createDocument(tempParam);		
		}
	}
	else
	{
		id = IsExitInstance(tempParam.emrDocId,tempParam.templateId);
		if (id != "0")
		{
			tempParam.id = id;
			loadDocument(tempParam); 
			if (tempParam.actionType == "CREATE")
			{
				focusDocument("GuideDocument","","First");
			}
			else
			{
				createDocument(tempParam);	
			}
		}
		else
		{
			if (tempParam.pluginType == "DOC") setWorkEnvironment(tempParam); 
			setPatientInfo();	                          
			var isMutex = (tempParam.isMutex=="1")?true:false;	
			var isGuideBox = (tempParam.isLeadframe == "1")?true:false;
			setDocTempalte(tempParam.emrDocId,isMutex,isGuideBox); //设置引导框	
			if (tempParam.actionType == "CREATE")
			{
				var defaultLoadId = getDefaultLoadId(tempParam.emrDocId,userLocID);
				if (defaultLoadId == "")
				{
					focusDocument("GuideDocument","","First");
				}
				else
				{
					tempParam.actionType = "CREATEBYTITLE";
					tempParam.titleCode = defaultLoadId;
					createDocument(tempParam);
				}
			}
			else
			{
				createDocument(tempParam);	
			}		
		}
	}
	result = true;
	return result;
}

//获取多文档加载未创建时默认加载的titleCode
function getDefaultLoadId(templateCategoryId,locID)
{
	var defaultLoadId = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLTitleConfig",
					"Method":"GetDefaultLoadTitleCode",			
					"p1":templateCategoryId,
					"p2":locID
				},
			success : function(d) {
	           		defaultLoadId = d;
			},
			error : function(d) { alert("GetDefaultLoadTitleCode error");}
		});	
	return defaultLoadId;
}

///打开文档
function doOpen(tempParam)
{
	var result = true;
	pluginType = tempParam["pluginType"];        	
	if (pluginType == "DOC")
	{
		if (!wordDoc(tempParam)) return false;
	}
	else if (pluginType == "GRID")
	{
		if (!girdDoc(tempParam)) return false;
	}
	else
	{
		alert("插件创建失败");
		return false;
	}
	if ((param != "")&&(param.emrDocId == tempParam.emrDocId) && ((param.characteristic != "0") || (param.id == tempParam.id)))
	{
		focusDocument(tempParam.id,"","Last");
	}
	else
	{
		loadDocument(tempParam); 
	}
	return result;
}
///文档是否已经被创建
function IsExitInstance(emrDocId,templateId)
{
	var result = "0";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLInstanceData",
			"Method":"IsHasInstance",
			"p1":episodeID,
			"p2":templateId,
			"p3":emrDocId
		},
		success: function(d) {
			result = d;
		},
		error : function(d) { alert("查数据出错");}
	});
	return result;		
}

//创建word编辑器
function wordDoc(tempParam)
{
	var result = true;
	parent.$('.tooledit').css("display","block");
	if(iword)
	{
		$("#containerGrid").css("display","none");
	}
	$("#containerWord").css("display","block");
	if (!iword)
	{
		var objString = "<object id='pluginWord' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";
	    objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
	    objString = objString + "<param name='product' value='GlobalEMR'/>";
	    objString = objString + "</object>";
	    document.getElementById("containerWord").innerHTML = objString;
		if (!$("#pluginWord")[0]||!$("#pluginWord")[0].valid)
		{
			setUpPlug();
			return;
		} 
		pluginAdd();
		var ret = $("#pluginWord")[0].initWindow("iEditor");
		if (!ret)
		{
			setMessage('创建编辑器失败!','warning');
			result = false;
			return result;
		}              
		var nectresult = setConnect();
		if (nectresult != "" && nectresult.result != "OK")
		{
			setMessage('数据库连接失败!','warning');
			result = false;
			return result;
		} 
		SetDefaultFontStyle();
		iword = true;                             	
		$("#containerGrid").css("display","none");
	}
	return result;
}

//创建gird编辑器
function girdDoc(tempParam)
{
	var result = true;
	parent.$('.tooledit').css("display","none");  //隐藏工具条
	$("#containerWord").css("display","none");
	$("#containerGrid").css("display","block");
	if (!igrid)
	{
		var objString = "<object id='pluginGrid' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'>";         
	    objString = objString + "<param name='install-url' value='" + pluginUrl + "'/>";
	    objString = objString + "<param name='product' value='GlobalEMR'/>";
	    objString = objString + "</object>";
	    document.getElementById("containerGrid").innerHTML = objString;  
		if (!$("#pluginGrid")[0]||!$("#pluginGrid")[0].valid)
		{
			setUpPlug();
			return;
		}  
		pluginAdd(); 
		var ret = $("#pluginGrid")[0].initWindow("iGridEditor");
		if (!ret)
		{
			setMessage('创建编辑器失败!','warning');
			result = false;
			return result;
		}              
		var nectresult = setConnect();
		if (nectresult != "" && nectresult.result != "OK")
		{
			
			setMessage('数据库连接失败!','warning');
			result = false;
			return result;
		}	                      
		igrid = true; 
	}
	return result;
}
//安装插件提示
function setUpPlug (){
	var result = window.showModalDialog("emr.record.downloadplugin.csp?PluginUrl=" +pluginUrl,"","dialogHeight:100px;dialogWidth:200px;resizable:yes;status:no");
	if (result)
	{
		window.location.reload();
	}
};

//查找插件
function plugin() {
	if(pluginType == "DOC")
	{
		return $("#pluginWord")[0];
	}
	else
	{
		return $("#pluginGrid")[0];
	}
}
//挂接插件\事件监听
function pluginAdd() {	
	addEvent(plugin(), 'onFailure', function(command){
		alert(command);
	});
    addEvent(plugin(), 'onExecute', function(command){
	   var commandJson = jQuery.parseJSON(command);
	   eventDispatch(commandJson);
    });
}

//添加监听事件
function addEvent(obj, name, func)
{
    if (obj.attachEvent) 
    {
        obj.attachEvent("on"+name, func);
    }  
    else 
    {
        obj.addEventListener(name, func, false); 
    }
}

//异步执行execute
function cmdDoExecute(argJson){
	plugin().execute(JSON.stringify(argJson));
};

//同步执行execute
function cmdSyncExecute(argJson){
	var result = plugin().syncExecute(JSON.stringify(argJson));
	try
	{
		result = jQuery.parseJSON(result);
	}
	catch(err)
	{
		result = "";
	}
	return result;
}

//建立数据库连接
function setConnect(){
	var strJson = {action:"SET_NET_CONNECT",args:parent.argConnect};
	return cmdSyncExecute(strJson);
}

//设置默认字体
function SetDefaultFontStyle(){
	var strJson = eval("("+"{'action':'SET_DEFAULT_FONTSTYLE','args':{"+setDefaultFontStyle+"}}"+")");
	cmdDoExecute(strJson);
}

//设置工作环境
function setWorkEnvironment(tempParam)
{
	//清空文档
	var argJson = {action:"CLEAN_DOCUMENT",args:""};
	cmdDoExecute(argJson);
	//设置工作空间上下文
	argJson = {action:"SET_WORKSPACE_CONTEXT",args:tempParam["chartItemType"]};
	cmdDoExecute(argJson);
	//设置书写状态
	argJson = {action:"SET_NOTE_STATE",args:"Edit"};
	cmdDoExecute(argJson);
	//设置文字只读颜色
	argJson = {action:"SET_READONLY_COLOR",args:{"color":"0000ff"}};
	cmdDoExecute(argJson);	
}

//设置只读
function setReadOnly(flag,instanceIds)
{
	var argJson = "";
	if (instanceIds == "")
	{
		argJson = {action:"SET_READONLY", args:{"ReadOnly":flag}};
	}
	else
	{
		argJson = {action:"SET_READONLY", args:{"ReadOnly":flag,"InstanceID":instanceIds}};
	}
	cmdDoExecute(argJson);
	//文档只读则不能保存，解锁后恢复文档保存权限
	if (flag==false)
	{
		//取文档信息
		var documentContext = getDocumentContext("");
		//设置当前文档是否可保存
		if(documentContext.privelege.canSave == 1)
		{
			parent.setSaveStatus('enable');
		}
	}
}

//设置患者信息
function setPatientInfo()
{
	var diseaseID = "";
	var argParams = {"PatientID":patientID,"EpisodeID":episodeID,"UserCode":userCode,"SessionID":sessionID,
	               "UserID":userID,"UserName":userName,"SsgroupID":ssgroupID,"UserLocID":userLocID,
	               "DiseaseID":diseaseID,"IPAddress":ipAddress};
    var argJson = {action: "SET_PATIENT_INFO",args:argParams};
    cmdDoExecute(argJson);
    var userLevel = getUserInfo().UserLevel;
    //设置当前操作者信息
    if (isSetCurrentRevisorIP == "N")
    {
	    ipAddress = "";
    }
    setCurrentRevisor(userID,userName,ipAddress,userLevel);
}

//添加或修改病种数据
function setDiseaseData()
{
	var diseaseID = parent.$('#disease').combo('getValue');  //add by niucaicai 2016-09-02
	if (diseaseID == "undefined") diseaseID ="";
	var argJson = {action: "SET_PATIENT_INFO",args:{"DiseaseID":diseaseID}};
	cmdDoExecute(argJson);
}

//创建病历
function createDocument(tempParam)
{
	if (param.emrDocId != tempParam.emrDocId) loadFalg = true;
	var args = "";
	if (tempParam.args) args = tempParam.args;
		
	if (tempParam.actionType == "QUOTATION")
	{
		var strJson = {action:"CREATE_DOCUMENT_BY_INSTANCE",args:{"params":args,"InstanceID":tempParam.pInstanceId,"Title":{"DisplayName":tempParam.text}}};
	}
	else if (tempParam.actionType == "CREATEBYTITLE")
	{
		var strJson = {action:"CREATE_DOCUMENT_BY_TITLE",args:{"params":args,"TitleCode":tempParam.titleCode}};	
	}
	else 
	{
		var strJson = {action:"CREATE_DOCUMENT",args:{"params":args,"Title":{"DisplayName":tempParam.text}}};
	}
	cmdDoExecute(strJson);
}

//加载文档
function loadDocument(tempParam)
{
	if (tempParam.pluginType == "DOC") setWorkEnvironment(tempParam); 
	setPatientInfo();	                          
	if (param.emrDocId != tempParam.emrDocId) loadFalg = true;
	var status = tempParam["status"];
	//加载文档
	var argJson = {action:"LOAD_DOCUMENT",args:{params:{"status":status},InstanceID:tempParam["id"],actionType:tempParam["actionType"]}};
	cmdDoExecute(argJson); 
	
	if (status == "DELETE")
	{
		setReadOnly(true,[tempParam["id"]]);
		parent.setToolBarStatus("disable");
	}
	else
	{
		//设置引导框
		var isMutex = (tempParam["isMutex"]=="1")?true:false;
		var isGuideBox = (tempParam["isLeadframe"] == "1")?true:false;
		if(!checkCreatePrivilege(tempParam,false)) setDocTempalte(tempParam["emrDocId"],isMutex,isGuideBox); 
	} 
}

//加载本地文档
function cmdLoadLocalDocument()
{
	var argJson = {action : "LOAD_LOCAL_DOCUMENT", args:{path:""}};
	cmdDoExecute(argJson);
}


//设置创建模板
function setDocTempalte(emrDocId,isMutex,isGuideBox)
{
	var argJson = {action:"SET_DOCUMENT_TEMPLATE",args:{DocID:emrDocId,IsMutex:isMutex,CreateGuideBox:isGuideBox}};
	cmdDoExecute(argJson);
}

//插入知识库结点
function appendComposite(kbNodeID)
{
   var argJson = {action:"APPEND_COMPOSITE",args:{params:{"action":"LOAD_COMPOSITE","KBNodeID":kbNodeID}}};
   cmdDoExecute(argJson);               
}	

//替换知识库结点
function replaceComposite(kbNodeID)
{
   var argJson = {action:"REPLACE_COMPOSITE",args:{params:{"action":"LOAD_COMPOSITE","KBNodeID":kbNodeID}}};
   cmdDoExecute(argJson);  
}

//判断当前光标在文档中的位置	
function getElementContext(position)
{
   var argJson = {action:"GET_ELEMENT_CONTEXT",args:{"Type":position}};
   var result = plugin().syncExecute(JSON.stringify(argJson))
   return result;
}

//插入文本
function insertText(text)
{
	var argJson = {action:"INSERT_TEXT_BLOCK",args:text};
	cmdDoExecute(argJson); 
}

//插入带格式文本
function insertStyleText(text)
{ 
	var argJson = {action:"INSERT_STYLE_TEXT_BLOCK",args:text};
	cmdDoExecute(argJson); 
}

//定位文档
function focusDocument(instanceId,path,actionType)
{
	var argJson = {action:"FOCUS_ELEMENT",args:{"InstanceID":instanceId,"Path":path,"actionType":actionType}}
	cmdDoExecute(argJson);
}
//签名
function signDocument(instanceId,type,signLevel,userId,userName,Image,actionType,description,headerImage,fingerImage)
{
	var argJson = {action:"SIGN_DOCUMENT",args:{"InstanceID":instanceId,"Type":type,"SignatureLevel":signLevel,"actionType":actionType,"Authenticator":{"Id":userId,"Name":userName,"Image":Image,"Description":description, "HeaderImage":headerImage,"FingerImage":fingerImage},"params":{}}}
	return cmdSyncExecute(argJson);
}
//获取活动文档上下文
function getDocumentContext(instanceId)
{
	var argJson = {action:"GET_DOCUMENT_CONTEXT",args:{"InstanceID":instanceId}};
	return cmdSyncExecute(argJson);
}
//请求目录大纲
function getOutLine()
{
	var argJson = {"action":"GET_DOCUMENT_OUTLINE","args":""}
	cmdDoExecute(argJson);
}

//获取文档是否被修改过
function getModifyStatus()
{
	var argJson = {action:"CHECK_DOCUMENT_MODIFY",args:""};
	return cmdSyncExecute(argJson);
}

//同步运行脚本
function runSyncScript(scripts) {
    var strJson = {action:"RUN_SCRIPT",args:{Script:scripts}};
    return cmdSyncExecute(strJson);
}

//标注必填项
function markRequiredObject()
{
	var strJson = {action:"MARK_REQUIRED_OBJECTS",args:{"Mark":"True"}};
	return cmdSyncExecute(strJson);
}

//刷新绑定数据
function reloadBinddata(autoRefresh,syncDialogVisible,silentRefresh)
{
	if (typeof(param) == "undefined" || param.id == "GuideDocument") return;
	
	var argJson = {"action":"REFRESH_REFERENCEDATA","args":{"InstanceID":"","AutoRefresh":autoRefresh,"SyncDialogVisible":syncDialogVisible,"SilentRefresh":silentRefresh}};
	cmdDoExecute(argJson);
	
	//基础平台日志
	setOperationLog(param,"EMR.BinddataReload");
	
}

//导出文档
function exportDocument()
{
	if (!param || param.id == "GuideDocument")
	{
		setMessage('请选中要导出的文档!','forbid');
		return;
	}
	var argJson = {"action":"SAVE_LOCAL_DOCUMENT","args":{}};
	cmdDoExecute(argJson);	
}

//设置文档参数
function setDocumentParam(id,actionType,params)
{
	var argJson = {"action":"SET_DOCUMENT_PARAMS","args":{"InstanceID":id,"actionType":actionType,"params":params}};
	cmdDoExecute(argJson);
}

//设置留痕基本信息
function setCurrentRevisor(userID,userName,ip,userLevel)
{
	var argJson = {"action":"SET_CURRENT_REVISOR","args":{"Id":userID, "Name":userName,"IP":ip,"Level":userLevel}};
	cmdDoExecute(argJson);		
}

//设置开启关闭留痕
function setRevisionState(InstanceId,status)
{
	var argJson = {action:"SET_REVISION_STATE", args:{"InstanceID":InstanceId,"Mark":status}};
	return cmdSyncExecute(argJson);
}

//显示留痕
function viewRevision(status)
{
	var argJson = {action:"SET_REVISION_VISIBLE",args: {"Visible":status}}
	cmdDoExecute(argJson);
}

//设置ASR语音识别状态
function setASRVoiceStatus(status)
{
	var argJson = {action:"SET_ASR_VOICE_STATE",args:{"Open":status}};
	cmdDoExecute(argJson);
}

//修改或追加单元内容
function updateInstanceData(actiontype,instanceID,path,value) {
    var strJson = {action: "UPDATE_INSTANCE_DATA",args: {"actionType":actiontype,"InstanceID":instanceID,"Path":path,"Value":value}};
    cmdDoExecute(strJson);
}

//保存文档
function cmdsaveDocument()
{
	var argJson = {action:"SAVE_DOCUMENT", "args":{"params":{"action":"SAVE_DOCUMENT"}}};
	cmdDoExecute(argJson);		
}

///失效签名
function cmdRevokeSignedDocument(signatureLevel,instanceId)
{
	var argJson = {"action":"REVOKE_SIGNED_DOCUMENT","args":{"SignatureLevel":signatureLevel,"InstanceID":instanceId}};
	return cmdSyncExecute(argJson);
}

//保存签名文档及相关操作
function saveSignDocument(instanceId,signUserId,signLevel,signId,digest,type,path,actionType)
{
	var argJson = {action:"SAVE_SIGNED_DOCUMENT",args:{params:{"action":"SAVE_SIGNED_DOCUMENT","SignUserID":signUserId,"SignID":signId,"SignLevel":signLevel,"Digest":digest,"Type":type,"Path":path,"ActionType":actionType},"InstanceID":instanceId}}
	cmdDoExecute(argJson);
}

//回滚签名
function unsignDocument()
{
	var argJson = {action:"UNSIGN_DOCUMENT",args:{}}
	cmdDoExecute(argJson);	
}

//撤销签名
function revokeSignElement(signProperty)
{
	var argJson = {"action":"REVOKE_SIGNED_ELEMENT","args":{"Path":signProperty.Path,params:{"Authenticator":{"Id":signProperty.Id,"Name":signProperty.Name,"Path":signProperty.Path,"SignatureLevel":signProperty.SignatureLevel}}}};
	return cmdSyncExecute(argJson);
}

//打印文档
function printDocument()
{
	if (getModifyStatus().Modified == "True")
	{
		var text = '文档正在编辑，请保存后打印，是否保存？';
		//判断客户端浏览器IE及其版本
		if ($.browser.msie && $.browser.version == '6.0')
		{
			returnValues = window.showModalDialog("emr.prompt.csp",text,"dialogHeight:180px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
		}else
		{
			returnValues = window.showModalDialog("emr.prompt.csp",text,"dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
		}
		if (returnValues == "save")
		{
			saveDocument();
		}
		else
		{
			return;
		}
	} 
	var qualityResult = qualityPrintDocument();
	if (qualityResult) return; 
	//取文档信息
	var documentContext = getDocumentContext("");
	if (documentContext.status.curAction == "print")
	{
		var text = '病历 "'+ param.text + '"已打印，是否确认继续打印！';
		var Values = "";
		if ($.browser.msie && $.browser.version == '6.0')
		{
			Values = window.showModalDialog("emr.printprompt.csp",text,"dialogHeight:180px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
		}else
		{
			Values = window.showModalDialog("emr.printprompt.csp",text,"dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
		}
		if (Values == "cancel") return;
	}
	//打印
	var argJson = {action:"PRINT_DOCUMENT",args:{"actionType":"Print"}}; 
 	cmdDoExecute(argJson);	
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
					"OutputType":"String",
					"Class":"EMRservice.HISInterface.QualityInterface",
					"Method":"QualityInterfaceCheck",			
					"p1":episodeId,
					"p2":eventType,
					"p3":templateId,
					"p4":instanceId
				},
			success: function(d) {
					result = d;
			},
			error : function(d) { alert("GetSummery error");}
		});	
	return result;	
}

//保存文档
function saveDocument()
{
	var flag = "save"
	//取文档信息
	var documentContext = getDocumentContext("");
	var modifyResult = getModifyStatus();
	//判断病历被修改且上一次操作是打印,则弹出病历已打印的提醒框
	if ((documentContext.status.curAction == "print")&&(modifyResult.Modified == "True"))
	{
		var text = '病历 "' +param.text + '" 已打印，是否确认保存修改！';
		var Values = "";
		if ($.browser.msie && $.browser.version == '6.0')
		{
			Values = window.showModalDialog("emr.printprompt.csp",text,"dialogHeight:180px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
		}else
		{
			Values = window.showModalDialog("emr.printprompt.csp",text,"dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
		}
		if (Values == "cancel") return;
	}
	if (isRevokeSign == "Y")
	{
		if (revokeSignedDocument(modifyResult)) flag = "revoke";
	}
	else
	{
		cmdsaveDocument();
	}
	return flag;
}

///撤销签名
function revokeSignedDocument(modifyResult)
{
	var result = false;
	var noSign = false;
	if (modifyResult.Modified == "False") checkRequiredCell();
	for (var i=0;i<modifyResult.InstanceID.length;i++)
	{
		var instanceId = modifyResult.InstanceID[i];
		var documentContext = getDocumentContext(instanceId);
		var userLevel = getUserInfo().UserLevel;
		if (revokeStatus()!= "Superior") userLevel = "";
		var revokeResult = cmdRevokeSignedDocument(userLevel,instanceId);
		if (revokeResult.result == "ERROR")
		{
			setMessage('失效文档失败!','warning');
			noSign = false;
			break;
		}
		else
		{
			if( typeof(revokeResult.Authenticator) == "undefined" || revokeResult.Authenticator.length<=0) 
			{
				noSign = true;
				continue;	
			}
			result = true;
			var tmpDocContext = getDocumentContext(instanceId);
			if (tmpDocContext.result == "ERROR") return;

			//设置当前文档操作权限
			setPrivelege(tmpDocContext);
		    //当前文档状态
		    setStatus(tmpDocContext);

			//修改文档目录
			modifyListRecord(tmpDocContext);
			setMessage('数据保存成功,签名已失效!','alert');
			
			//启用病历信息订阅与发布
			if (Observer == "Y") GetObserverData();

			//质控
			qualitySaveDocument();
			
			//getNewMenu();
			initCategory();
			
			//保存日志(基础平台组)
			setOperationLog(param,"EMR.Save");	
		}	
	}
	if (noSign)
	{
		cmdsaveDocument();
	}
    return result; 
}

///当前用户信息
function getUserInfo()
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRSign",
			"Method":"GetUserInfo",
			"p1":userCode,
			"p2":"",
			"p3":userLocID
		},
		success: function(d) {
			result = eval("("+d+")");
			if (signLogic == "Custom")
			{
				var temp =  getEpisodeThreeDoctor(result);
				if (temp.flag == 1)
				{
					result = temp.userInfo;
				}
			}			
		},
		error: function(d) {alert("error");}
	});	
	return result;	
}

//是否调用签名失效
function revokeStatus()
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.SystemParameter",
			"Method":"GetRevokeStatus"
		},
		success: function(d) {
			result = d;
		},
		error: function(d) {alert("error");}
	});	
	return result;	
}

//文档保存质控
function qualitySaveDocument()
{
	var result = false;
	result = checkRequiredCell();
	if (result == true) 
	{
		setMessage('有未完成项目,请检查!','forbid');
		return result;
	}
	//打散数据质控
	var eventType = "Save^" + ssgroupID + "^" + userLocID;
	var qualityData = qualityCheck(episodeID,param.id,param.templateId,eventType)
	if (qualityData != "")
	{
		var pos = qualityData.indexOf("^");
		var controlType = qualityData.substring(0,pos);
        var strQualityData = qualityData.substring(pos+1);
        if (strQualityData != "")
        {
			var strQualityData = strQualityData.replace(new RegExp(';','gm'),'\n')
			alert(strQualityData);
			if (controlType == "0") 
			{
				result = true;
				return result;
			}
        }
	}
	return result;	
}

//签名质控
function qualitySignDocument()
{
	var result = false;
	result = checkRequiredCell();
	if (result == true) 
	{
		setMessage('有未完成项目不能签名,请处理!','forbid');
		return result;
	}	
	var eventType = "Commit^" + ssgroupID + "^" + userLocID;
	var qualityData = qualityCheck(episodeID,param.id,param.templateId,eventType)
	if (qualityData != "")
	{
		var pos = qualityData.indexOf("^");
		var controlType = qualityData.substring(0,pos);
        var strQualityData = qualityData.substring(pos+1);
        if (strQualityData != "")
        {
			alert(strQualityData);
			if (controlType == "0") 
			{
				result = true;
				return result;
			}
        }
	}
	return result;	
}

//打印质控
function qualityPrintDocument()
{
	var result =  false;
	result = checkRequiredCell();
	if (result == true) 
	{
		setMessage('有未完成项目不能打印,请处理','forbid');
		return result;
	}
	//病历质控
	var eventType = "Print^" + ssgroupID + "^" + userLocID;
	var qualityData = qualityCheck(episodeID,param.id,param.templateId,eventType)
	if (qualityData != "")
	{
		var pos = qualityData.indexOf("^");
		var controlType = qualityData.substring(0,pos);
        var strQualityData = qualityData.substring(pos+1);
        if (strQualityData != "")
        {
			alert(strQualityData);
			if (controlType == "0") 
			{
				result = true;
				return result;
			}
        }
	}
	return result;	
}

///检查必填项
function checkRequiredCell()
{
	var result =  false;
	if ((requiredFlag.Grid == "1")&&(param.pluginType == "GRID")||(requiredFlag.Word == "1")&&(param.pluginType == "DOC"))
	{
		//脚本检查
		var resultMarkRequired = markRequiredObject();
		if (resultMarkRequired.MarkCount>0) result = true;
	}
	return result;
}

// 打开签名窗口
function audit(signProperty)
{
	var qualityResult = qualitySignDocument();
	if (qualityResult) return; 
	var documentContext = getDocumentContext("");
    var canRevokCheck = documentContext.privelege.canRevokCheck;
    if (pluginType != "GRID") canRevokCheck =0;
    var tmpInstanceId = signProperty.InstanceID;
    var openFlag = episodeType=="O"?"0":"1";
   	if (signProperty.OriSignatureLevel.toUpperCase() == 'PATIENT') 
   	{
		var argEditor = {
			instanceId: tmpInstanceId,
			signDocument: signDocument,
			saveSignedDocument: saveSignDocument
		};
		handSign.sign(argEditor);
		return;
	}
	if ('1' == CAServicvice) 
	{
		var signParam = {"topwin":window,"canRevokCheck":canRevokCheck,"cellName":signProperty.Name};
		var returnValues = window.showModalDialog("emr.record.signca.csp?UserID="+userID+"&OpenFlag="+openFlag+"&UserLocID="+userLocID,signParam,"dialogHeight:150px;dialogWidth:300px;resizable:yes;status:no");
		if (returnValues != "" && returnValues != undefined)
		{
			returnValues = eval("("+returnValues+")");
			userInfo = returnValues.userInfo;
			if ((userInfo.UserLevel == "")&&(userInfo.UserPos == ""))
			{
				setMessage('请先维护用户级别','forbid');
				return;	
			}
			if (returnValues.action == "sign")
			{
				if (userInfo.Type == "Graph" && userInfo.Image == "")
				{
					setMessage('签名图片未维护，请维护','forbid');
					return;
				}	
				caSign(signProperty,userInfo,tmpInstanceId);
			}
			else if (returnValues.action == "revoke")
			{
				if (userInfo.UserID != signProperty.Id)
				{
					setMessage('非本人签名,不能撤销','forbid');
					return;
				}
				var ret = revokeSignElement(signProperty);
				if (ret.result == "OK")
				{
					setMessage('撤销成功','alert');
				}
				else
				{
					setMessage('撤销失败','warning');
				}
			}	
		}
	}
	else
	{
		var signParam = {"canRevokCheck":canRevokCheck,"cellName":signProperty.Name};
		var returnValues = window.showModalDialog("emr.record.sign.forinsu.csp?UserName="+userName+"&UserCode="+userCode+"&UserLocID="+userLocID+"&PasswordType=INSU",signParam,"dialogHeight:220px;dialogWidth:300px;resizable:yes;status:no");
		if (returnValues != "" && returnValues != undefined)
		{
			returnValues = eval("("+returnValues+")");
			userInfo = returnValues.userInfo;	
			if ((userInfo.UserLevel == "")&&(userInfo.UserPos == ""))
			{
				setMessage('请先维护用户级别','forbid');
				return;	
			}		
			if (returnValues.action == "sign")
			{
				if (userInfo.Type == "Graph" && userInfo.Image == "")
				{
					setMessage('签名图片未维护，请维护','forbid');
					return;
				}
				checkSign(signProperty,userInfo,tmpInstanceId,documentContext);	
			}
			else if (returnValues.action == "revoke")
			{
				if (userInfo.UserID != signProperty.Id)
				{
					setMessage('非本人签名,不能撤销','forbid');
					return;
				}
				var ret = revokeSignElement(signProperty);
				if (ret.result == "OK")
				{
					setMessage('撤销成功','alert');
				}
				else
				{
					setMessage('撤销失败','warning');
				}
			}
			
		}
	}
}

//数字签名
function caSign(signProperty,userInfo,instanceId)
{
	//权限检查
	var checkresult = checkPrivilege(userInfo,signProperty);
	if(!checkresult.flag) return;

	//开始签名
	var cert = parent.GetSignCert(parent.strKey);
    var UsrCertCode = parent.GetUniqueID(cert);
    if (!UsrCertCode || '' == UsrCertCode) return '用户唯一标示为空！';
    
	var signlevel = signProperty.SignatureLevel;
	var actionType = checkresult.ationtype;
    if (signProperty.OriSignatureLevel == "Check") signlevel = userInfo.UserLevel
	var signInfo = signDocument(instanceId,userInfo.Type,signlevel,userInfo.UserID,userInfo.UserName,userInfo.Image,actionType,userInfo.LevelDesc,"","");

    if (!signInfo.Digest || signInfo.Digest == "") 
    {
	    alert('签名原文为空！');
	    return ;
	}
    var signValue = parent.SignedData(signInfo.Digest,parent.strKey);
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        cache: false,
        data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRSign",
			"Method":"Sign",
			"p1":UsrCertCode,
			"p2":signValue,
			"p3":signInfo.Digest
        },
        success: function(ret) {
            if (ret && ret.Err) 
            {
                setMessage(ret.Err,'forbid');
            } 
            else 
            {
                saveSignDocument(instanceId,userInfo.UserID,signlevel,ret.SignID,signInfo.Digest,"CA",signInfo.Path,actionType)
				//签名成功后，判断是否需要发送消息给Portal系统
				/*if (IsSetToPortal == "Y")
				{
					setInfoToPortal(userInfo.UserID);
				}*/
            }
        },
        error: function(ret) {alert(ret);}
    });
}

//系统签名
function checkSign(signProperty,userInfo,instanceId,documentContext)
{
	//权限检查
	var checkresult = checkPrivilege(userInfo,signProperty);
	if(!checkresult.flag) return;
	var signlevel = signProperty.SignatureLevel;
	var actionType = checkresult.ationtype;	
	if ((actionType == "Append" && documentContext.privelege.canCheck == 0) || (actionType == "Replace" && documentContext.privelege.canReCheck == 0))
	{
		setMessage("没有权限签名",'forbid');
		return
	}
	
	//开始签名
    if (signProperty.OriSignatureLevel == "Check") signlevel = userInfo.UserLevel
	var signInfo = signDocument(instanceId,userInfo.Type,signlevel,userInfo.UserID,userInfo.UserName,userInfo.Image,actionType,userInfo.LevelDesc,"","");
	if (signInfo.result == "OK")
	{
		saveSignDocument(instanceId,userInfo.UserID,signlevel,"","","SYS",signInfo.Path,actionType);
		
		//签名成功后，判断是否需要发送消息给Portal系统
		/*if (IsSetToPortal == "Y")
		{
			setInfoToPortal(userInfo.UserID);
		}*/
	}
	else
	{
		setMessage('签名失败','warning');
	}		
}

///取为患者设定的三级医师
function getEpisodeThreeDoctor(userInfo)
{
	var result = {};
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRSign",
			"Method":"GetThreeLevelDoctor",
			"p1":episodeID
        },
        success: function(ret) {
            if (ret == "")
            {
	            result.flag = "0";
	            result.message = "没维护三级医师";
	            return result;
	        } 
			for (var i=0;i<ret.length;i++)
			{
				if (ret[i].Id == userInfo.UserID) 
				{
					userInfo.UserLevel = ret[i].level;
					userInfo.LevelDesc = ret[i].desc;
					result.flag = "1";
					result.message = "";
					result.userInfo = userInfo;
					break;
				}
			}
			if (result.flag ==undefined || result.flag != "1")
			{
				result.flag = "0";
				result.message = "该用户不是该患者的责任医师,无权限签名";
			}

        },
        error: function(ret) {alert(ret);}
    });
    return result;	
}

//检查签名权限脚本
function checkPrivilege(userInfo,signProperty)
{
	var result = {"flag":false,"ationtype":""};
	if (signLogic == "Custom")
	{
		var tempResult = getEpisodeThreeDoctor(userInfo);
		if (tempResult.flag !== "1") 
		{
			setMessage(tempResult.message,'forbid');
	   		return result;	
		}
		else
		{
			userInfo = tempResult.userInfo; 
		}
	}	
	var count = signProperty.Authenticator.length;
	if (count >0 && signProperty.Id == userInfo.UserID)
	{
		result = {"flag":false,"ationtype":""};
		setMessage('已签名,不必再签','forbid');
	    return result;
	}
	
	var signArray = ["All","QCDoc","QCNurse","ChargeNurse","student","intern","Refresher","Coder"];
	
	if ($.inArray(signProperty.OriSignatureLevel, signArray) != -1)
	{
		if (count>0)
		{
			//改签
			if (confirm("已签名，是否改签")==true)
			{
				result = {"flag":true,"ationtype":"Replace"};
			}
			else
			{
				result = {"flag":false,"ationtype":""};
			}
		}
		else
		{
			//签名
			 result = {"flag":true,"ationtype":"Append"};
		}
	}
	else if (signProperty.OriSignatureLevel == "Check")
	{
		if (count <=0)
		{
			//签名
			result = {"flag":true,"ationtype":"Append"};
		}
		else
		{
			if (userInfo.UserLevel == "student")
			{
				if (count == 1 && signProperty.SignatureLevel == "student")
				{
					//改签
					if (confirm("已签名，是否改签")==true)
					{
						result = {"flag":true,"ationtype":"Replace"};
					}
					else
					{
						result = {"flag":false,"ationtype":""};
					}
				}
				else
				{
					//无权限签
					result = {"flag":false,"ationtype":""};
					setMessage("无权限签名","forbid");
				}
	
			}
			else if (userInfo.UserLevel == "intern")
			{
				if (count == 1 && signProperty.SignatureLevel == "intern")
				{
					//改签
					if (confirm("已签名，是否改签")==true)
					{
						result = {"flag":true,"ationtype":"Replace"};
					}
					else
					{
						result = {"flag":false,"ationtype":""};
					}
				}
				else
				{
					//无权限签
					result = {"flag":false,"ationtype":""};
					setMessage("无权限签名","forbid");
				}
	
			}	
			else if (userInfo.UserLevel == "Resident")
			{
				var flag = 0
				for (var i=0;i<count;i++)
				{
					if ($.inArray(signProperty.Authenticator[i].SignatureLevel,["Attending","ViceChief","Chief"]) != -1)
					{
						flag = 1
						break;
					} 
				}
				
				if (flag == 1)
				{
					//无权限签
					result = {"flag":false,"ationtype":""};
					setMessage("无权限签名","forbid");
					return result;
				}
				
				flag = 0
				for (var i=0;i<count;i++)
				{
					if (signProperty.Authenticator[i].SignatureLevel == "Resident")
					{
						flag = 1
						break;
					} 
				}
				
				if (flag != 1)
				{
					//签名
					result = {"flag":true,"ationtype":"Append"};		
				}
				else if (signProperty.SignatureLevel == "Resident")
				{
					//改签
					if (confirm("已签名，是否改签")==true)
					{
						result = {"flag":true,"ationtype":"Replace"};
					}
					else
					{
						result = {"flag":false,"ationtype":""};
					}
				}
				else
				{
					//无权限签
					result = {"flag":false,"ationtype":""};
					setMessage("无权限签名","forbid");
				}
			}
			else if (userInfo.UserLevel == "Attending")
			{
				var flag = 0
				for (var i=0;i<count;i++)
				{
					if ($.inArray(signProperty.Authenticator[i].SignatureLevel,["ViceChief","Chief"]) != -1)
					{
						flag = 1
						break;
					} 
				}
				
				if (flag == 1)
				{
					//无权限签
					result = {"flag":false,"ationtype":""};
					setMessage("无权限签名","forbid");
					return result;
				}
				
				flag = 0
				for (var i=0;i<count;i++)
				{
					if (signProperty.Authenticator[i].SignatureLevel == "Attending")
					{
						flag = 1
						break;
					} 
				}
				
				if (flag != 1)
				{
					//签名
					result = {"flag":true,"ationtype":"Append"};		
				}
				else if (signProperty.SignatureLevel == "Attending")
				{
					//改签
					if (confirm("已签名，是否改签")==true)
					{
						result = {"flag":true,"ationtype":"Replace"};
					}
					else
					{
						result = {"flag":false,"ationtype":""};
					}
				}
				else
				{
					//无权限签
					result = {"flag":false,"ationtype":""};
					setMessage("无权限签名","forbid");
				}
			}			
			else if ($.inArray(userInfo.UserLevel,["Chief","ViceChief"]) != -1)
			{
				var flag = 0
				for (var i=0;i<count;i++)
				{
					if ($.inArray(signProperty.Authenticator[i].SignatureLevel,["Chief","ViceChief"]) != -1)
					{
						flag = 1
						break;
					} 
				}
				if (flag != 1)
				{
					//签名
					result = {"flag":true,"ationtype":"Append"};		
				}
				else if ($.inArray(signProperty.SignatureLevel,["Chief","ViceChief"]) != -1)
				{
					//改签
					if (confirm("已签名，是否改签")==true)
					{
						result = {"flag":true,"ationtype":"Replace"};
					}
					else
					{
						result = {"flag":false,"ationtype":""};
					}
				}
				else
				{
					//无权限签
					result = {"flag":false,"ationtype":""};
					setMessage("无权限签名","forbid");
				}				
			}
		}
	}
	else if(signProperty.OriSignatureLevel == "Resident")
	{
		//住院医师签名可签上级
		if ($.inArray(userInfo.UserLevel,["Chief","ViceChief","Attending","Resident"]) != -1)
		{
			if (count <=0)
			{
				//签名
				result = {"flag":true,"ationtype":"Append"};		
			}
			else
			{
				//改签
				if (confirm("已签名，是否改签")==true)
				{
					result = {"flag":true,"ationtype":"Replace"};
				}
				else
				{
					result = {"flag":false,"ationtype":""};
				}	
			}	
		}
		else
		{
			//无权限签
			result = {"flag":false,"ationtype":""};
			setMessage("无权限签名","forbid");			
		}
	}
	else if (signProperty.OriSignatureLevel == "Attending")
	{
		//住治医师签名可签上级
		if ($.inArray(userInfo.UserLevel,["Attending","ViceChief","Chief"]) != -1)
		{
			if (count <=0)
			{
				//签名
				result = {"flag":true,"ationtype":"Append"};		
			}
			else
			{
				//改签
				if (confirm("已签名，是否改签")==true)
				{
					result = {"flag":true,"ationtype":"Replace"};
				}
				else
				{
					result = {"flag":false,"ationtype":""};
				}	
			}	
		}
		else
		{
			//无权限签
			result = {"flag":false,"ationtype":""};
			setMessage("无权限签名","forbid");			
		}	
	}
	else if ($.inArray(signProperty.OriSignatureLevel,["ViceChief","Chief"]) != -1)
	{
		//主任副主任可签
		if ($.inArray(userInfo.UserLevel,["ViceChief","Chief"]) != -1)
		{
			if (count <=0)
			{
				//签名
				result = {"flag":true,"ationtype":"Append"};		
			}
			else
			{
				//改签
				if (confirm("已签名，是否改签")==true)
				{
					result = {"flag":true,"ationtype":"Replace"};
				}
				else
				{
					result = {"flag":false,"ationtype":""};
				}	
			}	
		}
		else
		{
			//无权限签
			result = {"flag":false,"ationtype":""};
			setMessage("无权限签名","forbid");			
		}		
	}
	else 
	{
		if (signProperty.OriSignatureLevel != userInfo.UserLevel && signProperty.OriSignatureLevel != userInfo.UserPos)
		{
			//无权限签
			result = {"flag":false,"ationtype":""};
			setMessage("签名身份不符，无权限签名","forbid");
		}
		else if (count > 0)
		{
			//改签
			if (confirm("已签名，是否改签")==true)
			{
				result = {"flag":true,"ationtype":"Replace"};
			}
			else
			{
				result = {"flag":false,"ationtype":""};
			}
		}
		else
		{
			//签名
			result = {"flag":true,"ationtype":"Append"};		
		}
	}
	return result;	
}

//设置权限
function setPrivelege(documentText)
{
	if (documentText == null) return;
	if (documentText.result == "ERROR") return;
	if (documentText.status.curStatus == "deleted") return;
	
	var privelegeJson = {"action":"setToolbar","status":documentText.privelege};
	//设置工具条件
	eventSetToolbar(privelegeJson);
	
	if (documentText.privelege.canSave == "0")
	{
		setReadOnly(true,documentText.InstanceID);
	}	
}

//设置状态
function setStatus(documentText)
{
	if (documentText == null) return;
	if (documentText.result == "ERROR") return;
	curStatus = documentText.status.curStatus;			
}

//删除病历
function deleteDocument()
{
	var documentContext = getDocumentContext("");
	if (documentContext.result == "ERROR")
	{
		setMessage('请先选中文档再删除!','warning');
		return;
	}
	var instanceId = documentContext.InstanceID;
	var titleName = documentContext.Title.DisplayName;
	var status = documentContext.status.curStatus;	
	if (status == undefined)
	{
		setMessage('请先选中文档再删除!','warning');
		return;
	}
	var tipMsg = "是否确定删除 "+titleName+"?";
	var flag= false;
	if (isFavoriteRecord(instanceId))
	{
		flag = true;
		tipMsg = titleName+" 曾经被收藏过,是否确定删除？";
		if (!window.confirm(tipMsg)) return;
	}
	//签名状态提醒
	if ((status != "finished")&&(status != "")&&(status != "deleted"))
	{
		flag = true;
		tipMsg = titleName+" 已经签名,是否确定删除？";
		if (!window.confirm(tipMsg)) return;
	}
	//普通删除提醒
	if (!flag)
	{
		if (!window.confirm(tipMsg)) return;
	}
	if (isDeleteVerification == "Y")
	{
		var creatorMessage = getCreatorMessage(instanceId);
		if (creatorMessage != "")
		{
			if ((creatorMessage[0].creatorID != "")&&(creatorMessage[0].creatorName != ""))
			{	
				var result = window.showModalDialog("emr.userverification.delete.csp?UserID="+creatorMessage[0].creatorID+"&UserName="+creatorMessage[0].creatorName,"","dialogHeight:200px;dialogWidth:180px;resizable:no;status:no");
				if ((result == "")||(typeof(result) == "undefined")) 
				{
					return;
				}
				else if(result == "0")
				{
					alert("密码验证失败");
					return;
				}
			}
		}
	}
	if (param.IsActive != "N") param.IsActive = "N";
	var json = {action:"DELETE_DOCUMENT",args:{"InstanceID":instanceId}};
	cmdDoExecute(json);	
}

//提示当前病例是否被收藏
function isFavoriteRecord(instanceId)
{
	var result = false;
	$.ajax({
		type: "GET",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLFavInformation",
			"Method":"SearchFavRecord",
			"p1":patientNo,
			"p2":userID,
			"p3":episodeID,
			"p4":instanceId
		},
		success: function (data){
			if (data == "1")
			{
				result = true;
			}
		 }
	});
	return result;	
}

//获取当前病历创建者code和name
function getCreatorMessage(instanceId)
{
	var result = "";
	$.ajax({
		type: "GET",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRLogs",
			"Method":"GetCreatorMessage",
			"p1":instanceId
		},
		success: function (data){
			if (data != "")
			{
				result = eval("["+data+"]");
			}
		 }
	});
	return result;	
}

//事件派发
function eventDispatch(commandJson)
{
	if(commandJson["action"] == "eventMRSetView")                   
	{
		//创建网格视图完毕加载网格文档
	    eventCreatorReportorView();
	}
	else if(commandJson["action"] == "eventDocumentChanged")        
	{
		//文档改变
		eventDocumentChanged(commandJson);
	}
	else if(commandJson["action"] == "eventSectionChanged")          
	{ 
		//章节改变
		eventSectionChanged(commandJson);
	}
	else if (commandJson["action"] == "eventSaveDocument")      
	{
		//保存监听
		eventSaveDocument(commandJson);
	}
	else if (commandJson["action"] == "eventQuerySaveDocument")
	{
		//提示用户保存文档
		eventQuerySaveDocument();
	}
	else if (commandJson["action"] == "eventGetDocumentOutline")
	{
		//获得文档大纲
		eventGetDocumentOutline(commandJson);
	}	
	else if(commandJson["action"] == "eventCreateDocument")
	{
		//创建文档后事件
		eventCreateDocument(commandJson);
	}
	else if(commandJson["action"] == "eventSaveSignedDocument")
	{
		//文档签名
		eventSaveSignedDocument(commandJson);
	}
	else if(commandJson["action"] == "eventDeleteDocument")
	{
		eventDeleteDocument(commandJson);
	}
	else if(commandJson["action"] == "eventSave")
	{
		//ctrl+s保存事件
		eventSave();
	}
	else if (commandJson["action"] == "eventInsertSummary")
	{
		eventInsertSummary(commandJson);
	}
	else if (commandJson["action"] == "eventCaretContext")
	{
		//eventCaretContext(commandJson);
	}
	else if (commandJson["action"] == "eventLoadDocument")
	{
		eventLoadDocument(commandJson);
	}
	else if (commandJson["action"] == "eventPrintDocument")
	{
		eventPrintDocument(commandJson);
	}
	else if(commandJson["action"] == "eventSendCopyCutData")
	{
		eventSendCopyCutData(commandJson);
	}
	else if (commandJson["action"] == "eventSaveLocalDocument")
	{
		eventSaveLocalDocument(commandJson);
	}
	else if (commandJson["action"] == "eventRequestSign")
	{
		eventRequestSign(commandJson);
	}
	else if (commandJson["action"] == "eventReplaceComposite")
	{
		//判断知识库是否替换成功
		eventReplaceView(commandJson);
	}
	else if (commandJson["action"] == "eventRefreshReferenceData")
	{
		//刷新引用数据
		eventRefreshReferenceData(commandJson);
	}
	else if(commandJson["action"] == "eventHyperLink")
	{
		//连接单元
		eventHyperLink(commandJson);
	}
	else if(commandJson["action"] == "eventUpdateInstanceData")
	{
		eventUpdateInstanceData(commandJson);
	}
	else if(commandJson["action"] == "insertText")
	{
		insertText(commandJson["text"]); 
	}
	else if(commandJson["action"] == "appendComposite")
	{
		appendComposite(commandJson["NodeID"]);
	}
}

//同步绑定数据之后自动保存（南方医院个性化需求）
function eventRefreshReferenceData(commandJson)
{
	saveDocument();
}

//判断知识库是否替换成功
function eventReplaceView(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
		setMessage('知识库替换成功!','alert');
	}
	else
	{
		setMessage('知识库替换失败!','warning');
	}
}

//文档导出
function eventSaveLocalDocument(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
		//基础平台组审计和日志记录
		setOperationLog(param,"EMR.Export.Save");	
	}
}

//文档改变事件
function eventDocumentChanged(commandJson)
{
	//更新当前实例文档ID
	param.id = commandJson["args"]["InstanceID"]; 
	//更新当前标题
	titleCode = commandJson["args"]["Title"]["Code"];
	//取文档信息
	var documentContext = getDocumentContext(param.id);
	//设置当前文档操作权限
	setPrivelege(documentContext);
    //当前文档状态
    setStatus(documentContext);
	//选中当前文档目录
	//setSelectRecordColor(param.id);
}

//章节改变事件
function eventSectionChanged(commandJson)
{
	//刷新知识库
    var paramJson = {"action":"reflashKBNode","code":commandJson["args"]["Code"],bindKBBaseID:commandJson["args"]["BindKBBaseID"],"titleCode":titleCode,"diseaseID":"0"};
    reflashKBNode(paramJson);
	//定位章节
    var path = commandJson["args"]["InstanceID"]+"_"+commandJson["args"]["Path"];
    if (path == "") return;
    //focusOutLine(path);
}
//保存事件监听
function eventSaveDocument(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
	    if (commandJson["args"]["params"]["result"] == "OK")
	    { 
			//取文档信息
			param.id = commandJson["args"]["params"]["InstanceID"];
			var documentContext = getDocumentContext(param.id);
			if (documentContext.result == "ERROR") return;
			
			//设置当前文档操作权限
			setPrivelege(documentContext);
		    //当前文档状态
		    setStatus(documentContext);
		    
			//修改危急值事件的IsActive字段
			modifyCriticalEventValue(commandJson["action"]);
			
			//修改文档目录
			modifyListRecord(documentContext);
			setMessage('数据保存成功!','alert');
			//启用病历信息订阅与发布
			if (Observer == "Y")
			{
				GetObserverData();
			}
			//质控
			qualitySaveDocument();
			
			//getNewMenu();
			initCategory();
				
	   		//保存日志(基础平台组)
			setOperationLog(param,"EMR.Save");
	    }
	    else
	    {
		    setMessage('数据保存失败!','warning');
		}
	}
	else if (commandJson["args"]["result"] == "ERROR")
	{
	    setMessage('保存失败','warning');
	}
	else if (commandJson["args"]["result"] != "NONE")
	{
		setMessage('文档没有发生改变','warning');
	}
}

//同步患者基本信息选项卡列表
function GetObserverData()
{
	var returnValues = "";
	//获取电子病历信息同步选项卡数据
	$.ajax({ 
        type: "post",
		dataType: "text", 
        url: "../EMRservice.Ajax.common.cls",
        async : false,
        data:{
			"OutputType":"Stream",
			"Class":"EMRservice.Observer.BOUpdateData",
			"Method":"ObserverUpData",
			"p1":episodeID,
			"p2":patientID,
			"p3":userID,
			"p4":param.templateId,
			"p5":"SAVE"
		}, 
		error: function(d)
		{
			alert("同步信息获取失败!");
        }, 
        success: function (d)
        {
        	if (d != "")
        	{
	        	var data = eval("["+d+"]");
	        	$.each(data, function(index, item){
		        	if (item.Type == "PaPatMas")
		        	{
			        	var array = {
				        	"data":item.children,
							"patientID":patientID,
							"userID":userID
						};
						returnValues = window.showModalDialog("emr.observerdata.csp",array,"dialogWidth:607px;dialogHeight:313px;resizable:yes;center:yes;status:no;");
					}else if (item.Type == "WMRInfection")
					{
						$.each(item.children, function(childindex, childitem){
							//传染病上报
							ReportWMRInfection(childitem.ActionInfo);
						});
					}else if (item.Type == "NosocomialInfection")
					{
						$.each(item.children, function(childindex, childitem){
							//院内感染
							ReportWMRInfection(childitem.ActionInfo);
						});
					}
        		});
	        }
        } 
    });
    if (returnValues)
	{
		parent.$("#patientInfo").empty();
		parent.getPatinentInfo();
		window.setTimeout("setMessage('同步数据项数据保存成功!','alert')",messageScheme['alert']);
	}
}
// 传染病上报,院内感染界面
function ReportWMRInfection(reportInfectionUrl)
{
	if (reportInfectionUrl == "") return;
	
	var c1 = String.fromCharCode(1);
	var arrReportInfection = reportInfectionUrl.split(c1);
	if (arrReportInfection[0] == "0")
	{
		alert(arrReportInfection[1]);
	}
	else if (arrReportInfection[0] == "1")
	{
		if (!window.confirm(arrReportInfection[1])) return;
		var c2 = String.fromCharCode(2);
		var arrReportInfectionUrl = arrReportInfection[2].split(c2);
		for (var i=0; i<arrReportInfectionUrl.length; i++)
		{
			if (arrReportInfectionUrl[i] == "") continue;
			try{
	        window.showModalDialog(arrReportInfectionUrl[i],"","dialogHeight:800px;dialogWidth:800px;resizable:yes;center:yes;status:no;");
	    }catch(e){
	        alert(e.message);
	    }
  	}
  }
}

//提示用户保存文档
function eventQuerySaveDocument()
{
	setMessage('新建文档保存后才可创建新文档','forbid');
}

//获得文档大纲
function eventGetDocumentOutline(commandJson)
{
	var outLine = commandJson["args"]["Instances"];
	if (outLine == "") return;
}

//创建文档事件
function eventCreateDocument(commandJson)
{
	loadFalg = false;
	if (commandJson["args"]["result"] == "OK")
	{
		param.id = commandJson["args"]["InstanceID"];
		titleCode = commandJson["args"]["Title"]["Code"];
		
		var paramJson = {"action":"reflashKBNode","code":commandJson["args"]["Code"],bindKBBaseID:commandJson["args"]["BindKBBaseID"],"titleCode":titleCode,"diseaseID":"0"};
	    reflashKBNode(paramJson);
	    
	    if (param.insert)
	    {
		    focusDocument(args.InstanceID,param.insert.path,"Last");
		    insertText(param.insert.content);
	    }
	}
}

//文档签名事件
function eventSaveSignedDocument(commandJson)
{
	if ((commandJson["args"]["result"] == "OK")&&(commandJson["args"]["params"]["result"] == "OK")) 
	{
		//取文档信息
		var documentContext = getDocumentContext(commandJson["args"]["params"]["InstanceID"]);
		//设置当前文档操作权限
		setPrivelege(documentContext);
		//当前文档状态
		setStatus(documentContext);
		
		//修改文档目录
		modifyListRecord(documentContext);
		setMessage('数据签名成功!','alert');
		
		//基础平台组审计和日志记录
		setOperationLog(param,"EMR.Sign.OK");
		/*
		//签名成功后，判断是否需要发送消息给Portal系统  //有时会先执行此处，再去执行签名之前的权限审核
		if (IsSetToPortal == "Y")
		{
			setInfoToPortal(documentContext);
		}
		*/
	}
	else
	{
		setMessage('签名失败或级别不符!','warning');
		unsignDocument();
	}
}
//签名成功后，发送消息给Portal系统
function setInfoToPortal(UserID)
{
	var signUserID = UserID;
	//alert("signUserID"+signUserID);
	var InstanceId = param.id;
	var categoryId = param.categoryId;
	var templateId = param.templateId;
	var emrDocId = param.emrDocId;
	var chartItemType = param.chartItemType;

	//取文档信息
	var documentContext = getDocumentContext("");

	var TitleCode = documentContext["Title"]["Code"];
	var TitleDesc = documentContext["Title"]["DisplayName"];
	var curStatus = documentContext["status"]["curStatus"];
	var curStatusDesc = documentContext["status"]["curStatusDesc"];
	var signStatus = documentContext["status"]["signStatus"];

	var canAttendingCheck = documentContext["privelege"]["canAttendingCheck"];
	var canChiefCheck = documentContext["privelege"]["canChiefCheck"];

	//var str = "EpisodeID=" + episodeID + "&signUserID="+ signUserID + "&InstanceId=" + InstanceId + "&categoryId=" + categoryId + "&templateId=" + templateId + "&emrDocId=" + emrDocId + "&chartItemType=" + chartItemType + "&TitleCode=" + TitleCode + "&TitleDesc=" + TitleDesc + "&curStatus=" + curStatus + "&curStatusDesc=" + curStatusDesc + "&signStatus=" + signStatus + "&canAttendingCheck=" + canAttendingCheck + "&canChiefCheck=" + canChiefCheck;
	//alert(str);
	//return;
	$.ajax({ 
		type: "POST", 
		url: "../EMRservice.Ajax.SetDataToPortal.cls", 
		data: "EpisodeID=" + episodeID + "&signUserID="+ signUserID + "&InstanceId=" + InstanceId + "&categoryId=" + categoryId + "&templateId=" + templateId + "&emrDocId=" + emrDocId + "&chartItemType=" + chartItemType + "&TitleCode=" + TitleCode + "&TitleDesc=" + TitleDesc + "&curStatus=" + curStatus + "&curStatusDesc=" + curStatusDesc + "&signStatus=" + signStatus + "&canAttendingCheck=" + canAttendingCheck + "&canChiefCheck=" + canChiefCheck
	});
}

//删除文档
function eventDeleteDocument(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
		var instanceId = commandJson["args"]["params"]["InstanceID"];
		//var deleteData = deleteListRecord(instanceId,"InstanceTree");
		//$(deleteData).find("#status").html("已删除");
		
		//修改危急值事件的IsActive字段
		modifyCriticalEventValue(commandJson["action"]);
		
		//修改文档目录
		//addDeleteTree(deleteData);

		//getNewMenu();
		initCategory();

		setMessage('病历删除成功!','alert');
				
		//基础平台组审计和日志记录
		setOperationLog(param,"EMR.Delete.OK");
	}
	unLock(lockinfo.LockID);
	if (param.chartItemType == "Single")
	{
		param = "";
	}
	else
	{
		param.id = "";
	}
}
//快捷键保存
function eventSave()
{
	if (getModifyStatus().Modified != "True") return;
	var documentContext = getDocumentContext("");
	if (documentContext.result != "OK") return;
	if (documentContext.privelege.canSave != "1") return;
    saveDocument();
}

//插入备注
function eventInsertSummary(commandJson)
{
	$('#memo').window('open');
	$('#memoText').val(commandJson.args.Value);
}

//设置字体样式
function eventCaretContext(commandJson)
{
	if (commandJson.args.FONT_FAMILY)
	{
		$("#font").combobox('setValue',commandJson.args.FONT_FAMILY);
	}
}

//文档加载成功事件
function eventLoadDocument(commandJson)
{
	loadFalg = false;
	
	//刷新绑定数据，静默刷新，不弹框自动刷新
	reloadBinddata("true","false","true");
}

//获取当前病历只读状态
function getReadOnlyStatus()
{
	var strJson = {action:"GET_READONLY",args:{}};
	return cmdSyncExecute(strJson);
}


//文档打印事件
function eventPrintDocument(commandJson)
{
	if (commandJson["args"].result == "OK")
	{
		//取文档信息
		var documentContext = getDocumentContext("");
		//设置当前文档操作权限
		setPrivelege(documentContext);
		//当前文档状态
		setStatus(documentContext);
		
		//修改病历目录列表
		var lis = $("#InstanceTree li[id='"+param["id"]+"']");
		var docId = lis.attr("emrDocId");
		var Num = lis.attr("emrNum");
		//判断是否打印病案首页成功后，对外提供访问出院患者列表
		//getMedicalRecordDocID(docId);
		lis.children(".flag").attr({style:"border:#49A026;background-color:#49A026;color:#49A026","id":"Logflag","emrDocId":docId,"emrNum":Num});		
		//基础平台组审计和日志记录
		setOperationLog(param,"EMR.Print.OK");
	}
}

//复制剪切
function eventSendCopyCutData(commandJson)
{
	//刷新知识库
    var paramJson = {"action":"sendCopyCutData","content":commandJson.args.Value};
    parent.eventDispatch(paramJson);

}

///签名
function eventRequestSign(commandJson)
{
	 if (getModifyStatus().Modified == "True")
	 {
		 var text = '  签名前，请先保存病历！';
		 returnValues = window.showModalDialog("emr.prompt.csp",text,"dialogHeight:180px;dialogWidth:350px;resizable:yes;status:no;scroll:no;");
         if (returnValues != "save")
         {
	         return;
	     }
	     if (saveDocument()=="revoke") return;
     }
	 var signProperty = commandJson.args;
	 audit(signProperty);
}



///连接单元
function eventHyperLink(commandJson)
{
	if (commandJson.args.Url !="")
	{
		getUnitLink(commandJson);
	}
}

function eventUpdateInstanceData(commandJson)
{
	if (commandJson["args"]["result"] == "OK")
	{
		setMessage('插入成功!','alert');
	}
	else 
	{
		setMessage('插入失败!','warning');
	}
}

$(function(){
	//编辑备注
	$('#memo').window({
		title: "编辑备注",
		width: 400,  
		height: 300,  
		modal: true,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		closed: true	 
	});
	$('#memo').css("display","block");	
	
	//保存备注信息
	$('#memoSure').click(function(){
		var memoText = $('#memoText').val();
		memoText = stringTJson(memoText);
		if (memoText.length > 1000)
		{
			alert("备注内容超出1000字数限制");
		}else{
			$.ajax({ 
	       		type: "post", 
				url: "../EMRservice.Ajax.common.cls", 
				data: {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLInstanceData",
					"Method":"SetDocumentMemo",
					"p1":param.id,
					"p2":memoText
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) { 
					alert(textStatus); 
				}, 
				success: function (data) { 
					if (data == "1")
					{
						setMessage('备注修改成功!','alert')	
						$('#memo').window('close');
					}
					else
					{
						setMessage('备注修改失败!','warning')	
					}
				} 
			});			
		}		
	});
	
	//取消或关闭编辑备注
	$("#memoCancel").click(function(){
		$('#memo').window('close');	
	});
});


//修改危急值事件的IsActive字段
function modifyCriticalEventValue(eventAction)
{
	if (eventAction == "eventSaveDocument")
	{
		//保存事件
		if (param.IsActive == "Y") param.IsActive = "N";
	}else if (eventAction == "eventDeleteDocument")
	{
		//删除事件
		if (param.IsActive != "N") param.IsActive = "N";
	}
}

///增加或修改病历列表导航条数据
function modifyListRecord(commandJson)
{
	var instanceId = commandJson.InstanceID;	
	if (instanceId == "GuideDocument") return;
	var creator = commandJson.status.Creator;
	var happendate = commandJson.status.HappenDate;
	var happentime = commandJson.status.HappenTime; 
	var status = commandJson.status.curStatusDesc;
	var text = commandJson.Title.DisplayName;
	var li = $('<li class="green"></li>');
	$(li).attr({"id":instanceId,"text":text,"isLeadframe":param.isLeadframe});
	$(li).attr({"chartItemType":param.chartItemType,"documentType":param.pluginType});           
	$(li).attr({"emrDocId":param.emrDocId,"isMutex":param.isMutex,"categoryId":param.categoryId});	
	$(li).attr({"templateId":param.templateId,"characteristic":param.characteristic});		       
	var datetime = '<h3>'+happendate+'<span>'+happentime+'</span></h3>';
	var content = '<a href="#">'
						+'<DIV><H3>'+text+'</H3>'
					   	+'<P class=con><span>'+creator+'</span>&nbsp&nbsp<span id="status">'+status+'</span></P></DIV>';
				 +'</a>' 
	var n = instanceId.indexOf("||");
	var Num = instanceId.substr(n+2);
	var Logflag = $('<input type="button" class=flag id="Logflag"></input>');
	$(Logflag).attr({"emrDocId":param.emrDocId,"emrNum":Num});
	$(li).append(datetime);
	$(li).append(content);
	$(li).append(Logflag);
	var data = document.getElementById(instanceId);
	if(data)
	{
		data.innerHTML = li[0].innerHTML;
	}
	else
	{
		$("#InstanceTree").append(li);
	}	
}



//刷新知识库
function reflashKBNode(commandParam)
{
	if ((!window.frames["framKBTree"].GetKBNodeByTreeID)||(!commandParam)) return;
	window.frames["framKBTree"].GetKBNodeByTreeID(commandParam);
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
}



///设置工具条

///Desc:是否可编辑
function setSaveStatus(flag)
{
	$('#bold').linkbutton(flag);
	$('#italic').linkbutton(flag);
	$('#underline').linkbutton(flag);
	$('#strike').linkbutton(flag);
	$('#super').linkbutton(flag);
	$('#sub').linkbutton(flag);
	$('#undo').linkbutton(flag);
	$('#redo').linkbutton(flag);
	$('#alignjustify').linkbutton(flag);
	$('#alignleft').linkbutton(flag);
	$('#aligncenter').linkbutton(flag);
	$('#alignright').linkbutton(flag);
	$('#indent').linkbutton(flag);
	$('#unindent').linkbutton(flag);
	$('#cut').linkbutton(flag);
	$('#paste').linkbutton(flag);
	
	$('#save').linkbutton(flag);
	$('#binddatareload').linkbutton(flag);
	$('#spechars').linkbutton(flag);
	
}

///Desc:是否可打印
function setPrintStatus(flag)
{
	$('#print').linkbutton(flag);
}

///Desc:是否可删除
function setDeleteStatus(flag)
{
	$('#delete').linkbutton(flag);
}


//设置粗体
document.getElementById("bold").onclick = function(){
 	strJson = {action:"BOLD",args:{path:""}}; 
 	cmdDoExecute(strJson);	
};

//设置斜体
document.getElementById("italic").onclick = function(){
 	strJson = {action:"ITALIC",args:""}; 
 	cmdDoExecute(strJson);	
};

//设置下划线
document.getElementById("underline").onclick = function(){
 	strJson = {action:"UNDER_LINE",args:""};
 	cmdDoExecute(strJson);	
};

//删除线
document.getElementById("strike").onclick = function(){
 	strJson = {action:"STRIKE",args:""};
 	cmdDoExecute(strJson);	
};

//设置上标
document.getElementById("super").onclick = function(){
 	strJson = {action:"SUPER",args:""};
 	cmdDoExecute(strJson);	
};

//设置下标
document.getElementById("sub").onclick = function(){
 	strJson = {action:"SUB",args:""};
 	cmdDoExecute(strJson);	
};

//撤销
document.getElementById("undo").onclick = function(){
 	strJson = {action:"UNDO",args:""}; 
 	cmdDoExecute(strJson);	
};

//重做
document.getElementById("redo").onclick = function(){
 	strJson = {action:"REDO",args:""}; 
 	cmdDoExecute(strJson);	
};

//设置两端对齐
document.getElementById("alignjustify").onclick = function(){
 	strJson = {action:"ALIGN_JUSTIFY",args:""}; 
 	cmdDoExecute(strJson);	
};

//设置左对齐
document.getElementById("alignleft").onclick = function(){
 	strJson = {action:"ALIGN_LEFT",args:""}; 
 	cmdDoExecute(strJson);	
};

//设置居中对齐
document.getElementById("aligncenter").onclick = function(){
 	strJson = {action:"ALIGN_CENTER",args:""}; 
 	cmdDoExecute(strJson);	
};

//设置右对齐
document.getElementById("alignright").onclick = function(){
 	strJson = {action:"ALIGN_RIGHT",args:""}; 
 	cmdDoExecute(strJson);	
};

//设置缩进
document.getElementById("indent").onclick = function(){
 	strJson = {action:"INDENT",args:""};
 	cmdDoExecute(strJson);	
};

//设置反缩进
document.getElementById("unindent").onclick = function(){
 	strJson = {action:"UNINDENT",args:""};  
 	cmdDoExecute(strJson);	
};

//剪切
document.getElementById("cut").onclick = function(){
 	strJson = {action:"CUT",args:""};  
 	cmdDoExecute(strJson);	
};

//复制
document.getElementById("copy").onclick = function(){
 	strJson = {action:"COPY",args:""};  
 	cmdDoExecute(strJson);	
};

//粘贴
document.getElementById("paste").onclick = function(){
 	strJson = {action:"PASTE",args:""};  
 	cmdDoExecute(strJson);	
};


//特殊字符
document.getElementById("spechars").onclick = function(){
	//if (!window.frames["framRecord"]) return;
	var returnValues = window.showModalDialog("emr.spechars.csp","","dialogHeight:480px;dialogWidth:490px;resizable:no;status:no");	
	if (returnValues != "")	window.frames["framRecord"].insertStyleText(returnValues); 
};

//刷新绑定数据
document.getElementById("binddatareload").onclick = function(){					
	reloadBinddata("false","true","false"); 
}

//保存
document.getElementById("save").onclick = function(){						
	saveDocument(); 
};

//打印
document.getElementById("print").onclick = function(){						
	printDocument();	
};

//删除文档
document.getElementById("delete").onclick = function(){						
	deleteDocument();
}

window.onbeforeunload = function(){    
	var result = savePrompt();
	var status = getRecordStatus().toUpperCase();
	if ( status.indexOf("CHECKED")== -1 )
	{
		alert("病历还未签名，请签名");
		return false;
	}
	if (result == "cancel") return false;
}

$('#close').bind('click', function(){    
    window.close();   
}); 

//显示病历操作记录明细
$("#InstanceTree li #Logflag").live('click',function()
{
	var docId = $(this).attr("emrDocId");
	var Num = $(this).attr("emrNum");
	window.showModalDialog("emr.logdetailrecord.csp?EpisodeID="+episodeID+"&EMRDocId="+docId+"&EMRNum="+Num,"","dialogWidth:801px;dialogHeight:550px;resizable:yes;");
});

function getRecordStatus()
{
	var result = "";
	if ((param.emrDocId == undefined)||(param.emrDocId == "")) return result;
	if ((param.id == undefined)||(param.id == "")) return result;
	strs = param.id.split("||");
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLEMRLogs",
					"Method":"GetEMRStatus",			
					"p1":episodeID,
					"p2":param.emrDocId,
					"p3":strs[1]
				},
			success : function(d) {
	           if ( d != "") 
			   {
					result = d;
			   }
			},
			error : function(d) { alert("getRecordStatus error");}
		});	
	return result;
}
