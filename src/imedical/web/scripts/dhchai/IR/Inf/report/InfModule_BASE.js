function InitBase(obj){

	// 初始化就诊信息
	obj.AdmInfo = $.Tool.RunQuery('DHCHAI.DPS.PAAdmSrv','QryAdmInfo',EpisodeID);
	if (obj.AdmInfo!=''){
		if (obj.AdmInfo.total!=0){
			var AdmInfo = obj.AdmInfo.record[0];
			$.form.SetValue("txtPatName",AdmInfo.PatName);
			$.form.SetValue("txtPapmiNo",AdmInfo.PapmiNo);
			$.form.SetValue("txtMrNo",AdmInfo.MrNo);
			$.form.SetValue("txtAdmDate",AdmInfo.AdmDate);
			$.form.SetValue("txtDisDate",AdmInfo.DischDate);
			if (AdmInfo.IsDeath=='1'){
				$('#txtPatName').css('color','red');	// 死亡病人
			}
			
			$.form.SetValue("txtAdmitDiag",AdmInfo.AdmitDiag);
			$.form.SetValue("txtMainDiag",AdmInfo.MainDiag);
			$.form.SetValue("txtOtherDiag",AdmInfo.OtherDiag);
		}
	}
	$("#txtAdmitDiag").mouseover(function(){
		var AdmitDiag = $.form.GetValue("txtAdmitDiag");
		if (AdmitDiag!='') {
	 		layer.tips(AdmitDiag, '#txtAdmitDiag', {
	  			tips: [1, '#3595CC'],
	  			time: 2000
			});
		}
	});
	$("#txtMainDiag").mouseover(function(){
		var MainDiag = $.form.GetValue("txtMainDiag");
		if (MainDiag!='') {
	 		layer.tips(MainDiag, '#txtMainDiag', {
	  			tips: [1, '#3595CC'],
	  			time: 2000
			});
		}
	});
	$("#txtOtherDiag").mouseover(function(){
		var OtherDiag = $.form.GetValue("txtOtherDiag");
		if (OtherDiag!='') {
	 		layer.tips(OtherDiag, '#txtOtherDiag', {
	  			tips: [1, '#3595CC'],
	  			time: 2000
			});
		}
	});
	/*
	// 诊断
	var AdmitDiag='';
	var MainDiag = '';
	var OtherDiag = '';
	obj.Diag = $.Tool.RunQuery('DHCHAI.DPS.MRDiagnosSrv','QryDiagByEpisodeID',EpisodeID,'','C');
	if (obj.Diag!=''){
		if (obj.Diag.total!=0){
			var Diag = obj.Diag.record;
			for (var i = 0;i<Diag.length;i++){
				var DiagDesc =  Diag[i].DiagDesc;
				var DiagTpCode =  Diag[i].DiagTpCode;
				var DiagTpDesc =  Diag[i].DiagTpDesc;
				if (DiagTpCode=='3')		//入院诊断
				{
					AdmitDiag=(AdmitDiag==''?DiagDesc:AdmitDiag+','+DiagDesc);
				}
				else if (DiagTpCode=='4')		//主要诊断
				{
					MainDiag=(MainDiag==''?DiagDesc:MainDiag+','+DiagDesc);
				}else{		//其他诊断
					OtherDiag=(OtherDiag==''?DiagDesc:OtherDiag+','+DiagDesc);
				}
			}
		}
	}
	$.form.SetValue("txtAdmitDiag",AdmitDiag);
	$.form.SetValue("txtMainDiag",MainDiag);
	$.form.SetValue("txtOtherDiag",OtherDiag);
	*/
}