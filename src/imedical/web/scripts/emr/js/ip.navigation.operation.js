var defaultload = 0;
var operViewType = "";
var opereventId = "";
$(function(){
//选择手术项目，加载要写的模板及写过的病历
    $('#operations').accordion({
        onSelect:function(title,index){
            defaultload = index;
            //加载手术模板
            loadOperationTemplate(index);
        }
    }); 
    if (gl.isShowAppendOperations == 'N')
    {
        $('#operate').layout('remove','north');
    }
    if(gl.viewType == "LIST"){
        setListView();
    }else{
        setCardView();
    }
});

function setCardView()
{
	$('#personalDiv').css("display","none");
	$('#personalTemp').checkbox('uncheck')
    gl.viewType = "CARD";
    $("#operate").layout('remove','east');
    $('#operate').layout('resize');
    operViewType = "";
    loadOperations();
    loadNoLink();
}

function setListView()
{
	$('#personalDiv').css("display","block");
    gl.viewType = "LIST";
    var options = {border:false,split:true,region:'east',overflow:'hidden',id:'east'};
    $('#operate').layout('add', options);
    $("#east").append('<table id="gridshow" title="表格病历列表" style="border:0;padding:15px 5px 5px 5px"></table>');
    var xpwidth=window.screen.width * 0.45;
    $('#east').panel('resize', {width:xpwidth});
    $('#operate').layout('resize');
    initAllRecordGrid();
    operViewType = "List";
    loadOperations();
    loadNoLink();
    getAllRecord();
}

function init()
{
    var p = $('#operations').accordion('getSelected');
    if (p){
        $('#operations').accordion('unselect',defaultload);
        $('#operations').accordion('select',defaultload);
    }
    if (gl.viewType == "LIST")
    {
        getAllRecord();
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
            if (d == "") return;
            d = eval("["+d+"]");
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
    if (gl.viewType =="LIST")
    {
        var arrtitle = title.split("|")
        var ntitle = arrtitle.slice(0,-1).join("|")
        title = (ntitle.length>40?ntitle.slice(0,41)+"...":ntitle) + arrtitle.splice(-1)
    }
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

///Desc:加载手术模板
function loadOperationTemplate(index){
    var panel = $("#operations").accordion('getPanel',index);
    var id = panel[0].id;
    panel[0].style.height = 'auto';
    if (id == "noLinkTemplateDocument")
    {
        loadNoLinkTemplateDocument(index,gl.categoryId);
    }else if (id != undefined && id != "")
    {
	    if ($("#personalTemp").is(':checked'))
	    {
		    loadPersonalTemplate(index,id,gl.categoryId)
		}
		else
		{
			//加载模板
	        loadTemplate(index,id,gl.categoryId);
		}
    }
}

function loadPersonalTemplate(index,opereventId,categoryId)
{
	var d = loadPersonTemplate('');
	$('#display'+index+' .display').empty();
    if ($('#pastatus'+index).text() != "拒绝" && $('#pastatus'+index).text() != "撤销")
    {
	    if (d != "")
	    {
	        if (operViewType == "List")
	        {
	            $('#display'+index+' .display').append('<table id=grid'+index+'></table>');
	            gridList(index);
	            var data = d;
	            $('#grid'+index).treegrid('loadData',data);
	        }else{
	            setTemplate(index,data,categoryId);
	        }
	    }
	    //加载病历
	    if ((opereventId != "")&&(opereventId != undefined)&&(gl.type!="Template"))
	    {
	        getRecord(index,opereventId,categoryId);
	    }    
	}
}

///Desc:加载模板
function loadTemplate(index,opereventId,categoryId)
{
	if((index === "")||(opereventId == "")||(categoryId == "")) return;
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLClientCategory",
            "Method":"GetTempCateJsonByCategoryIDNew",
            "p1":categoryId,
            "p2":gl.episodeId,
            "p3":gl.userId,
            "p4":operViewType,
            "p5":"Operation",
            "p6":opereventId,
            "p7":gl.userLocId,
            "p8":"",
            "p9":gl.userLocId
        },
        success: function(d) {
            $('#display'+index+' .display').empty();
            if ($('#pastatus'+index).text() != "拒绝" && $('#pastatus'+index).text() != "撤销"){
                if (d != "")
                {
                    if (operViewType == "List")
                    {
                        $('#display'+index+' .display').append('<table id=grid'+index+'></table>');
                        gridList(index);
                        var data = eval("["+d+"]");
                        $('#grid'+index).treegrid('loadData',data);
                    }else{
                        setTemplate(index,eval("["+d+"]"),categoryId);
                    }
                }
            }
            //加载病历
            if ((opereventId != "")&&(opereventId != undefined)&&(gl.type!="Template"))
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
        var link = $('<li onmouseover="temp.show(this)" onmouseout="temp.hide(this)" style="background:url(../scripts/emr/image/record-card-png/png/5.png);background-size:100%"></li>');
        $(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].attributes.isLeadframe});
        $(link).attr({"chartItemType":data[i].attributes.chartItemType,"documentType":data[i].attributes.documentType});
        $(link).attr({"isMutex":data[i].attributes.isMutex,"categoryId":categoryId});
        $(link).attr({"templateId":data[i].attributes.templateId});
        
        var div = $('<div class="template" style="position:relative;padding:14px 3px 0px 3px"></div>');
        var hasTemplate = GetHasUserTemplate(data[i].id);
		var cardTitleText = "通用模板";
		var cardTitle = "使用通用模板创建病历";
		if(hasTemplate)
		{
			cardTitleText = "科室模板";
			cardTitle = "选择模板创建";	
		}
        
        if (data[i].attributes.quotation == "1")
        {
 			$(div).append('<div class="cardImage" style="width:128;height:146px;background:url(../scripts/emr/image/record-card-png/png/10.png) no-repeat"><div class="new" ><div class="title">' +data[i].attributes.DocIDText+ '<div class="creatediv" style="margin-top:10px"><a href="#" onClick="SelectTemplateClick(this)" title=' +emrTrans(cardTitle) +'>'+emrTrans(cardTitleText) +'</a></div><a href="#" onClick="createDocument(this)" title=' +emrTrans("使用通用模板创建病历") +'><div class="addimage" style="width:16px;height:18px;right:18px; bottom:23px; position: absolute;background:url(../scripts/emr/image/record-card-png/png/add.png) no-repeat;"></div></a></div></div></div>');
			$(div).append('<a href="#" title=' +emrTrans("引用") +'><div class="quote" style="margin:-23px 0px 0px 8px;background:url(../scripts/emr/image/record-card-png/png/12.png) no-repeat;"></div></a>');       
        }
        else
        {
        	$(div).append('<div class="cardImage" style="width:128;height:146px;background:url(../scripts/emr/image/record-card-png/png/10.png) no-repeat"><div class="title">' +data[i].attributes.DocIDText+ '<div class="creatediv" style="margin-top:10px"><a href="#" onClick="SelectTemplateClick(this)" title=' +emrTrans(cardTitle) +'>'+emrTrans(cardTitleText) +'</a></div><a href="#" onClick="createDocument(this)" title=' +emrTrans("使用通用模板创建病历") +'><div class="addimage" style="width:16px;height:16px;right:18px; bottom:23px; position: absolute;background:url(../scripts/emr/image/record-card-png/png/add.png) no-repeat;"></div></a></div></div>');
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
	if((index == "")||(opereventId == "")||(categoryId == "")) return;
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
                if (operViewType == "List")
                {}
                else{
                    setRecord(index,eval("["+d+"]"),categoryId);
                }
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
        //var link = $('<li onClick="openDocument(this)"></li>');
        var link = $('<li onClick="openDocument(this)" onmouseover="record.show(this)" onmouseout="record.hide(this)" style="background:url(../scripts/emr/image/record-card-png/png/34.png);background-size:100%"></li>');
        $(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].isLeadframe});
        $(link).attr({"chartItemType":data[i].chartItemType,"documentType":data[i].documentType});		
        $(link).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":categoryId});
        $(link).attr({"templateId":data[i].templateId,"characteristic":data[i].characteristic});
        
		var div = $('<div class="instance" style="padding:14px 3px 0px 3.5px"></div>');
		var contentclass = "class = 'content'";
		var imagecontentclass = "class='recordimage' style='width:128px;height:146px;background:url(../scripts/emr/image/record-card-png/png/10.png) no-repeat'"
		if ((data[i].doctorwait != "")&&(data[i].patientwait != ""))
		{
			var ret = getContentClass(data[i].doctorwait,data[i].doctorIsSignCA,data[i].patSignStatus);
			contentclass = ret.contentclass;
			if ((ret.doctorStyle!="")&&(ret.patStyle!=""))
			{
				$(div).append('<div '+ imagecontentclass +'><a href="#"><div ' +contentclass+ '><div ' +ret.patStyle+ '></div><div ' +ret.doctorStyle+ '></div><div class="memoConcent">' +data[i].summary+ '</div></div></a></div>');
			}
			else if((ret.doctorStyle!="")&&(ret.patStyle==""))
			{
				$(div).append('<div '+ imagecontentclass +'><a href="#"><div ' +contentclass+ '><div ' +ret.doctorStyle+ '></div><div class="memoConcent">' +data[i].summary+ '</div></div></a></div>');
			}
			else if((ret.doctorStyle=="")&&(ret.patStyle!=""))
			{
				$(div).append('<div '+ imagecontentclass +'><a href="#"><div ' +contentclass+ '><div ' +ret.patStyle+ '></div><div class="memoConcent">' +data[i].summary+ '</div></div></a></div>');
			}
			else if((ret.doctorStyle=="")&&(ret.patStyle==""))
			{
				$(div).append('<div '+ imagecontentclass +'><a href="#"><div ' +contentclass+ '><div class="memoConcent">' +data[i].summary+ '</div></div></a></div>');
			}
		}
		else
		{
			$(div).append('<div class="recordimage" style="width:128px;height:146px;background:url(../scripts/emr/image/record-card-png/png/10.png) no-repeat"><a href="#"><div ' +contentclass+ '>' +data[i].summary+ '</div></a></div>');
		}
        
        //$(div).append('<a href="#"><div ' +contentclass+ '>' +data[i].summary+ '</div></a>');
        
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

//无关联模板、病历实例
function loadNoLink()
{
    var panels = $("#operations").accordion("panels");
    if ((panels.length !== 0)&&($("#operations").accordion('getSelected') !== null)) $("#operations").accordion('getSelected').panel('collapse');
    var noLinkTemplateData = getNoLinkTemplate(gl.categoryId);
    var noLinkDocumentData = "";
    if (gl.type!="Template"){
        noLinkDocumentData = getNoLinkDocument(gl.categoryId);
    }
    if ((noLinkTemplateData != "")||(noLinkDocumentData != ""))
    {
        var title = "无关联手术相关记录";
        var i = panels.length;
        var content = $('<div id="display'+i+'" style="fit:true;overflow-y:hidden"></div>');
        var templateRecord = $('<ul class="display" id=""></ul>');
        if (operViewType !== "List")
        {
            if (noLinkTemplateData != "") {
                setTemplate(i,noLinkTemplateData,gl.categoryId,templateRecord);
            }
            if (noLinkDocumentData != "") {
                setRecord(i,noLinkDocumentData,gl.categoryId,templateRecord);
            }
            $(content).append(templateRecord);
            addAccordion(title,content,false,"noLinkTemplateDocument");
        }else{
            $(content).append(templateRecord);
            addAccordion(title,content,true,"noLinkTemplateDocument"); 
        }
        setTimeout(function(){
            if (($("#operations").accordion("panels").length !== 0)&&($("#operations").accordion('getSelected') !== null)) $("#operations").accordion('getSelected').panel('collapse');
            $('#operations').accordion('select',0);
        },500);
    }
}

//获取无关联病历实例
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
            "Method":"GetTempCateJsonByCategoryIDNew",
            "p1":categoryId,
            "p2":gl.episodeId,
            "p3":gl.userId,
            "p4":operViewType,
            "p5":"Operation",
            "p6":"",
            "p7":gl.userLocId,
            "p8":"",
            "p9":gl.userLocId
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

//加载无关联模板、病历实例
function loadNoLinkTemplateDocument(index,categoryId)
{
    $('#display'+index+' .display').empty();
    var noLinkTemplateData = "";
    if ($("#personalTemp").is(':checked'))
    {
	   noLinkTemplateData = loadPersonTemplate(''); 
	}
	else
	{
		noLinkTemplateData = getNoLinkTemplate(categoryId);
	}
    if (noLinkTemplateData != "")
    {
        if (operViewType == "List")
        {
            $('#display'+index+' .display').append('<table id=grid'+index+'></table>');
            gridList(index);
            $('#grid'+index).treegrid('loadData',noLinkTemplateData);
        }else{
            setTemplate(index,noLinkTemplateData,categoryId);
        }
    }
    var noLinkDocumentData = "";
    if (gl.type!="Template"){
        noLinkDocumentData = getNoLinkDocument(categoryId);
    }
    if (noLinkDocumentData != "")
    {
        if (operViewType == "List")
        {}
        else{
            setRecord(index,noLinkDocumentData,categoryId);
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
    if (operViewType !== "List")
    {
        var eventId = $('#operations').accordion('getSelected')[0].id;
        if (eventId == "noLinkTemplateDocument") eventId = "";
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
    }else{
        if (typeof(obj) == "string") {
            obj = eval('(' + obj + ')');
        }
        var eventId = $('#operations').accordion('getSelected')[0].id;
        if (eventId == "noLinkTemplateDocument") eventId = "";
        var tabParam ={
            "id":"",
            "text":obj.text,
            "pluginType":obj.documentType,
            "chartItemType":obj.chartItemType,
            "emrDocId":obj.emrDocId,
            "templateId":obj.templateId,
            "isLeadframe":obj.isLeadframe,
            "isMutex":obj.isMutex,
            "categoryId":obj.categoryId,
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
        if ($("#personalTemp").is(':checked'))
        {
    	    tabParam.actionType = "CREATEBYPERSONAL";
			tabParam.exampleId = obj.id;
			tabParam.categoryId = gl.categoryId;
			tabParam.chartItemType = obj.attributes.chartItemType;
			tabParam.emrDocId = obj.attributes.emrdocId;
			tabParam.pluginType = obj.attributes.documentType;
			tabParam.templateId = obj.attributes.templateId;
			tabParam.titleCode = obj.attributes.titleCode;
			tabParam.isLeadframe = obj.attributes.isLeadframe;
			tabParam.isMutex = obj.attributes.isMutex;
	    }        
        if (obj.attributes){
            if (((obj.attributes.nodetype != "leaf")&& (obj.attributes.nodetype != undefined))&&(obj.attributes.nodeType != "personal"))
            {
                return;
            }
            tabParam.userTemplateCode = obj.attributes.Code;
            tabParam.titleCode = obj.attributes.TitleCode;
            if (obj.attributes.nodeType =="personal") tabParam.titleCode = obj.attributes.titleCode;
            tabParam.titleName = obj.text;
            if ((tabParam.TitleCode != undefined)&&(tabParam.TitleCode != "")){
                var content = "<iframe id='iframeModifyTitle' scrolling='auto' frameborder='0' src='emr.ip.navigation.template.csp?DocID="+tabParam.emrDocId+"&LocID="+gl.userLocId+"&EpisodeID="+gl.episodeId+"&Action=modifyTitle"+"&TitleCode="+tabParam.TitleCode+"' style='width:100%;height:100%; display:block;'></iframe>";
                parent.createModalDialog("temptitleDialog","修改标题","525","490","iframeModifyTitle",content,SelectTempTitle,tabParam);
                return;
            }else{
                operateRecord(tabParam);
                //自动记录病例操作日志
                CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");
                return;
            }
        }
    }
    operateRecord(tabParam);	

    //自动记录病例操作日志
    CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");
}
//从模板新建
function SelectTemplateClick(obj){
    
    if (operViewType !== "List")
    {
        
        var eventId = $('#operations').accordion('getSelected')[0].id;
        if (eventId == "noLinkTemplateDocument") eventId = "";
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
    }else{
        if (typeof(obj) == "string") {
            obj = eval('(' + obj + ')');
        }
        var eventId = $('#operations').accordion('getSelected')[0].id;
        if (eventId == "noLinkTemplateDocument") eventId = "";
        var tabParam ={
            "id":"",
            "text":obj.text,
            "pluginType":obj.documentType,
            "chartItemType":obj.chartItemType,
            "emrDocId":obj.id,
            "templateId":obj.templateId,
            "isLeadframe":obj.isLeadframe,
            "isMutex":obj.isMutex,
            "categoryId":obj.categoryId,
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
    }
    getParamByUserTemplate(tabParam);
}

//打开文档
function openDocument(obj)
{
    if (operViewType !== "List")
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
    }
    else
    {
        var id = obj.id.replace("A","||");
        var tabParam ={
            "id":id,
            "text":obj.text,
            "pluginType":obj.documentType,
            "chartItemType":obj.chartItemType,
            "emrDocId":obj.emrDocId,
            "templateId":obj.templateId,
            "isLeadframe":obj.isLeadframe,
            "isMutex":obj.isMutex,
            "categoryId":obj.categoryId,
            "characteristic":obj.characteristic,
            "actionType":"LOAD",
            "status":"NORMAL",
            "closable":true
        }; 
    }
    operateRecord(tabParam);
    
    //自动记录病例操作日志
    openDocumentLog(tabParam,"EMR.Nav.RecordNav.Open");
}

///过滤
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

function getContentClass(doctorwait,doctorIsSignCA,patSignStatus)
{
	var ret = {};
	ret.contentclass = "class = 'content'";
	ret.doctorStyle = "";
	ret.patStyle = "";
	if (doctorwait == "1")
	{
		var tmpClass = "";
		var tmpTitle = "需要医生签名";
		ret.doctorStyle = "style='margin:8px 7px 0px 0px;float:right;width:16px;height:16px;background:url(../scripts/emr/image/record-card-png/png/30.png) no-repeat'";
		ret.patStyle = "";
		if ((patSignStatus.indexOf("待签") != -1)&&(isPatCAOn == "1"))
		{
			tmpClass = " patientwait";
			tmpTitle = "需要医生和患者签名";
			ret.doctorStyle = "style='margin:8px 7px 0px 0px;float:right;width:16px;height:16px;background:url(../scripts/emr/image/record-card-png/png/30.png) no-repeat'";
			ret.patStyle = "style='margin:8px 0px 0px 7px;float:left;width:16px;height:16px;background:url(../scripts/emr/image/record-card-png/png/33.png) no-repeat'"
		}
		else if((patSignStatus.indexOf("已签") != -1)&&(isPatCAOn == "1"))
		{
			tmpClass = " patCA";
			tmpTitle = "需要医生签名，患者已签名";
			ret.doctorStyle = "style='margin:8px 7px 0px 0px;float:right;width:16px;height:16px;background:url(../scripts/emr/image/record-card-png/png/38.png) no-repeat'";
		}
		ret.contentclass = "class = 'content doctorwait"+ tmpClass +"' title="+emrTrans(tmpTitle);
	}
	else if(doctorIsSignCA == "1")
	{
		var tmpClass = "";
		var tmpTitle = "医生已CA签名";
		if ((patSignStatus.indexOf("待签") != -1)&&(isPatCAOn == "1"))
		{
			tmpClass = " patientwait";
			tmpTitle = "需要患者签名，医生已CA签名";
			ret.patStyle = "style='margin:8px 0px 0px 7px;float:left;width:16px;height:16px;background:url(../scripts/emr/image/record-card-png/png/33.png) no-repeat'"			
		}
		else if((patSignStatus.indexOf("已签") != -1)&&(isPatCAOn == "1"))
		{
			tmpClass = " patCA";
			tmpTitle = "医生和患者均已CA签名";
		}
		ret.contentclass = "class = 'content docCA"+ tmpClass +"' title="+emrTrans(tmpTitle);
	}
	else if((patSignStatus.indexOf("待签") != -1)&&(isPatCAOn == "1"))
	{
		ret.contentclass = "class = 'content patientwait' title="+emrTrans("需要患者签名");
		ret.patStyle = "style='margin:8px 0px 0px 7px;float:left;width:16px;height:16px;background:url(../scripts/emr/image/record-card-png/png/33.png) no-repeat'";
	}
	else if((patSignStatus.indexOf("已签") != -1)&&(isPatCAOn == "1"))
	{
		ret.contentclass = "class = 'content patCA' title="+emrTrans("患者已CA签名");
	}
	
	return ret;
}

///增加手术索引
function appendOperations()
{
    var iframeContent = "<iframe id='iframeAddoperation' scrolling='auto' frameborder='0' src='emr.record.library.navoperation.addoperation.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&openWay=editor' style='width:100%; height:100%; display:block;overflow:hidden'></iframe>"
    parent.createModalDialog("addoperationDialog","手术索引",window.screen.width-300,window.screen.height-300,"iframeAddoperation",iframeContent,addoperationDialogCallBack,'');
}

function addoperationDialogCallBack(returnValue,arr)
{
    if ((!returnValue)||(returnValue == "")) return;
    if (Values != "")
    {
        var returnValues = eval("("+Values+")");
        if ((returnValues == "")||(returnValues == undefined)) return;
        var panels =  $("#operations").accordion("panels");
        var i = panels.length;
        var title = returnValues.OperDateTime+" | "+returnValues.OperDesc+" | "+returnValues.OperDoc+" | "+returnValues.OperAssistFirst+" | "+returnValues.OperAssistSecond;
        var content = '<div id="display'+i+'" style="fit:true;overflow-y:hidden"><ul class="display" id="'+returnValues.ID+'"></ul></div>';
    
        addAccordion(title,content,true,returnValues.ID);
        loadTemplate(i,returnValues.ID,categoryID);
    }
}

//加载模板表格视图列表
function gridList(index)
{
    $('#grid'+index).treegrid({
        iconCls:'icon-paper',
        fitColumns:true, 
        headerCls:'panel-header-gray',
        loadMsg:'数据装载中......',
        autoRowHeight:true,
        nowrap:true,
        url:"../EMRservice.Ajax.common.cls",
        singleSelect:true,
        height:280,
        idField:'id',
        treeField:'text',
        border:false,
        columns:[[
            {field:'id',title:'emrDocId',hidden:true},
            {field:'operate',title:'操作',width:95,formatter:operateContent},
            {field:'text',title:'名称',width:250,sortable:true,formatter:show}
        ]],
        onDblClickRow:function(rowIndex, rowData){
			var condition = rowData.attributes 
				? (rowData.type == "flod")&&(rowData.attributes.nodetype != undefined)
				: rowData.type == "flod";
				            
            if (condition||(rowData.children ? true : false))
            {
                if (rowData.state == "closed")
                {
                    $('#grid'+index).treegrid("expand", rowData.id);
                }
                else
                {
                    $('#grid'+index).treegrid("collapse", rowData.id);
                }
            }
            else
            {
                if ((rowData.type == "TempCate")||(rowData.type == "UserTem")||(rowData.attributes.nodeType == "personal"))
                {
                    createDocument(rowData);
                }
                else 
                {
                    openDocument(rowData);
                }
            }
        },
        onLoadSuccess:function(){
            
        }
    });
}

function operateContent(val,row,index)
{
    var span = '';
    if (row.type == "flod") return;
    var showbtnname = "新建通用模板";
    if (row.type == "UserTem"){
        showbtnname = "新建科室模板";
    }
    span = '<span class="listOperate" onclick="createDocument('+"'"+ JSON.stringify(row).replace(/"/g, '&quot;')+"'"+')"><img title="'+showbtnname+'" align="center" src="../scripts/emr/image/icon/add.png" style="margin-left:5px;"/></span>';
    //因列表模式下直接展示，不需要提供展开科室模板的流程
    //span += '<span class="listOperate" onclick="SelectTemplateClick('+"'"+ JSON.stringify(row).replace(/"/g, '&quot;')+"'"+')"><img title="选择模板新建" align="center" src="../scripts/emr/image/icon/listmore.png" style="margin-left:10px;" /></span>'; 
    return span;	
}

//鼠标放在上面显示全名
function show(val,row)
{
    if (val)
    {        
        return '<span title="' + val + '">' + val + '</span>';    
    } else {        
        return val;    
    }
}

//签名状态设置
function StatusOperate(val,row,index)
{
    if(row.id == "TXT")
    {
        return row.status;
    }
    if(row.doctorwait == undefined) return;
    if(row.doctorwait == "1")
    {
        var span = '<a style="color:#FB9A42;">'+emrTrans("待签")+'</a>';  
        return span;
    }else{
        var span = '<a>'+row.status+'</a>';  
        return span;
    }
}

//获取本次就诊所有实例
function getAllRecord()
{
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.Event.BLOperation",
            "Method":"GetOperationRecord",
            "p1":gl.categoryId,
            "p2":gl.episodeId,
            "p3":"Operation",
            "p4":gl.sequence
        },
        success: function(d) {
            if (d == "") return;
            var data = eval("("+d+")");
            $('#gridshow').datagrid('loadData',data);
        },
        error : function(d) { alert("getAllRecord error");}
    });	
}

//所有实例表格
function initAllRecordGrid()
{
    $('#gridshow').datagrid({
        iconCls:'icon-paper',
        fitColumns:true,
        headerCls:'panel-header-gray',
        loadMsg:'数据装载中......',
        autoRowHeight:true,
        singleSelect:true,
        idField:'id',
        sortOrder:'desc',
        remoteSort:false,
        nowrap:true,
        fit:true,
        toolbar:[],
        columns:[[
            {field:'id',title:'id',hidden:true},
            {field:'status',title:'医生签名状态',width:140,formatter:StatusOperate},
            {field:'text',title:'名称',width:170},
            {field:'createdate',title:'创建日期',width:100},
            {field:'createtime',title:'创建时间',width:90},
            {field:'creator',title:'创建人',width:100},
            {field:'operator',title:'最后修改人',width:100}
        ]],
        view : groupview,
        groupField : 'OperInfo',
        groupFormatter : function (value, rows) {
            var groupText = value;
            return groupText;
        },
        //点击表格病历打开
        onDblClickRow:function(index,row)
        {
            if (row.id == "TXT") return;
            openDocument(row);
        }
    });
}

//手术与病历批量关联
function setContact()
{
    var iframeContent = "<iframe id='iframeBatchContact' scrolling='auto' frameborder='0' src='emr.ip.navigation.operation.batchcontact.csp?EpisodeID="+gl.episodeId+"&CategoryID="+gl.categoryId+"&Sequence="+gl.sequence + "' style='width:100%; height:100%; display:block;'></iframe>";	
    parent.createModalDialog("batchContactDialog","病历关联手术","1100","500","iframeBatchContact",iframeContent,batchContactCallBack,"")
}

//关闭批量关联功能后回调
function batchContactCallBack(returnValue,arr)
{
    getAllRecord();
}

function getPersonTemplate()
{
	if (($("#operations").accordion("panels").length !== 0)&&($("#operations").accordion('getSelected') !== null)) $("#operations").accordion('getSelected').panel('collapse');
	$('#operations').accordion('select',0);
}

//获取个人模板
function loadPersonTemplate(searchText)
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.PersonalTemplate",
			"Method":"GetCategoryDataForList",
			"p1":gl.userId,
			"p2":gl.categoryId,
			"p3":gl.userLocId,
            "p4":gl.episodeId,
            "p5":searchText
		},
		success: function(d) {
			if (d == "") return;
			result = eval("["+d+"]")[0];
		},
		error : function(d) { 
			alert("getPersonalTreeData error");
		}
	});
	return result
}
