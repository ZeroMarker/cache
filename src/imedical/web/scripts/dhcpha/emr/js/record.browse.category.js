$(function(){
	if (browseShow["Display"] == "Fold")
	{
		$('#layout').layout('panel','east').panel('resize',{width:130});
		$('#layout').layout('resize');
	}
	getCategory();	
});

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
	for (var i=0;i<data.length;i++)
	{
		var li = $('<li></li>');
		
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
		if (i == 0)
		{
			initRecord(li); 	
			$(li).css('background-color','#CBE8F6'); 	
		}
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
	loadRecords(this);
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
function initRecord(obj)
{
	var tempParam = setTempParam(obj);
	var src = "emr.record.browse.browsform.editor.csp?id="+tempParam.id+"&text="+tempParam.text+"&chartItemType="+tempParam.chartItemType
        + "&pluginType="+tempParam.pluginType+"&emrDocId="+tempParam.emrDocId+"&characteristic="+tempParam.characteristic
        + "&characteristic=1" + "&status=BROWSE" + "&episodeId=" + episodeID + "&patientId=" + patientID + "&Action=" + action;	
	var content = "<iframe id='frameBrowseCategory' src='" + src + "' scrolling='no' width='100%' height='100%' frameborder='0'></iframe>";
	$('#BrowseCategory').append(content);
}

//加载病历
function loadRecords(obj)
{
	if (window.frames["frameBrowseCategory"])
	{
	 	window.frames["frameBrowseCategory"].loadDocument(setTempParam(obj));
	}
}

///检索当前病历
function selectRecord(value)
{
	$("#ulcategory li").hide();
	var $Category = $("#ulcategory li div").filter(":contains('"+$.trim(value)+"')");
	$Category.parent().show();
}