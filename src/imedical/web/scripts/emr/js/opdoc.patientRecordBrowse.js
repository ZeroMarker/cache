$(function(){
    getEpisodeInfo();
    initCategory();
    $(".categorytree input[type='checkbox']").attr('checked',true);
    $(".categorytree label").click(function(){
       //获取当前菜单旁边input的check状态
       var isChecked = $(this).next("input[type='checkbox']").is(':checked');
       //展开和收齐的不同状态下更换右侧小图标
       if(isChecked){
           $(this).css(
               "background-image","url(../scripts/emr/image/icon/down.png)"
           );
       }else{
           $(this).css(
               "background-image","url(../scripts/emr/image/icon/up.png)"
           );
       }
    });
    $('#browse').layout('panel','east').panel({
        onResize:function(width, height){
            if (searchBoxWidth != width)
            {
                searchBoxWidth = width;
                $('#selectCategory').searchbox('resize',searchBoxWidth- 12);
            }
        }
    });
});

//就诊信息
function getEpisodeInfo()
{
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.patientInfo.cls", 
        data: "action=GetEpisodeInfo"+ "&EpisodeIDs=" +episodeIDs, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) {
            if (data != "")
            {
                var episodeInfo = $.parseJSON(data);
                var htmlStr = episodeInfo[0].fistAdmDate+' 至 '+episodeInfo[0].lastAdmDate+'，'+episodeInfo[0].episodeNum+'次就诊';
                $("#episodeInfo").html(htmlStr);
            }
        }
    });
}

function initCategory()
{
    var data = {
        "OutputType":"Stream",
        "Class":"EMRservice.BL.BLClientCategory",
        "Method":"GetBrowseCategoryByEpisodeIDs",
        "p1":episodeIDs
    };
    jQuery.ajax({
        type: "POST",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: data,
        success: function(d) {
            if (d != "")
            {
                setCategory($.parseJSON("["+d+"]"));
            }
        },
        error : function(d) { alert("GetBrowseCategoryByEpisodeIDs error");}
    });
}

function setCategory(data)
{
    var firstId = "";
    for (var i=0;i<data.length;i++)
    {
        if (data[i].children && data[i].children.length>0)
        {
            var li = $('<li></li>');
            var category = '<label for="folder'+data[i].id+'" class="folderOne">'+data[i].text+'</label><input type="checkbox" id="folder'+data[i].id+'"/>';
            $(li).append(category);
            var childul = $('<ol></ol>');
            for (var j=0;j<data[i].children.length;j++)
            {
                var tmpli = setContent(data[i].children[j]);
                $(childul).append(tmpli);
            }
            $(li).append(childul);
            $('#ulcategory').append(li);
        }
        else
        {
            var li = setContent(data[i]);
            $('#ulcategory').append(li);
        }

        if (i == 0)
        {
            if (data[i].children == undefined)
            {
                firstId = data[0].id;
            }
            else
            {
                firstId = data[0].children[0].id;
            }
        }
    }
    initDoc(firstId);
}

function setContent(data)
{
    var li = $('<li class="file folderTwo"></li>');
    $(li).attr("id",data.id);
    $(li).attr("chartItemType",data.chartItemType);
    $(li).attr("pluginType",data.documentType);
    $(li).attr("emrDocId",data.emrDocId);
    $(li).attr("type",data.type);
    $(li).attr("characteristic",data.characteristic);
    $(li).attr("epsiodeId",data.epsiodeId);
    $(li).attr({"isLeadframe":data.isLeadframe});
    $(li).attr({"isMutex":data.isMutex,"categoryId":data.categoryId});
    $(li).attr({"templateId":data.templateId});
    
    var link = $('<a href="#"></a>');
    $(link).append($('<div></div>').append('<div class="title">'+$.trim(data.text)+'</div><div class="log"></div>'));
    var print = "";
    if (data.printstatus != "") print = "已打印";
    $(link).append($('<div></div>').append('<div class="date">'+data.happendate+' '+ data.happentime+'</div><div class="print">'+print+'</div>'));
    $(li).append(link);
    return li;
}

function initDoc(initId)
{
    selectListRecord(initId);
    var obj = $('.categorytree').find('li').filter('[id="'+initId+'"]');
    loadRecord(obj);
}

//选中文档目录
function selectListRecord(id)
{
    $(".categorytree .folderTwo").each(function()
    {
        if ($(this).attr('id') == undefined) return;
        if($(this).attr('id')==id)
        {
            $(this).addClass("select");
            $(this).find(".title,.date,.print").addClass("whitefont");
            episodeID = $(this).attr("epsiodeId");
            setTempParam(this);
        }
        else
        {
            $(this).removeClass("select");
            $(this).find(".title,.date,.print").removeClass("whitefont");
        }
     });
}

//显示病历操作记录明细
$(document).on("click",".categorytree li .log",function()
{
    var obj = $(this).closest("li");
    var instanceId = obj.attr("id");
    var docId = obj.attr("emrDocId");
    var Num = instanceId.split("||")[1];
    var episodeID = obj.attr("epsiodeId");
    
    var content = '<iframe id="logdetailWinFrame" scrolling="auto" frameborder="0" src="emr.opdoc.logdetailrecord.csp?EpisodeID=' + episodeID + '&EMRDocId=' + docId + '&EMRNum=' + Num + '&MWToken=' + getMWToken() + '" style="width:100%;height:100%;display:block;"></iframe>';
    createModalDialog('LogdetailWin','结核病历的操作日志',900,450,"logdetailWinFrame",content,"","");
});

//目录点击事件
$(document).on("click",".categorytree .folderTwo",function()
{
    //选中文档目录
    selectListRecord($(this).attr("id"));
    loadRecord(this);
});


//取调用数据
function setTempParam(obj)
{
    if ($(obj).attr("id") == undefined) return "";
    var id = $(obj).attr("id");
    var text = $(obj).text();
    var chartItemType = $(obj).attr("chartItemType");
    var pluginType = $(obj).attr("pluginType");
    var emrDocId = $(obj).attr("emrDocId");
    var characteristic = $(obj).attr("characteristic");
    var templateId = $(obj).attr("templateId");
    var categoryId = $(obj).attr("categoryId");
    var isLeadframe = $(obj).attr("isLeadframe");
    var isMutex = $(obj).attr("isMutex");
    
    var tempParam = {
        "id":id,
        "text":text,
        "chartItemType":chartItemType,
        "pluginType":pluginType,
        "emrDocId":emrDocId,
        "characteristic":characteristic,
        "templateId":templateId,
        "categoryId":categoryId,
        "isLeadframe":isLeadframe,
        "isMutex":isMutex,
        "actionType":"LOAD",
        "status":"BROWSE"
    };
    return tempParam;
}

//加载病历
function loadRecord(obj)
{
    var tempParam = setTempParam(obj);
    if (tempParam == "") return;
    loadDocument(tempParam);
}

//查询
$('#selectCategory').searchbox({
    width:searchBoxWidth,
    height:27,
    searcher:function(value,name){
        selectRecord($.trim(value));
    }
});

//检索当前病历
function selectRecord(value)
{
    if (value != "" && value != "请输入病历名称搜索")
    {
        $("#ulcategory li").hide();
        var $Category = $("#ulcategory>li>a>div>.title").filter(":contains('"+value+"')");
        $Category.parent().parent().parent().show();
        var $child = $("#ulcategory>li>ol>li>a>div>.title").filter(":contains('"+value+"')");
        $child.parent().parent().parent().parent().parent().show();
        $child.parent().parent().parent().show();
    }
    else
    {
        $("#ulcategory li").show();
    }
}

//修改病历操作记录明细的显示颜色
function setListPrinted(ids)
{
    var printArray = ids.split(",");
    $.each(printArray,function(idx, id){
        var li = $("#ulcategory li[id='"+id+"']");
        $(li).find(".print").html("已打印");
    });
}
