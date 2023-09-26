
//页面Gui
function InitEmrCourseWin(){
	var obj = new Object();
	obj.DateLine = $.Tool.RunQuery("DHCHAI.DPS.EmrRecordSrv","QryDocDate",PaadmID,"");
	if (obj.DateLine.total==0){		//没有数据显示提示
		$(".main").css("text-align","center");
		$(".main div").remove();
		$(".main ul").remove();
		var htm = "";
		htm +='<img class="no_result"/>'
		$(".main").append(htm);
		return obj;
	}else{
		$(".timeline_ul div").remove();
		$(".content li").remove();
		for (var i=(obj.DateLine.total-1);i>=0;i--)
		{
			var tmp = obj.DateLine.record[i].DocDate;
			var htm="";
			if (i==0){
				htm+='<div class="timeline_ul_div_0">';
			}else{
				htm+='<div class="timeline_ul_div">';
			}
			if (i==(obj.DateLine.total-1)){
				htm+='<li><div class="greenspot"></div><span style="color:#02C486;">';
			}else{
				htm+='<li><div class="grayspot"></div><span>';
			}
			htm+=tmp;
			htm+='</span id="span_' + i + '"></li></div>';
			$(".timeline_ul").append(htm);
		}
	}
	InitEmrCourseWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
