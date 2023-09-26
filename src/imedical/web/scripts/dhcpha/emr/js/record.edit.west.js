///////////////////////////////导航操作////////////////////////////////////////////////////
////新建病历///////////////////////////////////////////////////////////////////////
//从后台获得目录数据
function getNewMenu()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"GetTempCateJson",			
			"p1":userLocID,
			"p2":ssgroupID,
			"p3":episodeID,
			"p4":userID
		},
		success: function(d){
			if (d == "") return;
			setNewMenu(eval("["+d+"]"));
		},
		error: function(d){alert("error");}
	});
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
			$(link).attr({"id":tData[j].id,"text":tData[j].text,"isLeadframe":tData[j].attributes.isLeadframe});
			$(link).attr({"chartItemType":tData[j].attributes.chartItemType,"documentType":tData[j].attributes.documentType});
			$(link).attr({"isMutex":tData[j].attributes.isMutex,"categoryId":data[i].id});
			$(link).attr({"templateId":tData[j].attributes.templateId,"type":data[i].type});
			$(link).append('<div class="doc">'+tData[j].text+'</div>');
			if (tData[j].childs.length > 0)
			{
				var titleInfo = setTitleByDocId(tData[j].childs);
				if (titleInfo != "") $(link).append(titleInfo);				
			}
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

//设置标题
function setTitleByDocId(data)
{
	var result = '';
	for (var i=0;i<data.length;i++)
	{
		result = result + '<div id="' +data[i].TitleCode+ '" class="info">' +data[i].TitleDesc+ '</div>';
	}
	//添加纵向滚动条
	if(data.length>1)
	{
		result = '<div class="titleInfo" style="height:200px;overflow-y:scroll;">'+ result + '</div>';
	}else
	{
		result = '<div class="titleInfo">'+ result + '</div>';
	}
	return result;
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
			event = {"event":{"EventType":result.split("^")[1],"EventID":result.split("^")[0]}};
		}
	}
	var tabParam ={
		"id":"",
		"text":$(obj).attr("text"),
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
	InitDocument(tabParam);
	//自动记录病例操作日志
	CreateDocumentLog(tabParam,"EMR.Record.RecordNav.CreateRecord.Create");
});

//按标题创建
$('#InstanceNewItem>dl>dd>.list>.titleInfo>div').live('click',function(){
	var obj = $(this).parent().parent();
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
		"text":$(this).text(),
		"pluginType":$(obj).attr("documentType"),
		"chartItemType":$(obj).attr("chartItemType"),
		"emrDocId":$(obj).attr("id"),
		"templateId":$(obj).attr("templateId"),
		"isLeadframe":$(obj).attr("isLeadframe"),
		"isMutex":$(obj).attr("isMutex"),
		"categoryId":$(obj).attr("categoryId"),
		"args":event,
		"actionType":"CREATEBYTITLE",
		"status":"NORMAL",
		"titleCode":$(this).attr("id"),
		"closable":true
	 }; 
	 InitDocument(tabParam);
     //自动记录病例操作日志
     CreateDocumentLog(tabParam,"EMR.Record.RecordNav.CreateRecord.Create");
});

//加载目录////////////////////////////////////////////////////////
function getRecord()
{
	if (parent.pageAttribute.EditRecordDisplayType == "Tree")	
	{
		$('#TypeTree').attr("checked",true);
		getTreeRecord();
	}
	else
	{
		$('#TypeList').attr("checked",true);
		getListRecord();	
	}
}
///按列表加载取数据
function getListRecord()
{
	var data = { 
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"GetRecordCatalogByHappenDate",
			"p1":episodeID,
			"p2":"save",
			"p3":"List"
		};
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: data,
		success: function(d) {
			setRecordList(eval("["+d+"]"));
		},
		error : function(d) { alert("GetInstance error");}
	});		
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
		if ((data[i].modifyTimeFlag == 1)&&(isModifyColorChangeColor == "Y"))
		{
			var datetime = '<h3 style="color:red;">'+data[i].happendate+'<span style="color:red;">'+data[i].happentime+'</span><span style="color:#000;">作者:'+data[i].creator+'</span></h3>';
			var content = '<a href="#">'
								+'<DIV><H3 style="color:red;">'+data[i].text+'</H3>'
								+'<P class=con><span id="operator">'+data[i].operator+'</span>&nbsp|&nbsp<span id="status">'+data[i].status+'</span></P></DIV>';
						 +'</a>';
		}
		else
		{
			var datetime = '<h3>'+data[i].happendate+'<span>'+data[i].happentime+'</span><span style="color:#000;">作者:'+data[i].creator+'</span></h3>';
			var content = '<a href="#">'
								+'<DIV><H3>'+data[i].text+'</H3>'
								+'<P class=con><span id="operator">'+data[i].operator+'</span>&nbsp|&nbsp<span id="status">'+data[i].status+'</span></P></DIV>';
						 +'</a>';
		}
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

//按分类加载目录
function getTreeRecord()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"GetInstanceJson",
			"p1":userLocID,
			"p2":ssgroupID,
			"p3":episodeID,
			"p4":"ZTree"				
		},
		success: function(d) {
			setTreeData(eval("["+d+"]"));
		},
		error : function(d) { alert("GetInstanceJson error");}
	});	
}
//用ztree方法加载目录
function setTreeData(data)
{
	$("#InstanceTree").attr("class","ztree chats_ztree");
	$.fn.zTree.init($('#InstanceTree'), ztSetting, data[0]);
	var treeObj = $.fn.zTree.getZTreeObj('InstanceTree');
	treeObj.expandAll(true);
}
//ztree显示、回调函数、数据格式配置
var ztSetting =
{
    view :
    {
        showIcon : false,
        nameIsHTML: true
    },
    callback :
    {
        onClick : ztOnClick,
        beforeClick : ztBeforeClick
    },
    data :
    {
        simpleData :
        {
            enable : false
        }
    }
};
//ztree鼠标左键点击回调函数
function ztOnClick(event, treeId, treeNode)
{
	var tempParam = {
		"id":treeNode.id,
		"text":treeNode.attributes.text,
		"pluginType":treeNode.attributes.documentType,
		"chartItemType":treeNode.attributes.chartItemType,
		"emrDocId":treeNode.attributes.emrDocId,
		"templateId":treeNode.attributes.templateId,
		"isLeadframe":treeNode.attributes.isLeadframe,
		"characteristic":treeNode.attributes.characteristic,
		"isMutex":treeNode.attributes.isMutex,
		"categoryId":treeNode.attributes.categoryId,
		"actionType":"LOAD",
		"status":"NORMAL",
		"closable":true
	};
	InitDocument(tempParam);
	openDocumentLog(tempParam,"EMR.Record.RecordNav.RecordDirectory.Open");
}
//如果返回 false，zTree 将不会选中节点，也无法触发 onClick 事件回调函数
function ztBeforeClick(treeId, treeNode, clickFlag)
{
	//当是父节点 返回false 不让选取
	return !treeNode.isParent;
}

//显示病历操作记录明细
$("#InstanceTree li #Logflag").live('click',function()
{
	var docId = $(this).attr("emrDocId");
	var Num = $(this).attr("emrNum");
	window.showModalDialog("emr.logdetailrecord.csp?EpisodeID="+episodeID+"&EMRDocId="+docId+"&EMRNum="+Num,"","dialogWidth:801px;dialogHeight:550px;resizable:yes;");
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
	InitDocument(tempParam);
	//自动记录病例操作日志
	openDocumentLog(tempParam,"EMR.Record.RecordNav.RecordDirectory.Open");
});

//选中文档目录
function setSelectRecordColor(instanceId)
{
	if ($('#TypeTree')[0].checked)
	{
		selectZtreeNode(instanceId);
	}
	else
	{
		selectListRecord(instanceId);
	}
}

///列表病历导航条目选中
function selectListRecord(instanceId)
{
	$('#InstanceTree.instance-item li').each(function()
	{
		if($(this).attr('id')==instanceId)
		{
			$(this).css('background-color','#DAEBFC');
			$(".instance-item").animate({scrollTop: $(this).position().top}, 1000); 
		}
		else
		{
			$(this).css('background-color','transparent');
		}
	 });	
}

///选中Ztree节点
function selectZtreeNode(instanceId)
{
	 if (instanceId != "GuideDocument")
	 {
		 var treeObj = $.fn.zTree.getZTreeObj("InstanceTree");
		 var node = treeObj.getNodeByParam("id",instanceId, null);
		 treeObj.selectNode(node);
	 }
}

//新增或修改病历目录列表
function modifyInstanceTree(commandJson)
{
	if ($('#TypeTree')[0].checked)
	{
		modifyZTreeRecord(commandJson);
	}
	else
	{
		modifyListRecord(commandJson);
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
	var text = commandJson["Title"]["NewDisplayName"];
	var li = $('<li class="green"></li>');
	$(li).attr({"id":instanceId,"text":text,"isLeadframe":param.isLeadframe});
	$(li).attr({"chartItemType":param.chartItemType,"documentType":param.pluginType});           
	$(li).attr({"emrDocId":param.emrDocId,"isMutex":param.isMutex,"categoryId":param.categoryId});	
	$(li).attr({"templateId":param.templateId,"characteristic":param.characteristic});		       
	if ((commandJson.status.HappenDate != commandJson.status.OperateDate)&&(isModifyColorChangeColor == "Y"))
	{
		var datetime = '<h3 style="color:red;">'+happendate+'<span style="color:red;">'+happentime+'</span><span style="color:#000;">作者:'+creator+'</span></h3>';
		var content = '<a href="#">'
							+'<DIV><H3 style="color:red;">'+text+'</H3>'
							+'<P class=con><span id="operator">'+userName+'</span>&nbsp|&nbsp<span id="status">'+status+'</span></P></DIV>';
					 +'</a>' 
	}
	else
	{
		var datetime = '<h3>'+happendate+'<span>'+happentime+'</span><span style="color:#000;">作者:'+creator+'</span></h3>';
		var content = '<a href="#">'
							+'<DIV><H3>'+text+'</H3>'
							+'<P class=con><span id="operator">'+userName+'</span>&nbsp|&nbsp<span id="status">'+status+'</span></P></DIV>';
					 +'</a>' 
	}
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

function modifyZTreeRecord(commandJson)
{
	//修改病历目录分类列表
	var instanceId = commandJson.InstanceID;	
	if (instanceId == "GuideDocument") return;
	var creator = commandJson.status.Creator;
	var happendate = commandJson.status.HappenDate;
	var happentime = commandJson.status.HappenTime;
	var status = commandJson.status.curStatusDesc;
	var name = commandJson["Title"]["NewDisplayName"];
	var treeObj = $.fn.zTree.getZTreeObj('InstanceTree');
	var node = treeObj.getNodeByParam("id",instanceId, null);
	var text = happendate+" "+happentime+" "+name+" "+creator+" "+status;
	if ((commandJson.status.HappenDate != commandJson.status.OperateDate)&&(isModifyColorChangeColor == "Y"))
	{
		text = "<span style='color:red;'>"+ text +"</span>"
	}
	if (node != null) 
	{
		node.name = text;
		treeObj.updateNode(node);	
	}
	else
	{
		var newNode = {
			"id":instanceId,
			"name":text,
			"attributes":{
				"chartItemType":param.chartItemType,
				"documentType":param.pluginType,
				"categoryId":param.categoryId,
				"emrDocId":param.emrDocId,
				"emrNum":instanceId.substr(instanceId.indexOf("||")+2),
				"templateId":param.templateId,
				"isLeadframe":param.isLeadframe,
				"isMutex":param.isMutex,
				"characteristic":param.characteristic
			}
		}
		var parentNode = null;
		if (param.chartItemType == "Multiple")
		{
			parentNode = treeObj.getNodeByParam("id", param.emrDocId, null);
			if (parentNode == null)
			{
				var parentNodeData = {
					"id":param.emrDocId,
					"name":name
					};
				treeObj.addNodes(null, parentNodeData);
				parentNode = treeObj.getNodeByParam("id", param.emrDocId, null);
			}
		}
		treeObj.addNodes(parentNode, newNode);	
		
	}	
}

//修改病历操作记录明细的显示颜色
function modifyWestListFlag()
{
		var lis = $("#InstanceTree li[id='"+param["id"]+"']");
		var docId = lis.attr("emrDocId");
		var Num = lis.attr("emrNum");
		lis.children(".flag").attr({style:"border:#49A026;background-color:#49A026;color:#49A026","id":"Logflag","emrDocId":docId,"emrNum":Num});		
}

///删除病历///////////////////////////////////////////////////////////
function deleteTreeItem(instanceId,treeId)
{
	var result = "";
	if ($('#TypeTree')[0].checked)
	{
		result = deleteZTreeRecord(instanceId);
	}
	else
	{
		result = deleteListRecord(instanceId,treeId);
	}
	 return result;		
}

///删除列表病历
function deleteListRecord(instanceId,treeId)
{
	var result = "";
	$('#'+treeId+' li').each(function(){
		if ($(this).attr('id')==instanceId)
		{
			$(this).remove(); 
			result = $(this);
			return result;	
		}
	 });
	 return result;	
}
///删除Tree病历
function deleteZTreeRecord(instanceId)
{
	var result = "";
	var treeObj = $.fn.zTree.getZTreeObj('InstanceTree');
	var node = treeObj.getNodeByParam("id",instanceId, null);
	if (node == null) return result;
	treeObj.removeNode(node);
	if (param.chartItemType == "Multiple")
	{
		var parentNode = treeObj.getNodeByParam("id", param.emrDocId, null);
		if (parentNode.children.length == 0)
		{
			treeObj.removeNode(parentNode);
		}
	}
	
	var li = $('<li class="green"></li>');
	$(li).attr({"id":instanceId,"text":node.attributes.text,"isLeadframe":node.attributes.isLeadframe});
	$(li).attr({"chartItemType":node.attributes.chartItemType,"documentType":node.attributes.documentType});           
	$(li).attr({"emrDocId":node.attributes.emrDocId,"isMutex":node.attributes.isMutex,"categoryId":node.attributes.categoryId});	
	$(li).attr({"templateId":param.templateId,"characteristic":node.attributes.characteristic});		       
	var datetime = '<h3>'+node.attributes.happendate+'<span>'+node.attributes.happentime+'</span><span style="color:#000;">作者:'+node.attributes.creator+'</span></h3>';
	var content = '<a href="#">'
						+'<DIV><H3>'+node.attributes.text+'</H3>'
					   	+'<P class=con><span id="operator">'+userName+'</span>&nbsp|&nbsp<span id="status">'+'已删除</span></P></DIV>';
				 +'</a>' 
	var n = instanceId.indexOf("||");
	var Num = instanceId.substr(n+2);
	var Logflag = $('<input type="button" class=flag id="Logflag"></input>');
	$(Logflag).attr({"emrDocId":node.attributes.emrDocId,"emrNum":Num});
	$(li).append(datetime);
	$(li).append(content);
	$(li).append(Logflag);
	result = $(li);
	return result;

}


///取回收站病历
function getDeleteRecord()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"GetRecordCatalogByHappenDate",
			"p1":episodeID,
			"p2":"delete",
			"p3":"List"
		},
		success: function(d) 
		{
			if (d == "") return;
			setDeleteRecord(eval("["+d+"]"));
		},
		error : function(d) { 
			alert("GetDeleteData error");
		}
	});		
}


///加载回收站病历
function setDeleteRecord(data)
{
	$('#deleteTree').empty();
	for (var i=0;i<data.length;i++)
	{
		var li = $('<li class="green"></li>');
		$(li).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].isLeadframe});
		$(li).attr({"chartItemType":data[i].chartItemType,"documentType":data[i].documentType});           
		$(li).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":data[i].categoryId});
		$(li).attr({"templateId":data[i].templateId});			       
		var datetime = '<h3>'+data[i].happendate+'<span>'+data[i].happentime+'</span><span style="color:#000;">作者:'+data[i].creator+'</span></h3>';
		var content = '<a href="#">'
							+'<DIV><H3>'+data[i].text+'</H3>'
						   	+'<P class=con><span id="operator">'+data[i].operator+'</span>&nbsp|&nbsp<span id="status">'+data[i].status+'</span></P></DIV>';
					 +'</a>' 
		$(li).append(datetime)
		$(li).append(content);	

		$('#deleteTree').append(li);   	
	}	
}
$("#deleteTree li").live('click',function(){
	var tempParam = {
		"id":$(this).attr("id"),
		"text":$(this).attr("text"),
		"pluginType":$(this).attr("documentType"),
		"chartItemType":$(this).attr("chartItemType"),
		"emrDocId":$(this).attr("emrDocId"),
		"templateId":$(this).attr("templateId"),
		"isLeadframe":$(this).attr("isLeadframe"),
		"isMutex":$(this).attr("isMutex"),
		"categoryId":$(this).attr("categoryId"),
		"actionType":"LOAD",
		"status":"DELETE",
		"closable":true
	};
	InitDocument(tempParam);
	//自动记录病例操作日志
	openDocumentLog(tempParam,"EMR.Record.RecordNav.RecordDirectory.Open");
});

///目录增加删除病历
function addDeleteTree(data)
{
	$('#deleteTree').append(data);  	
}

///选择病历导航列表显示样式
function GetRecordType(type)
{
	if (type == "Tree")
	{
		getTreeRecord();
	}
	else
	{
		getListRecord();
	}
}
