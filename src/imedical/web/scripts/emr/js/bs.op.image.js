$(function () {
    $('#imageTree').tree({
        onSelect: function(node){
            $('#content').empty();
            if (node.nodetype == "commonItem")
            {
                getCommonImageItem(node.id);
            }
            else if(node.nodetype == "userItem")
            {
                getUserImageItem();
            }
        },
        onLoadSuccess: function(node, data){
            $('#content').empty();
            if ((data[0].children.length>0)&&(data[0].children[0].children.length>0))
            {
                //getCommonImageItem(data[0].children[0].children[0].id);
                var item = $('#imageTree').tree('find', data[0].children[0].children[0].id);
                $('#imageTree').tree('select', item.target);
            }
        }
    });
    getImageTreeCategory();
});

function getImageTreeCategory(){
    var args = {
        action: "GET_IMAGECATEGORY",
        params: {
            userID: userID
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data.length > 0){
            $('#imageTree').tree({data: data});
        }
    }, function (error) {
        $.messager.alert("发生错误", "getImageTreeCategory error:"+error, "error");
    }, true);
}

//获取通用图库数据
function getCommonImageItem(id)
{
    var args = {
        action: "GET_IMAGE_COMMONITEM",
        params: {
            userID: userID,
            categoryID: id
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data.length > 0){
            setImageItem(data, "common");
        }
    }, function (error) {
        $.messager.alert("发生错误", "getCommonImageItem error:"+error, "error");
    }, false);
}

//获取个人图库数据
function getUserImageItem()
{
    var args = {
        action: "GET_IMAGE_USERITEM",
        params: {
            userID: userID
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data.length > 0){
            setImageItem(data, "user");
        }
    }, function (error) {
        $.messager.alert("发生错误", "getUserImageItem error:"+error, "error");
    }, false);
}

//设置图片视图
function setImageItem(data, itemType)
{
    var content = $('<div style="width:100%;height:100%;"></div>');
    for (var i=0;i<data.length;i++)
    {
        var link = $('<li></li>');
        $(link).attr({"id":data[i].code,"text":data[i].name,"imageType":data[i].imageType});
        $(link).attr({"itemID":data[i].itemID,"itemType":itemType});
        var div = $('<div class="imagecontent"></div>');
        var imageData = "data:" + data[i].imageType + ";base64," + getImageData(data[i].code,data[i].itemID);
        var image = $('<img class="image" type="image" ondblclick=insertImage("'+data[i].itemID+'","'+imageData+'",this) />');
        $(image).attr({"id":data[i].code});
        $(image).attr({"src":imageData});
        $(div).append(image);
        var table = $('<div></div>');
        $(table).attr({"itemID":data[i].itemID,"title":data[i].name});
        $(table).append('<div class="title">' +data[i].name+ '</div>');
        var favoriteContent = '<a id="favorites" class="favorite" href="javascript:void(0)"></a>';
        var favorite = $(favoriteContent);
        if ((itemType != "common")||(data[i].favoriteFlag == 1))
        {
            $(favorite).addClass("favoritesDelete");
            $(favorite).attr({"title":emrTrans("取消收藏"),"favoriteFlag":"1"});
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

//获取图片数据
function getImageData(imageID,itemID)
{
    var result = "";
    var args = {
        action: "GET_IMAGEDATA",
        params: {
            itemID: itemID
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data.length > 0){
            result = data;
        }
    }, function (error) {
        $.messager.alert("发生错误", "getImageData error:"+error, "error");
    }, false);
    
    return result;
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

function deleteFavorite(itemID)
{
    var result = "0";
    var args = {
        action: "DELETE_USERIMAGE",
        params: {
            userID: userID,
            itemID: itemID
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data == "1"){
            result = data;
            $.messager.alert("提示", "取消收藏成功", 'info');
        }else
        {
            $.messager.alert("提示", "取消收藏失败", 'info');
        }
    }, function (error) {
        $.messager.alert("发生错误", "deleteFavorite error:"+error, "error");
    }, false);
    return result;
}

function addFavorite(itemID)
{
    var result = "0";
    var args = {
        action: "ADD_USERIMAGE",
        params: {
            userID: userID,
            itemID: itemID
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
        if (data == "1"){
            result = data;
            $.messager.alert("提示", "收藏成功", 'info');
        }else
        {
            $.messager.alert("提示", "收藏失败", 'info');
        }
    }, function (error) {
        $.messager.alert("发生错误", "addFavorite error:"+error, "error");
    }, false);
    return result;
}

function insertImage(itemID, imageData, obj)
{
    var rtn = parent.EmrEditor.syncExecute({
        action:"COMMAND",
        params:{
            media:{
                type: "image",
                url: imageData
            }
        },
        product: product
    });
    changeIMGfreq(itemID);
    parent.closeDialog("imageModal");
}

function changeIMGfreq(itemID)
{
    var args = {
        action: "UP_USERIMGFREQ",
        params: {
            userID: userID,
            itemID: itemID
        },
        product: product
    };
    ajaxGETCommon(args, function(data){
    }, function (error) {
        $.messager.alert("发生错误", "changeIMGfreq error:"+error, "error");
    }, false);
}
