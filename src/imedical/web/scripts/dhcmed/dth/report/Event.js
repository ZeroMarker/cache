﻿
function InitDMReportEvent(obj){
	obj.LoadEvent = function() {
		obj.ClsDTHReport = ExtTool.StaticServerObject("DHCMed.DTH.Report");
		obj.ClsDTHCommonSrv = ExtTool.StaticServerObject("DHCMed.DTHService.CommonSrv");
		obj.ClsDTHReportSrv = ExtTool.StaticServerObject("DHCMed.DTHService.ReportSrv");
		obj.ClsDTHRepNoSrv = ExtTool.StaticServerObject("DHCMed.DTHService.RepNoSrv");
		obj.ClsBasePatient = ExtTool.StaticServerObject("DHCMed.Base.Patient");
		obj.ClsSSConfigSrv = ExtTool.StaticServerObject("DHCMed.SSService.ConfigSrv");
		obj.ClsDTHPaperNo = ExtTool.StaticServerObject("DHCMed.DTH.PaperNo");
		obj.ClsDTHPaperNoSrv = ExtTool.StaticServerObject("DHCMed.DTHService.PaperNoSrv");
		
		var objPaadmManage = ExtTool.StaticServerObject("DHCMed.Base.PatientAdm");		// 病人就诊信息对象
		obj.objCurrPaadm = objPaadmManage.GetObjById(EpisodeID);
		
		obj.btnReport.on('click',obj.Report_Click,obj);
		obj.btnPrintPatInfo.on('click',obj.btnPrintPatInfo_Click,obj);
		obj.btnSaveTmp.on('click',obj.btnSaveTmp_Click,obj);
		obj.btnCheckOne.on('click',obj.btnCheckOne_Click,obj);
		obj.btnPrintOne.on('click',obj.btnPrintOne_Click,obj);
		obj.btnPrintThree.on('click',obj.btnPrintThree_Click,obj);
		obj.btnCancle.on('click',obj.btnCancle_Click,obj);
		obj.btnGrantThree.on('click',obj.btnGrantThree_Click,obj);
		obj.btnGrantOne.on('click',obj.btnGrantOne_Click,obj);
		obj.btnCheckTwo.on('click',obj.btnCheckTwo_Click,obj);
		obj.btnDel.on('click',obj.btnDel_Click,obj);
		obj.btnHelpWord.on('click',obj.btnHelpWord_Click,obj);
		obj.btnReturn.on('click',obj.btnReturn_Click,obj);
		obj.btnChildReport.on('click', obj.btnChildReport_Click, obj);

		obj.cboDeathPlace.on('select',obj.cboDeathPlace_Select,obj);
		obj.cboBaseReason.on('select',obj.cboBaseReason_Select,obj);
		obj.cboDamage.on('select',obj.cboDamage_Select,obj);
		obj.cboAReason.on('select',obj.cboAReason_Select,obj);
		obj.cboBReason.on('select',obj.cboBReason_Select,obj);
		obj.cboCReason.on('select',obj.cboCReason_Select,obj);
		obj.cboDReason.on('select',obj.cboDReason_Select,obj);
		obj.cboOtherDiagnose.on('select',obj.cboOtherDiagnose_Select,obj);
		obj.cboDamageDiagnose.on('select',obj.cboDamageDiagnose_Select,obj);
		obj.txtSex.on('blur',obj.txtSex_Blur,obj);
		obj.txtDeathDate.on('blur',obj.txtDeathDate_Blur,obj);
		obj.txtDeathTime.on('select',obj.txtDeathTime_Select,obj);

		//户籍地址
		obj.cboRegProvince.on('expand',obj.cboRegProvince_expand,obj);
		//obj.cboRegCity.on('expand',obj.cboRegCity_expand,obj);
		//obj.cboRegCounty.on('expand',obj.cboRegCounty_expand,obj);
		//obj.cboRegVillage.on('expand',obj.cboRegVillage_expand,obj);
		obj.cboRegProvince.on('select',obj.cboRegProvince_Select,obj);
		obj.cboRegCity.on('select',obj.cboRegCity_Select,obj);
		obj.cboRegCounty.on('select',obj.cboRegCounty_Select,obj);
		obj.cboRegVillage.on('select',obj.cboRegVillage_Select,obj);
		
		//生前住址
		obj.cboCurrProvince.on('expand',obj.cboCurrProvince_expand,obj);
		//obj.cboCurrCity.on('expand',obj.cboCurrCity_expand,obj);
		//obj.cboCurrCounty.on('expand',obj.cboCurrCounty_expand,obj);
		//obj.cboCurrVillage.on('expand',obj.cboCurrVillage_expand,obj);
		obj.cboCurrProvince.on('select',obj.cboCurrProvince_Select,obj);
		obj.cboCurrCity.on('select',obj.cboCurrCity_Select,obj);
		obj.cboCurrCounty.on('select',obj.cboCurrCounty_Select,obj);
		obj.cboCurrVillage.on('select',obj.cboCurrVillage_Select,obj);
		obj.cboAReason.on("blur",obj.cboAReason_blur,obj)
		obj.cboBReason.on("blur",obj.cboBReason_blur,obj)
		obj.cboCReason.on("blur",obj.cboCReason_blur,obj)
		obj.cboDReason.on("blur",obj.cboDReason_blur,obj)
		obj.cboDamageDiagnose.on("blur",obj.cboDamageDiagnose_blur,obj)
		obj.cboOtherDiagnose.on("blur",obj.cboOtherDiagnose_blur,obj)
		obj.cboBaseReason.on("blur",obj.cboBaseReason_blur,obj)
		obj.cboDamage.on("blur",obj.cboDamage_blur,obj)
		
		//是否使用新版本打印模板 配置项目：新模板设置为1
		obj.TemplateVersion= obj.ClsSSConfigSrv.GetValueByKeyHosp("DTH-TemplateVersion", "");
		obj.SwitchPrint= obj.ClsSSConfigSrv.GetValueByKeyHosp("DTH-SwitchPrint", "");
		if (ReportID!=""){
			//已填报报告页面数据加载
			obj.InitRepByReportID();
		}else{
			//新建报告页面数据加载
			obj.InitRepByEpisodeID();
		}
		//控制是否允许修改病人基本信息 0：允许  1：不允许 
		obj.IsUpdatePatientInfo = obj.ClsSSConfigSrv.GetValueByKeyHosp("DTH-IsUpdatePatientInfo", "");
		if (obj.IsUpdatePatientInfo != 0) {
			//重新加载病人基本信息
			obj.UpdatePatientInfo();
		}
		obj.InitRepPowerByStatus();
		
		//Common_SetDisabled("chkJohnDoe",true);
		//Common_SetDisabled("chkNewBorn",true);
		Common_SetDisabled("txtRegAddress",true);
		Common_SetDisabled("txtCurrAddress",true);
		Common_SetDisabled("txtAFPReason",true);
		Common_SetDisabled("txtBFPReason",true);
		Common_SetDisabled("txtCFPReason",true);
		Common_SetDisabled("txtDFPReason",true);
		Common_SetDisabled("txtOtherDiagnoseFP",true);
		Common_SetDisabled("txtEncryptLevel",true);
		Common_SetDisabled("txtPatLevel",true);
		var SecretStr = ExtTool.RunServerMethod("DHCMed.SSIO.FromSecSrv","GetPatEncryptLevel",PatientID,"");
		obj.txtPatLevel.setValue(SecretStr.split('^')[1]);
		obj.txtEncryptLevel.setValue(SecretStr.split('^')[0]);
		//死亡编号手工输入还是自动生成 0 手工 1 自动
		var DeathNoType=obj.ClsDTHRepNoSrv.GetDeathNoType(HospitalID);
		if (DeathNoType==0){
			obj.txtDeathNo.setDisabled(false);
		} else {
			obj.txtDeathNo.setDisabled(true);
		}
		window.onunload = obj.btnCancle_Click;
	}
	//疾病诊断为空失去焦点自动情空后面项目
	obj.cboAReason_blur = function (){
		if (obj.cboAReason.getRawValue().trim()=="") {
			obj.txtAReasonICD.setValue("");
			obj.txtAInterval.setValue("");
			obj.cboATime.setValue("");
		}
		//增加诊断关键字检验
		var checkflag = CheckDiagnoseByKeys(obj.cboAReason.getRawValue());
		if (checkflag == "-1") {
			obj.cboAReason.setValue("");
			obj.txtAReasonICD.setValue("");
			obj.txtAInterval.setValue("");
			obj.cboATime.setValue("");
		}
	}
	obj.cboBReason_blur = function (){
		if (obj.cboBReason.getRawValue().trim()=="") {
			obj.txtBReasonICD.setValue("");
			obj.txtBInterval.setValue("");
			obj.cboBTime.setValue("");
		}
	}
	obj.cboCReason_blur = function (){
		if (obj.cboCReason.getRawValue().trim()=="") {
			obj.txtCReasonICD.setValue("");
			obj.txtCInterval.setValue("");
			obj.cboCTime.setValue("");
		}
	}
	obj.cboDReason_blur = function (){
		if (obj.cboDReason.getRawValue().trim()=="") {
			obj.txtDReasonICD.setValue("");
			obj.txtDInterval.setValue("");
			obj.cboDTime.setValue("");
		}
	}
	obj.cboDamageDiagnose_blur = function (){
		if (obj.cboDamageDiagnose.getRawValue().trim()=="") {
			obj.cboDamageDiagnoseICD.setValue("");
		}
	}
	obj.cboOtherDiagnose_blur = function (){
		if (obj.cboOtherDiagnose.getRawValue().trim()=="") {
			obj.txtOtherDiagnoseICD.setValue("");
			obj.txtOtherDiagnoseInterval.setValue("");
			obj.cboOtherDiagnoseTime.setValue("");
		}
	}
	obj.cboBaseReason_blur = function (){
		if (obj.cboBaseReason.getRawValue().trim()=="") {
			obj.txtBaseReasonICD.setValue("");
		}
	}
	obj.cboDamage_blur = function (){
		if (obj.cboDamage.getRawValue().trim()=="") {
			obj.txtDamageICD.setValue("");
		}
	}
	
	function CheckDiagnoseByKeys (DiagDesc) {
		if (DiagDesc == "") {
			return
		}
		var ConfigDeathKeys=obj.ClsSSConfigSrv.GetValueByKeyHosp("DTH-DeathReasonKeys","");
		var isHaveKey = obj.ClsDTHReportSrv.CheckReasonByKeys(DiagDesc,ConfigDeathKeys);
		if (isHaveKey == "1") {
			alert("诊断有误(诊断不能包含<衰竭>)，请核实后重新填写!");
			return "-1"
		}
	}

	//户籍地址触发事件
	obj.cboRegProvince_expand = function(){
		obj.cboRegProvince.setValue('');
		obj.cboRegCity.setValue('');
		obj.cboRegCounty.setValue('');
		obj.cboRegVillage.setValue('');
	}
	obj.cboRegCity_expand = function(){
		obj.cboRegCity.clearValue();
		obj.cboRegCounty.clearValue();
		obj.cboRegVillage.clearValue();
	}
	obj.cboRegCounty_expand = function(){
		obj.cboRegCounty.clearValue();
		obj.cboRegVillage.clearValue();
	}
	obj.cboRegVillage_expand = function(){
		obj.cboRegVillage.clearValue();
	}

	obj.cboRegProvince_Select = function(){
		obj.cboRegCity.getStore().load({}); 
		obj.cboRegCounty.getStore().load({}); 
		obj.cboRegVillage.getStore().load({}); 
	}
	obj.cboRegCity_Select = function(){
		obj.cboRegCounty.getStore().load({}); 
		obj.cboRegVillage.getStore().load({}); 
	}
	obj.cboRegCounty_Select = function(){
		obj.cboRegVillage.getStore().load({}); 
	}
	//*****************************
	//add by pylian  20160126 fix bug  171276 对户籍地址赋值
	obj.cboRegVillage_Select = function(){
		var RegAddress=obj.cboRegProvince.getRawValue()+obj.cboRegCity.getRawValue()+obj.cboRegCounty.getRawValue()+obj.cboRegVillage.getRawValue();
		obj.txtRegAddress.setValue(RegAddress);
	}
	obj.txtRegRoad.on('change', function(field, e){   
	 	var RegAddress=obj.cboRegProvince.getRawValue()+obj.cboRegCity.getRawValue()+obj.cboRegCounty.getRawValue()+obj.cboRegVillage.getRawValue()+obj.txtRegRoad.getValue();
		obj.txtRegAddress.setValue(RegAddress);
        
     });
    //*****************************	 
	//生前地址触发事件

	obj.cboCurrProvince_expand = function(){
		obj.cboCurrProvince.setValue('');
		obj.cboCurrCity.setValue('');
		obj.cboCurrCounty.setValue('');
		obj.cboCurrVillage.setValue('');
	}
	obj.cboCurrCity_expand = function(){
		obj.cboCurrCity.setValue('');
		obj.cboCurrCounty.setValue('');
		obj.cboCurrVillage.setValue('');
	}
	obj.cboCurrCounty_expand = function(){
		obj.cboCurrCounty.setValue('');
		obj.cboCurrVillage.setValue('');
	}
	obj.cboCurrVillage_expand = function(){
		obj.cboCurrVillage.setValue('');
	}
	obj.cboCurrProvince_Select = function(){
		obj.cboCurrCity.getStore().load({}); 
		obj.cboCurrCounty.getStore().load({}); 
		obj.cboCurrVillage.getStore().load({}); 
	}
	obj.cboCurrCity_Select = function(){
		obj.cboCurrCounty.getStore().load({}); 
		obj.cboCurrVillage.getStore().load({}); 
	}
	obj.cboCurrCounty_Select = function(){
		obj.cboCurrVillage.getStore().load({}); 
	}
	//*****************************
	//add by pylian  20160126 fix bug  171276 对生前地址赋值
	obj.cboCurrVillage_Select = function(){
		var CurrAddress=obj.cboCurrProvince.getRawValue()+obj.cboCurrCity.getRawValue()+obj.cboCurrCounty.getRawValue()+obj.cboCurrVillage.getRawValue();
		obj.txtCurrAddress.setValue(CurrAddress);

	}	
	obj.txtCurrRoad.on('change', function(field, e){   
		var CurrAddress=obj.cboCurrProvince.getRawValue()+obj.cboCurrCity.getRawValue()+obj.cboCurrCounty.getRawValue()+obj.cboCurrVillage.getRawValue()+obj.txtCurrRoad.getValue();
		obj.txtCurrAddress.setValue(CurrAddress);
        
     });  
	//*******************************
	obj.txtSex_Blur = function(){
		var Sex = obj.txtSex.getValue();
		if (Sex=="女"){
			obj.DisplayPregnanciesDiv(true);
		}
		if (Sex=="男"){
			obj.DisplayPregnanciesDiv(false);
		}
	}
	
	//add by mxp 2017-12-21 根据所填死亡日期、时间计算年龄
	obj.txtDeathDate_Blur = function(){
		var DeathDate = obj.txtDeathDate.getRawValue();
		var DeathTime = obj.txtDeathTime.getRawValue();
		if (DeathDate!="") {
			obj.setAgeValue(DeathDate,DeathTime);
		}
	}
	obj.txtDeathTime_Select = function(){
		obj.txtDeathDate_Blur();
	}
	obj.setAgeValue = function(date,time){
		var DeathDate = obj.txtDeathDate.getRawValue();
		var DeathTime = obj.txtDeathTime.getRawValue();
		var Age = "";
		if (DeathDate!="") {
			Age = ExtTool.RunServerMethod("DHCMed.SSIO.FromHisSrv","GetPapmiAge",PatientID,EpisodeID, DeathDate,DeathTime);
		}else{
			Age = ExtTool.RunServerMethod("DHCMed.SSIO.FromHisSrv","GetPapmiAge",PatientID,EpisodeID, date,time);
		}
		Common_SetValue("txtAge",Age);
	}
	
	//死亡地点
	obj.cboDeathPlace_Select=function(){
		var strDesc=obj.cboDeathPlace.getRawValue();
		var UserName=session['LOGON.USERNAME'];
		if (strDesc.indexOf("医疗卫生机构") > -1){
			obj.txtExamUser.setValue('');
			obj.txtExamDate.setValue('');
		}else{
			obj.txtExamUser.setValue(UserName);
			obj.txtExamDate.setValue(new Date());
		}
	}
	
	//根本死因
	obj.cboBaseReason_Select =function(){
		var objRec = arguments[1];
		if (objRec){
			Common_SetValue("txtBaseReasonICD",objRec.get("ICD10"))
		}
	}
	//损失中毒
	obj.cboDamage_Select =function(){
		var objRec = arguments[1];
		if (objRec){
			Common_SetValue("txtDamageICD",objRec.get("ICD10"))
		}
	}
	//A死因
	obj.cboAReason_Select =function(){
		var objRec = arguments[1];
		if (objRec){
			Common_SetValue("txtAReasonICD",objRec.get("ICD10"))
		}
	}
	//B死因
	obj.cboBReason_Select =function(){
		var objRec = arguments[1];
		if (objRec){
			Common_SetValue("txtBReasonICD",objRec.get("ICD10"))
		}
	}  
	//C死因
	obj.cboCReason_Select =function(){
		var objRec = arguments[1];
		if (objRec){
			Common_SetValue("txtCReasonICD",objRec.get("ICD10"))
		}
	} 
	//D死因
	obj.cboDReason_Select =function(){
		var objRec = arguments[1];
		if (objRec){
			Common_SetValue("txtDReasonICD",objRec.get("ICD10"))
		}
	}
	//其他原因
	obj.cboOtherDiagnose_Select = function(){
		var objRec = arguments[1];
		if (objRec){
			Common_SetValue("txtOtherDiagnoseICD",objRec.get("ICD10"))
		}
	}
	// 损伤中毒诊断
	obj.cboDamageDiagnose_Select =function(){
		var objRec = arguments[1];
		if (objRec){
			Common_SetValue("cboDamageDiagnoseICD",objRec.get("ICD10"))
		}
	}
	
	//控制根本死因面板显示
	obj.DisplayBaseReasonDiv = function(flag){
		if (flag){
			document.all['DivBaseReasonL'].style.display = 'block';
			document.all['DivBaseReason'].style.display = 'block';
		} else {
			document.all['DivBaseReasonL'].style.display = 'none';
			document.all['DivBaseReason'].style.display = 'none';
		}
	}
	
	//控制孕产情况面板显示
	obj.DisplayPregnanciesDiv = function(flag){
		if (flag){
			document.all['TD-cboPregnanciesL'].style.display = 'block';
			document.all['TD-cboPregnancies'].style.display = 'block';
		} else {
			document.all['TD-cboPregnanciesL'].style.display = 'none';
			document.all['TD-cboPregnancies'].style.display = 'none';
		}
	}
	
	//显示按钮操作权限 根据报告状态与操作权限控制
	obj.InitRepPowerByStatus = function(){
		Common_SetVisible("btnSaveTmp",false);
		Common_SetVisible("btnReport",false);
		Common_SetVisible("btnCheckOne",false);
		Common_SetVisible("btnCheckTwo",false);
		Common_SetVisible("btnPrintOne",false);
		Common_SetVisible("btnGrantOne",false);
		Common_SetVisible("btnPrintThree",false);
		Common_SetVisible("btnGrantThree",false);
		Common_SetVisible("btnDel",false);
		Common_SetVisible("btnReturn",false);
		if(obj.strCurrAge < 5){
			Common_SetVisible("btnChildReport", true);
		}else{
			Common_SetVisible("btnChildReport", false);
		}
		obj.RepStatusCode=obj.ClsDTHReportSrv.GetReportStatus(ReportID);
     	switch (obj.RepStatusCode) {
			case "" : // 无报告 只能暂存、上报
				Common_SetVisible("btnSaveTmp",true);
				Common_SetVisible("btnReport",true);
				break;
			case "1" : // 待审
				obj.btnReport.setText("修改报卡");
				Common_SetVisible("btnReport",true);
				Common_SetVisible("btnDel",true);
				Common_SetVisible("btnCheckOne",true);
				Common_SetVisible("btnPrintThree",true);
				Common_SetVisible("btnGrantThree",true);
				Common_SetVisible("btnReturn",true);
				//待审状态允许首联打印
				if (SSHospCode=='11-BJZYY') {  //北京中医院
					Common_SetVisible("btnPrintOne",true);
					Common_SetVisible("btnGrantOne",true);
				} else if (SSHospCode=='37-QYFY'){  //青医附院
					Common_SetVisible("btnPrintOne",true);
					Common_SetVisible("btnGrantOne",true);
				} else if (SSHospCode == '11-AZ') {	//安贞医院·
					Common_SetVisible("btnPrintOne",true);
					Common_SetVisible("btnGrantOne",true);
				}
				break;
			case "2" : //编码(病案室/统计室)
				Common_SetVisible("btnCheckOne",true);
				Common_SetVisible("btnCheckTwo",true);
				Common_SetVisible("btnPrintThree",true);
				Common_SetVisible("btnGrantThree",true);
				Common_SetVisible("btnPrintOne",true);
				Common_SetVisible("btnGrantOne",true);
				Common_SetVisible("btnReturn",true);
				break;
			case "3" : //审核(预防保健科)
				Common_SetVisible("btnPrintThree",true);
				Common_SetVisible("btnGrantThree",true);
				Common_SetVisible("btnPrintOne",true);
				Common_SetVisible("btnGrantOne",true);
				//Common_SetVisible("btnReturn",true);
				break;
			case "9" : // 退回
				obj.btnReport.setText("修改报卡");
				Common_SetVisible("btnReport",true);
				Common_SetVisible("btnDel",true);
				break;
			case "6" : // 草稿
				Common_SetVisible("btnSaveTmp",true);
				Common_SetVisible("btnReport",true);
				Common_SetVisible("btnDel",true);
				break;
			case "5" : // 作废
				break;
		}
		
		if (tDHCMedMenuOper['Report']!=1) {
			Common_SetVisible("btnReport",false);
			Common_SetVisible("btnSaveTmp",false);
		}
		if (tDHCMedMenuOper['CheckOne']!=1) {
			Common_SetVisible("btnCheckOne",false);
		}
		if (tDHCMedMenuOper['CheckTwo']!=1) {
			Common_SetVisible("btnCheckTwo",false);
		}
		if (tDHCMedMenuOper['PrintOne']!=1) {
			Common_SetVisible("btnPrintOne",false);
		}
		if (tDHCMedMenuOper['PrintThree']!=1) {
			Common_SetVisible("btnPrintThree",false);
		}
		if (tDHCMedMenuOper['GrantThree']!=1) {
			Common_SetVisible("btnGrantThree",false);
		}
		if (tDHCMedMenuOper['GrantOne']!=1) {
			Common_SetVisible("btnGrantOne",false);
		}
		if (tDHCMedMenuOper['Del']!=1){
			Common_SetVisible("btnDel",false);
		}
		if (tDHCMedMenuOper['Return']!=1){
			Common_SetVisible("btnReturn",false);
		}
		
		//只有编码、审核权限才可看到根本死因及损伤中毒及ICD编码
		if ((tDHCMedMenuOper['CheckOne']==1)||(tDHCMedMenuOper['CheckTwo']==1)){
			obj.DisplayBaseReasonDiv(true);
		}else{
			obj.DisplayBaseReasonDiv(false);
		}
		
		//待审状态、三联打印后不允许修改病人基本信息、调查记录
		if (obj.RepStatusCode=="1") {
			//允许打印次数
			var retPrintValue = obj.ClsSSConfigSrv.GetValueByKeyHosp("DTH-ReportPrintTimes",HospitalID);	
			var inputStr=ReportID + CHR_1 + 2;
			//已打印次数
			var retPrintNumValue=obj.ClsDTHReportSrv.GetPrintNumStatus(inputStr,CHR_1);	  
			if (retPrintNumValue=="") retPrintNumValue=0;
			if (retPrintNumValue>=retPrintValue){
				//病人基本信息
				Common_SetDisabled("txtRegNo",true);
				Common_SetDisabled("txtMrNo",true);
				Common_SetDisabled("txtPatName",true);
				Common_SetDisabled("txtIdentify",true);
				Common_SetDisabled("txtSex",true);
				Common_SetDisabled("txtBirthday",true);
				Common_SetDisabled("txtAge",true);
				Common_SetDisabled("txtCountry",true);
				Common_SetDisabled("txtNation",true);
				Common_SetDisabled("cboCardType",true);
				Common_SetDisabled("cboMarital",true);
				Common_SetDisabled("cboEducation",true);
				Common_SetDisabled("cboOccupation",true);
				Common_SetDisabled("cboWorkType",true);
				Common_SetDisabled("txtCompany",true);
				if (Common_GetValue("cboRegProvince") != '') Common_SetDisabled("cboRegProvince",true);
				if (Common_GetValue("cboRegCity") != '') Common_SetDisabled("cboRegCity",true);
				if (Common_GetValue("cboRegCounty") != '') Common_SetDisabled("cboRegCounty",true);
				if (Common_GetValue("cboRegVillage") != '') Common_SetDisabled("cboRegVillage",true);
				if (Common_GetValue("txtRegRoad") != '') Common_SetDisabled("txtRegRoad",true);
				if (Common_GetValue("cboCurrProvince") != '') Common_SetDisabled("cboCurrProvince",true);
				if (Common_GetValue("cboCurrCity") != '') Common_SetDisabled("cboCurrCity",true);
				if (Common_GetValue("cboCurrCounty") != '') Common_SetDisabled("cboCurrCounty",true);
				if (Common_GetValue("cboCurrVillage") != '') Common_SetDisabled("cboCurrVillage",true);
				if (Common_GetValue("txtCurrRoad") != '') Common_SetDisabled("txtCurrRoad",true);
				Common_SetDisabled("txtFamName",true);
				Common_SetDisabled("cboFamCardType",true);
				Common_SetDisabled("txtFamIdentify",true);
				Common_SetDisabled("cboFamRelation",true);
				Common_SetDisabled("txtFamTel",true);
				Common_SetDisabled("txtFamAddress",true);
				Common_SetDisabled("txtDeathDate",true);
				Common_SetDisabled("txtDeathTime",true);
				Common_SetDisabled("cboDeathPlace",true);
				Common_SetDisabled("cboPregnancies",true);
				//调查记录
				obj.txtExamMedical.setDisabled(true);
				obj.txtExamName.setDisabled(true);
				obj.cboExamRelation.setDisabled(true);
				obj.txtExamTel.setDisabled(true);
				obj.txtExamDeathReason.setDisabled(true);
				obj.txtExamAddress.setDisabled(true);
				obj.txtExamUser.setDisabled(true);
				obj.txtExamDate.setDisabled(true);
			}
		}
	}
	
	//死亡证页面初始化
	obj.InitRepByReportID=function(){
		Common_SetDisabled("chkJohnDoe",true);
		Common_SetDisabled("chkNewBorn",true);
		
		var separate="^";
		var retValue=obj.ClsDTHReport.GetStringById(ReportID,separate);
		var arrValue=retValue.split("^");
		
		Common_SetValue("txtPatName",arrValue[3]);
		Common_SetValue("txtSex",arrValue[4]);
		
		//孕产周期（妊娠期或终止妊娠42天内 是/否）
		if (arrValue[4].indexOf("男") > -1) {
			SetComboxByValue("cboPregnancies","","");
			obj.DisplayPregnanciesDiv(false);
		}else{
			SetComboxByValue("cboPregnancies",arrValue[15]);
			obj.DisplayPregnanciesDiv(true);
		}
		//obj.strCurrAge = arrValue[7].replace("岁", ""); //Add By LiYang 2015-03-13 记录患者日期，如果小于5岁，要提示上报儿童死亡报告卡
		//修改年龄小于一岁的儿童上报死亡证明
		if(arrValue[7].indexOf("岁") > -1){
			obj.strCurrAge = arrValue[7].replace("岁", ""); 
		}else{
			obj.strCurrAge = 1;
		}
		Common_SetValue("txtRegNo",arrValue[1]);
		Common_SetValue("txtMrNo",arrValue[2]);
		Common_SetValue("txtIdentify",arrValue[5]);
		Common_SetValue("txtBirthday",arrValue[6]);
		Common_SetValue("txtAge",arrValue[7]);
		Common_SetValue("txtCountry",arrValue[8]);
		Common_SetValue("txtNation",arrValue[9]);
		SetComboxByValue("cboMarital",arrValue[10]);
		SetComboxByValue("cboEducation",arrValue[11]);
		SetComboxByValue("cboOccupation",arrValue[12]);
		Common_SetValue("txtCompany",arrValue[14]);
		Common_SetValue("txtRegAddress",arrValue[16]);
		Common_SetValue("txtCurrAddress",arrValue[17]);
		//SetComboxByValue("cboCurrProvince",arrValue[65]);
		//SetComboxByValue("cboCurrCity",arrValue[66]);
		//SetComboxByValue("cboCurrCounty",arrValue[67]);
		//SetComboxByValue("cboCurrVillage",arrValue[77]);
		//居住地
		obj.cboCurrProvince.getStore().load({
			callback : function(){
				SetComboxByValue("cboCurrProvince",arrValue[65]);
				obj.cboCurrCity.getStore().load({
					callback : function(){
						SetComboxByValue("cboCurrCity",arrValue[66]);
						obj.cboCurrCounty.getStore().load({
							callback : function(){
								SetComboxByValue("cboCurrCounty",arrValue[67]);
								obj.cboCurrVillage.getStore().load({
									callback : function(){
										SetComboxByValue("cboCurrVillage",arrValue[77]);									
									}
								});							
							}
						});
					}
				});
			}
		});
		
		//SetComboxByValue("cboRegProvince",arrValue[78]);
		//SetComboxByValue("cboRegCity",arrValue[79]);
		//SetComboxByValue("cboRegCounty",arrValue[80]);
		//SetComboxByValue("cboRegVillage",arrValue[81]);
		//户籍地
		obj.cboRegProvince.getStore().load({
			callback : function(){
				SetComboxByValue("cboRegProvince",arrValue[78]);
				obj.cboRegCity.getStore().load({
					callback : function(){
						SetComboxByValue("cboRegCity",arrValue[79]);
						obj.cboRegCounty.getStore().load({
							callback : function(){
								SetComboxByValue("cboRegCounty",arrValue[80]);
								obj.cboRegVillage.getStore().load({
									callback : function(){
										SetComboxByValue("cboRegVillage",arrValue[81]);									
									}
								});							
							}
						});
					}
				});
			}
		});
		Common_SetValue("txtFamName",arrValue[18]);
		SetComboxByValue("cboFamRelation",arrValue[19]);
		Common_SetValue("txtFamTel",arrValue[20]);
		Common_SetValue("txtFamAddress",arrValue[21]);
		if(arrValue[22]!=""){
			var DeathNoArray = arrValue[22].split("-");
			var ShortDeathNo = DeathNoArray[1]+DeathNoArray[2];
			if(DeathNoArray[1]!=undefined){
				Common_SetValue("txtDeathNo",ShortDeathNo);
			}else{
				Common_SetValue("txtDeathNo",arrValue[22]);
			}
		}
		Common_SetValue("txtDeathDate",arrValue[23]);
		Common_SetValue("txtDeathTime",arrValue[24]);
		SetComboxByValue("cboDeathPlace",arrValue[25]);
		
		if ((SSHospCode=='11-BJZYY')||(SSHospCode=='11-AZ')) {
			//北京中医院、北京安贞医院 特殊情况处理
			//根本死因
			if (arrValue[26]!=""){ 
				Common_SetValue("cboBaseReason","",arrValue[26]);
			}
			//根本死因ICD
			if (arrValue[27]!=""){
				Common_SetValue("txtBaseReasonICD",arrValue[27]);
			}
			//损伤中毒
			if (arrValue[28]!=""){
				Common_SetValue("cboDamage","",arrValue[28]);
			}
			//损伤中毒ICD
			if (arrValue[29]!=""){
				Common_SetValue("txtDamageICD",arrValue[29]);
			}
		} else {
			//根本死因  如果根本死因为空则以dcba顺序取诊断
			if (arrValue[26]==""){  
				if(arrValue[36]!="") {
					Common_SetValue("cboBaseReason","",arrValue[36]);
				}else if(arrValue[34]!="") {
					Common_SetValue("cboBaseReason","",arrValue[34]);
				}else if(arrValue[32]!="") {
					Common_SetValue("cboBaseReason","",arrValue[32]);
				}else if(arrValue[30]!="") {
					Common_SetValue("cboBaseReason","",arrValue[30]);
				}
			} else {
				Common_SetValue("cboBaseReason","",arrValue[26]);
			}
			//根本死因ICD
			if (arrValue[27]==""){
				if(arrValue[36]!="") {
					Common_SetValue("txtBaseReasonICD",arrValue[57]);
				}else if(arrValue[34]!="") {
					Common_SetValue("txtBaseReasonICD",arrValue[56]);
				}else if(arrValue[32]!="") {
					Common_SetValue("txtBaseReasonICD",arrValue[55]);
				}else if(arrValue[30]!="") {
					Common_SetValue("txtBaseReasonICD",arrValue[54]);
				}
			} else {
				Common_SetValue("txtBaseReasonICD",arrValue[27]);
			}
			
			//损伤中毒
			if (arrValue[28]==""){
				Common_SetValue("cboDamage","",arrValue[53]);
			} else {
				Common_SetValue("cboDamage","",arrValue[28]);
			}
			//损伤中毒ICD
			if (arrValue[29]==""){
				Common_SetValue("txtDamageICD",arrValue[58]);
			} else {
				Common_SetValue("txtDamageICD",arrValue[29]);
			}
		}
		
		Common_SetValue("cboAReason","",arrValue[30]);
		Common_SetValue("txtAInterval",arrValue[31]);
		Common_SetValue("cboBReason","",arrValue[32]);
		Common_SetValue("txtBInterval",arrValue[33]);
		Common_SetValue("cboCReason","",arrValue[34]);
		Common_SetValue("txtCInterval",arrValue[35]);
		Common_SetValue("cboDReason","",arrValue[36]);
		Common_SetValue("txtDInterval",arrValue[37]);
		Common_SetValue("cboOtherDiagnose","",arrValue[38]);
		Common_SetValue("txtOtherDiagnoseInterval",arrValue[89]);
		SetComboxByValue("cboDiagnoseUnit",arrValue[39]);
		SetComboxByValue("cboDiagnoseBasis",arrValue[40]);
		
		Common_SetValue("txtResume",arrValue[41]);
		Common_SetValue("txtExamMedical",arrValue[42]);
		Common_SetValue("txtExamName",arrValue[43]);
		SetComboxByValue("cboExamRelation",arrValue[44]);
		Common_SetValue("txtExamTel",arrValue[45]);
		Common_SetValue("txtExamDeathReason",arrValue[46]);
		Common_SetValue("txtExamAddress",arrValue[47]);
		Common_SetValue("txtExamUser",arrValue[48]);
		Common_SetValue("txtExamDate",arrValue[49]);
		Common_SetValue("cboDamageDiagnose","",arrValue[53]);
		
		Common_SetDisabled("txtDeathNo",true);
		
		Common_SetValue("txtAReasonICD",arrValue[54]);
		Common_SetValue("txtBReasonICD",arrValue[55]);
		Common_SetValue("txtCReasonICD",arrValue[56]);
		Common_SetValue("txtDReasonICD",arrValue[57]);
		Common_SetValue("txtOtherDiagnoseICD",arrValue[86]);
		Common_SetValue("cboDamageDiagnoseICD",arrValue[58]);
		SetComboxByValue("cboATime",arrValue[59]);
		SetComboxByValue("cboBTime",arrValue[60]);
		SetComboxByValue("cboCTime",arrValue[61]);
		SetComboxByValue("cboDTime",arrValue[62]);
		SetComboxByValue("cboOtherDiagnoseTime",arrValue[90]);
		SetComboxByValue("cboCardType",arrValue[63]);
		Common_SetValue("chkJohnDoe",arrValue[64]);
		Common_SetValue("chkNewBorn",arrValue[91]);
		if (arrValue[72]!='') {
			Common_SetValue("txtAFPReason",'[' + arrValue[72] + ']' + arrValue[68]);
		} else {
			Common_SetValue("txtAFPReason",arrValue[68]);
		}
		if (arrValue[73]!='') {
			Common_SetValue("txtBFPReason",'[' + arrValue[73] + ']' + arrValue[69]);
		} else {
			Common_SetValue("txtBFPReason",arrValue[69]);
		}
		if (arrValue[74]!='') {
			Common_SetValue("txtCFPReason",'[' + arrValue[74] + ']' + arrValue[70]);
		} else {
			Common_SetValue("txtCFPReason",arrValue[70]);
		}
		if (arrValue[75]!='') {
			Common_SetValue("txtDFPReason",'[' + arrValue[75] + ']' + arrValue[71]);
		} else {
			Common_SetValue("txtDFPReason",arrValue[71]);
		}
		if (arrValue[87]!='') {
			Common_SetValue("txtOtherDiagnoseFP",'[' + arrValue[87] + ']' + arrValue[88]);
		} else {
			Common_SetValue("txtOtherDiagnoseFP",arrValue[88]);
		}
		SetComboxByValue("cboFamCardType",arrValue[82]);
		Common_SetValue("txtFamIdentify",arrValue[83]);
		Common_SetValue("txtRegRoad",arrValue[84]);
		Common_SetValue("txtCurrRoad",arrValue[85]);
	}
	
	//重新加载病人基本信息
	obj.UpdatePatientInfo = function(){
		
		//判断是否新生儿
		var IsNewBorn=obj.ClsDTHReport.GetIsNewBornByPaadm(EpisodeID);
		if(IsNewBorn == 1) {
			Common_SetValue("chkNewBorn",true);
		}
		
		var separate=CHR_1;
		var strPatInfo = obj.ClsBasePatient.GetStringById("",separate,EpisodeID);
		var arrPatInfo = strPatInfo.split(separate);
		if(arrPatInfo.length>0){
			Common_SetValue("txtRegNo",arrPatInfo[1]);
			Common_SetValue("txtMrNo",arrPatInfo[22]);
			
			if (SSHospCode=='11-BJZYY') {
				//北京中医院特殊情况处理（姓名）
			} else {
				var PatName = arrPatInfo[2];
				Common_SetValue("txtPatName",PatName);     //姓名
			}
			
			//判断是否无名氏
			if ((PatName.indexOf("无名") > -1)||(PatName.indexOf("未知") > -1)) {
				Common_SetValue("chkJohnDoe",true);
			}
			
			var Sex = arrPatInfo[3];
			Common_SetValue("txtSex",Sex);
			if (Sex.indexOf("男") > -1) {
				Common_SetValue("cboPregnancies","","");
				obj.DisplayPregnanciesDiv(false);
			}else{
				obj.DisplayPregnanciesDiv(true);
			}
			
			if (SSHospCode=='11-BJZYY') {
				//北京中医院特殊情况处理（证件类型、身份证号）
			} else {
				//Common_SetValue("txtIdentify",arrPatInfo[8]);
				var CardInfo = obj.ClsDTHCommonSrv.GetPatActiveCardNo(PatientID);
				var arrCardInfo = CardInfo.split("^");
				// 1：不可修改病人基本信息 如果有效证件号不为空 则显示病人基本信息表中的证件信息
				// 如果病人基本信息中有效证件号为空且报告已存在,则显示报告中的证件信息
				if (arrCardInfo[0]!="") { 
					SetComboxByText("cboCardType",arrCardInfo[2]);  //证件类型
					Common_SetValue("txtIdentify",arrCardInfo[0]);
				}
			}
			
			Common_SetValue("txtBirthday",arrPatInfo[4]);
			
			//update by pylian 2015-07-17 年龄由接口来获取,解决已上报的报告打开时年龄变化的问题
			//var Age = ExtTool.RunServerMethod("DHCMed.SSIO.FromHisSrv","GetPapmiAge",PatientID,EpisodeID, obj.objCurrPaadm.AdmitDate,obj.objCurrPaadm.AdmitTime);
			//Common_SetValue("txtAge",Age);
			//update by mxp 2017-12-21 根据死亡日期、时间计算年龄
			if (arrPatInfo[25]!="") {
				obj.setAgeValue(arrPatInfo[25],arrPatInfo[26]);
			} else {
				obj.setAgeValue("","");
			}
	    
			var Marital = arrPatInfo[11];
			var Education = arrPatInfo[14];
			Common_SetValue("txtCountry",arrPatInfo[21]);
			Common_SetValue("txtNation",arrPatInfo[12]);
		}
		
		Common_SetDisabled("chkNewBorn",true);
		Common_SetDisabled("chkJohnDoe",true);
		Common_SetDisabled("txtRegNo",true);
		Common_SetDisabled("txtMrNo",true);
		
		if (SSHospCode=='11-BJZYY') {
			//北京中医院特殊情况处理
		} else {
			Common_SetDisabled("txtPatName",true);
			// 1:不可修改病人基本信息 证件号不为空时 证件号不可编辑
			if (Common_GetValue("txtIdentify")!="") {
				Common_SetDisabled("cboCardType",true);
				Common_SetDisabled("txtIdentify",true);
			}
		}
		
		Common_SetDisabled("txtSex",true);
		Common_SetDisabled("txtBirthday",true);
		Common_SetDisabled("txtAge",true);
		Common_SetDisabled("txtCountry",true);
		Common_SetDisabled("txtNation",true);
	}
	
	//新建报告页面初始化
	obj.InitRepByEpisodeID = function(){
		
		//判断是否新生儿
		var IsNewBorn=obj.ClsDTHReport.GetIsNewBornByPaadm(EpisodeID);
		if(IsNewBorn == 1) {
			Common_SetValue("chkNewBorn",true);
		}
		var separate=CHR_1;
		var strPatInfo = obj.ClsBasePatient.GetStringById("",separate,EpisodeID);
		var arrPatInfo = strPatInfo.split(separate);
		if(arrPatInfo.length>0){
			Common_SetValue("txtRegNo",arrPatInfo[1]);  //登记号
			var MrNo=obj.ClsDTHCommonSrv.GetMrNoByAdm(EpisodeID);
			if (MrNo){
				Common_SetValue("txtMrNo",MrNo);
			} else {
				Common_SetValue("txtMrNo",arrPatInfo[22]);  //病案号
			}
			var PatName = arrPatInfo[2];
			if (SSHospCode=='11-BJZYY') {
				//北京中医院不自动加载姓名，需要医生主动录入，上报时做一致性检查
			} else {
				Common_SetValue("txtPatName",PatName);     //姓名
			}
			//判断是否无名氏
			if ((PatName.indexOf("无名") > -1)||(PatName.indexOf("未知") > -1)) {
				Common_SetValue("chkJohnDoe",true);
			}
			
			var Sex = arrPatInfo[3];
			Common_SetValue("txtSex",Sex);   //性别
			if (Sex.indexOf("男") > -1) {
				Common_SetValue("cboPregnancies","","");
				obj.DisplayPregnanciesDiv(false);
			}else{
				obj.DisplayPregnanciesDiv(true);
			}
			
			/*var CardType = arrPatInfo[24];
			if (CardType=="") CardType="身份证";*/
			var CardInfo = obj.ClsDTHCommonSrv.GetPatActiveCardNo(PatientID);
			var arrCardInfo = CardInfo.split("^");
			var CardType = arrCardInfo[2];
			SetComboxByText("cboCardType",CardType);  //证件类型
			
			if (SSHospCode=='11-BJZYY') {
				//北京中医院不自动加载身份证号，需要医生主动录入，上报时做一致性检查
			} else {
				Common_SetValue("txtIdentify",arrCardInfo[0]);  //身份证号
			}
			
			Common_SetValue("txtBirthday",arrPatInfo[4]);  //生日
			
			//update by pylian 2015-07-17 年龄由接口来获取,解决已上报的报告打开时年龄变化的问题
			//var Age = ExtTool.RunServerMethod("DHCMed.SSIO.FromHisSrv","GetPapmiAge",PatientID,EpisodeID, obj.objCurrPaadm.AdmitDate,obj.objCurrPaadm.AdmitTime);
	       
			//Common_SetValue("txtAge",Age);  //年龄
			//update by mxp 2017-12-21 根据死亡日期、时间计算年龄
			if (arrPatInfo[25]!="") {
				obj.setAgeValue(arrPatInfo[25],arrPatInfo[26]);
			} else {
				obj.setAgeValue("","");
			}
			
			obj.strCurrAge = arrPatInfo[5]; //Add By LiYang 2015-03-13 记录患者日期，如果小于5岁，要提示上报儿童死亡报告卡
			var Marital = arrPatInfo[11];
			//var Occupation = arrPatInfo[13];
			var Education = arrPatInfo[14];
			if ((arrPatInfo[6]>0)||(arrPatInfo[7]>0)||(arrPatInfo[5]<8)) { //update by pylian 2015-04-29
				Marital = "未婚";
				Education = "初中及以下";
			}
			SetComboxByText("cboMarital",Marital);  //婚姻情况
			//SetComboxByText("cboOccupation",Occupation);  //职业
			SetComboxByText("cboEducation",Education);  //教育程度
			
			Common_SetValue("txtCountry",arrPatInfo[21]);  //国家
			Common_SetValue("txtNation",arrPatInfo[12]);  //民族
			Common_SetValue("txtCompany",arrPatInfo[15]);  //公司
			Common_SetValue("txtRegAddress",arrPatInfo[20]);  //户籍地址
			Common_SetValue("txtCurrAddress",arrPatInfo[20]);  //生前地址
			Common_SetValue("txtFamName",arrPatInfo[18]);  //联系人姓名
			SetComboxByText("cboFamRelation",arrPatInfo[16]);  //关系
			Common_SetValue("txtFamTel",arrPatInfo[19]);  //电话
			SetComboxByText("cboFamCardType","身份证");  //联系人证件类型
			Common_SetValue("txtFamIdentify","");  //联系人身份证号
			//Common_SetValue("txtFamAddress",arrPatInfo[17]);  //地址
			//add by pylian 2015-07-15 死亡患者有死亡时间时自动带出
			Common_SetValue("txtDeathDate",arrPatInfo[25]);
			Common_SetValue("txtDeathTime",arrPatInfo[26]);
			
			//诊断单位 默认显示三级医院
			var tmpDiagnoseUnit = obj.ClsSSConfigSrv.GetValueByKeyHosp("DTH-DiagnoseUnit", ""); 
			if (tmpDiagnoseUnit != '') {
				SetComboxByText("cboDiagnoseUnit",tmpDiagnoseUnit);
			}
		}
		obj.txtExamDate.setValue("");
		//obj.txtExamUser.setValue(session['LOGON.USERNAME']);  //调查人
		//obj.txtExamDate.setValue(new Date());  //调查日期
	}
	
	//退出按钮触发事件
	obj.btnCancle_Click=function(){
		if((ReportID != "")&&(obj.strCurrAge < 5)){
			var strChildRepID = ExtTool.RunServerMethod("DHCMed.DTH.ChildReport", "GetRepIDByDthID", ReportID)
			if(strChildRepID == "")
			{
				if(window.confirm("5周岁以下患儿需要填报儿童死亡报卡，现在是否上报？"))
				{
					obj.btnChildReport_Click();
				}
			}
		}
		
		//update by zf 20151023
		if(window.opener){
			//window.opener.location.reload();
			if (window.opener.RefreshRowByReportID){
				window.opener.RefreshRowByReportID(ReportID);
			}
		}
		window.close();
	}
	//退回按钮触发事件
	obj.btnReturn_Click = function(){
		var InitBackReasonWindow=new InitBackReason(obj);
		InitBackReasonWindow.mainWindow.show();
	}
	// 儿童死亡报卡触发事件
	obj.btnChildReport_Click = function(){
	
		if((ReportID == "")||((obj.RepStatusCode!="1")&&(obj.RepStatusCode!="2")&&(obj.RepStatusCode!="3")))
		{
			alert("请先保存医学死亡证明书信息再上报儿童死亡报卡!");
			return;
		}
		var url = "./dhcmed.dth.childreport.csp?ReportID=&DthReportID=" + ReportID + "&PatientID=" + PatientID + "&EpisodeID=" + EpisodeID;
		//window.open(url);
		//window.alert(url);
		window.showModalDialog(url, null, "center:yes;dialogHeight:420px;dialogWidth:800px;");
	}
	//二审按钮触发事件
	obj.btnCheckTwo_Click = function(){
		var status = 3;
		var resumeText = '';
		var retValue=ChangeDMRepStatus(status,resumeText)
		if ((retValue>-1)){
			alert("审核成功!");
			obj.InitRepPowerByStatus();
			obj.LoadEvent();
		}
	}
	obj.btnDel_Click = function(){
		Ext.MessageBox.confirm("提示","请确认是否作废?",function(btn){
			if(btn=="yes"){
				var status = 5;
				var resumeText = '';
				var retValue=ChangeDMRepStatus(status,resumeText)
				if ((retValue>-1)){
					alert("作废成功!");
					obj.InitRepPowerByStatus();
					obj.LoadEvent();
				}
			}
		});
	}
	//帮助文档按钮触发事件
	obj.btnHelpWord_Click=function(){
		var objTmp = ExtTool.StaticServerObject("DHCMed.Service");
		var TemplatePath = objTmp.GetTemplatePath();
		var fileName=TemplatePath+"\\\\"+"死亡证明书管理系统用户使用手册.doc";
		var newwindow=window.open(fileName,"","height="+ (screen.height-65) +" width=" + screen.width + " top=0 left=0 toolbar=no menubar=no scrollbars=yes resizable=yes location=no status=no")
		newwindow.document.oncontextmenu=function() {return false;} 
		newwindow.document.onselectstart=function() {return   false;}     
		newwindow.document.oncopy=function(){return   false;} 
	}
	
	//首联打印按钮触发事件
	obj.btnPrintOne_Click=function(){
		RepStatus=1;  //首联打印状态1 三联打印状态2
		var returnFlagIdS="";
		//允许打印次数
		var retPrintValue = obj.ClsSSConfigSrv.GetValueByKeyHosp("DTH-ReportPrintTimes",HospitalID);
		var inputStr=ReportID + CHR_1 + RepStatus;
		//已打印次数
		var retPrintNumValue=obj.ClsDTHReportSrv.GetTPrintNumStatus(inputStr,CHR_1);
		retPrintValue = parseInt(retPrintValue);
		retPrintNumValue = parseInt(retPrintNumValue);
		if (retPrintNumValue=="") retPrintNumValue=0;
		var IsPrintFlag = 0;
		if(SSHospCode=="22-CCZX"){
			if(obj.ClsDTHReportSrv.GetTimeOutFlag(ReportID)==0){
				IsPrintFlag = 1;
			}else{
				if (retPrintNumValue<retPrintValue){
					IsPrintFlag = 1;
				} else {
					//获取授权状态
					var PrintNum="",TPrintNum=retPrintNumValue;
					var inputStr = ReportID + CHR_1 + RepStatus + CHR_1 + TPrintNum + CHR_1 + PrintNum;
					var retGrantFlagValue=obj.ClsDTHReportSrv.GetGrantFlagStatus(inputStr,CHR_1);
					if ((retGrantFlagValue=="")||(retGrantFlagValue==0)){
						alert("死亡证不允许重复打印，请提交申请!");
						var InitTPrintReasonWindow=new InitTPrintReason(obj);
						InitTPrintReasonWindow.mainWindow.show();
					} else {
						IsPrintFlag = 1;
					}
				}
			}
		}else{
			if (retPrintNumValue<retPrintValue){
				IsPrintFlag = 1;
			} else {
				//获取授权状态
				var PrintNum="",TPrintNum=retPrintNumValue;
				var inputStr = ReportID + CHR_1 + RepStatus + CHR_1 + TPrintNum + CHR_1 + PrintNum;
				var retGrantFlagValue=obj.ClsDTHReportSrv.GetGrantFlagStatus(inputStr,CHR_1);
				if ((retGrantFlagValue=="")||(retGrantFlagValue==0)){
					alert("死亡证不允许重复打印，请提交申请!");
					var InitTPrintReasonWindow=new InitTPrintReason(obj);
					InitTPrintReasonWindow.mainWindow.show();
				} else {
					IsPrintFlag = 1;
				}
			}
		}
		if (IsPrintFlag != 1) return;
		var SSHospCodeArray=SSHospCode.split("-");
		var waringmes = "提示";
		if (SSHospCodeArray[0]=="11"){  //11是北京的医院，北京的医院一般需要纸单号
			var pNo = obj.ClsDTHPaperNoSrv.GetPaperNo(ReportID);
			if(pNo==""){
				value = window.showModalDialog("dhcmed.dth.paperno.csp?ReportID="+ReportID,window,"help:no;scroll:no;dialogWidth:300px;dialogHeight:150px;status:no;");
				if(value==undefined){
					return;
				}
				if(value<0){
					return;
				}
			}
			pNo = obj.ClsDTHPaperNoSrv.GetPaperNo(ReportID);
			waringmes += ":【当前纸单号为"+pNo+"】";
		}
		if (obj.SwitchPrint==1){
			if(SSHospCode=="------"){
				//选择报告是否显示补打字样
				returnFlagIdS = window.showModalDialog("dhcmed.dth.addprintflag.csp",window,"help:no;scroll:no;dialogWidth:300px;dialogHeight:50px;status:no;");
				if(returnFlagIdS==undefined){
					returnFlagIdS = ""
				}
			}
		}
		Ext.MessageBox.confirm(waringmes,"（1）本次将是死亡证的正式打印，在打印前请再次核对所有信息。<br/>（2）打印后的死亡证将被锁定并保存，之后不得更改。<br/>（3）正式打印1次后，将不得再次打印。",function(btn){
			if(btn=="yes"){
				if (SSHospCodeArray[0]=="11"){
					var retValue = obj.ClsDTHPaperNoSrv.UpdatePaperNo(ReportID,"1","1");
					if ((retValue>-1)){
						//Ext.Msg.alert("提示","更新纸单号成功!");
					}else{
						Ext.Msg.alert("提示","更新纸单号失败!");
						return
					}
				}
				var LogonLocID=session['LOGON.CTLOCID'];
				var LogonUserID=session['LOGON.USERID'];
				var PrintNum="",TPrintNum=retPrintNumValue;
				var retValue=ChangeDMRepPrint(LogonLocID,LogonUserID,RepStatus,PrintNum,TPrintNum);
				try {
					if (obj.TemplateVersion==1) {
						ExportTwoDataToExcelNew("","","",ReportID,returnFlagIdS);
						obj.InitRepPowerByStatus(); //首联打印后刷新
					}else{
						ExportTwoDataToExcel("","","",ReportID);
					}
				}catch(e){}
	  		}
		})
	}
	
	//三联打印按钮触发事件
	obj.btnPrintThree_Click=function(){
		var returnIdS="";
		var returnFlagIdS="";
		RepStatus=2;  //首联打印状态1 三联打印状态2
		
		//允许打印次数
		var retPrintValue = obj.ClsSSConfigSrv.GetValueByKeyHosp("DTH-ReportPrintTimes",HospitalID);
		//已打印次数
		var inputStr=ReportID + CHR_1 + RepStatus;
		var retPrintNumValue=obj.ClsDTHReportSrv.GetPrintNumStatus(inputStr,CHR_1);
		retPrintValue = parseInt(retPrintValue);
		retPrintNumValue = parseInt(retPrintNumValue);
		var IsPrintFlag = 0;
		
		if(SSHospCode=="22-CCZX"){
			if(obj.ClsDTHReportSrv.GetTimeOutFlag(ReportID)==0){
				IsPrintFlag = 1;
			}else{
				if (retPrintNumValue<retPrintValue){
					IsPrintFlag = 1;
				} else {
					//获取授权状态
					TPrintNum="",PrintNum=retPrintNumValue;
					var inputStr=ReportID + CHR_1 + RepStatus + CHR_1 + TPrintNum + CHR_1 + PrintNum;
					var retGrantFlagValue=obj.ClsDTHReportSrv.GetGrantFlagStatus(inputStr,CHR_1);
					if ((retGrantFlagValue=="")||(retGrantFlagValue==0)){
						alert("死亡证不允许重复打印，请提交申请!")
						var InitPrintReasonWindow=new InitPrintReason(obj);
						InitPrintReasonWindow.mainWindow.show();
					} else {
						IsPrintFlag = 1;
					}
				}
			}
		}else{
			if (retPrintNumValue<retPrintValue){
				IsPrintFlag = 1;
			} else {
				//获取授权状态
				TPrintNum="",PrintNum=retPrintNumValue;
				var inputStr=ReportID + CHR_1 + RepStatus + CHR_1 + TPrintNum + CHR_1 + PrintNum;
				var retGrantFlagValue=obj.ClsDTHReportSrv.GetGrantFlagStatus(inputStr,CHR_1);
				if ((retGrantFlagValue=="")||(retGrantFlagValue==0)){
					alert("死亡证不允许重复打印，请提交申请!")
					var InitPrintReasonWindow=new InitPrintReason(obj);
					InitPrintReasonWindow.mainWindow.show();
				} else {
					IsPrintFlag = 1;
				}
			}
		}
		if (IsPrintFlag != 1) return;
		
		var SSHospCodeArray=SSHospCode.split("-");
		var waringmes = "提示";
		if ((SSHospCodeArray[0]=="11")&&(SSHospCode != '11-AZ')){
			var OneFlag = 0;
			var ThreeFlag = 1;
			var havePaperNo = obj.ClsDTHPaperNoSrv.GetPaperNo(ReportID);
			//var newNoFlag = obj.ClsDTHPaperNoSrv.CreatePaperNoFlag(ReportID);  //新生成编号模式 每次三联打印都要新生成纸单号 返回值：1，0
			if(havePaperNo==""){
				value = window.showModalDialog("dhcmed.dth.paperno.csp?ReportID="+ReportID,window,"help:no;scroll:no;dialogWidth:300px;dialogHeight:150px;status:no;");
				if(value==undefined){
					return;
				}
				if(value<0){
					return;
				}
			}
			var pNo = obj.ClsDTHPaperNoSrv.GetPaperNo(ReportID);
			waringmes += ":【当前纸单号为"+pNo+"】";
		}
		if (obj.SwitchPrint==1){
			if((SSHospCode=="-----")&&(retPrintNumValue>=1)){  //从第二次打印开始选择打印哪联
				//选择三联打印  直接退出，打印三联；选择某联后确定，将打印对应联
				returnIdS = window.showModalDialog("dhcmed.dth.switchprint.csp",window,"help:no;scroll:no;dialogWidth:300px;dialogHeight:200px;status:no;");
				if(returnIdS==undefined){
					returnIdS="";
				}
			}
			if((SSHospCode=="-----")&&(retPrintNumValue>=1)){
				//选择报告是否显示补打字样
				returnFlagIdS = window.showModalDialog("dhcmed.dth.addprintflag.csp",window,"help:no;scroll:no;dialogWidth:300px;dialogHeight:50px;status:no;");
				if(returnFlagIdS==undefined){
					returnFlagIdS = ""
				}
				
			}
			if((SSHospCode=="-----")&&(retPrintNumValue>=1)){  //如果有医院同时想要显示【补打】字样和选择打印功能，为了减少一次弹窗可以用下面预留方式
				//选择三联打印同时选择报告是否显示补打字样
				SwitchFlagIds = window.showModalDialog("dhcmed.dth.addandswitch.csp",window,"help:no;scroll:no;dialogWidth:300px;dialogHeight:200px;status:no;");
				if(SwitchFlagIds==undefined){
					returnIdS="";
					returnFlagIdS="";
				}else{
					returnIdS = SwitchFlagIds.split("-")[0];
					returnFlagIdS = SwitchFlagIds.split("-")[1];
				}
			}
		}
		Ext.MessageBox.confirm(waringmes,"（1）本次将是死亡证的正式打印，在打印前请再次核对所有信息。<br/>（2）打印后的死亡证将被锁定并保存，之后不得更改。<br/>（3）正式打印1次后，将不得再次打印。",function(btn){
			if(btn=="yes"){
				
				if (SSHospCodeArray[0]=="11") {
					if (SSHospCode != '11-AZ') {
						var retValue = obj.ClsDTHPaperNoSrv.UpdatePaperNo(ReportID,"3","1");
						if ((retValue>-1)){
							//Ext.Msg.alert("提示","更新纸单号成功!");
						}else{
							Ext.Msg.alert("提示","更新纸单号失败!");
							return
						}
					}else {
						//安贞医院要求在打印的时候自动生成纸单号
						//取可用的最新的纸单号，并同时跟新纸单号的状态和纸单号的打印状态
						var CtlocId=session['LOGON.CTLOCID'];
						var UserID=session['LOGON.USERID'];
						var StatusDR = 3;  //已用
						var instr = StatusDR + "^" + CtlocId + "^" + CtlocId + "^" + UserID + "^" + ReportID;
						var retValue = obj.ClsDTHPaperNoSrv.GetAndUpdateNewPaperNo(ReportID,instr);
						if ((retValue>-1)){
						}else{
							Ext.Msg.alert("提示","更新纸单号失败!");
							return
						}
					}
				}
				var LogonLocID=session['LOGON.CTLOCID'];
				var LogonUserID=session['LOGON.USERID'];
				TPrintNum="",PrintNum=retPrintNumValue;
				var retValue=ChangeDMRepPrint(LogonLocID,LogonUserID,RepStatus,PrintNum,TPrintNum);
				try {
					if(obj.TemplateVersion==1) {
						ExportDataToExcelNew("","","",ReportID,returnIdS,returnFlagIdS);
						obj.InitRepPowerByStatus(); //三联打印后刷新
					}else{
						ExportDataToExcel("","","",ReportID);
					}
				}catch(e){}
			}
		})
	}
    
	//编码按钮触发事件 2保健科审核
	obj.btnCheckOne_Click=function(){
		var ReportStatus=2;
		var resumeText="";
		var inStr="",separate="^";
		
		var BaseReason=obj.cboBaseReason.getRawValue();     //根本死因
		var BaseReasonICD=obj.txtBaseReasonICD.getValue();  //根本死因ICD
		if (BaseReasonICD.split("C02").length>1) {
			ExtTool.alert("提示","根本死因诊断错误!");
			return;
		}
		var Damage=obj.cboDamage.getRawValue();             //损伤中毒
		var DamageICD=obj.txtDamageICD.getValue();          //损伤中毒ICD
		var AReason=obj.cboAReason.getRawValue();           //A死因
		var AReasonICD=obj.txtAReasonICD.getValue();        //A死因编码
		var BReason=obj.cboBReason.getRawValue();           //B死因
		var BReasonICD=obj.txtBReasonICD.getValue();        //B死因编码
		var CReason=obj.cboCReason.getRawValue();           //C死因
		var CReasonICD=obj.txtCReasonICD.getValue();        //C死因编码
		var DReason=obj.cboDReason.getRawValue();           //D死因
		var DReasonICD=obj.txtDReasonICD.getValue();        //D死因编码
		var OtherDiagnose=obj.cboOtherDiagnose.getRawValue();           //D死因
		var OtherDiagnoseICD=obj.txtOtherDiagnoseICD.getValue();        //D死因编码
		var inStr = ReportID;                      //ReportID
		inStr = inStr + separate + BaseReason;     //根本死因
		inStr = inStr + separate + BaseReasonICD;  //根本死因ICD
		inStr = inStr + separate + Damage;         //损伤中毒
		inStr = inStr + separate + DamageICD;      //损伤中毒ICD
		inStr = inStr + separate + AReason;        //A死因
		inStr = inStr + separate + BReason;        //A死因编码
		inStr = inStr + separate + CReason;        //B死因
		inStr = inStr + separate + DReason;        //B死因编码
		inStr = inStr + separate + AReasonICD;     //C死因  10
		inStr = inStr + separate + BReasonICD;     //C死因编码
		inStr = inStr + separate + CReasonICD;     //D死因
		inStr = inStr + separate + DReasonICD;     //D死因编码
		inStr = inStr + separate + OtherDiagnose;     //其他死因 14
		inStr = inStr + separate + OtherDiagnoseICD;     //其他死因编码 15
		var retVal=obj.ClsDTHReport.UpdateDMRepDiagnose(inStr,separate);
		if (parseInt(retVal)>0) {
			var retValue=ChangeDMRepStatus(ReportStatus,resumeText);
			if (parseInt(retValue)>0) {
				ExtTool.alert("提示","编码保存成功!");
				obj.InitRepPowerByStatus();
				obj.LoadEvent();
			} else {
				ExtTool.alert("错误提示","保存审核状态错误!");
			}
		} else {
			ExtTool.alert("错误提示","编码保存错误!");
		}
	}
	
	//三联打印授权按钮触发事件 三联打印授权
	obj.btnGrantThree_Click=function(){
		var initPopStorageWindow=new InitPopStorage(obj);
		initPopStorageWindow.mainWindow.show(); 
	}
	
	//二联打印授权按钮触发事件 二联打印授权
	obj.btnGrantOne_Click=function(){
		var initPopStorageWindow=new InitPopStorageTwo(obj);
		initPopStorageWindow.mainWindow.show();
	}
	
	//暂存按钮触发事件
	obj.btnSaveTmp_Click=function(){
		if ((obj.RepStatusCode==2)||(obj.RepStatusCode==3)) {
			ExtTool.alert("提示","已编码或已审核的报告,不允许再修改!");
			return;
		}
		obj.SaveData(6);
	}
	
	//死亡证数据完整性校验方法
	String.prototype.trim = function()  
	{  
	   return this.replace(/(^\s*)|(\s*$)/g, "");  
	}  
	obj.CheckRepData = function(){
		var errInfo = '';
		if (SSHospCode=='11-BJZYY') {
			//北京中医院检查病人基本信息（报告内容与病人基本信息【姓名、身份证号】一致性检查）
			var strPatInfo = obj.ClsBasePatient.GetStringById("",CHR_1,EpisodeID);
			var arrPatInfo = strPatInfo.split(CHR_1);
			if(arrPatInfo.length>0){
				var basePatName  = arrPatInfo[2];
				var baseCardType = arrPatInfo[24];
				var baseIdentify = arrPatInfo[8];
				var CardType = obj.cboCardType.getRawValue();
				var Identify = obj.txtIdentify.getValue();
				var PatName  = obj.txtPatName.getValue();
				if (basePatName != '') {
					if (basePatName != PatName){
						 errInfo ="建卡处病人姓名【" + basePatName + "】与死亡证中病人姓名【"+PatName+"】不一致，请核实!<br/>";
					}
				}
				if ((baseCardType.indexOf('身份证')>-1)&&((baseCardType.indexOf('身份证')>-1)||(baseCardType.indexOf('户口簿')>-1))) {
					if(baseIdentify!=Identify){
						errInfo +="建卡处病人身份证号【"+baseIdentify+"】与报告中病人身份证号【"+Identify+"】不一致，请核实!";
					}
				}
			}
			if (errInfo!="") return errInfo;
		} else {
			//其他医院暂时不做检查
		}
		//友谊医院身份号不能和以前填过的报告中的号码重复
		if (SSHospCode=='11-YY') {
			var Identify=obj.txtIdentify.getValue();    //身份证
			var IdentifyFlag = obj.ClsDTHReportSrv.CheckIdentify(Identify,EpisodeID);
			if(IdentifyFlag==1){
				return "身份证号重复，请核实后再上报！";
			}
		}
		
		var PatName=obj.txtPatName.getValue();
		if (PatName=="") errInfo += '姓名不允许为空!<br>';
		var Sex = obj.txtSex.getValue();
		if (Sex=="") errInfo += '性别不允许为空!<br>';
		var Age=obj.txtAge.getValue();
		if (Age=="") errInfo += '年龄不允许为空!<br>';
		var Birthday=obj.txtBirthday.getValue();
		if (Birthday=="") errInfo += '出生日期不允许为空!<br>';
		var Country=obj.txtCountry.getValue();
		if (Country=="") errInfo += '国家或地区不允许为空!<br>';
		var Nation=obj.txtNation.getValue();
		if (Nation=="") errInfo += '民族不允许为空!<br>';
		var CardType=obj.cboCardType.getValue();
		if (CardType=="") errInfo += '证件类型不允许为空!<br>';
		var Identify=obj.txtIdentify.getValue();
		if (Identify=="") errInfo += '证件号码不允许为空!<br>';
		var Marital=obj.cboMarital.getValue();
		if (Marital=="") errInfo += '婚姻状况不允许为空!<br>';
		var Education=obj.cboEducation.getValue();
		if (Education=="") errInfo += '文化程度不允许为空!<br>';
		var Occupation=obj.cboOccupation.getValue();
		if (Occupation=="") errInfo += '职业不允许为空!<br>';
		var Company=obj.txtCompany.getValue();
		if (Company=="") errInfo += '工作单位不允许为空!<br>';
		//var RegAddress=obj.txtRegAddress.getValue();
		//if (RegAddress=="") errInfo += '户籍地址不允许为空!<br>';
		var RegProvince = obj.cboRegProvince.getValue();
		if (RegProvince=="") errInfo += "户籍地址省不允许为空<br/>";
		var RegCity = obj.cboRegCity.getValue();
		if (RegCity=="") errInfo += "户籍地址市不允许为空<br/>";
		var RegCounty = obj.cboRegCounty.getValue();
		if (RegCounty=="") errInfo += "户籍地址县不允许为空<BR/>";
		var RegVillage = obj.cboRegVillage.getValue();
		if (RegVillage=="") errInfo += "户籍地址乡(街道)不允许为空<BR/>";
		var RegAddress=obj.txtRegRoad.getValue();
		if (RegAddress=="") errInfo += "户籍地址村(小区)不允许为空<BR/>";
		//var CurrAddress=obj.txtCurrAddress.getValue();
		//if (CurrAddress=="") errInfo += '生前地址不允许为空!<br>';
		var CurrProvince=obj.cboCurrProvince.getValue();
		if (CurrProvince=="") errInfo += "生前住址省不允许为空<BR/>";
		var CurrCity=obj.cboCurrCity.getValue();
		if (CurrCity=="") errInfo += "生前住址市不允许为空<BR/>";
		var CurrCounty=obj.cboCurrCounty.getValue();
		if (CurrCounty=="") errInfo += "生前住址县不允许为空<BR/>";
		var CurrVillage=obj.cboCurrVillage.getValue();
		if (CurrVillage=="") errInfo += "生前住址乡(街道)不允许为空<BR/>";
		var CurrAddress=obj.txtCurrRoad.getValue();
		if (CurrAddress=="") errInfo += "生前住址村(小区)不允许为空<BR/>";		
		//手工录入死亡编号，则死亡编号不许为空!
		var DeathNo=obj.txtDeathNo.getValue();
		var DeathNoType = ExtTool.RunServerMethod("DHCMed.DTHService.RepNoSrv", "GetDeathNoType",HospitalID);
		if((DeathNoType == 0) && (DeathNo.trim() == "")) errInfo = errInfo + '死亡证明书编号不允许为空!<br>';
		var DeathDate=obj.txtDeathDate.getRawValue();
		if (DeathDate=="") errInfo += '死亡日期不允许为空!<br>';
		//add by mxp 20160322 fix bug 187178 死亡日期不能大于当前日期
		//var NowDate = new Date().format("Y-m-d");
		if ((DeathDate!="")&&(Common_ComputeDays("txtDeathDate")<0)) {
			errInfo += '死亡日期不允许大于当前日期!<br>';
		}
		var DeathTime=obj.txtDeathTime.getRawValue();
		if (DeathTime=="") errInfo += '死亡时间不允许为空!<br>';
		if(Sex=="女") {
			var Pregnancies=obj.cboPregnancies.getValue();
			if (Pregnancies=="") errInfo += '妊娠期或终止妊娠42天内不允许为空!<br>';
		}
		var FamName=obj.txtFamName.getValue();
		if (FamName=="") errInfo += '家属姓名不允许为空!<br>';
		var FamTel=obj.txtFamTel.getValue();
		if (FamTel=="") errInfo += '联系电话不允许为空!<br>';
		var FamRelation=obj.cboFamRelation.getValue();
		if (FamRelation=="") errInfo += '与死者关系不允许为空!<br>';
		var FamAddr=obj.txtFamAddress.getValue();
		if (FamAddr=="") errInfo += '家属住址或工作单位不允许为空!<br>';
		if (SSHospCode=='11-BJZYY') {
			var FamCardType=obj.cboFamCardType.getValue();
			if (FamCardType=="") errInfo += '家属证件类型不允许为空!<br>';
			var FamIdentify=obj.txtFamIdentify.getValue();
			if (FamIdentify=="") errInfo += '家属证件号码不允许为空!<br>';
		}
		var AReason = obj.cboAReason.getRawValue();
		var BReason = obj.cboBReason.getRawValue();
		var CReason = obj.cboCReason.getRawValue();
		var DReason = obj.cboDReason.getValue();
		if ((AReason=="")&&((BReason!="")||(CReason!="")||(DReason!=""))) {
			errInfo += '(a)直接导致死亡的疾病或情况不允许为空!<br>';
		}
		if ((BReason=="")&&((CReason!="")||(DReason!=""))) {
			errInfo += '(b)引起(a)的疾病或情况不允许为空!<br>';
		}
		if ((CReason=="")&&(DReason!="")) {
			errInfo += '(c)引起(b)的疾病或情况不允许为空!<br>';
		}
		if (AReason!=""){
			var AInterval = obj.txtAInterval.getValue();
			var ATime = obj.cboATime.getValue();
			if(AInterval==""){
				errInfo += 'A诊断时间间隔不允许为空!<br>';
			}
			if(ATime==""){
				errInfo += 'A诊断时间单位不允许为空!<br>';
			}
		}
		if (BReason!=""){
			var BInterval = obj.txtBInterval.getValue();
			var BTime = obj.cboBTime.getValue();
			if(BInterval==""){
				errInfo += 'B诊断时间间隔不允许为空!<br>';
			}
			if(BTime==""){
				errInfo += 'B诊断时间单位不允许为空!<br>';
			}
		}
		if (CReason!=""){
			var CInterval = obj.txtCInterval.getValue();
			var CTime = obj.cboCTime.getValue();
			if(CInterval==""){
				errInfo += 'C诊断时间间隔不允许为空!<br>';
			}
			if(CTime==""){
				errInfo += 'C诊断时间单位不允许为空!<br>';
			}
		}
		if (DReason!=""){
			var DInterval = obj.txtDInterval.getValue();
			var DTime = obj.cboDTime.getRawValue();
			if(DInterval==""){
				errInfo += 'D诊断时间间隔不允许为空!<br>';
			}
			if(DTime==""){
				errInfo += 'D诊断时间单位不允许为空!<br>';
			}
		}
		var OtherDiagnose = obj.cboOtherDiagnose.getRawValue();
		if (OtherDiagnose!=""){
			var OtherDiagnoseInterval = obj.txtOtherDiagnoseInterval.getValue();
			var OtherDiagnoseTime = obj.cboOtherDiagnoseTime.getValue();
			if(OtherDiagnoseInterval==""){
				errInfo += '其他诊断时间间隔不允许为空!<br>';
			}
			if(OtherDiagnoseTime==""){
				errInfo += '其他诊断时间单位不允许为空!<br>';
			}
		}
		var DiagnoseUnit=obj.cboDiagnoseUnit.getValue();
		if (DiagnoseUnit=="") errInfo += '诊断单位不允许为空!<br>';
		var DiagnoseBasis=obj.cboDiagnoseBasis.getValue();
		if (DiagnoseBasis=="") errInfo += '诊断依据不允许为空!<br>';
		var cboDeathPlace=obj.cboDeathPlace.getValue()
		if (cboDeathPlace==""){
			errInfo += '死亡地点不允许为空!<br>';
		}else{
			var DeathPlaceDesc=obj.cboDeathPlace.getRawValue();     //死亡地点
			var ExamMedical=obj.txtExamMedical.getValue();          //死者生前病史及症状体征
			var ExamDeathReason=obj.txtExamDeathReason.getValue();  //死因推断
			var ExamName = obj.txtExamName.getValue();	//被调查者
			var ExamRelation = obj.cboExamRelation.getValue(); //与死者关系
			var ExamTel = obj.txtExamTel.getValue(); //联系电话
			var ExamAddress = obj.txtExamAddress.getValue(); //联系地址
			var ExamUser = obj.txtExamUser.getValue(); //调查者
			var ExamDate = obj.txtExamDate.getValue(); //调查日期
			
			if ((DeathPlaceDesc!="医疗卫生机构(急诊)")&&(DeathPlaceDesc!="医疗卫生机构(病房)")){
				if((ExamMedical=="")||(ExamDeathReason=="")){
				   errInfo += '死亡地点不在医疗卫生机构的患者，死者生前病史及症状体征和死因推断不允许为空!<br>';
				}
				if (ExamName == "") {
					errInfo += '死亡地点不在医疗卫生机构的患者，被调查者不允许为空!<br>';
				}
				if (ExamRelation == "") {
					errInfo += '死亡地点不在医疗卫生机构的患者，与死者关系不允许为空!<br>';
				}
				if (ExamTel == "") {
					errInfo += '死亡地点不在医疗卫生机构的患者，联系电话不允许为空!<br>';
				}
				if (ExamAddress == "") {
					errInfo += '死亡地点不在医疗卫生机构的患者，联系地址不允许为空!<br>';
				}
				if (ExamUser == "") {
					errInfo += '死亡地点不在医疗卫生机构的患者，调查者不允许为空!<br>';
				}
				if (ExamDate == "") {
					errInfo += '死亡地点不在医疗卫生机构的患者，调查日期不允许为空!<br>';
				}
			}
			
		}
		
		//时间间隔转换成分钟
		//根据时间间隔，检查诊断填写顺序是否正确
		var Atim=0,Btim=0,Ctim=0,Dtim=0;
		var AInterval=obj.txtAInterval.getValue();             //时间间隔
		var ATime=obj.cboATime.getValue();                  //时间单位
		var BInterval=obj.txtBInterval.getValue();             //时间间隔
		var BTime=obj.cboBTime.getValue();                  //时间单位
		var CInterval=obj.txtCInterval.getValue();             //时间间隔
		var CTime=obj.cboCTime.getValue();                  //时间单位
		var DInterval=obj.txtDInterval.getValue();             //时间间隔
		var DTime=obj.cboDTime.getValue();                  //时间单位
		var ATimeCode=obj.ClsDTHReportSrv.GetDataById(ATime);  //时间单位代码
		var BTimeCode=obj.ClsDTHReportSrv.GetDataById(BTime);  //时间单位代码
		var CTimeCode=obj.ClsDTHReportSrv.GetDataById(CTime);  //时间单位代码
		var DTimeCode=obj.ClsDTHReportSrv.GetDataById(DTime);  //时间单位代码
		if (ATimeCode!=""){
		   if (ATimeCode==1) {Atim=AInterval*365*24*60}
		   if (ATimeCode==2) {Atim=AInterval*30*24*60}
		   if (ATimeCode==3) {Atim=AInterval*24*60}
		   if (ATimeCode==4) {Atim=AInterval*60}
		   if (ATimeCode==5) {Atim=AInterval*1}
		}
		if (BTimeCode!=""){
		   if (BTimeCode==1) {Btim=BInterval*365*24*60}
		   if (BTimeCode==2) {Btim=BInterval*30*24*60}
		   if (BTimeCode==3) {Btim=BInterval*24*60}
		   if (BTimeCode==4) {Btim=BInterval*60}
		   if (BTimeCode==5) {Btim=BInterval*1}
		}
		if (CTimeCode!=""){
		   if (CTimeCode==1) {Ctim=CInterval*365*24*60}
		   if (CTimeCode==2) {Ctim=CInterval*30*24*60}
		   if (CTimeCode==3) {Ctim=CInterval*24*60}
		   if (CTimeCode==4) {Ctim=CInterval*60}
		   if (CTimeCode==5) {Ctim=CInterval*1}
		}
		if (DTimeCode!=""){
		  if (DTimeCode==1) {Dtim=DInterval*365*24*60}
		  if (DTimeCode==2) {Dtim=DInterval*30*24*60}
		  if (DTimeCode==3) {Dtim=DInterval*24*60}
		  if (DTimeCode==4) {Dtim=DInterval*60}
		  if (DTimeCode==5) {Dtim=DInterval*1}
		}
		if (Atim>Btim&&Btim!="0"){
			errInfo += "'(a)直接导致死亡的疾病或情况'与'(b)引起(a)的疾病或情况',顺序填写有误!";
		} else if (Ctim!="0"&&Btim>Ctim){
			errInfo += "'(b)引起(a)的疾病或情况'与'(c)引起(b)的疾病或情况',顺序填写有误!";
		} else if ((Ctim!="0"&&Dtim!="0")&&(Ctim>Dtim)){
			errInfo += "'(c)引起(b)的疾病或情况'与'(d)引起(c)的疾病或情况',顺序填写有误!";
		} else if (Ctim!="0"&&Atim>Ctim){
			errInfo += "'(a)直接导致死亡的疾病或情况'与'(c)引起(b)的疾病或情况',顺序填写有误!";
		} else if (Dtim!="0"&&Atim>Dtim){
			errInfo += "'(a)直接导致死亡的疾病或情况'与'(d)引起(c)的疾病或情况',顺序填写有误!";
		} else if (Dtim!="0"&&Btim>Dtim){
			errInfo += "'(b)引起(a)的疾病或情况'与'(d)引起(c)的疾病或情况',顺序填写有误!";
		}
		//add by cpj 
		//增加职业控制工作单位
		var occupationList = obj.ClsSSConfigSrv.GetValueByKeyHosp("DTHOccupationToCompany", "");
		var occupationArray = occupationList.split("~");
		
		var OccupationRawValue=obj.cboOccupation.getRawValue();
		var Company = obj.txtCompany.getValue();
		for (var i = 0; i < occupationArray.length; i ++) {
			var occupation = occupationArray[i] ;
			if (OccupationRawValue == occupation) {
				if ((Company=="") || (Company == "无")) {
					errInfo += '工作单位不允许为空或者"无"!';
				}
			}
		}
		
		if (PatName.indexOf('无名氏')>-1)
		{
			errInfo='';	//无名氏信息不做验证
		}

		return errInfo;
	}
	
	//保存死亡证方法
	obj.SaveData = function(RepStatus){
		var separate="^";                                 //分隔符
		var MrNo=obj.txtMrNo.getValue();                  //病案号
		var Name=obj.txtPatName.getValue();               //患者姓名
		var Sex=obj.txtSex.getValue();                    //性别
		var Birthday=obj.txtBirthday.getRawValue();       //出生日期
		var Age=obj.txtAge.getValue();                    //年龄
		//var CardT=obj.cboCardType.getRawValue();          //证件类型
		var CardType=obj.cboCardType.getValue();          //证件类型ID
		var Identify=obj.txtIdentify.getValue();          //证件号码
		var PapmiNo=obj.txtRegNo.getValue();              //登记号
		var Occupation=obj.cboOccupation.getValue();      //职业
		var Country=obj.txtCountry.getValue();            //国家或地区
		var Nation=obj.txtNation.getValue();              //民族
		var Marital=obj.cboMarital.getValue();            //婚姻状况
		var Education=obj.cboEducation.getValue();        //文化程度
		var Company=obj.txtCompany.getValue();            //工作单位
		var FamName=obj.txtFamName.getValue();            //家属姓名
		var FamRelation=obj.cboFamRelation.getValue();    //与死者关系
		var FamTel=obj.txtFamTel.getValue();              //家属联系电话
		var FamAddr=obj.txtFamAddress.getValue();         //家属住址
		//var FamCardType=obj.cboFamCardType.getRawValue(); //家属证件类型
		var FamCardTypeId=obj.cboFamCardType.getValue();  //家属证件类型ID
		var FamIdentify=obj.txtFamIdentify.getValue();    //家属证件号码
		var Pregnancies=obj.cboPregnancies.getValue();    //孕产情况
		
		//户籍地址(省市县乡)
		var RegProvince=Common_GetValue('cboRegProvince');
		var RegCity=Common_GetValue('cboRegCity');
		var RegCounty=Common_GetValue('cboRegCounty');
		var RegVillage=Common_GetValue('cboRegVillage');
		var RegProvinceDesc=Common_GetText('cboRegProvince');
		var RegCityDesc=Common_GetText('cboRegCity');
		var RegCountyDesc=Common_GetText('cboRegCounty');
		var RegVillageDesc=Common_GetText('cboRegVillage');
		var RegRoad=Common_GetValue('txtRegRoad');
		var RegAddress = RegProvinceDesc + RegCityDesc + RegCountyDesc + RegVillageDesc + RegRoad;
		//生前住址(省市县乡)
		var CurrProvince=Common_GetValue('cboCurrProvince');
		var CurrCity=Common_GetValue('cboCurrCity');
		var CurrCounty=Common_GetValue('cboCurrCounty');
		var CurrVillage=Common_GetValue('cboCurrVillage');
		var CurrProvinceDesc=Common_GetText('cboCurrProvince');
		var CurrCityDesc=Common_GetText('cboCurrCity');
		var CurrCountyDesc=Common_GetText('cboCurrCounty');
		var CurrVillageDesc=Common_GetText('cboCurrVillage');
		var CurrRoad=Common_GetValue('txtCurrRoad');
		var CurrAddress = CurrProvinceDesc + CurrCityDesc + CurrCountyDesc + CurrVillageDesc + CurrRoad;
		
		var RepNo=obj.txtDeathNo.getValue();                       //报告编号
		var DeathNo=obj.txtDeathNo.getValue();                     //死亡编号
		var DeathDate=obj.txtDeathDate.getRawValue();             //死亡日期
		var DeathTime=obj.txtDeathTime.getRawValue();                //死亡时间
		var ExamMedical=obj.txtExamMedical.getValue();             //死者生前病史及症状体征
		ExamMedical =ExamMedical.replace(/["^,\\]/g, " ");
		var ExamDeathReason=obj.txtExamDeathReason.getValue();     //死亡推断
		var DeathPlace=obj.cboDeathPlace.getValue()                //死亡地点
		var AReason=obj.cboAReason.getRawValue();                  //A诊断
		var AReasonICD=obj.txtAReasonICD.getValue();               //A诊断ICD10
		var AInterval=obj.txtAInterval.getValue();                 //时间间隔
		var ATime=obj.cboATime.getValue();                         //时间单位
		if (AReason==""){
			AReasonICD="";
			AInterval="";
			ATime="";
		}
		var BReason=obj.cboBReason.getRawValue();                  //B诊断
		var BReasonICD=obj.txtBReasonICD.getValue();               //B诊断ICD10
		var BInterval=obj.txtBInterval.getValue();                 //时间间隔
		var BTime=obj.cboBTime.getValue();                         //时间单位
		if (BReason==""){
			BReasonICD="";
			BInterval="";
			BTime="";
		}
		var CReason=obj.cboCReason.getRawValue();                  //C诊断
		var CReasonICD=obj.txtCReasonICD.getValue();               //C诊断ICD10
		var CInterval=obj.txtCInterval.getValue();                 //时间间隔
		var CTime=obj.cboCTime.getValue();                         //时间单位
		if (CReason==""){
			CReasonICD="";
			CInterval="";
			CTime="";
		}
		var DReason=obj.cboDReason.getRawValue();                  //D诊断
		var DReasonICD=obj.txtDReasonICD.getValue();               //D诊断ICD10
		var DInterval=obj.txtDInterval.getValue();                 //时间间隔
		var DTime=obj.cboDTime.getValue();                         //时间单位
		if (DReason==""){
			DReasonICD="";
			DInterval="";
			DTime="";
		}
		var OtherDiagnose=obj.cboOtherDiagnose.getRawValue();         //其他诊断
		var OtherDiagnoseICD=obj.txtOtherDiagnoseICD.getValue();         //其他诊断ICD
		var OtherDiagnoseInterval=obj.txtOtherDiagnoseInterval.getValue();         //时间间隔
		var OtherDiagnoseTime=obj.cboOtherDiagnoseTime.getValue();         //时间单位
		var DamageDiagnose=obj.cboDamageDiagnose.getRawValue();    //损伤中毒诊断
		var DamageDiagnoseICD=obj.cboDamageDiagnoseICD.getValue(); //损伤中毒诊断ICD10
		var DiagnoseUnit=obj.cboDiagnoseUnit.getValue();           //诊断单位
		var DiagnoseBasis=obj.cboDiagnoseBasis.getValue();         //诊断依据
		var ResumeText=obj.txtResume.getValue();                   //备注
		
		var BaseReason=obj.cboBaseReason.getRawValue();           //根本死因
		var BaseReasonICD=obj.txtBaseReasonICD.getValue();        //根本死因ICD10
		var Damage=obj.cboDamage.getRawValue();                   //损伤中毒
		var DamageICD=obj.txtDamageICD.getValue();                //损伤中毒ICD10
		var ExamName=obj.txtExamName.getValue();                  //被调查者
		var ExamRelation=obj.cboExamRelation.getValue();          //被调查者与死者关系
		var ExamAddress=obj.txtExamAddress.getValue();            //被调查者地址
		var ExamTel=obj.txtExamTel.getValue();                    //被调查者电话
		var ExamDeathReason=obj.txtExamDeathReason.getValue();    //调查死因推断
		
		//死因推断为空，调查日期置为空
		if (ExamDeathReason==""){
		   var ExamDate=""                                        //调查日期
		}else{
		   var ExamDate=obj.txtExamDate.getRawValue();           //调查日期
		}
		var ExamUserDR=obj.txtExamUser.getValue();                //调查人
		var RepUsrDR=ReportUser;                                      //报告人
		var IsJohnDoe=(obj.chkJohnDoe.checked?1:0)                 //无名氏
		var IsNewBorn=(obj.chkNewBorn.checked?1:0)                 //新生儿
		var Household="";
		var inStr = ReportID;
		inStr = inStr + separate + PatientID;         //PatientID 2
		inStr = inStr + separate + Name;              //患者姓名 3
		inStr = inStr + separate + RepNo;             //报告编号 4
		inStr = inStr + separate + RepUsrDR;          //报告人 5
		inStr = inStr + separate + RepStatus;         //报告状态 6
		inStr = inStr + separate + PapmiNo;           //登记号 7
		inStr = inStr + separate + Age;               //年龄 8
		inStr = inStr + separate + Sex;               //性别 9
		inStr = inStr + separate + Identify;          //证件号码（身份证号）10
		inStr = inStr + separate + Birthday;          //出生日期 11
		inStr = inStr + separate + Country;           //国家或地区 12
		inStr = inStr + separate + Nation;            //民族 13
		inStr = inStr + separate + Marital;           //婚姻状况 14
		inStr = inStr + separate + Education;         //文化程度 15
		inStr = inStr + separate + Occupation;        //职业 16
		inStr = inStr + separate + '';                //工种 17
		inStr = inStr + separate + Company;           //工作单位 18
		inStr = inStr + separate + Pregnancies;       //孕产情况 19
		inStr = inStr + separate + RegAddress;        //户籍地址 20
		inStr = inStr + separate + CurrAddress;       //生前住址 21
		inStr = inStr + separate + FamName;           //家属姓名22
		inStr = inStr + separate + FamRelation;       //与死者关系 23
		inStr = inStr + separate + FamTel;            //家属电话 24
		inStr = inStr + separate + FamAddr;           //家属住址25
		inStr = inStr + separate + DeathNo;           //死亡编号 26
		inStr = inStr + separate + DeathDate;         //死亡日期 27
		inStr = inStr + separate + DeathTime;         //死亡时间 28
		inStr = inStr + separate + DeathPlace;        //死亡地点 29
		inStr = inStr + separate + BaseReason;        //根本死因 30 
		inStr = inStr + separate + BaseReasonICD;     //根本死因ICD 31
		inStr = inStr + separate + Damage;            //损失中毒 32
		inStr = inStr + separate + DamageICD;         //损失中毒ICD 33
		inStr = inStr + separate + AReason;           //A死因 34
		inStr = inStr + separate + AInterval;         //A时间间隔 35 
		inStr = inStr + separate + BReason;           //B死因 36
		inStr = inStr + separate + BInterval;         //B时间间隔 37
		inStr = inStr + separate + CReason;           //C死因 38
		inStr = inStr + separate + CInterval;         //C时间间隔 39
		inStr = inStr + separate + DReason;           //D死因 40
		inStr = inStr + separate + DInterval;         //D时间间隔 41
		inStr = inStr + separate + OtherDiagnose;     //其他诊断 42
		inStr = inStr + separate + DiagnoseUnit;      //诊断单位  43
		inStr = inStr + separate + DiagnoseBasis;     //诊断依据 44
		inStr = inStr + separate + ResumeText;        //备注 45
		inStr = inStr + separate + ExamMedical;       //死者生前病史及症状体征 46 
		inStr = inStr + separate + ExamName;          //被调查者 47
		inStr = inStr + separate + ExamRelation;      //被调查者与死者关系 48
		inStr = inStr + separate + ExamTel;           //被调查则联系电话 49
		inStr = inStr + separate + ExamDeathReason;   //调查死因推断 50
		inStr = inStr + separate + ExamAddress;       //被调查者住址 51
		inStr = inStr + separate + ExamUserDR;        //调查人 52
		inStr = inStr + separate + ExamDate;          //调查日期 53
		inStr = inStr + separate + ReportLoc;          //报告科室 54
		inStr = inStr + separate + Household;         //户籍性质 55
		inStr = inStr + separate + MrNo;              //病案号  56
		inStr = inStr + separate + DamageDiagnose;    //损伤中毒诊断 57
		inStr = inStr + separate + AReasonICD;        //A死因ICD10 58
		inStr = inStr + separate + BReasonICD;        //B死因ICD10 59
		inStr = inStr + separate + CReasonICD;        //C死因ICD10 60
		inStr = inStr + separate + DReasonICD;        //D死因ICD10 61
		inStr = inStr + separate + DamageDiagnoseICD; //损伤中毒诊断 62
		inStr = inStr + separate + ATime;             //A时间间隔单位ID 63
		inStr = inStr + separate + BTime;             //B时间间隔单位ID 64
		inStr = inStr + separate + CTime;             //C时间间隔单位ID 65
		inStr = inStr + separate + DTime;             //D时间间隔单位ID 66
		inStr = inStr + separate + CardType;          //证件类型 67
		inStr = inStr + separate + IsJohnDoe;         //是否无名氏 68
		inStr = inStr + separate + CurrProvince;      //生前住址省 69
		inStr = inStr + separate + CurrCity;          //生前住址市 70
		inStr = inStr + separate + CurrCounty;        //生前住址县 71
		inStr = inStr + separate + EpisodeID;         //就诊号 72
		inStr = inStr + separate + '';                //A死因编码 73
		inStr = inStr + separate + '';                //B死因编码 74
		inStr = inStr + separate + '';                //C死因编码 75
		inStr = inStr + separate + '';                //D死因编码 76
		inStr = inStr + separate + '';                //A死因编码ICD 77
		inStr = inStr + separate + '';                //B死因编码ICD 78
		inStr = inStr + separate + '';                //C死因编码ICD 79
		inStr = inStr + separate + '';                //D死因编码ICD 80
		inStr = inStr + separate + CurrVillage;       //生前住址乡 81
		inStr = inStr + separate + RegProvince;       //户籍地址省 82
		inStr = inStr + separate + RegCity;           //户籍地址市 83
		inStr = inStr + separate + RegCounty;         //户籍地址县 84
		inStr = inStr + separate + RegVillage;        //户籍地址乡 85
		inStr = inStr + separate + FamCardTypeId;     //家属证件类型 86
		inStr = inStr + separate + FamIdentify;       //家属证件号码 87
		inStr = inStr + separate + RegRoad;           //户籍地址村（小区） 88
		inStr = inStr + separate + CurrRoad;          //生前住址村（小区） 89
		inStr = inStr + separate + OtherDiagnoseICD;          //其他诊断ICD  90
		inStr = inStr + separate + '';                //其他诊断死因编码 91
		inStr = inStr + separate + '';                //其他诊断死因编码ICD 92
		inStr = inStr + separate + OtherDiagnoseInterval;          //其他诊断时间间隔 93
		inStr = inStr + separate + OtherDiagnoseTime;          //其他诊断时间单位 94
		inStr = inStr + separate + IsNewBorn;          //新生儿 95
		var retValue=obj.ClsDTHReport.Update(inStr,separate);
		if (retValue>0){
			ExtTool.alert("提示","报告"+(RepStatus==1?"上报":"保存")+"成功!");
			if (ReportID == "") {
				ReportID=retValue;
				obj.InitRepPowerByStatus();	  //add by pylian 20160130 暂存、上报后改变按钮状态
				//修改弹出多余界面
				//var lnk = "dhcmed.dth.report.csp?1=1&ReportID=" + ReportID + "&2=2";
				//window.location.href = lnk;
			} else {
				ReportID=retValue;
				obj.InitRepPowerByStatus();
				
				//update by zf 20151023
				if(window.opener){
					//window.opener.location.reload();
					if (window.opener.RefreshRowByReportID){
						window.opener.RefreshRowByReportID(ReportID);
					}
				}
			}
			ParrefWindowRefresh_Handler();
		}else if(retValue==-200){
			ExtTool.alert("错误提示","死亡证不允许重复填报!");
			return;
		}else{
			ExtTool.alert("错误提示","数据中存在不规范字符!");
			return;
		}
	}
	
	//打印核对信息按钮触发事件
	obj.btnPrintPatInfo_Click=function(){	
		try {
			ExportBaseDataToExcel("","","",ReportID);
		} catch(e) {
			ExtTool.alert("错误提示","打印核对信息出错!Error：" + e.message);
		}
	}
	
	//上报按钮单击事件
	obj.Report_Click=function(){
		//已审核的报告，不允许再修改
		if ((obj.RepStatusCode==2)||(obj.RepStatusCode==3))
		{
			ExtTool.alert("提示","已编码或已审核的报告,不允许再修改!");
			return;
		}
		//非无名氏或新生儿报告，数据完整性校验
		if ((obj.chkJohnDoe.checked==false)&&(obj.chkNewBorn.checked==false))
		{
			var ret=obj.CheckRepData();
			if(ret!=""){
				ExtTool.alert("提示",ret);
				return;	
			}
		}
		
		//保存死亡证
		obj.SaveData(1);
	}
}
//改变编码状态
function ChangeDMRepStatus(status,resumeText){
	var separate="^";
	var LogonUserID=session['LOGON.USERID'];
	var inStr=ReportID + separate + status + separate + LogonUserID + separate + resumeText;
	var retValue=objScreen.ClsDTHReportSrv.ChangeStatus(inStr,separate);
	return retValue;
}
//改变首联三联打印状态
function ChangeDMRepPrint(CtlocId,UserID,RepStatus,PrintNum,TPrintNum){
	var separate="^";
	var inStr=ReportID + separate + CtlocId + separate + UserID + separate + "Y" + separate + "" + separate + RepStatus + separate + PrintNum + separate + TPrintNum+separate;
	var retValue=objScreen.ClsDTHReportSrv.UpdatePrintStatus(inStr,separate);
	return retValue;
}
/*
function GetDMRepPrint(CtlocId,UserID){       
	var separate="^";
	var inStr=ReportID + separate + UserID;
	var retValue=objScreen.ClsDTHReportSrv.GetPrintStatus(inStr,separate);
	return retValue;
}
*/
//改变首联三联打印原因
function ChargePrintReason(CtlocId,UserID,RepStatus,PrintNum,TPrintNum,rejText){
	var separate="^";
	var inStr=ReportID + separate + CtlocId + separate + UserID + separate + "Y" + separate + "" + separate + RepStatus + separate + PrintNum + separate + TPrintNum + separate + rejText;
	var retVal=objScreen.ClsDTHReportSrv.ChargePrintReason(inStr,separate);
	return retVal;
}

function InitPopStorageEvent(obj){
	var parentForm = obj.ParentForm;
	UserID=session['LOGON.USERCODE'];
	CtlocId=session['LOGON.CTLOCID'];
	obj.TxtUser.setValue(UserID);
	obj.LoadEvent=function(){
		obj.btnSure.on("click", obj.btnSure_click, obj);
		obj.btnExit.on("click", obj.btnExit_click, obj);
	}
	obj.btnSure_click=function(){
		var PassWord=obj.TxtPassWord.getValue();
		if (PassWord==""){
			alert("请输入用户名密码");
			obj.TxtPassWord.focus();
			return;
		}
		var separate="^"
		var inStr=UserID + separate + PassWord;
		var retVal=objScreen.ClsDTHCommonSrv.VerifyUser(inStr,separate);
		if (retVal==-1){
			alert("用户名和密码不一致,请检查")
			ret="" ;
			obj.TxtPassWord.setValue("");
			return;
		}else{
			//alert("签名成功")
			obj.mainWindow.close();
			RepStatus=2;
			var inStr=ReportID + separate + RepStatus   
			var retPrintNumValue=objScreen.ClsDTHReportSrv.GetPrintNumStatus(inStr,separate);  //获取打印次数
			PrintNum=retPrintNumValue;
			TPrintNum="";
			GrantFlag="Y";
			var inStr=ReportID + separate + CtlocId + separate + UserID + separate + RepStatus + separate + PrintNum + separate + TPrintNum + separate + GrantFlag;
			var retValue=objScreen.ClsDTHReportSrv.UpdateGrantFlag(inStr,separate);
			if (retValue>0){
				alert("授权成功!")
			}
		}
		return;
	}
	obj.btnExit_click=function(){
		obj.mainWindow.close();
	}
}


function InitPopStorageTwoEvent(obj){
	var parentForm = obj.ParentForm;
	UserID=session['LOGON.USERCODE'];
	var CtlocId=session['LOGON.CTLOCID']
	obj.TxtUser.setValue(UserID);
	obj.LoadEvent=function(){
	   obj.btnSure.on("click", obj.btnSure_click, obj);
	   obj.btnExit.on("click", obj.btnExit_click, obj);
	}
	obj.btnSure_click=function(){
		var PassWord=obj.TxtPassWord.getValue();
		if (PassWord==""){
			alert("请输入用户名密码");
			obj.TxtPassWord.focus();
			return;
		}
		var separate="^"
		var inStr=UserID + separate + PassWord;
		var retVal=objScreen.ClsDTHCommonSrv.VerifyUser(inStr,separate);
		if (retVal==-1){
			alert("用户名和密码不一致,请检查")
			ret="" ;
			obj.TxtPassWord.setValue("");
			return;
		}else{
			//alert("签名成功")
			obj.mainWindow.close();
			RepStatus=1;
			var inStr=ReportID + separate + RepStatus   
			var retPrintNumValue=objScreen.ClsDTHReportSrv.GetTPrintNumStatus(inStr,separate);  //获取打印次数
			PrintNum="";
			TPrintNum=retPrintNumValue;
			GrantFlag="Y";

			var inStr=ReportID + separate + CtlocId + separate + UserID + separate + RepStatus + separate + PrintNum + separate + TPrintNum + separate + GrantFlag;
			var retValue=objScreen.ClsDTHReportSrv.UpdateGrantFlag(inStr,separate);
			if (retValue>0){
				alert("授权成功!")
			}
		}
		return;
	}
	obj.btnExit_click=function(){
		obj.mainWindow.close();
	}
}


function InitPrintReasonEvent(objPrintReason){
	var parentForm = objPrintReason.ParentForm;
	objPrintReason.LoadEvent = function(){
		
	};
	objPrintReason.saveBtn_click = function(){
		var separate="^";
		var CtlocId=session['LOGON.CTLOCID'];
		var UserID=session['LOGON.USERID'];
		RepStatus=2;
		var inStr=ReportID + separate + RepStatus   
		var retPrintNumValue=objScreen.ClsDTHReportSrv.GetPrintNumStatus(inStr,separate);  //获取打印次数
		TPrintNum="";
		PrintNum=retPrintNumValue;
		if (!(rejText = objPrintReason.resumeText.getValue())){
			ExtTool.alert("提示","重复打印原因不能为空");
			return;
		}
		var ret=ChargePrintReason(CtlocId,UserID,RepStatus,PrintNum,TPrintNum,rejText,rejText);
		if (ret<0){
			Ext.Msg.alert("提示","重复打印申请提交失败");	
		}
		objPrintReason.mainWindow.close();
		var patName=parentForm.txtPatName.getValue();
		Ext.Msg.alert("提示","死者 "+patName+" 的死亡证再次打印申请已提交!",function(){
			//parent.window.close();
			parentForm.BtnCancle_Click();
		});
	   //parentForm.btnExit_click();
	};
	objPrintReason.exitBtn_click = function(){
		objPrintReason.mainWindow.close();
	};
}


function InitTPrintReasonEvent(objTPrintReason){
	var parentForm = objTPrintReason.ParentForm;
	objTPrintReason.LoadEvent = function(){
		
	};
	objTPrintReason.saveBtn_click = function(){
		var separate="^";
		var CtlocId=session['LOGON.CTLOCID'];
		var UserID=session['LOGON.USERID'];
		RepStatus=1;
		var inStr=ReportID + separate + RepStatus   
		var retPrintNumValue=objScreen.ClsDTHReportSrv.GetTPrintNumStatus(inStr,separate);  //获取打印次数
		TPrintNum=retPrintNumValue;
		PrintNum="";
		if (!(rejText = objTPrintReason.resumeText.getValue())){
			ExtTool.alert("提示","重复打印原因不能为空");
			return;
		}
		var ret=ChargePrintReason(CtlocId,UserID,RepStatus,PrintNum,TPrintNum,rejText,rejText);
		if (ret<0){
			Ext.Msg.alert("提示","重复打印申请提交失败!");
		}
		objTPrintReason.mainWindow.close();
		var patName=parentForm.txtPatName.getValue();
		Ext.Msg.alert("提示","死者 "+patName+" 的死亡证再次打印申请已提交!",function(){
			//parent.window.close();
			parentForm.BtnCancle_Click();
		});
		//parentForm.btnExit_click();
	};
	objTPrintReason.exitBtn_click = function(){
		objTPrintReason.mainWindow.close();
	};
}
function InitBackReasonEvent(objBackReason){
	var parentForm = objBackReason.ParentForm;
	objBackReason.LoadEvent = function(){
		
	};
	objBackReason.saveBtn_click = function(){
		if (!(rejText = objBackReason.resumeText.getValue())){
			ExtTool.alert("提示","退回原因不能为空");
			return;
		}
		var status = 9;
		var retValue=ChangeDMRepStatus(status,rejText);
		objBackReason.mainWindow.close();
		if ((retValue>-1)){
			Ext.Msg.alert("提示","退回成功!");
			objBackReason.ParentForm.InitRepPowerByStatus();
			objBackReason.ParentForm.LoadEvent();
		}else{
			Ext.Msg.alert("提示","退回失败!");
		}
	};
	objBackReason.exitBtn_click = function(){
		objBackReason.mainWindow.close();
	};
}




//调用父窗体页面刷新
function ParrefWindowRefresh_Handler(){
	if (typeof window.opener != "undefined"){
		if (typeof window.opener.WindowRefresh_Handler != "undefined"){
			window.opener.WindowRefresh_Handler();
		}
	} else {
		if (window.parent) {
			if (typeof window.parent.WindowRefresh_Handler != "undefined"){
				window.parent.WindowRefresh_Handler();
			}
		}
	}
}