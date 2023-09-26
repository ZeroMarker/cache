$(function(){
	if($.browser.version == '11.0')
	{
		document.documentElement.className ='ie11';
	}
	favUserId = getFavUserID();
	////初始化收藏名称
	if (para)
	{
		var image = para.Gender=="女"?"../scripts/dhcpha/emr/image/icon/women_cq.png":"../scripts/dhcpha/emr/image/icon/men_cq.png";
		$("#photo").append('<img src="'+image+'"/>');
		$(".tdtitle").append('<span>登记号:</span><span class="tcol1">'+para.PatientNo+'</span>');
		var info = '<div><span>姓名:</span><span id="Name">'+para.Name+'</span></div>';
		info = info + '<div><span>性别:</span><span id="Gender">'+para.Gender+'</span></div>';
		info = info + '<div><span>出生日期:</span><span id="BOD">'+para.BOD+'</span></div>';
		$("#content").append(info);
		$("#txaMemo").val(para.Memo);
		if (para.Type != "Add")
		{
			$("#divTag").css("display","none");
			$("#divLocation").css("display","none");
			document.title = '修改备注'; 
		}
	}
	//初始化收藏位置
	initCatalogTree("cbxLocation",true);
	
	//添加收藏
	$("#btnAdd").click(function(){ 
		if (para.Type == "Add")
		{
			addFavorite();
			//记录用户(收藏病历.提交)行为
			AddActionLog(para.UserID,para.UserLoc,"FavoritesAdd.Commit","");  	
		}
		else
		{
			modityFavInfo();
			//记录用户(整理收藏.修改备注.确定)行为
			AddActionLog(para.UserID,para.UserLoc,"FavoritesView.ModifyMemo.Sure","");  	

		}
	});
	
	//关闭窗口
	$("#btnCancel").click(function(){
		if (para.Type == "Add")
		{
			//记录用户(收藏病历.取消)行为
			AddActionLog(para.UserID,para.UserLoc,"FavoritesAdd.Cancel",""); 
		} 
		else
		{
			//记录用户(整理收藏.修改备注.取消)行为
			AddActionLog(para.UserID,para.UserLoc,"FavoritesView.ModifyMemo.Cancel",""); 	
		}
		closeWindow();
	});
	
	$('#tags').tagsInput({
		width:'310px',
		height:'73px',
		defaultText:"输入关键字，回车试试看^_^"
	});
});

///获取收藏用户ID
function getFavUserID()
{
	var result = "";
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data:"Action=GetFavUserID&UserID="+para.UserID,
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
		data : {"Action":"GetFavCatalog","FavUserID":favUserId},
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
function addFavorite()
{
	var tags = $("#tags").val();
	var catalogId = $('#cbxLocation').combotree('getValue');
	var memo = $("#txaMemo").val();
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data:"Action=AddFavorite&PatientNo="+para.PatientNo+"&FavUserID="+favUserId+"&Tags="+tags+"&CatalogID="+catalogId+"&Memo="+memo+"&EpisodeID="+para.EpisodeID+"&InstanceID="+para.InstanceID, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	if (data == "1")
        	{
				if (para.IsSetToLog == "Y")
				{
					var ModelName = "EMR.FavoritesAdd.OK";
					var Condition = "";
					Condition = Condition + '{"patientID":"' + para.PatientNo + '",';
					Condition = Condition + '"episodeID":"' + para.EpisodeID + '",';
					Condition = Condition + '"userName":"' + escape(para.userName) + '",';
					Condition = Condition + '"userID":"' + para.UserID + '",';
					Condition = Condition + '"ipAddress":"' + para.ipAddress + '",';
					Condition = Condition + '"InstanceID":"' + para.InstanceID + '",';
					Condition = Condition + '"Tags":"' + tags + '",';
					Condition = Condition + '"CatalogID":"' + catalogId + '"}';
					var ConditionAndContent = Condition;
					//alert(ConditionAndContent);
					var SecCode = "";
					$.ajax({ 
						//type: "POST", 
						url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
						data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + para.SecCode
					});
				}
        		closeWindow();
        	}
        	else
        	{
	        	$.messager.alert('提示信息','收藏失败','info');
	        }
        } 
    });
}

//修改收藏备注
function modityFavInfo()
{
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.favorites.cls", 
        data: "Action=ModifyInfoMemo&FavInfoID="+ para.ID+"&Memo="+$("#txaMemo").val(), 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	if (data == "1")
        	{
	        	window.returnValue = $("#txaMemo").val();
        		closeWindow();
        	}
        	else
        	{
	        	$.messager.alert('提示信息','修改失败','info');
	        }
        } 
    });	
}

//关闭窗口
function closeWindow()
{
	window.opener = null;
	window.open('','_self');
	window.close();	
}

$("#btnNew").click(function(){
	
	//记录用户(收藏病历.新建目录)行为
	AddActionLog(para.UserID,para.UserLoc,"FavoritesAdd.NewDir","");
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
	$('#newCatalog').css("display","block");
}

$("#btnClose").click(function(){
	
	//记录用户(收藏病历.新建目录.关闭)行为
	AddActionLog(para.UserID,para.UserLoc,"FavoritesAdd.NewDir.Close","");

	$('#newCatalog').window('close');
});

$("#btnCreate").click(function(){
	//记录用户(创建收藏目录)行为
	AddActionLog(para.UserID,para.UserLoc,"FavoritesAdd.NewDir.Create","");
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
        data: "Action=AddCatalog&FavUserID="+favUserId+"&ParentID="+parentId+"&CatalogName="+name, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
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
