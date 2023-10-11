$(function(){
	$('#searchInput').searchbox({ 
	    searcher:function(value,name){ 
	    	serachRecord();
	    }          
	  });	
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
			setCategory(eval(d));
		},
		error : function(d) { alert(action+" error");}
	});		
}

//加载页面病历目录
function setCategory(data)
{
    if (data.length == 0)
    {
        return;
    }
    var isSelected = false;
	for (var i=0;i<data.length;i++)
	{
		var li = $('<li></li>');
		
		if (data[i].children)
		{
			if (data[i].children[0].characteristic == "1")
			{
				var link = $('<a>'+ data[i].name +'</a>');
				$(link).attr("id",data[i].children[0].id);
				$(link).attr("chartItemType",data[i].children[0].chartItemType);
				$(link).attr("pluginType",data[i].children[0].documentType);
				$(link).attr("emrDocId",data[i].children[0].emrDocId);
				$(link).attr("type",data[i].children[0].type);
				$(link).attr("characteristic",data[i].children[0].characteristic);
				$(link).attr("onclick","javascript:clickCategory(this)");
				$(li).append(link);
				$('.navcategory').append(li);
                if ((historyDefaultSelectDocID !== "")&&(historyDefaultSelectDocID == data[i].children[0].emrDocId))
				{
					initRecord(link); 	
					$(link).css('background-color','#CBE8F6');  
					isSelected = true;		
				}
			}
			else
			{
				for (var j=0;j<data[i].children.length;j++)
				{
					var tmpli = $('<li></li>');
					var link = $('<a>'+ data[i].children[j].text +'</a>');
					$(link).attr("id",data[i].children[j].id);
					$(link).attr("chartItemType",data[i].children[j].chartItemType);
					$(link).attr("pluginType",data[i].children[j].documentType);
					$(link).attr("emrDocId",data[i].children[j].emrDocId);
					$(link).attr("type",data[i].children[j].type);
					$(link).attr("characteristic",data[i].children[j].characteristic);
					$(link).attr("onclick","javascript:clickCategory(this)");
					$(tmpli).append(link);
					$('.navcategory').append(tmpli);
					if ((historyDefaultSelectDocID !== "")&&(historyDefaultSelectDocID == data[i].children[j].emrDocId))
					{
						initRecord(link); 	
						$(link).css('background-color','#CBE8F6');  
						isSelected = true;	
					}	                    
				}
			}
		}
		else
		{
			var link = $('<a>' + data[i].text +'</a>');
			$(link).attr("id",data[i].id);
			$(link).attr("chartItemType",data[i].chartItemType);
			$(link).attr("pluginType",data[i].documentType);
			$(link).attr("emrDocId",data[i].emrDocId);
			$(link).attr("type",data[i].type);
			$(link).attr("characteristic",data[i].characteristic);
			$(link).attr("onclick","javascript:clickCategory(this)");
			$(li).append(link);
			$('.navcategory').append(li);	
            if ((historyDefaultSelectDocID !== "")&&(historyDefaultSelectDocID == data[i].emrDocId))
			{
				initRecord(link); 	
				$(link).css('background-color','#CBE8F6');  
				isSelected = true;
			}
		}	
		if (i == 0)
		{
            var tmplink = link;
		}
	}	
    if (!isSelected) 
	{
		initRecord(tmplink); 	
		$(tmplink).css('background-color','#CBE8F6');  	
	}	
}
//目录点击事件
/* $(".navcategory li a").click(function(){
	//选中文档目录
	selectListRecord($(this).attr("id"));
	loadRecords(this);
}); 
*/

function clickCategory(obj)
{
	selectListRecord(obj.id);
	loadRecords(obj);
}

//选中文档目录
function selectListRecord(id)
{
	$(".navcategory li a").each(function()
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
        + "&pluginType="+tempParam.pluginType+"&emrDocId="+tempParam.emrDocId
        + "&characteristic="+tempParam.characteristic + "&status=BROWSE" + "&episodeId=" + episodeID + "&patientId=" + patientID + "&Action=" + action
        + "&MWToken="+getMWToken() ;	

	var content = "<iframe id='frameBrowseCategory' src='" + src + "' scrolling='no' width='100%' height='100%' frameborder='0'></iframe>";
	$('#InterfaceBrowseCategory').append(content);
}

//加载病历
function loadRecords(obj)
{
	if (document.getElementById("frameBrowseCategory"))
	{
	 	document.getElementById("frameBrowseCategory").contentWindow.loadDocument(setTempParam(obj));
	}
}

function GetBrowseStatus(episodeID)
{
	var result = "";
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.browse.cls",
		async: false,
		data: {"Action":"GetBrowseStatus","EpisodeID":episodeID},
		success: function(d) { result = eval("("+d+")");},
		error : function(d) { alert(action+" error");}
	});
	return result;
}

///查询//////////////////////////////////////////////////////////
//搜索框回车查询
$('#searchInput').searchbox({ 
    searcher:function(value,name){ 
    	serachRecord();
    }          
  });

//检索当前病历
function serachRecord()
{
	var serachValue = $('#searchInput').searchbox('getValue');
	$("#ulcategory li").hide();
	var $Category = $("#ulcategory li a").filter(":contains('"+$.trim(serachValue)+"')");
	$Category.parent().show();
}