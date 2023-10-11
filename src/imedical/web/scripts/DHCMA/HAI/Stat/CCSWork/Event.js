function InitCCSWorkWinEvent(obj){	
	obj.LoadEvent = function(args){
		setTimeout(function(){
			obj.LoadRep();
		},50);
		//查询按钮
    	$("#btnQuery").on('click', function(){
	    	obj.LoadRep();
		});
   	}
   	
   	obj.LoadRep = function(){
	   	var ErrorStr="";
		var aHospID  = $("#cboHospital").combobox('getValue');
		var DateFrom = $("#DateFrom").datebox('getValue');
		var DateTo 	 = $("#DateTo").datebox('getValue');
		if (DateFrom=="") {
			ErrorStr += '请选择开始日期!<br/>';
		}
		if (DateTo == "") {
			ErrorStr += '请选择结束日期!<br/>';
		}
		if (DateFrom > DateTo) {
			ErrorStr += '开始日期不能大于结束日期!<br/>';
		}if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}
		ReportFrame = document.getElementById("ReportFrame");
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.Sta.CCSWork.raq&aHospIDs='+aHospID +'&aFromDate=' + DateFrom +'&aToDate='+ DateTo;	
		if ("undefined" !==typeof websys_getMWToken) {
			p_URL   += "&MWToken="+websys_getMWToken();
		}
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}
		
	}
}
