
$(function(){
    initCategory("");
    
    $('#InstanceTree').on('mouseenter', 'li', function() {
        $(this).find('#dot').addClass("hoverdot");
    });
    $('#InstanceTree').on('mouseleave', 'li', function() {
       $(this).find('#dot').removeClass("hoverdot");
    });
},0);

//按列表加载取数据
function initCategory(instanceId)
{
    var data = { 
        "OutputType":"Stream",
        "Class":"EMRservice.BL.opInterface",
        "Method":"GetPhthsisRecordCatalogByHappenDate",
        "p1":episodeID
    };
    $.ajax({
        type: "post",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: data,
        success: function(d) {
            if (d != "")
            {
                setRecordList($.parseJSON("["+d+"]"),instanceId);
            }
        },
        error : function(d) {
            alert("GetPhthsisRecordCatalogByHappenDate error");
        }
    });
}

//加载目录
function setRecordList(data,instanceId)
{
    $('#InstanceTree').empty();
    $('#InstanceTree').addClass('instance-item');
    $('#InstanceTree').append('<div class="head"></div>');
    for (var i=0;i<data.length;i++)
    {
        $('#InstanceTree').append(setlistdata(data[i]));
    }
    $('#InstanceTree').append('<div class="foot"></div>');
    
    if (instanceId == "")
    {
        instanceId = parent.emrEditor.getInstanceID();
    }
    setSelectRecordColor(instanceId);
}

//加载列表样式
function setlistdata(data)
{
    var li = $('<li></li>');
    $(li).attr({"id":data.id,"text":data.text,"isLeadframe":data.isLeadframe});
    $(li).attr({"chartItemType":data.chartItemType,"documentType":data.documentType});
    $(li).attr({"emrDocId":data.emrDocId,"isMutex":data.isMutex,"categoryId":data.categoryId});
    $(li).attr({"templateId":data.templateId,"characteristic":data.characteristic,"emrNum":data.emrNum});
    $(li).attr({"itemTitle":data.itemTitle,"epsiodeId":data.epsiodeId,"categoryName":data.categoryName});
    $(li).append('<div id="dot" class="left"></div>')
    var right = $('<a href="#" class="right"></a>');
    var first = $('<div class="first"></div>');
    $(first).append('<div class="title">'+data.text+'</div>');
    var fleft = $('<div class="fleft"></div>');
    var print = "";
    if (data.printstatus != "")
    {
        print = data.printstatus;
    }
    else if (IsHasPrinted(data.id, data.epsiodeId) != "0")
    {
        print = "打印后修改";
        fleft = $('<div class="fleft" style="width:94px;"></div>');
    }
    $(fleft).append('<span class="printed">'+print+'</span>');
    $(fleft).append('<span type="image" class="log" onclick="showListLog(this)"></div>');
    $(first).append(fleft);
    $(right).append(first);
    var second = '<div class="second"><span class="data">'+data.happendate+'</span><span>'+data.happentime+'</span><span>'+data.creator+'</span></div>';
    $(right).append(second);
    var statusClass = "status green";
    if (data.statusCode != "finished") statusClass = "status blue";
    var third = '<div class="third"><span id="operator" class="operator">'+data.operator+'</span><span id="status" class="'+statusClass+'">'+data.status+'</span></div>';
    $(right).append(third);
    $(li).append(right);
    return li;
}

//判断病历是否被打印过
function IsHasPrinted(instanceId, epsiodeId)
{
    var retvalue = "0";
    $.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLEMRLogs",
            "Method":"RecHasAction",
            "p1":epsiodeId,
            "p2":instanceId,
            "p3":"print"
        },
        success: function(d) {
            if (d != "0") 
            {
                retvalue = d;
            }
        },
        error : function(d) {
            alert("IsHasPrinted error");
        }
    });
    return retvalue;
}

//显示病历操作记录明细
function showListLog(obj)
{
    event.stopPropagation();
    var obj = $(obj).closest("li");
    var instanceId = obj.attr("id");
    var docId = obj.attr("emrDocId");
    var num = instanceId.split("||")[1];
    var epsiodeId = obj.attr("epsiodeId");
    var content = '<iframe id="logdetailWinFrame" scrolling="auto" frameborder="0" src="emr.opdoc.logdetailrecord.csp?EpisodeID=' + epsiodeId + '&EMRDocId=' + docId + '&EMRNum=' + num + '&MWToken=' + getMWToken() + '" style="width:100%;height:100%;display:block;"></iframe>';
    parent.createModalDialog('LogdetailWin','结核病历的操作日志',900,450,"logdetailWinFrame",content,"","");
}

//打开病历
$(document).on('click',"#InstanceTree.instance-item li",function(){
    opendDocument($(this));
});

///打开病历
function opendDocument(obj)
{
    currentEpisodeID = obj.attr("epsiodeId");
    
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
        "categoryName":obj.attr("categoryName"),
        "epsiodeId":obj.attr("epsiodeId"),
        "closable":true,
        "actionType":"LOAD",
        "status":"NORMAL"
    };
    parent.LoadPhthsisRecords(tempParam);
}

//设置选中文档目录颜色
function setSelectRecordColor(instanceId)
{
    $('#InstanceTree.instance-item li').each(function()
    {
        if($(this).attr('id')==instanceId)
        {
            $(this).addClass("selectli");
            $(this).find('#dot').addClass("selectdot");
            $("#InstanceTree .instance-item").animate({scrollTop: $(this).position().top}, 1000); 
        }
        else
        {
            $(this).removeClass("selectli");
            $(this).find('#dot').removeClass("selectdot");
        }
     });
}

//删除列表病历
function deleteListRecord(instanceId)
{
    $('#InstanceTree li').each(function(){
        if ($(this).attr('id')==instanceId)
        {
            $(this).remove();
            return false;
        }
     });
}

//增加或修改病历列表导航条数据
function modifyListRecord(commandJson)
{
    var instanceId = commandJson.InstanceID;
    if (instanceId == "GuideDocument") return;
    if ((commandJson.status.createDateCache != commandJson.status.happenDateCache)||(Math.abs(commandJson.status.createTimeCache - commandJson.status.happenTimeCache) > 120))
    {
        initCategory(instanceId);
        return;
    }
    var creator = commandJson.status.Creator;
    var operator = commandJson.status.Operator;
    var happendate = commandJson.status.HappenDate;
    var happentime = commandJson.status.HappenTime; 
    var statusCode = commandJson.status.curStatus;
    var status = commandJson.status.curStatusDesc;
    var text = commandJson["Title"]["NewDisplayName"];
    var formatHappenDate=getHISDateTimeFormate("Date",happendate)
    var formatHappenTime=getHISDateTimeFormate("Time",happentime)

    var data ={
        "id":instanceId,
        "text":text,
        "isLeadframe":commandJson.insData.isLeadframe,
        "chartItemType":commandJson.insData.chartItemType,
        "documentType":commandJson.insData.pluginType,
        "emrDocId":commandJson.insData.emrDocId,
        "isMutex":commandJson.insData.isMutex,
        "categoryId":commandJson.insData.categoryId,
        "templateId":commandJson.insData.templateId,
        "characteristic":commandJson.insData.characteristic,
        "itemTitle":commandJson.insData.itemTitle,
        "epsiodeId":commandJson.insData.epsiodeId,
        "categoryName":commandJson.insData.text,
        "happendate":formatHappenDate,
        "happentime":formatHappenTime,
        "creator":creator,
        "operator":operator,
        "statusCode":statusCode,
        "status":status,
        "printstatus":""
    }
    var li = setlistdata(data);
    var data = document.getElementById(instanceId);
    if (data)
    {
        data.innerHTML = li[0].innerHTML;
    }
    else
    {
        $("#InstanceTree .foot").before(li);
    }
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
function setListPrinted(ids)
{
    var printArray = ids.split(",");
    $.each(printArray,function(idx, id){
        var li = $("#InstanceTree li[id='"+id+"']");
        $(li).find(".fleft").css({width:67});
        $(li).find(".fleft .printed").html("已打印");
    });
}

