function InitBactDrugfastWinEvent(obj){
   	obj.LoadEvent = function(args){
		$('#ReportFrame').css('display', 'block');
		setTimeout(function(){
			obj.LoadRep(1);
		},50);
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$('#ReportFrame').css('display', 'block');
			obj.LoadRep();
		});
   	}
	
   	obj.LoadRep = function(flag){
		var aHospID 	= $('#cboHospital').combobox('getValue');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aSubLocDr 	= $('#cboSubLoc').combobox('getValue');
		var aBacteriaDr = obj.BacteriaDr;
		var aDateType 	= $('#cboDateType').combobox('getValue');
		var aDrugLevel 	= $('#cboDrugLevel').combobox('getValue');
		ReportFrame = document.getElementById("ReportFrame");
		if((aBacteriaDr=="")&&(flag!=1)){
			//$.messager.alert("提示","请选择细菌！", 'info');
			//return;
		}
		var cboInfType 	= $('#cboInfType').combobox('getValue');
		if (cboInfType==""){
			obj.TypeCode="";
		}
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.BactDrugfast.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aDateType='+aDateType+'&aLocID='+aSubLocDr+'&aBactID='+aBacteriaDr+'&aDrugLevel='+aDrugLevel+'&aTypeCode='+obj.TypeCode+'&aPath='+cspPath;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}
	}
}