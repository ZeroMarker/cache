///////////////////////////////导航操作////////////////////////////////////////////////////
function getListRecord(groupCode)
{
	if (groupCode == ""|| groupCode == undefined ) return;
	var data = "";
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLEMRTemplateGroup",
			"Method":"GetInstanceJsonByGroupCode",
			"p1":episodeID,
			"p2":groupCode,
			"p3":"Save"
		},
		success: function(d) {
			if(d != ""){
				data = eval("["+d+"]");
				setRecordList(data);
			}
		},
		error : function(d) { 
			alert("获取病历失败");
		}
	});
	return data;
}

//加载目录
function setRecordList(data)
{
	$('#InstanceTree').empty();
	for (var i=0;i<data.length;i++)
	{
		var li = $('<li></li>');
		$(li).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].isLeadframe});
		$(li).attr({"chartItemType":data[i].chartItemType,"documentType":data[i].documentType});           
		$(li).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":data[i].categoryId});			       
		$(li).attr({"templateId":data[i].templateId,"characteristic":data[i].characteristic,"emrNum":data[i].emrNum});
		var datetime = '<div class="datetime"><div class="date">'+data[i].happendate+'</div><div class="time">'+data[i].happentime+'</div><div>作者:'+data[i].creator+'</div></div>';
		var content ='<div class="content"><div class="title">'+data[i].text+'</div>'
					+'<div class="operator"><span id="operator">'+data[i].operator+'</span>&nbsp|&nbsp<span id="status">'+data[i].status+'</span></div></div>';

		//判断当前是否被打印过，若printstatus为空，未被打印过
		if (data[i].printstatus == "")
		{
			var Logflag = $('<input type="button" class="flag" id="Logflag"></input>');
		}
		else
		{
			var Logflag = $('<input type="button" class="flag flagp" id="Logflag"></input>');
		}
		$(Logflag).attr({"emrDocId":data[i].emrDocId,"emrNum":data[i].emrNum});	
		var page = "";
		for (var j= data[i].startPage;j<=data[i].endPage;j++)
		{
			if (j != data[i].startPage) page = page + '<br/>';
        	page = page +  '<input type="checkbox" name="checkbox" value="'+j+'">'+'第'+j+'页'+'</input>';
		}
		$(li).append('<div style="float:right"><input type="radio" name="radio'+data[i].id+'" id="all" onclick="selectThis(this)">全选</input><input type="radio" name="radio'+data[i].id+'" id="odd" onclick="selectOdd(this)">奇数</input><input type="radio" name="radio'+data[i].id+'" id="even" onclick="selectEven(this)">偶数</input></div>');	
		$(li).append(datetime);
		$(li).append(content);	
		$(li).append(Logflag);
		$(li).append('<div class="page">'+page+'</div>');
		$('#InstanceTree').append(li);   	
	}
}
$("#selectAll").change(function() {
	if ($("#selectAll").attr("checked")== "checked")
	{
		$('#InstanceTree li').find(":checkbox").attr("checked",'true');
	}
	else
	{
		$('#InstanceTree li').find(":checkbox").removeAttr("checked");
	}	
});

function selectThis(obj)
{
	var li = $(obj).closest("li");
	$(li).find(":checkbox").attr("checked",'true');
}
function selectEven(obj)
{
	var li = $(obj).closest("li");
	$(li).find(":checkbox").removeAttr("checked");
	$(li).find("input[name='checkbox']:odd").attr('checked','true'); 
}
function selectOdd(obj)
{
	var li = $(obj).closest("li");
	$(li).find(":checkbox").removeAttr("checked");
	$(li).find("input[name='checkbox']:even").attr('checked','true'); 
	
}

//显示病历操作记录明细
$("#InstanceTree li #Logflag").live('click',function()
{
	var docId = $(this).attr("emrDocId");
	var Num = $(this).attr("emrNum");
	window.showModalDialog("emr.logdetailrecord.csp?EpisodeID="+episodeID+"&EMRDocId="+docId+"&EMRNum="+Num,"","dialogWidth:801px;dialogHeight:550px;resizable:yes;");
});

///List类型打开病历
$("#InstanceTree.instance-item li .content").live('click',function(){
	var obj = $(this).closest("li");
	var tempParam = {
		"id":obj.attr("id"),
		"text":obj.attr("text"),
		"pluginType":obj.attr("documentType"),
		"chartItemType":obj.attr("chartItemType"),
		"emrDocId":obj.attr("emrDocId"),
		"templateId":obj.attr("templateId"),
		"isLeadframe":obj.attr("isLeadframe"),
		"characteristic":obj.attr("characteristic"),
		"isMutex":obj.attr("isMutex"),
		"categoryId":obj.attr("categoryId"),
		"actionType":"LOAD",
		"status":"NORMAL",
		"closable":true
	};
	InitDocument(tempParam);
	g_groupTempParam = [tempParam];
	//自动记录病例操作日志
	openDocumentLog(tempParam,"EMR.Record.RecordNav.RecordDirectory.Open");
});

//选中文档目录
function setSelectRecordColor(instanceId)
{
	selectListRecord(instanceId);
}

///列表病历导航条目选中
function selectListRecord(instanceId)
{
	$('#InstanceTree.instance-item li').each(function()
	{
		if ($(this).attr('id')==instanceId)
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


//新增或修改病历目录列表
function modifyInstanceTree(commandJson)
{
	modifyListRecord(commandJson);	
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
	if (text == undefined) text = commandJson["Title"]["DisplayName"];
	var li = $('<li></li>');
	$(li).attr({"id":instanceId,"text":text,"isLeadframe":param.isLeadframe});
	$(li).attr({"chartItemType":param.chartItemType,"documentType":param.pluginType});           
	$(li).attr({"emrDocId":param.emrDocId,"isMutex":param.isMutex,"categoryId":param.categoryId});	
	$(li).attr({"templateId":param.templateId,"characteristic":param.characteristic});	
	
	var datetime = '<div class="datetime"><div class="date">'+happendate+'</div><div class="time">'+happentime+'</div><div>作者:'+creator+'</div></div>';
	var content ='<div class="content"><div class="title">'+text+'</div>'
				+'<div class="operator"><span id="operator">'+userName+'</span>&nbsp|&nbsp<span id="status">'+status+'</span></div></div>';

	var Logflag = $('<input type="button" class="flag" id="Logflag"></input>');

	var n = instanceId.indexOf("||");
	var Num = instanceId.substr(n+2);
	$(Logflag).attr({"emrDocId":param.emrDocId,"emrNum":Num});	
	var pagecount = getDocumentPage().pageCount;
	var page = "";
	for (var j= 1;j<= pagecount;j++)
	{
		if (j != 1) page = page + '<br/>';
    	page = page +  '<input type="checkbox" name="checkbox" value="'+j+'">'+'第'+j+'页'+'</input>';
	}
	$(li).append('<div style="float:right"><input type="radio" name="radio'+instanceId+'" id="all" onclick="selectThis(this)">全选</input><input type="radio" name="radio'+instanceId+'" id="odd" onclick="selectOdd(this)">奇数</input><input type="radio" name="radio'+instanceId+'" id="even" onclick="selectEven(this)">偶数</input></div>');	
	$(li).append(datetime);
	$(li).append(content);	
	$(li).append(Logflag);
	$(li).append('<div class="page">'+page+'</div>');	

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
	var result = deleteListRecord(instanceId,treeId);
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

///选择病历导航列表显示样式
function GetRecordType(type)
{
	getListRecord();
}
