function InitBase(obj){

	// 初始化就诊信息
	obj.AdmInfo = $.Tool.RunQuery('DHCHAI.DPS.PAAdmSrv','QryPatAdm','',EpisodeID);
	if (obj.AdmInfo!=''){
		if (obj.AdmInfo.total!=0){
			var AdmInfo = obj.AdmInfo.record[0]
			$.form.SetValue("txtPatName",AdmInfo.PatName);
			$.form.SetValue("txtPapmiNo",AdmInfo.PapmiNo);
			$.form.SetValue("txtMrNo",AdmInfo.MrNo);
			$.form.SetValue("txtAdmDate",AdmInfo.AdmDate);
			$.form.SetValue("txtDisDate",AdmInfo.DischDate);
			if (AdmInfo.IsDeath=='1'){
				$('#txtPatName').css('color','red');	// 死亡病人
			}
		}
	}

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
				if (DiagTpCode=='PRE')		//入院诊断
				{
					AdmitDiag=(AdmitDiag==''?DiagDesc:AdmitDiag+','+DiagDesc);
				}
				else if (DiagTpCode=='Main')		//主要诊断
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

	// 初始化报告主表信息
	obj.RepInfo = $.Tool.RunQuery('DHCHAI.IRS.INFReportSrv','QryRepInfo',ReportID);
	if (obj.RepInfo!=''){
		if (obj.RepInfo.total!=0){
			var RepInfo = obj.RepInfo.record[0]
			$.form.SetValue("txtRepDate",RepInfo.RepDate);
			$.form.SetValue("txtRepLoc",RepInfo.RepLoc);
			$.form.SetValue("txtRepUser",RepInfo.RepUser);
			$.form.SetValue("txtRepStatus",RepInfo.RepStatus);
		}
	}
	obj.Rep_SaveBase = function (){
		// 主表信息
		var InputRep = ReportID;
		InputRep = InputRep + CHR_1 + EpisodeID;
		InputRep = InputRep + CHR_1 + 4;  //手术切口调查
		InputRep = InputRep + CHR_1 + (ReportID==''?'':$.form.GetText('txtRepDate').split(' - ')[0]);
		InputRep = InputRep + CHR_1 + (ReportID==''?'':$.form.GetText('txtRepDate').split(' - ')[1]);;
		InputRep = InputRep + CHR_1 + $.LOGON.LOCID;
		InputRep = InputRep + CHR_1 + $.LOGON.USERID;
		InputRep = InputRep + CHR_1 + 1;		//状态
    	return InputRep;
	}
}