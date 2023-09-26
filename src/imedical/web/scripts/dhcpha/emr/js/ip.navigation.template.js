$(function(){
    GetUserTemplate(locId);
    initLoc();
});

function initLoc()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLUserTemplateCTLoc",
			"Method":"GetUserTemplateCTLoc",
			"p1":docId,
			"p2":locId
		},
		success: function(d) {
			var data = eval(d);
			$("#selLocId").combobox({
				valueField:"RowID",
				textField:"Desc",
				data:data,
				onSelect:function(rec){
				GetUserTemplate(rec.RowID);
				}
			});
			$("#selLocId").combobox("setValue",locId);
		},
		error : function(d) { 
			alert("getTemplate error");
		}
	});	
}

///查询卡片///////////////////////////////////////////////////////////////
var search = {
	my_click:function(obj, myid)
	{
		if (document.getElementById(myid).value == document.getElementById(myid).defaultValue)
		{
			document.getElementById(myid).value = '';
			obj.style.color='#000';
		}
	},
	my_blur:function (obj, myid)
	{
		if (document.getElementById(myid).value == '')
		{
			document.getElementById(myid).value = document.getElementById(myid).defaultValue;
			obj.style.color='#999'
		}
	},
	my_keyDown:function (myid)
	{
		if(event.keyCode == 13)
		{
			var selectValue = document.getElementById(myid).value;
			var defaultValue = document.getElementById(myid).defaultValue;
			if (selectValue == defaultValue) selectValue = "";
			searchSelect(selectValue);
		}
	}
};

//查询
$("#search").click(function(){
	var selectValue = $("#searchInput").val();
	var defaultValue = $("#searchInput")[0].defaultValue;
	if (selectValue == defaultValue) selectValue = "";
	searchSelect(selectValue);
});

function searchSelect(value)
{
	$('.userTemplate').empty();
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLUserTemplate",
			"Method":"GetUserTemplateByCondition",
			"p1":docId,
			"p2":value
		},
		success: function(d) {
			setUserTemplate(eval("["+d+"]"));
		},
		error : function(d) { 
			alert("getUserTemplate error");
		}
	});	

}
//模板操作////////////////////////////////////////////////////////////
//取模板
function GetUserTemplate(tmpLocId)
{
	$('.userTemplate').empty();
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLUserTemplate",
			"Method":"GetUserTemplateJson",
			"p1":tmpLocId,
			"p2":docId,
			"p3":episodeId
		},
		success: function(d) {
			setUserTemplate(eval("["+d+"]"));
		},
		error : function(d) { 
			alert("getUserTemplate error");
		}
	});
}

//加载模板
function setUserTemplate(data)
{
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li></li>');
		$(link).attr({"code":data[i].Code,"titleCode":data[i].TitleCode,"templateId":data[i].TemplateID,"titleName":data[i].Name});
		var titleClass = "title";
		if (data[i].Type == "全院通用") titleClass = "title ty"
		$(link).append('<a href="#"><div class="'+titleClass+'">' +data[i].Name+ '</div><div class="loc">'+data[i].Type+'</div><div class="pinyin">'+data[i].SimpleSpel+'</div></a>');
		$('.userTemplate').append(link);
	}
}

$(".userTemplate").delegate("li","click",function(){
	var returnData = 
	{
	 	"code":$(this).attr("code"),
	 	"titleCode":$(this).attr("titleCode"),
	 	"titleName":$(this).attr("titleName")
	}
	if ($(this).attr("titleCode") != "") 
	{
		var titleConfig =  window.showModalDialog("emr.ip.navigation.template.title.csp?DocID="+docId+"&TitleCode="+$(this).attr("titleCode"),"","dialogHeight:300px;dialogWidth:400px;status:no");
		if (titleConfig != undefined)
		{
			returnData.titleName = titleConfig.title;
			returnData.dateTime = titleConfig.dateTime;
		}
		else
		{
			return;
		}
	}
	window.returnValue = returnData;
	closeWindow();
});

//关闭窗口
function closeWindow() {
    window.opener = null;
    window.open('', '_self');
    window.close();
}


