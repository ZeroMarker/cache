$(function(){
	
	initRecord();
	initCategory(episodeID);
	if (setRecReferenceLayout == "east")
	{
		//对于左右对照的病历参考做处理
		 setRefLayoutEast()
	}
	
	//就诊类型
	$('#episodeType').combobox({  
		valueField:'id',  
		textField:'text',
		panelHeight:100,
		width:60,
		data:[
				{"id":"","text":"全部","selected":true},
				{"id":"O","text":"门诊"},
				{"id":"E","text":"急诊"},
				{"id":"I","text":"住院"}
			 ]
	}); 	
	//就诊列表
	$("#episodeList").datagrid({ 
	    width:'100%',
	    height:'100%', 
	    loadMsg:'数据装载中......',
	    url:'../EMRservice.Ajax.hisData.cls?Action=GetEpisodeList&PatientID='+patientID,
	    singleSelect:true,
	    rownumbers:true,	    
	    idField:'EpisodeID',
	    fit:true,
	    columns:[[  
	        {field:'EpisodeDate',title:'就诊日期',width:70},
	        {field:'Diagnosis',title:'诊断',width:100}, 
	        {field:'EpisodeType',title:'类型',width:50,formatter:formatColor}, 
	        {field:'EpisodeDeptDesc',title:'科室',width:100},     
	        {field:'MainDocName',title:'主治医生',width:70}, 
	        {field:'DischargeDate',title:'出院日期',width:60},
	        {field:'EpisodeID',title:'就诊号',width:40},
	        {field:'EpisodeDeptID',title:'科室ID',width:30,hidden:true}
	    ]],
	    onSelect:function(rowIndex,rowData){
		   initCategory(rowData.EpisodeID);
	    },
	    onDblClickRow:function(rowIndex,rowData){
		   $('#InstanceTreeTab').tabs('select','目录');
		   initCategory(rowData.EpisodeID);
	    }
  });	
	$("#episodeSeek").click(function(){
		queryData();
	});
});

function setCategory(data)
{
	$("#InstanceTree").html("");
	$("#InstanceTree").append('<div id="accordiontree" class="easyui-accordion" data-options="fit:true"></div>');
	for (var i=0;i<data.length;i++)
	{
		var ac = '<div title="'+data[i].name+'"><ul id="'+data[i].id+'Tree" class="ztree chats_ztree"></ul></div>'; 
        	$("#accordiontree").append(ac);
		$.fn.zTree.init($('#'+data[i].id+'Tree'), ztSetting, data[i].children);
        	var treeObj = $.fn.zTree.getZTreeObj(data[i].id+'Tree');
        	treeObj.expandAll(true);
	} 	
	$.parser.parse("#InstanceTree");	
}
//ztree显示、回调函数、数据格式配置
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
//ztree鼠标左键点击回调函数
function ztOnClick(event, treeId, treeNode)
{
	var tempParam = {
		"id":treeNode.id,
		"text":treeNode.attributes.text,
		"pluginType":treeNode.attributes.documentType,
		"chartItemType":treeNode.attributes.chartItemType,
		"emrDocId":treeNode.attributes.emrDocId,
		"characteristic":treeNode.attributes.characteristic,
		"status":"NORMAL"
	};
	if (window.frames["framebrowse"])
	{
		window.frames["framebrowse"].loadDocument(tempParam);
		setReferenceToEventLog(treeNode);
	}
}
//如果返回 false，zTree 将不会选中节点，也无法触发 onClick 事件回调函数
function ztBeforeClick(treeId, treeNode, clickFlag)
{
	//当是父节点 返回false 不让选取
	return !treeNode.isParent;
}

function initCategory(episodeID)
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
			"p1":episodeID				
		},
		success: function(d) {
			setCategory(eval("["+d+"]"));
		},
		error : function(d) { alert("GetInstance error");}
	});	
}

//初始化打开病历
function initRecord()
{
	var src = "emr.record.browse.browsform.editor.csp?";
    src = src + "id="+param.id+"&text="+param.text+"&chartItemType="+param.chartItemType;
    src = src + "&pluginType="+param.pluginType+"&episodeId="+episodeID+"&patientId="+patientID
    src = src + "&characteristic"+param.characteristic +"&status=NORMAL";	
    $('#framebrowse').attr("src",src);	
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
	if (flag) 
	{
		parent.parent.$('#reference').attr("disabled",false);
		flag = false;
	}
}

//复制剪切
function eventSendCopyCutData(commandJson)
{
    parent.eventSendCopyCutData(commandJson);
}

function setReferenceToEventLog(node)
{
	if (IsSetToLog == "Y")
	{
		var ipAddress = parent.getIpAddress();
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
		Condition = Condition + '"templateId":"' + node.attributes.templateId + '",';
		Condition = Condition + '"categoryId":"' + node.attributes.categoryId + '",';
		Condition = Condition + '"isLeadframe":"' + node.attributes.isLeadframe + '",';
		Condition = Condition + '"isMutex":"' + node.attributes.isMutex + '",';
		Condition = Condition + '"summary":"' + node.attributes.summary + '",';
		Condition = Condition + '"status":"' + node.attributes.status + '",';
		Condition = Condition + '"creator":"' + node.attributes.creator + '",';
		Condition = Condition + '"happendate":"' + node.attributes.happendate + '",';
		Condition = Condition + '"happentime":"' + node.attributes.happentime + '",';
		Condition = Condition + '"text":"' + node.text + '"}';
		var ConditionAndContent = Condition;
		$.ajax({ 
			type: "POST", 
			url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
			data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + SecCode
		});
	}
}

//对于左右对照的病历参考做处理
function setRefLayoutEast()
{
	//病历参考目录折叠时仍显示标题
	var Ltitle = $(".easyui-layout").layout("panel","south").panel('options').title;
	$(".layout-expand .panel-title").html(Ltitle);
	//使病历参考目录展开正常
	$("#referenceLayout .layout-expand .panel-header").click(function(){
		$("#referenceLayout").layout("expand","south");
	});
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
}


//查询就诊列表
function queryData()
{
	var queryItem = document.getElementById("diagnosDesc").value
	$("#episodeList").datagrid('load', {
		Action: "GetEpisodeList",
		PatientID: patientID,
		QueryItem: (queryItem == "诊断内容")? "":queryItem,
		EpisodeType: $('#episodeType').combobox('getValue')
	});	
}
//点击控件事件
function my_click(obj, myid)
{
	if (document.getElementById(myid).value == document.getElementById(myid).defaultValue)
	{
		document.getElementById(myid).value = '';
		obj.style.color='#000';
	}
}
//离开控件事件
function my_blur(obj, myid)
{
	if (document.getElementById(myid).value == '')
	{
		document.getElementById(myid).value = document.getElementById(myid).defaultValue;
		obj.style.color='#999'
	}
}