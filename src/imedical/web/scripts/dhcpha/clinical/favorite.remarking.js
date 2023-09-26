??$(function(){
	initFavInfo();
	$("#saveComment").click(function(){
		
		//��¼�û�(�����ղ�.��������.��������)��Ϊ
		AddActionLog(userId,userLocId,"FavoritesView.RecordComment.Comment","");  

		if ($("#content").text() != "��������Ϊ1-200��")
		{
			saveComment();
			$("#content").empty();
			document.getElementById('content').value = document.getElementById('content').defaultValue;
			$("#content").css("color","#999");
		}
	});
	getComment();
	var content = '<iframe id="framInstance" scrolling="no" frameborder="0" src="dhcpha.clinical.browse.editor.csp?id='+instanceId+'&pluginType='+pluginType+'&chartItemType='+chartItemType+'&emrDocId='+emrDocId+'"></iframe>';
	$(".fac_right").append(content);
});

//��ʼ��������Ϣ
function initFavInfo()
{
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=GetInfoByID&FavInfoID="+favInfoId, 
        error: function (XMLHttpRequest,textStatus,errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	setFavInfo(eval(data));
        } 
    });	
}

//���ز�����Ϣ
function setFavInfo(data)
{
	$("#record").empty();
	for (var i=0;i<data.length;i++)
	{
		var table = $('<table class="tbData" style="width:100%;height:130px;"></table>');
		var tr = $('<tr></tr>');
		$(tr).append('<td class="tdtitle" colspan=3><span>����ID:</span><span class="tcol1">'+data[i].PatientNo+" "+'</span><span>��������:</span><span class="tcol1">'+instanceName+'</span></td>');
		$(table).append(tr);
		var image =  data[i].Gender=="Ů"?"../scripts/dhcpha/emr/image/icon/women_cq.png":"../scripts/dhcpha/emr/image/icon/men_cq.png";
		var tr =  $('<tr></tr>');
		$(tr).append('<td class="centertd"><img src="'+image+'"/></td>');
		var td = '<td class="info">';
		td = td + '<div><span>����:</span><span>'+data[i].Name+'</span></div>';
		td = td + '<div><span>�Ա�:</span><span>'+data[i].Gender+'</span></div>';
		td = td + '<div><span>��������:</span><span>'+data[i].BOD+'</span></div>';
		td = td + '</td>';
		var td = td + '<td id="remark-tagMemo">';
		td = td + '<div id="remark-Memo">'+data[i].Memo+'</div>';
		td = td + '<div id="tags">'
		for (var j=0;j<data[i].Tags.length;j++)
		{
			td = td + '<span class="tag">'+data[i].Tags[j].TagName+'</span>';
		}
		td = td +'</div></td>';
		$(tr).append(td);
		$(table).append(tr);
		$("#record").append(table);
  	}	
}

//��������
function saveComment()
{
	var content = $("#content").text();
	var score = $("#result").val();
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls",
        //���������˿����ֶ�userLocCode 
        data: "Action=SaveComment&Content="+content+"&UserID="+userId+"&UserLocCode="+userLocCode+"&InstanceID="+instanceId+"&Scores="+score+"&FavInfoID="+favInfoId, 
        error: function (XMLHttpRequest,textStatus,errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	if (data != "")
        	{
	        	initComment(eval(data));
	        }
	        else
	        {
		        alert("����ʧ��");
		    }
        } 
    });	
}

//��ʾ������Ϣ
function getComment()
{
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=GetComment&InstanceID="+instanceId+"&FavInfoID="+favInfoId, 
        error: function (XMLHttpRequest,textStatus,errorThrown) { 
            alert(textStatus); 
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

//��������
function initComment(data)
{
	for (var i=0;i<data.length;i++)
	{
		var item = $('<div id="'+data[i].id+'" class="item"></div>');
		//��ȡ�����˿����ֶ�userLoc
		$(item).append('<div class="user">'+data[i].userName+"  "+data[i].userLoc+'</div>');
		var opic = '<div class="star sa'+data[i].score+'"></div>';
		opic = opic + '<div class="date-comment">'+data[i].datetime+'</div>';
		opic = opic + '<strong class="topic"></strong>';
		opic = opic + '<div class="comment-content">'+data[i].content+'</div>';
		opic = opic + '<div class="btns"><a href="#" onclick="replay('+"'"+data[i].id+"','"+data[i].userName+"'"+')"><i class="glyphicon glyphicon-share-alt"></i>�ظ�</a></div>';
		opic = opic + '<div class="fd"></div>';
		$(item).append(opic);
		$("#comments-list").append(item);
		getReplays(data[i].id);
	}
	
}

///�ظ�
function replay(id,name)
{
	//��¼�û�(�����ղ�.��������.�ظ�����)��Ϊ
	AddActionLog(userId,userLocId,"FavoritesView.RecordComment.Reply","");  
	
	var content = replayForm(id,name,0);
	$("#"+id+" .comment-content").append(content);
}

///�ظ�����
function replayForm(id,name,parentId)
{
	var content = $('<div style="display: block;" class="replay-form"></div>');
	var replywrap = $('<div class="reply-wrap"></div>');
	$(replywrap).append('<p><em>�ظ�</em><span class="u-name">'+" "+name+'</span></p>');
	var reply = $('<div class="reply-input"></div>');	
	$(reply).append('<textarea id="txtreplay" name="txtreplay" rows="2"></textarea><a href="#" onclick="saveReplay('+"'"+id+"','"+parentId+"'"+')" class="reply-btn btn-gray" style="float:right;">�ظ�</a><div class="clr"></div>');
	$(replywrap).append(reply);  
	$(content).append(replywrap);
	return content;
}

///������ػظ�
function saveReplay(id,parentId)
{
	var content = $("#"+id+ ".comment-content #txtreplay").val();
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=SetReplyComment&CommentID="+id+"&ParentID="+parentId+"&Content="+content+"&UserID="+userId, 
        error: function (XMLHttpRequest,textStatus,errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
       		if (data != "")
       		{
	       		var data = eval("("+data+")");
	       		setReplay(data.commentId,data.userName,data.content,data.datetime);
	       	}
        } 
    });		
}

//���ػظ�
function setReplay(id,name,content,datetime)
{
	var replay = $('<div class="reply-list"></div>');
	$(replay).append('<div class="reply-con"><span class="u-name">'+name+" "+':<em>�ظ�</em></span><span class="u-con">'+" "+content+'</span>');
	$(replay).append('<div class="reply-meta"><span class="reply-left fl">'+datetime+'</span></div>');
	$("#"+ id + " .comment-content .replay-form").remove();
	$("#"+ id + " .comment-content").append(replay);
}

//ȡ�������ۻظ�
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

//�ݹ�������ۻظ�
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

//ҳ��ر�
window.onunload=function()
{
	//��¼�û�(�����ղ�.��������.ҳ��ر�)��Ϊ
    AddActionLog(userId,userLocId,"FavoritesView.RecordComment.Page.Close",""); 			
}
//��������
function limit(length)
{
	var curlength = $("#content").val().length;
	if(curlength > length)
	{
		var num = $("#content").val().substr(0,length);
		$("#content").val(num);
		alert("����200�������ƣ�������ֱ��ضϣ�");
	}
}
//����ؼ��¼�
function my_click(obj, myid)
{
	if (document.getElementById(myid).value == document.getElementById(myid).defaultValue)
	{
		document.getElementById(myid).value = '';
		obj.style.color='#000';
	}
}
//�뿪�ؼ��¼�
function my_blur(obj, myid)
{
	if (document.getElementById(myid).value == '')
	{
		document.getElementById(myid).value = document.getElementById(myid).defaultValue;
		obj.style.color='#999'
	}
}
