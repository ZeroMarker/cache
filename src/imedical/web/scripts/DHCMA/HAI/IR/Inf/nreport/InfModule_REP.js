function InitRep(obj){

	//初始化感染报告易感因素信息
	obj.PreFactor = $cm({
		ClassName:"DHCHAI.BTS.PreFactorSrv",
		QueryName:"QueryPreFactor",	
		aIsNewborn:2,		
		aActive:1
	},false);
	var Prelen = obj.PreFactor.total;
	
	for (var m = 0; m < Prelen; m++) {
		var PreFactorID = obj.PreFactor.rows[m].ID;
		var PreFactorDesc = obj.PreFactor.rows[m].BTDesc;
		//处理特殊字符
		PreFactorDesc = PreFactorDesc.replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#39;");
		$("#chkPreFactor").append(
			 "<div style='float:left;width:25%'><input id=chkPreFactor"+PreFactorID+" type='checkbox' class='hisui-checkbox' "+" label="+PreFactorDesc+" name='chkPreFactor' value="+PreFactorID+"></div>"
		);
	}	
	$.parser.parse('#chkPreFactor');  //解析checkbox	
	
	//初始化感染诊断分类
	obj.InfPosEx = $cm({
		ClassName:"DHCHAI.BTS.InfSubSrv",
		QueryName:"QryInfPosExt",		
		aInfPos:"新生儿感染",
		aIsActive:1
	},false);
	var Sublen = obj.InfPosEx.total;
	
	for (var n = 0; n < Sublen; n++) {
		var InfSubID = obj.InfPosEx.rows[n].InfSubID;
		var InfSub = obj.InfPosEx.rows[n].InfSub;
		$("#chkInfPosExt").append(
			 "<div style='float:left;width:25%'><input id=chkInfPosExt"+InfSubID+" type='checkbox' class='hisui-checkbox' "+" label="+InfSub+" name='chkInfPosExt' value="+InfSubID+"></div>"
		);
	}	
	$.parser.parse('#chkInfPosExt');  //解析checkbox	
		
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
		//加载报告数据
        if (ReportID){	
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
			
			// 感染诊断
			obj.InfPosSub = $cm({
				ClassName:"DHCHAI.IRS.INFDiagnosSrv",
				QueryName:"QryINFDiagByRep",	
				aReportID:ReportID,		
				aEpisodeID:EpisodeID
			},false);
			
			for (var n=0;n<obj.InfPosSub.total;n++){
				$("#txtInfDate").datebox('setValue',obj.InfPosSub.rows[n].InfDate);
				var InfSubID = obj.InfPosSub.rows[n].InfSubID;
				var InfPosID = obj.InfPosSub.rows[n].ID;
				if (!InfSubID) return;
				var selector = '#chkInfPosExt'+InfSubID; 
				$(selector).attr('dataID',InfSubID);
				$(selector).checkbox('setValue',true);
			}
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
		InputRep = InputRep + CHR_1 + 2;
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
	
	obj.DIAG_Save = function(){
		var errorStr = '';
		// 感染日期
		var InfDate = $("#txtInfDate").datebox('getValue');
		var InfPosID = Common_CheckboxValue("chkInfPosExt");
		var AdmDate = obj.AdmInfo.rows[0].AdmDate;
		var DischDate = obj.AdmInfo.rows[0].DischDate;
		var NowDate = Common_GetDate(new Date()); 
		if (!InfPosID) {
			errorStr = errorStr + "请填写感染诊断分类!</br>"; 
		}
		if (!InfDate) {
			errorStr = errorStr + "请填写感染日期!</br>"; 
		}else {	
			if ((Common_CompareDate(AdmDate,InfDate)>0)||(Common_CompareDate(InfDate,DischDate)>0)||(Common_CompareDate(InfDate,NowDate)>0)) {
				errorStr = errorStr + "感染时间需要在住院期间且不应超出当前日期!</br>"; 
			}
		}
		if (errorStr!="") { 
			$.messager.alert("提示", errorStr, 'info');
			return; 
		}
		// 感染诊断
		var Diags='';
        var DiagID='';
	
		var InfPos = $cm({
			ClassName:"DHCHAI.BT.InfPos",
			MethodName:"GetIDByDesc",	
			aDesc:"新生儿感染"
		},false);
        $('input:checkbox',$("#chkInfPosExt")).each(function(){
       		if(true == $(this).is(':checked')){
				var InfSubID=($(this).attr("dataID")==undefined?'':$(this).attr("dataID"));
		
            	DiagID = $m({
					ClassName:"DHCHAI.IRS.INFDiagnosSrv",
					MethodName:"GetDiagID",	
					aReportID:ReportID,
					aInfSubID:InfSubID
				},false);
		       
				Input = (DiagID ? DiagID : '');
				Input = Input + CHR_1 + EpisodeID;
				Input = Input + CHR_1 + InfPos;
				Input = Input + CHR_1 + $(this).val();
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