$(function(){
	returnValue = "";
	initCategory();	
});

function initCategory()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.Image.BLImage",
			"Method":"GetCategory",
			"p1":userID
		},
		success: function(d) {
			if (d != "")
			{
				setCategory(eval("["+d+"]"));
			}
		},
		error : function(d) { alert("GetInstance error");}
	});	
}

function setCategory(data)
{
	$('#ImageTree').tree({
		data:data,
		onClick: function(node){
			if (node.nodetype == "commonItem")
			{
				getCommonImageItem(node.categoryID);
			}
			else if(node.nodetype == "userItem")
			{
				getUserImageItem(userID);
			}
		},
		onLoadSuccess: function(node, data){
			$('#content').empty();
			if ((data[0].children.length>0)&&(data[0].children[0].children.length>0))
			{
				getCommonImageItem(data[0].children[0].children[0].categoryID);
				var item = $('#ImageTree').tree('find', data[0].children[0].children[0].id);
				$('#ImageTree').tree('select', item.target);
			}
		}
	});	
}

//获取通用图库数据
function getCommonImageItem(categoryID)
{
	$('#content').empty();
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"Stream",
					"Class":"EMRservice.BL.Image.BLImage",
					"Method":"getCommonImageItem",			
					"p1":categoryID,
					"p2":userID
				},
			success : function(d) {
	           		if (d != "[]")
	           		{
	           			setCommonImageItem(eval("("+d+")"));
	           		}
			},
			error : function(d) { alert("getCommonImageItem error");}
		});	
}


///设置图片视图
function setCommonImageItem(data)
{
	var content = $('<div style="width:100%;height:100%;"></div>');
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li></li>');
		$(link).attr({"id":data[i].code,"text":data[i].name,"imageType":data[i].imageType});
		$(link).attr({"itemID":data[i].itemID,"itemType":"common"});
		var div = $('<div class="imagecontent"></div>');
		var imagedata = "data:" + data[i].imageType + ";base64," + getImageData(data[i].code,data[i].itemID);
		var image = $('<img class="image" type="image" ondblclick=insertImage("'+data[i].imageType+'","'+data[i].itemID+'") />');
		$(image).attr({"id":data[i].code});
		$(image).attr({"src":imagedata});
		$(div).append(image);
		var table = $('<div></div>');
		$(table).attr({"itemID":data[i].itemID});
		$(table).append('<div class="title">' +data[i].name+ '</div>');
		$(table).attr("title",data[i].name);
		var favoriteContent = '<a id="favorites" class="favorite" href="javascript:void(0)"></a>'
		var favorite = $(favoriteContent);
		if (data[i].favoriteFlag == 1)
		{
			$(favorite).addClass("favoritesDelete");
			$(favorite).attr({"title":"取消收藏"});
			$(link).attr({"favoriteFlag":"1"});
		}
		else
		{
			$(favorite).addClass("favoritesPlus");
			$(favorite).attr({"title":"收藏"});
			$(link).attr({"favoriteFlag":"0"});
		}
		$(table).append(favorite);
		$(div).append(table);
		$(link).append(div);
		$(content).append(link);
	}
	$('#content').append(content);
}

$(document).on("click",".favorite",function(){
	var obj = $(this).closest("li");
	var itemID = obj.attr("itemID");
	if (obj.attr("favoriteFlag") == "1")
	{
		if (deleteFavorite(itemID) == "1")
		{
			$(this).removeClass("favoritesDelete");
			$(this).addClass("favoritesPlus");
			$(obj).attr({"favoriteFlag":"0"});
			if (obj.attr("itemType") == "user")
			{
				$(obj).remove();
			}
		}
	}
	else
	{
		if (result = addFavorite(itemID) == "1")
		{
			$(this).removeClass("favoritesPlus");
			$(this).addClass("favoritesDelete");
			$(obj).attr({"favoriteFlag":"1"});
		}
	}
});

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
	$('#content').empty();
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
	           			setUserImageItem(eval("("+d+")"));
	           		}
			},
			error : function(d) { alert("getUserImageItem error");}
		});	
}

///设置个人图片视图
function setUserImageItem(data)
{
	var content = $('<div style="width:100%;height:100%;"></div>');
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li></li>');
		$(link).attr({"id":data[i].code,"text":data[i].name,"imageType":data[i].imageType});
		$(link).attr({"itemID":data[i].itemID,"itemType":"user"});
		var imagedata = "data:" + data[i].imageType + ";base64," + getImageData(data[i].code,data[i].itemID);
		var div = $('<div class="imagecontent"></div>');
		var image = $('<img class="image" type="image" ondblclick=insertImage("'+data[i].imageType+'","'+data[i].itemID+'") />');
		$(image).attr({"id":data[i].code});
		$(image).attr({"src":imagedata});
		$(div).append(image);
		var table = $('<div></div>');
		$(table).attr({"itemID":data[i].itemID});
		$(table).append('<div class="title">' +data[i].name+ '</div>');
		$(table).attr("title",data[i].name);
		var favoriteContent = '<a id="favorites" class="favorite" href="javascript:void(0)"></a>'
		var favorite = $(favoriteContent);
		$(favorite).addClass("favoritesDelete");
		$(favorite).attr({"title":"取消收藏","favoriteFlag":"1"});
		$(link).attr({"favoriteFlag":"1"});
		$(table).append(favorite);
		$(div).append(table);
		$(link).append(div);
		$(content).append(link);
	}
	$('#content').append(content);
}

function addFavorite(itemID)
{
	var result = "0"
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
	           			$.messager.alert("提示", "收藏成功", 'info');
	           			result = "1";
	           		}
	           		else
	           		{
		           		$.messager.alert("提示", "收藏失败", 'info');
	           		}
			},
			error : function(d) { alert("addFavorite error");}
		});	
	return result;
}

function deleteFavorite(itemID)
{
	var result = "0"
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.Image.BLImage",
					"Method":"DeleteUserImage",			
					"p1":itemID,
					"p2":userID
				},
			success : function(d) {
	           		if (d == "1")
	           		{
	           			$.messager.alert("提示", "取消收藏成功", 'info');
	           			result = "1";
	           		}
	           		else
	           		{
		           		$.messager.alert("提示", "取消收藏失败", 'info');
	           		}
			},
			error : function(d) { alert("addFavorite error");}
		});	
	return result;
}

function insertImage(imageType,imageId)
{
	returnValue = {"ImageType":imageType,"ImageId":imageId};
	changeIMGfreq(imageId);
	closeWindow();
}

function changeIMGfreq(imageId)
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.Image.BLImage",
					"Method":"changeUserIMGfreq",			
					"p1":userID,
					"p2":imageId
				},
			success : function(d) {
			},
			error : function(d) { alert("changeIMGfreq error");}
		});	
}

//关闭窗口
function closeWindow() {
	parent.closeDialog("dialogImage");
}