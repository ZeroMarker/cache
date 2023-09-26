$(function(){
	loadContent();
	initCategoryShow();
});

function loadContent()
{
    var templateRecord = '<iframe id = "framCategory" frameborder="0" src="emr.record.library.category.csp?PatientID='+patientID+'&EpisodeID='+episodeID+'" style="width:100%; height:100%;scrolling:no;"></iframe>';
    addTab("tabCategory","病历导航",templateRecord,false,true);
	var welCome = '<iframe id = "framSummary" frameborder="0" src="emr.record.library.summary.csp?PatientID="'+patientID+'&EpisodeID='+episodeID+'" '+'style="width:100%; height:100%;scrolling:no;"></iframe>';
	addTab("tabSummary","病历时间轴",welCome,false,false);	
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

//初始化病历目录视图显示
function initCategoryShow()
{
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLUserPageConfig",
			"Method":"GetViewDisplayData"
		},
		success: function(d) {
			if(d != "") initViewShow(eval("["+d+"]"));
		},
		error : function(d) { 
			alert("GetViewDisplayData error");
		}
	});
}

//初始化视图显示
function initViewShow(data)
{
	$("#ChangeShowMethod").combobox({
		valueField:'value',                        
		textField:'name',
		width:90,
		height:22,
		panelHeight:82,
		data:data,
		onBeforeLoad:function()
		{
			//获取视图显示配置
			getViewDisplayConfig();
			$("#ChangeShowMethod").combobox('setValue',viewDisplayConfig);
		},
		onSelect:function(record)
		{
			if(!window.frames["framCategory"].frames["framTemplateRecord"]) return;
			window.frames["framCategory"].frames["framTemplateRecord"].loadRecord($("#sortName").attr("categoryId")); 
			//保存视图显示配置
			viewFlag = true;
			viewDisplayConfig = record.value;
		}
	});
}
//获取视图显示配置
function getViewDisplayConfig()
{
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLUserPageConfig",
			"Method":"GetViewDisplayConfig",
			"p1":userID,
			"p2":userLocID
		},
		success: function(d) {
			if(d != "") viewDisplayConfig = d;
		},
		error : function(d) { 
			alert("GetViewDisplayConfig error");
		}
	});
}

//保存视图显示配置
function saveViewDisplayConfig()
{
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLUserPageConfig",
			"Method":"SaveViewDisplayConfig",
			"p1":userID,
			"p2":userName,
			"p3":userLocID,
			"p4":viewDisplayConfig
		},
		success: function(d) {
			if(d == "0")
			{
				alert("UnSaveViewDisplayConfig");
			}
		},
		error : function(d) { 
			alert("SaveViewDisplayConfig error");
		}
	});
}

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

//刷新或关闭页面操作
window.onbeforeunload = function(){
	if (viewFlag)
	{
		//保存视图显示配置
		saveViewDisplayConfig();
	}
}
