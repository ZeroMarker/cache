function InitS800CssPosInfWinEvent(obj){	
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	$("#mCSB_2_container").css({"height":"99%"});
	// 默认加载报表文件	
	ReportFrame = document.getElementById("reportFrame");
	//根据系统参数取不同展示科室模式 1 =科室
	var retval = $.Tool.RunServerMethod("DHCHAI.BT.Config","GetValByCode","StatLocModel");	
	if(retval=="2"){
		//obj.repName = "";
	}
	p_URL = 'dhccpmrunqianreport.csp?reportName='+obj.repName+'&aSurNumID=' + "";	
	ReportFrame.src = p_URL;
	
	//查询按钮
    $("#btnQuery").on('click', function(){
	    var aHospID  = $.form.GetValue("cboHospital");
	    var aSurNum =$.form.GetText("cboSurvNumber");;
		var aSurNumID = $.form.GetValue("cboSurvNumber");;
		
		if (aSurNumID==""){
			layer.msg('请选择调查编号！');
			return;
		}
		
		p_URL = 'dhccpmrunqianreport.csp?reportName='+obj.repName+'&aSurNumID='+ aSurNumID;	
		ReportFrame.src = p_URL;
	});
}
