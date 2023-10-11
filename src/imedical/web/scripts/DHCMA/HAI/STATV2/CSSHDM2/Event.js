function InitCSSHDM2WinEvent(obj){
   	obj.LoadEvent = function(args){
		$('#ReportFrame').css('display', 'block');
		setTimeout(function(){
			obj.LoadRep();
		},50);
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$('#ReportFrame').css('display', 'block');
			$('#EchartDiv').css('display', 'none');
			obj.LoadRep();
		});
   	}
   	obj.LoadRep = function(){
		var aSurNumID 	= $('#cboSurvNumber').combobox('getValue');
		var aInfTypeStr = $('#cboInfType').combobox('getText');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.HDMSta2.raq&aSurNumID='+aSurNumID +'&aInfTypeStr=' + aInfTypeStr +'&aLocType='+ aLocType;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}
		
	}
}