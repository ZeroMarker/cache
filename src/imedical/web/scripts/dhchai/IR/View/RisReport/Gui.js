
//页面Gui
function InitRisReportWin(){
	var obj = new Object();
	obj.RBReport = $.Tool.RunQuery("DHCHAI.IRS.CCRMEWordSrv","QryRBReport",PaadmID,"","");
	if (obj.RBReport.total==0){	//没有数据显示提示
		$(".col-sm-12.col-xs-12").css("text-align","center");
		$(".col-sm-12.col-xs-12 div").remove();
		var htm = "";
		htm +='<img class="no_result"></img>'
		$(".col-sm-12.col-xs-12").append(htm);
		return obj;
	}else{
		$(".col-sm-12.col-xs-12 div").remove();
		for (var i=obj.RBReport.total-1;i>=0;i--){
			var ReportID = obj.RBReport.record[i].ReportID;
			var CheckItem = obj.RBReport.record[i].CheckItem;
			var ExamDesc = obj.RBReport.record[i].ExamDesc;
			var ResultDesc = obj.RBReport.record[i].ResultDesc;
			var RegDate = obj.RBReport.record[i].RegDate;
			var RegTime = obj.RBReport.record[i].RegTime;
			var RepDate = obj.RBReport.record[i].RepDate;
			var RepTime = obj.RBReport.record[i].RepTime;
			var RepUser = obj.RBReport.record[i].RepUser;

			var htm="";
			htm+='<div class="report"><table class="onereport">';
			htm+='<tr class="Item"><td colspan= 2>'+CheckItem+'</td></tr>';
			htm+='<tr><td class="title">检查所见：</td><td class="examdesc"><p>'+ExamDesc;
			htm+='</p></td></tr>';
			htm+='<tr><td class="title">诊断意见：</td><td><p class="course">'+ResultDesc+'</p></td></tr>';
			//htm+='<tr class="sign" ><td colspan= 2>'+ '登记日期：' + RegDate + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;报告日期：' + RepDate + ' ' + RepUser+ '</td></tr>';
            //平台接口没有登记时间
			htm+='<tr class="sign" ><td colspan= 2>'+ '报告日期：' + RepDate + ' ' + RepUser+ '</td></tr>';
			htm+='</table></div>';
			$(".col-sm-12.col-xs-12").append(htm);
		}
	}
	
	$("body").mCustomScrollbar({
		//scrollButtons: { enable: true },
		//autoHideScrollbar: true,
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	InitRisReportWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
