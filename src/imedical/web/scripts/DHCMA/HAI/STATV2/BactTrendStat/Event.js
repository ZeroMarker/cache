function InitBactTrendWinEvent(obj){
   	obj.LoadEvent = function(args){
		$('#ReportFrame').css('display', 'block');
		setTimeout(function(){
			obj.LoadRep(1);
		},50);
		
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$('#ReportFrame').css('display', 'block');
			$('#EchartDiv').css('display', 'none');
			obj.LoadRep();
		});
   	}
	
   	obj.LoadRep = function(flag){
		var aHospID   = $('#cboHospital').combobox('getValues').join('|');
		var aStatUnit = $('#cboUnit').combobox('getValue');
		var FromYear  = $('#cboYearFrom').combobox('getValue');
		var ToYear    = $('#cboYearTo').combobox('getValue');
		var FromMonth = $('#cboMonthFrom').combobox('getValue');
		var ToMonth   = $('#cboMonthTo').combobox('getValue');
		var aDateFrom ="",aDateTo=""
		if (aStatUnit=="1") {    //月
			aDateFrom = FromYear+"-"+(FromMonth<10?('0'+FromMonth):FromMonth);
			aDateTo = ToYear+"-"+(ToMonth<10?('0'+ToMonth):ToMonth);
		}else if (aStatUnit=="2") {    //季度
		    var fm =FromMonth.split("JD")[1];
		    var tm =ToMonth.split("JD")[1];
			aDateFrom = FromYear+"-"+((fm*3-2)<10?('0'+(fm*3-2)):(fm*3-2));
			aDateTo = ToYear+"-"+((tm*3)<10?('0'+(tm*3)):(tm*3));
		}else {
			aDateFrom = FromYear;
			aDateTo = ToYear;
		}	
	
		var SubLocArr   = $('#cboSubLoc').combobox('getValues');
		var aSubLocIDs  = SubLocArr.join();
		var aBacteriaDr = obj.BacteriaDr;
		var aDateType 	= $('#cboDateType').combobox('getValue');
		var aDrugLevel 	= $('#cboDrugLevel').combobox('getValue');
		ReportFrame = document.getElementById("ReportFrame");
		var aStatType   = Common_CheckboxValue('chkStatunit');
		if (aStatType=="W"){
			aStatType=1;
		}else{
			aStatType=2;
		}
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		if ((aStatUnit==3)&&((aDateTo-aDateFrom)>3)){ //按年统计不能超过3年
			$.messager.alert("提示","统计开始结束日期不能超过三年！", 'info');
			return;
		}
		if ($('#cboInfType').combobox('getValue')==""){
			obj.TypeCode="";
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.BactTrendStat.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aDateType='+aDateType+'&aLocID='+aSubLocIDs+'&aBactID='+aBacteriaDr+'&aBactDesc='+obj.BactDesc+'&aDrugLevel='+aDrugLevel+'&aStatUnit='+aStatUnit+'&aTypeCode='+obj.TypeCode+'&aStatType='+aStatType+'&aPath='+cspPath;
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}
	}
	
}