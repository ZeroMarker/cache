$(function(){
	getSummary();
});

//取索引目录数据
function getSummary()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"GetRecordCatalogByHappenDate",
			"p1":episodeID,
			"p2":"save",
			"p3":"",
			"p4":recordSequence.TimeLineRecord
		},
		success: function(d) {
			setSummary(eval("["+d+"]"));
		},
		error : function(d) { alert(action+"GetSummary error");}
	});	
}
//显示病历完成情况
function setSummary(data)
{
	$('#container').empty();
	var style = '<h2 class="first"><a class="more-history" href="#">'+patientName+'的病历时间轴</a></h2>';
	$('#container').append(style); 
	for (var i=0;i<data.length;i++)
	{
		var detial = '<h3><span class="fl">'+data[i].text+'</span><span class="fr">状态:</b>'+data[i].status+'</span></h3>'
		            +'<p class="con">'+data[i].summary+'</p>';
		var content = $('<a href="#"></a>');
		$(content).append(detial);
		$(content).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].isLeadframe});
		$(content).attr({"chartItemType":data[i].chartItemType,"documentType":data[i].documentType});           
		$(content).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":data[i].categoryId,"templateId":data[i].templateId});
		var tmpData ='<li class="green">'
		               +'<h3>'+data[i].happendate+'<span>'+data[i].happentime+'</span></h3>'
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
	
	parentH = $warpEle.parent().height() + 130;
	$warpEle.parent().css({"height":59});
	
	setTimeout(function(){
		$warpEle.find("ul").children(":not('h2')").each(function(idx){
			eleTop.push($(this).position().top);
			$(this).css({"margin-top":-eleTop[idx]}).children().hide();
		}).animate({"margin-top":0}, 1600).children().fadeIn();
		$("html,body").animate({"scrollTop":parentH}, 2600);
		$warpEle.parent().animate({"height":parentH}, 2600);
		$warpEle.find("ul").children(":not('h2')").addClass("bounceInDown").css({"-webkit-animation-duration":"2s","-webkit-animation-delay":"0","-webkit-animation-timing-function":"ease","-webkit-animation-fill-mode":"both"}).end().children("h2").css({"position":"relative"});	
	}, 600);
};

$("#container>li>a").live('click',function(){
	    var tabParam ={
			"id":$(this).attr("id"),
			"text":$(this).attr("text"),
			"pluginType":$(this).attr("documentType"),
			"chartItemType":$(this).attr("chartItemType"),
			"emrDocId":$(this).attr("emrDocId"),
			"templateId":$(this).attr("templateId"),
			"isLeadframe":$(this).attr("isLeadframe"),
			"isMutex":$(this).attr("isMutex"),
			"categoryId":$(this).attr("categoryId"),
			"actionType":"LOAD",
			"status":"NORMAL",
			"closable":true
    	 }; 	
	parent.parent.operateRecord(tabParam);
	if (IsSetToLog == "Y")
	{
		var ipAddress = getIpAddress();
		var ModelName = "EMR.Nav.RecordTimeline.Open";
		var Condition = "";
		Condition = Condition + '{"patientID":"' + patientID + '",';
		Condition = Condition + '"episodeID":"' + episodeID + '",';
		Condition = Condition + '"userName":"' + userName + '",';
		Condition = Condition + '"userID":"' + userID + '",';
		Condition = Condition + '"ipAddress":"' + ipAddress + '",';
		Condition = Condition + '"id":"' + tabParam["id"] + '",';
		Condition = Condition + '"pluginType":"' + tabParam["pluginType"] + '",';
		Condition = Condition + '"chartItemType":"' + tabParam["chartItemType"] + '",';
		Condition = Condition + '"emrDocId":"' + tabParam["emrDocId"] + '",';
		Condition = Condition + '"categoryId":"' + tabParam["categoryId"] + '",';
		Condition = Condition + '"templateId":"' + $(this).attr("templateId") + '",';
		Condition = Condition + '"isLeadframe":"' + tabParam["isLeadframe"] + '",';
		Condition = Condition + '"isMutex":"' + tabParam["isMutex"] + '",';
		Condition = Condition + '"actionType":"' + tabParam["actionType"] + '",';
		Condition = Condition + '"text":"' + tabParam["text"] + '"}';
		var ConditionAndContent = Condition;
		$.ajax({ 
			type: "POST", 
			url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
			data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + SecCode
		});
	}
});