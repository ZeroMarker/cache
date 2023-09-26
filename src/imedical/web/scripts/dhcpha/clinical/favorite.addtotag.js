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
		
		//��¼�û�(�����ղ�.��ӹؼ���.ȫѡ)��Ϊ
	    AddActionLog(userID,userLocID,"FavoritesView.KeyWordAdd.SelectAll",""); 
    
        var checked=$("#ckxSelectAll").prop("checked");  
        var tag = "";
        $("input:checkbox[name='tag']").each(function(){
            var id = $(this).attr("id");
            tag = tag + id+"^"+checked + ",";
            if (checked) //ȫѡ
            {
                $(this).attr("checked","true");
            }
            else  //ȡ��ȫѡ
            {
                $(this).removeAttr("checked");
            }
        });
        addInfotoTag(tag.substring(0,tag.length-1),favInfoID); 
    })  
	
	//�ر�
	$("#btnCancel").click(function(){
		
		//��¼�û�(�����ղ�.��ӹؼ���.�ر�)��Ϊ
	    //AddActionLog(userID,userLocID,"FavoritesView.KeyWordAdd.Close",""); 
	    
		CloseWindow();
	});
	
	//��ӱ�ǩ
	$("#btnAddTag").click(function(){
		
		//��¼�û�(�����ղ�.��ӹؼ���.�ر�)��Ϊ
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


///�ҵ��ղ�
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

//��ʼ����ǩ�б�
function initTags(data)
{
	for (var i=0;i<data.length;i++)
	{
		var tag = "<label><input type='checkbox' name='tag' id='"+data[i].id+"'/>"+data[i].text+"</label><br/>";
		$('#tags').append(tag);
	}
}

//������ǩ
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

//�����������ǩ
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
	        	$.messager.alert('��ʾ��Ϣ','���ʧ��','info');
	        }
        } 
    });	    	
}
///�����ؼ���
function addTag()
{
	var tagName = $("#txtTagName").val()
	tagName = tagName.replace(/(^\s*)|(\s*$)/g, ""); 
	if (tagName == "")
	{
		alert("��ǩ���Ʋ���Ϊ��");
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
	        	alert("���ʧ��");
	        }
        }  
    });	 	
}

//��������
function limit()
{
	var curlength = $("#txtTagName").val().length;
	if(curlength > 15)
	{
		var num = $("#txtTagName").val().substr(0,15);
		$("#txtTagName").val(num);
		alert("����15�������ƣ����������룡");
	}
}

/*window.onunload=function()
{
	//��¼�û�(�����ղ�.��ӹؼ���.ҳ��ر�)��Ϊ
    AddActionLog(userID,userLocID,"FavoritesView.KeyWordAdd.Page.Close",""); 
	
	CloseWindow();
}
//�رմ���
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
		//����showModalDialogд��
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
