﻿$(function(){
    //已经收藏的病历
    getRecords();
    //就诊列表
    getEpisodeList();
    $HUI.radio("input[name='episode']",{
        onChecked:function(e,value){
            var queryItem = $("#episodeSeek").val();
            var id = $(e.target).attr("id");
            if (id == "all") {
                queryData(queryItem,"");
            }else {
                queryData(queryItem,id);
            }
        }
    });
    $HUI.radio("#all").check();
    ///按就诊内容查找
    $("#episodeSeek").searchbox({ 
        searcher:function(value,name){
            var episodeType = $("input[name='episode']:checked").attr("id");
            episodeType = (episodeType == "all")?"":episodeType;
            queryData(value,episodeType);
        },
        prompt : emrTrans("请输入诊断内容")+"..."
    });
});

//查询
function queryData(queryItem,episodeType)
{
    //记录用户(整理收藏.查看病历.全部就诊病历.类型)行为
    AddActionLog(userId,userLocId,"FavoritesView.RecordView.AllRecord."+episodeType,"");
    
    $("#episodeList").datagrid('load', {
        Action: "GetEpisodeList",
        PatientID: patientId,
        QueryItem: queryItem,
        EpisodeType: episodeType
    });
}
// 取消收藏病历
function cancelFavRecrod(instanceId,episodeId,favInfoId,pluginType,chartItemType,emrDocId,episodeDate,episodeType,episodeLoc)
{
    //记录用户(整理收藏.查看病历.取消病历收藏)行为
    AddActionLog(userId,userLocId,"FavoritesView.RecordView.Record.UnFavorite","");

    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=CancelFavRecrod&FavInfoID="+favInfoId+"&EpisodeID="+episodeId+"&InstanceID="+instanceId, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
            if (data == "1") 
            {
                var tmpArray = removeRecord("favoriteRecordList #"+episodeId,instanceId);
                
                $(tmpArray).find(".titlediv>span").remove();
                var titlediv = "<span class='favIcon icon icon-star-light-yellow' onclick='doFavorite("+'"'+ instanceId +'","'+episodeId+'","'+favInfoId +'","'+pluginType+'","'+chartItemType+'","'+emrDocId+'","'+episodeDate+'","'+episodeType+'","'+episodeLoc+'"'+")' title='"+emrTrans("添加收藏")+"' alt align='top' border='0' style='width:20px;height:inherit'/>";
                $(tmpArray).find(".titlediv").append(titlediv);
                
                $(tmpArray).find(".datediv>span").remove();
                
                if ($("#editEpisode #"+episodeId+" .apply_nav").length>0)
                {
                    $("#editEpisode #"+episodeId+" .apply_nav").append(tmpArray);
                }else
                {
                    var apply = $('<div id="'+episodeId+'" class="apply"></div>');
                    $(apply).append('<div class="titlelist"><span>'+episodeDate+'</span><span>'+episodeType+'</span><span>'+episodeLoc+'</span></div>');
                    var applynav = $('<div class="apply_nav"></div>');
                    $(applynav).append(tmpArray);
                    $(apply).append(applynav);
                    $("#editEpisode").append(apply);
                }
            }
            else
            {
                alert("取消失败");
            }
        }
    });
}

//对病历进行评论
function remarkingFav(instanceId,favInfoId,instanceName,episodeId,pluginType,chartItemType,emrDocId)
{
    //记录用户(整理收藏.查看病历.点评病历)行为
    AddActionLog(userId,userLocId,"FavoritesView.RecordView.Record.Comment","");
    var url = "emr.fav.remarking.csp?FavInfoID="+favInfoId+"&InstanceID="+instanceId+"&InstanceName="+instanceName+"&EpisodeID="+episodeId+"&UserID="+userId+"&UserLocID="+userLocId+"&pluginType="+pluginType+"&chartItemType="+chartItemType+"&emrDocId="+emrDocId+"&MWToken="+getMWToken();
    var content = "<iframe id='iframeModifyTitle' scrolling='auto' frameborder='0' src="+url+" style='width:100%;height:100%;display:block;'></iframe>";;
    parent.addTab("tabFavorite","remark"+instanceId,emrTrans("对 ")+instanceName+emrTrans(" 评价"),content,true);
    
}

//添加收藏
function doFavorite(instanceId,episodeId,favInfoId,pluginType,chartItemType,emrDocId,episodeDate,episodeType,episodeLoc)
{
    //记录用户(整理收藏.查看病历.全部就诊病历.添加病历)行为
    AddActionLog(userId,userLocId,"FavoritesView.RecordView.AllRecord.AddRecord","");
    
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=AddFavRecord&FavInfoID="+favInfoId+"&EpisodeID="+episodeId+"&InstanceID="+instanceId, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
            if (data == "1") 
            {
                var tmpArray = removeRecord("editEpisode #"+episodeId,instanceId);
                
                var titleText = $(tmpArray).find(".title").text();
                
                $(tmpArray).find(".titlediv>span").remove();
                var titlediv = "<span class='favIcon icon-star-yellow' onclick='cancelFavRecrod("+'"'+ instanceId +'","'+episodeId+'","'+favInfoId +'","'+pluginType+'","'+chartItemType+'","'+emrDocId+'","'+episodeDate+'","'+episodeType+'","'+episodeLoc+'"'+")' title='"+emrTrans("取消收藏")+"' alt align='top' border='0' style='width:20px;height:inherit'/>";
                $(tmpArray).find(".titlediv").append(titlediv);
                
                var datediv = "<span class='favIcon icon-add-note' onclick='remarkingFav("+'"'+ instanceId +'","'+ favInfoId +'","'+titleText+'","'+episodeId+'","'+pluginType+'","'+chartItemType+'","'+emrDocId+'"'+")' title='"+emrTrans("病历评价")+"' alt align='top' border='0' style='width:20px;height:inherit'/>";
                $(tmpArray).find(".datediv").append(datediv);
                
                if ($("#favoriteRecordList #"+episodeId+" .apply_nav").length>0)
                {
                    $("#favoriteRecordList #"+episodeId+" .apply_nav").append(tmpArray);
                }
                else
                {
                    var apply = $('<div id="'+episodeId+'" class="apply"></div>');
                    $(apply).append('<div class="titlelist"><span>'+episodeDate+'</span><span>'+episodeType+'</span><span>'+episodeLoc+'</span></div>');
                    var applynav = $('<div class="apply_nav"></div>');
                    $(applynav).append(tmpArray);
                    $(apply).append(applynav);
                    $("#favoriteRecordList").append(apply);
                }
            }
            else
            {
                alert("添加失败");
            }

        }
    });
}

//从界面移除病历
function removeRecord(pageId,instanceId)
{
    var data = "";

    $("#"+pageId+" .apply_array").each(function(i){
        if($(this).find(".content").attr("id")==instanceId) {
            if ((pageId.indexOf("editEpisode")>=0)||(pageId.indexOf("favoriteRecordList")>=0)) {
                data = $(this);
            }
            $(this).remove();
            if ($("#"+pageId+" .apply_nav")[0].children.length == 0) {
                $("#"+pageId).remove();
            }
            return false;
        }
    });

    return data;
}

//添加病历
function setRecord(episodeId,data)
{
    $("#favoriteRecordList #"+episodeId+" .apply_nav").append(data);
}

//未收藏病历
function getNoFavRecords(admData)
{
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=GetNoFavRecords&FavInfoID="+favInfoId+"&EpisodeID="+admData.EpisodeID, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
            $("#editEpisode").empty();
            var result = setRecords(eval(data),"NoFavoriteRecord",favInfoId,admData.EpisodeID,admData.EpisodeDate+" "+admData.EpisodeTime,admData.EpisodeType,admData.EpisodeDeptDesc);
            $("#editEpisode").append(result);
        } 
    });
}

///我的收藏
function getRecords()
{
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=GetFavRecords&FavInfoID="+favInfoId, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus);
        }, 
        success: function (data) {
            $("#favoriteRecordList").empty();
            var array = eval(data);
            for (var i=0;i<array.length;i++)
            {
                var result = setRecords(array[i].Records,"FavoriteRecord",favInfoId,array[i].EpioseID,array[i].EpisodeDateTime,array[i].EpisodeType,array[i].EpisodeLoc); 
                $("#favoriteRecordList").append(result);
            }
        }
    });
}

///加载病例列表
function setRecords(data,type,favInfoId,episodeId,episodeDate,episodeType,episodeLoc)
{
    var apply = $('<div id="'+episodeId+'" class="apply"></div>');
    $(apply).append('<div class="titlelist"><span>'+episodeDate+'</span><span>'+emrTrans(episodeType)+'</span><span>'+episodeLoc+'</span></div>');
    
    var applynav = $('<div class="apply_nav"></div>');
    for (var i=0;i<data.length;i++)
    {
        var array = $('<div class="apply_array"></div>');
        var content = $('<div class="content"></div>');
        $(content).attr({"id":data[i].id,"isLeadframe":data[i].isLeadframe,"text":data[i].text});
        $(content).attr({"chartItemType":data[i].chartItemType,"documentType":data[i].documentType});
        $(content).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":data[i].categoryId});
        $(content).attr({"templateId":data[i].templateId});
        if(data[i].status=="完成") {
            $(content).append("<div class='info pic'>"+data[i].summary+"</div>");
        }else {
            $(content).append("<div class='info'>"+data[i].summary+"</div>");
        }
        var tag = $('<div class="tag"></div>');
        var titlediv = "<div class='titlediv'><div class='title' title='"+data[i].text+"'>"+data[i].text+"</div>";
        var datediv = "<div class='datediv'><div class='date'>"+data[i].happendate+" "+data[i].happentime+"</div>";
        if (type == "FavoriteRecord")
        {
            titlediv = titlediv + "<span class='favIcon icon-star-yellow' onclick='cancelFavRecrod("+'"'+ data[i].id +'","'+episodeId+'","'+favInfoId +'","'+data[i].documentType+'","'+data[i].chartItemType+'","'+data[i].emrDocId+'","'+episodeDate+'","'+episodeType+'","'+episodeLoc+'"'+")' title='"+emrTrans("取消收藏")+"' alt align='top' border='0' style='width:20px;height:inherit'/>";
            
            datediv = datediv + "<span class='favIcon icon-add-note' onclick='remarkingFav("+'"'+ data[i].id +'","'+ favInfoId +'","'+data[i].text+'","'+episodeId+'","'+data[i].documentType+'","'+data[i].chartItemType+'","'+data[i].emrDocId+'"'+")' title='"+emrTrans("病历评价")+"' alt align='top' border='0' style='width:20px;height:inherit'/>";
        } 
        else
        {
            titlediv = titlediv + "<span class='favIcon icon-star-light-yellow' onclick='doFavorite("+'"'+ data[i].id +'","'+episodeId+'","'+favInfoId+'","'+data[i].documentType+'","'+data[i].chartItemType+'","'+data[i].emrDocId+'","'+episodeDate+'","'+episodeType+'","'+episodeLoc+'"'+")' title='"+emrTrans("添加收藏")+"' alt align='top' border='0' style='width:20px;height:inherit'/>";
        }
        titlediv = titlediv + "</div>";
        $(tag).append(titlediv);
        datediv = datediv + "</div>";
        $(tag).append(datediv);
        $(content).append(tag);
        $(array).append(content);
        $(applynav).append(array);
    }
    $(apply).append(applynav);
    return apply;
}

//打开病历
$(document).on('click','.apply .content .info', function(){
    var id = $(this).parent().attr("id"); 
    var text = $(this).parent().attr("text");
    var pluginType = $(this).parent().attr("documentType");
    var chartItemType = $(this).parent().attr("chartItemType");
    var emrDocId = $(this).parent().attr("emrDocId");
    var templateId = $(this).parent().attr("templateId");
    var isLeadframe = $(this).parent().attr("isLeadframe");
    var isMutex = $(this).parent().attr("isMutex");
    var categoryId = $(this).parent().attr("categoryId");
    var actionType = "LOAD";
    var status = "NORMAL";
    var url = "emr.record.browse.browsform.editor.csp?patientId="+patientId+"&id="+id+"&pluginType="+pluginType+"&chartItemType="+chartItemType+"&emrDocId="+emrDocId+"&Action=reference"+"&MWToken="+getMWToken();
    window.open(url,"","width:100%,height:100%,top=0,left=0");
    
    //记录用户(整理收藏.查看病历.打开病历)行为
    AddActionLog(userId,userLocId,"FavoritesView.RecordView.Record.Open",text);
});

//就诊列表
function getEpisodeList()
{
    $("#episodeList").datagrid({
        loadMsg:'数据装载中......',
        url:'../EMRservice.Ajax.hisData.cls?Action=GetEpisodeList&PatientID='+patientId,
        singleSelect:true,
        rownumbers:true,
        pagination:true,
        pageSize:10,
        pageList:[10,20,30],
        idField:'EpisodeID',
        fit:true,
        fitColumns: true,
        remoteSort: false,
        columns:[[  
            {field:'EpisodeDate',title:'就诊日期',width:150,align:'left'},
            {field:'EpisodeTime',title:'就诊时间',width:150,align:'left'},
            {field:'Diagnosis',title:'诊断',width:400,align:'left'},
            {field:'EpisodeType',title:'类型',width:103,formatter:formatColor,align:'left',
            	styler: function (value) 
            	{
            	    if (value == "住院")
				    {
				        return 'background-color:#47CE27;color:#fff;'
				    }
				    else if (value == "门诊")
				    {
				        return 'background-color:#FF3D3D;color:#fff;'
				    }
				    else if (value == "急诊")
				    {
				        return 'background-color:#339EFF;color:#fff;'
				    }else
				    {
				        return '';
				    }
	            }
            },
            {field:'EpisodeDeptDesc',title:'科室',width:200,align:'left'},
            {field:'MainDocName',title:'主治医生',width:143,align:'left'},
            {field:'DischargeDate',title:'出院日期',width:150,align:'left'},
            {field:'EpisodeID',title:'就诊号',hidden:true}
        ]],
        onSelect:function(rowIndex,rowData){
            getNoFavRecords(rowData);
        }
      });
}

//设置颜色
function formatColor(val,row)
{
    val = emrTrans(val);
    if (row.EpisodeType == "住院")
    {
        return '<span">'+val+'</span>';
    }
    else if (row.EpisodeType == "门诊")
    {
        return '<span">'+val+'</span>';
    }
    else if (row.EpisodeType == "急诊")
    {
        return '<span">'+val+'</span>';
    }else
    {
        return '<span>'+val+'</span>';
    }
}
