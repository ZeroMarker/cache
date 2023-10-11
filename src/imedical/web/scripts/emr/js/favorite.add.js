﻿$(function(){
    if($.browser.version == '11.0')
    {
        document.documentElement.className ='ie11';
        $('#addcss').attr("href","../scripts/emr/lib/tool/taginput/jquery.tagsinput-IE11.css");
    }
    FavUserID = getFavUserID();
    ////初始化收藏名称
    var image = Gender=="女"?"../scripts/emr/image/icon/woman_big.png":"../scripts/emr/image/icon/man_big.png";
    var alt = Gender=="女"?"woman_big.png":"man_big.png";
    $("#photo").attr({"src":image, "alt":alt});
    var info = '<div class="contantdiv"><span>&emsp;'+emrTrans("病人ID")+'：</span><span id="PatientNo">'+PatientNo+'</span></div>';
    info = info + '<div class="contantdiv"><span>&emsp;&emsp;'+emrTrans("姓名")+'：</span><span id="Name">'+Name+'</span></div>';
    info = info + '<div class="contantdiv"><span>&emsp;&emsp;'+emrTrans("性别")+'：</span><span id="Gender">'+Gender+'</span></div>';
    info = info + '<div class="contantdiv"><span>'+emrTrans("出生日期")+'：</span><span id="BOD">'+BOD+'</span></div>';
    $("#content").append(info);
    //初始化收藏位置
    initCatalogTree("cbxLocation",true);
    
    //添加收藏
    $("#btnAdd").bind('click', function(){ 
        //当前患者是否已经被收藏
        var rtn = isFavoriteInfo();
        if (rtn === "0"){
            addFavorite();
        }else{
            var text='已经收藏在目录【' + rtn + '】下,是否确定重新收藏?';
            $.messager.defaults = { ok: "是", cancel: "否" };
            $.messager.confirm('添加收藏提示',text,function(data){
                if (data){
                    addFavorite();
                }
            });
        }
        returnValue = "FavoritesAdd.Commit";
    });
    
    //关闭窗口
    $("#btnCancel").bind('click', function(){
		returnValue = "FavoritesAdd.Cancel";
        closeWindow();
    });
    
    $('#tags').tagsInput({
        width:'300px',
        height:'73px',
        onAddTag:function(tag){
            var curlength = tag.length;
            if(curlength > 15)
            {
                $.messager.alert('提示信息','超出15字数限制，请重新输入！','info');
                $('#tags').removeTag(tag);
            }
        },
        defaultText:emrTrans("输入关键字(0-15字)，回车试试看")
    });
});

///获取收藏用户ID
function getFavUserID()
{
    var result = "";
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data:"Action=GetFavUserID&UserID=" + UserID,
        async: false, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
            result = data;
        } 
    });
    return result;		
}

//初始化页面收藏位置
function initCatalogTree(id,required)
{
    jQuery.ajax({
        type : "GET",
        dataType : "text",
        url : "../EMRservice.Ajax.favorites.cls",
        async : true,
        data : {"Action":"GetFavCatalog","FavUserID":FavUserID},
        success : function(d) {
        
            var data = eval(d);
            if (id == "cbxNewLocation")
            {
                data = [{id:0,text:emrTrans("收藏夹"),children:data}];
            }
            $('#'+id).combotree('loadData',data);
            var node = $('#'+id).combotree('tree').tree('getRoot');
            if (node)
            {
                $('#'+id).combotree('setValue',node.id);
            }
            
        },
        error : function(d) {
            $.messager.alert('提示信息','目录加载失败！','info');
        }
    }); 
}

//提示当前患者是否已经被收藏
function isFavoriteInfo()
{
    var result = "0";
    $.ajax({
        type: "GET",
        url: "../EMRservice.Ajax.common.cls", 
        async : false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLFavInformation",
            "Method":"SearchFavInfo",
            "p1":PatientNo,
            "p2":FavUserID,
            "p3":EpisodeID
        },
        success: function (data){
            if (data != "0")
            {
                result = data;
            }
         }
    });
    return result;
}

//添加收藏
function addFavorite()
{
    var tags = $("#tags").val();
    var catalogId = $('#cbxLocation').combotree('getValue');
    var memo = $("#txaMemo").val().replace(/\n|\r\n/g,"\\n");
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data:"Action=AddFavorite&PatientNo="+PatientNo+"&FavUserID="+FavUserID+"&Tags="+tags+"&CatalogID="+catalogId+"&Memo="+memo+"&EpisodeID="+EpisodeID+"&InstanceID="+InstanceID, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
            if (data == "1")
            {
                SetToLog(catalogId,tags);
                $.messager.alert('提示信息','添加成功','info');
                closeWindow();
            }
            else
            {
                $.messager.alert('提示信息','收藏失败','info');
            }
        } 
    });
}

//关闭窗口
function closeWindow()
{
	parent.closeDialog("dialogFavAdd");
}

$("#btnNew").bind('click', function(){
    
    //记录用户(收藏病历.新建目录)行为
    AddActionLog(UserID,UserLocID,"FavoritesAdd.NewDir","");
    newCatalog();	
});

//新建文件夹窗口
function newCatalog()
{
    $('#newCatalog').window({
        title: "创建文件夹",
        width: 312,  
        height: 197,  
        modal: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        iconCls: 'icon-w-card',
        closed: true,
        onOpen: function(){
            initCatalogTree("cbxNewLocation",false);
        },
        onClose: function(){
        }	 
    });
    $('#newCatalog').window('open');
    $('#newCatalog').css("display","block");
}

$("#btnClose").bind('click', function(){
    
    //记录用户(收藏病历.新建目录.关闭)行为
    AddActionLog(UserID,UserLocID,"FavoritesAdd.NewDir.Close","");

    $('#newCatalog').window('close');
});

$("#btnCreate").bind('click', function(){
    //记录用户(创建收藏目录)行为
    AddActionLog(UserID,UserLocID,"FavoritesAdd.NewDir.Create","");
    saveNewCatalogTree()
});

//新增目录
function saveNewCatalogTree()
{
    var value = $('#cbxNewLocation').combotree('getValue');
    var parentId = ((value == null)||(value == ""))?"0":value;
    var name = $('#txtName').val();
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=AddCatalog&FavUserID="+FavUserID+"&ParentID="+parentId+"&CatalogName="+name, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
            if (data != "0")
            {
                initCatalogTree("cbxLocation",true);
                $('#newCatalog').window('close');
            }
            else
            {
                $.messager.alert('提示信息','创建失败','info');
            }
        } 
    });		
    
}
//记录病历操作行为日志
function SetToLog(catalogId,tags){
    if (categoryId != "" && templateId != "")
    {
        if (IsSetToLog == "Y")
        {
            var ipAddress = getIpAddress();
            var ModelName = "EMR.FavoritesAdd.OK";
            var Condition = "";
            Condition = Condition + '{"patientID":"' + PatientNo + '",';
            Condition = Condition + '"episodeID":"' + EpisodeID + '",';
            Condition = Condition + '"userName":"' + escape(UserName) + '",';
            Condition = Condition + '"userID":"' + UserID + '",';
            Condition = Condition + '"ipAddress":"' + ipAddress + '",';
            Condition = Condition + '"InstanceID":"' + InstanceID + '",';
            Condition = Condition + '"categoryId":"' + categoryId + '",';
            Condition = Condition + '"templateId":"' + templateId + '",';
            Condition = Condition + '"Tags":"' + tags + '",';
            Condition = Condition + '"CatalogID":"' + catalogId + '"}';
            var ConditionAndContent = Condition;
            var SecCode = "";
            $.ajax({ 
                //type: "POST", 
                url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
                data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + SecCode
            });
        }
    }
}
