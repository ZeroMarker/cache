$(function(){
	window.returnValue = "";
	loadCommonImagePage();
	loadUserImagePage();	
});

//增加tab标签
function addTab(ctrlId,tabId,tabTitle,content,closable,selected)
{
	$('#'+ctrlId).tabs('add',{
	    id:       	tabId ,
		title:    	tabTitle,
		content:  	content,
		closable: 	closable,
		selected: 	selected
   });	 
}

//加载通用图库页签
function loadCommonImagePage()
{
	var content = $('<div id="commonImageContent" class="easyui-tabs" data-options="fit:true,border:false"  style="width:100%;height:100%;"></div>');
	addTab("content","commonImage","通用",content,false,true);	
	getCategory(0);	    
}

//加载个人图库页签
function loadUserImagePage()
{
	var content = $('<div id="userImageContent"  style="width:100%;height:100%;"></div>');
	$(content).attr("class","display");
	if (userID != "")
	{
		var result = getUserImageItem(userID);
		$(content).append(result);
	}
	addTab("content","userImage","个人",content,false,false);
			    
}

//获取图库目录
function getCategory(categoryID)
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : true,
			data : {
					"OutputType":"Stream",
					"Class":"EMRservice.BL.Image.BLImage",
					"Method":"GetCategoryNodes",			
					"p1":categoryID
				},
			success : function(d) {
	           		if (d != "[]")
	           		{
	           			setFirstCategory(eval("("+d+")"));
	           		}
			},
			error : function(d) { alert("getCategory error");}
		});	
}

function setFirstCategory(data)
{
	var xpheight=window.screen.height-150;
	for (var i=0;i<data.length;i++)
	{
		if ( i == 0 )
		{
			var select = true;
		}
		else
		{
			var select = false;
		}
		var content = $('<div class="easyui-tabs" data-options="fit:true,border:false" style="height:'+xpheight+'px;"></div>');
		$(content).attr("id",data[i].code+"Content");
		$(content).attr("data-options", "tabPosition:'left'");				
		addTab("commonImageContent",data[i].code,data[i].name,content,false,select);
		
	}
}

//获取二级图库目录
function getCommonCategory(parentCode)
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"Stream",
					"Class":"EMRservice.BL.Image.BLImage",
					"Method":"GetCategoryByParentCode",			
					"p1":parentCode
				},
			success : function(d) {
	           		if (d != "[]")
	           		{
	           			setCommonCategory(parentCode,eval("("+d+")"));
	           		}
			},
			error : function(d) { alert("getCategory error");}
		});	
}

function setCommonCategory(parentCode,data)
{
	for (var i=0;i<data.length;i++)
	{
		var content = $('<div style="width:100%;height:100%;"></div>');
		$(content).attr("id",data[i].code+"Content");
		$(content).attr("class","display");
		if ( i == 0 )
		{
			var select = true;
		}
		else
		{
			var select = false;
		}				
		var result = getCommonImageItem(data[i].code+"Content",data[i].categoryID);
		$(content).append(result);
		addTab(parentCode+"Content",data[i].code,data[i].name,content,false,select);
	}
}

//获取通用图库数据
function getCommonImageItem(contentID,categoryID)
{
	var result = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"Stream",
					"Class":"EMRservice.BL.Image.BLImage",
					"Method":"getCommonImageItem",			
					"p1":categoryID
				},
			success : function(d) {
	           		if (d != "[]")
	           		{
	           			result = setCommonImageItem(contentID,eval("("+d+")"));
	           		}
			},
			error : function(d) { alert("getCommonImageItem error");}
		});	
	return result;
}


///设置图片视图
function setCommonImageItem(contentID,data)
{
	var content = $('<div style="width:100%;height:100%;"></div>');
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li></li>');
		$(link).attr({"id":data[i].code,"text":data[i].name,"imageType":data[i].imageType});
		
		var div = $('<div class="imagecontent"></div>');
		var imagedata = "data:" + data[i].imageType + ";base64," + getImageData(data[i].code,data[i].itemID);
		var image = $('<img class="image" type="image" ondblclick=insertImage("'+data[i].imageType+'","'+data[i].itemID+'") />');
		$(image).attr({"id":data[i].code});
		$(image).attr({"src":imagedata});
		$(div).append(image);
		var table = $('<div></div>');
		$(table).attr({"itemID":data[i].itemID});
		$(table).append('<div class="title" style="float:left;width:80px;text-overflow:ellipsis;overflow:hidden;height:25px;line-height:25px;color:#ffffff;width:80px;">' +data[i].name+ '</div>');
		$(table).attr("title",data[i].name);
		var favorite = $('<a id="favoritesPlus" href="javascript:void(0)" onclick="addFavorite('+data[i].itemID+')" style="border:none;color:#ffffff;background-color:#57B382;height:25px;width:50px;float:right;line-height:25px;color:#ffffff;display:block;" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;收藏</a>');
		$(table).append(favorite);
		$(div).append(table);
		$(link).append(div);
		$(content).append(link);
	}
	return content;
}


//获取图片数据
function getImageData(imageID,itemID)
{
	var result = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"Stream",
					"Class":"EMRservice.BL.Image.BLImage",
					"Method":"GetImageData",			
					"p1":itemID
				},
			success : function(d) {
	           		if (d != "[]")
	           		{
						result = d; 
	           		}
			},
			error : function(d) { alert("getImageData error");}
		});	
		return result;
}

//获取个人图库数据
function getUserImageItem(userID)
{
	var result = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"Stream",
					"Class":"EMRservice.BL.Image.BLImage",
					"Method":"getUserImageItem",			
					"p1":userID
				},
			success : function(d) {
	           		if (d != "[]")
	           		{
	           			result = setUserImageItem(eval("("+d+")"));
	           		}
			},
			error : function(d) { alert("getUserImageItem error");}
		});	
	return result;
}

///设置个人图片视图
function setUserImageItem(data)
{
	var content = $('<div style="width:100%;height:100%;"></div>');
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li></li>');
		$(link).attr({"id":data[i].code,"text":data[i].name,"imageType":data[i].imageType});
		
		var imagedata = "data:" + data[i].imageType + ";base64," + getImageData(data[i].code,data[i].itemID);
		var div = $('<div class="imagecontent"></div>');
		var image = $('<img class="image" type="image" ondblclick=insertImage("'+data[i].imageType+'","'+data[i].itemID+'") />');
		$(image).attr({"id":data[i].code});
		$(image).attr({"src":imagedata});
		$(div).append(image);
		var table = $('<div></div>');
		$(table).attr({"itemID":data[i].itemID});
		$(table).append('<div class="title" style="background-color:#57B382;width:130px;text-overflow:ellipsis;overflow:hidden;height:25px;line-height:25px;color:#ffffff;">' +data[i].name+ '</div>');
		$(table).attr("title",data[i].name);
		$(div).append(table);
		$(link).append(div);
		$(content).append(link);
	}
	return content;
}

function initCommonCategory()
{
	var tabs = $('#commonImageContent').tabs('tabs');
	if (tabs.length>0)
	{
		$('#commonImageContent').tabs('select', 0);
	}
}

$(function(){
	$('#commonImageContent').tabs({
        onSelect:function(title,index){
	    	var tab = $('#commonImageContent').tabs('getTab',index);
		    var id = tab[0].id;
		    var childTab = $('#'+id+'Content').tabs('tabs');
		    if (childTab.length == 0)
			{ 
	    		getCommonCategory(id);
			}
        }
	});	
	$('#content').tabs({
        onSelect: function (title) {
            var currTab = $('#content').tabs('getTab', title);
            if (title == "个人")
            {
	            var content = $('<div id="userImageContent"></div>');
				$(content).attr("class","display");
				if (userID != "")
				{
					var result = getUserImageItem(userID);
					$(content).append(result);
				}
	            $('#content').tabs('update', { tab: currTab, options: { content: content} });
            }
        }
    });
});

function addFavorite(itemID)
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.Image.BLImage",
					"Method":"AddUserImage",			
					"p1":itemID,
					"p2":userID
				},
			success : function(d) {
	           		if (d == "1")
	           		{
	           			alert("收藏成功");
	           		}
	           		else
	           		{
		           		alert("收藏失败");
	           		}
			},
			error : function(d) { alert("addFavorite error");}
		});	
}

function insertImage(imageType,imageId)
{
	window.returnValue = {"ImageType":imageType,"ImageId":imageId}
	closeWindow();
}

//关闭窗口
function closeWindow() {
    window.opener = null;
    window.open('', '_self');
    window.close();
}