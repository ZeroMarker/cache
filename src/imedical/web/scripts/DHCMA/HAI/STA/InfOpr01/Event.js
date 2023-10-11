function InitOpr01InfWinEvent(obj){
   	obj.LoadEvent = function(args){ 
   	    setTimeout(function () {
   	        obj.LoadRep();
   	    }, 50);
		//表的点击事件
		$('#btnSearch').on('click',function(e,value){
			obj.LoadRep();
		});
   	}

   	obj.LoadRep = function(){
		var aHospID = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var DateType= $('#cboDateType').combobox('getValue');
		var OperCat  = $('#cboOperCat').combobox('getValue');
		
		ReportFrame = document.getElementById("ReportFrame");
		if(DateFrom > DateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((DateFrom=="")||(DateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.Sta.InfOpr01.raq&aHospIDs='+aHospID +'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo+'&aDateType='+DateType+'&aOperCat='+OperCat;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}	
	}
  
}
