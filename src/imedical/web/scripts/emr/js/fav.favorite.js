﻿var returnValue = 1; 
$(function(){
    //个人收藏夹
    getFavNavigation();
    
    $('#contentSeek').searchbox({ 
        searcher:function(value,name){
            doSearch(value);
        },
        prompt : '查询病历'
    });
    
});


//增加tab标签
function addTab(ctrlId,tabId,title,content,closable)
{
   var tt = $('#'+ctrlId);
   if (tt.tabs('exists', title))
   {
        tt.tabs('select', title);
   } 
   else 
   {  
        tt.tabs('add',{
            id:       tabId ,
            title:    title,
            content:  content,
            closable: closable
        });
   }
}

	$('#tabFavorite').tabs({
	  onBeforeClose: function(title,index){
		 var tab = $('#tabFavorite').tabs('getTab',index);
		 if (tab[0].id.indexOf("Fav") != -1)
		 {
			 AddActionLog(userId,userLocId,"FavoritesView.RecordView.Page.Close","");
		 }
		 else if (tab[0].id.indexOf("remark")!= -1)
		 {
			 AddActionLog(userId,userLocId,"FavoritesView.RecordComment.Page.Close","");
		 }
	  }
	});

//目录/////////////////////////////////////////////////////////////////////////
///我的收藏
function getFavNavigation()
{
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=GetMyNavigation&UserID="+userId, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) {
            initMyNavigation(eval(data));
        }
    });
}

//加载我的收藏
function initMyNavigation(data)
{
    $("#myNavigationTree").tree({
        data:data,
        onClick: function(node){
            $("#favInfoList").empty();
            if (node.attributes.type == "CatalogRoot")
            {
                $("#favcount").text(0);
                $("#favInfoList").empty();
            }
            else if (node.attributes.type == "Catalog")
            {
                getFavInformation(node.attributes.favUserId,node.id);
                
                //记录用户(整理收藏.我的收藏.分类查看)行为
                AddActionLog(userId,userLocId,"FavoritesView.MyTreeNode.Catalog.Click",node.text);
            }
            else if (node.attributes.type == "KeyWordRoot")
            {
                $("#favcount").text(0);
                $("#favInfoList").empty();
            }
            else if (node.attributes.type == "KeyWord")
            {
                getFavInfoByTagID(node.id);
                
                //记录用户(整理收藏.我的收藏.关键字查看)行为
                AddActionLog(userId,userLocId,"FavoritesView.MyTreeNode.KeyWord.Click",node.text);
            }
            $("#search").empty().append('<a href="#" class="selected" id="'+node.attributes.type+'">'+node.text+'</a>');
            
        },
        onContextMenu: function(e, node){
            treeRightClick(e,node);
        },
        onAfterEdit: function(node){
            updateTree(node);
        }
    });
}
//列表////////////////////////////////////////////////////////////////////////
///取收藏病例列表
function getFavInformation(favUserId,catalogId)
{
    var type = "";
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=GetFavInfoByCataLog&FavUserID="+favUserId+"&CatalogID="+catalogId+"&Type="+type, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
            setFavInformation(eval("("+data+")"),"Catalog");
        } 
    });
}

///取标签下病历
function getFavInfoByTagID(tagId)
{
    var type = "";
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=GetInfoByTag&TagID="+tagId+"&Type="+type, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
            setFavInformation(eval("("+data+")"),"KeyWord");
        }
    });
}

///加载病例列表
function setFavInformation(favdata,dirType)
{
    $("#favInfoList").empty();
    $("#favcount").text(favdata.count);
    var data = favdata.total;
    for (var i=0;i<data.length;i++)
    {
        var panel = $('<div class="favData" id="'+data[i].id+'"></div>');
        $(panel).attr({"CatalogID":data[i].CatalogID,"DirType":dirType});
        var title = '<div class="panelTitle"><span id="Name">'+data[i].Name+'</span><span id="PatientNo">'+data[i].PatientNo+'</span><div class="i-sep"></div><span id="Gender">'+data[i].Gender+'</span><div class="i-sep"></div><span id="BOD">'+data[i].BOD+'</span>';
        title = title + '<div class="tool"><a href="#" class="hisui-linkbutton" onclick="deleteInfomation('+"'"+data[i].id+"'"+')">取消收藏</a>';
        title = title + '<a href="#" class="hisui-linkbutton" onclick="openRecord('+"'"+data[i].id+"','"+data[i].EpisodeID+"','"+data[i].PatientID+"','"+data[i].Name+"'"+')">查看病历</a>';
        title = title + '<a href="#" class="hisui-linkbutton" onclick="moveTo('+"'"+data[i].id+"','"+data[i].CatalogID+"'"+')">移动病历</a></div></div>';
        $(panel).append(title);
        var memo = '<table id="tagMemo" style="width:100%;">';
        memo = memo + '<tr><td style="width:40px;text-align:right;">'+emrTrans("备注")+'</td>';
        memo = memo + '<td style="padding:0px 5px;"><textarea class="textbox" id="com">'+data[i].Memo.replace(/\\n/g,"\n")+'</textarea></td>';
        memo = memo + '<td style="width:93px;"><a href="#" class="hisui-linkbutton" id="modifymemo" onclick="modifyMemo('+"'"+data[i].id+"'"+')">修改备注</a></td>';
        memo = memo + '</tr></table>';
        $(panel).append(memo);
        
        if (dirType != "KeyWord")
        {
            var span = ""
            for (var j=0;j<data[i].Tags.length;j++)
            {
                span = span + '<a class="tag" id="'+data[i].Tags[j].TagID+'">'+data[i].Tags[j].TagName+'</a>';
            }
            var tag = '<div id="tags">';
            tag = tag + '<span>'+emrTrans("关键字")+'</span><span id="keyWord">'+span+'</span>';
            tag = tag + '<span class="icon-add" id="addkeywords" onclick="addInfoToTag('+"'"+data[i].id+"'"+')">'+emrTrans("添加关键字")+'</span></div>';
            $(panel).append(tag);
        }
        $("#favInfoList").append(panel);
        $.parser.parse('#favInfoList');
    }
    
}

//打开病历
function openRecord(id,episodeId,patientId,name)
{
    //记录用户(整理收藏.查看病历)行为
    AddActionLog(userId,userLocId,"FavoritesView.RecordView",name);

    var content = '<iframe id="framFav'+id+'" frameborder="0" src="emr.fav.recordlist.csp?FavInfoID='+id+'&EpisodeID='+episodeId+'&PatientID='+patientId+'&UserID='+userId+'&UserLocID='+userLocId+'" style="width:100%;height:100%;scrolling:no;"></iframe>'
    addTab("tabFavorite","Fav"+id,name+emrTrans(" 的病历"),content,true);
}

//取消收藏病例
function deleteInfomation(id)
{
    $.messager.confirm('取消收藏', '要取消病历收藏吗?', function(r){
        if (r)
        {
            $.ajax({ 
                type: "POST", 
                url: "../EMRservice.Ajax.favorites.cls", 
                data: "Action=DeleteFavInfomation&FavInfoID="+id, 
                error: function (XMLHttpRequest, textStatus, errorThrown) { 
                    alert(textStatus); }, 
                success: function (data) { 
                    if (data == "1")
                    {
                        $("#"+id).remove();
                    }
                    else
                    {
                        alert("取消收藏失败");
                    }
                }
            });
        }
    });
}

//修改备注信息
function modifyMemo(id)
{
    //记录用户(整理收藏.修改备注)行为
    //AddActionLog(userId,userLocId,"FavoritesView.ModifyMemo","");
    
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=ModifyInfoMemo&FavInfoID="+ id+"&Memo="+$("#com").val().replace(/\n|\r\n/g,"\\n"), 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
            if (data == "1")
            {
                $.messager.alert('提示信息','修改成功','info');
            }
            else
            {
                $.messager.alert('提示信息','修改失败','info');
            }
        } 
    });
    //记录用户(整理收藏.修改备注.确定)行为
    AddActionLog(userId,userLocId,"FavoritesView.ModifyMemo.Sure","");
}

//添加病历到标签
function addInfoToTag(id)
{
    //记录用户(整理收藏.添加关键字)行为
    AddActionLog(userId,userLocId,"FavoritesView.KeyWordAdd","");
    
    var array = {"UserID":userId,"FavInfoID":id,"UserLocID":userLocId};
    var arrayStr = base64encode(utf16to8(escape(JSON.stringify(array))));
    
	var args = {id:id,UserID:userId,UserLocID:userLocId};
	
    var iframe = '<iframe id="addInfoToTagFrame" scrolling="auto" frameborder="0" src="emr.fav.addtotag.csp?arrayStr='+arrayStr+'" style="width:100%;height:100%;display:block;"></iframe>';
    createModalDialog('addInfoToTag','添加关键字',453,410,'addInfoToTagFrame',iframe,addInfoToValue,args);
}
function addInfoToValue(returnValues,args){
		//记录用户(整理收藏.添加关键字.关闭)行为
    AddActionLog(args.UserID,args.UserLocID,"FavoritesView.KeyWordAdd.Close",""); 
	if (returnValues)
    {
        var nodes = $("#myNavigationTree").tree("getRoots");
        var favUserId = "";
        var n = "";
        for(var j = 0;j<nodes.length;j++)
        {
            if (nodes[j].attributes.type == "KeyWordRoot")
            {
                favUserId = nodes[j].id.substring(1);
                n = j;
            }
        }
        var node = $("#myNavigationTree").tree("getChildren",nodes[n].target);
        $("#favInfoList #"+args.id +" #tags #keyWord").empty();
        for(var i=0;i<returnValues.length;i++)
        {
            $("#favInfoList #"+args.id +" #tags #keyWord").append('<a class="tag" id="'+returnValues[i].id+'">'+returnValues[i].text+'</a>');
            if(node[node.length-1]!=null&&parseInt(returnValues[i].id)>parseInt(node[node.length-1].id)) {
                var json = {
                    "id":returnValues[i].id,
                    "text":returnValues[i].text,
                    attributes:{
                        "favUserId":favUserId,
                        "type":"KeyWord"
                    }
                }
                $("#myNavigationTree").tree('append',{
                    parent:nodes[n].target,
                    data:[json]
                });
            }
        }
    }else{
	return;    
	}
}

//右键菜单
function treeRightClick(e,node)
{
    if (node==null)
    {
        return;
    }
    $('#mm').menu('disableItem',$("#addCatalog")[0]);
    $('#mm').menu('disableItem',$("#addTag")[0]);
    $('#mm').menu('disableItem',$("#modityName")[0]);
    $('#mm').menu('disableItem',$("#delCatalog")[0]);
    $('#mm').menu('disableItem',$("#delTag")[0]);
    if (node.attributes.type=="CatalogRoot")
    {
        $('#mm').menu('enableItem',$("#addCatalog")[0]);
    }
    else if(node.attributes.type=="Catalog")
    {
        $('#mm').menu('enableItem',$("#modityName")[0]);
        $('#mm').menu('enableItem',$("#addCatalog")[0]);
        if ($("#myNavigationTree").tree("isLeaf",node.target)) $('#mm').menu('enableItem',$("#delCatalog")[0]);
    }
    else if (node.attributes.type=="KeyWordRoot")
    {
        $('#mm').menu('enableItem',$("#addTag")[0]);
    }
    else
    {
        $('#mm').menu('enableItem',$("#modityName")[0]);
        $('#mm').menu('enableItem',$("#delTag")[0]);
    }
    e.preventDefault();
    $('#myNavigationTree').tree('select', node.target);
    $('#mm').menu('show', {left: e.pageX, top: e.pageY});
}



//移动病历到目录
function moveTo(id,catalogId)
{
    //记录用户(整理收藏.移动病历)行为
    AddActionLog(userId,userLocId,"FavoritesView.ModifyPosition","");
    
    var array = {"FavUserID":favUserId,"FavInfoID":id,"UserID":userId,"UserLocID":userLocId};
    var arrayStr = base64encode(utf16to8(escape(JSON.stringify(array))));
    var iframe = '<iframe id="movetocatalogFrame" scrolling="auto" frameborder="0" src="emr.fav.movetocatalog.csp?arrayStr='+arrayStr+'" style="width:100%;height:100%;display:block;"></iframe>';
    var args = {
	    id:id,
	    catalogId:catalogId,
		userId:userId,
		userLocId:userLocId
	    }
    createModalDialog('movetocatalog','移动病历',360,360,'movetocatalogFrame',iframe,removeInfo,args);
}
//移除界面病历内容
function removeInfo(returnValue,args)
{
	    //记录用户(整理收藏.移动病历.页面确定)行为，在子页面中调用会报error
    if ( $.isEmptyObject(returnValue))
    	{AddActionLog(args.userId,args.userLocId,"FavoritesView.ModifyPosition.Close","");
    	return;}
    if(returnValue.logtype.indexOf("Close")==-1)
    	AddActionLog(args.userId,args.userLocId,returnValue.logtype,"");
    AddActionLog(args.userId,args.userLocId,"FavoritesView.ModifyPosition.Close",""); 
	if (returnValue.id==undefined||(args.catalogId == returnValue.id))
	return;
	var count = $("#favcount").text()-1;
	$("#favcount").text(count);
	$("#favInfoList #"+args.id).remove();
}

//创建目录
$("#addCatalog").click(function(){

    //记录用户(整理收藏.我的收藏.新建目录)行为
    AddActionLog(userId,userLocId,"FavoritesView.MyTreeNode.Catalog.New","");  	

    var node = $("#myNavigationTree").tree("getSelected");
    if (node.attributes.type != "CatalogRoot" && node.attributes.type != "Catalog")
    {
        return;
    }
    $.messager.prompt('在' + node.text + '中创建目录', '请输入目录名称', function (r)
    {
        if (r)
        {
            addCatalog(node, r);
        }
    });
});

//增加目录
function addCatalog(node,catalogName)
{
    var parentId = 0;favUserId = "";
    if (node.attributes.type == "CatalogRoot")
    {
        favUserId = node.id.substring(1);
    }
    else
    {
        parentId = node.id;
        favUserId = node.attributes.favUserId;
    }
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=AddCatalog&ParentID="+parentId+"&FavUserID="+favUserId+"&CatalogName="+catalogName, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
            if (data != "0") {
                var json = 
                {
                    "id" : data,
                    "text" : catalogName,
                    attributes : {
                        "parent" : parentId,
                        "favUserId" : favUserId,
                        "type" : "Catalog"
                    }
                }
                $('#myNavigationTree').tree('append', {
                        parent: (node?node.target:null),
                        data: [json]
                });
            }
        }
    });
}

//创建标签
$("#addTag").click(function(){
    
    //记录用户(整理收藏.我的收藏.新建关键字)行为
    AddActionLog(userId,userLocId,"FavoritesView.MyTreeNode.KeyWord.New","");
    
    var node = $("#myNavigationTree").tree("getSelected");
    if (node.attributes.type != "KeyWordRoot" && node.attributes.type != "KeyWord")
    {
        return;
    }
    $.messager.prompt('在'+node.text+'中创建标签', '请输入标签名称', function(r){
        if (r){
            addTag(node,r);
        }
    });
});

//增加标签
function addTag(node,tagName)
{
    var favUserId = "";
    if (node.attributes.type == "KeyWordRoot")
    {
        favUserId = node.id.substring(1);
    }
    if (favUserId == "")
    {
        return;
    }
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=AddTag&FavUserID="+favUserId+"&TagName="+tagName, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
            var newNode = "";
            if (data != "0")
            {
                newNode = 
                {
                    "id" : data,
                    "text" : tagName,
                    attributes :{
                        "favUserId" : favUserId,
                        "type" : "KeyWord"
                    }
                }
                $('#myNavigationTree').tree('append', {
                        parent: (node?node.target:null),
                        data: [newNode]
                });
            }
        } 
    });
}

//删除标签
$("#delTag").click(function(){
    var node = $("#myNavigationTree").tree("getSelected");
    if (node.attributes.type != "KeyWord") return;
    var returnData = false,text = "";
    //删除标签中是否含有收藏的病历
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=GetInfoByTag&TagID="+node.id+"&Type="+false, 
        async:false,
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
            if (eval("("+data+")").count != 0) returnData = true;
        } 
    });
    if (returnData){
        text='该关键字包含收藏的病历,是否确定删除关键字【' + node.text + '】?';
    }else{
        text='是否确定删除关键字【' + node.text + '】?';
    }
    $.messager.defaults = { ok: "是", cancel: "否" };
    $.messager.confirm('删除关键字提示',text,function(data){
        if (data){
            delTag(node, returnData);
        }
    });
});
//删除标签节点
function delTag(node, flag){
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=DelTag&RowID="+node.id,
        async:false, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) {
            if (data != "0") {
                $("#myNavigationTree").tree("remove",node.target);
                if (flag) {
                    $("#favInfoList #tags #keyWord .tag[id="+node.id+"]").each(function(i) {
                        $(this).remove();
                    });
                }
            }
        }
    });
    //记录用户(整理收藏.我的收藏.新建关键字)行为
    AddActionLog(userId,userLocId,"FavoritesView.MyTreeNode."+node.text+".Del","");
}

//删除目录
$("#delCatalog").click(function(){
    var node = $("#myNavigationTree").tree("getSelected");
    if (node.attributes.type != "Catalog") return;
    var returnData = false,text = "";
    //删除目录中是否含有收藏的病历
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=GetFavInfoByCataLog&FavUserID="+node.attributes.favUserId+"&CatalogID="+node.id+"&Type="+false, 
        async:false,
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
            if (eval("("+data+")").count != 0) returnData = true;
        } 
    });
    if (returnData){
        text='该目录包含收藏的病历,是否确定删除【' + node.text + '】?';
    }else{
        text='是否确定删除' + node.text + '?';
    }
    $.messager.defaults = { ok: "是", cancel: "否" };
    $.messager.confirm('删除目录提示',text,function(data){
        if (data){
            delCatalog(node, returnData);
        }
    });
});
//删除目录节点
function delCatalog(node, flag){
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=DelCatalog&RowID="+node.id,
        async:false, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) {
            if (data != "0") {
                $("#myNavigationTree").tree("remove",node.target);
                if (flag) {
                    var count = $("#favcount").text();
                    $("#favInfoList .favData[CatalogID="+node.id+"]").each(function(i) {
                        $(this).remove();
                        count = count - 1;
                    });
                    $("#favcount").text(count);
                }
            }
        }
    });
    //记录用户(整理收藏.我的收藏.删除目录)行为
    AddActionLog(userId,userLocId,"FavoritesView.MyTreeNode.Catalog."+node.text+".Del","");
}

///重命名节点
$("#modityName").click(function(){
    var node = $('#myNavigationTree').tree('getSelected')
    $('#myNavigationTree').tree('beginEdit',node.target);
});
///更新树节点
function updateTree(node)
{
    var id = node.id;
    var name = node.text;
    var type = node.attributes.type;
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=UpdateCatalogTagName&ID="+id+"&Name="+name+"&Type="+type, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
            if (data == "0") alert("重命名失败");
        } 
    });
    
    //记录用户(整理收藏.我的收藏.目录重命名)行为
    AddActionLog(userId,userLocId,"FavoritesView.MyTreeNode."+type+".ReName","");
}

///信息检索
function doSearch(value){
    var id = $("#search a").attr("id");
    
    //检索所有
    if ((id == "all")||(id == "CatalogRoot")||(id == "KeyWordRoot"))
    {
        selectAll(value,id);
    }
    //从当前页面中检索
    else
    {
        selectPresent(value);
    }
    
    //记录用户(整理收藏.查找病例)行为
    AddActionLog(userId,userLocId,"FavoritesView.Search","");
}

///检索当前
function selectPresent(value)
{
    $("#favInfoList div.favData").hide();
    var $d = $("#favInfoList div.favData").filter(":contains('"+$.trim(value)+"')");
    $("#favcount").text($d.length);
    $d.show();
}

///检索所有
function selectAll(value,Location)
{
    $.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=SelectInfo&Value="+value+"&Location="+Location, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
            if(Location == "KeyWordRoot")
            {
                var favdata = eval("("+data+")");
                $("#favInfoList").empty();
                if(favdata.count == 0)
                {
                    $("#favcount").text(0);
                    alert("请输入关键字进行搜索！");
                }else
                {
                    setFavInformation(favdata,false,"Catalog");
                }
            }else
            {
                var favdata = eval("("+data+")");
                $("#favInfoList").empty();
                if(favdata.count == 0)
                {
                    $("#favcount").text(0);
                    alert("没有找到相关病历，请重新进行搜索！");
                }else
                {
                    setFavInformation(favdata,false,"Catalog");
                }
            }
        }
    });
}
//导出收藏列表到word
function exportWord(){
    //记录用户(整理收藏.导出收藏列表到word)行为
    AddActionLog(userId,userLocId,"FavoritesView.ExprotToWord","");
    exportToWord("favInfoList");

}

//导出收藏列表到Excel
function exportExcel(){
    //记录用户(整理收藏.导出收藏列表到Excel)行为
    AddActionLog(userId,userLocId,"FavoritesView.ExprotToExcel",""); 
    exportToExcel("favInfoList");
}
/*
//页面关闭
window.onunload=function()
{
    //记录用户(整理收藏.页面关闭)行为
    AddActionLog(userId,userLocId,"FavoritesView.Page.Close","");
}
*/
