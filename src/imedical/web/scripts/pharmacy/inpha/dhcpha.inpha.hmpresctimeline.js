/*
模块:		草药房
子模块:		草药房-处方时间线
Creator:	MaYuqiang
CreateDate:	2020-08-27
*/
 
$(function(){
	
	InitBodyStyle();
})


function InitBodyStyle(){
	$('#container').empty();
	var prescheight=DhcphaJqGridHeight(1,1)+60;
	$("#container").height(prescheight);
	//$("#container").width(3000);
	getSummary(LoadPrescNo)
}


function getSummary(prescno)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: ChangeCspPathToAll(LINK_CSP)+"?ClassName=web.DHCINPHA.HMPresTrack.PresTrackQuery&MethodName=GetPresTrackJsonByPres&prescno="+prescno,
		async: true,
		data:"",
		success: function(d) {
			setSummary(eval("["+d+"]"));
		},
		error : function(d) { alert("获取追踪信息错误!");}
	});	
}

//显示追踪完成情况
function setSummary(data)
{
	var style = '<h2 class="first"><a class="more-history" href="#">处方时间轴</a></h2>';
	$('#container').append(style); 

	for (var i=0;i<data.length;i++)
	{
		var detial = '<h3><span class="fl">'+data[i].TPhaPreStatue+'</span><span class="fr"></b>'+data[i].TExecuteUser+'&nbsp;&nbsp;&nbsp;&nbsp;</b>'+data[i].TExeLoc+'</span></h3>'
		var content = $('<a href="#"></a>');
		$(content).append(detial);
		var tmpData ='<li class="green">'
		               +'<h3>'+data[i].TExecuteDate+'<span>'+data[i].TExecuteTime+'</span></h3>'
		               	+ $(content)[0].outerHTML
		            +'</li>';         
		$('#container').append(tmpData);           
	}
	systole();	
}

function systole(){
	if(!$(".history").length){
		return;
	}
	var $warpEle = $(".history-date"),
		parentH,
		eleTop = [];
	parentH = $warpEle.parent().height()*0.75;
	$warpEle.parent().css({"height":parentH});
	setTimeout(function(){
		$warpEle.find("ul").children(":not('h2')").each(function(idx){
			eleTop.push($(this).position().top);
			$(this).css({"margin-top":-eleTop[idx]}).children().hide();
		}).animate({"margin-top":0}, 1600).children().fadeIn();
		$("html,body").animate({"scrollTop":parentH}, 2600);
		$warpEle.parent().animate({"height":parentH}, 2600);
		$warpEle.find("ul").children(":not('h2')").addClass("bounceInDown").css({"-webkit-animation-duration":"2s","-webkit-animation-delay":"0","-webkit-animation-timing-function":"ease","-webkit-animation-fill-mode":"both"}).end().children("h2").css({"position":"relative"});	
	}, 500);
};

