var navPage ="";
var tool="";
$(function(){
	$('#allAndOftenKeyWord').keywords({
        singleSelect:true,
        items:[
            {text:emrTrans('全部'),id:'allBtn',selected:true},
            {text:emrTrans('常用模板'),id:'oftenBtn'}
        ],
        onSelect:function(v){
            toggleBtn(v.id);
        }
    });
	//初始化全选按钮样式
  	//$("#allBtn").addClass("selectFlag");
  	$('#cardAndListKeyWord').keywords({
        singleSelect:true,
        items:[
            {text:emrTrans('卡片视图'),id:'card'},
            {text:emrTrans('列表视图'),id:'list'}
        ],
        onClick:function(v){
            toggleBtn(v.id);
        }
    });
  	$('#opercardAndListKeyWord').keywords({
        singleSelect:true,
        items:[
            {text:emrTrans('卡片视图'),id:'operDard'},
            {text:emrTrans('列表视图'),id:'operList'}
        ],
        onClick:function(v){
            toggleBtn(v.id);
        }
    });    
	initToolbar();
	initNavPage();
	navPage = document.getElementById("framenav").contentWindow;
	tool= document.getElementById("frameTool").contentWindow;
});

///切换页签
function toggleBtn(tabId)
{
    if (tabId == "allBtn")
    {
	  init();
    }
    else if(tabId == "oftenBtn")
    {
	  filterOften();
    }
    else if(tabId == "card")
    {
	  setNavPage("","CARD","");
    }
    else if(tabId == "list")
    {
	  setNavPage("","LIST","");
    }    
    else if(tabId == "operDard")
    {
	    if('function' === typeof(navPage.setCardView))
	    {
		    navPage.setCardView();
		} 
    }
    else if(tabId == "operList")
    {
	    if('function' === typeof(navPage.setListView))
	    {
		   navPage.setListView(); 
		} 
    }     
}
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
	//navPage.init();
    navPage.xhrRefresh(gl.patientId,gl.episodeId,gl.categoryId);
}
function filterOften() {
	navPage.filterOftenIdx(gl.patientId,gl.episodeId,gl.categoryId);
}
///加载工具栏///////////////////////////////////
function initToolbar()
{
	var toolbar = '<iframe id="frameTool" frameborder="0" src="emr.ip.toolbar.csp?EpisodeID='+gl.episodeId+'&Position=card'+'&MWToken='+getMWToken()+'" frameborder="no" style="width:100%;height:100%;border:0;margin:0;padding:0;overflow:hidden"></iframe>';
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
	$('#sequence').text(desc);
}

///显示模式///////////////////////////////////////////////////////////////////////////

/* $("#card").click(function () {
	setDisplayType("CARD");
	setNavPage("","CARD","");
});

$("#list").click(function () {
	setDisplayType("LIST");
	setNavPage("","LIST","");
}); */

/* //手术相关专用，设置卡片/列表视图
$("#operDard").click(function () {
	setDisplayType("CARD","oper");
	navPage.setCardView();
});

$("#operList").click(function () {
	setDisplayType("LIST","oper");
	navPage.setListView();
}); */

//手术相关：病历关联手术
$("#operBatchContact").click(function () {
	navPage.setContact();
});
/* $("#allBtn").click(function () {
  setDisplay("allBtn", "oftenBtn");
  init();
});
$("#oftenBtn").click(function () {
  setDisplay("oftenBtn", "allBtn");
  filterOften();
}); */

///选中导航显示类型按钮
function setDisplay(check, nocheck) {
  $("#" + check).addClass("selectFlag");
  $("#" + nocheck).removeClass("selectFlag");
}

///选中导航显示类型按钮 2021-5-14重写

function setDisplayType(type,team)
{
	if (type == "LIST")
	{
		switch(team){
			case 'oper':$("#opercardAndListKeyWord").keywords("switchById","operList");break;
			default:$("#cardAndListKeyWord").keywords("switchById","list");break;
		}
	}
	else
	{
		switch(team){
			case 'oper':$("#opercardAndListKeyWord").keywords("switchById","operDard");break;
			default:$("#cardAndListKeyWord").keywords("switchById","card");break;
		}
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
		var team;
		if (param.ItemURL == "emr.ip.navigation.operation.csp")
		{
			team = "oper";
		}
		setDisplayType(param.DisplayType,team);
		
		setNavPage(param.Sequence,param.DisplayType,param.ItemURL);
	}
	
}

function xhrRefreshNavPage()
{
	var url = "";
	var team;
	var param = getNavParam();
	if (param != "")
	{
		url = param.ItemURL;
		if (url == "emr.ip.navigation.operation.csp")
		{
			team = "oper";
		}		 
	} 
	var type = getNavType();

	setDisplayType(type,team);

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
		$(".operdisplayspan").show();
		$("#recordSearch").css("right","273px")
	}
	else if (src == "emr.ip.navigation.templategroup.csp") 
	{
		$(".displayspan").hide();
		$(".operdisplayspan").hide();
	}
	else
	{
		$(".displayspan").show();
		$(".operdisplayspan").hide();
		src = (type == "LIST")?"emr.ip.navigation.list.csp":"emr.ip.navigation.card.csp"
		$("#recordSearch").css("right","227px");	
	}
	if ($("#framenav").attr("src") != src)
	{
		$("#framenav").attr("src",src +'?EpisodeID='+gl.episodeId+'&CategoryID='+gl.categoryId+'&Sequence='+sequence+'&DocID='+gl.docID+'&ViewType='+type+'&MWToken='+getMWToken());
	}
	else
	{
		init();
	}
}

function getNavType()
{
	var type = "CARD";
	if ($("#list").hasClass("selected")) type = "LIST";
	if ($("#operList").hasClass("selected")) type = "LIST";
	return type;

}

// "ASC"为"升序";"DESC"为"倒序";
function getNavSequence()
{
	var sequence = $("#sequence").attr("flag");
	return sequence;
}
