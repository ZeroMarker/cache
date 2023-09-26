var navPage ="";
var tool="";
$(function(){
	initToolbar();
	initNavPage();
	navPage = document.getElementById("framenav").contentWindow;
	tool= document.getElementById("frameTool").contentWindow;
});

///加载卡片///////////////////////////////////////////////////////////////////////////////////////////////////////////
function xhrRefresh(patientId,episodeId,categoryId)
{
	gl.patientId = patientId;
	gl.episodeId = episodeId;
	gl.categoryId = categoryId;
	xhrRefreshNavPage();
	$('#searchRecord').searchbox('setValue', '');
}

function changeCategoryId(categoryId)
{
	gl.categoryId = categoryId;
	//window.frames["framenav"].gl.categoryId = categoryId;
	document.getElementById("framenav").contentWindow.changeCategoryId(categoryId);
}

function init()
{
	//window.frames["framenav"].init();
	navPage.init();
}

///加载工具栏///////////////////////////////////
function initToolbar()
{
	var toolbar = '<iframe id="frameTool" frameborder="0" src="emr.ip.toolbar.csp?EpisodeID='+gl.episodeId+'&Position=card" frameborder="no" style="width:100%;height:100%;border:0;margin:0;padding:0;overflow:hidden"></iframe>';
	$('#nav').layout('panel', 'north').panel().append(toolbar);	
}
function setButtonStatus()
{
    //window.frames["frameTool"].setOtherButtonPrivilege();
    tool.setOtherButtonPrivilege();
}
///隐藏或显示工具栏
function hideToolbar(status)
{
	if (status == "hide")
	{
		$('#nav').layout('panel', 'north').panel('resize',{height:35});
	}
	else
	{
		$('#nav').layout('panel', 'north').panel('resize',{height:110});
	}
	$('#nav').layout('resize');
}

///查询/////////////////////////////////////////////////////////////
 $('#searchRecord').searchbox({ 
    searcher:function(value,name){ 
    	search(value); 
    }          
  });
  
 function search(value)
 {
	 navPage.searchSelect(value);  
 }

///排序///////////////////////////////////////////////////////////////
$("#sequence").click(function(){
	var sequence = $("#sequence").attr("flag");
	if (sequence == "DESC")
	{
		setSequence("ASC");
		sequence = "ASC";
	}
	else
	{
		setSequence("DESC");
		sequence = "DESC";
	}
	var type = getNavType();
	setNavPage(sequence,type,"");
	
});

function setSequence(sequence)
{
	$("#sequence").attr("flag",sequence);
	var desc = "升序";
	if (sequence == "DESC") desc = "倒序";
	$('#sequence').linkbutton({text:desc});
}

///显示模式///////////////////////////////////////////////////////////////////////////

$("#card").click(function () {
	setDisplayType("CARD");
	setNavPage("","CARD","");
});

$("#list").click(function () {
	setDisplayType("LIST");
	setNavPage("","LIST","");
});

///选中导航显示类型按钮
function setDisplayType(type)
{
	if (type == "LIST")
	{
		$("#card").removeClass("selectFlag");
		$("#list").addClass("selectFlag"); 
	}
	else
	{
		$("#list").removeClass("selectFlag");
		$("#card").addClass("selectFlag"); 
	}	
}

///加载导航/////////////////////////////////////////////////////////////////////////
//初始化导航
function initNavPage()
{
	var param = getNavParam();
	if (param != "")
	{
		setSequence(param.Sequence);
		setDisplayType(param.DisplayType);
		
		setNavPage(param.Sequence,param.DisplayType,param.ItemURL);
	}
	
}

function xhrRefreshNavPage()
{
	var url = "";
	var param = getNavParam();
	if (param != "") url = param.ItemURL; 
	var type = getNavType();
	setNavPage("",type,url);
}

function getNavParam()
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"GetNavParam",
			"p1":gl.categoryId,
			"p2":gl.userId,
			"p3":gl.userLocId
		},
		success: function(d) {
			result = JSON.stringify(d)=="{}"?"":d;
		},
		error : function(d) { 
			alert("initNavPage error");
		}
	});
	return result;	
}

//加载导航页签
function setNavPage(sequence,type,src)
{
	if (sequence == "") sequence = $("#sequence").attr("flag");
	if (src == "emr.ip.navigation.operation.csp") 
	{
		$(".displayspan").hide();
	}
	else if (src == "emr.ip.navigation.templategroup.csp") 
	{
		$(".displayspan").hide();
	}
	else
	{
		$(".displayspan").show();
		src = (type == "LIST")?"emr.ip.navigation.list.csp":"emr.ip.navigation.card.csp"	
	}
	$("#framenav").attr("src",src +'?EpisodeID='+gl.episodeId+'&CategoryID='+gl.categoryId+'&Sequence='+sequence+'&DocID='+gl.docID);
}

function getNavType()
{
	var type = "CARD";
	if ($("#list").hasClass("selectFlag")) type = "LIST";
	return type;

}

// "ASC"为"升序";"DESC"为"倒序";
function getNavSequence()
{
	var sequence = $("#sequence").attr("flag");
	return sequence;
}
