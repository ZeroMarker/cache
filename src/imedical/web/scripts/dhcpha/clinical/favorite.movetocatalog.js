window.returnValue={}
$(function(){
	if (arrayStr != "")
    {
	   var opts = JSON.parse(unescape(utf8to16(base64decode(arrayStr))));
	   favUserId = opts.FavUserID;
       favInfoId = opts.FavInfoID;
       userId = opts.UserID;
       userLocId =opts.UserLocID;
    }

    initCatalogTree();
    $("#sure").click(function(){
            
        //��¼�û�(�����ղ�.��ӹؼ���.ҳ��ر�)��Ϊ
        //AddActionLog(userId,userLocId,"FavoritesView.ModifyPosition.Sure",""); 
		window.returnValue["logtype"] = "FavoritesView.ModifyPosition.Sure";
        ModifyInfoCatalog();
    });

    $("#close").click(function(){
        
        //��¼�û�(�����ղ�.�ƶ�����.�ر�)��Ϊ
        //AddActionLog(userId,userLocId,"FavoritesView.ModifyPosition.Close",""); 
    	window.returnValue["logtype"] = "FavoritesView.ModifyPosition.Close";
        CloseWindow();
    });

});

///�ҵ��ղ�
function initCatalogTree()
{	
    $('#calalog').tree({  
    	url:"../web.DHCCM.EMRservice.Ajax.favorites.cls?Action=GetFavCatalog&FavUserID="+favUserId 
	}); 
}

//�����޸�Ŀ¼
function ModifyInfoCatalog()
{
	var nodes = $('#calalog').tree('getSelected');	
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=ModifyInfoCatalog&FavInfoID="+favInfoId+"&CatalogID="+nodes.id, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); }, 
        success: function (data) { 
        	if (data == "1")
        	{
	        	window.returnValue["id"]= nodes.id;
	        	CloseWindow();
	        }
	        else
	        {
		        alert("�ƶ�ʧ��");
		    }
        } 
    });    
}
function CloseWindow(){
	var id = "movetocatalog" ; 
	parent.closeDialog(id);
	}

/*
window.onunload=function()
{
    //��¼�û�(�����ղ�.�ƶ�����.ҳ��ȷ��)��Ϊ
    AddActionLog(userId,userLocId,"FavoritesView.ModifyPosition.Page.Close",""); 
}
*/
