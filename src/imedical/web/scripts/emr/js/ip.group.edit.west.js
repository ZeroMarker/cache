///////////////////////////////导航操作////////////////////////////////////////////////////
function getListRecord(groupCode)
{
	if (groupCode == ""|| groupCode == undefined ) return;
	$HUI.checkbox('#selectAll').setValue(false);
	$HUI.radio("#west input.hisui-radio",{});
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
			else
			{
				$('#InstanceTree').empty();
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
		$('#InstanceTree').append(setlistdata(data[i]));
	}
	$.parser.parse('#recordlist');
}

///加载列表样式
function setlistdata(data)
{
	var li = $('<li></li>');
	$(li).attr({"id":data.id,"text":data.text,"isLeadframe":data.isLeadframe});
	$(li).attr({"chartItemType":data.chartItemType,"documentType":data.documentType});           
	$(li).attr({"emrDocId":data.emrDocId,"isMutex":data.isMutex,"categoryId":data.categoryId});			       
	$(li).attr({"templateId":data.templateId,"characteristic":data.characteristic,"emrNum":data.emrNum});
	$(li).attr({"itemTitle":data.itemTitle});
	$(li).attr({"page":data.endPage});
	var left = "<div class='left'><input class='hisui-checkbox recordcheck' type='checkbox' name='recordList' data-options='onCheckChange:function(event,value){checkOnClick(this)}' label=''/></div>" 
	$(li).append(left);
	var right = $('<a href="#" class="right"></a>');
	var first = $('<div class="first"></div>');
	$(first).append('<div class="title">'+data.text+'</div>');
	var fleft = $('<div class="fleft"></div>');
	if (data.printstatus != "")
	{
		$(fleft).append('<span class="printed">'+emrTrans("已打印")+'</span>');
	}
	$(fleft).append('<span type="image" class="log" onclick="showListLog(this)"></span></div>');
	$(first).append(fleft);
	$(right).append(first);
	var second = '<div class="second"><span class="data">'+data.happendate+'</span><span>'+data.happentime+'</span><span>'+data.creator+'</span></div>';
	$(right).append(second);
	var statusClass = "status green";
	if (data.status != "完成") statusClass = "status blue";
	var third = $('<div class="third"></div>');
	$(third).append('<div class="thirdleft"><span id="operator" class="operator">'+data.operator+'</span><span id="status" class="'+statusClass+'">'+data.status+'</span></div>');
	var thirdright = $('<div class="thirdright blue">'+emrTrans('共')+data.endPage+emrTrans('页')+'</div>');
	$(third).append(thirdright);
	$(right).append(third);
	$(li).append(right);
	return li;
}

///List类型打开病历
$(document).on('click',"#InstanceTree.instance-item li .right",function(){
	var obj = $(this).parent();
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
	//g_groupTempParam = [tempParam];
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
			$(this).find('.right').addClass("selectli");
			$(".instance-item").animate({scrollTop: $(this).position().top}, 1000); 
		}
		else
		{
			$(this).find('.right').removeClass("selectli");
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
	var operator = commandJson.status.Operator;
	var happendate = commandJson.status.HappenDate;
	var happentime = commandJson.status.HappenTime; 
	var status = commandJson.status.curStatusDesc;
	var text = commandJson["Title"]["NewDisplayName"];
	var formatHappenDate=getHISDateTimeFormate("Date",happendate)
	var formatHappenTime=getHISDateTimeFormate("Time",happentime)
	var pagecount = getDocumentPage().pageCount;

	var data ={
		"id":instanceId,
		"text":text,
		"isLeadframe":param.isLeadframe,
		"chartItemType":param.chartItemType,
		"documentType":param.pluginType,
		"emrDocId":param.emrDocId,
		"isMutex":param.isMutex,
		"categoryId":param.categoryId,
		"templateId":param.templateId,
		"characteristic":param.characteristic,
		"itemTitle":param.itemTitle,
		"happendate":formatHappenDate,
		"happentime":formatHappenTime,
		"creator":creator,
		"operator":operator,
		"status":status,
		"printstatus":"",
		"endPage":pagecount
	}
	var li = setlistdata(data);
	var data = document.getElementById(instanceId);
	if (data)
	{
		$(data).attr("page",pagecount);
		data.innerHTML = li[0].innerHTML;
	}
	else
	{
		$("#InstanceTree").append(li);
	}
	selectListRecord(instanceId);
	$.parser.parse('#recordlist');	
}

function getHISDateTimeFormate(valuetype,value)
{
	var retvalue = ""
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.Tools.Tool",
			"Method":"GetHISStandardDateTimeFormat",
			"p1":"ChangeToFormat",
			"p2":valuetype,
			"p3":value
		},
		success: function(d) 
		{
			if (d != "") 
			{
				retvalue = d;
			}
		},
		error : function() 
		{ 
			retvalue = value;
		}

	});	
	return retvalue;
	
}

//修改病历操作记录明细的显示颜色
function setListPrinted(id)
{
	var li = $("#InstanceTree li[id='"+id+"']");
	if ($(li).find(".fleft").find(".printed").length == "1") return;
	$(li).find(".fleft").append('<span class="printed">'+emrTrans('已打印')+'</span>');
}

///删除病历///////////////////////////////////////////////////////////
function deleteListRecord(instanceId,treeId)
{
	$('#'+treeId+' li').each(function(){
		if ($(this).attr('id')==instanceId)
		{
			$(this).remove(); 
			result = $(this);
			return false;	
		}
	 });
}

///选择病历导航列表显示样式
function GetRecordTypeValue()
{
	return "";
}

//显示病历操作记录明细
function showListLog(obj)
{
	event.stopPropagation();
	var obj = $(obj).closest("li");
	var instanceId = obj.attr("id");
	var docId = obj.attr("emrDocId");	
	var num = instanceId.split("||")[1];
	showLog(docId,num)	
}

function showLog(docId,num)
{
	var content = '<iframe id="framedialog" src="emr.instancelog.csp?EpisodeID='+episodeID+'&EMRDocId='+docId+'&EMRNum='+num+'&MWToken='+getMWToken()+'" frameborder="no" style="width:100%;height:100%;border:0;margin:0;padding:0;overflow:hidden"></iframe>';
	parent.$HUI.dialog('#dialog',{  
	    title: '操作日志',  
	    width: 980,  
	    height: 500,
	    border:false,
	    content: content,  
	    closed: true,  
	    cache: false, 
	    iconCls:'icon-w-list',
	    isTopZindex:true, 
	    modal: true 
	});
	parent.$HUI.dialog('#dialog').open();	
}

//更改选中的边框颜色
function checkOnClick(obj)
{
	if (obj.checked)
	{
		var li = $(obj).closest("li");
		$(li).find(".right").addClass("checkli");
	}
	else
	{
		var li = $(obj).closest("li");
		$(li).find(".right").removeClass("checkli");
	}	
}

function selectAll(obj)
{
	if (obj.checked)
	{
		$HUI.checkbox("input[name='recordList']").setValue(true);
	}
	else
	{
		$HUI.checkbox("input[name='recordList']").setValue(false);
	}	
} 
