var defaultload = 0;
$(function(){
    loadOperations();
    loadNoLink();
});

function init()
{
    var p = $('#operations').accordion('getSelected');
    if (p){
        loadOperationTemplate(defaultload);
    }
}

///加载手术信息
function loadOperations()
{
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.Event.BLEvents",
            "Method":"GetData",
            "p1":"Operation",
            "p2":gl.episodeId
        },
        success: function(d) {
            d = eval("["+d+"]");
            if (d == "") return;
            removeAccordion();
            var count = 0;
            var panels =  $("#operations").accordion("panels");
            var length = panels.length + d.length;
            for (i=panels.length;i<length;i++)
            {
                var OperPAStatus = "";
                if ((d[i].OperPAStatus == "拒绝")||(d[i].OperPAStatus == "撤销")){
                    OperPAStatus = "<span id='pastatus"+i+"' style='padding-left:10px;color:red;'>"+d[i].OperPAStatus+"</span>";
                }else{
                    OperPAStatus = "<span id='pastatus"+i+"' style='padding-left:10px;color:#000000;'>"+d[i].OperPAStatus+"</span>";
                    if ((count == 0)&&(defaultload == 0))
                    {
                        defaultload = i ;
                    }
                    count = count + 1;
                }
                var title =d[i].OperDate+" "+d[i].OperTime+" | "+d[i].OperDesc+" | "+d[i].OperDocName+" | "+d[i].OperAssistFirstDesc+" | "+d[i].OperAssistSecondDesc+OperPAStatus;
                var content = '<div id="display'+i+'" style="fit:true;overflow-y:hidden"><ul class="display" id ="'+d[i].ID+'"></ul></div>';
                addAccordion(title,content,false,d[i].ID);
            }
        },
        error : function(d) { alert("查数据出错");}
    });	
}

function removeAccordion()
{
    var accObj = $HUI.accordion('#operations');
    if (accObj.panels().length > 0)
    {
        accObj.remove(0);
        removeAccordion();
    }
}

//添加手术记录选项卡
function addAccordion(title,content,select,id)
{
    var pp = $('#operations').accordion("getPanel",title);
    if (!pp)
    {
        $('#operations').accordion('add',{
            id: id,
            title: title,
            content: content,
            selected: select
        });	
    }
}

//选择手术项目，加载要写的模板及写过的病历
$(function(){
    $('#operations').accordion({
        onSelect:function(title,index){
            defaultload = index;
            //加载手术模板
            loadOperationTemplate(index);
        }
    }); 
});

///Desc:加载手术模板
function loadOperationTemplate(index){
    var panel = $("#operations").accordion('getPanel',index);
    var id = panel[0].id;
	panel[0].style.height = 'auto';
    if (id == "noLinkDocument")
    {
        loadNoLinkDocument(index,gl.categoryId);
    }else if(id == "noLinkTemplate")
    {
        loadNoLinkTemplate(index,gl.categoryId);
    }else if (id != undefined && id != "")
    {
        //加载模板
        loadTemplate(index,id,gl.categoryId);
    }
}

///Desc:加载模板
function loadTemplate(index,opereventId,categoryId)
{
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLClientCategory",
            "Method":"GetTempCateJsonByCategoryID",
            "p1":categoryId,
            "p2":gl.episodeId,
            "p3":gl.userId,
            "p4":"",
            "p5":"Operation",
            "p6":opereventId
        },
        success: function(d) {
            $('#display'+index+' .display').empty();
            if ($('#pastatus'+index).text() != "拒绝" && $('#pastatus'+index).text() != "撤销"){
                if (d != "")
                {
                    setTemplate(index,eval("["+d+"]"),categoryId);
                }
            }
            //加载病历
            if ((opereventId != "")&&(opereventId != undefined))
            {
                getRecord(index,opereventId,categoryId);
            }
        },
        error : function(d) { 
            alert("Template error");
        }
    });
}

//加载模板
function setTemplate(index,data,categoryId,template)
{
    for (var i=0;i<data.length;i++)
    {
        var link = $('<li onClick="createDocument(this)"></li>');
        $(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].attributes.isLeadframe});
        $(link).attr({"chartItemType":data[i].attributes.chartItemType,"documentType":data[i].attributes.documentType});
        $(link).attr({"isMutex":data[i].attributes.isMutex,"categoryId":categoryId});
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
        if (typeof template != "undefined")
        {
            $(template).append(link);
        }else{
            $('#display'+index+' .display').append(link);	
        }
    }
}

//加载实例
function getRecord(index,opereventId,categoryId)
{
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLClientCategory",
            "Method":"GetInstanceByCategoryEvent",
            "p1":categoryId,
            "p2":gl.episodeId,
            "p3":"Operation",
            "p4":opereventId,
            "p5":gl.sequence
        },
        success: function(d) {
            if (d != "")
            {
                setRecord(index,eval("["+d+"]"),categoryId);
            }
        },
        error : function(d) { 
            alert("getRecord error");
        }
    });	
}

//加载文档
function setRecord(index,data,categoryId,record)
{
    for (var i=0;i<data.length;i++)
    {
        var link = $('<li onClick="openDocument(this)"></li>');
        $(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].isLeadframe});
        $(link).attr({"chartItemType":data[i].chartItemType,"documentType":data[i].documentType});		
        $(link).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":categoryId});
        $(link).attr({"templateId":data[i].templateId,"characteristic":data[i].characteristic});
        
        var div = $('<div class="instance"></div>');
        var contentclass = "class = 'content'";
		if ((data[i].doctorwait != "")&&(data[i].patientwait != ""))
		{
			var contentclass = getContentClass(data[i].doctorwait,data[i].patientwait);
		}
		$(div).append('<a href="#"><div ' +contentclass+ '>' +data[i].summary+ '</div></a>');
        var tag = $('<div class="tag" onmouseover="tip.show(this)" onmouseout="tip.hide()"></div>');
        $(tag).append('<div title="'+data[i].text+ '" class="title">' +data[i].text+ '</div>');
        $(tag).append('<div class="time">' +data[i].happendate+" "+data[i].happentime+" "+'</div>');
        $(tag).append('<div class="janespell" style="display:none;">' +data[i].JaneSpell+ '</div>');
        $(tag).append('<div class="fullfight" style="display:none;">' +data[i].FullFight+ '</div>');
        $(link).append($(div).append(tag));
        if (typeof record != "undefined")
        {
            $(record).append(link);
        }else{
            $('#display'+index+' .display').append(link);
        }
    }
}

//无关联病历、模板
function loadNoLink()
{
    var noLinkDocumentData = getNoLinkDocument(gl.categoryId);
    if (noLinkDocumentData != "")
    {
        var title = "无关联病历";
        var panels = $("#operations").accordion("panels");
        var i = panels.length;
        var content = $('<div id="display'+i+'" style="width:100%;height:100%;overflow-y:scroll"></div>');
        var record = $('<ul class="display" id=""></ul>');
        setRecord(i,noLinkDocumentData,gl.categoryId,record);
        $(content).append(record);
        addAccordion(title,content,false,"noLinkDocument");
    }
    var noLinkTemplateData = getNoLinkTemplate(gl.categoryId);
    if (noLinkTemplateData != "")
    {
        var title = "无关联手术模板";
        var panels = $("#operations").accordion("panels");
        var i = panels.length;
        var content = $('<div id="display'+i+'" style="width:100%;height:100%;overflow-y:scroll"></div>');
        var template = $('<ul class="display" id=""></ul>');
        setTemplate(i,noLinkTemplateData,gl.categoryId,template);
        $(content).append(template);
        addAccordion(title,content,false,"noLinkTemplate");
    }
}

//获取无关联病历
function getNoLinkDocument(categoryId)
{
    var result = "";
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLClientCategory",
            "Method":"GetInstanceNoLinkEvent",
            "p1":categoryId,
            "p2":gl.episodeId,
            "p3":"Operation"
        },
        success: function(d) {
            if (d != "")
            {
                result = eval("["+d+"]");
            }
        },
        error : function(d) { 
            alert("getInstanceNoLinkEvent error");
        }
    });
    return result;
}

//加载无关联病历
function loadNoLinkDocument(index,categoryId)
{
    $('#display'+index+' .display').empty();
    var noLinkDocumentData = getNoLinkDocument(categoryId);
    if (noLinkDocumentData != "")
    {
        setRecord(index,noLinkDocumentData,categoryId);
    }
}

//获取无关联模板
function getNoLinkTemplate(categoryId)
{
    var result = "";
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLClientCategory",
            "Method":"GetTempCateJsonNoLink",
            "p1":categoryId,
            "p2":gl.episodeId,
            "p3":gl.userId,
            "p4":"",
            "p5":"Operation"
        },
        success: function(d) {
            if (d != "")
            {
                result = eval("["+d+"]");
            }
        },
        error : function(d) { 
            alert("getTempCateJsonNoLink error");
        }
    });
    return result;
}

//加载无关联模板
function loadNoLinkTemplate(index,categoryId)
{
    $('#display'+index+' .display').empty();
    var noLinkTemplateData = getNoLinkTemplate(categoryId);
    if (noLinkTemplateData != "")
    {
        setTemplate(index,noLinkTemplateData,categoryId);
        var panels =  $("#operations").accordion("panels");
        var result = IsPanelExitById(panels,"noLinkDocument");
        if (!result[0])
        {
            var noLinkDocumentData = getNoLinkDocument(categoryId);
            if (noLinkDocumentData != "")
            {
                var title = "无关联病历";
                var i = panels.length;
                var content = $('<div id="display'+i+'" style="width:100%;height:100%;overflow-y:scroll"></div>');
                var record = $('<ul class="display" id=""></ul>');
                setRecord(i,noLinkDocumentData,categoryId,record);
                $(content).append(record);
                addAccordion(title,content,false,"noLinkDocument");
            }
        }
    }
}

//判断panel是否存在
function IsPanelExitById(panels,id)
{
    var result = [false,0]
    for(var i=0; i< panels.length; i++){
        if (panels[i].panel("options").id == id)
        {
            result = [true,i];
        } 
    }
    return result;
}

//从模板新建
function createDocument(obj){
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
     
    tabParam = getParamByUserTemplate(tabParam);
    if (tabParam == "") return;  
    /*///创建病历 	
    operateRecord(tabParam);	
    
    //自动记录病例操作日志
    CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");*/
}

//打开文档
function openDocument(obj)
{
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
        "closable":true
    }; 	
    operateRecord(tabParam);
    
    //自动记录病例操作日志
    openDocumentLog(tabParam,"EMR.Nav.RecordNav.Open");
}

///过滤页面卡片
function searchSelect(value)
{
    if(!(/^[\u4e00-\u9fa5]+$/i).test(value)){
         value = value.toUpperCase();
    }
    var selectOperation = $('#operations').accordion('getSelected');
    if (selectOperation)
    {
        var index = $('#operations').accordion('getPanelIndex',selectOperation);
        $('#display'+index+' .display li').hide();
        var $instance = $('#display'+index+' .display li .instance .tag').filter(":contains('"+$.trim(value)+"')");
        $instance.parent().parent().show();
        var $template = $('#display'+index+' .display li .template').filter(":contains('"+$.trim(value)+"')");
        $template.parent().show();	
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
