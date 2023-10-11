
//页面Gui
function InitRisReportWin(){
	var obj = new Object();
    var res = $cm({
        ClassName: "DHCHAI.IRS.CCRMEWordSrv",
        QueryName: "QryRBReport",
        aEpisodeID: PaadmID,
        page: 1,
        rows: 99999
        }, false);
	
	if (res.total==0){	//没有数据显示提示
		$(".mainarea").css("text-align","center");
		$(".mainarea div").remove();
		var htm = "";
		htm +='<img class="no_result"></img>'
		$(".mainarea").append(htm);
		return obj;
	}else{
		$(".mainarea div").remove();
		for (var i=res.total-1;i>=0;i--){
            obj.RBReport=res;
			var ReportID = obj.RBReport.rows[i].ReportID;
			var CheckItem = obj.RBReport.rows[i].CheckItem;
			var ExamDesc = obj.RBReport.rows[i].ExamDesc;
			var ResultDesc = obj.RBReport.rows[i].ResultDesc;
			var RepDate = obj.RBReport.rows[i].RepDate;
			var RepTime = obj.RBReport.rows[i].RepTime;
			var RepUser = obj.RBReport.rows[i].RepUser;

			var htm="";
			htm+='<div class="report" ><table class="onereport">';
			htm+='<tr class="Item"><td colspan= 2>'+CheckItem+'</td></tr>';
			htm+='<tr><td class="title">检查所见：</td><td class="examdesc"><p>'+ExamDesc;
			htm+='</p></td></tr>';
			htm+='<tr><td class="title">诊断意见：</td><td><p class="course">'+ResultDesc+'</p></td></tr>';
			//htm+='<tr class="sign" ><td colspan= 2>'+ '登记日期：' + RegDate + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;报告日期：' + RepDate + ' ' + RepUser+ '</td></tr>';
            //平台接口没有登记时间
			htm+='<tr class="sign" ><td colspan= 2>'+ '报告日期：' + RepDate + ' ' + RepUser+ '</td></tr>';
			htm+='</table></div>';
			$(".mainarea").append(htm);
		}
	}
	InitRisReportWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}