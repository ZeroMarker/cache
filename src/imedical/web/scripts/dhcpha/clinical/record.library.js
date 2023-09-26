$(function(){
	loadContent();
	$("#ChangeShowMethod").combobox({
		valueField:'value',                        
		textField:'name',
		width:80,
		height:24,
		panelHeight:42,
		data:[{"value":"Picshow","name":"卡片视图","selected":true},
			  {"value":"listshow","name":"表格视图"}],
		onSelect:function(record)
		{
			if(!window.frames["framCategory"].frames["framTemplateRecord"]) return;
			window.frames["framCategory"].frames["framTemplateRecord"].loadRecord($("#sortName").attr("categoryId")); 
		}
	}); 
});

function loadContent()
{
    var templateRecord = '<iframe id = "framCategory" frameborder="0" src="dhcpha.clinical.record.library.category.csp?PatientID='+patientID+'&EpisodeID='+episodeID+'" style="width:100%; height:100%;scrolling:no;"></iframe>';
    addTab("tabCategory","药学项目导航",templateRecord,false,true);
	var welCome = '<iframe id = "framSummary" frameborder="0" src="dhcpha.clinical.record.library.summary.csp?PatientID="'+patientID+'&EpisodeID='+episodeID+'" '+'style="width:100%; height:100%;scrolling:no;"></iframe>';
	addTab("tabSummary","药学服务时间轴",welCome,false,false);	
}

//增加Tab
function addTab(id,title,content,closable,isSelect)
{
	$('#library').tabs('add',{
		id: id,
		title: title,
		content: content,
		closable: closable,
		selected: isSelect
	});		
}

$(function(){
	$('#library').tabs({
 		onSelect: function(title,index){
			var tab = $('#library').tabs('getTab',index);
			if (tab[0].id == "tabSummary")
			{
				$('#framSummary').attr("src","emr.record.library.summary.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&UserLocID="+userLocID);
			}
			if (tab[0].id == "tabCategory")
			{
				$('#tab-tools').css("display","inline");
			}
			else
			{
				$('#tab-tools').css("display","none");
			}
        }
	});	
});

//点击控件事件
function my_click(obj, myid)
{
	if (document.getElementById(myid).value == document.getElementById(myid).defaultValue)
	{
		document.getElementById(myid).value = '';
		obj.style.color='#000';
	}
}
//离开控件事件
function my_blur(obj, myid)
{
	if (document.getElementById(myid).value == '')
	{
		document.getElementById(myid).value = document.getElementById(myid).defaultValue;
		obj.style.color='#999'
	}
}
// 回车事件
function my_keyDown()
{
	if(event.keyCode==13)
    {
		serachRecord();                             
    }

}

$("#searchRecord").click(function(){
	serachRecord();
});

//病历检索
function serachRecord()
{
	if (!window.frames["framCategory"]) return;
	var selectValue = $("#searchInput").val();
	if (selectValue == $("#searchInput")[0].defaultValue)
	{
		selectValue = "";
	}
	window.frames["framCategory"].selectRecord(selectValue);	
}
