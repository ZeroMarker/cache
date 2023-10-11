function InitDishTrendStatWinEvent(obj){
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
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aSubLocDr 	= $('#cboSubLoc').combobox('getValues').join(',');		
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
		
		//var aDateType 	= $('#cboDateType').combobox('getValue');
		ReportFrame = document.getElementById("ReportFrame");
		
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.DishTrendStat.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aStatUnit='+aStatUnit+'&aLocID='+aSubLocDr+'&aLocType='+aLocType+'&aPath='+cspPath;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}
	}
}
