$(function(){
	initCategory();
	initQulaity();
});﻿

//从后台获得目录数据
function initCategory()
{
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"GetCategoryJson",
			"p1":userLocID,
			"p2":ssgroupID,
			"p3":episodeID
		},
		success: function(d){
			setCategory(eval("["+d+"]"));
		},
		error: function(d){
			alert("error");
		}
	});
}

//加载目录明细到页面
function setCategory(data)
{
	for (var i=0;i<data.length;i++)
	{
		var li = $('<li></li>');
		var link = $('<a>'+ data[i].text +'</a>');
		$(link).attr("id",data[i].id);       
		$(link).attr("href","javascript:void(0);");
		$(link).attr("categoryId",data[i].attributes.categoryId);
		$(link).attr("itemUrl",data[i].attributes.itemUrl);
		$(link).attr("type",data[i].attributes.type); 
		$(li).append(link);  
		$('.navcategory').append(li);
		if (i == 0 && data[i].attributes.type == "EMR")
		{
			categoryClick(link);
		}
	}
}

//目录点击事件
$(".navcategory li a").live('click',function(){
	categoryClick(this);
});

function categoryClick(obj)
{
	var type = $(obj).attr("type");
	var itemUrl = $(obj).attr("itemUrl");
	if (type == "EMR")
	{
		var categoryId = $(obj).attr("categoryId");
		if (itemUrl == "?")
		{
			//病历导航页面卡片是否分类显示
			if (cardClassificationDisplay == "Y")
			{
				if ($('#framTemplateRecord').attr("src").indexOf("emr.record.library.templaterecord.classification.csp")=="-1")
				{
					$('#framTemplateRecord').attr("src","emr.record.library.templaterecord.classification.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&CategoryID="+categoryId);
				}
				else
				{
					window.frames["framTemplateRecord"].loadRecord(categoryId);
				}
			}
			else
			{
				if ($('#framTemplateRecord').attr("src").indexOf("emr.record.library.templaterecord.csp")=="-1")
				{
					$('#framTemplateRecord').attr("src","emr.record.library.templaterecord.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&CategoryID="+categoryId);
				}
				else
				{
					window.frames["framTemplateRecord"].loadRecord(categoryId);
				}
			}	
		}
		else
		{
			if ($('#framTemplateRecord').attr("src").indexOf(itemUrl)=="-1")
			{
				$('#framTemplateRecord').attr("src",itemUrl+"PatientID="+patientID+"&EpisodeID="+episodeID+"&CategoryID="+categoryId);
			}
			else
			{
				window.frames["framTemplateRecord"].loadRecord(categoryId);
			}			
		}
		parent.$("#sortName").text($(obj).text());
		parent.$("#sortName").attr("categoryId",categoryId);
	}
	else
	{
		//打开接口病历
		var id =  $(obj).attr("id");
		var itemName = $(obj)[0].innerText;
		parent.parent.openInterfaceRecord(id,itemName,itemUrl);
	}			
}

//加载质控
function initQulaity()
{
	var href = "";
	var title = "";
 	if (isArchived == "0")
 	{
	 	href = '../web.eprajax.qualityreport.cls?EpisodeID='+episodeID+'&RecordType='+isArchived+'&CTLocID='+userLocID+'&SSGroupID='+ssgroupID;
	 	title = "提醒";
	} 
	else
	{
		href = '../web.eprajax.qualityreport.cls?EpisodeID='+episodeID+'&RecordType='+isArchived; 
		title = "终末质控评价";
	}
	qualityReport(title,href);
}

//质控信息
function qualityReport(title,href)
{
	$('.easyui-layout .easyui-layout').layout('add',{
		id: 'QualityRecord',
	    region: 'north',  
	    height: 120,  
	    title: title, 
	    closedTitle: title, 
	    split: true,
	    border: false,
	    iconCls: "icon-tip",
		href: href,
		tools: '#layout-tools'
	});
}
//刷新质控记录
function Refresh()
{
	var href = "";
 	if (isArchived == "0")
 	{
	 	href = '../web.eprajax.qualityreport.cls?EpisodeID='+episodeID+'&RecordType='+isArchived+'&CTLocID='+userLocID+'&SSGroupID='+ssgroupID;
	} 
	else
	{
		href = '../web.eprajax.qualityreport.cls?EpisodeID='+episodeID+'&RecordType='+isArchived;
	}
	$('#QualityRecord').panel('refresh',href);
}

function selectRecord(value)
{
	window.frames["framTemplateRecord"].selectRecord(value);
}

function reLoadNav(categoryId)
{
	window.frames["framTemplateRecord"].loadRecord(categoryId);
}

