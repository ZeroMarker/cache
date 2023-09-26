$(function(){
	initCategory();
	//initQulaity();	// �������ʿػ������� ҩ��û���ʿ� qunianpeng 2018.6.12
	
	//Ŀ¼����¼�
	$(".navcategory li a").live('click',function(){
		categoryClick(this);
	});
});

//�Ӻ�̨���Ŀ¼����
function initCategory()
{
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"web.DHCCM.EMRservice.BL.BLClientCategory",
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

//����Ŀ¼��ϸ��ҳ��
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

/*
//Ŀ¼����¼�
$(".navcategory li a").live('click',function(){
	categoryClick(this);
});
*/

function categoryClick(obj)
{
	var type = $(obj).attr("type");
	var itemUrl = $(obj).attr("itemUrl");
	if (type == "EMR")
	{
		var categoryId = $(obj).attr("categoryId");
		if (itemUrl == "?")
		{
			if ($('#framTemplateRecord').attr("src").indexOf("dhcpha.clinical.record.library.templaterecord.csp")=="-1")
			{
				$('#framTemplateRecord').attr("src","dhcpha.clinical.record.library.templaterecord.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&CategoryID="+categoryId);
			}
			else
			{   if($.IEVersion()==-1){

				     window.frames["framTemplateRecord"].contentWindow.loadRecord(categoryId);
			    }
			    else{
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
				if($.IEVersion()==-1){

				     window.frames["framTemplateRecord"].contentWindow.loadRecord(categoryId);
			    }
			    else{
				     window.frames["framTemplateRecord"].loadRecord(categoryId);
			    }
			}			
		}
		parent.$("#sortName").text($(obj).text());
		parent.$("#sortName").attr("categoryId",categoryId);
	}
	else
	{
		//�򿪽ӿڲ���
		var id =  $(obj).attr("id");
		var itemName = $(obj)[0].innerText;
		parent.parent.openInterfaceRecord(id,itemName,itemUrl);
	}			
}

//�����ʿ�
function initQulaity()
{
	var href = "";
	var title = "";
 	if (isArchived == "0")
 	{
	 	//href = '../web.eprajax.qualityreport.cls?EpisodeID='+episodeID+'&RecordType='+isArchived+'&CTLocID='+userLocID+'&SSGroupID='+ssgroupID;
	 	href ="";
	 	title = "����";
	} 
	else
	{
		//href = '../web.eprajax.qualityreport.cls?EpisodeID='+episodeID+'&RecordType='+isArchived;
		href =""; 
		title = "��ĩ�ʿ�����";
	}
	qualityReport(title,href);
}

//�ʿ���Ϣ
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
//ˢ���ʿؼ�¼
function Refresh()
{
	var href = "";
 	if (isArchived == "0")
 	{
	 	//href = '../web.eprajax.qualityreport.cls?EpisodeID='+episodeID+'&RecordType='+isArchived+'&CTLocID='+userLocID+'&SSGroupID='+ssgroupID;
	 	href="";
	} 
	else
	{
		//href = '../web.eprajax.qualityreport.cls?EpisodeID='+episodeID+'&RecordType='+isArchived;
		href="";
	}
	$('#QualityRecord').panel('refresh',href);
}

function selectRecord(value)
{
	if($.IEVersion()==-1){

	    window.frames["framTemplateRecord"].contentWindow.selectRecord(value);	
	}
	else{
		  window.frames["framTemplateRecord"].selectRecord(value); 
	   }
}

function reLoadNav(categoryId)
{
	
	if($.IEVersion()==-1){

	    window.frames["framTemplateRecord"].contentWindow.loadRecord(categoryId);	
	}
	else{
		  window.frames["framTemplateRecord"].loadRecord(categoryId); 
	   }
}

