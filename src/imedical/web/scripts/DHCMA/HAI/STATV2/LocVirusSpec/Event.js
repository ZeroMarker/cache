function InitLocVirusSpecWinEvent(obj){
   	obj.LoadEvent = function(args){
		$('#ReportFrame').css('display', 'block');
	
		setTimeout(function(){
			obj.LoadRep();
		},50);
		//图的点击事件
		$('#btnSearchChart').on('click',function(e,value){
			$('#EchartDiv').css('display', 'block');
			$('#ReportFrame').css('display', 'none');
			obj.LoadChaert();
		});
		
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$('#ReportFrame').css('display', 'block');
			$('#EchartDiv').css('display', 'none');
			obj.LoadRep();
		});
   	}
	obj.LoadChaert = function(){
		var aHospID 	= $('#cboHospital').combobox('getValue');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aStatNum 	= 99999;
		var aDateType 	= $('#cboDateType').combobox('getValue');
		var aStatUnit   = Common_CheckboxValue('chkStatunit');
		var aVirusTest  = $('#cboVirusTest').combobox('getValues');
		if (aStatUnit=="W"){
			aStatUnit=1;
		}else{
			aStatUnit=2;
		}
		ReportFrame = document.getElementById("Echarts");
		
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		if (!$('#cboSpec').lookup('getText')) {
			$('#cboSpec').lookup('clear');
			obj.SpecDr ="";
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.LocVirusChart.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aDateType='+aDateType+'&aSpecID='+obj.SpecDr+'&aStatNum='+""+'&aStatUnit='+aStatUnit+'&aVirusTest='+aVirusTest+'&aLocID='+""+'&aAbFlag='+"1";
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}
	}
	
   	obj.LoadRep = function(){
		var aHospID 	= $('#cboHospital').combobox('getValue');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aStatNum 	= $('#cboStatNum').combobox('getText');
		var aDateType 	= $('#cboDateType').combobox('getValue');
		var aStatUnit   = Common_CheckboxValue('chkStatunit');
		var aVirusTest  = $('#cboVirusTest').combobox('getValues');
		if (aStatUnit=="W"){
			aStatUnit=1;
		}else{
			aStatUnit=2;
		}
		ReportFrame = document.getElementById("ReportFrame");
		
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		if (!$('#cboSpec').lookup('getText')) {
			$('#cboSpec').lookup('clear');
			obj.SpecDr ="";
		}
		
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.LocVirusSpec.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aDateType='+aDateType+'&aSpecID='+obj.SpecDr+'&aStatNum='+aStatNum+'&aStatUnit='+aStatUnit+'&aVirusTest='+aVirusTest+'&aLocID='+"";
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}
	}
	
	obj.up=function(x,y){
        return y.InfPatCnt-x.InfPatCnt
    }
	
}