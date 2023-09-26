function InitS410CssInfWinEvent(obj){	
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	$("#mCSB_2_container").css({"height":"99%"});
	// 默认加载报表文件	
	ReportFrame = document.getElementById("reportFrame");
	//根据系统参数取不同展示科室模式 1 =科室
	var retval = $.Tool.RunServerMethod("DHCHAI.BT.Config","GetValByCode","StatLocModel");	
	if(retval=="2"){
		obj.repName = "DHCHAI.STAT.S410CssInf2.raq";
	}
	p_URL = 'dhccpmrunqianreport.csp?reportName='+obj.repName+'&aHospIDs='+"" +'&aSurNumID=' + "" +'&aSurNum='+ ""+'&aLocModel='+retval;	
	ReportFrame.src = p_URL;
	
	//查询按钮
    $("#btnQuery").on('click', function(){
	    var aHospID  = $.form.GetValue("cboHospital");
	    var aSurNum =$.form.GetText("cboSurvNumber");;
		var aSurNumID= $.form.GetValue("cboSurvNumber");;
		
		if (aSurNumID==""){
			layer.msg('请选择调查编号！');
			return;
		}
		var surStr = $.Tool.RunServerMethod("DHCHAI.STAT.S410CssInf","GetSurInfo",aSurNumID);
		var aDateFrom = "";
		var aDateTo = "";
		if(surStr!="")
		{
			var arr = surStr.split("^");
			if(arr.length<3)
			{
				layer.msg('选择的调查编号定义数据异常！');
				return;
			}
			aDateFrom = arr[0];
			aDateTo = arr[1];
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName='+obj.repName+'&aHospIDs='+aHospID +'&aSurNum=' + aSurNum +'&aSurNumID='+ aSurNumID+'&aLocModel='+retval+"&aDateFrom="+aDateFrom+"&aDateTo="+aDateTo;	
		ReportFrame.src = p_URL;
	});
}
