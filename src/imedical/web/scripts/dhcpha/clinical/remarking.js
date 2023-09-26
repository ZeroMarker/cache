$(function(){	
	$("#saveComment").click(function(){	
		if ($.trim($("#content").val())!= "字数限制1-500字")
		{
			if($.trim($("#content").val())==""){
				alert("评论内容不能为空!");
			}
			else{
				saveComment();	
		   		$("#content").empty();	
			}
		}
	});
		getComment();
});

//保存评论
function saveComment()
{
	
	var content = $("#content").val();
	var score = $("#result").val(); //评分等级（1-5）
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls",
        async:false,
        //新增评论人科室字段userLocCode 
        data: "Action=SaveComment&Content="+content+"&UserID="+userId+"&UserLocCode="+userLocCode+"&InstanceID="+instanceId+"&Scores="+score+"&FavInfoID="+favInfoId, 
        error: function (XMLHttpRequest,textStatus,errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	if (data != "")
        	{    	
	        	getComment();
	        }
	        else
	        {
		        alert("发表失败");
		    }
        } 
    });
}

//显示评论信息
function getComment()
{   
 	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        async:false,
        data: "Action=GetComment&InstanceID="+instanceId+"&FavInfoID="+favInfoId, 
        error: function (XMLHttpRequest,textStatus,errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
       		if (data != "")
       		{
	       		$("#comments-list").empty();
	       		initComment(eval("("+data+")"));
	       		
	       	}
        } 
    });	
}

//加载评论
function initComment(data)
{
	
	obtainPage(data);
}

///回复
function replay(id)   
{          
           var replaycontent='<div class="replay">';
           replaycontent+='<textarea id="txtreplay'+id+'" rows="5" cols="80" autofocus="true"></textarea>' ;
           replaycontent+='<div class="repleybtns">';
           replaycontent+='<div style="float:left" class="commitbtn" onclick=commitreply('+id+","+0+')>确定</div>';
           replaycontent+='<div style="float:left" class="canclebtn" onclick="canclereply()">取消</div>';
           replaycontent+='</div>';
           replaycontent+='</div>';
	       $("#replycontent"+id+"").html(replaycontent);
	       $("#replycontent"+id+"").show();	   	     
 	}

function canclereply(){

	 $(".replycontent").hide();
	
	}
	
	
function commitreply(id,parentId){
	var replycontent = $("#txtreplay"+id+"").val();
	if($.trim(replycontent)==""){
		alert("评论回复内容不能为空!");return;
	}
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=SetReplyComment&CommentID="+id+"&ParentID="+parentId+"&Content="+replycontent+"&UserID="+userId, //dws 2017-01-19 评论回复人
        error: function (XMLHttpRequest,textStatus,errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
       		if (data != "")
       		{    
	       		 var data = eval("("+data+")");
	       	     $("#txtreplay").empty();
	       		 $(".replycontent").hide();
	       		 setReplay(data.commentId,data.userName,data.content,data.datetime);
	       	}
        } 
    });	
	}


//加载回复
function setReplay(id,name,content,datetime)
{
	$('#reply-list'+id).css({'width':'75%','height':'auto'});
	$(".replycontent").hide();
	var replay=$('<ul></ul>');
	var replaylist=$('<li></li>');
	$(replaylist).append('<span style="color:#5CAE5C;">'+name+" "+':</span>');
	$(replaylist).append('<span>回复</span>');
	$(replaylist).append('<span class="reply-left">'+datetime+'</span>');
	$(replaylist).append('<span style="margin-left: 30px;margin-top:5px;display:block">'+content+'</span>');
	$(replay).append(replaylist)
	$('#reply-list'+id).append(replay);

}

//取病历评论回复
function getReplays(id)
{
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=GetReplyComment&CommentID="+id+"&ParentID=0", 
        error: function (XMLHttpRequest,textStatus,errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
       		if (data != "")
       		{
	       		var data = eval("("+data+")");
	       		setReplays(data);
	       	}
        } 
    });	
}

//递归加载评论回复
function setReplays(data)
{
	for (var i=0;i<data.length;i++)
	{
		setReplay(data[i].commentId,data[i].userName,data[i].content,data[i].datetime);
		if (data[i].children.length>0)
		{
			setReplays(data[i].children)
		}
	}
}

//页面关闭
window.onunload=function()
{
	//记录用户(整理收藏.病历评价.页面关闭)行为
    AddActionLog(userId,userLocId,"FavoritesView.RecordComment.Page.Close",""); 			
}
//字数限制
function limit(length)
{
	var curlength = $("#content").val().length;
	if(curlength > length)
	{
		var num = $("#content").val().substr(0,length);
		$("#content").val(num);
		alert("超出200字数限制，多出的字被截断！");
	}
}
//点击控件事件
function my_click(obj, myid)
{
	if (document.getElementById(myid).value == document.getElementById(myid).defaultValue)
	{
		document.getElementById(myid).value = '';
		obj.style.color='#000';
	}
}
//离开控件事件
function my_blur(obj, myid)
{
	if (document.getElementById(myid).value == '')
	{
		document.getElementById(myid).value = document.getElementById(myid).defaultValue;
		obj.style.color='#999'
	}
}
