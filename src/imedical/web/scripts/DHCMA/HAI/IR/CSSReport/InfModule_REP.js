//赋值
function Common_SetCombo(ID,Value,Text)
{
	if (typeof(ID) !== 'string') return '';
	if (ID == '') return '';
	var $this = $('#'+ ID);
	if ($this.length < 1) return '';
	
    var className = $this.attr("class").split(' ');
    if (className.indexOf('combobox-f')>=0) {  //下拉框
	    $this.combobox('setValue',Value);
		$this.combobox('setText',Text);
    }
}
function Common_SetLookup(ID,Value,Text)
{
	if (typeof(ID) !== 'string') return '';
	if (ID == '') return '';
	var $this = $('#'+ ID);
	if ($this.length < 1) return '';
	
    var className = $this.attr("class");
    if (className.indexOf('lookup')>=0) {   //放大镜
	    $this.val(Text);
		$this.attr('data-idField',Value);
    }
}
function InitRep(obj){
	// 增加配置：CSSRepDispalyItemConfig：横断面报告模块展现维护  1#2#3
	//1：细菌耐药情况:2：输液（调查日）和经血传播病毒情况:3：基础疾病和危险因素:
	//4：抗菌药物其他病原学检测:5：基础信息:6：手术情况:7：感染情况:8：抗菌药物使用情况
	ItemConfig = $m({
		ClassName:"DHCHAI.BT.Config",
		MethodName:"GetValByCode",		
		aCode: "CSSRepDispalyItemConfig"
	},false);
	$(".tranBoold").parent().attr("style","display:inline-block;");
	$(".baseDiag").parent().attr("style","display:inline-block;");
	if (ItemConfig.indexOf(1)<0){
		$("#MRBInfo").parent().attr("style","display:none;");
	}
	if (ItemConfig.indexOf(2)<0){
		$(".tranBoold").parent().attr("style","display:none;");
	}
	if (ItemConfig.indexOf(3)<0){
		$(".baseDiag").parent().attr("style","display:none;");
	}
	if (ItemConfig.indexOf(4)<0){
		$(".otherLab").attr("style","display:none;");
	}
	if ((ItemConfig.indexOf(2)<0)&&(ItemConfig.indexOf(3)<0)){
		$(".tranBooldbaseDiag").parent().attr("style","display:none;");
	}
	
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
		}else{
			$('#txtRepDate').val("");
			$('#txtRepLoc').val("");
			$('#txtRepUser').val("");
			$('#txtRepStatus').val("");
		}
		//加载横断面数据
		obj.InfCSS  = $cm({
			ClassName:"DHCHAI.IRS.INFCSSSrv",
			QueryName:"QryNewCSSByPaadm",	
			aEpisodeID:EpisodeID,		
			aSurNumber:SurvNumber
		},false);
		
		for (var indX=0; indX<9; indX++){
			for (var indY=1; indY<7; indY++){
				$HUI.radio("input[name='chkMRB"+(indX+1)+indY+"']").setValue(false);
			}
		}
		if (obj.InfCSS!=''){
			if (obj.InfCSS.total!=0){
				var CSSInfo = obj.InfCSS.rows[0];
				if (CSSInfo.Age!=""){
					$('#txtAge').html(CSSInfo.Age);
				}
				
				Common_SetCombo("cboCSSDiagnos",CSSInfo.DiagnosDr,CSSInfo.DiagnosDesc);	
				var IRBugsAntiSen = CSSInfo.IRBugsAntiSen;
				if (IRBugsAntiSen){
					var arrBugsAntiSen = IRBugsAntiSen.split('#');
					if (arrBugsAntiSen.length>8){
						for (var indX=0; indX<arrBugsAntiSen.length; indX++){
							var strItem = arrBugsAntiSen[indX];
							var arrItem = strItem.split('||');
							for (var indY=1; indY<arrItem.length; indY++){
								
								$("#chkMRB-"+(indX+1)+arrItem[indY]+"").checkbox("setValue",true);	
							}
						}
					}
				}
				
				$("#cboCSSIsOpr").combobox("setValue",CSSInfo.OperFlag); //是否手术	
				if (CSSInfo.OperFlag=="0"){
					$("#cboCSSIncisionDr").combobox('disable');
				}else{
					$("#cboCSSIncisionDr").combobox('enable');
				}
				Common_SetCombo("cboCSSIncisionDr",CSSInfo.CuteTypeID,CSSInfo.CuteType);
				
				Common_SetCombo("cboIRInfectionDr",CSSInfo.InfectionDr,CSSInfo.InfectionDesc);
				Common_SetCombo("cboInfCategoryDr",CSSInfo.InfCateDr,CSSInfo.InfCateDesc);
				if (CSSInfo.InfectionDesc=="存在"){
					$('#cboInfCategoryDr').combobox('enable');
					$('#cboYYInfPos1').combobox('enable');
					$('#cboYYInfPos2').combobox('enable');
					$('#cboYYInfPos3').combobox('enable');
					$('.YYBacteria').lookup('enable');
					$('.SQBacteria').lookup('enable');
					if (CSSInfo.InfCateDesc=="医院感染"){
						$("#dtFirInf").datebox('enable');
						$("#dtFirInf").datebox('setValue',CSSInfo.FirInfDate);
						$("#cboYYInfPos1").combobox('setValue',CSSInfo.YYInfPos11Dr);
						Common_SetLookup("cboYYBacteria11",CSSInfo.YYBacteria11Dr,CSSInfo.YYBacteria11Desc);
						Common_SetLookup("cboYYBacteria12",CSSInfo.YYBacteria12Dr,CSSInfo.YYBacteria12Desc);
						Common_SetLookup("cboYYBacteria13",CSSInfo.YYBacteria13Dr,CSSInfo.YYBacteria13Desc)
						$("#cboYYInfPos2").combobox('setValue',CSSInfo.YYInfPos21Dr);
						Common_SetLookup("cboYYBacteria21",CSSInfo.YYBacteria21Dr,CSSInfo.YYBacteria21Desc);
						Common_SetLookup("cboYYBacteria22",CSSInfo.YYBacteria22Dr,CSSInfo.YYBacteria22Desc);
						Common_SetLookup("cboYYBacteria23",CSSInfo.YYBacteria23Dr,CSSInfo.YYBacteria23Desc)
						$("#cboYYInfPos3").combobox('setValue',CSSInfo.YYInfPos31Dr);
						Common_SetLookup("cboYYBacteria31",CSSInfo.YYBacteria31Dr,CSSInfo.YYBacteria31Desc);
						Common_SetLookup("cboYYBacteria32",CSSInfo.YYBacteria32Dr,CSSInfo.YYBacteria32Desc);
						Common_SetLookup("cboYYBacteria33",CSSInfo.YYBacteria33Dr,CSSInfo.YYBacteria33Desc)
						$('#cboCSSOperLung').combobox('enable');
						Common_SetCombo("cboCSSOperLung",CSSInfo.OprInfDr,CSSInfo.OprInfDesc);
						$('#cboSQInfPos1').combobox('disable');
						$('#cboSQInfPos2').combobox('disable');
						$('#cboSQInfPos3').combobox('disable');
						$("#cboSQMethod1").combobox('disable');
						$("#cboSQMethod2").combobox('disable');
						$("#cboSQMethod3").combobox('disable');
						$('.SQBacteria').lookup('disable');
					}else if(CSSInfo.InfCateDesc=="社区感染"){
						$("#dtFirInf").datebox('setValue',"");
						$("#dtFirInf").datebox('disable');
						$("#cboSQInfPos1").combobox('setValue',CSSInfo.SQInfPos11Dr);
						Common_SetLookup("cboSQBacteria11",CSSInfo.SQBacteria11Dr,CSSInfo.SQBacteria11Desc);
						Common_SetLookup("cboSQBacteria12",CSSInfo.SQBacteria12Dr,CSSInfo.SQBacteria12Desc);
						Common_SetLookup("cboSQBacteria13",CSSInfo.SQBacteria13Dr,CSSInfo.SQBacteria13Desc)
						$("#cboSQInfPos2").combobox('setValue',CSSInfo.SQInfPos21Dr);
						Common_SetLookup("cboSQBacteria21",CSSInfo.SQBacteria21Dr,CSSInfo.SQBacteria21Desc);
						Common_SetLookup("cboSQBacteria22",CSSInfo.SQBacteria22Dr,CSSInfo.SQBacteria22Desc);
						Common_SetLookup("cboSQBacteria23",CSSInfo.SQBacteria23Dr,CSSInfo.SQBacteria23Desc)
						$("#cboSQInfPos3").combobox('setValue',CSSInfo.SQInfPos31Dr);
						Common_SetLookup("cboSQBacteria31",CSSInfo.SQBacteria31Dr,CSSInfo.SQBacteria31Desc);
						Common_SetLookup("cboSQBacteria32",CSSInfo.SQBacteria32Dr,CSSInfo.SQBacteria32Desc);
						Common_SetLookup("cboSQBacteria33",CSSInfo.SQBacteria33Dr,CSSInfo.SQBacteria33Desc)
						Common_SetCombo("cboCSSOperLung","","");
						$("#cboSQMethod1").combobox('setValue',CSSInfo.SQMethod1);
						$("#cboSQMethod2").combobox('setValue',CSSInfo.SQMethod2);
						$("#cboSQMethod3").combobox('setValue',CSSInfo.SQMethod3);
						
						$('#cboCSSOperLung').combobox('disable');
						$('#cboYYInfPos1').combobox('disable');
						$('#cboYYInfPos2').combobox('disable');
						$('#cboYYInfPos3').combobox('disable');
						$('.YYBacteria').lookup('disable');
					}else if(CSSInfo.InfCateDesc=="医院+社区"){
						$("#dtFirInf").datebox('enable');
						$("#dtFirInf").datebox('setValue',CSSInfo.FirInfDate);
						$("#cboYYInfPos1").combobox('setValue',CSSInfo.YYInfPos11Dr);
						Common_SetLookup("cboYYBacteria11",CSSInfo.YYBacteria11Dr,CSSInfo.YYBacteria11Desc);
						Common_SetLookup("cboYYBacteria12",CSSInfo.YYBacteria12Dr,CSSInfo.YYBacteria12Desc);
						Common_SetLookup("cboYYBacteria13",CSSInfo.YYBacteria13Dr,CSSInfo.YYBacteria13Desc)
						$("#cboYYInfPos2").combobox('setValue',CSSInfo.YYInfPos21Dr);
						Common_SetLookup("cboYYBacteria21",CSSInfo.YYBacteria21Dr,CSSInfo.YYBacteria21Desc);
						Common_SetLookup("cboYYBacteria22",CSSInfo.YYBacteria22Dr,CSSInfo.YYBacteria22Desc);
						Common_SetLookup("cboYYBacteria23",CSSInfo.YYBacteria23Dr,CSSInfo.YYBacteria23Desc)
						$("#cboYYInfPos3").combobox('setValue',CSSInfo.YYInfPos31Dr);
						Common_SetLookup("cboYYBacteria31",CSSInfo.YYBacteria31Dr,CSSInfo.YYBacteria31Desc);
						Common_SetLookup("cboYYBacteria32",CSSInfo.YYBacteria32Dr,CSSInfo.YYBacteria32Desc);
						Common_SetLookup("cboYYBacteria33",CSSInfo.YYBacteria33Dr,CSSInfo.YYBacteria33Desc);
						$('#cboCSSOperLung').combobox('enable');
						Common_SetCombo("cboCSSOperLung",CSSInfo.OprInfDr,CSSInfo.OprInfDesc)
						$("#cboSQInfPos1").combobox('setValue',CSSInfo.SQInfPos11Dr);
						Common_SetLookup("cboSQBacteria11",CSSInfo.SQBacteria11Dr,CSSInfo.SQBacteria11Desc);
						Common_SetLookup("cboSQBacteria12",CSSInfo.SQBacteria12Dr,CSSInfo.SQBacteria12Desc);
						Common_SetLookup("cboSQBacteria13",CSSInfo.SQBacteria13Dr,CSSInfo.SQBacteria13Desc);
						$("#cboSQInfPos2").combobox('setValue',CSSInfo.SQInfPos21Dr);
						Common_SetLookup("cboSQBacteria21",CSSInfo.SQBacteria21Dr,CSSInfo.SQBacteria21Desc);
						Common_SetLookup("cboSQBacteria22",CSSInfo.SQBacteria22Dr,CSSInfo.SQBacteria22Desc);
						Common_SetLookup("cboSQBacteria23",CSSInfo.SQBacteria23Dr,CSSInfo.SQBacteria23Desc);
						$("#cboSQInfPos3").combobox('setValue',CSSInfo.SQInfPos31Dr);
						Common_SetLookup("cboSQBacteria31",CSSInfo.SQBacteria31Dr,CSSInfo.SQBacteria31Desc);
						Common_SetLookup("cboSQBacteria32",CSSInfo.SQBacteria32Dr,CSSInfo.SQBacteria32Desc);
						Common_SetLookup("cboSQBacteria33",CSSInfo.SQBacteria33Dr,CSSInfo.SQBacteria33Desc);
						$("#cboSQMethod1").combobox('setValue',CSSInfo.SQMethod1);
						$("#cboSQMethod2").combobox('setValue',CSSInfo.SQMethod2);
						$("#cboSQMethod3").combobox('setValue',CSSInfo.SQMethod3);
					}
				}else if (CSSInfo.InfectionDesc=="不存在") {
					$('#cboInfCategoryDr').combobox('disable');
					$("#dtFirInf").datebox('disable');
					$('#cboYYInfPos1').combobox('disable');
					$('#cboYYInfPos2').combobox('disable');
					$('#cboYYInfPos3').combobox('disable');
					$('.YYBacteria').lookup('disable');
					$('#cboCSSOperLung').combobox('disable');
					$('#cboSQInfPos1').combobox('disable');
					$('#cboSQInfPos2').combobox('disable');
					$('#cboSQInfPos3').combobox('disable');
					$('#cboSQMethod1').combobox('disable');
					$('#cboSQMethod2').combobox('disable');
					$('#cboSQMethod3').combobox('disable');
					$('.SQBacteria').lookup('disable');
					$("#dtFirInf").datebox('setValue',"");
					$("#cboYYInfPos1").combobox('setValue',"");
					Common_SetLookup("cboYYBacteria11","","");
					Common_SetLookup("cboYYBacteria12","","");
					Common_SetLookup("cboYYBacteria13","","")
					$("#cboYYInfPos2").combobox('setValue',"");
					Common_SetLookup("cboYYBacteria21","","");
					Common_SetLookup("cboYYBacteria22","","");
					Common_SetLookup("cboYYBacteria23","","");
					$("#cboYYInfPos3").combobox('setValue',"");
					Common_SetLookup("cboYYBacteria31","","");
					Common_SetLookup("cboYYBacteria32","","");
					Common_SetLookup("cboYYBacteria33","","");
					$('#cboCSSOperLung').combobox('disable');
					Common_SetCombo("cboCSSOperLung","","");
					$("#cboSQInfPos1").combobox('setValue',"");
					Common_SetLookup("cboSQBacteria11","","");
					Common_SetLookup("cboSQBacteria12","","");
					Common_SetLookup("cboSQBacteria13","","");
					$("#cboSQInfPos2").combobox('setValue',"");
					Common_SetLookup("cboSQBacteria21","","");
					Common_SetLookup("cboSQBacteria22","","");
					Common_SetLookup("cboSQBacteria23","","");
					$("#cboSQInfPos3").combobox('setValue',"");
					Common_SetLookup("cboSQBacteria31","","");
					Common_SetLookup("cboSQBacteria32","","");
					Common_SetLookup("cboSQBacteria33","","");
				}else{
                    changeStyle("");  
                }
				if (CSSInfo.IsVD==""){
					$HUI.radio("input[name='radIsVD']").setValue(false);
				}else{
					$HUI.radio("#radIsVD-"+CSSInfo.IsVD).setValue(true);
				}
				if (CSSInfo.IsANTVD==""){
					$HUI.radio("input[name='radIsANTVD']").setValue(false);
				}else{
					$HUI.radio("#radIsANTVD-"+CSSInfo.IsANTVD).setValue(true);
				}
				
				if (CSSInfo.HBVInf==""){
					$HUI.radio("input[name='cboHBVInf']").setValue(false);
				}else{
					$HUI.radio("#cboHBVInf-"+CSSInfo.HBVInf).setValue(true);
				}
				
				if (CSSInfo.HCVInf==""){
					$HUI.radio("input[name='cboHCVInf']").setValue(false);
				}else{
					$HUI.radio("#cboHCVInf-"+CSSInfo.HCVInf).setValue(true);
				}
				
				if (CSSInfo.HIVInf==""){
					$HUI.radio("input[name='cboHIVInf']").setValue(false);
				}else{
					$HUI.radio("#cboHIVInf-"+CSSInfo.HIVInf).setValue(true);
				}
				
				if (CSSInfo.TPInf==""){
					$HUI.radio("input[name='cboTPInf']").setValue(false);
				}else{
					$HUI.radio("#cboTPInf-"+CSSInfo.TPInf).setValue(true);
				}
				
				if (CSSInfo.IsCa==""){
					$HUI.radio("input[name='cboIsCa']").setValue(false);
				}else{
					$HUI.radio("#cboIsCa-"+CSSInfo.IsCa).setValue(true);
				}
				
				if (CSSInfo.IsBloodMT==""){
					$HUI.radio("input[name='cboBloodMT']").setValue(false);
				}else{
					$HUI.radio("#cboBloodMT-"+CSSInfo.IsBloodMT).setValue(true);
				}
				
				if (CSSInfo.IsTNB==""){
					$HUI.radio("input[name='cboTNB']").setValue(false);
				}else{
					$HUI.radio("#cboTNB-"+CSSInfo.IsTNB).setValue(true);
				}
				
				if (CSSInfo.IsARF==""){
					$HUI.radio("input[name='cboARF']").setValue(false);
				}else{
					$HUI.radio("#cboARF-"+CSSInfo.IsARF).setValue(true);
				}
				
				if (CSSInfo.IsARI==""){
					$HUI.radio("input[name='cboARI']").setValue(false);
				}else{
					$HUI.radio("#cboARI-"+CSSInfo.IsARI).setValue(true);
				}
				
				if (CSSInfo.IsLC==""){
					$HUI.radio("input[name='cboLC']").setValue(false);
				}else{
					$HUI.radio("#cboLC-"+CSSInfo.IsLC).setValue(true);
				}
				
				if (CSSInfo.ISHM==""){
					$HUI.radio("input[name='cboHM']").setValue(false);
				}else{
					$HUI.radio("#cboHM-"+CSSInfo.ISHM).setValue(true);
				}
				
				if (CSSInfo.ISISD==""){
					$HUI.radio("input[name='cboISD']").setValue(false);
				}else{
					$HUI.radio("#cboISD-"+CSSInfo.ISISD).setValue(true);
				}
				if (CSSInfo.IsGlucocorticoid==""){
					$HUI.radio("input[name='cboGlucocorticoid']").setValue(false);
				}else{
					$HUI.radio("#cboGlucocorticoid-"+CSSInfo.IsGlucocorticoid).setValue(true);
				}
				
				//是否抗菌药物
				if (CSSInfo.IRAntiFlag!=""){
					 $HUI.radio("#radCSSIsAnti-"+CSSInfo.IRAntiFlag).setValue(true);
				}
				Common_SetCombo("cboCSSMedPurpose",CSSInfo.PurposeDr,CSSInfo.PurposeDesc);
				Common_SetCombo("cboCSSCombinedMed",CSSInfo.CombinDr,CSSInfo.CombinDesc);
				$("#cboCSSZLSbmt").combobox('setValue',CSSInfo.IRAntiSenFlag);
				$("#cboCSSISPYSAntiBefre").combobox('setValue',CSSInfo.IROperAntiFlag);
				
				$("#cboCSSSpecGL").combobox('setValue',CSSInfo.IRCSSSpecGLFlag);
				$("#cboCSSSpecKS").combobox('setValue',CSSInfo.IRCSSSpecKSFlag);
				$("#cboCSSSpecMZ").combobox('setValue',CSSInfo.IRCSSSpecMZFlag);
				$("#cboCSSSpecJY").combobox('setValue',CSSInfo.IRCSSSpecJYFlag);
				if (ReportID==""){
					 $("#dtFirInf").datebox('setValue',"");
				}
			}
		}else{
			$('#cboInfCategoryDr').combobox('disable');
			$("#dtFirInf").datebox('disable');
			$('#cboYYInfPos1').combobox('disable');
			$('#cboYYInfPos2').combobox('disable');
			$('#cboYYInfPos3').combobox('disable');
			$('.YYBacteria').lookup('disable');
			$('#cboCSSOperLung').combobox('disable');
			$('#cboSQInfPos1').combobox('disable');
			$('#cboSQInfPos2').combobox('disable');
			$('#cboSQInfPos3').combobox('disable');
			$('#cboSQMethod1').combobox('disable');
			$('#cboSQMethod2').combobox('disable');
			$('#cboSQMethod3').combobox('disable');
			$('.SQBacteria').lookup('disable');
			$("#dtFirInf").datebox('setValue',"");
			$("#cboYYInfPos1").combobox('setValue',"");
			Common_SetLookup("cboYYBacteria11","","");
			Common_SetLookup("cboYYBacteria12","","");
			Common_SetLookup("cboYYBacteria13","","")
			$("#cboYYInfPos2").combobox('setValue',"");
			Common_SetLookup("cboYYBacteria21","","");
			Common_SetLookup("cboYYBacteria22","","");
			Common_SetLookup("cboYYBacteria23","","");
			$("#cboYYInfPos3").combobox('setValue',"");
			Common_SetLookup("cboYYBacteria31","","");
			Common_SetLookup("cboYYBacteria32","","");
			Common_SetLookup("cboYYBacteria33","","");
			$('#cboCSSOperLung').combobox('enable');
			Common_SetCombo("cboCSSOperLung","","");
			$("#cboSQInfPos1").combobox('setValue',"");
			Common_SetLookup("cboSQBacteria11","","");
			Common_SetLookup("cboSQBacteria12","","");
			Common_SetLookup("cboSQBacteria13","","");
			$("#cboSQInfPos2").combobox('setValue',"");
			Common_SetLookup("cboSQBacteria21","","");
			Common_SetLookup("cboSQBacteria22","","");
			Common_SetLookup("cboSQBacteria23","","");
			$("#cboSQInfPos3").combobox('setValue',"");
			Common_SetLookup("cboSQBacteria31","","");
			Common_SetLookup("cboSQBacteria32","","");
			Common_SetLookup("cboSQBacteria33","","");
			$('#cboSQMethod1').combobox('setValue',"");
			$('#cboSQMethod2').combobox('setValue',"");
			$('#cboSQMethod3').combobox('setValue',"");
		}
	}
	obj.refreshReportInfo();
		
	obj.Rep_Save = function (statusCode){
		var RepDate = '';
		var RepTime = '';
		var RepLoc  = $.LOGON.LOCID;
		var RepUser = $.LOGON.USERID;

		if (obj.AdminPower==1){  //管理员 不修改 报告科室、报告人、报告日期、报告时间 采用报告数据
			if ((obj.RepInfo)&&(obj.RepInfo.total>0)) { 
				RepDate = obj.RepInfo.rows[0].RepDate;
				RepTime = obj.RepInfo.rows[0].RepTime;
				RepLoc  = obj.RepInfo.rows[0].RepLocID;
				RepUser = obj.RepInfo.rows[0].RepUserID;
			}
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

	obj.RepLog_Save = function(statusCode){
		var Opinion = arguments[1];
		if (typeof(Opinion)=='undefined'){
			Opinion='';
		}
		var InputRepLog = ReportID;
		InputRepLog = InputRepLog + CHR_1 + statusCode;		//状态
		InputRepLog = InputRepLog + CHR_1 + Opinion;
		InputRepLog = InputRepLog + CHR_1 + $.LOGON.USERID;      //session['LOGON.USERID'];
    	return InputRepLog;
	}
}