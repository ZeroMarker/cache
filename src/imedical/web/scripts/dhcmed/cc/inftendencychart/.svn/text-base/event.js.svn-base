var CRChar=String.fromCharCode(13) + String.fromCharCode(10);
function InitWinControlEvent(obj){
	obj.intChartHeight = 350;
	obj.intChartWidth = 700;
	obj.arryData = null;

	
	
	obj.LoadEvent = function(args){
		obj.btnQuery.on("click", obj.btnQuery_click, obj);
		obj.radioDepTypeD.fireEvent("check");
		//obj.dfDateFrom.setValue("2012-01-01");
		obj.btnQuery_click();
	}
	
	obj.radioDepTypeD.on("check", 
		function(){
			if(obj.radioDepTypeD.getValue())
			{
				obj.cboWard.disable();
				obj.cboWard.clearValue();
				obj.cboLoc.enable();
			}
			else
			{
			obj.cboLoc.disable();
			obj.cboLoc.clearValue();
			obj.cboWard.enable();			
			}
		}
	, obj);


	obj.btnQuery_click = function(){
		var objIFrame = document.getElementById("pnResult");
		//var strUrl = "./dhccpmrunqianreport.csp?reportName=DHCMed.NINF.TendencyChart.raq" +
		var strUrl = "./dhccpmrunqianreportgroup.csp?reportName=DHCMed.NINF.TendencyChart.rpg" +
			"&FromDate=" + obj.dfDateFrom.getRawValue() +
			"&ToDate=" + obj.dfDateTo.getRawValue() +
			"&LocList=" + obj.cboLoc.getValue() +
			"&WardList=" + obj.cboWard.getValue();
			if(obj.radioDateType1.getValue())
				strUrl += "&DateGroup=1";
			if(obj.radioDateType2.getValue())
				strUrl += "&DateGroup=2";			
			if(obj.radioDepTypeD.getValue())
				strUrl += "&DepType=1";
			if(obj.radioDepTypeW.getValue())
				strUrl += "&DepType=2";	
		objIFrame.src = strUrl;
			
	}
	
}