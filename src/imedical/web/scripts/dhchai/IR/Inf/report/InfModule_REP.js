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

		// 初始化感染报告侵害性操作信息
		obj.InfInvasOper = $.Tool.RunQuery('DHCHAI.IRS.INFInvOperSrv','QryInvOperByRep',ReportID,EpisodeID);
		for (var i=0;i<obj.InfInvasOper.total;i++){
			var InvOperDicID = obj.InfInvasOper.record[i].InvOperID;
			var InvOperID  = obj.InfInvasOper.record[i].ID;
			var selector = '#chkInvasOper '+'#'+InvOperDicID
			$(selector).attr('dataID',InvOperID);
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
		InputRep = InputRep + CHR_1 + 1;
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

	obj.InvasOper_Save = function(){
		// 侵害性操作
    	var InvasOpers='';
        $('input:checkbox',$("#chkInvasOper")).each(function(){
       		if(true == $(this).is(':checked')){
            	Input = ($(this).attr("dataID")==undefined?'':$(this).attr("dataID"));
            	Input = Input + CHR_1 + EpisodeID;
    			Input = Input + CHR_1 + $(this).attr("id");
    			Input = Input + CHR_1 + '';
    			Input = Input + CHR_1 + '';
    			Input = Input + CHR_1 + $.LOGON.USERID;
    			InvasOpers = InvasOpers + CHR_2 + Input;
       		}
    	});
    	if (InvasOpers) InvasOpers = InvasOpers.substring(1,InvasOpers.length);
    	return InvasOpers;
	}

	obj.RepLog_Save = function(statusCode){
		var Opinion = arguments[1];
		if (typeof(Opinion)=='undefined'){
			Opinion='';
		}
		var InputRepLog = ReportID;
		InputRepLog = InputRepLog + CHR_1 + statusCode;		//状态
		InputRepLog = InputRepLog + CHR_1 + Opinion;
		InputRepLog = InputRepLog + CHR_1 + $.LOGON.USERID;
    	return InputRepLog;
	}
}