function InitCCSWorkWinEvent(obj){	
	obj.LoadEvent = function(args){
		setTimeout(function(){
			obj.LoadRep();
		},50);
		//��ѯ��ť
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
			ErrorStr += '��ѡ��ʼ����!<br/>';
		}
		if (DateTo == "") {
			ErrorStr += '��ѡ���������!<br/>';
		}
		if (DateFrom > DateTo) {
			ErrorStr += '��ʼ���ڲ��ܴ��ڽ�������!<br/>';
		}if (ErrorStr != '') {
			$.messager.alert("������ʾ",ErrorStr, 'info');
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
