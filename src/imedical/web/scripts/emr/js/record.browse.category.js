$(function(){
	initCategory();	
});

function initCategory()
{
	if (browseShow["Default"] == "ZTtree")
	{
		$('#TypeTree').attr("checked",true);	
		getTreeCategory();
	}
	else
	{
		$('#TypeList').attr("checked",true);	
		getCategory();
	}
}

///选择病历导航列表显示样式
function GetRecordType(type)
{
	if (type == "Tree")
	{
		getTreeCategory();
	}
	else
	{
		getCategory();
	}
}

//取病历分类目录
function getTreeCategory()
{
	var data = {
		"OutputType":"Stream",
		"Class":"EMRservice.BL.BLClientCategory",
		"Method":"GetBrowseCategory",
		"p1":episodeID,
		"p2":"ZTree"
	};
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: data,
		success: function(d) {
			if (d!="")
			{
				setTreeData(eval("["+d+"]"));
			}
		},
		error : function(d) { alert("GetBrowseCategory error");}
	});		
}

//用ztree方法加载目录
function setTreeData(data)
{
	$('.navcategory').empty();
	if (data[0].length != 0)
	{
		$("#noRecordMes").css("display","none");
		$("#InstanceTree").attr("class","ztree chats_ztree");
		$.fn.zTree.init($('#InstanceTree'), ztSetting, data[0]);
		var treeObj = $.fn.zTree.getZTreeObj('InstanceTree');
		var firstNode = treeObj.getNodes()[0];
		if (firstNode.isParent){
		    firstNode = firstNode.children[0];
		}
		if (initflag == 0)
		{
			var tempparam = setZtreeTempParam(firstNode);
			initRecord(tempparam); 
			initflag = 1
		}
		treeObj.expandAll(true);
	}
    else
    {
        $("#noRecordMes").css("display","block");
    }
}

//取Ztree调用数据
function setZtreeTempParam(firstNode)
{
	var id = firstNode.id;
	var text = firstNode.attributes["text"];
    var chartItemType = firstNode.attributes["chartItemType"];
    var pluginType = firstNode.attributes["documentType"];
    var emrDocId = firstNode.attributes["emrDocId"];
    var characteristic = firstNode.attributes["characteristic"];
	var tempParam = {"id":id,"text":text,"chartItemType":chartItemType,"pluginType":pluginType,"emrDocId":emrDocId,"characteristic":characteristic,"status":"BROWSE"};
	return tempParam;
}

//ztree显示、回调函数、数据格式配置
var ztSetting =
{
    view :
    {
        showIcon : false,
        nameIsHTML: true
    },
    callback :
    {
        onClick : ztOnClick,
        beforeClick : ztBeforeClick
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
	var tempParam = {
		"id":treeNode.id,
		"text":treeNode.attributes.text,
		"pluginType":treeNode.attributes.documentType,
		"chartItemType":treeNode.attributes.chartItemType,
		"emrDocId":treeNode.attributes.emrDocId,
		"templateId":treeNode.attributes.templateId,
		"isLeadframe":treeNode.attributes.isLeadframe,
		"characteristic":treeNode.attributes.characteristic,
		"isMutex":treeNode.attributes.isMutex,
		"categoryId":treeNode.attributes.categoryId,
		"actionType":"LOAD",
		"status":"BROWSE",
		"closable":true
	};
	if (window.frames["frameBrowseCategory"])
	{
	 	//window.frames["frameBrowseCategory"].loadDocument(tempParam);
	 	//医为浏览器切换病历时，上面方式loadDocument未定义，但是ie没问题；改成下面方式后，医为浏览器、ie都没问题；
	 	document.getElementById("frameBrowseCategory").contentWindow.loadDocument(tempParam);
	}
}
//如果返回 false，zTree 将不会选中节点，也无法触发 onClick 事件回调函数
function ztBeforeClick(treeId, treeNode, clickFlag)
{
	//当是父节点 返回false 不让选取
	return !treeNode.isParent;
}

//取病历目录
function getCategory()
{
	var data = {
		"OutputType":"Stream",
		"Class":"EMRservice.BL.BLClientCategory",
		"Method":"GetBrowseCategory",
		"p1":episodeID
	};
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: data,
		success: function(d) {
			setCategory( eval(d));
		},
		error : function(d) { alert("GetBrowseCategory error");}
	});		
}

//加载页面病历目录
function setCategory(data)
{
	if (data.length > 0)
    {
		$('#InstanceTree').empty();
		$("#noRecordMes").css("display","none");
		for (var i=0;i<data.length;i++)
		{
			var li = $('<li></li>');
			if ( typeof data[i].attributes != "undefined" && data[i].attributes.itemType !="EMR")
			{
				$(li).attr("id",data[i].id);
				$(li).attr("itemType","other");
				$(li).attr("itemUrl",data[i].attributes.itemUrl);
				var link = $('<div title="' + $.trim(data[i].name) + '" class="title">'+ data[i].name +'</div>');
				$(li).append(link);
				$('.navcategory').append(li);
				if (i== 0)
				{
					loadOterUrl(data[i].attributes.itemUrl);
				}
				continue;
			}
			if (data[i].children)
			{
				if (browseShow["Display"] == "Fold" && data[i].children[0].characteristic == "1")
				{
					$(li).attr("id",data[i].children[0].id);
					$(li).attr("chartItemType",data[i].children[0].chartItemType);
					$(li).attr("pluginType",data[i].children[0].documentType);
					$(li).attr("emrDocId",data[i].children[0].emrDocId);
					$(li).attr("type",data[i].children[0].type);
					$(li).attr("characteristic",data[i].children[0].characteristic);
				
					var link = $('<div title="' + $.trim(data[i].name) + '" class="title">'+ data[i].name +'</div>');
					$(li).append(link);
					$('.navcategory').append(li);
				}
				else
				{
					for (var j=0;j<data[i].children.length;j++)
					{
						var tmpli = $('<li></li>');
						$(tmpli).attr("id",data[i].children[j].id);
						$(tmpli).attr("chartItemType",data[i].children[j].chartItemType);
						$(tmpli).attr("pluginType",data[i].children[j].documentType);
						$(tmpli).attr("emrDocId",data[i].children[j].emrDocId);
						$(tmpli).attr("type",data[i].children[j].type);
						$(tmpli).attr("characteristic",data[i].children[j].characteristic);
						if (browseShow["Display"] == "All")
						{
							if (data[i].children[j].printstatus != "")
							{
								var flagprint = $('<input class=flag id="Logflag" style="margin-top:1px;border:#49A026;background-color:#49A026;color:#49A026"/>');
								$(flagprint).attr({"emrDocId":data[i].children[j].emrDocId,"emrNum":data[i].children[j].emrNum});
								$(tmpli).append(flagprint);
							}else{
								var flagSave =  $('<input class=flag id="Logflag"/>');
								$(flagSave).attr({"emrDocId":data[i].children[j].emrDocId,"emrNum":data[i].children[j].emrNum});
								$(tmpli).append(flagSave);
							}
						}
						var link = $('<div title="' + $.trim(data[i].children[j].text) + '" class="title">'+ data[i].children[j].text +'</div>');
						$(tmpli).append(link);
						if (browseShow["Display"] == "All")
						{
							var datetime = '<h3>'+data[i].children[j].happendate+'<span>'+data[i].children[j].happentime+'</span></h3>';
							//判断客户端浏览器IE及其版本
							if ($.browser.msie && $.browser.version == '8.0')
							{
								datetime = '<h3 style="position:absolute;float:left;padding:6px 8px 0px;">'+data[i].children[j].happendate+'<span>'+data[i].children[j].happentime+'</span></h3>';
							}
							$(tmpli).append(datetime);
						}
						$('.navcategory').append(tmpli);	
						if ((i == 0)&&(j == 0)) li = tmpli;	
					}
				}
			}
			else
			{
				$(li).attr("id",data[i].id);
				$(li).attr("chartItemType",data[i].chartItemType);
				$(li).attr("pluginType",data[i].documentType);
				$(li).attr("emrDocId",data[i].emrDocId);
				$(li).attr("type",data[i].type);
				$(li).attr("characteristic",data[i].characteristic);
				if (browseShow["Display"] == "All")
				{
					if (data[i].printstatus != "")
					{
						var flagprint = $('<input class=flag id="Logflag" style="margin-top:1px;border:#49A026;background-color:#49A026;color:#49A026"/>');
						$(flagprint).attr({"emrDocId":data[i].emrDocId,"emrNum":data[i].emrNum});
						$(li).append(flagprint);
					}else{
						var flagSave =  $('<input class=flag id="Logflag"/>');
						$(flagSave).attr({"emrDocId":data[i].emrDocId,"emrNum":data[i].emrNum});
						$(li).append(flagSave);
					}
				}
				var link = $('<div title="' + $.trim(data[i].text) + '" class="title">' + data[i].text +'</div>');
				$(li).append(link);
				if (browseShow["Display"] == "All")
				{
					var datetime = '<h3>'+data[i].happendate+'<span>'+data[i].happentime+'</span></h3>';
					//判断客户端浏览器IE及其版本
					if ($.browser.msie && $.browser.version == '8.0')
					{
						datetime = '<h3 style="position:absolute;float:left;padding:6px 8px 0px;">'+data[i].happendate+'<span>'+data[i].happentime+'</span></h3>';
					}
					$(li).append(datetime);
				}
				$('.navcategory').append(li);	
			}	
			if ((i == 0)&&(initflag == 0))
			{
				var tempParam = setTempParam(li);
				initRecord(tempParam); 	
				$(li).css('background-color','#CBE8F6'); 	
				initflag = 1
			}
		  }
        }
        else
        {
	        $("#noRecordMes").css("display","block");
        }
}

//显示病历操作记录明细
$(".navcategory li #Logflag").live('click',function()
{
	var docId = $(this).attr("emrDocId");
	var Num = $(this).attr("emrNum");
	window.showModalDialog("emr.logdetailrecord.csp?EpisodeID="+episodeID+"&EMRDocId="+docId+"&EMRNum="+Num,"","dialogWidth:801px;dialogHeight:550px;resizable:yes;");
});

//目录点击事件
$(".navcategory li").live('click',function(){
	//选中文档目录
	selectListRecord($(this).attr("id"));
	var type = $(this).attr("itemType")
	if (type == "other")
	{
		var url = $(this).attr("itemUrl");
		loadOterUrl(url);
	}
	else
	{
		loadRecords(this);
	}
});

//选中文档目录
function selectListRecord(id)
{
	$(".navcategory li").each(function()
	{
		if($(this).attr('id')==id)
		{
			$(this).css('background-color','#CBE8F6');
		}
		else
		{
			$(this).css('background-color','transparent');
		}
	 });
}

//取调用数据
function setTempParam(obj)
{
	var id = $(obj).attr("id");
	var text = $(obj).text();
    var chartItemType = $(obj).attr("chartItemType");
    var pluginType = $(obj).attr("pluginType");
    var emrDocId = $(obj).attr("emrDocId");
    var characteristic = $(obj).attr("characteristic");
	var tempParam = {"id":id,"text":text,"chartItemType":chartItemType,"pluginType":pluginType,"emrDocId":emrDocId,"characteristic":characteristic,"status":"BROWSE"};
	return tempParam;
}

//初始化病历
function initRecord(tempParam)
{
	var src = "emr.record.browse.browsform.editor.csp?id="+tempParam.id+"&text="+tempParam.text+"&chartItemType="+tempParam.chartItemType
        + "&pluginType="+tempParam.pluginType+"&emrDocId="+tempParam.emrDocId+"&characteristic="+tempParam.characteristic
        + "&characteristic=1" + "&status=BROWSE" + "&episodeId=" + episodeID + "&patientId=" + patientID + "&Action=" + action;	
	$("#frameBrowseCategory").attr("src",src);
}

//加载病历
function loadRecords(obj)
{
	setDisplayFrame("frameBrowseCategory");
	var param;
	if ($('#TypeTree')[0].checked)
	{
		param = setZtreeTempParam(obj);	
	}
	else
	{
		param = setTempParam(obj);
	}
	if ($("#frameBrowseCategory").attr("src")!="")
	{
	 	//window.frames["frameBrowseCategory"].loadDocument(param);
	 	//医为浏览器切换病历时，上面方式loadDocument未定义，但是ie没问题；改成下面方式后，医为浏览器、ie都没问题；
	 	document.getElementById("frameBrowseCategory").contentWindow.loadDocument(param);
	}
	else
	{
		initRecord(param);
	}
}

function loadOterUrl(url)
{
	setDisplayFrame("frameOtherUrl");
	url = url.replace(/\[patientID\]/g, patientID);
	url = url.replace(/\[episodeID\]/g, episodeID);
	$("#frameOtherUrl").attr("src",url);		
}

function setDisplayFrame(frame)
{
	if (frame == "frameOtherUrl")
	{ 
		$("#frameBrowseCategory").css("display","none");
		$("#frameOtherUrl").css("display","block");
	}
	else
	{
		$("#frameOtherUrl").css("display","none");
		$("#frameBrowseCategory").css("display","block");
	}	
}

///检索当前病历
function selectRecord(value)
{
	$("#ulcategory li").hide();
	var $Category = $("#ulcategory li div").filter(":contains('"+$.trim(value)+"')");
	$Category.parent().show();
}