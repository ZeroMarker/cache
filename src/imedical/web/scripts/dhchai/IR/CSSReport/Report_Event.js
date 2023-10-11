/**
 * 
 * @authors liyi (124933390@qq.com)
 * @date    2017-09-13 16:25:35
 * @version v1.0
 */
function InitReportWinEvent(obj){
	// 初始化功能按钮
	CheckSpecificKey();
	obj.InitButtons = function(){
		$('#btnSubmit').hide();
		$('#btnCheck').hide();
		$('#btnDelete').hide();
		$('#btnReturn').hide();
		$('#btnExport').hide();
		$('#btnUnCheck').hide();
		switch (obj.RepStatusCode){
			case '2':       // 提交
				$('#btnDelete').show();
				$('#btnSubmit').show();
				$('#btnExport').show();
				if (obj.AdminPower==1){	// 管理员
					$('#btnCheck').show();
					$('#btnReturn').show();
					$('#btnDelete').show();
				}
				break;
			case '3':       // 审核
				//$('#btnExport').show();
				if (obj.AdminPower==1){	// 管理员
					$('#btnUnCheck').show();
				}
				break;
			case '6':       // 取消审核
				$('#btnSubmit').show();
				$('#btnDelete').show();
				if (obj.AdminPower==1){	// 管理员
					$('#btnCheck').show();
					$('#btnReturn').show();
				}
				break;
			case '4':       // 删除
				break;
			case '5':       // 退回
				$('#btnSubmit').show();
				$('#btnDelete').show();
				break;
			default:
				$('#btnSubmit').show();
				break;
		}
	}
	
	obj.InitButtons();
	// 提交
	$('#btnSubmit').click(function (e) {
		if (!obj.CheckInputData(2)){
			return;
		}
    	if (obj.Save()){
    		layer.msg('提交成功!',{icon: 1});
    	}else{
    		layer.msg('提交失败!',{icon: 2});
    	};
	});
	
	
	//感染选择的判断
	$("#cboIRInfectionDr").change(function(){
		var IRInfectionDesc = $.form.GetText("cboIRInfectionDr");
		if ((IRInfectionDesc == "--请选择--") || (IRInfectionDesc == "不存在")){
			$("#cboInfCategoryDr").attr("disabled","disabled");
		}
		if (IRInfectionDesc == "存在"){
			$("#cboInfCategoryDr").removeAttr("disabled");
		}
	});
	
	//选择感染类型的判断
	$("#cboInfCategoryDr").change(function(){
		var InfCategoryDesc = $.form.GetText("cboInfCategoryDr");
		if (InfCategoryDesc == "--请选择--"){
			//社区感染
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
			//医院感染
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
		if (InfCategoryDesc == "医院感染"){
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
		if (InfCategoryDesc == "社区感染"){
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
	});
	// 审核
	$('#btnCheck').click(function (e) {
		if (!obj.CheckInputData(3)){
			return;
		}
    	if (obj.Save()){
    		layer.msg('审核成功!',{icon: 1});
    	}else{
    		layer.msg('审核失败!',{icon: 2});
    	};
	});

	// 删除
	$('#btnDelete').click(function (e) {
    	if (obj.SaveStatus(4)){
    		layer.msg('删除成功!',{icon: 1});
    	}else{
    		layer.msg('删除失败!',{icon: 2});
    	};
	});

	// 退回
	$('#btnReturn').click(function (e) {
    	if (obj.SaveStatus(5)){
    		layer.msg('退回成功!',{icon: 1});
    	}else{
    		layer.msg('退回失败!',{icon: 2});
    	};
	});

	// 取消审核
	$('#btnUnCheck').click(function (e) {
    	if (obj.SaveStatus(6)){
    		layer.msg('取消审核成功!',{icon: 1});
    	}else{
    		layer.msg('取消审核失败!',{icon: 2});
    	};
	});
	
	// 导出
	$('#btnExport').click(function(e){
		var url="dhccpmrunqianreport.csp?reportName=DHCHAICSSReport.raq&aReportID="+ReportID+"&aEpisodeID="+EpisodeID+"&aSurvNumber="+SurvNumber;
		websys_createWindow(url,1,"width=710,height=610,top=0,left=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	})
	
	// 数据完整性验证
	obj.CheckInputData = function (statusCode){
		obj.InputRep 		= obj.Rep_Save(statusCode);		// 报告主表信息
		obj.InputRepLog 	= obj.RepLog_Save(statusCode);	// 日志
    	obj.InputPreFactors = ""; //obj.PreFactor_Save();			// 易感因素
    	obj.InputInvasOpers = ""; //obj.InvasOper_Save();			// 侵害性操作
    	obj.InputDiag 		= ""; //obj.DIAG_Save();				// 感染信息
    	obj.InputOPS 		= ""; //obj.OPR_Save();				// 手术信息
    	obj.InputLab 		= ""; //obj.LAB_Save();				// 病原学送检
    	obj.InputAnti 		= ""; //obj.ANT_Save();				// 抗菌药物
		//横断面信息
		//var  Input=$("#CSSID").val();       //1
		var  Input="";                      //1
		Input = Input + CHR_1 + EpisodeID;  //2
		Input = Input + CHR_1 + SurvNumber; //3
		Input = Input + CHR_1 + $.LOGON.USERDESC;     //4
		Input = Input + CHR_1 + "1";   //是否有效   //5
		
		var cboIRInfectionDr = $.form.GetValue("cboIRInfectionDr");
		var IRInfectionDesc  = $.form.GetText("cboIRInfectionDr");
		if (cboIRInfectionDr==""){
			layer.msg('感染必填!',{icon: 2});
			return false;
		}
		var CSSDiagnosDr = $.form.GetValue("cboCSSDiagnos");
		if (CSSDiagnosDr==""){
			layer.msg('疾病诊断必填!',{icon: 2});
			return false;
		}
		var InfCategoryDr = $.form.GetValue("cboInfCategoryDr");
		if ((IRInfectionDesc=="存在")&&(InfCategoryDr=="")){
			layer.msg('当感染存在时,感染类型必选!',{icon: 2});
			return false;
		}
		
		Input = Input + CHR_1 + cboIRInfectionDr;    //6
		Input = Input + CHR_1 + InfCategoryDr;       //7
		
		var YYInfPos11Dr   = $.form.GetValue("cboYYInfPos11");
		var YYBacteria11Dr = $.form.GetValue("cboYYBacteria11");
		var YYMDR11Dr      = $.form.GetValue("cboYYMDR11");
		var YYBacteria12Dr = $.form.GetValue("cboYYBacteria12");
		var YYMDR12Dr      = $.form.GetValue("cboYYMDR12");
		var YYBacteria13Dr = $.form.GetValue("cboYYBacteria13");
		var YYMDR13Dr      = $.form.GetValue("cboYYMDR13");
		var IRInfPathogen1 = YYInfPos11Dr+"#"+YYBacteria11Dr+"#"+YYMDR11Dr+"#"+YYBacteria12Dr+"#"+YYMDR12Dr+"#"+YYBacteria13Dr+"#"+YYMDR13Dr;
		Input = Input + CHR_1 + IRInfPathogen1;     //8
		var YYInfPos21Dr   = $.form.GetValue("cboYYInfPos21");
		var YYBacteria21Dr = $.form.GetValue("cboYYBacteria21");
		var YYMDR21Dr      = $.form.GetValue("cboYYMDR21");
		var YYBacteria22Dr = $.form.GetValue("cboYYBacteria22");
		var YYMDR22Dr      = $.form.GetValue("cboYYMDR22");
		var YYBacteria23Dr = $.form.GetValue("cboYYBacteria23");
		var YYMDR23Dr      = $.form.GetValue("cboYYMDR23");
		var IRInfPathogen2 = YYInfPos21Dr+"#"+YYBacteria21Dr+"#"+YYMDR21Dr+"#"+YYBacteria22Dr+"#"+YYMDR22Dr+"#"+YYBacteria23Dr+"#"+YYMDR23Dr;
		Input = Input + CHR_1 + IRInfPathogen2;      //9
		var YYInfPos31Dr   = $.form.GetValue("cboYYInfPos31");
		var YYBacteria31Dr = $.form.GetValue("cboYYBacteria31");
		var YYMDR31Dr      = $.form.GetValue("cboYYMDR31");
		var YYBacteria32Dr = $.form.GetValue("cboYYBacteria32");
		var YYMDR32Dr      = $.form.GetValue("cboYYMDR32");
		var YYBacteria33Dr = $.form.GetValue("cboYYBacteria33");
		var YYMDR33Dr      = $.form.GetValue("cboYYMDR33");
		var IRInfPathogen3 = YYInfPos31Dr+"#"+YYBacteria31Dr+"#"+YYMDR31Dr+"#"+YYBacteria32Dr+"#"+YYMDR32Dr+"#"+YYBacteria33Dr+"#"+YYMDR33Dr;
		Input = Input + CHR_1 + IRInfPathogen3;    //10
		var CSSOperLungDr = $.form.GetValue("cboCSSOperLung");
		if (CSSOperLungDr==""){
			layer.msg('手术后肺炎必填!',{icon: 2});
			return false;
		}
		Input = Input + CHR_1 + CSSOperLungDr;     //11
		var SQInfPos11Dr   = $.form.GetValue("cboSQInfPos11");
		var SQBacteria11Dr = $.form.GetValue("cboSQBacteria11");
		var SQMDR11Dr      = $.form.GetValue("cboSQMDR11");
		var SQBacteria12Dr = $.form.GetValue("cboSQBacteria12");
		var SQMDR12Dr      = $.form.GetValue("cboSQMDR12");
		var SQBacteria13Dr = $.form.GetValue("cboSQBacteria13");
		var SQMDR13Dr      = $.form.GetValue("cboSQMDR13");
		var IRComInfPathogen1 = SQInfPos11Dr+"#"+SQBacteria11Dr+"#"+SQMDR11Dr+"#"+SQBacteria12Dr+"#"+SQMDR12Dr+"#"+SQBacteria13Dr+"#"+SQMDR13Dr;
		Input = Input + CHR_1 + IRComInfPathogen1;    //12
		var SQInfPos21Dr   = $.form.GetValue("cboSQInfPos21");
		var SQBacteria21Dr = $.form.GetValue("cboSQBacteria21");
		var SQMDR21Dr      = $.form.GetValue("cboSQMDR21");
		var SQBacteria22Dr = $.form.GetValue("cboSQBacteria22");
		var SQMDR22Dr      = $.form.GetValue("cboSQMDR22");
		var SQBacteria23Dr = $.form.GetValue("cboSQBacteria23");
		var SQMDR23Dr      = $.form.GetValue("cboSQMDR23");
		var IRComInfPathogen2 = SQInfPos21Dr+"#"+SQBacteria21Dr+"#"+SQMDR21Dr+"#"+SQBacteria22Dr+"#"+SQMDR22Dr+"#"+SQBacteria23Dr+"#"+SQMDR23Dr;
		Input = Input + CHR_1 + IRComInfPathogen2;    //13
		var SQInfPos31Dr   = $.form.GetValue("cboSQInfPos31");
		var SQBacteria31Dr = $.form.GetValue("cboSQBacteria31");
		var SQMDR31Dr      = $.form.GetValue("cboSQMDR31");
		var SQBacteria32Dr = $.form.GetValue("cboSQBacteria32");
		var SQMDR32Dr      = $.form.GetValue("cboSQMDR32");
		var SQBacteria33Dr = $.form.GetValue("cboSQBacteria33");
		var SQMDR33Dr      = $.form.GetValue("cboSQMDR33");
		var IRComInfPathogen3 = SQInfPos31Dr+"#"+SQBacteria31Dr+"#"+SQMDR31Dr+"#"+SQBacteria32Dr+"#"+SQMDR32Dr+"#"+SQBacteria33Dr+"#"+SQMDR33Dr;
		
		var CategoryDesc=$.form.GetText("cboInfCategoryDr");
		if (IRInfectionDesc=="存在"){
    		if ((CategoryDesc=="医院感染")&&(YYInfPos11Dr=="")&&(YYInfPos21Dr=="")&&(YYInfPos31Dr=="")){
       			layer.msg('医院感染请填写至少一项感染部位!',{icon: 2});
				return false;
     		}else if ((CategoryDesc=="社区感染")&&(SQInfPos11Dr=="")&&(SQInfPos21Dr=="")&&(SQInfPos31Dr=="")){
        		layer.msg('社区感染请填写至少一项感染部位!',{icon: 2});
				return false;
     		}

   		}
		Input = Input + CHR_1 + IRComInfPathogen3;    //14
		var chkCSSIsOpr = $.form.GetValue("chkCSSIsOpr"); //是否手术
		var CSSIncisionDr = $.form.GetValue("cboCSSIncisionr");
		var OperDate      = $.form.GetValue("OperDate");
		var txtOperName   = $.form.GetValue("txtOperName");
		if (chkCSSIsOpr==1){
			if ((CSSIncisionDr=="")||(OperDate=="")||(txtOperName=="")){
				layer.msg('手术选择"是",切口类型、手术日期、手术名称必填!',{icon: 2});
				return false;
			}
		}
		Input = Input + CHR_1 + chkCSSIsOpr;      //15
		Input = Input + CHR_1 + CSSIncisionDr;    //16
		Input = Input + CHR_1 + OperDate;         //17
		Input = Input + CHR_1 + txtOperName;      //18
		
		var CRBugsAntiSen = "金黄色葡萄球菌"
			+ "||" + $.form.GetValue("cbgAntiSen11")
			+ "||" + $.form.GetValue("cbgAntiSen12")
			+ "#凝固酶阴性葡萄球菌"
			+ "||" + $.form.GetValue("cbgAntiSen21")
			+ "||" + $.form.GetValue("cbgAntiSen22")
			+ "#粪肠球菌"
			+ "||" + $.form.GetValue("cbgAntiSen31")
			+ "||" + $.form.GetValue("cbgAntiSen32")
			+ "#屎肠球菌"
			+ "||" + $.form.GetValue("cbgAntiSen41")
			+ "||" + $.form.GetValue("cbgAntiSen42")
			+ "#肺炎链球菌"
			+ "||" + $.form.GetValue("cbgAntiSen51")
			+ "#大肠埃希菌"
			+ "||" + $.form.GetValue("cbgAntiSen61")
			+ "||" + $.form.GetValue("cbgAntiSen62")
			+ "||" + $.form.GetValue("cbgAntiSen63")
			+ "#肺炎克雷伯菌"
			+ "||" + $.form.GetValue("cbgAntiSen71")
			+ "||" + $.form.GetValue("cbgAntiSen72")
			+ "||" + $.form.GetValue("cbgAntiSen73")
			+ "#铜绿假单胞菌"
			+ "||" + $.form.GetValue("cbgAntiSen81")
			+ "||" + $.form.GetValue("cbgAntiSen82")
			+ "||" + $.form.GetValue("cbgAntiSen83")
			+ "||" + $.form.GetValue("cbgAntiSen84")
			+ "||" + $.form.GetValue("cbgAntiSen85")
			+ "||" + $.form.GetValue("cbgAntiSen86")
			+ "#鲍曼不动杆菌"
			+ "||" + $.form.GetValue("cbgAntiSen91")
			+ "||" + $.form.GetValue("cbgAntiSen92")
		Input = Input + CHR_1 + CRBugsAntiSen;	  //19
		
		var chkCSSIsAnti = $.form.GetValue("chkCSSIsAnti"); //是否使用抗菌药物
		// 获取抗菌药物名称
		var CSSAntiNameList = $("#cboCSSAntiName").select2("data");
		var CSSAntiNameDrs = "";
		for(var j = 0;j<CSSAntiNameList.length;j++){
			var dataObj = CSSAntiNameList[j];
			var id = dataObj.id;
			if(id!=""){
				if(CSSAntiNameDrs==""){
					CSSAntiNameDrs = id;
				}else{
					CSSAntiNameDrs = CSSAntiNameDrs +","+id;
				}
			}
		}
		var MedPurposeDr   = $.form.GetValue("cboCSSMedPurpose");
		var CombinedMedDr  = $.form.GetValue("cboCSSCombinedMed");
		var chkCSSZLSbmt   = $.form.GetValue("chkCSSZLSbmt");
		var IROperAntiFlag = $.form.GetValue("chkCSSISPYSAntiBefre");
		var RepFinishFlag  = $.form.GetValue("chkCSSIsRepFinish");
		if (chkCSSIsAnti==1){
			if ((CSSAntiNameDrs=="")||(MedPurposeDr=="")||(CombinedMedDr=="")){
				layer.msg('使用抗菌药物,抗菌药物名称、目的、联用必填!',{icon: 2});
				return false;
			}
		}
		Input = Input + CHR_1 + chkCSSIsAnti;  	  //20
		Input = Input + CHR_1 + CSSAntiNameDrs;	  //21
		Input = Input + CHR_1 + MedPurposeDr;	  //22
		Input = Input + CHR_1 + CombinedMedDr;	  //23
		Input = Input + CHR_1 + chkCSSZLSbmt;	  //24
		Input = Input + CHR_1 + IROperAntiFlag;	  //25
		Input = Input + CHR_1 + RepFinishFlag;	  //26
			
    	Input = Input + CHR_1 + '';	              //27
    	Input = Input + CHR_1 + '';	              //28
    	Input = Input + CHR_1 + $.LOGON.USERID;	  //29
    	Input = Input + CHR_1 + CSSDiagnosDr;     //30
    	obj.InputCSS = Input;	
		
    	if (obj.InputCSS==''){
    		layer.msg('横断面调查信息不能为空!',{icon: 2});
			return false;
    	}
    	return true;
	}

	// 保存报告内容+状态
	obj.Save = function (){
		
    	var ret = $.Tool.RunServerMethod('DHCHAI.IRS.INFReportSrv','SaveINFReport',obj.InputRep,obj.InputPreFactors,obj.InputInvasOpers,obj.InputDiag,obj.InputOPS,obj.InputLab,obj.InputAnti,obj.InputRepLog,obj.InputCSS);
    	if (parseInt(ret)>0){
    		ReportID = parseInt(ret);
    		obj.refreshReportInfo();
    		//obj.refreshgridINFDiagnos();
    		//obj.refreshgridINFOPS();
    		//obj.refreshgridINFLab();
    		//obj.refreshgridINFAnti();
    		obj.InitButtons();
    		return true;
    	}else{
    		return false;
    	}
	}

	// 保存报告状态
	obj.SaveStatus = function(statusCode){
		var InputRepLog 	= obj.RepLog_Save(statusCode);	// 日志
		var ret = $.Tool.RunServerMethod('DHCHAI.IRS.INFReportSrv','SaveINFReportStatus',InputRepLog,CHR_1)
    	if (parseInt(ret)>0){
    		obj.refreshReportInfo();
    		obj.InitButtons();
    		return true;
    	}else{
    		return false;
    	}
	}

	obj.checkDate = function(d){
		d = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","DateHtmlToLogical",d);
		var cDateFrom = obj.AdmInfo.record[0].AdmDate;
		var cDateTo = obj.AdmInfo.record[0].DischDate;
		if (cDateTo==''){
			cDateTo = $.form.GetCurrDate('-');
		}
		var flg1 = $.form.CompareDate(d,cDateFrom);
		var flg2 = $.form.CompareDate(cDateTo,d);
		if (flg1&&flg2){
			return true;
		}else{
			return false;
		}
	}
}

