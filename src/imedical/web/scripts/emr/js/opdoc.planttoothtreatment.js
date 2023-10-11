var count = 0;
var tempTreatmentId = "";	//记录当前打开病历的疗程id
var tempIndex="";		//记录当前打开病历的index（每个折叠板都有index，从上到下从0开始）
$(function(){
	getAccordionInfo(gl.patientId);
});

//添加疗程
document.getElementById("addCourse").onclick = function(){
	var content = "<iframe id='addCourseFrame' scrolling='auto' frameborder='0' src='emr.opdoc.planttoothtreatment.addCourse.csp?MWToken="+getMWToken()+"' style='width:100%; height:100%;'></iframe>";
	parent.createModalDialog('addCourseDialog',"添加种植牙疗程",400,300,'addCourseFrame',content,addCourse,'');
}

function addCourse(returnValue,arr)
{
	if(returnValue !== "")
	{
		var time = new Date();
		var timeNum = time.toLocaleString();
		var id = parseInt(timeNum.replace(/[^0-9]/ig,""));
		//alert(returnValue);
		var content = '<div id="display'+count+'" style="fit:true"><ul class="display" id ="'+id+'"></ul></div>';
		var title = '<a onclick=modifyTitle("'+returnValue.split('-')[0]+'","'+returnValue.split('-')[1]+'","'+id+'","'+count+'")>'+returnValue+'</a>'
		addAccordion(title,content,true,id);
		//过0.5秒后执行加载模板
		setTimeout(function(){
                getTemplate("EMRservice.BL.BLPlantToothTreatment","GetTempCateJsonByCategoryID",false,count,"");
                count = count + 1;
            }, 500);
        tempIndex = count;
        recordTreatment(id,returnValue,"",gl.episodeId,gl.patientId,gl.userId);	//记录到表中新建疗程的记录
	}
}

document.getElementById("btnDelete").onclick = function(){
	var accObj = $HUI.accordion('#courseList');
	var p = accObj.getSelected();
	if (p){	
		if (isDeleteRecord(p[0].id) !== "")
		{
			top.$.messager.alert("提示信息：","当前展开疗程下有实例病历，如要删除当前疗程，请先删除病历",'info');
			return;
		}
		var tipMsg = "是否确认删除当前展开疗程";
		top.$.messager.confirm("操作提示", tipMsg, function (data) {
			if (!data)
			{   
				return ;
			}
			else 
			{
				var _accObj = $HUI.accordion('#courseList');
				var _p = _accObj.getSelected();
		        var _idx = _accObj.getPanelIndex(_p);
		        accObj.remove(_idx);
		        count = count - 1;
		        deleteRecord(p[0].id);
		    }
		});
	}
	else
	{
		top.$.messager.alert("提示信息：","当前没有展开的疗程",'info')
	}
}

//删除疗程前判断该疗程下是否有实例
function isDeleteRecord(treatmtId)
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"string",
			"Class":"EMRservice.BL.BLPlantToothTreatment",
			"Method":"getInstanceIdByTreatId",
			"p1":gl.patientId,
			"p2":treatmtId
		},
		success: function(d) {
			if (d !== "") result = d;
		},
		error : function(d) { 
			alert("isDeleteRecord error");
		}
	});
	return result;
}


//获得模板
function getTemplate(className,methodName,async,index,treatmentId)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: async,
		data: {
			"OutputType":"Stream",
			"Class":className,
			"Method":methodName,
			"p1":gl.categoryId,
			"p2":gl.episodeId,
			"p3":gl.userId,
			"p4":"",
			"p5":treatmentId,
			"p6":gl.patientId
		},
		success: function(d) {
			$('#display'+index+' .display').empty();
			setTemplate(eval("["+d+"]"),index);
		},
		error : function(d) { 
			alert("getTemplate error");
		}
	});
}
//加载模板
function setTemplate(data,index)
{
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li onClick="createDocument(this)"></li>');
		$(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].attributes.isLeadframe});
		$(link).attr({"chartItemType":data[i].attributes.chartItemType,"documentType":data[i].attributes.documentType});
		$(link).attr({"isMutex":data[i].attributes.isMutex,"categoryId":gl.categoryId});
		$(link).attr({"templateId":data[i].attributes.templateId});
		
		var div = $('<div class="template"></div>');
		if (data[i].attributes.quotation == "1")
		{
			$(div).append('<a href="#"><div class="new" ><div class="title">' +data[i].text+ '</div></div></a>');
			$(div).append('<a href="#"><div class="quote"></div></a>');	
		}
		else
		{
			$(div).append('<a href="#"><div class="title">' +data[i].text+ '</div></a>');
		}
		$(div).append('<div class="janespell" style="display:none;">' +data[i].attributes.JaneSpell+ '</div>');
		$(div).append('<div class="fullfight" style="display:none;">' +data[i].attributes.FullFight+ '</div>');
		$(link).append(div);
		$('#display'+index+' .display').append(link);
	}
}

//加载实例
function getRecord(className,methodName,async,index,treatmentId)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: async,
		data: {
			"OutputType":"Stream",
			"Class":className,
			"Method":methodName,
			"p1":gl.patientId,
			"p2":treatmentId
		},
		success: function(d) {
			setRecord(eval("["+d+"]"),gl.categoryId,index);
		},
		error : function(d) { 
			alert("getRecord error");
		}
	});	
}
//加载文档
function setRecord(data,categoryId,index)
{
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li onClick="openDocument(this)"></li>');
		$(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].isLeadframe});
		$(link).attr({"chartItemType":data[i].chartItemType,"documentType":data[i].documentType});		
		$(link).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":categoryId});
		$(link).attr({"templateId":data[i].templateId,"characteristic":data[i].characteristic});
		$(link).attr({"epsiodeId":data[i].epsiodeId,"instanceId":data[i].instanceId});
		
		var div = $('<div class="instance"></div>');
		var contentclass = "class = 'content'";
		if ((data[i].doctorwait != "")&&(data[i].patientwait != ""))
		{
			var contentclass = getContentClass(data[i].doctorwait,data[i].patientwait);
		}
		$(div).append('<a href="#"><div ' +contentclass+ '>' +data[i].summary+ '</div></a>');
		var tag = $('<div class="tag"></div>');
		$(tag).append('<div title="'+data[i].text+ '" class="title">' +data[i].text+ '</div>');
		$(tag).append('<div class="time">' +data[i].happendate+" "+data[i].happentime+" "+'</div>');
		$(tag).append('<div class="janespell" style="display:none;">' +data[i].JaneSpell+ '</div>');
		$(tag).append('<div class="fullfight" style="display:none;">' +data[i].FullFight+ '</div>');
		$(link).append($(div).append(tag));
		$('#display'+index+' .display').append(link);
	}
}

//增加折叠卡
function addAccordion(title,content,select,id)
{
    var pp = $('#courseList').accordion("getPanel",title);
    if (!pp)
    {
        $('#courseList').accordion('add',{
            id: id,
            title: title,
            content: content,
            selected: select
        });
    }
}

//打开折叠板时触发
$(function(){
    $('#courseList').accordion({
        onSelect:function(title,index){
            //加载模板
            var pp = $('#courseList').accordion("getPanel",title);
            var treatmentId = pp[0].id;
            if (tempTreatmentId == treatmentId) tempIndex = index;	//增加判断当前打开的病历是否在当前展开折叠板中（展开折叠板时触发），true：把当前index赋值给全局变量
            getTemplate("EMRservice.BL.BLPlantToothTreatment","GetTempCateJsonByCategoryID",false,index,treatmentId);
            getRecord("EMRservice.BL.BLPlantToothTreatment","getInstancesJsonById",false,index,treatmentId);
        }
    }); 
});

//记录新建疗程到疗程表中
function recordTreatment(treatmentId,title,instanceId,episodeId,patientId,userId)
{
	var name = title.split("-")[0];
	var desc = title.split("-")[1];
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"",
			"Class":"EMRservice.BL.BLPlantToothTreatment",
			"Method":"insertRecord",
			"p1":treatmentId,
			"p2":name,
			"p3":desc,
			"p4":instanceId,
			"p5":episodeId,
			"p6":patientId,
			"p7":userId
		},
		success: function(d) {
			if (d == 1)
			{
				
			}
		},
		error : function(d) { 
			alert("recordTreatment error");
		}
	});
}

//修改名称和描述
function modifyTitle(name,desc,id,index)
{
	var arr = {"id":id,"index":index};
	var content = "<iframe id='addCourseFrame' scrolling='auto' frameborder='0' src='emr.opdoc.planttoothtreatment.addCourse.csp?name="+name+"&desc="+desc+"&action=modify&MWToken="+getMWToken()+"' style='width:100%; height:100%;'></iframe>";
	parent.createModalDialog('addCourseDialog',"修改种植牙疗程名称描述",400,300,'addCourseFrame',content,modifyTitleBack,arr);
}

function modifyTitleBack(returnValue,arr)	//modifyNameDescById
{
	if (returnValue == "") return;
	var id = arr.id;
	var index = arr.index;
	var name = returnValue.split("-")[0];
	var desc = returnValue.split("-")[1];
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"string",
			"Class":"EMRservice.BL.BLPlantToothTreatment",
			"Method":"modifyNameDescById",
			"p1":gl.patientId,
			"p2":id,
			"p3":name,
			"p4":desc
		},
		success: function(d) {
			if (d == 1)
			{
				var title = '<a onclick=modifyTitle("'+name+'","'+desc+'","'+id+'","'+index+'")>'+returnValue+'</a>';
				$('#courseList').accordion("getPanel", Number(index)).panel("setTitle", title);
			}
		},
		error: function(d){
			alert("modifyTitleBack error");
		}
	})
}

//获得所有折叠板信息
function getAccordionInfo(patientId)
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"string",
			"Class":"EMRservice.BL.BLPlantToothTreatment",
			"Method":"getAccordionInfo",
			"p1":patientId
		},
		success: function(d) {
			result = eval("["+d+"]");
			for(var i=0;i<result.length;i++)
			{
				var content = '<div id="display'+count+'" style="fit:true"><ul class="display" id ="'+result[i].id+'"></ul></div>';
				addAccordion(result[i].title,content,true,result[i].id)
				if (i == result.length-1)	//加载完页面后只有最后一个折叠板是打开的，加载模板和实例
				{
					setTimeout(function(){
				        getTemplate("EMRservice.BL.BLPlantToothTreatment","GetTempCateJsonByCategoryID",false,count-1,result[count-1].id);
				        getRecord("EMRservice.BL.BLPlantToothTreatment","getInstancesJsonById",false,count-1,result[count-1].id);
				    }, 500);
				}
				tempIndex = count;
				count = count + 1;
			}
		},
		error : function(d) {
			alert("getAccordionInfo error");
		}
	});
}

//删除疗程
function deleteRecord(treatmentId)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"string",
			"Class":"EMRservice.BL.BLPlantToothTreatment",
			"Method":"deleteRecord",
			"p1":gl.patientId,
			"p2":treatmentId
		},
		success: function(d) {
			if (d == 1)
			{	//这里重新加载页面，是为了保证每个折叠板title上的id是连续的（修改名称和标题时用）
				window.location.reload();
			}
		},
		error : function(d) { 
			alert("deleteRecord error");
		}
	});
}

//从模板打开病历
function createDocument(obj)
{
	var p = $('#courseList').accordion('getSelected');
	if (p){
		tempIndex = $('#courseList').accordion('getPanelIndex', p);
	}
	tempTreatmentId = p[0].id;
	var eventId = $(obj).parent().attr("id");
    var obj = $(obj).closest("li");
    var tabParam ={
        "id":"",
        "text":obj.attr("text"),
        "pluginType":obj.attr("documentType"),
        "chartItemType":obj.attr("chartItemType"),
        "emrDocId":obj.attr("id"),
        "templateId":obj.attr("templateId"),
        "isLeadframe":obj.attr("isLeadframe"),
        "isMutex":obj.attr("isMutex"),
        "categoryId":obj.attr("categoryId"),
        "actionType":"CREATE",
        "status":"NORMAL",
        "closable":true,
        "args":{
            "event":{
                "EventType":"Operation",
                "EventID":eventId
            }
        }
     };
     var temp = parent.emrEditor.createDoc(tabParam);
     if (temp == "") return;
}

//从实例打开病历
function openDocument(obj)
{
	var p = $('#courseList').accordion('getSelected');
	if (p){
		tempIndex = $('#courseList').accordion('getPanelIndex', p);
	}
	tempTreatmentId = p[0].id;
	var obj = $(obj).closest("li");
	var tabParam ={
		"id":obj.attr("id"),
		"text":obj.attr("text"),
		"pluginType":obj.attr("documentType"),
		"chartItemType":obj.attr("chartItemType"),
		"emrDocId":obj.attr("emrDocId"),
		"templateId":obj.attr("templateId"),
		"isLeadframe":obj.attr("isLeadframe"),
		"isMutex":obj.attr("isMutex"),
		"categoryId":obj.attr("categoryId"),
		"characteristic":obj.attr("characteristic"),
		"actionType":"LOAD",
		"status":"NORMAL",
		"closable":true,
		"epsiodeId":obj.attr("epsiodeId"),
		"instanceId":obj.attr("instanceId"),
	};
	if (tabParam.epsiodeId !== gl.episodeId)	//如果打开的病历不是本次就诊病历，则用模态框进行打开
	{
		var content = "<iframe id='planttoothtreatmentFrame' scrolling='auto' frameborder='0' src='emr.interface.ip.main.csp?EpisodeID="+tabParam.epsiodeId+"&UserCode="+gl.userCode+"&UserID="+gl.userId+"&GroupID="+gl.ssgroupID+"&CTLocID="+gl.userLocId+"&DocID="+tabParam.emrDocId+"&InstanceID="+tabParam.instanceId+"&DisplayType=&RecordShowType=Doc&MWToken="+getMWToken()+"' style='width:100%; height:100%;'></iframe>";
        parent.createModalDialog('planttoothtreatment',"种植牙疗程病历",1600,800,'planttoothtreatmentFrame',content,'','');
	}
	else
	{
		var tabId = parent.emrTemplate.getTabId(tabParam.templateId, tabParam.instanceId);
		parent.emrTemplate.selectTmplTab(tabId);
	}
}

function getContentClass(doctorwait,patientwait)
{
	var contentclass = "class = 'content'";
	if ((doctorwait == "1")&&(patientwait == "1"))
	{
		contentclass = "class = 'content doctorwait patientwait'";
	}
	else if(doctorwait == "1")
	{
		contentclass = "class = 'content doctorwait'";
	}
	else if(patientwait == "1")
	{
		var contentclass = "class = 'content patientwait'";
	}
	return contentclass;
}

//保存病历成功后调用该方法，把本次就诊号和InstanceId更新到种植牙表中对应的TreatmentID下
function UpdateRecord(InstanceId)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"string",
			"Class":"EMRservice.BL.BLPlantToothTreatment",
			"Method":"updateRecord",
			"p1":gl.patientId,
			"p2":tempTreatmentId,
			"p3":gl.episodeId,
			"p4":InstanceId
		},
		success: function(d) {
			if (d == 1)
			{
				$('#courseList').accordion('select',tempIndex);
				getTemplate("EMRservice.BL.BLPlantToothTreatment","GetTempCateJsonByCategoryID",false,tempIndex,tempTreatmentId);
				getRecord("EMRservice.BL.BLPlantToothTreatment","getInstancesJsonById",false,tempIndex,tempTreatmentId);
			}
		},
		error : function(d) { 
			alert("UpdateRecord error");
		}
	});
}

//删除病历后对表中字段做相应的改变
function deleteRecordInstanceId(InstanceId)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"string",
			"Class":"EMRservice.BL.BLPlantToothTreatment",
			"Method":"deleteRecordInstanceId",
			"p1":InstanceId
		},
		success: function(d) {
			if (d == 1)
			{
				$('#courseList').accordion('select',tempIndex);
				getTemplate("EMRservice.BL.BLPlantToothTreatment","GetTempCateJsonByCategoryID",false,tempIndex,tempTreatmentId);
				getRecord("EMRservice.BL.BLPlantToothTreatment","getInstancesJsonById",false,tempIndex,tempTreatmentId);
			}
		},
		error : function(d) {
			alert("deleteRecordInstanceId error");
		}
	});
}