//页面Gui
function InitPatScreeningWin(){
	var obj = new Object();	
	InitPatDtl(obj);
	
	obj.PatInfo=$cm ({
		ClassName:'DHCHAI.IRS.CCScreeningSrv',
		QueryName:'QrySuRulePatList',
		aTypeFlag:1,
		aPatInfo:"^^^^"+EpisodeDr
	},false);
	
	if (obj.PatInfo.total>0) {
		$('#divNoResult').attr("style","display:none");
		objAdm = obj.PatInfo.rows[0];
		obj.BuildPatIfo('','',objAdm,0);
	}else {
		$('#divNoResult').attr("style","display:block");
		$.messager.alert("提示", "患者信息加载失败，请检查!", 'info');
		return;
	}
    
	return obj;
}


