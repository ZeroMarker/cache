$(function(){
	initRecord();
	initCategory();
	if (setRecReferenceLayout == "east")
	{
		//对于左右对照的病历参考做处理
		 setRefLayoutEast()
	}
});

function setCategory(data)
{
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

function initCategory()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"web.DHCCM.EMRservice.BL.BLClientCategory",
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
	var src = "dhcpha.clinical.record.browse.browsform.editor.csp?";
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