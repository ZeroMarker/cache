//页面Event
function InitMED0101WinEvent(obj){
    obj.LoadEvent = function(args){ 
		$("#btnQuery").on('click', function(){
			obj.btnQuery();
		});
		ReportFrame = document.getElementById("report");
		obj.btnQuery();
		/*p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMed.DTH.MonReport.raq&HospID='+"" +'&StartDate=' + "" +'&EndDate='+ "";	
		ReportFrame.src = p_URL;*/
    }
	//查询按钮
    obj.btnQuery = function(){
		var errinfo = "";
	    var HospID  = $("#cboHospital").combobox('getValue');
	    var StartDate = $("#StartDate").datebox('getValue');
		var EndDate   = $("#EndDate").datebox('getValue');	
		var NowDate   = Common_GetDate(new Date());		
		//var User=$.LOGON.USERDESC;
		if (!StartDate) {
			errinfo = errinfo + "开始日期为空!<br>";
		}
		if (!EndDate) {
			errinfo = errinfo + "结束日期为空!<br>";
		}
		if (Common_CompareDate(StartDate,NowDate)>0) {
			errinfo = errinfo + "开始日期不允许大于当前日期!<br>";
		}
		if (Common_CompareDate(EndDate,NowDate)>0) {
			errinfo = errinfo + "结束日期不允许大于当前日期!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		if (Common_CompareDate(StartDate,EndDate)>0) {
			$.messager.alert("错误提示", "开始日期应小于或等于结束日期！<br>", 'info');
			return 
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMed.DTH.MonReport.raq&HospID='+HospID +'&StartDate=' + StartDate +'&EndDate='+ EndDate;	
		ReportFrame.src = p_URL;
	};
	
}