function InitS411CssBloodWinEvent(obj){
   	obj.LoadEvent = function(args){
		
		$('#ReportFrame').css('display', 'block');
		setTimeout(function(){
			obj.LoadRep();
		},50);
		
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$('#ReportFrame').css('display', 'block');
			obj.LoadRep();
		});
   	}
   	obj.LoadRep = function(){
	   	
		var SurNumID 	= $('#cboSurNum').combobox('getValue');	
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs = $('#cboLoc').combobox('getValues').join(',');	
		ReportFrame = document.getElementById("ReportFrame");
		
		p_URL =  Append_Url('dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S411CssBlood.raq&aSurNumID='+SurNumID +'&aStaType=' + aLocType);	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 
		
	}
	obj.up=function(x,y){
        return y.OpUseCnt-x.OpUseCnt		//根据手术人数排序
    }
}