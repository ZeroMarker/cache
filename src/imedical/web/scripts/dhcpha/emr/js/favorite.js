﻿$(function(){
	if($.browser.version == '11.0')
	{
		$('#selectcss').attr("href","../scripts/emr/css/favorite-IE11.css");
	}
	//个人收藏夹
	getFavNavigation();
	
	$('#contentSeek').click(function(){
		var val = document.getElementById("content").value
		doSearch(val);
	});
	
	$("#serach .selected").live('click',function(){
		$(this).remove();
		$("#serach").append('<a href="#" class="all" id="all">所有病历</a>');
		$("#favcount").text(0);
		$("#favInfoList").empty();
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
            data = data.replace(/<.*?>/g, "");
            data = data.replace(/text/g, "name");
        	initMyNavigation(eval(data));
        } 
    });	
}

//ztree显示、回调函数、数据格式配置
var ztSetting =
{
    view :
    {
        showIcon : false
    },
    callback :
    {
        onClick : ztOnClick,
        onRightClick : ztOnRightClick,
		//重命名后更新树
        onRename: updateTree
    },
    data :
    {
        simpleData :
        {
            enable : false
        }
    }
};

//ztree鼠标左键点击回调函数
function ztOnClick(event, treeId, treeNode)
{
    $("#favInfoList").empty();
    if (treeNode.attributes.type == "CatalogRoot")
    {
	    $("#favcount").text(0);
	    $("#favInfoList").empty();
	}
	else if (treeNode.attributes.type == "Catalog")
    {
        getFavInformation(treeNode.attributes.favUserId, treeNode.id, false);

        //记录用户(整理收藏.我的收藏.分类查看)行为
        AddActionLog(userId, userLocId, "FavoritesView.MyTreeNode.Catalog.Click", treeNode.name);
    }
    else if (treeNode.attributes.type == "KeyWordRoot")
    {
	    $("#favcount").text(0);
	    $("#favInfoList").empty();
	}
	else if (treeNode.attributes.type == "KeyWord")
    {
        getFavInfoByTagID(treeNode.id, false);

        //记录用户(整理收藏.我的收藏.关键字查看)行为
        AddActionLog(userId, userLocId, "FavoritesView.MyTreeNode.KeyWord.Click", treeNode.name);
    }
    $("#serach").empty().append('<A href="#" class="selected" id="'+treeNode.attributes.type+'">'+treeNode.name+'</A>');
};

//ztree鼠标右键点击回调函数
function ztOnRightClick(event, treeId, treeNode)
{
	if (treeNode==null)
	{
		return;
	}
	$("#delCatalog").hide();
    if (treeNode.attributes.type == "CatalogRoot")
    {
        $("#addTag").hide();
        $("#modityName").hide();
        $("#addCatalog").show();
    }
    else if (treeNode.attributes.type == "Catalog")
    {
        $("#addTag").hide();
        $("#modityName").show();
        $("#addCatalog").show();
        if (!treeNode.isParent) $("#delCatalog").show();
    }
    else if (treeNode.attributes.type == "KeyWordRoot")
    {
        $("#addCatalog").hide();
        $("#modityName").hide();
        $("#addTag").show();
    }
    else
    {
        $("#addTag").hide();
        $("#addCatalog").hide();
        $("#modityName").show();
    }
    event.preventDefault();
    var treeObj = $.fn.zTree.getZTreeObj("myNavigationTree");
    treeObj.selectNode(treeNode);
	$('#mm').menu('show',{left : event.pageX,top : event.pageY});
}

//加载我的收藏
function initMyNavigation(data)
{	
	$.fn.zTree.init($("#myNavigationTree"), ztSetting, data);
	var treeObj = $.fn.zTree.getZTreeObj("myNavigationTree");
	var nodes = treeObj.getNodes();
	treeObj.expandNode(nodes[0], true, false, false, false);
	treeObj.expandNode(nodes[1], true, false, false, false);
}
//列表////////////////////////////////////////////////////////////////////////
///取收藏病例列表
function getFavInformation(favUserId,catalogId,isShare)
{
	var type = (isShare)?"Share":"";
	$.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=GetFavInfoByCataLog&FavUserID="+favUserId+"&CatalogID="+catalogId+"&Type="+type, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	setFavInformation(eval("("+data+")"),isShare,"Catalog");
        } 
    });		
}

///取标签下病历
function getFavInfoByTagID(tagId,isShare)
{
	var type = (isShare)?"Share":"";
	$.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=GetInfoByTag&TagID="+tagId+"&Type="+type, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	setFavInformation(eval("("+data+")"),isShare,"KeyWord");
        } 
    });		
}

///加载病例列表
function setFavInformation(favdata,isShare,dirType)
{
	$("#favInfoList").empty();
	$("#favcount").text(favdata.count);
	var data = favdata.total;
	for (var i=0;i<data.length;i++)
	{
		var table = $('<table class="tbData" style="width:100%" id="'+data[i].id+'"></table>');
		$(table).attr({"IsShareFolder":(isShare)?"Share":"UnShare","DirType":dirType});
		var td = '<td class="tdtitle" colspan=4><span>病人ID:</span><span class="tcol1" id="PatientNo">'+data[i].PatientNo+'</span><div title="取消收藏" class="c" onclick="deleteInfomation('+"'"+data[i].id+"'"+')"></div></td>';
		$(table).append($('<tr></tr>').append(td));
		var image =  data[i].Gender=="女"?"../scripts/emr/image/icon/women_cq.png":"../scripts/emr/image/icon/men_cq.png";
		td  = '<td class="centertd"><img class="picture" src="'+image+'"/></td>';
		td = td + '<td class="info">';
		td = td + '<div><span>姓名:</span><span id="Name">'+data[i].Name+'</span></div>';
		td = td + '<div><span>性别:</span><span id="Gender">'+data[i].Gender+'</span></div>';
		td = td + '<div><span>出生日期:</span><span id="BOD">'+data[i].BOD+'</span></div>';
		td = td + '</td>';
		td = td + '<td id="tagMemo">';
		td = td + '<div id="Memo"><textarea id="com" class="noborder" readOnly="readonly">'+data[i].Memo.replace(/\\n/g,"\n")+'</textarea><div><a class="modify" href="#" onclick="modifyMemo('+"'"+data[i].id+"'"+')"><i id="modifymemo" class="glyphicon glyphicon-edit"></i>修改备注...</a></div></div>';
		if (dirType != "KeyWord")
		{
			td = td + '<div id="tags">'
			var span = ""
			for (var j=0;j<data[i].Tags.length;j++)
			{
				span = span + '<span class="tag">'+data[i].Tags[j].TagName+'</span>';
			}
			td = td + span +'</div><a class="addkeywords" href="#" onclick="addInfoToTag('+"'"+data[i].id+"'"+')"><i class="addkey"></i>添加关键字...</a>';
		}
		td = td + '</td>';
		td = td + '<td id="tool">';
		td = td + '<div><a href="#" onclick="openRecord('+"'"+data[i].id+"','"+data[i].EpisodeID+"','"+isShare+"','"+data[i].PatientID+"','"+data[i].Name+"'"+')">查看病历</a></div>';
		if (!isShare)
		{
			td = td + '<div><a href="#" onclick="moveTo('+"'"+data[i].id+"','"+data[i].CatalogID+"'"+')">移动病历</a></div>';
		}
		td = td + '</td>';
		$(table).append($('<tr></tr>').append(td));
		$("#favInfoList").append(table);
	}	
}

//打开病历
function openRecord(id,episodeId,isShare,patientId,name)
{
	if (isShare=="false")
	{
		//记录用户(整理收藏.查看病历)行为
		AddActionLog(userId,userLocId,"FavoritesView.RecordView",name);  
	}
	else
	{
		//记录用户(整理收藏.查看共享病历)行为
		AddActionLog(userId,userLocId,"FavoritesView.RecordViewShare",name);  
	}	

	var content = '<iframe id="framFav'+id+'" frameborder="0" src="emr.favorite.recordlist.csp?FavInfoID='+id+'&EpisodeID='+episodeId+'&PatientID='+patientId+'&UserID='+userId+'&UserLocID='+userLocId+'&IsShare='+isShare+'" style="width:100%;height:100%;scrolling:no;"></iframe>'
	addTab("tabFavorite","Fav"+id,"病历("+name+")",content,true);		
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
	AddActionLog(userId,userLocId,"FavoritesView.ModifyMemo","");  	
	
	var array = {
		"UserID":userId,
		"PatientNo":$("#"+ id +" #PatientNo").text(),
		"Name":$("#"+ id +" #Name").text(),
		"Gender":$("#"+ id +" #Gender").text(),
		"BOD":$("#"+ id +" .info #BOD").text(),
		"Memo":$("#"+ id +" #Memo" + " #com").val(),
		"InstanceID":"",
		"ID":id,
		"Type":"Modity"
		};
	var returnValues = window.showModalDialog("emr.favorite.modify.csp",array,"dialogHeight:340px;dialogWidth:420px;resizable:no;status:no");
	if (returnValues)
	{
		$("#favInfoList #"+id+" #Memo"+" #com").val(returnValues);
	}

}

//添加病历到标签
function addInfoToTag(id)
{
	//记录用户(整理收藏.添加关键字)行为
	AddActionLog(userId,userLocId,"FavoritesView.KeyWordAdd","");  	
	
	var array = {"UserID":userId,"FavInfoID":id,"UserLocID":userLocId};
	var returnValues = window.showModalDialog("emr.favorite.addtotag.csp",array,"dialogHeight:300px;dialogWidth:310px;resizable:yes;status:no");
	if (returnValues)
	{
		var treeObj = $.fn.zTree.getZTreeObj("myNavigationTree");
		var nodes = treeObj.getNodes();
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
		var node = treeObj.getNodes()[n];
		$("#"+id +" #tags").empty();
		for(var i=0;i<returnValues.length;i++)
		{
			$("#"+id +" #tags").append('<span class="tag">'+returnValues[i].text+'</span>');
			if(node.children[node.children.length-1]!=null&&parseInt(returnValues[i].id)>parseInt(node.children[node.children.length-1].id))
			{
				var newNode = {
					id:returnValues[i].id,
					name:returnValues[i].text,
	        	    attributes:{
		        	    	"favUserId":favUserId,
		        	    	"type":"KeyWord"
	        	    }
				}
				var treeObj = $.fn.zTree.getZTreeObj("myNavigationTree");
				newNode = treeObj.addNodes(node, newNode);
			}
		}
	}
}

//移动病历到目录
function moveTo(id,catalogId)
{
	//记录用户(整理收藏.移动病历)行为
	AddActionLog(userId,userLocId,"FavoritesView.ModifyPosition","");  	
	
	var array = {"FavUserID":favUserId,"FavInfoID":id,"UserID":userId,"UserLocID":userLocId};
	var returnValue = window.showModalDialog("emr.favorite.movetocatalog.csp",array,"dialogHeight:350px;dialogWidth:350px;resizable:yes;status:no");
	if ((returnValue != "")&&(catalogId != returnValue))
	{
		removeInfo(id);
	}
	
}
//移除界面病历内容
function removeInfo(id)
{
	$("#"+id).remove();
}

//创建目录
$("#addCatalog").click(function(){

	//记录用户(整理收藏.我的收藏.新建目录)行为
    AddActionLog(userId,userLocId,"FavoritesView.MyTreeNode.Catalog.New","");  	

    var treeObj = $.fn.zTree.getZTreeObj("myNavigationTree");
    var node = treeObj.getSelectedNodes()[0];
    if (node.attributes.type != "CatalogRoot" && node.attributes.type != "Catalog")
    {
        return;
    }
    $.messager.prompt('在' + node.name + '中创建目录', '请输入目录名称', function (r)
        {
            if (r)
            {
                addCatalog(node, r);
            }
        }
        );
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
            var newNode = "";
        	if (data != "0")
        	{
                newNode = 
                {
                    id : data,
                    name : catalogName,
                    attributes :
                    {
                            parent : parentId,
                            favUserId : favUserId,
                            type : "Catalog"
                    }
                }
            }
            var treeObj = $.fn.zTree.getZTreeObj("myNavigationTree");
            newNode = treeObj.addNodes(node, newNode);
        }
    }
    );
}

//创建标签
$("#addTag").click(function(){
	
	//记录用户(整理收藏.我的收藏.新建关键字)行为
    AddActionLog(userId,userLocId,"FavoritesView.MyTreeNode.KeyWord.New","");  	
	
	var treeObj = $.fn.zTree.getZTreeObj("myNavigationTree");
    var node = treeObj.getSelectedNodes()[0];
	if (node.attributes.type != "KeyWordRoot" && node.attributes.type != "KeyWord")
	{
		return;
	}
	$.messager.prompt('在'+node.name+'中创建标签', '请输入标签名称', function(r){
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
                    id : data,
                    name : tagName,
                    attributes :
                    {
	                    favUserId : favUserId,
	                    type : "KeyWord"
                    }
                }
            }
            var treeObj = $.fn.zTree.getZTreeObj("myNavigationTree");
            newNode = treeObj.addNodes(node, newNode);
        } 
    });	 
}

//删除目录
$("#delCatalog").click(function(){
    var treeObj = $.fn.zTree.getZTreeObj("myNavigationTree");
    var node = treeObj.getSelectedNodes()[0];
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
	    text='该目录包含收藏的病历,是否确定删除' + node.name + '?';
	}else{
		text='是否确定删除' + node.name + '?';
	}
    $.messager.defaults = { ok: "是", cancel: "否" };
    $.messager.confirm('删除目录提示',text,function(data){
	    if (data){
		    delCatalog(node);
		}
	});
});
//删除目录节点
function delCatalog(node){
	var treeObj = $.fn.zTree.getZTreeObj("myNavigationTree");
	$.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=DelCatalog&RowID="+node.id,
        async:false, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) {
        	if (data != "0") treeObj.removeNode(node);
        }
    });
    //记录用户(整理收藏.我的收藏.删除目录)行为
    AddActionLog(userId,userLocId,"FavoritesView.MyTreeNode.Catalog."+node.name+".Del","");
}

///重命名节点
$("#modityName").click(function(){	
    var treeObj = $.fn.zTree.getZTreeObj("myNavigationTree");
    var nodes = treeObj.getSelectedNodes();
    treeObj.editName(nodes[0]);
});
///更新树节点
function updateTree(event, treeId, node, isCancel)
{
    var id = node.id;
    var name = node.name;
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
	var id = $("#serach a").attr("id");
	
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
	$("#favInfoList table").hide();
	var $d = $("#favInfoList table").filter(":contains('"+$.trim(value)+"')");
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
$("#exportWord").click(function(){
	
	//记录用户(整理收藏.导出收藏列表到word)行为
    AddActionLog(userId,userLocId,"FavoritesView.ExprotToWord",""); 	
	exportToWord("favInfoList");

});

//导出收藏列表到Excel
$("#exportExcel").click(function(){
	
	//记录用户(整理收藏.导出收藏列表到Excel)行为
    AddActionLog(userId,userLocId,"FavoritesView.ExprotToExcel",""); 	
	exportToExcel("favInfoList");
});

//页面关闭
window.onunload=function()
{
	//记录用户(整理收藏.页面关闭)行为
    AddActionLog(userId,userLocId,"FavoritesView.Page.Close",""); 			
}
//点击控件事件
function my_click(obj, myid)
{
	if (document.getElementById(myid).value == document.getElementById(myid).defaultValue)
	{
		document.getElementById(myid).value = '';
		obj.style.color='#000';
	}
}
//离开控件事件
function my_blur(obj, myid)
{
	if (document.getElementById(myid).value == '')
	{
		document.getElementById(myid).value = document.getElementById(myid).defaultValue;
		obj.style.color='#999'
	}
}
