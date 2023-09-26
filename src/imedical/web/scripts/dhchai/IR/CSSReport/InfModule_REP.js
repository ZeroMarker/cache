function InitRep(obj){

	obj.refreshReportInfo = function(){
		// 初始化报告主表信息
		obj.RepInfo = $.Tool.RunQuery('DHCHAI.IRS.INFReportSrv','QryRepInfo',ReportID);
		if (obj.RepInfo!=''){
			if (obj.RepInfo.total!=0){
				var RepInfo = obj.RepInfo.record[0]
				$.form.SetValue("txtRepDate",RepInfo.RepDate+ ' ' + RepInfo.RepTime);
				$.form.SetValue("txtRepLoc",RepInfo.RepLoc);
				$.form.SetValue("txtRepUser",RepInfo.RepUser);
				$.form.SetValue("txtRepStatus",RepInfo.RepStatus);
				obj.RepStatusCode = RepInfo.RepStatusCode;
			}
		}
		// 初始化横断面信息
		obj.InfCSS = $.Tool.RunQuery('DHCHAI.IRS.INFCSSSrv','QryCSSByPaadm',EpisodeID,SurvNumber);
		if (obj.InfCSS!=''){
			if (obj.InfCSS.total!=0){
				var CSSInfo = obj.InfCSS.record[0];				
				//$.form.SetValue("txtCROBSDiarrhea",CSSInfo.OBSCnt=="1");
				$.form.SetValue("cboIRInfectionDr",CSSInfo.InfectionDr,"");
				$.form.SetValue("cboInfCategoryDr",CSSInfo.InfCateDr,"");
				$.form.SetValue("cboCSSDiagnos",CSSInfo.DiagnosDr,""); 
				$.form.SetValue("cboYYInfPos11",CSSInfo.YYInfPos11Dr,"");
				$("#cboYYBacteria11").append(new Option(CSSInfo.YYBacteria11Desc,CSSInfo.YYBacteria11Dr, false, true));
				$.form.SetValue("cboYYMDR11",CSSInfo.YYMDR11Dr,"");
				$("#cboYYBacteria12").append(new Option(CSSInfo.YYBacteria12Desc,CSSInfo.YYBacteria12Dr, false, true));
				$.form.SetValue("cboYYMDR12",CSSInfo.YYMDR12Dr,"");
				$("#cboYYBacteria13").append(new Option(CSSInfo.YYBacteria13Desc,CSSInfo.YYBacteria13Dr, false, true));
				$.form.SetValue("cboYYMDR13",CSSInfo.YYMDR13Dr,"");
				
				$.form.SetValue("cboYYInfPos21",CSSInfo.YYInfPos21Dr,"");
				$("#cboYYBacteria21").append(new Option(CSSInfo.YYBacteria21Desc,CSSInfo.YYBacteria21Dr, false, true));
				$.form.SetValue("cboYYMDR21",CSSInfo.YYMDR21Dr,"");
				$("#cboYYBacteria22").append(new Option(CSSInfo.YYBacteria22Desc,CSSInfo.YYBacteria22Dr, false, true));
				$.form.SetValue("cboYYMDR22",CSSInfo.YYMDR22Dr,"");
				$("#cboYYBacteria23").append(new Option(CSSInfo.YYBacteria23Desc,CSSInfo.YYBacteria23Dr, false, true));
				$.form.SetValue("cboYYMDR23",CSSInfo.YYMDR23Dr,"");
				
				$.form.SetValue("cboYYInfPos31",CSSInfo.YYInfPos31Dr,"");
				$("#cboYYBacteria31").append(new Option(CSSInfo.YYBacteria31Desc,CSSInfo.YYBacteria31Dr, false, true));
				$.form.SetValue("cboYYMDR31",CSSInfo.YYMDR31Dr,"");
				$("#cboYYBacteria32").append(new Option(CSSInfo.YYBacteria32Desc,CSSInfo.YYBacteria32Dr, false, true));
				$.form.SetValue("cboYYMDR32",CSSInfo.YYMDR32Dr,"");
				$("#cboYYBacteria33").append(new Option(CSSInfo.YYBacteria33Desc,CSSInfo.YYBacteria33Dr, false, true));
				$.form.SetValue("cboYYMDR33",CSSInfo.YYMDR33Dr,"");
				
				$.form.SetValue('cboCSSOperLung',CSSInfo.OprInfDr,"");
				
				if (CSSInfo.IRComInfPathogen1){
					var arrIRComInf = CSSInfo.IRComInfPathogen1.split('#');
					$.form.SetValue("cboSQInfPos11",arrIRComInf[0],"");
					var BactDesc = $.Tool.RunServerMethod("DHCHAI.DPS.LabBactSrv", "GetBacteriaById", arrIRComInf[1]);
					$("#cboSQBacteria11").append(new Option(BactDesc,arrIRComInf[1],false,true));
					$.form.SetValue("cboSQMDR11",arrIRComInf[2],"");
					var BactDesc = $.Tool.RunServerMethod("DHCHAI.DPS.LabBactSrv", "GetBacteriaById", arrIRComInf[3]);
					$("#cboSQBacteria12").append(new Option(BactDesc,arrIRComInf[3],false,true));
					$.form.SetValue("cboSQMDR12",arrIRComInf[4],"");
					var BactDesc = $.Tool.RunServerMethod("DHCHAI.DPS.LabBactSrv", "GetBacteriaById", arrIRComInf[5]);
					$("#cboSQBacteria13").append(new Option(BactDesc,arrIRComInf[5],false,true));
					$.form.SetValue("cboSQMDR13",arrIRComInf[6],"");
				}
				if (CSSInfo.IRComInfPathogen2){
					var arrIRComInf = CSSInfo.IRComInfPathogen2.split('#');
					$.form.SetValue("cboSQInfPos21",arrIRComInf[0],"");
					var BactDesc = $.Tool.RunServerMethod("DHCHAI.DPS.LabBactSrv", "GetBacteriaById", arrIRComInf[1]);
					$("#cboSQBacteria21").append(new Option(BactDesc,arrIRComInf[1],false,true));
					$.form.SetValue("cboSQMDR21",arrIRComInf[2],"");
					var BactDesc = $.Tool.RunServerMethod("DHCHAI.DPS.LabBactSrv", "GetBacteriaById", arrIRComInf[3]);
					$("#cboSQBacteria22").append(new Option(BactDesc,arrIRComInf[3],false,true));
					$.form.SetValue("cboSQMDR22",arrIRComInf[4],"");
					var BactDesc = $.Tool.RunServerMethod("DHCHAI.DPS.LabBactSrv", "GetBacteriaById", arrIRComInf[5]);
					$("#cboSQBacteria23").append(new Option(BactDesc,arrIRComInf[5],false,true));
					$.form.SetValue("cboSQMDR23",arrIRComInf[6],"");
				}
				if (CSSInfo.IRComInfPathogen3){
					var arrIRComInf = CSSInfo.IRComInfPathogen3.split('#');
					$.form.SetValue("cboSQInfPos31",arrIRComInf[0],"");
					var BactDesc = $.Tool.RunServerMethod("DHCHAI.DPS.LabBactSrv", "GetBacteriaById", arrIRComInf[1]);
					$("#cboSQBacteria31").append(new Option(BactDesc,arrIRComInf[1],false,true));
					$.form.SetValue("cboSQMDR31",arrIRComInf[2],"");
					var BactDesc = $.Tool.RunServerMethod("DHCHAI.DPS.LabBactSrv", "GetBacteriaById", arrIRComInf[3]);
					$("#cboSQBacteria32").append(new Option(BactDesc,arrIRComInf[3],false,true));
					$.form.SetValue("cboSQMDR32",arrIRComInf[4],"");
					var BactDesc = $.Tool.RunServerMethod("DHCHAI.DPS.LabBactSrv", "GetBacteriaById", arrIRComInf[5]);
					$("#cboSQBacteria33").append(new Option(BactDesc,arrIRComInf[5],false,true));
					$.form.SetValue("cboSQMDR33",arrIRComInf[6],"");
				}
				var IRBugsAntiSen = CSSInfo.IRBugsAntiSen;
				if (IRBugsAntiSen){
					var arrBugsAntiSen = IRBugsAntiSen.split('#');
					if (arrBugsAntiSen.length>8){
						for (var indX=0; indX<arrBugsAntiSen.length; indX++){
							var strItem = arrBugsAntiSen[indX];
							var arrItem = strItem.split('||');
							for (var indY=1; indY<arrItem.length; indY++){
								$.form.SetValue("cbgAntiSen"+(indX+1)+indY,arrItem[indY],"");
							}
						}
					}
				}
				
				//是否手术
				$.form.SetValue("chkCSSIsOpr",CSSInfo.OperFlag==1);
				$.form.SetValue('cboCSSIncisionr',CSSInfo.CuteTypeID,CSSInfo.CuteType);
				$.form.DateRender('OperDate',CSSInfo.IROperDate);
				$.form.SetValue("txtOperName",CSSInfo.IROperName);
				if (CSSInfo.IROperName==""){
					setTimeout(obj.OPRinitset,3*1000);
				}
				
				//是否抗菌药物
				$.form.SetValue('chkCSSIsAnti',CSSInfo.IRAntiFlag==1);
				
				$("#cboCSSAntiName").empty();
				var IRAntiDrList= CSSInfo.IRAntiDrList;
				if (IRAntiDrList!=""){
					var AntiArry = IRAntiDrList.split(",");
					for (var j = 0; j< AntiArry.length; j++){
						var AntiDr = AntiArry[j];
						var AntiDesc = $.Tool.RunServerMethod("DHCHAI.DPS.LabAntiSrv","GetAntiDescByID",AntiDr);
						if (AntiDesc=="") continue;
						$("#cboCSSAntiName").append(new Option(AntiDesc,AntiDr,false,true));
					}
				}
				
				$.form.SetValue('cboCSSMedPurpose',CSSInfo.PurposeDr,CSSInfo.PurposeDesc);
				$.form.SetValue('cboCSSCombinedMed',CSSInfo.CombinDr,CSSInfo.CombinDesc);
				$.form.SetValue('chkCSSZLSbmt',CSSInfo.IRAntiSenFlag==1);	
				$.form.SetValue('chkCSSISPYSAntiBefre',CSSInfo.IROperAntiFlag==1);
				$.form.SetValue('chkCSSIsRepFinish',CSSInfo.IRRepFinishFlag==1);
			}
			//对感染的选择
			var IRInfectionDesc = $.form.GetText("cboIRInfectionDr");
			if ((IRInfectionDesc == "--请选择--") || (IRInfectionDesc == "不存在")){
			$("#cboInfCategoryDr").attr("disabled","disabled");
			}
			if (IRInfectionDesc == "存在"){
			$("#cboInfCategoryDr").removeAttr("disabled");
			}
			
			//当感染类型为空时，禁用医院感染选择和社区感染选择
			var InfCategoryDesc = $.form.GetText("cboInfCategoryDr");
			if(InfCategoryDesc == "--请选择--"){
				$("#cboSQInfPos11").attr("disabled","disabled");
				$("#cboSQBacteria11").attr("disabled","disabled");
				$("#cboSQMDR11").attr("disabled","disabled");
				$("#cboSQBacteria12").attr("disabled","disabled");
				$("#cboSQMDR12").attr("disabled","disabled");
				$("#cboSQBacteria13").attr("disabled","disabled");
				$("#cboSQMDR13").attr("disabled","disabled");
				$("#cboSQInfPos21").attr("disabled","disabled");
				$("#cboSQBacteria21").attr("disabled","disabled");
				$("#cboSQMDR21").attr("disabled","disabled");
				$("#cboSQBacteria22").attr("disabled","disabled");
				$("#cboSQMDR22").attr("disabled","disabled");
				$("#cboSQBacteria23").attr("disabled","disabled");
				$("#cboSQMDR23").attr("disabled","disabled");
				$("#cboSQInfPos31").attr("disabled","disabled");
				$("#cboSQBacteria31").attr("disabled","disabled");
				$("#cboSQMDR31").attr("disabled","disabled");
				$("#cboSQBacteria32").attr("disabled","disabled");
				$("#cboSQMDR32").attr("disabled","disabled");
				$("#cboSQBacteria33").attr("disabled","disabled");
				$("#cboSQMDR33").attr("disabled","disabled");
				$("#cboYYInfPos11").attr("disabled","disabled");
				$("#cboYYBacteria11").attr("disabled","disabled");
				$("#cboYYMDR11").attr("disabled","disabled");
				$("#cboYYBacteria12").attr("disabled","disabled");
				$("#cboYYMDR12").attr("disabled","disabled");
				$("#cboYYBacteria13").attr("disabled","disabled");
				$("#cboYYMDR13").attr("disabled","disabled");
				$("#cboYYInfPos21").attr("disabled","disabled");
				$("#cboYYBacteria21").attr("disabled","disabled");
				$("#cboYYMDR21").attr("disabled","disabled");
				$("#cboYYMDR22").attr("disabled","disabled");
				$("#cboYYBacteria23").attr("disabled","disabled");
				$("#cboYYMDR23").attr("disabled","disabled");
				$("#cboYYInfPos31").attr("disabled","disabled");
				$("#cboYYBacteria31").attr("disabled","disabled");
				$("#cboYYMDR31").attr("disabled","disabled");
				$("#cboYYBacteria32").attr("disabled","disabled");
				$("#cboYYMDR32").attr("disabled","disabled");
				$("#cboYYBacteria33").attr("disabled","disabled");
				$("#cboYYMDR33").attr("disabled","disabled");
			}
			if(InfCategoryDesc == "医院感染"){
				$("#cboYYInfPos11").removeAttr("disabled");
				$("#cboYYBacteria11").removeAttr("disabled");
				$("#cboYYMDR11").removeAttr("disabled");
				$("#cboYYBacteria12").removeAttr("disabled");
				$("#cboYYMDR12").removeAttr("disabled");
				$("#cboYYBacteria13").removeAttr("disabled");
				$("#cboYYMDR13").removeAttr("disabled");
				$("#cboYYInfPos21").removeAttr("disabled");
				$("#cboYYBacteria21").removeAttr("disabled");
				$("#cboYYMDR21").removeAttr("disabled");
				$("#cboYYBacteria22").removeAttr("disabled");
				$("#cboYYMDR22").removeAttr("disabled");
				$("#cboYYBacteria23").removeAttr("disabled");
				$("#cboYYMDR23").removeAttr("disabled");
				$("#cboYYInfPos31").removeAttr("disabled");
				$("#cboYYBacteria31").removeAttr("disabled");
				$("#cboYYMDR31").removeAttr("disabled");
				$("#cboYYBacteria32").removeAttr("disabled");
				$("#cboYYMDR32").removeAttr("disabled");
				$("#cboYYBacteria33").removeAttr("disabled");
				$("#cboYYMDR33").removeAttr("disabled");
				$("#cboSQInfPos11").attr("disabled","disabled");
				$("#cboSQBacteria11").attr("disabled","disabled");
				$("#cboSQMDR11").attr("disabled","disabled");
				$("#cboSQBacteria12").attr("disabled","disabled");
				$("#cboSQMDR12").attr("disabled","disabled");
				$("#cboSQBacteria13").attr("disabled","disabled");
				$("#cboSQMDR13").attr("disabled","disabled");
				$("#cboSQInfPos21").attr("disabled","disabled");
				$("#cboSQBacteria21").attr("disabled","disabled");
				$("#cboSQMDR21").attr("disabled","disabled");
				$("#cboSQBacteria22").attr("disabled","disabled");
				$("#cboSQMDR22").attr("disabled","disabled");
				$("#cboSQBacteria23").attr("disabled","disabled");
				$("#cboSQMDR23").attr("disabled","disabled");
				$("#cboSQInfPos31").attr("disabled","disabled");
				$("#cboSQBacteria31").attr("disabled","disabled");
				$("#cboSQMDR31").attr("disabled","disabled");
				$("#cboSQBacteria32").attr("disabled","disabled");
				$("#cboSQMDR32").attr("disabled","disabled");
				$("#cboSQBacteria33").attr("disabled","disabled");
				$("#cboSQMDR33").attr("disabled","disabled");
			}
			if(InfCategoryDesc == "社区感染"){
				$("#cboSQInfPos11").removeAttr("disabled");
				$("#cboSQBacteria11").removeAttr("disabled");
				$("#cboSQMDR11").removeAttr("disabled");
				$("#cboSQBacteria12").removeAttr("disabled");
				$("#cboSQMDR12").removeAttr("disabled");
				$("#cboSQBacteria13").removeAttr("disabled");
				$("#cboSQMDR13").removeAttr("disabled");
				$("#cboSQInfPos21").removeAttr("disabled");
				$("#cboSQBacteria21").removeAttr("disabled");
				$("#cboSQMDR21").removeAttr("disabled");
				$("#cboSQBacteria22").removeAttr("disabled");
				$("#cboSQMDR22").removeAttr("disabled");
				$("#cboSQBacteria23").removeAttr("disabled");
				$("#cboSQMDR23").removeAttr("disabled");
				$("#cboSQInfPos31").removeAttr("disabled");
				$("#cboSQBacteria31").removeAttr("disabled");
				$("#cboSQMDR31").removeAttr("disabled");
				$("#cboSQBacteria32").removeAttr("disabled");
				$("#cboSQMDR32").removeAttr("disabled");
				$("#cboSQBacteria33").removeAttr("disabled");
				$("#cboSQMDR33").removeAttr("disabled");
				$("#cboYYInfPos11").attr("disabled","disabled");
				$("#cboYYBacteria11").attr("disabled","disabled");
				$("#cboYYMDR11").attr("disabled","disabled");
				$("#cboYYBacteria12").attr("disabled","disabled");
				$("#cboYYMDR12").attr("disabled","disabled");
				$("#cboYYBacteria13").attr("disabled","disabled");
				$("#cboYYMDR13").attr("disabled","disabled");
				$("#cboYYInfPos21").attr("disabled","disabled");
				$("#cboYYBacteria21").attr("disabled","disabled");
				$("#cboYYMDR21").attr("disabled","disabled");
				$("#cboYYBacteria22").attr("disabled","disabled");
				$("#cboYYMDR22").attr("disabled","disabled");
				$("#cboYYBacteria23").attr("disabled","disabled");
				$("#cboYYMDR23").attr("disabled","disabled");
				$("#cboYYInfPos31").attr("disabled","disabled");
				$("#cboYYBacteria31").attr("disabled","disabled");
				$("#cboYYMDR31").attr("disabled","disabled");
				$("#cboYYBacteria32").attr("disabled","disabled");
				$("#cboYYMDR32").attr("disabled","disabled");
				$("#cboYYBacteria33").attr("disabled","disabled");
				$("#cboYYMDR33").attr("disabled","disabled");	
			}
		}else{
			
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
		InputRep = InputRep + CHR_1 + 7;
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
		var InputRepLog = ReportID;
		InputRepLog = InputRepLog + CHR_1 + statusCode;		//状态
		InputRepLog = InputRepLog + CHR_1 + '';
		InputRepLog = InputRepLog + CHR_1 + $.LOGON.USERID;
    	return InputRepLog;
	}
}