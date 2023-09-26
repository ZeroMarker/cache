function InitRep(obj){

	//初始化感染报告易感因素信息
	obj.PreFactor = $cm({
		ClassName:"DHCHAI.BTS.PreFactorSrv",
		QueryName:"QueryPreFactor",	
		aIsNewborn:1,		
		aActive:1
	},false)
	var Prelen = obj.PreFactor.total;
	
	for (var m = 0; m < Prelen; m++) {
		var PreFactorID = obj.PreFactor.rows[m].ID;
		var PreFactorDesc = obj.PreFactor.rows[m].BTDesc;
		//处理特殊字符
		PreFactorDesc = PreFactorDesc.replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#39;");
		$("#chkPreFactor").append(
			 "<div style='float:left;width:12.5%'><input id=chkPreFactor"+PreFactorID+" type='checkbox' class='hisui-checkbox' "+" label="+PreFactorDesc+" name='chkPreFactor' value="+PreFactorID+"></div>"
		);
	}	
	$.parser.parse('#chkPreFactor');  //解析checkbox	
	
	//初始化感染报告侵害性操作信息
	obj.InvasOper = $cm({
		ClassName:"DHCHAI.BTS.InvasOperSrv",
		QueryName:"QueryInvasOper",		
		aActive:1
	},false)
	var Invlen = obj.InvasOper.total;
	
	for (var n = 0; n < Invlen; n++) {
		var InvasOperID = obj.InvasOper.rows[n].ID;
		var InvasOperDesc = obj.InvasOper.rows[n].BTDesc;
		$("#chkInvasOper").append(
			 "<div style='float:left;width:12.5%'><input id=chkInvasOper"+InvasOperID+" type='checkbox' class='hisui-checkbox' "+" label="+InvasOperDesc+" name='chkInvasOper' value="+InvasOperID+"></div>"
		);
	}	
	$.parser.parse('#chkInvasOper');  //解析checkbox	
		
	obj.refreshReportInfo = function(){
		// 初始化报告主表信息
		obj.RepInfo = $cm({
			ClassName:"DHCHAI.IRS.INFReportSrv",
			QueryName:"QryRepInfo",		
			aRepotID: ReportID
		},false);
		if (obj.RepInfo.total>0) {
			var RepInfo = obj.RepInfo.rows[0];
			$('#txtRepDate').val(RepInfo.RepDate+ ' ' + RepInfo.RepTime);
			$('#txtRepLoc').val(RepInfo.RepLoc);
			$('#txtRepUser').val(RepInfo.RepUser);
			$('#txtRepStatus').val(RepInfo.RepStatus);
			obj.RepStatusCode = RepInfo.RepStatusCode;
		}
				
		//加载数据
		obj.InfPreFactor = $cm({
			ClassName:"DHCHAI.IRS.INFPreFactorSrv",
			QueryName:"QryPreFactorByRep",	
			aReportID:ReportID,		
			aEpisodeID:EpisodeID
		},false);
		
		for (var j=0;j<obj.InfPreFactor.total;j++){
			var PreFactorDicID = obj.InfPreFactor.rows[j].PreFactorID;
			var PreFactorID = obj.InfPreFactor.rows[j].ID;
			var selector = '#chkPreFactor'+PreFactorDicID;
			$(selector).attr('dataID',PreFactorID);
			$(selector).checkbox('setValue',true);
		}
		obj.InfInvasOper = $cm({
			ClassName:"DHCHAI.IRS.INFInvOperSrv",
			QueryName:"QryInvOperByRep",	
			aReportID:ReportID,		
			aEpisodeID:EpisodeID
		},false);
		
		for (var n=0;n<obj.InfInvasOper.total;n++){
			var InvOperDicID = obj.InfInvasOper.rows[n].InvOperID;
			var InvOperID = obj.InfInvasOper.rows[n].ID;
			var selector = '#chkInvasOper'+InvOperDicID;
			$(selector).attr('dataID',InvOperID);
			$(selector).checkbox('setValue',true);
		}
		
	}
	obj.refreshReportInfo();

	obj.Rep_Save = function (statusCode){
		var RepDate = '';
		var RepTime = '';
		var RepLoc  = $.LOGON.LOCID;
		var RepUser = $.LOGON.USERID;

		if (obj.AdminPower==1){  //管理员 不修改 报告科室、报告人、报告日期、报告时间 采用报告数据
			if (obj.RepInfo) { 
				RepDate = obj.RepInfo.rows[0].RepDate;
				RepTime = obj.RepInfo.rows[0].RepTime;
				RepLoc  = obj.RepInfo.rows[0].RepLocID;
				RepUser = obj.RepInfo.rows[0].RepUserID;
			}
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
    			Input = Input + CHR_1 + $(this).val();
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
    			Input = Input + CHR_1 + $(this).val();
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