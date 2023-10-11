/*---interbrowse内布局2---*/
function clickCategory(obj)
{
	selectListRecordInter(obj.id);
	loadRecords(obj);
}
//选中文档目录
function selectListRecordInter(id)
{
	$(".internavcategory li a").each(function()
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
//加载页面病历目录
function setCategoryInter(data)
{
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
				$('.internavcategory').append(li);
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
					$('.internavcategory').append(tmpli);
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
			$('.internavcategory').append(li);	
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
	//检索当前病历
	function serachRecord()
	{
		var serachValue = $('#interselectCategory').searchbox('getValue');
		$("#interulcategory li").hide();
		var $Category = $("#interulcategory li a").filter(":contains('"+$.trim(serachValue)+"')");
		$Category.parent().show();
	}