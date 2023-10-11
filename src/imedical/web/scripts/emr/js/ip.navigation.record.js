///////////////////////////////病历目录导航操作///////////////////////////////
$(function(){
    $('#quicknav').keywords({
        singleSelect:true,
        labelCls:'red',
        items:[
            {text:emrTrans('病历目录'),id:'navList'},
            {text:emrTrans('已删病历'),id:'navDelete'}
        ],
        onClick:function(v){
            toggleNav(v.id,"");
        }
    }); 
    
    $HUI.radio("[name='NavType']",{
        onChecked:function(e,value){
            var type = $(e.target).attr("value");
            var recordtype = $("#quicknav").keywords("getSelected");
            if (recordtype[0].id == "navList")
            {
                if (type == "Tree")
                {
                    getTreeRecord("");
                }
                else
                {
                    getListRecord("");
                }
            }
            else
            {
                if (type == "Tree")
                {
                    getDeleteTree();
                }
                else
                {
                    getDeleteList();
                }
            }
        }
    });
    $("#quicknav").keywords("select","navList");
    
    $('#InstanceTree,#deleteTree').on('mouseenter', 'li', function() {
        $(this).find('#dot').addClass("hoverdot");
    });
    $('#InstanceTree,#deleteTree').on('mouseleave', 'li', function() {
       $(this).find('#dot').removeClass("hoverdot");
    });
},0);

///切换页签
function toggleNav(tabId,instanceId)
{
    if (tabId == "navList")
    {
        $("#recordlist").css("display","block");
        $("#deletelist").css("display","none");
        $('#deleteTree').empty();
        initListRecord(instanceId);
    }
    else
    {
        $("#recordlist").css("display","none");
        $('#InstanceTree').empty();
        $("#deletelist").css("display","block");
        initDeleteRecord(instanceId);
    }
}
///////////////////////////////加载病历目录///////////////////////////////
function initListRecord(instanceId)
{
    var checked = $("input[name='NavType']:checked");
    var type = checked.val() || "";
    if (type == "") {
        type = getUserConfigData(userID,userLocID,"RecordType");
        type = type || EditRecordDisplayType;
        if (type.toUpperCase() == "TREE")
        {
            $HUI.radio("#Tree").setValue(true);
        }
        else
        {
            $HUI.radio("#List").setValue(true);
        }
    }else {
        if (type.toUpperCase() == "TREE")
        {
            getTreeRecord(instanceId);
        }
        else
        {
            getListRecord(instanceId);
        }
    }
}
///按List加载目录取数据
function getListRecord(instanceId)
{
    var data = { 
        "OutputType":"Stream",
        "Class":"EMRservice.BL.BLClientCategory",
        "Method":"GetRecordCatalogByHappenDate",
        "p1":episodeID,
        "p2":"save",
        "p3":"List",
        "p4":"",
        "p5":"",
        "p6":""
    };
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: data,
        success: function(d) {
            setRecordList(eval("["+d+"]"),instanceId);
        },
        error: function() {
            alert("getListRecord error");
        }
    });     
}
///加载List目录
function setRecordList(data,instanceId)
{
    $('#InstanceTree').empty();
    $('#InstanceTree').removeClass('categorytree');
    $('#InstanceTree').addClass('instance-item');
    
    for (var i=0;i<data.length;i++)
    {
        $('#InstanceTree').append(setlistdata(data[i]));
    }
    
    if (instanceId != "")
    {
        selectListRecord(instanceId);
    }
}
///加载List样式
function setlistdata(data)
{
    var li = $('<li></li>');
    $(li).attr({"id":data.id,"text":data.text,"isLeadframe":data.isLeadframe});
    $(li).attr({"chartItemType":data.chartItemType,"documentType":data.documentType});           
    $(li).attr({"emrDocId":data.emrDocId,"isMutex":data.isMutex,"categoryId":data.categoryId});                
    $(li).attr({"templateId":data.templateId,"characteristic":data.characteristic,"emrNum":data.emrNum});
    $(li).attr({"itemTitle":data.itemTitle,"pdfDocType":data.pdfDocType});
    $(li).append('<div id="dot" class="left"></div>');
    var right = $('<a href="#" class="right"></a>');
    $(right).append('<div class="title">'+data.text+'</div>');
    var first = $('<div class="first"></div>');
    $(first).append('<span type="image" class="log" onclick="showListLog(this)"></span>');
    var print = "";
    if (data.printstatus != "")
    {
        print = emrTrans(data.printstatus);
    }
    else if (data.printDesc != "")
    {
        print = emrTrans(data.printDesc);
    }
    $(first).append('<span>'+data.creator+'</span><span class="printed">'+print+'</span>');
    $(right).append(first);
    var second = '<div class="second"><span class="date">'+data.happendate+'</span><span>'+data.happentime+'</span></div>';
    $(right).append(second);
    var statusClass = "status green";
    if (data.statusCode != "finished") statusClass = "status blue";
    var third = '<div class="third"><span id="operator" class="operator">'+data.operator+'</span><span id="status" class="'+statusClass+'">'+emrTrans(data.status)+'</span>'
    if ((data.caSignID != "")&&(data.caSignID != undefined))
    third = third + '<span type="image" class="iscasign"></span>';
    third = third + '</div>';
    $(right).append(third);
    $(li).append(right);
    return li;
}
///按Tree加载目录取数据
function getTreeRecord(instanceId)
{
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLClientCategory",
            "Method":"GetInstanceByCategory",
            "p1":userLocID,
            "p2":ssgroupID,
            "p3":episodeID,
            "p4":"Tree",
            "p5":"",
            "p6":"Save",
            "p7":"",
            "p8":""
        },
        success: function(d) {
            setRecordTree(eval("["+d+"]"),instanceId);
        },
        error: function() {
            alert("getTreeRecord error");
        }
    }); 
    
}
///加载Tree目录
function setRecordTree(data,instanceId)
{
    $('#InstanceTree').empty();
    $('#InstanceTree').removeClass('instance-item');
    $('#InstanceTree').addClass('categorytree');
    for (var i=0;i<data.length;i++)
    {
        $('#InstanceTree').append(setTreeData(data[i]));
    }
    if (instanceId != "")
    {
        selectZtreeNode(instanceId);
    }
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
}
///加载Tree样式
function setTreeData(data)
{
    var li = $('<li></li>');
    var category = '<label for="folder'+data.id+'" class="folderOne">'+emrTrans(data.text)+'</label><input type="checkbox" id="folder'+data.id+'"/>';
    $(li).append(category);
    var childul = $('<ol></ol>');
    for (var j=0;j<data.children.length;j++)
    {
        var tmpli = setTreeContent(data.children[j]);
        $(childul).append(tmpli);
    }
    $(li).append(childul);
    $('#InstanceTree').append(li);
}
///加载Tree内容
function setTreeContent(data)
{
    var li = $('<li class="file folderTwo"></li>');
    $(li).attr("id",data.id);
    $(li).attr("text",data.attributes.text);
    $(li).attr("isLeadframe",data.attributes.isLeadframe);
    $(li).attr("chartItemType",data.attributes.chartItemType);
    $(li).attr("documentType",data.attributes.documentType);
    $(li).attr("emrDocId",data.attributes.emrDocId);
    $(li).attr("isMutex",data.attributes.isMutex);
    $(li).attr("categoryId",data.attributes.categoryId);
    $(li).attr("templateId",data.attributes.templateId);
    $(li).attr("characteristic",data.attributes.characteristic);
    $(li).attr("emrNum",data.attributes.emrNum);
    $(li).attr("itemTitle",data.attributes.itemTitle);
    $(li).attr("pdfDocType",data.attributes.pdfDocType);
    var right = $('<a href="#" class="right"></a>');
    $(right).append('<div class="title">'+data.attributes.text+'</div>');
    var first = $('<div class="first"></div>')
    $(first).append('<span type="image" class="log" onclick="showTreeLog(this)"></span>');
    var print = "";
    if (data.attributes.printstatus != "")
    {
        print = emrTrans(data.attributes.printstatus);
    }
    else if (data.attributes.printDesc != "")
    {
        print = emrTrans(data.attributes.printDesc);
    }
    $(first).append('<span>'+data.attributes.creator+'</span><span class="printed">'+print+'</span>');
    $(right).append(first);
    var second = '<div class="second"><span class="date">'+data.attributes.happendate+'</span><span>'+data.attributes.happentime+'</span></div>';
    $(right).append(second);
    var statusClass = "status green";
    if (data.attributes.statusCode != "finished") statusClass = "status blue";
    var third = '<div class="third"><span id="operator" class="operator">'+data.attributes.operator+'</span><span id="status" class="'+statusClass+'">'+emrTrans(data.attributes.status)+'</span>';
    if ((data.attributes.caSignID != "")&&(data.attributes.caSignID != undefined))
    third = third + '<span type="image" class="iscasign"></span>';
    third = third + '</div>';
    $(right).append(third);
    $(li).append(right);
    return li;
}

///////////////////////////////删除病历目录///////////////////////////////
function initDeleteRecord()
{
    var checked = $("input[name='NavType']:checked");
    if (checked.val() == "Tree")
    {
        getDeleteTree();
    }
    else
    {
        getDeleteList();
    }
}
///按Tree加载目录取数据
function getDeleteTree()
{
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLClientCategory",
            "Method":"GetInstanceByCategory",
            "p1":userLocID,
            "p2":ssgroupID,
            "p3":episodeID,
            "p4":"Tree",
            "p5":"",
            "p6":"Delete"               
        },
        success: function(d) {
            setDeleteTree(eval("["+d+"]"));
        },
        error: function() {
            alert("getDeleteTree error");
        }
    });     
}
///加载Tree目录
function setDeleteTree(data)
{
    $('#deleteTree').empty();
    $('#deleteTree').removeClass('instance-item');
    $('#deleteTree').addClass('categorytree');
    for (var i=0;i<data.length;i++)
    {
        $('#deleteTree').append(setDeleteTreeData(data[i]));
    }
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
}
///加载Tree样式
function setDeleteTreeData(data)
{
    var li = $('<li></li>');
    var category = '<label for="folder'+data.id+'" class="folderOne">'+data.text+'</label><input type="checkbox" id="folder'+data.id+'"/>';
    $(li).append(category);
    var childul = $('<ol></ol>');
    for (var j=0;j<data.children.length;j++)
    {
        var tmpli = setTreeContent(data.children[j]);
        $(childul).append(tmpli);
    }
    $(li).append(childul);
    $('#deleteTree').append(li);
}
///按List加载目录取数据
function getDeleteList()
{
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLClientCategory",
            "Method":"GetRecordCatalogByHappenDate",
            "p1":episodeID,
            "p2":"delete",
            "p3":"List"
        },
        success: function(d) 
        {
            if (d == "") return;
            setDeleteRecord(eval("["+d+"]"));
        },
        error: function() { 
            alert("getDeleteList error");
        }
    });     
}
///加载List目录
function setDeleteRecord(data)
{
    $('#deleteTree').empty();
    $('#deleteTree').removeClass('categorytree');
    $('#deleteTree').addClass('instance-item');
    
    for (var i=0;i<data.length;i++)
    {
        $('#deleteTree').append(setlistdata(data[i]));
    }
}

///////////////////////////////操作病历目录///////////////////////////////
///List类型打开病历
$(document).on('click',".instance-item li",function(){
    openDocument($(this));
});
///Tree类型打开病历
$(document).on('click',".categorytree ol li",function(){
    openDocument($(this));
});
///新增或修改病历目录列表
function modifyInstanceTree(commandJson)
{
    var recordtype = $("#quicknav").keywords("getSelected");
    toggleNav(recordtype[0].id,commandJson.InstanceID);  
}

///打印操作修改病历目录样式
function setPrinted(id)
{
    var checked = $("input[name='NavType']:checked");
    if (checked.val()== "Tree")
    {
        setTreePrinted(id);
    }
    else
    {
        setListPrinted(id);
    }   
}
///修改Tree类型显示样式
function setTreePrinted(ids)
{
    var printArray = ids.split(",");
    $.each(printArray,function(idx, id){
        var li = $("#InstanceTree ol li[id='"+id+"']");
        $(li).find(".right .printed").html(emrTrans("医生打印"));
    });
}
///修改List类型显示样式
function setListPrinted(ids)
{
    var printArray = ids.split(",");
    $.each(printArray,function(idx, id){
        var li = $("#InstanceTree li[id='"+id+"']");
        $(li).find(".right .printed").html(emrTrans("医生打印"));
    });
}
///打开病历目录病历
function openDocument(obj)
{
    var recordtype = $("#quicknav").keywords("getSelected");
    if (recordtype[0].id == "navList")
    {
        opendDocument(obj,"NORMAL");
    }else{
        opendDocument(obj,"DELETE");
    }
}
///加载病历
///平台提供方法调用打开病历页面并加载病历
function opendDocument(obj,status)
{
    currentInstanceID = obj.attr("id");
    setSelectRecordColor(currentInstanceID);
    var categoryId = obj.attr("categoryId");
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
        "pdfDocType":obj.attr("pdfDocType"),
        "status":status
    };
    //自动记录病例操作日志
    openDocumentLog(tempParam,"EMR.Record.RecordNav.RecordDirectory.Open");
    var tabParam = base64encode(utf16to8(escape(JSON.stringify(tempParam))));
    var tabName = "CategoryID="+categoryId;
    var tabOption = {
        ilink: "emr.ip.main.csp?TabParam="+tabParam,
        valueExp: "&"+tabName,
        content: '<iframe id="i"'+categoryId+' name="i"'+categoryId+' src="about:blank" width="100%" min-height="500px" height="100%" frameborder="0"></iframe>'
    };
    var cfg = {oneTimeValueExp:"TabParam="+tabParam};
    switchTabByEMRAndOpt(tabName,tabOption,cfg);
}
///List显示病历操作记录明细
function showListLog(obj)
{
    event.stopPropagation();
    var obj = $(obj).closest("li");
    var instanceId = obj.attr("id");
    var docId = obj.attr("emrDocId");   
    var num = instanceId.split("||")[1];
    showLog(docId,num);
}
///Tree显示病历操作记录明细
function showTreeLog(obj)
{
    event.stopPropagation();
    var obj = $(obj).closest("li");
    var instanceId = obj.attr("id");
    var docId = obj.attr("emrDocId");   
    var num = instanceId.split("||")[1];
    showLog(docId,num);
}
///显示病历操作记录明细
function showLog(docId,num)
{
    var xpwidth =980;
    var xpheight = 500;
    var tempFrame = "<iframe id='iframeInstanceLog' scrolling='auto' frameborder='0' src='emr.instancelog.csp?EpisodeID="+episodeID+"&EMRDocId="+docId+"&EMRNum="+num+"' style='width:100%; height:100%; display:block;'></iframe>";
    createModalDialog("dialogInstanceLog","操作日志",xpwidth+4,xpheight+40,"iframeInstanceLog",tempFrame,"","");
}
//选中文档目录
function setSelectRecordColor(instanceId)
{
    var checked = $("input[name='NavType']:checked");
    if (checked.val()== "Tree")
    {
        selectZtreeNode(instanceId);
    }
    else
    {
        selectListRecord(instanceId);
    }
}
///Tree选中病历节点
function selectZtreeNode(instanceId)
{
    $('.categorytree ol li').each(function()
    {
        if($(this).attr('id')==instanceId)
        {
            $(this).addClass("selectli");
        }
        else
        {
            $(this).removeClass("selectli");
        }
    });
}
///List选中病历节点
function selectListRecord(instanceId)
{
    $('.instance-item li').each(function()
    {
        if($(this).attr('id')==instanceId)
        {
            $(this).addClass("selectli");
            $(this).find('#dot').addClass("selectdot");
            $(".instance-item").animate({scrollTop: $(this).position().top}, 1000); 
        }
        else
        {
            $(this).removeClass("selectli");
            $(this).find('#dot').removeClass("selectdot");
        }
    }); 
}
///刷新病历目录--平台调用
function recordListRefresh(instanceId)
{
    if (instanceId == "GuideDocument"){
        return;
    }
    var recordtype = $("#quicknav").keywords("getSelected");
    toggleNav(recordtype[0].id,instanceId);
}
