﻿$(function(){
	$("#content").attr("placeholder",emrTrans("字数限制为1-200个"));
    initFavInfo();
    getComment();
    
    $('#editorFrame').attr('src', 'emr.record.browse.browsform.editor.csp?id='+instanceId+'&pluginType='+pluginType+'&chartItemType='+chartItemType+'&emrDocId='+emrDocId+"&MWToken="+getMWToken());
    
    $("#saveComment").click(function(){
        
        //记录用户(整理收藏.病历评价.发表评价)行为
        AddActionLog(userId,userLocId,"FavoritesView.RecordComment.Comment","");

        if ($("#content").val() != "" ) {
            saveComment();
            changeIconStatus(0);
            $("#result").attr("value","0");
            $("#content").val('');
        }else {
            $.messager.alert("提示信息", "请填写评价内容！", 'info');
        }
        
    });
	if ("undefined"==typeof HISUIStyleCode || HISUIStyleCode=="")
	{
		 // 炫彩版
	}
	else if (HISUIStyleCode=="lite")
	{
		 // 极简版
		$('#content').css('height','96px')
	}else
	{
		// 炫彩版
	}
});

//初始化病历信息
function initFavInfo()
{
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=GetInfoByID&FavInfoID="+favInfoId, 
        error: function (XMLHttpRequest,textStatus,errorThrown) { 
            $.messager.alert("提示信息", textStatus, 'info');
        }, 
        success: function (data) { 
            setFavInfo(eval(data));
        }
    });
}

//加载病历信息
function setFavInfo(data)
{
	var manImg = "";
	var womanImg = "";
	if ("undefined"==typeof HISUIStyleCode || HISUIStyleCode==""){
	 // 炫彩版
	 var manImg = "scripts/emr/image/icon/man_big.png";
	 var womanImg = "scripts/emr/image/icon/woman_big.png";
	 }else if (HISUIStyleCode=="lite"){
	 // 极简版
	 var manImg = "images/man_lite.png";
	 var womanImg = "images/woman_lite.png";
	 }else{
	// 炫彩版
	 var manImg = "scripts/emr/image/icon/man_big.png";
	 var womanImg = "scripts/emr/image/icon/woman_big.png";
	}
    $("#record").empty();
    var table = $('<table class="tbData"></table>');
    var tr = $('<tr></tr>');
    var image =  data[0].Gender=="女"?"../"+womanImg:"../"+manImg;
    var td = '<td class="centertd"><img src="'+image+'" style="height:60px;width:60px;border-radius:30px"/></td>';
    td = td + '<td class="info">';
    td = td + '<div><span>'+data[0].Name+'</span><div class="i-sep"></div>';
    td = td + '<span>'+data[0].Gender+'</span><div class="i-sep"></div>';
    td = td + '<span>'+data[0].BOD+'</span></div>';
    td = td + '<div>'+emrTrans("患者ID")+'<span>'+data[0].PatientNo+'</span><div class="i-sep"></div>';
    td = td + '<span>'+emrTrans("病历名称")+'</span>'+instanceName+'</div></td>';
    $(tr).append(td);
    $(table).append(tr);
    $("#record").append(table);
}

//显示评论信息
function getComment()
{
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=GetComment&InstanceID="+instanceId+"&FavInfoID="+favInfoId, 
        error: function (XMLHttpRequest,textStatus,errorThrown) { 
            $.messager.alert("提示信息", textStatus, 'info');
        }, 
        success: function (data) { 
            if (data != "")
            {
                $("#comments-list").empty();
                initComment(eval(data));
            }
        }
    });
}

//加载评论
function initComment(data)
{
    for (var i=0;i<data.length;i++)
    {
        var item = $('<div id="'+data[i].id+'" class="item"></div>');
        
        //读取评论人科室字段userLoc
        var content = '<div class="userInfo"><span>'+data[i].userName+"  "+data[i].userLoc+'</span>';
        content = content + '<span class="date-comment">'+data[i].datetime+'</span></div>';
        content = content + '<div class="starScore" style="height:30px">';
        var total = parseInt(data[i].score);
        if (total != 0) {
            for (n=1;n<=total;n++) {
                content = content + '<span class="favIcon icon icon-star" style="width:20px;height:inherit;display:inline-block"/>';
            }
        }
        if (total != 5) {
            for (n=1;n<=(5 - total);n++) {
                content = content + '<span class="favIcon icon-star-empty" style="width:20px;height:inherit;display:inline-block"/>';
            }
        }
        content = content + '</div>';
        content = content + '<div class="comment-content">'+data[i].content+'</div>';
        content = content + '<div class="fd"/>';
        $(item).append(content);
        $("#comments-list").append(item);
    }
    
}

//保存评论
function saveComment()
{
    var content = $("#content").val();
    var score = $("#result").attr("value");
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls",
        async : false,
        //新增评论人科室字段userLocCode 
        data: "Action=SaveComment&Content="+content+"&UserID="+userId+"&UserLocCode="+userLocCode+"&InstanceID="+instanceId+"&Scores="+score+"&FavInfoID="+favInfoId, 
        error: function (XMLHttpRequest,textStatus,errorThrown) { 
            $.messager.alert("提示信息", textStatus, 'info');
        }, 
        success: function (data) { 
            if (data != "")
            {
                initComment(eval(data));
            }
            else
            {
                $.messager.alert("提示信息", "发表评论失败！", 'info');
            }
        }
    });
}

//评价图标点击触发事件
function picScore(id){
    var score = $("#"+id).attr("value");
    $("#result").attr("value",score);
    $("#result").text($("#"+id).attr("title"));
    var className = $("#"+id).attr("class");
    changeIconStatus(parseInt(score));
}

//改变评价图标样式
function changeIconStatus(num) {
    $("span[name=startscore]").each(function(i){
        if (i < num) {
            $(this).attr("class","favIcon icon icon-star");
        }else {
            $(this).attr("class","favIcon icon icon-star-empty");
        }
    });
}

//字数限制
function limit(length)
{
    var curlength = $("#content").val().length;
    if(curlength > length)
    {
        var num = $("#content").val().substr(0,length);
        $("#content").val(num);
        $.messager.alert("提示信息", "超出200字数限制，多出的字被截断！", 'info');
    }
}
