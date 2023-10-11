
function InitMED0101WinEvent(obj){
	// 默认加载报表文件
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMed.EPD.OPAdmLog.raq&aHospIDs='+"" +'&aDateFrom=' + "" +'&aDateTo='+ "";	
	ReportFrame.src = p_URL;
	//登记号补零 length位数
	var length=10;
	$("#txtPapmiNo").blur(function(){
		var PapmiNo	 = $("#txtPapmiNo").val();
		if(!PapmiNo) return;
		$("#txtPapmiNo").val((Array(length).join('0') + PapmiNo).slice(-length));  
		
　　});
	//查询按钮
	$("#btnQuery").on('click',function(){
		var aHospID  = $("#cboHospital").combobox("getValue");
		if (!aHospID){ aHospID="";}
		
	    var DateTimeFrom = $("#DateFrom").datetimebox("getValue");
		var DateTimeTo 	 = $("#DateTo").datetimebox("getValue");
		
		var arrDateTimeFrom = DateTimeFrom.split(" ")
		var DateFrom = arrDateTimeFrom[0]
		var TimeFrom = arrDateTimeFrom[1]
		var arrDateTimeTo = DateTimeTo.split(" ")
		var DateTo = arrDateTimeTo[0]
		var TimeTo = arrDateTimeTo[1]
				
		var LocID 	 = $("#cboLocation").combobox("getValues");	
		if (!LocID){ LocID=""; }
		
		var PapmiNo	 = $("#txtPapmiNo").val();
		var MrNo	 = $("#txtMrNo").val();
		var PatName	 = $("#txtPatName").val();
		var Diagnos	 = $('#txtDiagnos').lookup('getText')
		
		if ((DateFrom=="")||(DateTo=="")){
			$.messager.alert("错误提示",'请选择开始日期、结束日期！','info');
			return;
		}
		if(Common_CompareDate(DateFrom,DateTo)){
			$.messager.alert("错误提示",'开始日期应小于或等于结束日期！','info');
			return;
		}
		if ((DateFrom==DateTo)&&(TimeFrom>TimeTo)){
			$.messager.alert("错误提示",'同一日期开始时间不可大于结束时间！','info');
			return;
		}
		var flg=checkThreeTime(DateFrom,DateTo);
		if(!flg){
			$.messager.alert("错误提示",'查询日期间隔超过了三个月！','info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMed.EPD.OPAdmLog.raq&aHospIDs='+aHospID +'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aLoc='+ LocID+'&aPapmi='+ PapmiNo+'&aMrNo='+ MrNo +'&aName='+ PatName +'&aDiagnos='+ Diagnos+'&aTimeFrom='+TimeFrom+'&aTimeTo='+TimeTo;	
		ReportFrame.src = p_URL;
	});
		
}