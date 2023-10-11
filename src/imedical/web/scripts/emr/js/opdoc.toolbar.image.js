$(function(){
    initCategory();
});

function initCategory()
{
    var data = ajaxDATA("Stream", "EMRservice.BL.Image.BLImage", "GetCategory", userID);
    ajaxGET(data, function (d) {
        if (d != "")
        {
            setCategory(eval("["+d+"]"));
        }
    }, function (ret) {
        $.messager.alert("发生错误", "GetCategory error:" + ret, "error");
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
    var data = ajaxDATA("Stream", "EMRservice.BL.Image.BLImage", "getCommonImageItem", categoryID, userID);
    ajaxGETSync(data, function (d) {
        if (d != "[]")
        {
            setCommonImageItem(eval("("+d+")"));
        }
    }, function (ret) {
        $.messager.alert("发生错误", "getCommonImageItem error:" + ret, "error");
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
            $(favorite).attr({"title":emrTrans("取消收藏")});
            $(link).attr({"favoriteFlag":"1"});
        }
        else
        {
            $(favorite).addClass("favoritesPlus");
            $(favorite).attr({"title":emrTrans("收藏")});
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
    var data = ajaxDATA("Stream", "EMRservice.BL.Image.BLImage", "GetImageData", itemID);
    ajaxGETSync(data, function (d) {
        if (d != "[]")
        {
            result = d;
        }
    }, function (ret) {
        $.messager.alert("发生错误", "GetImageData error:" + ret, "error");
    });
    return result;
}

//获取个人图库数据
function getUserImageItem(userID)
{
    $('#content').empty();
    var data = ajaxDATA("Stream", "EMRservice.BL.Image.BLImage", "getUserImageItem", userID);
    ajaxGETSync(data, function (d) {
        if (d != "[]")
        {
            setUserImageItem(eval("("+d+")"));
        }
    }, function (ret) {
        $.messager.alert("发生错误", "getUserImageItem error:" + ret, "error");
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
        $(favorite).attr({"title":emrTrans("取消收藏"),"favoriteFlag":"1"});
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
    var result = "0";
    var data = ajaxDATA("String", "EMRservice.BL.Image.BLImage", "AddUserImage", itemID, userID);
    ajaxGETSync(data, function (d) {
        if (d == "1")
        {
            $.messager.alert("提示", "收藏成功", 'info');
            result = "1";
        }
        else
        {
            $.messager.alert("提示", "收藏失败", 'info');
        }
    }, function (ret) {
        $.messager.alert("发生错误", "AddUserImage error:" + ret, "error");
    });
    return result;
}

function deleteFavorite(itemID)
{
    var result = "0";
    var data = ajaxDATA("String", "EMRservice.BL.Image.BLImage", "DeleteUserImage", itemID, userID);
    ajaxGETSync(data, function (d) {
        if (d == "1")
        {
            $.messager.alert("提示", "取消收藏成功", 'info');
            result = "1";
        }
        else
        {
            $.messager.alert("提示", "取消收藏失败", 'info');
        }
    }, function (ret) {
        $.messager.alert("发生错误", "DeleteUserImage error:" + ret, "error");
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
    var data = ajaxDATA("String", "EMRservice.BL.Image.BLImage", "changeUserIMGfreq", userID, imageId);
    ajaxGETSync(data, function (d) {
    }, function (ret) {
        $.messager.alert("发生错误", "changeUserIMGfreq error:" + ret, "error");
    });
}

//关闭窗口
function closeWindow() {
    parent.closeDialog("dialogImage");
}