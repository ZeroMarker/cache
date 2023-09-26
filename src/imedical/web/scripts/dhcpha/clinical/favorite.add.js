var returnValue = 1;
﻿$(function(){
	
	if($.browser.version == '11.0')
	{
		document.documentElement.className ='ie11';
		$('#addcss').attr("href","../scripts/dhcpha/emr/lib/tool/taginput/jquery.tagsinput-IE11.css");
	}
	FavUserID = getFavUserID();
	////初始化收藏名称
	if(Gender=="女")
	var image ="../scripts/dhcpha/emr/image/icon/women_cq.png";
	else if(Gender=="男")
	var image ="../scripts/dhcpha/emr/image/icon/men_cq.png";
	else
	var image ="../scripts/dhcpha/emr/image/icon/menno_cq.png";
	//var image = Gender=="女"?"../scripts/dhcpha/emr/image/icon/woman.jpg":"../scripts/dhcpha/emr/image/icon/man.jpg";
	$("#photo").append('<span><img src="'+image+'"/></span>');
	$(".tdtitle").append('<span>登记号:</span><span class="tcol1">'+PatientNo+'</span>');
	var info = '<div><span>姓名:</span><span id="Name">'+Name+'</span></div>';
	info = info + '<div><span>性别:</span><span id="Gender">'+Gender+'</span></div>';
	info = info + '<div><span>出生日期:</span><span id="BOD">'+BOD+'</span></div>';
	$("#content").append(info);
	//初始化收藏位置
	initCatalogTree("cbxLocation",true);
	
	//添加收藏
	$("#btnAdd").click(function(){ 
		addFavorite();
		//记录用户(收藏病历.提交)行为
		 returnValue = "FavoritesAdd.Commit";  			
	});
	
	//关闭窗口
	$("#btnCancel").click(function(){
		//记录用户(收藏病历.取消)行为
	       returnValue = "FavoritesAdd.Cancel"; 
		closeWindow();
	});
	
	/* $('#tags').tagsInput({
		width:'310px',
		height:'73px',
		onAddTag:function(tag){
			var curlength = tag.length;
			if(curlength > 15)
			{
				alert("超出15字数限制，请重新输入！");
				$('#tags').removeTag(tag);
			}
		},
	//defaultText:"输入关键字(0-15字),回车试试"
	});*/
}); 

///获取收藏用户ID
function getFavUserID()
{
	var result = "";
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data:"Action=GetFavUserID&UserID=" + UserID,
        async: false, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	result = data;
        } 
    });
    return result;		
}

//初始化页面收藏位置
function initCatalogTree(id,required)
{
	jQuery.ajax({
		type : "GET",
		dataType : "text",
		url : "../web.DHCCM.EMRservice.Ajax.favorites.cls",
		async : true,
		data : {"Action":"GetFavCatalog","FavUserID":FavUserID},
		success : function(d) {
		
			var data = eval(d);
			if (id == "cbxNewLocation")
			{
				data = [{id:0,text:"收藏夹",children:data}];
			}
			$('#'+id).combotree('loadData',data);
			var node = $('#'+id).combotree('tree').tree('getRoot');
			if (node)
			{
				$('#'+id).combotree('setValue',node.id);
			}
			
		},
		error : function(d) { alert("目录加载失败");}
	}); 
}

//添加收藏
function addFavorite(){
	var tags = $("#tags").val(); //关键字
	var catalogId = $('#cbxLocation').combotree('getValue'); //收藏分类
	var memo = $("#txaMemo").val(); //备注
    runClassMethod("web.DHCCM.drugFav","OnPage",{"PatientNo":PatientID,"FavUserID":FavUserID,"Tags":tags,"CatalogID":catalogId,"Memo":memo,"EpisodeID":EpisodeID,"InstanceID":InstanceID},function(jsonObj){
		if (jsonObj == "1")
        {
			SetToLog(catalogId,tags); //收藏日志写入
        	alert("添加成功");
        	closeWindow();
        }
        else
        {
	        $.messager.alert('提示信息','收藏失败','info');
	    }
   });
}
//关闭窗口
function closeWindow()
{
	parent.closeDialog("dialogFavAdd");
}

$("#btnNew").click(function(){
	
	//记录用户(收藏病历.新建目录)行为
	AddActionLog(UserID,UserLocID,"FavoritesAdd.NewDir","");
	newCatalog();	
});

//新建文件夹窗口
function newCatalog()
{
	$('#newCatalog').window({
		title: "创建文件夹",
		width: 300,  
		height: 150,  
		modal: true,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		closed: true,
		onOpen: function(){
			initCatalogTree("cbxNewLocation",false);
		},
		onClose: function(){
		}	 
	});
	$('#newCatalog').window('open');
	$('#txtName').val("");//huaxiaoying 2018-02-28 清空文件夹名
	$('#newCatalog').css("display","block");
}

$("#btnClose").click(function(){
	
	//记录用户(收藏病历.新建目录.关闭)行为
	AddActionLog(UserID,UserLocID,"FavoritesAdd.NewDir.Close","");

	$('#newCatalog').window('close');
});

$("#btnCreate").click(function(){
	//记录用户(创建收藏目录)行为
	AddActionLog(UserID,UserLocID,"FavoritesAdd.NewDir.Create","");
	saveNewCatalogTree()
});

//新增目录
function saveNewCatalogTree()
{
	var value = $('#cbxNewLocation').combotree('getValue');
	var parentId = ((value == null)||(value == ""))?"0":value;
	var name = $('#txtName').val();
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=AddCatalog&FavUserID="+FavUserID+"&ParentID="+parentId+"&CatalogName="+name, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
            if(data=="-1"){ //huaxiaoying 2018-03-07
	            $.messager.alert('提示信息','重名请另起名字','info');
	            return;
	        }
        	if (data != "0")
        	{
	        	initCatalogTree("cbxLocation",true);
        		$('#newCatalog').window('close');
        	}
        	else
        	{
	        	$.messager.alert('提示信息','创建失败','info');
	        }
        } 
    });		
	
}
//记录病历操作行为日志(收藏分类,关键字)
function SetToLog(catalogId,tags){
	if (categoryId != "" && templateId != "")
	{
		if (IsSetToLog == "Y")
		{
			var ipAddress = getIpAddress();
			var ModelName = "EMR.FavoritesAdd.OK";
			var Condition = "";
			Condition = Condition + '{"patientID":"' + PatientNo + '",';
			Condition = Condition + '"episodeID":"' + EpisodeID + '",';
			Condition = Condition + '"userName":"' + escape(UserName) + '",';
			Condition = Condition + '"userID":"' + UserID + '",';
			Condition = Condition + '"ipAddress":"' + ipAddress + '",';
			Condition = Condition + '"InstanceID":"' + InstanceID + '",';
			Condition = Condition + '"categoryId":"' + categoryId + '",';
			Condition = Condition + '"templateId":"' + templateId + '",';
			Condition = Condition + '"Tags":"' + tags + '",';
			Condition = Condition + '"CatalogID":"' + catalogId + '"}';
			var ConditionAndContent = Condition;
			//alert(ConditionAndContent);
			var SecCode = "";
			$.ajax({ 
				//type: "POST", 
				url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
				data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + SecCode
			});
		}
	}
}
