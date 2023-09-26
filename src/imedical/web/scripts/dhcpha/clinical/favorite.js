var InstanceID=""; //模板id
var JsonObj="";
$(function(){
	if($.browser.version == '11.0')
	{
		$('#selectcss').attr("href","../scripts/dhcpha/emr/css/favorite-IE11.css");
	}
	//个人收藏夹
	getFavNavigation();
	
	$('#contentSeek').click(function(){ 
		var val = document.getElementById("content").value
		doSearch(val);
	});
	
	$("#serach .selected").live('click',function(){
		$(this).remove();
		$("#serach").append('<a href="#" class="all" id="all">所有药历</a>');
		$("#favcount").text(0);
		$("#favInfoList").empty();
	});
	//getAllTemNews(); //获取模板信息
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
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
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
    //$("#favcount").text(0);
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
    //$("#serach").empty().append('<A href="#" class="selected" id="'+treeNode.attributes.type+'">'+treeNode.name+'</A>'); //huaxiaoying 2018-03-01 注释和修改
    $("#serach").empty().append('<A href="#" value="'+treeNode.attributes.favUserId+'*'+treeNode.id+'"'+' class="selected" id="'+treeNode.attributes.type+'">'+treeNode.name+'</A>');
};

//ztree鼠标右键点击回调函数
function ztOnRightClick(event, treeId, treeNode)
{
	if (treeNode==null)
	{
		return;
	}
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
///取收藏药历列表
function getFavInformation(favUserId,catalogId,isShare)
{
	var type = (isShare)?"Share":"";
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=GetFavInfoByCataLog&FavUserID="+favUserId+"&CatalogID="+catalogId+"&Type="+type, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        //alert(data)
        	setFavInformation(eval("("+data+")"),isShare,"Catalog");
        } 
    });		
}

///取标签下药历
function getFavInfoByTagID(tagId,isShare)
{
	var type = (isShare)?"Share":"";
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=GetInfoByTag&TagID="+tagId+"&Type="+type, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        //alert(data)
        	setFavInformation(eval("("+data+")"),isShare,"KeyWord");
        } 
    });		
}

///hxy 2018-03-01 补零			
function getPatNo(PatNo){
	var plen = PatNo.length;
	for (var i=1;i<=10-plen;i++){
			PatNo="0"+PatNo;  
	}
	return PatNo;
}

///加载药历列表
function setFavInformation(favdata,isShare,dirType)
{
	$("#favInfoList").empty();
	$("#favcount").text(favdata.count);
	var data = favdata.total;
	
	for (var i=0;i<data.length;i++)
	{
		InstanceID=data[i].Records[0].InstanceID; //模板id
		getAllTemNews(); //模板相关信息
		var table = $('<table class="tbData" style="width:100%" id="'+data[i].id+'"></table>');
		$(table).attr({"IsShareFolder":(isShare)?"Share":"UnShare","DirType":dirType});
		var td = '<td class="tdtitle" colspan=4>'+
		    '<span>床号:</span><span class="bed" id="bed">'+data[i].Records[0].disBed+'</span>'+"|"+
		    '<span>登记号:</span><span class="tcol1" id="PatientNo">'+getPatNo(data[i].PatientNo)+'</span>'+"|"+ //hxy 2018-03-01 补零
			'<span>就诊号:</span><span class="eps" id="epsoideId">'+data[i].Records[0].EpisodeID+'</span>'+"|"+
			'<span>就诊日期:</span><span class="epsdate" id="epsdate">'+data[i].Records[0].PAADMAdmDate+'</span>'+"|"+
			'<span>科室:</span><span class="dept" id="dept">'+data[i].Records[0].episodeDeptDesc+'</span>'+"|"+
			'<span>付费方式:</span><span class="payType" id="payType">'+data[i].Records[0].payType+'</span>'+
			'<div title="取消收藏" class="c" onclick="deleteInfomation('+"'"+data[i].id+"'"+')"></div>'+
			'</td>';
		$(table).append($('<tr></tr>').append(td));
		if(data[i].Gender=="女")
	    var image ="../scripts/dhcpha/emr/image/icon/women_cq.png";
	    else if(data[i].Gender=="男")
	    var image ="../scripts/dhcpha/emr/image/icon/men_cq.png";
	    else
	    var image ="../scripts/dhcpha/emr/image/icon/menno_cq.png";
		//var image =  data[i].Gender=="女"?"../scripts/dhcpha/emr/image/icon/women_cq.png":"../scripts/dhcpha/emr/image/icon/men_cq.png";
		td  = '<td class="centertd"><img class="picture" src="'+image+'"/></td>';
		td = td + '<td class="info">';
		td = td + '<div><span>姓名:</span><span id="Name">'+data[i].Name+'</span></div>';
		td = td + '<div><span>性别:</span><span id="Gender">'+data[i].Gender+'</span>&nbsp&nbsp&nbsp&nbsp<span>年龄:</span><span id="Age">'+data[i].Records[0].age+'</span></div>';
		td = td + '<div><span>出生日期:</span><span id="BOD">'+data[i].BOD+'</span></div>';
		td = td + '</td>';
		td = td + '<td id="tagMemo">';
		td = td + '<div id="Memo"><textarea id="com" class="noborder">'+data[i].Memo+'</textarea><div><a class="modify"  href="#" onclick="modifyMemo('+"'"+data[i].id+"'"+')"><img id="modifymemo" class="glyphicon-edit" src="../scripts/dhcpha/jQuery/themes/icons/pencil.png">修改备注...</a></div></div>';//lbb  2018/7/13 添加图片
		if (dirType != "KeyWord")
		{
			td = td + '<div id="tags">'
			var span = ""
			for (var j=0;j<data[i].Tags.length;j++)
			{
				span = span + '<span class="tag">'+data[i].Tags[j].TagName+'</span>';
			}
			td = td + span +'</div><a class="addkeywords" href="#" onclick="addInfoToTag('+"'"+data[i].id+"'"+')"><img class="glyphicon-edit" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png">添加关键字...</a>';//lbb  2018/7/13 添加图片
		}
		td = td + '</td>';
		 td = td + '<td id="tool" style="width:14%">' ; //hxy 2018-02-28 add style="" //id,text,chartItemType,pluginType,emrDocId,epsoideId,patientId
		td = td + '<div><a href="#" style="margin-left:-20px" onclick="openDrugRecord('+"'"+JsonObj.id+"'"+','+"'"+JsonObj.text+"'"+','+"'"+JsonObj.chartItemType+"'"+','+"'"+JsonObj.pluginType+"'"+','+"'"+JsonObj.emrDocId+"'"+','+"'"+data[i].Records[0].EpisodeID+"'"+','+"'"+data[i].PatientNo+"'"+')"><img  style="margin-left:2px" class="glyphicon-search" src="../scripts/dhcpha/jQuery/themes/icons/search.png">查看药历</a></div>';//lbb  2018/7/13 添加图片
		if (!isShare)
		{
			td = td + '<div><a href="#" style="margin-left:-20px"onclick="moveTo('+"'"+data[i].id+"','"+data[i].CatalogID+"'"+')"><img style="margin-left:2px" class="glyphicon-search" src="../scripts/dhcpha/jQuery/themes/icons/adv-sel.png">移动药历</a></div>';//lbb  2018/7/13 添加图片
		}
		td = td + '</td>';
		$(table).append($('<tr></tr>').append(td));
		$("#favInfoList").append(table);
	}	
	$(".eps").css("color","red");
}

//打开药历
function openRecord(id,episodeId,isShare,patientId,name)
{
	if (isShare=="false")
	{
		//记录用户(整理收藏.查看药历)行为
		AddActionLog(userId,userLocId,"FavoritesView.RecordView",name);  
	}
	else
	{
		//记录用户(整理收藏.查看共享药历)行为
		AddActionLog(userId,userLocId,"FavoritesView.RecordViewShare",name);  
	}	

	var content = '<iframe id="framFav'+id+'" frameborder="0" src="dhcpha.clinical.favorite.recordlist.csp?FavInfoID='+id+'&EpisodeID='+episodeId+'&PatientID='+patientId+'&UserID='+userId+'&UserLocID='+userLocId+'&IsShare='+isShare+'" style="width:100%;height:100%;scrolling:no;"></iframe>'
	addTab("tabFavorite","Fav"+id,"药历("+name+")",content,true);		
}

//取消收藏病例
function deleteInfomation(id)
{
	$.messager.confirm('取消收藏', '要取消药历收藏吗?', function(r){
		if (r)
		{
			$.ajax({ 
		        type: "POST", 
		        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
		        data: "Action=DeleteFavInfomation&FavInfoID="+id, 
		        error: function (XMLHttpRequest, textStatus, errorThrown) { 
		            alert(textStatus); }, 
		        success: function (data) { 
		        	if (data == "1")
		        	{
			        	$("#"+id).remove();
						var count=$('#favcount').text()-1; //lbb  2020/5/21 得到界面药历数目
	                    $('#favcount').text(count);
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
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=ModifyInfoMemo&FavInfoID="+ id+"&Memo="+$("#com").val(), 
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
	//记录用户(整理收藏.修改备注)行为
	AddActionLog(userId,userLocId,"FavoritesView.ModifyMemo","");  

}

function addInfoToTag(id)
{
	//记录用户(整理收藏.添加关键字)行为
	AddActionLog(userId,userLocId,"FavoritesView.KeyWordAdd","");  	
	
	var array = {"UserID":userId,"FavInfoID":id,"UserLocID":userLocId};
         var arrayStr = base64encode(utf16to8(escape(JSON.stringify(array))));
    
	var args = {id:id,UserID:userId,UserLocID:userLocId};
	 var iframe = '<iframe id="addInfoToTagFrame" scrolling="auto" frameborder="0" src="dhcpha.clinical.favorite.addtotag.csp?arrayStr='+arrayStr+'" style="width:100%;height:100%;display:block;"></iframe>';
	  createModalDialog('addInfoToTag','添加关键字',453,410,'addInfoToTagFrame',iframe,addInfoToValue,args);
}
function addInfoToValue(returnValues,args){
		//记录用户(整理收藏.添加关键字.关闭)行为
    AddActionLog(args.UserID,args.UserLocID,"FavoritesView.KeyWordAdd.Close",""); 
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
		$("#"+args.id +" #tags").empty();
		for(var i=0;i<returnValues.length;i++)
		{
			$("#"+args.id +" #tags").append('<span class="tag">'+returnValues[i].text+'</span>');
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

//移动药历到目录
function moveTo(id,catalogId)
{
    //记录用户(整理收藏.移动病历)行为
    AddActionLog(userId,userLocId,"FavoritesView.ModifyPosition","");
    
    var array = {"FavUserID":favUserId,"FavInfoID":id,"UserID":userId,"UserLocID":userLocId};
    var arrayStr = base64encode(utf16to8(escape(JSON.stringify(array))));
    var iframe = '<iframe id="movetocatalogFrame" scrolling="auto" frameborder="0" src="dhcpha.clinical.favorite.movetocatalog.csp?arrayStr='+arrayStr+'" style="width:100%;height:100%;display:block;"></iframe>';
    var args = {
	    id:id,
	    catalogId:catalogId,
		userId:userId,
		userLocId:userLocId
	    }
    createModalDialog('movetocatalog','移动药历',360,400,'movetocatalogFrame',iframe,removeInfo,args);
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
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=AddCatalog&ParentID="+parentId+"&FavUserID="+favUserId+"&CatalogName="+catalogName, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
		    if(data=="-1"){ //lbb 2018/07/17
	            $.messager.alert('提示信息','重名请另起名字','info');
	            return;
	        }
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
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
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
    if(name==""){ //huaxiaoying 2018-03-01 st
	    alert("重命名不可为空");
	    getFavNavigation();
	    return;
	}//ed
    var type = node.attributes.type;
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=UpdateCatalogTagName&ID="+id+"&Name="+name+"&Type="+type, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
		    if(data=="-1"){ //lbb 2018-07-17
	            $.messager.alert('提示信息','重名请另起名字','info');
	            getFavNavigation();
	            return;
	        }
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
		//selectPresent(value); //huaxiaoying 2018-03-01 注释&st
		if ((id == "Catalog")||(id == "KeyWord")){	 
			var treeNodeStr= $("#serach a").attr("value");
			if(value=="检索药历:"){
				var NodeStr=treeNodeStr.split("*");
				getFavInformation(NodeStr[0], NodeStr[1], false);
			}else{
				selectPresent(value);
			}
		} //ed
	}

	//记录用户(整理收藏.查找药历)行为
    AddActionLog(userId,userLocId,"FavoritesView.Search",""); 		
}

///检索当前
function selectPresent(value)
{
	$("#favInfoList table").hide();
	var $d = $("#favInfoList table").filter(":contains('"+$.trim(value)+"')");
	$d.show();
}

///检索所有
function selectAll(value,Location)
{
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
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
					alert("没有找到相关药历，请重新进行搜索！");
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

/* //页面关闭
window.onbeforeunload=function()
{
	//记录用户(整理收藏.页面关闭)行为
    AddActionLog(userId,userLocId,"FavoritesView.Page.Close",""); 
} */

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

///查看药历模板
function openDrugRecord(id,text,chartItemType,pluginType,emrDocId,epsoideId,patientId){
	$("#winonline").html("");
	//alert(id+" "+text+" "+chartItemType+" "+pluginType+" "+emrDocId+" "+patientId)
	if($('#winonline').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="winonline" style="overflow-x:hidden;overflow-y:hidden"></div>'); //qunianpeng 2017/12/29 去掉滚动条
	$('#winonline').window({
		title:text+'查看',
		collapsible:true,
		border:false,
		minimizable:false,   //lbb 2018/7/17 屏蔽最小化按钮
		closed:"true",
		width:1110,
		height:620
	});
	var src = "dhcpha.record.browse.browsform.editor.csp?id="+id+"&text="+text+"&chartItemType="+chartItemType
        + "&pluginType="+pluginType+"&emrDocId="+emrDocId
        + "&characteristic=1" + "&status=BROWSE" + "&episodeId=" + epsoideId + "&patientId=" + patientId;	
	var content = "<iframe id='frameBrowseCategory' src='" + src + "' style='width:100%;height:100%;frameborder='0';scrolling='no''></iframe>";
	$('#winonline').append(content);
	$('#winonline').window('open');
	
}


///获取模板相关信息
function getAllTemNews(){
	 runClassMethod("web.DHCCM.drugFav","getAllTempNews",{"InstanceID":InstanceID},function(jsonObj){
		JsonObj=jsonObj;
   },'json',false);
}
