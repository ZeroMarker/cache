$(function(){
	getCategory();
	$(".categorytree input[type='checkbox']").attr('checked',true);
	$(".categorytree label").click(function(){
	   //获取当前菜单旁边input的check状态
	   var isChecked = $(this).next("input[type='checkbox']").is(':checked');
	   //展开和收齐的不同状态下更换右侧小图标
	   if(isChecked){
	       $(this).css(
	           "background-image","url(../scripts/emr/image/icon/down.png)"
	       );
	   }else{
	       $(this).css(
	           "background-image","url(../scripts/emr/image/icon/up.png)"
	       );
	   }
	});		
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
	var firstId = "";
	for (var i=0;i<data.length;i++)
	{
		if (data[i].children && data[i].children.length>0)
		{
			var li = $('<li></li>');
			var category = '<label for="folder'+data[i].id+'" class="folderOne">'+data[i].name+'</label><input type="checkbox" id="folder'+data[i].id+'"/>';
			$(li).append(category);
			var childul = $('<ol></ol>');
			for (var j=0;j<data[i].children.length;j++)
			{
				var tmpli = setContent(data[i].children[j]);
				$(childul).append(tmpli);
			}
			$(li).append(childul);
			$('#ulcategory').append(li);	
		}
		else
		{
			var li = setContent(data[i]);
			$('#ulcategory').append(li);
		}

		if (i == 0)
		{
			if (data[i].children == undefined)
			{
				firstId = data[0].id;
			}
			else
			{
				firstId = data[0].children[0].id;
			}
		}
	}
	initDoc(firstId);
}
function initDoc(initId)
{
	if (instanceID != "")
	{
		initId = instanceID;
	}
	selectListRecord(initId);
	var obj = $('.categorytree').find('li').filter('[id="'+initId+'"]');
	initRecord(obj);
	
}

function setContent(data)
{
	var li = $('<li class="file folderTwo"></li>');
	$(li).attr("id",data.id);
	$(li).attr("chartItemType",data.chartItemType);
	$(li).attr("pluginType",data.documentType);
	$(li).attr("emrDocId",data.emrDocId);
	$(li).attr("type",data.type);
	$(li).attr("characteristic",data.characteristic);
	var link = $('<a href="#"></a>');
	$(link).append($('<div></div>').append('<div class="title">'+$.trim(data.text)+'</div><div class="log"></div>'));
	var print = "";
	if (data.printstatus != "") print = "已打印";
	$(link).append($('<div></div>').append('<div class="date">'+data.happendate+' '+ data.happentime+'</div><div class="print">'+print+'</div>'));
    $(li).append(link);
    return li;
}

//显示病历操作记录明细
$(document).on("click",".navcategory li .log",function()
{
	var obj = $(this).closest("li");
	var instanceId = obj.attr("id");
	var docId = obj.attr("emrDocId");
	var Num = instanceId.split("||")[1];
	if ((action == "quality")||(action == "A")||(action == "D"))
	{
		if ((parent.parent.parent.parent.openBrowseRecordLog !=undefined)&&(typeof(parent.parent.parent.parent.openBrowseRecordLog)=="function"))
		{
			parent.parent.parent.parent.openBrowseRecordLog(episodeID,docId,Num)
		}
	}
	else
	{
		var logUrl = "emr.instancelog.csp?EpisodeID="+episodeID+"&EMRDocId="+docId+"&EMRNum="+Num;
		$('#logiframe').attr('src',logUrl);
		$HUI.dialog('#logdialog').open();
	}
});

//目录点击事件
$(document).on("click",".categorytree .folderTwo",function()
{
	//选中文档目录
	selectListRecord($(this).attr("id"));
	loadRecords(this);
});

//查询
 $('#selectCategory').searchbox({ 
    searcher:function(value,name){ selectRecord($.trim(value));}          
  });
//选中文档目录
function selectListRecord(id)
{
	$(".categorytree .folderTwo").each(function()
	{
		if ($(this).attr('id') == undefined) return;
		if($(this).attr('id')==id)
		{
			$(this).addClass("select");
			$(this).find(".title,.date,.print").addClass("whitefont");
		}
		else
		{
			$(this).removeClass("select");
			$(this).find(".title,.date,.print").removeClass("whitefont");
		}
	 });
}

//取调用数据
function setTempParam(obj)
{
	if ($(obj).attr("id") == undefined) return "";
	var id = $(obj).attr("id");
	var text = $(obj).text();
    var chartItemType = $(obj).attr("chartItemType");
    var pluginType = $(obj).attr("pluginType");
    var emrDocId = $(obj).attr("emrDocId");
    var characteristic = $(obj).attr("characteristic");
	var tempParam = {"id":id,"text":text,"chartItemType":chartItemType,"pluginType":pluginType,"emrDocId":emrDocId,"Path":path,"characteristic":characteristic,"status":"BROWSE"};
	return tempParam;
}

//初始化病历
function initRecord(obj)
{
	var tempParam = setTempParam(obj);
	if (tempParam == "") 
	{
		$("#browseContent").append('<img  src="../scripts/emr/image/icon/norecords.png"  alt="此患者无病历" />');
		return;
	}
	if('undefined' != typeof websys_getMWToken)
	{
		var src = "emr.record.browse.quality.browsform.editor.csp?id="+tempParam.id+"&text="+tempParam.text+"&chartItemType="+tempParam.chartItemType
        + "&pluginType="+tempParam.pluginType+"&emrDocId="+tempParam.emrDocId+"&characteristic="+tempParam.characteristic+"&Path="+tempParam.Path
        + "&characteristic=1" + "&status=BROWSE" + "&episodeId=" + episodeID + "&patientId=" + patientID + "&Action=" + action+"&MWToken="+websys_getMWToken();	
				
	}
	else
	{
		var src = "emr.record.browse.quality.browsform.editor.csp?id="+tempParam.id+"&text="+tempParam.text+"&chartItemType="+tempParam.chartItemType
        + "&pluginType="+tempParam.pluginType+"&emrDocId="+tempParam.emrDocId+"&characteristic="+tempParam.characteristic+"&Path="+tempParam.Path
        + "&characteristic=1" + "&status=BROWSE" + "&episodeId=" + episodeID + "&patientId=" + patientID + "&Action=" + action;	
	}
	var content = "<iframe id='frameBrowseContent' src='" + src + "' scrolling='no' width='100%' height='100%' frameborder='0'></iframe>";
	$('#browseContent').append(content);
}

//加载病历
function loadRecords(obj)
{
	
	if (document.getElementById("frameBrowseContent").contentWindow)
	{
		var tempParam = setTempParam(obj);
		if (tempParam == "") return;
		//window.frames["frameBrowseContent"].loadDocument(tempParam);
		document.getElementById("frameBrowseContent").contentWindow.loadDocument(tempParam);
	}
}

///检索当前病历
function selectRecord(value)
{
	if (value != "" && value != "请输入病历名称搜索")
	{
		$("#ulcategory li").hide();
		var $Category = $("#ulcategory>li>a>div>.title").filter(":contains('"+value+"')");
		$Category.parent().parent().parent().show();
		var $child = $("#ulcategory>li>ol>li>a>div>.title").filter(":contains('"+value+"')");
		$child.parent().parent().parent().parent().parent().show();
		$child.parent().parent().parent().show();

	}
	else
	{
		$("#ulcategory li").show();
	}
}

//获取HISUI病历浏览页面浏览的门诊病历实例ID
function getRefInsID()
{
    var insID = $('.categorytree').find('li').filter('[class="file folderTwo select"]').attr("id") || "";
    return insID;
}
