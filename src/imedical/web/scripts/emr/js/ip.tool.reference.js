
$(function(){
	      initRecord();
	
	//就诊类型
	$('#episodeType').combobox({  
		valueField:'id',  
		textField:'text',
		panelHeight:125,
		width:65,
		data:[
				{"id":"","text":emrTrans("全部"),"selected":true},
				{"id":"O","text":emrTrans("门诊")},
				{"id":"E","text":emrTrans("急诊")},
				{"id":"I","text":emrTrans("住院")},
				{"id":"H","text":emrTrans("体检")}
			 ],
	    onSelect:function(record){
            $('#episodeList').combogrid('grid').datagrid('options').url = '../EMRservice.Ajax.hisData.cls?Action=GetEpisodeList&PatientID='+patientID+'&EpisodeType='+$('#episodeType').combobox('getValue');
            $('#episodeList').combogrid('grid').datagrid('reload');
	    }
	}); 	
	//就诊列表
	$("#episodeList").combogrid({  
	    panelWidth:390,
        panelHeight:150,
	    loadMsg:'数据装载中......',
	    url:'../EMRservice.Ajax.hisData.cls?Action=GetEpisodeList&PatientID='+patientID,
	    singleSelect:true,
	    rownumbers:true,	    
	    idField:'EpisodeID',
	    textField:'EpisodeDate',
	    pagination:true, 
	    fit:true,
	    columns:[[  
	        {field:'EpisodeDate',title:'就诊日期',width:70},
	        {field:'Diagnosis',title:'诊断',width:100}, 
	        {field:'EpisodeType',title:'类型',width:50,formatter:formatColor}, 
	        {field:'EpisodeDeptDesc',title:'科室',width:100},     
	        {field:'MainDocName',title:'主治医生',width:70}, 
	        {field:'DischargeDate',title:'出院日期',width:60},
	        {field:'EpisodeID',title:'就诊号',width:40,hidden:true},
	        {field:'EpisodeDeptID',title:'科室ID',width:30,hidden:true}
	    ]],
	    onSelect:function(rowIndex,rowData){
		   episodeID = rowData.EpisodeID;
		   initCategory();
	    },
	    onDblClickRow:function(rowIndex,rowData){
		   episodeID = rowData.EpisodeID;
		   initCategory();

	    }
  	});
  	initCategory();	
});

//初始化打开病历
function initRecord()
{
	if (instanceID !="")
	{
	   var src = "emr.record.browse.browsform.editor.csp?";
       src = src + "id="+param.id+"&text="+param.text+"&chartItemType="+param.chartItemType;
       src = src + "&pluginType="+param.pluginType+"&episodeId="+episodeID+"&patientId="+patientID
       src = src + "&characteristic"+param.characteristic+"&status=NORMAL"+"&Action=reference&MWToken="+getMWToken();
       $('#framebrowse').attr("src",src);
	}
    else
    {
	    var src = "emr.record.browse.browsform.editor.csp?MWToken="+getMWToken();
        $('#framebrowse').attr("src",src);
    }
	
}

function initCategory()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"GetReferenceJsons",
			"p1":episodeID,
			"p2":"List"	
		},
		success: function(d) {
			if (d != "")
			{
				setCategory(eval("["+d+"]"));
			}
		},
		error : function(d) { alert("GetInstance error");}
	});	
}

function setCategory(data)
{	
	$('#InstanceTree').tree({
		data:data,
		onClick: function(node){
			if (node.nodeType == "instance")
			{
				ztOnClick(node)
			}
		}
	});	
}

function ztOnClick(node)
{
	var tempParam = {
		"id":node.id,
		"text":node.text,
		"pluginType":node.documentType,
		"chartItemType":node.chartItemType,
		"emrDocId":node.emrDocId,
		"characteristic":node.characteristic,
		"status":"NORMAL",
        "episodeId":episodeID
	};
	if (document.getElementById("framebrowse"))
	{
		document.getElementById("framebrowse").contentWindow.loadDocument(tempParam);
		setReferenceToEventLog(node);
	}
}

///事件派发
function eventDispatch(obj)
{
	if (obj.action == 'eventLoadDocument')
	{
		eidtEventLoadDocument(obj);
	}
	else if(obj.action == 'eventSendCopyCutData')
	{
		eventSendCopyCutData(obj);
	}
}

///编辑器文档加载完毕
function eidtEventLoadDocument(obj)
{
	if (flag) flag = false;
}

//复制剪切
function eventSendCopyCutData(commandJson)
{
    parent.eventDispatch(commandJson);
}

function setReferenceToEventLog(node)
{
	if (IsSetToLog == "Y")
	{
		var ipAddress = getIpAddress();
		var ModelName = "EMR.Reference.ReferenceNav.Open";
		var Condition = "";
		Condition = Condition + '{"patientID":"' + patientID + '",';
		Condition = Condition + '"episodeID":"' + episodeID + '",';
		Condition = Condition + '"userName":"' + userName + '",';
		Condition = Condition + '"userID":"' + userID + '",';
		Condition = Condition + '"ipAddress":"' + ipAddress + '",';
		Condition = Condition + '"id":"' + param["id"] + '",';
		Condition = Condition + '"pluginType":"' + param["pluginType"] + '",';
		Condition = Condition + '"chartItemType":"' + param["chartItemType"] + '",';
		Condition = Condition + '"emrDocId":"' + param["emrDocId"] + '",';
		Condition = Condition + '"templateId":"' + node.templateId + '",';
		Condition = Condition + '"categoryId":"' + node.categoryId + '",';
		Condition = Condition + '"isLeadframe":"' + node.isLeadframe + '",';
		Condition = Condition + '"isMutex":"' + node.isMutex + '",';
		Condition = Condition + '"summary":"' + node.summary + '",';
		Condition = Condition + '"status":"' + node.status + '",';
		Condition = Condition + '"creator":"' + node.creator + '",';
		Condition = Condition + '"happendate":"' + node.happendate + '",';
		Condition = Condition + '"happentime":"' + node.happentime + '",';
		Condition = Condition + '"text":"' + node.text + '"}';
		var ConditionAndContent = Condition;
		$.ajax({ 
			type: "POST", 
			url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
			data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + SecCode
		});
	}
}

function formatColor(val,row)
{
	if (row.EpisodeType == "住院")
	{
		return '<span style="color:green;">'+val+'</span>';
	}
	else if (row.EpisodeType == "门诊")
	{
		return '<span style="color:red;">'+val+'</span>';
	}
	else if (row.EpisodeType == "急诊")
	{
		return '<span style="color:blue;">'+val+'</span>';
	}
	else if (row.EpisodeType == "体检")
	{
		return '<span style="color:green;">'+val+'</span>';
	}	
}
//刷新病历目录
function refreshTreeData()
{
    initCategory();
}

function copyData(){
	var returnvalue = "";
	if (document.getElementById("framebrowse"))
	{
		returnvalue = document.getElementById("framebrowse").contentWindow.selectedContent();
	}
	if (returnvalue){
		if (window.opener){
			window.opener.insertText(returnvalue);
		}else{
			parent.eventDispatch({"action":"insertText","text":returnvalue});
		}
	}
}
