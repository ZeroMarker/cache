$(function(){
  
if (arrayStr != "")
    {
	    var opts = JSON.parse(unescape(utf8to16(base64decode(arrayStr)))); 
	    userID = opts.UserID;
        favInfoID = opts.FavInfoID;
        userLocID =opts.UserLocID;
    }
	getTags();
	$("#ckxSelectAll").change(function() {
		
		//记录用户(整理收藏.添加关键字.全选)行为
	    AddActionLog(userID,userLocID,"FavoritesView.KeyWordAdd.SelectAll",""); 
    
        var checked=$("#ckxSelectAll").prop("checked");  
        var tag = "";
        $("input:checkbox[name='tag']").each(function(){
            var id = $(this).attr("id");
            tag = tag + id+"^"+checked + ",";
            if (checked) //全选
            {
                $(this).attr("checked","true");
            }
            else  //取消全选
            {
                $(this).removeAttr("checked");
            }
        });
        addInfotoTag(tag.substring(0,tag.length-1),favInfoID); 
    })  
	
	//关闭
	$("#btnCancel").click(function(){
		
		//记录用户(整理收藏.添加关键字.关闭)行为
	    //AddActionLog(userID,userLocID,"FavoritesView.KeyWordAdd.Close",""); 
	    
		CloseWindow();
	});
	
	//添加标签
	$("#btnAddTag").click(function(){
		
		//记录用户(整理收藏.添加关键字.关闭)行为
	    AddActionLog(userID,userLocID,"FavoritesView.KeyWordAdd.Create",""); 
	    
		addTag();
	});
	
	$("input:checkbox[name='tag']").live("change",function() {
		var checked = $(this)[0].status;
		var id = $(this).attr("id");
		var tag = id+"^"+checked;
		addInfotoTag(tag,favInfoID);
	});
});


///我的收藏
function getTags()
{
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=GetTags&UserID="+userID, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	if (data != "")
        	{
        		initTags(eval(data));
        		getFavInfoTag();
        	}
        } 
    });	
}

//初始化标签列表
function initTags(data)
{
	for (var i=0;i<data.length;i++)
	{
		var tag = "<label><input type='checkbox' name='tag' id='"+data[i].id+"'/>"+data[i].text+"</label><br/>";
		$('#tags').append(tag);
	}
}

//病历标签
function getFavInfoTag()
{
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=GetTagsByInfoID&FavInfoID="+favInfoID, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	if (data != "")
        	{
	        	data = eval(data);
	        	for (var i=0;i<data.length;i++)
	        	{
		        	$("#"+data[i].TagID).attr("checked",true);
		        }
	        }
        } 
    });	
}	

//将病历加入标签
function addInfotoTag(tag,favInfoId)
{
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=AddInfoToTag&Tag="+tag+"&FavInfoID="+favInfoId,
        async: false, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	if (data == "0")
        	{
	        	$.messager.alert('提示信息','添加失败','info');
	        }
        } 
    });	    	
}
///创建关键字
function addTag()
{
	var tagName = $("#txtTagName").val()
	tagName = tagName.replace(/(^\s*)|(\s*$)/g, ""); 
	if (tagName == "")
	{
		alert("标签名称不能为空");
		return;
	}
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=AddTag&UserID="+userID+"&TagName="+tagName, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
           	alert(textStatus); 
        }, 
        success: function (data) { 
        	if (data != "0")
        	{
	        	var element=$("#"+data);
 				if (element.length <= 0)
 				{
	        		var tag = "<label><input type='checkbox' name='tag' id='"+data+"'/>"+tagName+"</label><br/>";
					$('#tags').append(tag);	
 				}
        	}
        	else
        	{
	        	alert("添加失败");
	        }
        }  
    });	 	
}

//字数限制
function limit()
{
	var curlength = $("#txtTagName").val().length;
	if(curlength > 15)
	{
		var num = $("#txtTagName").val().substr(0,15);
		$("#txtTagName").val(num);
		alert("超出15字数限制，请重新输入！");
	}
}

/*window.onunload=function()
{
	//记录用户(整理收藏.添加关键字.页面关闭)行为
    AddActionLog(userID,userLocID,"FavoritesView.KeyWordAdd.Page.Close",""); 
	
	CloseWindow();
}
//关闭窗口
function CloseWindow()
{
	var checkedList = new Array();
	$('input:checkbox[name=tag]:checked').each(function(i){
		var text = $(this).parent().text(); 
		var id = $(this).attr("id");
		checkedList.push({"id":id,"text":text});
	});
	window.returnValue = checkedList;
	if ((arrayStr != ""))
	{
		parent.closeDialog("addInfoToTag");	
	}
	else
	{
		//兼容showModalDialog写法
		window.opener=null;
		window.open('','_self');
		window.close();	
	} 

}*/

function dialogBeforeClose()
{
	var returnValue = new Array();
	$('input:checkbox[name=tag]:checked').each(function(i){
		var text = $(this).parent().text(); 
		var id = $(this).attr("id");
		returnValue.push({"id":id,"text":text});
	});
	window.returnValue = returnValue;
}

function CloseWindow(){
	parent.closeDialog("addInfoToTag");	
	}
