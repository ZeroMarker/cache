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
            
        //记录用户(整理收藏.添加关键字.页面关闭)行为
        //AddActionLog(userId,userLocId,"FavoritesView.ModifyPosition.Sure",""); 
		window.returnValue["logtype"] = "FavoritesView.ModifyPosition.Sure";
        ModifyInfoCatalog();
    });

    $("#close").click(function(){
        
        //记录用户(整理收藏.移动病历.关闭)行为
        //AddActionLog(userId,userLocId,"FavoritesView.ModifyPosition.Close",""); 
    	window.returnValue["logtype"] = "FavoritesView.ModifyPosition.Close";
        CloseWindow();
    });

});

///我的收藏
function initCatalogTree()
{	
    $('#calalog').tree({  
    	url:"../web.DHCCM.EMRservice.Ajax.favorites.cls?Action=GetFavCatalog&FavUserID="+favUserId 
	}); 
}

//保存修改目录
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
		        alert("移动失败");
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
    //记录用户(整理收藏.移动病历.页面确定)行为
    AddActionLog(userId,userLocId,"FavoritesView.ModifyPosition.Page.Close",""); 
}
*/
