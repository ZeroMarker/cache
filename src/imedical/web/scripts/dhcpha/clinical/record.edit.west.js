//�Ӻ�̨���Ŀ¼����
var tempParams="";var tempParamLock="";
var tempFlag="δ�л�ҩ��"; //�ж��Ƿ����л�ģ��
function getNewMenu()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"web.DHCCM.EMRservice.BL.BLClientCategory",
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
//�����½�Ŀ¼
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
			//�жϿͻ��������IE����汾
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
		//�жϿͻ��������IE�汾
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

//���ñ���
function setTitleByDocId(data)
{
	var result = '';
	for (var i=0;i<data.length;i++)
	{
		result = result + '<div id="' +data[i].TitleCode+ '" class="info">' +data[i].TitleDesc+ '</div>';
	}
	//������������
	if(data.length>1)
	{
		result = '<div class="titleInfo" style="height:200px;overflow-y:scroll;">'+ result + '</div>';
	}else
	{
		result = '<div class="titleInfo">'+ result + '</div>';
	}
	return result;
}

//�½�����	
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
	parent.btnCanNot("enable"); //��������ť����
	parent.btnPrintCanNot();
	InitDocument(tabParam);
	//�Զ���¼����������־
	CreateDocumentLog(tabParam,"EMR.Record.RecordNav.CreateRecord.Create");
});

//�����ⴴ��
$('#InstanceNewItem>dl>dd>.list>.titleInfo>div').live('click',function(){
	var obj = $(this).parent().parent();
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
		"actionType":"CREATEBYTITLE",
		"status":"NORMAL",
		"titleCode":$(this).attr("id"),
		"closable":true
	 }; 
	 InitDocument(tabParam);
     //�Զ���¼����������־
     CreateDocumentLog(tabParam,"EMR.Record.RecordNav.CreateRecord.Create");
});

//����Ŀ¼////////////////////////////////////////////////////////
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
///���б����ȡ����
function getListRecord()
{
	var data = { 
			"OutputType":"Stream",
			"Class":"web.DHCCM.EMRservice.BL.BLClientCategory",
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
//����Ŀ¼
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
		$(li).attr({"templateId":data[i].templateId,"characteristic":data[i].characteristic,"emrNum":data[i].emrNum,"status":data[i].status});
		var datetime = '<h3>'+data[i].happendate+'<span>'+data[i].happentime+'</span></h3>';
		var content = '<a href="#">'
							+'<DIV><H3>'+data[i].text+'</H3>'
						   	+'<P class=con><span>'+data[i].creator+'</span>&nbsp&nbsp<span id="status">'+data[i].status+'</span></P></DIV>';
					 +'</a>';
		//�жϵ�ǰ�Ƿ񱻴�ӡ������printstatusΪ�գ�δ����ӡ��
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

//���������Ŀ¼
function getTreeRecord()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"web.DHCCM.EMRservice.BL.BLClientCategory",
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
//��ztree��������Ŀ¼
function setTreeData(data)
{
	$("#InstanceTree").attr("class","ztree chats_ztree");
	$.fn.zTree.init($('#InstanceTree'), ztSetting, data[0]);
	var treeObj = $.fn.zTree.getZTreeObj('InstanceTree');
	treeObj.expandAll(true);
}
//ztree��ʾ���ص����������ݸ�ʽ����
var ztSetting =
{
    view :
    {
        showIcon : false
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
//ztree����������ص�����
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
		"status":treeNode.attributes.status,
		"closable":true
	};
	tempParamLock=tempParam;
	
	if(tempParam.status=="���")
		{
			parent.btnCanNot("enable");
			parent.btnPrintCanNot();
		}
		else{
			if(tempParam.status!="NORMAL"){
				///dws 2017-01-18 ǩ����ɺ����ͷ�˵�Ȩ�ޣ�ҩ�����ɱ༭��ֻ��
				parent.btnCanNot("disable");
				parent.btnSaveCanNot();
				lockDocument(tempParam);
				setReadOnly(true,"");
			}
			else{
				parent.btnCanNot("enable");
			}
		}
	InitDocument(tempParam);
	openDocumentLog(tempParam,"EMR.Record.RecordNav.RecordDirectory.Open");
}
//������� false��zTree ������ѡ�нڵ㣬Ҳ�޷����� onClick �¼��ص�����
function ztBeforeClick(treeId, treeNode, clickFlag)
{
	//���Ǹ��ڵ� ����false ����ѡȡ
	return !treeNode.isParent;
}

//��ʾ����������¼��ϸ
$("#InstanceTree li #Logflag").live('click',function()
{
	var docId = $(this).attr("emrDocId");
	var Num = $(this).attr("emrNum");
	window.showModalDialog("emr.logdetailrecord.csp?EpisodeID="+episodeID+"&EMRDocId="+docId+"&EMRNum="+Num,"","dialogWidth:801px;dialogHeight:550px;resizable:yes;");
});

///List���ʹ򿪲���
$("#InstanceTree.instance-item li").live('click',function(){
	tempFlag="�Ѿ��л�ҩ��";
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
		"status":$(this).attr("status"),
		"closable":true
	};
	tempParams={"InstanceID":tempParam.id,"categoryId":tempParam.categoryId,"templateId":tempParam.templateId};//ҩ����Ϣ
	tempParamLock=tempParam;
	if((tempParam.status=="���")||(tempParam.status==undefined))
		{
			parent.btnCanNot("enable");
			parent.btnPrintCanNot();
		}
		else{
			if(tempParam.status!="NORMAL"){
				///dws 2017-01-18 ǩ����ɺ����ͷ�˵�Ȩ�ޣ�ҩ�����ɱ༭��ֻ��
				parent.btnCanNot("disable");
				parent.btnSaveCanNot();
				lockDocument(tempParam);
				setReadOnly(true,"");
			}
			else{
				parent.btnCanNot("enable");
			}
		}
	InitDocument(tempParam);
	//�Զ���¼����������־
	openDocumentLog(tempParam,"EMR.Record.RecordNav.RecordDirectory.Open");
});

//ѡ���ĵ�Ŀ¼
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

///�б���������Ŀѡ��
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

///ѡ��Ztree�ڵ�
function selectZtreeNode(instanceId)
{
	 if (instanceId != "GuideDocument")
	 {
		 var treeObj = $.fn.zTree.getZTreeObj("InstanceTree");
		 var node = treeObj.getNodeByParam("id",instanceId, null);
		 treeObj.selectNode(node);
	 }
}

//�������޸Ĳ���Ŀ¼�б�
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

///���ӻ��޸Ĳ����б���������
function modifyListRecord(commandJson)
{
	var instanceId = commandJson.InstanceID;	
	if (instanceId == "GuideDocument") return;
	var creator = commandJson.status.Creator;
	var happendate = commandJson.status.HappenDate;
	var date=happendate.split('-')
	var happendate=date[2]+"/"+date[1]+"/"+date[0]
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

function modifyZTreeRecord(commandJson)
{
	//�޸Ĳ���Ŀ¼�����б�
	var instanceId = commandJson.InstanceID;	
	if (instanceId == "GuideDocument") return;
	var creator = commandJson.status.Creator;
	var happendate = commandJson.status.HappenDate;
	var date=happendate.split('-')
	var happendate=date[2]+"/"+date[1]+"/"+date[0]
	var happentime = commandJson.status.HappenTime;
	var status = commandJson.status.curStatusDesc;
	var text = commandJson.Title.DisplayName;
	var treeObj = $.fn.zTree.getZTreeObj('InstanceTree');
	var node = treeObj.getNodeByParam("id",instanceId, null);
	if (param.chartItemType == "Multiple")
	{
		text = happendate+" "+happentime+" "+text+" "+creator+" "+status;
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
				"documentType":param.documentType,
				"categoryId":param.categoryId,
				"emrDocId":param.emrDocId,
				"emrNum":instanceId.substr(instanceId.indexOf("||")+2),
				"templateId":param.templateId,
				"isLeadframe":param.isLeadframe,
				"isMutex":param.isMutex,
				"characteristic":param.characteristic,
				"status":param.status
			}
		}
		var parentNode = null;
		var selectNode = treeObj.getSelectedNodes()
		param.chartItemType == "Multiple"
		{
			parentNode = treeObj.getNodeByParam("id", param.emrDocId, null);
		}
		treeObj.addNodes(parentNode, newNode);	
		
	}	
}

//�޸Ĳ���������¼��ϸ����ʾ��ɫ
function modifyWestListFlag()
{
		var lis = $("#InstanceTree li[id='"+param["id"]+"']");
		var docId = lis.attr("emrDocId");
		var Num = lis.attr("emrNum");
		lis.children(".flag").attr({style:"border:#49A026;background-color:#49A026;color:#49A026","id":"Logflag","emrDocId":docId,"emrNum":Num});		
}

///ɾ������///////////////////////////////////////////////////////////
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

///ɾ���б���
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
///ɾ��Tree����
function deleteZTreeRecord(instanceId)
{
	var result = "";
	var treeObj = $.fn.zTree.getZTreeObj('InstanceTree');
	var node = treeObj.getNodeByParam("id",instanceId, null);
	if (node == null) return result;
	treeObj.removeNode(node);
	var li = $('<li class="green"></li>');
	$(li).attr({"id":instanceId,"text":node.attributes.text,"isLeadframe":node.attributes.isLeadframe});
	$(li).attr({"chartItemType":node.attributes.chartItemType,"documentType":node.attributes.pluginType});           
	$(li).attr({"emrDocId":node.attributes.emrDocId,"isMutex":node.attributes.isMutex,"categoryId":node.attributes.categoryId});	
	$(li).attr({"templateId":param.templateId,"characteristic":node.attributes.characteristic});		       
	var datetime = '<h3>'+node.attributes.happendate+'<span>'+node.attributes.happentime+'</span></h3>';
	var content = '<a href="#">'
						+'<DIV><H3>'+node.attributes.text+'</H3>'
					   	+'<P class=con><span>'+node.attributes.creator+'</span>&nbsp&nbsp<span id="status">��ɾ��</span></P></DIV>';
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


///ȡ����վ����
function getDeleteRecord()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"web.DHCCM.EMRservice.BL.BLClientCategory",
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


///���ػ���վ����
function setDeleteRecord(data)
{
	$('#deleteTree').empty();
	for (var i=0;i<data.length;i++)
	{
		var li = $('<li class="green"></li>');
		$(li).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].isLeadframe});
		$(li).attr({"chartItemType":data[i].chartItemType,"documentType":data[i].documentType});           
		$(li).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":data[i].categoryId});
		$(li).attr({"templateId":data[i].templateId,"status":data[i].status});			       
		var datetime = '<h3>'+data[i].happendate+'<span>'+data[i].happentime+'</span></h3>';
		var content = '<a href="#">'
							+'<DIV><H3>'+data[i].text+'</H3>'
						   	+'<P class=con><span>'+data[i].creator+'</span>&nbsp;&nbsp;<span id="status">'+data[i].status+'</span></P></DIV>';
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
		"status":$(this).attr("status"),
		"closable":true
	};
	parent.btnCanNot("disable");
	InitDocument(tempParam);
	//�Զ���¼����������־
	openDocumentLog(tempParam,"EMR.Record.RecordNav.RecordDirectory.Open");
});

///Ŀ¼����ɾ������
function addDeleteTree(data)
{
	$('#deleteTree').append(data);  	
}

///ѡ���������б���ʾ��ʽ
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
