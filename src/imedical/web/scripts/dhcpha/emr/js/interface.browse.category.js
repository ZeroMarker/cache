$(function(){
	getCategory();	
});

//ȡ����Ŀ¼
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
//����ҳ�没��Ŀ¼
function setCategory(data)
{
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
				
				$(li).append(link);
				$('.navcategory').append(li);
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
					$(tmpli).append(link);
					$('.navcategory').append(tmpli);	
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
			$(li).append(link);
			$('.navcategory').append(li);	
		}	
		if (i == 0)
		{
			initRecord(link); 	
			$(link).css('background-color','#CBE8F6');  	
		}
	}	
}
//Ŀ¼����¼�
$(".navcategory li a").live('click',function(){
	//ѡ���ĵ�Ŀ¼
	selectListRecord($(this).attr("id"));
	loadRecords(this);
});

//ѡ���ĵ�Ŀ¼
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

//ȡ��������
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

//��ʼ������
function initRecord(obj)
{
	var tempParam = setTempParam(obj);
	var src = "emr.record.browse.browsform.editor.csp?id="+tempParam.id+"&text="+tempParam.text+"&chartItemType="+tempParam.chartItemType
        + "&pluginType="+tempParam.pluginType+"&emrDocId="+tempParam.emrDocId
        + "&characteristic="+tempParam.characteristic + "&status=BROWSE" + "&episodeId=" + episodeID + "&patientId=" + patientID;	

	var content = "<iframe id='frameBrowseCategory' src='" + src + "' scrolling='no' width='100%' height='100%' frameborder='0'></iframe>";
	$('#InterfaceBrowseCategory').append(content);
}

//���ز���
function loadRecords(obj)
{
	if (window.frames["frameBrowseCategory"])
	{
	 	window.frames["frameBrowseCategory"].loadDocument(setTempParam(obj));
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

//����ؼ��¼�
function my_click(obj, myid)
{
	if (document.getElementById(myid).value == document.getElementById(myid).defaultValue)
	{
		document.getElementById(myid).value = '';
		obj.style.color='#000';
	}
}
//�뿪�ؼ��¼�
function my_blur(obj, myid)
{
	if (document.getElementById(myid).value == '')
	{
		document.getElementById(myid).value = document.getElementById(myid).defaultValue;
		obj.style.color='#999';
	}
}
// �س��¼�
function my_keyDown()
{
	if(event.keyCode==13)
    {
		serachRecord();
    }

}
//��������
$("#searchRecord").click(function(){
	serachRecord();
});
//������ǰ����
function serachRecord()
{
	var serachValue = $("#searchInput").val();
	if (serachValue == $("#searchInput")[0].defaultValue)
	{
		serachValue = "";
	}
	$("#ulcategory li").hide();
	var $Category = $("#ulcategory li a").filter(":contains('"+$.trim(serachValue)+"')");
	$Category.parent().show();
}