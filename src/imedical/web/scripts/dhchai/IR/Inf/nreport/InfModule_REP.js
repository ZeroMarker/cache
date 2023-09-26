function InitRep(obj){
	obj.refreshReportInfo = function(){
		// 初始化报告主表信息
		obj.RepInfo = $.Tool.RunQuery('DHCHAI.IRS.INFReportSrv','QryRepInfo',ReportID);
		if (obj.RepInfo!=''){
			if (obj.RepInfo.total!=0){
				var RepInfo = obj.RepInfo.record[0];
				$.form.SetValue("txtRepDate",RepInfo.RepDate+ ' ' + RepInfo.RepTime);
				$.form.SetValue("txtRepLoc",RepInfo.RepLoc);
				$.form.SetValue("txtRepUser",RepInfo.RepUser);
				$.form.SetValue("txtRepStatus",RepInfo.RepStatus);
				obj.RepStatusCode = RepInfo.RepStatusCode;
			}
		}

		// 初始化感染报告易感因素信息
		obj.InfPreFactor = $.Tool.RunQuery('DHCHAI.IRS.INFPreFactorSrv','QryPreFactorByRep',ReportID,EpisodeID);
		for (var i=0;i<obj.InfPreFactor.total;i++){
			var PreFactorDicID = obj.InfPreFactor.record[i].PreFactorID;
			var PreFactorID = obj.InfPreFactor.record[i].ID;
			var selector = '#chkPreFactor '+'#'+PreFactorDicID;
			$(selector).attr('dataID',PreFactorID);
			$(selector).iCheck('check');
		}

		// 初始化感染报告感染诊断
		obj.InfPosSub = $.Tool.RunQuery('DHCHAI.IRS.INFDiagnosSrv','QryINFDiagByRep',ReportID,EpisodeID);
		for (var i=0;i<obj.InfPosSub.total;i++){
			$.form.DateRender('txtInfDate',obj.InfPosSub.record[i].InfDate);
			var InfSubID  = obj.InfPosSub.record[i].InfSubID;
			if (!InfSubID) return;
			var selector = '#chkInfPosExt '+'#'+InfSubID;     //空格不能少
			$(selector).attr('dataID',InfSubID);
			$(selector).iCheck('check');
			
		}
	}
	obj.refreshReportInfo();

	obj.Rep_Save = function (statusCode){
		var RepDate = '';
		var RepTime = '';
		var RepLoc  = $.LOGON.LOCID;
		var RepUser = $.LOGON.USERID;

		if (obj.AdminPower==1){  //管理员 不修改 报告科室、报告人、报告日期、报告时间 采用报告数据
			RepDate = obj.RepInfo.record[0].RepDate;
			RepTime = obj.RepInfo.record[0].RepTime;
			RepLoc  = obj.RepInfo.record[0].RepLocID;
			RepUser = obj.RepInfo.record[0].RepUserID;
		}

		var InputRep = ReportID;
		InputRep = InputRep + CHR_1 + EpisodeID;
		InputRep = InputRep + CHR_1 + 2;                //新生儿感染报告
		InputRep = InputRep + CHR_1 + RepDate;
		InputRep = InputRep + CHR_1 + RepTime;
		InputRep = InputRep + CHR_1 + RepLoc;
		InputRep = InputRep + CHR_1 + RepUser;
		InputRep = InputRep + CHR_1 + statusCode;		//状态
    	return InputRep;
	}

	obj.PreFactor_Save = function(){
		// 易感因素
        var PreFactors='';
        $('input:checkbox',$("#chkPreFactor")).each(function(){
       		if(true == $(this).is(':checked')){
            	Input = ($(this).attr("dataID")==undefined?'':$(this).attr("dataID"));
            	Input = Input + CHR_1 + EpisodeID;
    			Input = Input + CHR_1 + $(this).attr("id");
    			Input = Input + CHR_1 + '';
    			Input = Input + CHR_1 + '';
    			Input = Input + CHR_1 + $.LOGON.USERID;
    			PreFactors = PreFactors + CHR_2 + Input;
       		}
    	});
    	if (PreFactors) PreFactors = PreFactors.substring(1,PreFactors.length);
    	return PreFactors;
	}

	obj.DIAG_Save = function(){
		// 感染日期
		var InfDate = $.form.GetValue("txtInfDate");
		// 感染诊断
		var Diags='';
        var DiagID='';
		var InfPos = $.Tool.RunServerMethod('DHCHAI.BT.InfPos','GetIDByDesc',"新生儿感染");
        $('input:checkbox',$("#chkInfPosExt")).each(function(){
       		if(true == $(this).is(':checked')){
            	//Input = ($(this).attr("dataID")==undefined?'':$(this).attr("dataID"));
            	var InfSubID=($(this).attr("dataID")==undefined?'':$(this).attr("dataID"))
            	DiagID= $.Tool.RunServerMethod('DHCHAI.IRS.INFDiagnosSrv','GetDiagID',ReportID,InfSubID);
				Input = DiagID;
				Input = Input + CHR_1 + EpisodeID;
				Input = Input + CHR_1 + InfPos;
				Input = Input + CHR_1 + $(this).attr("id");
				Input = Input + CHR_1 + InfDate;
				Input = Input + CHR_1 + '';
				Input = Input + CHR_1 + '';
				Input = Input + CHR_1 + '';
				Input = Input + CHR_1 + '';
				Input = Input + CHR_1 + '';
				Input = Input + CHR_1 + '';
				Input = Input + CHR_1 + '';
				Input = Input + CHR_1 + '';
				Input = Input + CHR_1 + $.LOGON.USERID;
				Input = Input + CHR_1 + '1';	// ????是否临床上报诊断
				Diags = Diags + CHR_2 + Input;
			}
		});
    	if (Diags) Diags = Diags.substring(1,Diags.length);
    	return Diags;
	}

	obj.RepLog_Save = function(statusCode){
		var InputRepLog = ReportID;
		InputRepLog = InputRepLog + CHR_1 + statusCode;		//状态
		InputRepLog = InputRepLog + CHR_1 + '';
		InputRepLog = InputRepLog + CHR_1 + $.LOGON.USERID;
    	return InputRepLog;
	}
}