﻿$(function(){
	initCatalogTree();
	window.returnValue ="";
	$("#sure").click(function(){
			
		//记录用户(整理收藏.添加关键字.页面关闭)行为
    	AddActionLog(userId,userLocId,"FavoritesView.ModifyPosition.Sure",""); 

		ModifyInfoCatalog();
	});

	$("#close").click(function(){
		
		//记录用户(整理收藏.移动病历.关闭)行为
    	AddActionLog(userId,userLocId,"FavoritesView.ModifyPosition.Close",""); 
	
		CloseWindow();
	});

});

///我的收藏
function initCatalogTree()
{	
    $('#calalog').tree({  
    	url:"../EMRservice.Ajax.favorites.cls?Action=GetFavCatalog&FavUserID="+favUserId 
	}); 
}

//保存修改目录
function ModifyInfoCatalog()
{
	var nodes = $('#calalog').tree('getSelected');	
	$.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=ModifyInfoCatalog&FavInfoID="+favInfoId+"&CatalogID="+nodes.id, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); }, 
        success: function (data) { 
        	if (data == "1")
        	{
	        	window.returnValue = nodes.id;
	        	CloseWindow();
	        }
	        else
	        {
		        alert("移动失败");
		    }
        } 
    });    
}

//关闭窗口
function CloseWindow()
{
	window.opener=null;
	window.open('','_self');
	window.close();	
}

window.onunload=function()
{
	//记录用户(整理收藏.移动病历.页面确定)行为
    AddActionLog(userId,userLocId,"FavoritesView.ModifyPosition.Page.Close",""); 
}
