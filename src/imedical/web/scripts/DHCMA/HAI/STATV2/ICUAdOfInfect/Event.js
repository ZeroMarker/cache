function InitICUTotalInfWinEvent(obj){
	obj.numbers = "ALL";
   	obj.LoadEvent = function(args){
		$('#ReportFrame').css('display', 'block');
   	    setTimeout(function () {
   	        obj.LoadRep();
   	    }, 50);

		
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$('#ReportFrame').css('display', 'block');
			$('#EchartDiv').css('display', 'none');
			obj.LoadRep();
		});
   	}
	
   	obj.LoadRep = function(){
		var aHospID = $('#cboHospital').combobox('getValues').join('|');
		var aLocIDs = $('#cboLoc').combobox('getValues').join(',');	
		var aYear   = $('#cboYear').combobox('getValue');
		var aMonth  = $('#cboMonth').combobox('getValue');
		if ((aYear=="")||(aMonth=="")){
			$.messager.alert("提示","请选择年、月！", 'info');
			return;
		}
		var DateFrom,DateTo="";
		if(aMonth=="QN"){
			DateFrom=aYear+"-"+"01";
			DateTo=aYear+"-"+"12";
		}
		else if(aMonth=="BN1"){
			DateFrom=aYear+"-"+"01";
			DateTo=aYear+"-"+"06";
		}
		else if(aMonth=="BN2"){
			DateFrom=aYear+"-"+"06";
			DateTo=aYear+"-"+"12";
		}
		else if(aMonth=="JD1"){
			DateFrom=aYear+"-"+"01";
			DateTo=aYear+"-"+"03";
		}
		else if(aMonth=="JD2"){
			DateFrom=aYear+"-"+"03";
			DateTo=aYear+"-"+"06";
		}
		else if(aMonth=="JD3"){
			DateFrom=aYear+"-"+"06";
			DateTo=aYear+"-"+"09";
		}
		else if(aMonth=="JD4"){
			DateFrom=aYear+"-"+"09";
			DateTo=aYear+"-"+"12";
		}
		else{
			DateFrom=aYear+"-"+aMonth;
			DateTo=aYear+"-"+aMonth;
		}
		
		var LocType = "W";
		ReportFrame = document.getElementById("ReportFrame");	
		
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.ICUAdOfInfect.raq&aHospIDs='+aHospID +'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo+'&aLocType='+LocType+'&aLocIDs='+aLocIDs+'&aPath='+cspPath;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}	
	}
}
