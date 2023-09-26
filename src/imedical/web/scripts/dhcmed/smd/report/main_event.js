function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args){
		obj.GetReportObj();  //获取报告内容
		obj.InitReport();  //初始化页面
	
		if(obj.ReportID != ""){
			switch(obj.CurrRepData.StatusDr.Code)
			{
				case "": 
			
				case "1": //上报
					obj.btnSubmit.enable();
					obj.btnRepTmp.disable();
					obj.btnCheck.enable();
					obj.btnCancelCheck.disable();
					obj.btnReturn.enable();
					obj.btnDelete.enable();
					obj.btnPrint.enable();
					obj.btnClose.enable();
					break;
				case "2": //审核
					obj.btnSubmit.disable();
					obj.btnRepTmp.disable();
					obj.btnCheck.disable();
					obj.btnCancelCheck.enable();
					obj.btnReturn.disable();
					obj.btnDelete.disable();
					obj.btnPrint.enable();
					obj.btnClose.enable();
					break;
				case "3": //退回
					obj.btnSubmit.enable();
					obj.btnRepTmp.enable();
					obj.btnCheck.disable();
					obj.btnCancelCheck.disable();
					obj.btnReturn.disable();
					obj.btnDelete.disable();
					obj.btnPrint.disable();
					obj.btnClose.enable();					
					break;					
				case "4": //删除
					obj.btnSubmit.disable();
					obj.btnRepTmp.disable();
					obj.btnCheck.disable();
					obj.btnCancelCheck.disable();
					obj.btnReturn.disable();
					obj.btnDelete.disable();
					obj.btnPrint.disable();
					obj.btnClose.enable();
					break;					
				case "0": //草稿
					obj.btnSubmit.enable();
					obj.btnRepTmp.enable();
					obj.btnCheck.disable();
					obj.btnCancelCheck.disable();
					obj.btnReturn.disable();
					obj.btnDelete.enable();
					obj.btnPrint.disable();
					obj.btnClose.enable();
					break;
				case "5":	//取消审核
					obj.btnSubmit.enable();
					obj.btnRepTmp.disable();
					obj.btnCheck.enable();
					obj.btnCancelCheck.disable();
					obj.btnReturn.enable();
					obj.btnDelete.enable();
					obj.btnPrint.enable();
					obj.btnClose.enable();
					break;
			}
		}
		// 省市县乡触发事件
		// 当下拉列表被展开时触发--户籍地址
		obj.cboRegProvince.on("expand", obj.cboRegProvince_expand, obj);
		//obj.cboRegCity.on("expand", obj.cboRegCity_expand, obj);
		//obj.cboRegCounty.on("expand", obj.cboRegCounty_expand, obj);
		//obj.cboRegVillage.on("expand", obj.cboRegVillage_expand, obj);
		
		// 当一个列表项目被选中时触发--现住址
		obj.cboRegProvince.on("select", obj.cboRegProvince_select, obj);
		obj.cboRegCity.on("select", obj.cboRegCity_select, obj);
		obj.cboRegCounty.on("select", obj.cboRegCounty_select, obj);
		obj.cboRegVillage.on("select", obj.cboRegVillage_select, obj);
		
		//当下拉列表被展开时触发--现住址
		obj.cboCurrProvince.on("expand", obj.cboCurrProvince_expand, obj);
		//obj.cboCurrCity.on("expand", obj.cboCurrCity_expand, obj);
		//obj.cboCurrCounty.on("expand", obj.cboCurrCounty_expand, obj);
		//obj.cboCurrVillage.on("expand", obj.cboCurrVillage_expand, obj);
		// 当一个列表项目被选中时触发--现住址
		obj.cboCurrProvince.on("select", obj.cboCurrProvince_select, obj);
		obj.cboCurrCity.on("select", obj.cboCurrCity_select, obj);
		obj.cboCurrCounty.on("select", obj.cboCurrCounty_select, obj);
		obj.cboCurrVillage.on("select", obj.cboCurrVillage_select, obj);
		
		Common_SetDisabled('txtCardNo',true);
		Common_SetDisabled('txtRepLoc',true);
		//Common_SetDisabled('txtDiagHospital',true);
		Common_SetDisabled('txtRepUser',true);
		//Common_SetDisabled('txtRepDate',true);	//填卡日期可编辑
		Common_SetDisabled('txtCheckUser',true);
		Common_SetDisabled('txtCheckDate',true);
		//初始化加载时，各个“其他”的备注信息均为不可编辑
		Common_SetDisabled('txtReferralTxt',true);		//送诊主体备注
		Common_SetDisabled('txtFundsSource',true);		//经济来源其他备注
		Common_SetDisabled('txtTreatMeasureTxt',true);	//本次住院康复措施其他备注
		Common_SetDisabled('txtRehabMeasureTxt',true);	//康复措施备注
		Common_SetDisabled('cbgFundsType',true);		//经费补助类型
		Common_SetDisabled('cbgFundsSource',true);		//经费来源
		Common_SetDisabled('txtAdmitDate',true);		//入院日期
		Common_SetDisabled('txtDischDate',true);		//出院日期
		//初始化"其他"change事件
		var objCmp = Ext.getCmp("cbgReferral");
		if (objCmp) {
			objCmp.on('change',function(cbg,val){
				var isActive = false;
				if (val.length > 0) {
					for (var indChk = 0; indChk < val.length; indChk++)	{
						var chk = val[indChk];
						var objDic = ExtTool.RunServerMethod("DHCMed.SS.Dictionary","GetObjById",chk.inputValue);
						if (!objDic) continue;
						if (objDic.Description.indexOf('其他') > -1) {
							isActive = true;
						}
					}
				}
				Common_SetDisabled('txtReferralTxt',(!isActive));
				if (!isActive) Common_SetValue('txtReferralTxt','');
			});
		}
		//初始化"其他"change事件,经费补助
		var objCmp = Ext.getCmp("cbgIsFunding");
		if (objCmp) {
			objCmp.on('change',function(cbg,val){
				var isActive = false;
				if (val.length > 0) {
					for (var indChk = 0; indChk < val.length; indChk++)	{
						var chk = val[indChk];
						var objDic = ExtTool.RunServerMethod("DHCMed.SS.Dictionary","GetObjById",chk.inputValue);
						if (!objDic) continue;
						if (objDic.Code == "1") {
							isActive = true;
						}
					}
				}
				Common_SetDisabled('cbgFundsType',(!isActive));
				Common_SetDisabled('cbgFundsSource',(!isActive));
				//是否获得经费补助为“无”时，清空经费补助来源
				if (!isActive) Common_SetValue('cbgFundsType','');
				if (!isActive) Common_SetValue('cbgFundsSource','');
				//Common_SetDisabled('txtFundsSource',(!isActive));
			});
		}
		//初始化"其他"change事件,经费来源其他
		var objCmp = Ext.getCmp("cbgFundsSource");
		if (objCmp) {
			objCmp.on('change',function(cbg,val){
				var isActive = false;
				if (val.length > 0) {
					for (var indChk = 0; indChk < val.length; indChk++)	{
						var chk = val[indChk];
						var objDic = ExtTool.RunServerMethod("DHCMed.SS.Dictionary","GetObjById",chk.inputValue);
						if (!objDic) continue;
						if (objDic.Description.indexOf('其他') > -1) {
							isActive = true;
						}
					}
				}
				Common_SetDisabled('txtFundsSource',(!isActive));
				if (!isActive) Common_SetValue('txtFundsSource','');
			});
		}
		//初始化"其他"change事件,康复措施
		var objCmp = Ext.getCmp("cbgTreatMeasure");
		if (objCmp) {
			objCmp.on('change',function(cbg,val){
				var isActive = false;
				if (val.length > 0) {
					for (var indChk = 0; indChk < val.length; indChk++)	{
						var chk = val[indChk];
						var objDic = ExtTool.RunServerMethod("DHCMed.SS.Dictionary","GetObjById",chk.inputValue);
						if (!objDic) continue;
						if (objDic.Description.indexOf('其他') > -1) {
							isActive = true;
						}
					}
				}
				Common_SetDisabled('txtTreatMeasureTxt',(!isActive));
				if (!isActive) Common_SetValue('txtTreatMeasureTxt','');
			});
		}
		//初始化"其他"change事件,康复措施
		var objCmp = Ext.getCmp("cbgRehabMeasure");
		if (objCmp) {
			objCmp.on('change',function(cbg,val){
				var isActive = false;
				if (val.length > 0) {
					for (var indChk = 0; indChk < val.length; indChk++)	{
						var chk = val[indChk];
						var objDic = ExtTool.RunServerMethod("DHCMed.SS.Dictionary","GetObjById",chk.inputValue);
						if (!objDic) continue;
						if (objDic.Description.indexOf('其他') > -1) {
							isActive = true;
						}
					}
				}
				Common_SetDisabled('txtRehabMeasureTxt',(!isActive));
				if (!isActive) Common_SetValue('txtRehabMeasureTxt','');
			});
		}
		obj.btnRepTmp.on("click",obj.btnRepTmp_click,obj);
		obj.btnSubmit.on("click",obj.btnSubmit_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.btnCheck.on("click",obj.btnCheck_click,obj);
		obj.btnCancelCheck.on("click",obj.btnCancelCheck_click,obj);
		obj.btnReturn.on("click",obj.btnReturn_click,obj);
		obj.btnPrint.on("click",obj.btnPrint_click,obj);
		obj.btnClose.on("click",obj.btnClose_click,obj);
		
		if(!tDHCMedMenuOper['Report'])
		{
			obj.btnSubmit.hide();
			obj.btnRepTmp.hide();	
			obj.btnPrint.hide();	
			obj.btnDelete.hide();
		}
		if(!tDHCMedMenuOper['Check'])
		{
			obj.btnCheck.disable();
			obj.btnCancelCheck.disable();
			obj.btnReturn.disable();
			obj.btnPrint.disable();	
			//Common_SetValue('txtRepUser',UserName);
		}
		//update by pylian 20150616 109476 发病报告卡-报告中【填卡医师】默认信息显示空，而不是当前医师 
		if(obj.ReportID == ""){
			if(tDHCMedMenuOper['Report'])
			{
				Common_SetValue('txtRepUser',UserName);
				
			}
			
			if(tDHCMedMenuOper['Check'])
			{
				Common_SetValue('txtCheckUser',UserName);
			}else{
				Common_SetValue('txtCheckDate','');
			}
			
			Common_SetValue('txtRepLoc',CTLocDesc);
			Common_SetValue('txtDiagHospital',HospDesc);
		}
	}
	
	
	obj.InitReport = function(){
		//初始化病人基本信息
		var objEpisode = ExtTool.RunServerMethod("DHCMed.Base.PatientAdm","GetObjById",obj.EpisodeID);
		obj.DisplayPatient(obj.CurrRepData.PatientObj);
		Common_SetValue("txtContactor",obj.CurrRepData.Contactor);
		Common_SetValue("txtContactorTel",obj.CurrRepData.ContactorTel);
		if (obj.CurrRepData.Company != ''){
			Common_SetValue('txtCompany',obj.CurrRepData.Company);
			Common_SetValue('txtCompanyTel',obj.CurrRepData.CompanyTel);
		}
		Common_SetValue("txtSickDate","");	//发病日期初始为空
		if (obj.CurrRepData.AdmTypeDr != ''){
			//Common_SetValue('cbgAdmType',obj.CurrRepData.AdmTypeDr.ID);
			obj.cbgAdmType.getStore().load({
				callback : function(){
					obj.cbgAdmType.setValue(obj.CurrRepData.AdmTypeDr.ID);
				} 
			});
		}
		if (obj.CurrRepData.AdmTypeDr.Code==2){
			Common_SetValue('txtRepLocTel',"01062715511");		//住院电话
		} else if (obj.CurrRepData.AdmTypeDr.Code==1){
			Common_SetValue('txtRepLocTel',"01062715511");	//门诊电话
		}
		if (obj.CurrRepData.PatTypeDr != ''){
			//Common_SetValue('cbgPatType',obj.CurrRepData.PatTypeDr.ID);
			obj.cbgPatType.getStore().load({
				callback : function(){
					obj.cbgPatType.setValue(obj.CurrRepData.PatTypeDr.ID);
				} 
			});
		}
		//下诊断弹出报卡时，疾病名称自动置为诊断名称
		if (obj.DiseaseID !='') {
			var objDisease = ExtTool.RunServerMethod("DHCMed.SS.Disease","GetObjById",obj.DiseaseID);
			Common_SetValue("cboDisease",objDisease.RowID,objDisease.IDDesc);
			obj.txtDiseaseICD.setValue(objDisease.IDICD10);
		}
		//注释掉此段代码，修改打开报卡页面后，疾病名称不显示问题
		/*//初始化疾病
		obj.cboDiseaseStore.load({
			callback : function(){
				obj.cboDisease.setValue(obj.DiseaseID);
				var objDisease = ExtTool.RunServerMethod("DHCMed.SS.Disease","GetObjById",obj.DiseaseID);
				obj.txtDiseaseICD.setValue(objDisease.IDICD10);
			} 
		});*/
		Common_SetValue("txtAdmitDate",objEpisode.AdmitDate);
		if ((obj.RepTypeCode=="2")||(obj.RepTypeCode=="4")){
			if (obj.CurrRepData.PatientObj.NationDr.ID != ''){
				obj.txtNation.getStore().load({
					callback : function(){
						obj.txtNation.setValue(obj.CurrRepData.PatientObj.NationDr.ID);
					}
			  });
			}
			//Common_SetValue("txtAdmitDate",objEpisode.AdmitDate);
			Common_SetValue("txtDischDate",objEpisode.DisDate);		
		}
		//初始化出院信息单
		if (obj.ReportID != ""){
			//显示报告信息
			if (obj.CurrRepData.WholenessDr != ''){
				//Common_SetValue('cbgIsComplete',obj.CurrRepData.WholenessDr.ID);
				obj.cbgIsComplete.getStore().load({
					callback : function(){
						obj.cbgIsComplete.setValue(obj.CurrRepData.WholenessDr.ID);
					} 
				});
			}
			if (obj.CurrRepData.OccupationDr != ''){
				obj.cboOccupation.getStore().load({
					callback : function(){
						obj.cboOccupation.setValue(obj.CurrRepData.OccupationDr.ID);
					} 
				});
			}
			
			if (obj.CurrRepData.AdmitReasonDr != ''){
				//Common_SetValue('cbgAdmitReason',obj.CurrRepData.AdmitReasonDr.ID);
				obj.cbgAdmitReason.getStore().load({
					callback : function(){
						obj.cbgAdmitReason.setValue(obj.CurrRepData.AdmitReasonDr.ID);
					} 
				});
			}
			//Common_SetValue("txtContactor",obj.CurrRepData.Contactor);
			//Common_SetValue("txtContactorTel",obj.CurrRepData.ContactorTel);
			Common_SetValue("txtCardNo",obj.CurrRepData.CardNo);
			//付费方式
			obj.cboPayment.getStore().load({
				callback : function(){
					obj.cboPayment.setValue(obj.CurrRepData.PaymentDr.ID);
				}
			});
			Common_SetValue("txtInsurNo",obj.CurrRepData.PatientObj.InsurNo)
			obj.cboDiseaseStore.load({
				callback : function(){
					obj.cboDisease.setValue(obj.CurrRepData.DiseaseDr.ID);
					Common_SetValue("txtDiseaseICD",obj.CurrRepData.DiseaseDr.ICD);
				} 
			});
			Common_SetValue("txtSickDate",obj.CurrRepData.SickDate);
			if ((obj.RepTypeCode=="2")||(obj.RepTypeCode=="4")){
				Common_SetValue("cbgOPTreatment",obj.CurrRepData.OPTreatmentDr.ID);
				Common_SetValue("txtFDTreatDate",obj.CurrRepData.FirstDrugTreatDate);
				Common_SetValue("txtTreatTimes",obj.CurrRepData.IPTreatTimes);
				obj.cboPrognosis.getStore().load({
					callback : function(){
						obj.cboPrognosis.setValue(obj.CurrRepData.PrognosisDr.ID);
					}
				});			
				Common_SetValue("cbgIsFunding",obj.CurrRepData.IsFunding.ID);
			}
			Common_SetValue("txtDiagHospital",obj.CurrRepData.DiagHospital);
			Common_SetValue("txtDiagDate",obj.CurrRepData.DiagDate);   
			Common_SetValue("txtRepLoc",obj.CurrRepData.ReportLoc);
			Common_SetValue("txtRepLocTel",obj.CurrRepData.RepLocTel);
			Common_SetValue("txtRepUser",obj.CurrRepData.ReportUser);
			Common_SetValue("txtRepDate",obj.CurrRepData.ReportDate);
			Common_SetValue("txtCheckUser",obj.CurrRepData.CheckUser);
			Common_SetValue("txtCheckDate",obj.CurrRepData.CheckDate);
			Common_SetValue("txtResume",obj.CurrRepData.ReportNote);
			if (obj.CurrRepData.FundsType!=""){
				Common_SetValue("cbgFundsType",obj.CurrRepData.FundsType.ID);
				Common_SetValue("cbgFundsSource",obj.CurrRepData.FundsSourceDr.ID);
				Common_SetValue("txtFundsSource",obj.CurrRepData.FundsSource); //修复经费补助其他不显示
			}
			if (obj.CurrRepData.DischDiagnos!=""){
				Common_SetValue("cboDiagnose",obj.CurrRepData.DischDiagnos.ID);
				Common_SetValue("txtDiseaseICD",obj.CurrRepData.DischDiagnos.ICD);
			}
			if (obj.CurrRepData.LocalDr!=""){
				//Common_SetValue("cbgLocal",obj.CurrRepData.LocalDr.ID);
				obj.cbgLocal.getStore().load({
					callback : function(){
						obj.cbgLocal.setValue(obj.CurrRepData.LocalDr.ID);
					} 
				});
			}
			if (obj.CurrRepData.RegAddrTypeDr!=""){
				obj.cboRegAddType.getStore().load({
					callback : function(){
						obj.cboRegAddType.setValue(obj.CurrRepData.RegAddrTypeDr.ID);
					} 
				});
			}
			obj.cboRegProvince.getStore().load({
				callback : function(){
					obj.cboRegProvince.setValue(obj.CurrRepData.RegProvince);
					obj.cboRegCity.getStore().load({
						callback : function(){
							obj.cboRegCity.setValue(obj.CurrRepData.RegCity);
							obj.cboRegCounty.getStore().load({
								callback : function(){
									obj.cboRegCounty.setValue(obj.CurrRepData.RegCounty);
									obj.cboRegVillage.getStore().load({
										callback : function(){
											obj.cboRegVillage.setValue(obj.CurrRepData.RegVillage);
										}
									});							
								}
							});
						}
					});
				}
			});
			Common_SetValue("txtRegRoad",obj.CurrRepData.RegRoad);
			if (obj.CurrRepData.CurrAddrTypeDr!=""){
				obj.cboCurrAddType.getStore().load({
					callback : function(){
						obj.cboCurrAddType.setValue(obj.CurrRepData.CurrAddrTypeDr.ID);
					} 
				});
			}
			obj.cboCurrProvince.getStore().load({
				callback : function(){
					obj.cboCurrProvince.setValue(obj.CurrRepData.CurrProvince);
					obj.cboCurrCity.getStore().load({
						callback : function(){
							obj.cboCurrCity.setValue(obj.CurrRepData.CurrCity);
							obj.cboCurrCounty.getStore().load({
								callback : function(){
									obj.cboCurrCounty.setValue(obj.CurrRepData.CurrCounty);
										obj.cboCurrVillage.getStore().load({
										callback : function(){
											obj.cboCurrVillage.setValue(obj.CurrRepData.CurrVillage);
										}
									});							
								}
							});
						}
					});
				}
			});
			Common_SetValue("txtCurrRoad",obj.CurrRepData.CurrRoad);
			//家庭社会影响
			if (obj.CurrRepData.SocietyImpact!=""){
				var arrayStr = obj.CurrRepData.SocietyImpact.split(",");
				Common_SetValue("txtCause",arrayStr[0]);
				Common_SetValue("txtCause1",arrayStr[1]);
				Common_SetValue("txtCause2",arrayStr[2]);
				Common_SetValue("txtCause3",arrayStr[3]);
				Common_SetValue("txtCause4",arrayStr[4]);
				Common_SetValue("txtCause5",arrayStr[5]);
				Common_SetValue("txtCauseNote",obj.CurrRepData.SocietyImpactTxt);
			}
			
			//送检主体
			var strValue = '';
			var arrDic = obj.CurrRepData.ReferralDr.split("#");
			if (arrDic!=""){
				for (var i =0; i < arrDic.length; i ++) {
					var strDic = arrDic[i];
					if (strDic == "") continue;
					if (strValue != '') strValue += ',';
					strValue += strDic.split("^")[0];
				}
			}
			Common_SetValue("cbgReferral",strValue);
			Common_SetValue("txtReferralTxt",obj.CurrRepData.ReferralTxt);
			
			//精神症状
			var strValue = '';
			var arrDic = obj.CurrRepData.SymptomDr.split("#");
			if (arrDic!=""){
				for (var i =0; i < arrDic.length; i ++) {
					var strDic = arrDic[i];
					if (strDic == "") continue;
					if (strValue != '') strValue += ',';
					strValue += strDic.split("^")[0];
				}
			}
			for (var j = 0; j < obj.cbgSymptoms.length; j++) {
				Common_SetValue("cbgSymptoms" + j,strValue);
			}
			
			//住院康复措施
			var strValue = '';
			var arrDic = obj.CurrRepData.TreatMeasureDr.split("#");
			if (arrDic!=""){
				for (var i =0; i < arrDic.length; i ++) {
					var strDic = arrDic[i];
					if (strDic == "") continue;
					if (strValue != '') strValue += ',';
					strValue += strDic.split("^")[0];
				}
			}
			Common_SetValue("cbgTreatMeasure",strValue);
			Common_SetValue("txtTreatMeasureTxt",obj.CurrRepData.TreatMeasureTxt);
			
			//康复措施
			var strValue = '';
			var arrDic = obj.CurrRepData.RehabMeasureDr.split("#");
			if (arrDic!=""){
				for (var i =0; i < arrDic.length; i ++) {
					var strDic = arrDic[i];
					if (strDic == "") continue;
					if (strValue != '') strValue += ',';
					strValue += strDic.split("^")[0];
				}
			}
			Common_SetValue("cbgRehabMeasure",strValue);
			Common_SetValue("txtRehabMeasureTxt",obj.CurrRepData.RehabMeasureTxt);
			Common_SetValue("txtRehabResume",obj.CurrRepData.RehabResume);
			
			//住院用药
			var arrayTreatPharmacy = obj.CurrRepData.TreatPharmacy.split("#");
			if (arrayTreatPharmacy!=""){
				for (var i = 0;i < arrayTreatPharmacy.length; i++) {
					var strDrug = arrayTreatPharmacy[i];
					if(strDrug == "") continue;
					var arrDrugInfo = strDrug.split("^");
					var index = parseInt(i)+1;
					Common_SetValue("cboTreatDrug"+index,arrDrugInfo[5],arrDrugInfo[1]);
					Common_SetValue("cboTreatInst"+index,arrDrugInfo[6],arrDrugInfo[2]);
					Common_SetValue("txtTreatDoseQty"+index,arrDrugInfo[3]);
					Common_SetValue("cboTreatDoseUnit"+index,arrDrugInfo[7],arrDrugInfo[4]);
				}
			}
			
			//康复用药
			var arrayRehabPharmacy = obj.CurrRepData.RehabPharmacy.split("#");
			if (arrayRehabPharmacy!=""){
				for (var i = 0;i < arrayRehabPharmacy.length; i++) {
					var strDrug = arrayRehabPharmacy[i];
					if(strDrug == "") continue;
					var arrDrugInfo = strDrug.split("^");
					var index = parseInt(i)+1;
					Common_SetValue("cboRehabDrug"+index,arrDrugInfo[5],arrDrugInfo[1]);
					Common_SetValue("cboRehabInst"+index,arrDrugInfo[6],arrDrugInfo[2]);
					Common_SetValue("txtRehabDoseQty"+index,arrDrugInfo[3]);
					Common_SetValue("cboRehabDoseUnit"+index,arrDrugInfo[7],arrDrugInfo[4]);
				}
			}
		}else if (((obj.RepTypeCode=="2")||(obj.RepTypeCode=="4"))){
			obj.DisplayDisRepInfo();
		}else{
			if (obj.CurrRepData.PatientObj.AdmType == "O"){
				obj.DisplayOldInfo();
			}
		}
	}
	obj.GetReportObj = function(){
		var strReport = ExtTool.RunServerMethod("DHCMed.SMDService.ReportSrv","GetReportString",obj.ReportID,obj.RepTypeCode,obj.EpisodeID);
		var arrFieldData = strReport.split(CHR_1);
		obj.CurrRepData.ReportID           = arrFieldData[0];
		obj.CurrRepData.EpisodeID          = arrFieldData[1];
		obj.CurrRepData.PatientID          = arrFieldData[2];
		obj.CurrRepData.RepTypeDr          = "";
		var arrFieldItem = arrFieldData[3].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.RepTypeDr      = new Object();
			obj.CurrRepData.RepTypeDr.ID   = arrFieldItem[0];
			obj.CurrRepData.RepTypeDr.Code = arrFieldItem[1];
			obj.CurrRepData.RepTypeDr.Desc = arrFieldItem[2];
		}
		obj.CurrRepData.AdmTypeDr          = "";
		var arrFieldItem = arrFieldData[4].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.AdmTypeDr      = new Object();
			obj.CurrRepData.AdmTypeDr.ID   = arrFieldItem[0];
			obj.CurrRepData.AdmTypeDr.Code = arrFieldItem[1];
			obj.CurrRepData.AdmTypeDr.Desc = arrFieldItem[2];
		}
		obj.CurrRepData.PatTypeDr		   = "";
		var arrFieldItem = arrFieldData[5].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.PatTypeDr      = new Object();
			obj.CurrRepData.PatTypeDr.ID   = arrFieldItem[0];
			obj.CurrRepData.PatTypeDr.Code = arrFieldItem[1];
			obj.CurrRepData.PatTypeDr.Desc = arrFieldItem[2];
		}
		//***
		obj.CurrRepData.LocalDr            = "";
		var arrFieldItem = arrFieldData[6].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.LocalDr        = new Object();
			obj.CurrRepData.LocalDr.ID     = arrFieldItem[0];
			obj.CurrRepData.LocalDr.Code   = arrFieldItem[1];
			obj.CurrRepData.LocalDr.Desc   = arrFieldItem[2];
		}
		obj.CurrRepData.DiseaseDr          = "";
		var arrFieldItem = arrFieldData[7].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.DiseaseDr      = new Object();
			obj.CurrRepData.DiseaseDr.ID   = arrFieldItem[0];
			obj.CurrRepData.DiseaseDr.Desc = arrFieldItem[1];
			obj.CurrRepData.DiseaseDr.ICD  = arrFieldItem[2];
		}
		obj.CurrRepData.DiseaseText        = arrFieldData[8];
		obj.CurrRepData.StatusDr           = "";
		var arrFieldItem = arrFieldData[9].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.StatusDr       = new Object();
			obj.CurrRepData.StatusDr.ID    = arrFieldItem[0];
			obj.CurrRepData.StatusDr.Code  = arrFieldItem[1];
			obj.CurrRepData.StatusDr.Desc  = arrFieldItem[2];
		}
		obj.CurrRepData.CardNo             = arrFieldData[10];
		obj.CurrRepData.WholenessDr        = "";
		arrFieldItem = arrFieldData[11].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.WholenessDr          = new Object();
			obj.CurrRepData.WholenessDr.ID       = arrFieldItem[0];
			obj.CurrRepData.WholenessDr.Code     = arrFieldItem[1];
			obj.CurrRepData.WholenessDr.Desc     = arrFieldItem[2];
		}
		var arrFieldItem = arrFieldData[12].split(CHR_2);
		if (arrFieldItem.length > 9){
			obj.CurrRepData.PatientObj     		 = new Object();
			obj.CurrRepData.PatientObj.PatName   = arrFieldItem[0];
			obj.CurrRepData.PatientObj.Sex 	 	 = arrFieldItem[1];
			obj.CurrRepData.PatientObj.Birthday  = arrFieldItem[2];
			obj.CurrRepData.PatientObj.PersonalID= arrFieldItem[3];
			obj.CurrRepData.PatientObj.Telephone = arrFieldItem[4];
			//obj.CurrRepData.PatientObj.Nation    = arrFieldItem[5];	//民族
			var arrNation = arrFieldItem[5].split(CHR_3);
			if (arrNation.length > 0){
				obj.CurrRepData.PatientObj.NationDr = new Object();
				obj.CurrRepData.PatientObj.NationDr.ID   = arrNation[0];
				obj.CurrRepData.PatientObj.NationDr.Code = arrNation[1];
				obj.CurrRepData.PatientObj.NationDr.Desc = arrNation[2];
			}
			obj.CurrRepData.PatientObj.OPMrNo 	 = arrFieldItem[6];
			obj.CurrRepData.PatientObj.IPMrNo    = arrFieldItem[7];
			obj.CurrRepData.PatientObj.InsurNo	 = arrFieldItem[8];
			obj.CurrRepData.PatientObj.AdmType	 = arrFieldItem[9];
		}
		obj.CurrRepData.Contactor          = arrFieldData[13];
		obj.CurrRepData.ContactorTel       = arrFieldData[14];
		obj.CurrRepData.HomeTel            = arrFieldData[15];
		obj.CurrRepData.RegAddrTypeDr      = "";
		arrFieldItem = arrFieldData[16].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.RegAddrTypeDr        = new Object();
			obj.CurrRepData.RegAddrTypeDr.ID     = arrFieldItem[0];
			obj.CurrRepData.RegAddrTypeDr.Code   = arrFieldItem[1];
			obj.CurrRepData.RegAddrTypeDr.Desc   = arrFieldItem[2];
		}
		obj.CurrRepData.RegAddress         = arrFieldData[17];
		obj.CurrRepData.RegProvince        = arrFieldData[18];
		obj.CurrRepData.RegCity            = arrFieldData[19];
		obj.CurrRepData.RegCounty          = arrFieldData[20];
		obj.CurrRepData.RegVillage         = arrFieldData[21];
		obj.CurrRepData.RegRoad            = arrFieldData[22];
		obj.CurrRepData.CurrAddrTypeDr     = "";
		arrFieldItem = arrFieldData[23].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.CurrAddrTypeDr       = new Object();
			obj.CurrRepData.CurrAddrTypeDr.ID    = arrFieldItem[0];
			obj.CurrRepData.CurrAddrTypeDr.Code  = arrFieldItem[1];
			obj.CurrRepData.CurrAddrTypeDr.Desc  = arrFieldItem[2];
		}
		obj.CurrRepData.CurrAddress        = arrFieldData[24];
		obj.CurrRepData.CurrProvince       = arrFieldData[25];
		obj.CurrRepData.CurrCity           = arrFieldData[26];
		obj.CurrRepData.CurrCounty         = arrFieldData[27];
		obj.CurrRepData.CurrVillage        = arrFieldData[28];
		obj.CurrRepData.CurrRoad           = arrFieldData[29];
		obj.CurrRepData.OccupationDr       = "";
		arrFieldItem = arrFieldData[30].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.OccupationDr         = new Object();
			obj.CurrRepData.OccupationDr.ID      = arrFieldItem[0];
			obj.CurrRepData.OccupationDr.Code    = arrFieldItem[1];
			obj.CurrRepData.OccupationDr.Desc    = arrFieldItem[2];
		}
		obj.CurrRepData.Company            = arrFieldData[31];
		obj.CurrRepData.CompanyTel         = arrFieldData[32];
		obj.CurrRepData.SickDate           = arrFieldData[33];
		obj.CurrRepData.ReferralDr         = arrFieldData[34];
		obj.CurrRepData.ReferralTxt        = arrFieldData[35];
		obj.CurrRepData.DiagHospital       = arrFieldData[36];
		obj.CurrRepData.DiagDate           = arrFieldData[37];
		obj.CurrRepData.AdmitReasonDr      = "";
		arrFieldItem = arrFieldData[38].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.AdmitReasonDr        = new Object();
			obj.CurrRepData.AdmitReasonDr.ID     = arrFieldItem[0];
			obj.CurrRepData.AdmitReasonDr.Code   = arrFieldItem[1];
			obj.CurrRepData.AdmitReasonDr.Desc   = arrFieldItem[2];
		}
		obj.CurrRepData.SymptomDr          = arrFieldData[39];
		obj.CurrRepData.SocietyImpact      = arrFieldData[40];
		obj.CurrRepData.SocietyImpactTxt   = arrFieldData[41];
		obj.CurrRepData.OPTreatmentDr      = "";
		arrFieldItem = arrFieldData[42].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.OPTreatmentDr       = new Object();
			obj.CurrRepData.OPTreatmentDr.ID    = arrFieldItem[0];
			obj.CurrRepData.OPTreatmentDr.Code  = arrFieldItem[1];
			obj.CurrRepData.OPTreatmentDr.Desc  = arrFieldItem[2];
		}
		obj.CurrRepData.IPTreatTimes       = arrFieldData[43];
		obj.CurrRepData.FirstDrugTreatDate = arrFieldData[44];
		obj.CurrRepData.DischDiagnos       = "";
		arrFieldItem = arrFieldData[45].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.DischDiagnos     	= new Object();
			obj.CurrRepData.DischDiagnos.ID   	= arrFieldItem[0];
			obj.CurrRepData.DischDiagnos.Desc 	= arrFieldItem[1];
			obj.CurrRepData.DischDiagnos.ICD  	= arrFieldItem[2];
		}
		obj.CurrRepData.PrognosisDr        = "";
		arrFieldItem = arrFieldData[46].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.PrognosisDr       	= new Object();
			obj.CurrRepData.PrognosisDr.ID    	= arrFieldItem[0];
			obj.CurrRepData.PrognosisDr.Code  	= arrFieldItem[1];
			obj.CurrRepData.PrognosisDr.Desc  	= arrFieldItem[2];
		}
		obj.CurrRepData.IsFunding          = ""; 
		arrFieldItem = arrFieldData[47].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.IsFunding       	= new Object();
			obj.CurrRepData.IsFunding.ID    	= arrFieldItem[0];
			obj.CurrRepData.IsFunding.Code  	= arrFieldItem[1];
			obj.CurrRepData.IsFunding.Desc 	 	= arrFieldItem[2];
		}
		obj.CurrRepData.FundsType          = "";
		arrFieldItem = arrFieldData[48].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.FundsType       	= new Object();
			obj.CurrRepData.FundsType.ID    	= arrFieldItem[0];
			obj.CurrRepData.FundsType.Code  	= arrFieldItem[1];
			obj.CurrRepData.FundsType.Desc 	 	= arrFieldItem[2];
		}
		obj.CurrRepData.FundsSourceDr      = "";
		arrFieldItem = arrFieldData[49].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.FundsSourceDr       = new Object();
			obj.CurrRepData.FundsSourceDr.ID    = arrFieldItem[0];
			obj.CurrRepData.FundsSourceDr.Code  = arrFieldItem[1];
			obj.CurrRepData.FundsSourceDr.Desc  = arrFieldItem[2];
		}
		obj.CurrRepData.FundsSource     = arrFieldData[50];  //修复经费来源其他不显示
		obj.CurrRepData.TreatPharmacy      = arrFieldData[51];
		obj.CurrRepData.TreatMeasureDr     = arrFieldData[52];
		obj.CurrRepData.TreatMeasureTxt    = arrFieldData[53];
		obj.CurrRepData.RehabPharmacy      = arrFieldData[54];
		obj.CurrRepData.RehabMeasureDr     = arrFieldData[55];
		obj.CurrRepData.RehabMeasureTxt    = arrFieldData[56];
		obj.CurrRepData.RehabResume        = arrFieldData[57];
		obj.CurrRepData.ReportNote         = arrFieldData[58];
		obj.CurrRepData.ReportLoc          = arrFieldData[59];
		obj.CurrRepData.RepLocTel          = arrFieldData[60];
		obj.CurrRepData.ReportUser         = arrFieldData[61];
		obj.CurrRepData.ReportDate         = arrFieldData[62];
		obj.CurrRepData.ReportTime         = arrFieldData[63];
		obj.CurrRepData.CheckUser          = arrFieldData[64];
		obj.CurrRepData.CheckDate          = arrFieldData[65];
		obj.CurrRepData.CheckTime          = arrFieldData[66];
		obj.CurrRepData.PaymentDr      = "";
		arrFieldItem = arrFieldData[67].split(CHR_2);
		if (arrFieldItem.length > 2){
			obj.CurrRepData.PaymentDr       = new Object();
			obj.CurrRepData.PaymentDr.ID    = arrFieldItem[0];
			obj.CurrRepData.PaymentDr.Code  = arrFieldItem[1];
			obj.CurrRepData.PaymentDr.Desc  = arrFieldItem[2];
		}
	}
	//显示历史的报告信息
	obj.DisplayOldInfo = function(){
		if (obj.CurrRepData.OccupationDr != ''){
			obj.cboOccupation.getStore().load({
				callback : function(){
					obj.cboOccupation.setValue(obj.CurrRepData.OccupationDr.ID);
				} 
			});
		}if (obj.CurrRepData.PatTypeDr != ''){	//患者类型
			//Common_SetValue('cbgPatType',obj.CurrRepData.PatTypeDr.ID);
			obj.cbgPatType.getStore().load({
					callback : function(){
						obj.cbgPatType.setValue(obj.CurrRepData.PatTypeDr.ID);
					} 
				});
		}
		if (obj.CurrRepData.WholenessDr != ''){	//完整性
			//Common_SetValue('cbgIsComplete',obj.CurrRepData.WholenessDr.ID);
			obj.cbgIsComplete.getStore().load({
				callback : function(){
					obj.cbgIsComplete.setValue(obj.CurrRepData.WholenessDr.ID);
				} 
			});
		}
		if (obj.CurrRepData.LocalDr!=""){
			//Common_SetValue("cbgLocal",obj.CurrRepData.LocalDr.ID);
			obj.cbgLocal.getStore().load({
				callback : function(){
					obj.cbgLocal.setValue(obj.CurrRepData.LocalDr.ID);
				} 
			});
		}
		if (obj.CurrRepData.Company != ''){
			Common_SetValue('txtCompany',obj.CurrRepData.Company);
			Common_SetValue('txtCompanyTel',obj.CurrRepData.CompanyTel);
		}
		Common_SetValue("txtContactor",obj.CurrRepData.Contactor);
		Common_SetValue("txtContactorTel",obj.CurrRepData.ContactorTel);
		Common_SetValue("txtDiagHospital",obj.CurrRepData.DiagHospital);
		
		obj.cboRegProvince.getStore().load({
			callback : function(){
				obj.cboRegProvince.setValue(obj.CurrRepData.RegProvince);
				obj.cboRegCity.getStore().load({
					callback : function(){
						obj.cboRegCity.setValue(obj.CurrRepData.RegCity);
						obj.cboRegCounty.getStore().load({
							callback : function(){
								obj.cboRegCounty.setValue(obj.CurrRepData.RegCounty);
								obj.cboRegVillage.getStore().load({
									callback : function(){
										obj.cboRegVillage.setValue(obj.CurrRepData.RegVillage);
									}
								});							
							}
						});
					}
				});
			}
		});
		Common_SetValue("txtRegRoad",obj.CurrRepData.RegRoad);
		if (obj.CurrRepData.CurrAddrTypeDr!=""){
			obj.cboCurrAddType.getStore().load({
				callback : function(){
					obj.cboCurrAddType.setValue(obj.CurrRepData.CurrAddrTypeDr.ID);
				} 
			});
		}
		obj.cboCurrProvince.getStore().load({
			callback : function(){
				obj.cboCurrProvince.setValue(obj.CurrRepData.CurrProvince);
				obj.cboCurrCity.getStore().load({
					callback : function(){
						obj.cboCurrCity.setValue(obj.CurrRepData.CurrCity);
						obj.cboCurrCounty.getStore().load({
							callback : function(){
								obj.cboCurrCounty.setValue(obj.CurrRepData.CurrCounty);
									obj.cboCurrVillage.getStore().load({
									callback : function(){
										obj.cboCurrVillage.setValue(obj.CurrRepData.CurrVillage);
									}
								});							
							}
						});
					}
				});
			}
		});
		Common_SetValue("txtCurrRoad",obj.CurrRepData.CurrRoad);
	}
	//显示患者信息
	obj.DisplayPatient = function(PatientObj){
		if (obj.CurrRepData.PatientObj.AdmType == "O") {
			//Common_SetDisabled("cbgIsComplete",true);	//是否完整
			Common_SetDisabled("cbgAdmitReason",true);	//入院原因
			Common_SetDisabled("txtAdmitDate",true);	//入院时间
			//Common_SetDisabled("cboRegAddType",true);	//户籍地址类型
			//Common_SetDisabled("cboCurrAddType",true);	//现住址地址类型
		}
		
		obj.txtPatName.setValue(PatientObj.PatName);
		obj.txtHomeTel.setValue(PatientObj.Telephone);
		obj.txtSex.setValue(PatientObj.Sex);
		obj.txtPersonalID.setValue(PatientObj.PersonalID);
		obj.txtBirthday.setRawValue(PatientObj.Birthday);
		//obj.txtNation.setValue(PatientObj.Nation);
		//Common_SetValue('txtNation',obj.CurrRepData.PatientObj.NationDr.ID,obj.CurrRepData.PatientObj.NationDr.Desc);
		obj.txtOPMrNo.setValue(PatientObj.OPMrNo);
		obj.txtIPMrNo.setValue(PatientObj.IPMrNo);
		obj.txtDiagHospital.setValue(HospDesc);
	}
	//初始化出院信息单
	obj.DisplayDisRepInfo = function()
	{
		//相应的发病报卡
		var objHapRep = ExtTool.RunServerMethod("DHCMed.SMD.Report","GetObjByRepType",obj.RepTypeCode,obj.PatientID);
		if ((objHapRep == "")||(objHapRep == null)){
			//window.alert("请先填写入院发病卡！");
			//window.close();
			return;
		}
		var SRPatientObj=ExtTool.RunServerMethod("DHCMed.SMD.ReportPat","GetPatObj",objHapRep.RowID,"")
		obj.txtPersonalID.setValue(SRPatientObj.RPPersonalID);
		Common_SetValue("txtContactor",objHapRep.SRContactor);
		Common_SetValue("txtContactorTel",objHapRep.SRContactorTel);
		Common_SetValue("txtInsurNo",obj.CurrRepData.PatientObj.InsurNo);
		//住院诊断
		var objDisease = ExtTool.RunServerMethod("DHCMed.SS.Disease","GetObjById",objHapRep.SRDiseaseDr)
		obj.cboDiseaseStore.load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						Common_SetValue("cboDisease",objDisease.RowID,objDisease.IDDesc);
						Common_SetValue("txtDiseaseICD",objDisease.IDICD10);
					}
				}
			} 
		});
		//住院用药
		var arrayTreatPharmacy = obj.CurrRepData.TreatPharmacy.split("#");
		if (arrayTreatPharmacy!=""){
			for (var i = 0;i < 3; i++)
			{
				var strDrug = arrayTreatPharmacy[i];
				//if(strDrug == "")
				//	continue;
				if((strDrug!= "")&&(typeof strDrug!= "undefined")){	//修改出院信息单按钮无反应问题
					var arrDrugInfo = strDrug.split("^");
					var index = parseInt(i)+1;
					Common_SetValue("cboTreatDrug"+index,arrDrugInfo[5],arrDrugInfo[1]);
					Common_SetValue("cboTreatInst"+index,arrDrugInfo[6],arrDrugInfo[2]);
					Common_SetValue("txtTreatDoseQty"+index,arrDrugInfo[3]);
					Common_SetValue("cboTreatDoseUnit"+index,arrDrugInfo[7],arrDrugInfo[4]);
				}
			}
		}
		//常住类型
		if (objHapRep.SRLocalDr!=""){
			//var objDic = ExtTool.RunServerMethod("DHCMed.SS.Dictionary","GetObjById",objHapRep.SRLocalDr);
			//Common_SetValue("cbgLocal",objDic.RowID);
			obj.cbgLocal.getStore().load({
				callback : function(){
					obj.cbgLocal.setValue(objHapRep.SRLocalDr);
				} 
			});
		}
		//户籍地址、现住址地址类型
		obj.cboRegAddType.getStore().load({
			callback : function(){
				obj.cboRegAddType.setValue(objHapRep.SRRegAddrTypeDr);
			}
		});
		obj.cboCurrAddType.getStore().load({
			callback : function(){
				obj.cboCurrAddType.setValue(objHapRep.SRRegAddrTypeDr);
			}
		});
		//户籍地址
		obj.cboRegProvince.getStore().load({
			callback : function(){
				obj.cboRegProvince.setValue(objHapRep.SRRegProvince);
				obj.cboRegCity.getStore().load({
					callback : function(){
						obj.cboRegCity.setValue(objHapRep.SRRegCity);
						obj.cboRegCounty.getStore().load({
							callback : function(){
								obj.cboRegCounty.setValue(objHapRep.SRRegCounty);
								
								obj.cboRegVillage.getStore().load({
									callback : function(){
										obj.cboRegVillage.setValue(objHapRep.SRRegVillage);									
									}
								});							
							}
						});
					}
				});
			}
		});
		obj.txtRegRoad.setValue(objHapRep.SRRegRoad);
		//现住址
		obj.cboCurrProvince.getStore().load({
			callback : function(){
				obj.cboCurrProvince.setValue(objHapRep.SRCurrProvince);
				obj.cboCurrCity.getStore().load({
					callback : function(){
						obj.cboCurrCity.setValue(objHapRep.SRCurrCity);
						obj.cboCurrCounty.getStore().load({
							callback : function(){
								obj.cboCurrCounty.setValue(objHapRep.SRCurrCounty);
								
								obj.cboCurrVillage.getStore().load({
									callback : function(){
										obj.cboCurrVillage.setValue(objHapRep.SRCurrVillage);									
									}
								});							
							}
						});
					}
				});
			}
		});
		Common_SetValue("txtCurrRoad",objHapRep.SRCurrRoad);
		//初次发病时间
		//Common_SetValue("txtSickDate",objHapRep.SRSickDate);
		Common_SetDateValue("txtSickDate",objHapRep.SRSickDate);
		//本次入院原因
		if (objHapRep.SRAdmitReasonDr!=""){
			//var objDic = ExtTool.RunServerMethod("DHCMed.SS.Dictionary","GetObjById",objHapRep.SRAdmitReasonDr);
			//Common_SetValue("cbgAdmitReason",objDic.RowID);
			obj.cbgAdmitReason.getStore().load({
				callback : function(){
					obj.cbgAdmitReason.setValue(objHapRep.SRAdmitReasonDr);
				} 
			});
		}
	}
	obj.SaveReport = function(StatusCode){
		var StatusID = ExtTool.RunServerMethod("DHCMed.SSService.DictionarySrv", "GetIdByTypeCode", StatusCode, "SMDRepStatus" );
		var strPatInfo = "";
		strPatInfo +=  Common_GetValue("txtPatName") + String.fromCharCode(2);
		strPatInfo +=  Common_GetValue("txtSex") + String.fromCharCode(2);
		strPatInfo +=  Common_GetValue("txtBirthday") + String.fromCharCode(2);
		strPatInfo +=  Common_GetValue("txtPersonalID") + String.fromCharCode(2);
		strPatInfo +=  Common_GetValue("txtNation")  + String.fromCharCode(2); //民族
		strPatInfo +=  obj.CurrRepData.PatientObj.OPMrNo  + String.fromCharCode(2); //门诊号
		strPatInfo +=  obj.CurrRepData.PatientObj.IPMrNo  + String.fromCharCode(2); //住院号
		strPatInfo +=  Common_GetValue("txtHomeTel")  + String.fromCharCode(2); //电话
		strPatInfo +=  Common_GetValue("txtInsurNo") + String.fromCharCode(2); //医保号
		
		var inputStr = '',strMentalSymptom = "",strTreatPharmacy = "",strRehabPharmacy = "";;
		inputStr += obj.ReportID + CHR_1;
		inputStr += obj.RepTypeID+ CHR_1;
		inputStr += Common_GetValue("cbgAdmType") + CHR_1;
		inputStr += Common_GetValue("cbgPatType") + CHR_1;
		inputStr += obj.EpisodeID + CHR_1;
		inputStr += obj.PatientID + CHR_1;
		inputStr += Common_GetValue("cbgLocal")   + CHR_1;
		inputStr += Common_GetValue("cboDisease") + CHR_1;
		inputStr += obj.cboDisease.getRawValue()  + CHR_1;
		inputStr += StatusID 	  + CHR_1;
		inputStr += Common_GetValue("txtCardNo")		 	+ CHR_1;	//CardNo
		inputStr += Common_GetValue("cbgIsComplete") 		+ CHR_1;
		inputStr += strPatInfo    + CHR_1;								    		//13-病人信息
		inputStr += Common_GetValue("txtContactor") 		+ CHR_1;			    //14-联系人姓名
		inputStr += Common_GetValue("txtContactorTel") 		+ CHR_1;             	//15-联系人电话
		inputStr += obj.cboRegProvince.getRawValue() + obj.cboRegCity.getRawValue() + obj.cboRegCounty.getRawValue() + obj.cboRegVillage.getRawValue() + obj.txtRegRoad.getRawValue() + CHR_1; 			//16-详细地址
		
		inputStr += Common_GetValue("cboRegAddType") 		+ CHR_1;				//17-户籍地址类型
		inputStr += Common_GetValue("cboRegProvince") 		+ CHR_1;				//18-
		inputStr += Common_GetValue("cboRegCity") 			+ CHR_1;                //19-
		inputStr += Common_GetValue("cboRegCounty") 		+ CHR_1;                //20-
		inputStr += Common_GetValue("cboRegVillage")		+ CHR_1;               	//21-
		inputStr += Common_GetValue("txtRegRoad") 			+ CHR_1;                 //22-
		inputStr += obj.cboCurrProvince.getRawValue() + obj.cboCurrCity.getRawValue() + obj.cboCurrCounty.getRawValue() + obj.cboCurrVillage.getRawValue() + obj.txtCurrRoad.getRawValue() + CHR_1;	//23-现住址
		inputStr += Common_GetValue("cboCurrAddType") 		+ CHR_1;				//24-现住址地址类型
		inputStr += Common_GetValue("cboCurrProvince") 		+ CHR_1;             	//25-
		inputStr += Common_GetValue("cboCurrCity") 			+ CHR_1;                //26-
		inputStr += Common_GetValue("cboCurrCounty") 		+ CHR_1;               	//27-
		inputStr += Common_GetValue("cboCurrVillage") 		+ CHR_1;              	//28-
		inputStr += Common_GetValue("txtCurrRoad") 			+ CHR_1;                //29-
		inputStr += Common_GetValue("cboOccupation") 		+ CHR_1;               	//30-职业
		if (Ext.getCmp("txtCompany")){
			inputStr += Common_GetValue("txtCompany") 		+ CHR_1;                //31-工作单位
			inputStr += Common_GetValue("txtCompanyTel") 	+ CHR_1;               	//32-工作单位电话
		}else{
			inputStr += "" 			+ CHR_1; 
		    inputStr += ""	 		+ CHR_1; 
		}
		inputStr += Common_GetValue("txtSickDate") 			+ CHR_1;                //33-初次发病时间
		if (Ext.getCmp("cbgReferral")){
			inputStr += Common_GetValue("cbgReferral") 		+ CHR_1;				//34-送诊主体
			inputStr += Common_GetValue("txtReferralTxt") 	+ CHR_1;              	//35-送诊主体（其它）
		}else{
			inputStr += "" 			+ CHR_1; 
			inputStr += ""	 		+ CHR_1; 
		}
		inputStr += Common_GetValue("txtDiagHospital") 		+ CHR_1;             	//36-确诊医院
		inputStr += Common_GetValue("txtDiagDate") 			+ CHR_1;                //37-确诊日期
		inputStr += session['LOGON.CTLOCID'] 				+ CHR_1;                //38-上报科室
		inputStr += session['LOGON.USERID'] 				+ CHR_1;                //39-上报医师
		inputStr += Common_GetValue("txtRepLocTel") 		+ CHR_1;                //40-科室电话
		inputStr += Common_GetValue("txtRepDate") 			+ CHR_1;                //41-上报日期
		inputStr += ""	+ CHR_1;                                            		//42-上报时间
		if (Ext.getCmp("txtResume")){
			inputStr += Common_GetValue("txtResume") 		+ CHR_1;            	//43-备注
		}else{
			inputStr += "" 			+ CHR_1; 
		}
		inputStr += Common_GetValue("cbgAdmitReason") 		+ CHR_1;				//44-本次入院原因
		if ((obj.RepTypeCode=="2")||(obj.RepTypeCode=="4")){
			inputStr += obj.txtCause.getValue() +","+ obj.txtCause1.getValue() +","+ obj.txtCause2.getValue() + "," + obj.txtCause3.getValue() + "," + obj.txtCause4.getValue() + "," + obj.txtCause5.getValue() + CHR_1;		//45-家庭社会影响
			inputStr += Common_GetValue("txtCauseNote") 	+ CHR_1;				//46-其他补充说明
			inputStr += Common_GetValue("cbgOPTreatment") 	+ CHR_1;                //47-门诊治疗情况
			inputStr += Common_GetValue("txtFDTreatDate") 	+ CHR_1;                //48-首次抗精神药物治疗时间
			inputStr += Common_GetValue("txtTreatTimes") 	+ CHR_1;                //49-住院次数
			inputStr += Common_GetValue("cboDisease") 		+ CHR_1;                //50-住院诊断
			inputStr += Common_GetValue("cboPrognosis") 	+ CHR_1;                //51-住院疗效
			inputStr += Common_GetValue("cbgTreatMeasure")  + CHR_1;				//52-本次住院康复措施
			inputStr += Common_GetValue("txtTreatMeasureTxt")  + CHR_1;             //53-本次住院康复措施其他 //修复无法保存
			inputStr += Common_GetValue("cbgRehabMeasure")  + CHR_1;				//54-康复措施
			inputStr += Common_GetValue("txtRehabMeasureTxt")  + CHR_1;             //55-康复措施其他  //修复无法保存
			inputStr += Common_GetValue("txtRehabResume")  	+ CHR_1;                //56-其他注意事项
			inputStr += Common_GetValue("cbgIsFunding")  	+ CHR_1;				//57-是否获得经费补助
			inputStr += Common_GetValue("cbgFundsType")  	+ CHR_1;				//58-补助类型
			inputStr += Common_GetValue("cbgFundsSource")  	+ CHR_1;				//59-经费来源
			inputStr += Common_GetValue("txtFundsSource")  	+ CHR_1;                //60-经费其他
			inputStr += Common_GetValue("cboPayment")  	+ CHR_1;                //61-付费方式
			strMentalSymptom = obj.SaveMentalSymptomToString();						//精神症状
		    strTreatPharmacy = obj.SaveTreatPharmacyToString();						//住院用药
		    strRehabPharmacy = obj.SaveRehabPharmacyToString();						//康复用药
		}
		
		var ret =ExtTool.RunServerMethod("DHCMed.SMD.Report","Update",inputStr,strMentalSymptom,strTreatPharmacy,strRehabPharmacy,CHR_1);
		if (parseInt(ret)>0){
			obj.ReportID = ret;
			window.returnValue = true;
			ParrefWindowRefresh_Handler();
			ExtTool.alert("提示","保存报卡成功!");
			//***更新报告状态（页面报卡编号旁边加一个报告状态显示）
		} else {
			ExtTool.alert("提示","保存报卡失败!");
			return;
		}
	}
	//精神症状
	obj.SaveMentalSymptomToString = function()
	{
		var strRet = "";
		for (var i = 0; i < obj.cbgSymptoms.length;i++)
		{
			var arrySymptoms = obj.cbgSymptoms[i].getValue();
			for(var j = 0; j < arrySymptoms.length; j ++)
			{
				var strID = arrySymptoms[j].getName().split("-")[1];
				strRet += strID + "#";
			}
		}
		return strRet;
	} 
	//住院用药
	obj.SaveTreatPharmacyToString = function()
	{
		var strRet = "";
		strRet += "";
		strRet += "^" + obj.cboTreatDrug1.getRawValue();
		strRet += "^" + obj.cboTreatInst1.getRawValue();
		strRet += "^" + obj.txtTreatDoseQty1.getValue();
		strRet += "^" + obj.cboTreatDoseUnit1.getRawValue();
		strRet += "^" + obj.cboTreatDrug1.getValue();
		strRet += "^" + obj.cboTreatInst1.getValue();
		strRet += "^" + obj.cboTreatDoseUnit1.getValue();
		strRet += String.fromCharCode(1);
		strRet += "";
		strRet += "^" + obj.cboTreatDrug2.getRawValue();
		strRet += "^" + obj.cboTreatInst2.getRawValue();
		strRet += "^" + obj.txtTreatDoseQty2.getValue();
		strRet += "^" + obj.cboTreatDoseUnit2.getRawValue();
		strRet += "^" + obj.cboTreatDrug2.getValue();
		strRet += "^" + obj.cboTreatInst2.getValue();
		strRet += "^" + obj.cboTreatDoseUnit2.getValue();
		strRet += String.fromCharCode(1);
		strRet += "";
		strRet += "^" + obj.cboTreatDrug3.getRawValue();
		strRet += "^" + obj.cboTreatInst3.getRawValue();
		strRet += "^" + obj.txtTreatDoseQty3.getValue();
		strRet += "^" + obj.cboTreatDoseUnit3.getRawValue();
		strRet += "^" + obj.cboTreatDrug3.getValue();
		strRet += "^" + obj.cboTreatInst3.getValue();
		strRet += "^" + obj.cboTreatDoseUnit3.getValue();
		return strRet;
	}
	//康复用药
	obj.SaveRehabPharmacyToString = function()
	{
		var strRet = "";
		strRet += "";
		strRet += "^" + obj.cboRehabDrug1.getRawValue();
		strRet += "^" + obj.cboRehabInst1.getRawValue();
		strRet += "^" + obj.txtRehabDoseQty1.getValue();
		strRet += "^" + obj.cboRehabDoseUnit1.getRawValue();
		strRet += "^" + obj.cboRehabDrug1.getValue();
		strRet += "^" + obj.cboRehabInst1.getValue();
		strRet += "^" + obj.cboRehabDoseUnit1.getValue();
		strRet += String.fromCharCode(1);
		strRet += "";
		strRet += "^" + obj.cboRehabDrug2.getRawValue();
		strRet += "^" + obj.cboRehabInst2.getRawValue();
		strRet += "^" + obj.txtRehabDoseQty2.getValue();
		strRet += "^" + obj.cboRehabDoseUnit2.getRawValue();
		strRet += "^" + obj.cboRehabDrug2.getValue();
		strRet += "^" + obj.cboRehabInst2.getValue();
		strRet += "^" + obj.cboRehabDoseUnit2.getValue();
		strRet += String.fromCharCode(1);
		strRet += "";
		strRet += "^" + obj.cboRehabDrug3.getRawValue();
		strRet += "^" + obj.cboRehabInst3.getRawValue();
		strRet += "^" + obj.txtRehabDoseQty3.getValue();
		strRet += "^" + obj.cboRehabDoseUnit3.getRawValue();
		strRet += "^" + obj.cboRehabDrug3.getValue();
		strRet += "^" + obj.cboRehabInst3.getValue();
		strRet += "^" + obj.cboRehabDoseUnit3.getValue();
		return strRet;
	}
	// 户籍地址省市县乡触发事件----------Start
	obj.cboRegProvince_expand = function() {
		obj.cboRegProvince.getStore().removeAll();
		obj.cboRegProvince.getStore().load({});
	};
	obj.cboRegProvince_select = function() {
		obj.cboRegCity.getStore().removeAll();
		obj.cboRegCity.getStore().load({});
		obj.cboRegCity.setValue('');
		obj.cboRegCounty.setValue('');
		obj.cboRegVillage.setValue('');
		obj.txtRegRoad.setValue('');
	};
	obj.cboRegCity_expand = function() {
		obj.cboRegCity.getStore().removeAll();
		obj.cboRegCity.getStore().load({});
	};
	obj.cboRegCity_select = function() {
		obj.cboRegCounty.getStore().removeAll();
		obj.cboRegCounty.getStore().load({});
		obj.cboRegCounty.setValue('');
		obj.cboRegVillage.setValue('');
		obj.txtRegRoad.setValue('');
	};
	obj.cboRegCounty_expand = function() {
		obj.cboRegCounty.getStore().removeAll();
		obj.cboRegCounty.getStore().load({});
	};
	obj.cboRegCounty_select = function() {
		obj.cboRegVillage.getStore().removeAll();
		obj.cboRegVillage.getStore().load({});
		obj.cboRegVillage.setValue('');
		obj.txtRegRoad.setValue('');
	};
	obj.cboRegVillage_expand = function() {
		obj.cboRegVillage.getStore().removeAll();
		obj.cboRegVillage.getStore().load({});
	};
	obj.cboRegVillage_select = function() {
		obj.txtRegRoad.setValue('');
	};
	// 户籍地址省市县乡触发事件----------End
	// 省市县乡触发事件----------Start
	obj.cboCurrProvince_expand = function() {
		obj.cboCurrProvince.getStore().removeAll();
		obj.cboCurrProvince.getStore().load({});
	};
	obj.cboCurrProvince_select = function() {
		obj.cboCurrCity.getStore().removeAll();
		obj.cboCurrCity.getStore().load({});
		obj.cboCurrCity.setValue('');
		obj.cboCurrCounty.setValue('');
		obj.cboCurrVillage.setValue('');
		obj.txtCurrRoad.setValue('');
	};
	obj.cboCurrCity_expand = function() {
		obj.cboCurrCity.getStore().removeAll();
		obj.cboCurrCity.getStore().load({});
	};
	obj.cboCurrCity_select = function() {
		obj.cboCurrCounty.getStore().removeAll();
		obj.cboCurrCounty.getStore().load({});
		obj.cboCurrCounty.setValue('');
		obj.cboCurrVillage.setValue('');
		obj.txtCurrRoad.setValue('');
	};
	obj.cboCurrCounty_expand = function() {
		obj.cboCurrCounty.getStore().removeAll();
		obj.cboCurrCounty.getStore().load({});
	};
	obj.cboCurrCounty_select = function() {
		obj.cboCurrVillage.getStore().removeAll();
		obj.cboCurrVillage.getStore().load({});
		obj.cboCurrVillage.setValue('');
		obj.txtCurrRoad.setValue('');
	};
	obj.cboCurrVillage_expand = function() {
		obj.cboCurrVillage.getStore().removeAll();
		obj.cboCurrVillage.getStore().load({});
	};
	obj.cboCurrVillage_select = function() {
		obj.txtCurrRoad.setValue('');
	};
	// 省市县乡触发事件----------End
	obj.btnRepTmp_click = function(){
		obj.SaveReport("0");
		//fix bug报告状态不能及时更新
		//document.getElementById("Spanid").innerText = "草稿";
		document.getElementById("Spanid").innerHTML = "草稿";  //火狐浏览器可能不支持innerText
		obj.LoadEvent();
	}			
	
	obj.btnSubmit_click = function(){
		if (obj.CheckReport() != true) return;
		obj.SaveReport("1");
		//document.getElementById("Spanid").innerText = "提交";
		document.getElementById("Spanid").innerHTML = "提交";   //火狐浏览器可能不支持innerText		
		obj.LoadEvent();
	}
	
	obj.btnDelete_click = function(){
		if(obj.ReportID == "") return;
		ExtTool.confirm("删除报告", "您确定要删除这份报告吗？", 
		function(btn){
			if(btn == "no")
				return;
			var ret = ExtTool.RunServerMethod("DHCMed.SMD.Report","CheckReport",obj.ReportID, "4", "", session['LOGON.USERID']);
			if(ret == "1")
			{
				ExtTool.alert("提示", "删除成功！", Ext.MessageBox.INFO);
				window.close();
			}
			else
				ExtTool.alert("提示", "删除失败，错误代码：" + ret + "！", Ext.MessageBox.ERROR);
		});	
	}
	
	obj.btnCheck_click = function(){
		ExtTool.confirm("审核报告", "您确定要审核这份报告吗？", 
		function(btn){
			if(btn == "no")
				return;
			var ret = ExtTool.RunServerMethod("DHCMed.SMD.Report","CheckReport",obj.ReportID, "2", "", session['LOGON.USERID']);
			if(ret == "1")
			{
				ExtTool.alert("提示", "审核成功！", Ext.MessageBox.INFO);
				//window.location.href = "dhcmed.smd.report.csp?ReportID="+obj.ReportID + "&rnd=" + Math.random();
				//document.getElementById("Spanid").innerText = "审核";
				document.getElementById("Spanid").innerHTML = "审核";   //火狐浏览器可能不支持innerText
			    obj.LoadEvent();
			}
			else
				ExtTool.alert("提示", "审核失败，错误代码：" + ret + "！", Ext.MessageBox.ERROR);
			}
		);
	}
	
	obj.btnCancelCheck_click = function(){
		ExtTool.confirm("取消审核报告", "您确定要取消审核这份报告吗？", 
		function(btn){
			if(btn == "no")
				return;
			var ret = ExtTool.RunServerMethod("DHCMed.SMD.Report","CheckReport",obj.ReportID, "5", "", session['LOGON.USERID']);
			if(ret == "1")
			{
				ExtTool.alert("提示", "取消审核成功！", Ext.MessageBox.INFO);
				//window.location.href = "dhcmed.smd.report.csp?ReportID="+obj.ReportID + "&rnd=" + Math.random();
				document.getElementById("Spanid").innerHTML = "取消审核";   //火狐浏览器可能不支持innerText
			}
			else
				ExtTool.alert("提示", "取消审核失败，错误代码：" + ret + "！", Ext.MessageBox.ERROR);
			}
		);
	}
	
	obj.btnReturn_click = function(){
		ExtTool.confirm("退回报告", "您确定要退回这份报告吗？", 
		function(btn){
			if(btn == "no")
				return;
			ExtTool.prompt("退回原因", "请输入退回原因"	,
				function(btn, txt)
				{
					if (btn == "cancel") return;
					if(txt == "")
					{
						ExtTool.alert("提示", "请输入退回原因，否则不能退回报告！", Ext.MessageBox.INFO);
						return;
					}
					var ret = ExtTool.RunServerMethod("DHCMed.SMD.Report","CheckReport",obj.ReportID, "3", txt, session['LOGON.USERID']);
					if(ret == "1")
					{
						ExtTool.alert("提示", "退回成功！", Ext.MessageBox.INFO);
						//document.getElementById("Spanid").innerText = "退回";
						document.getElementById("Spanid").innerHTML = "退回";    //火狐浏览器不支持innerText
						obj.LoadEvent();
						//window.location.reload();
					}
					else
					{
						ExtTool.alert("提示", "退回失败，错误代码：" + ret + "！", Ext.MessageBox.ERROR);				
					}
				}
			);
		});
	}
	
	obj.btnPrint_click = function(){
		var TemplatePath = ExtTool.RunServerMethod("DHCMed.Service","GetTemplatePath");
		if ((obj.RepTypeCode=="1")||(obj.RepTypeCode=="3")){
			if (obj.CurrRepData.PatientObj.AdmType == "O"){
				var FileName=TemplatePath+"\\\\"+"DHCMed.SMD.ReportOP.xls"
			}else{
				var FileName=TemplatePath+"\\\\"+"DHCMed.SMD.ReportIP.xls"
			}
			try {
				xls = new ActiveXObject ("Excel.Application");
			}catch(e) {
				alert("创建Excel应用对象失败!");
				return;
			}
			xls.visible=false;
			xlBook=xls.Workbooks.Add(FileName);
			xlSheet=xlBook.Worksheets.Item(1);
			var flg = ExtTool.RunServerMethod("DHCMed.SMDService.ReportSrv","PrintSMDReport","fillxlSheet",obj.ReportID);
		}else{
			var FileName=TemplatePath+"\\\\"+"DHCMed.SMD.DisReport.xls"
			try {
				xls = new ActiveXObject ("Excel.Application");
			}catch(e) {
				alert("创建Excel应用对象失败!");
				return;
			}
			xls.visible=false;
			xlBook=xls.Workbooks.Add(FileName);
			xlSheet=xlBook.Worksheets.Item(1);
			var flg = ExtTool.RunServerMethod("DHCMed.SMDService.ReportSrv","PrintSMDDisReport","fillxlSheet",obj.ReportID);
		}
		xlSheet.printout();
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
	}
	
	obj.btnClose_click = function(){
		window.close();
		ParrefWindowClose_Handler();
	}
	//检查规范
	obj.CheckReport = function(){
		var errStr = "";
		if ((obj.RepTypeCode=="2")||(obj.RepTypeCode=="4"))
		{
			errStr += obj.ValidateControl(obj.txtPatName);
			errStr += obj.ValidateControl(obj.txtSex);
			errStr += obj.ValidateControl(obj.txtBirthday);
			errStr += obj.ValidateControl(obj.txtNation);
			//errStr += obj.ValidateControl(obj.txtHomeTel);
			errStr += obj.ValidateControl(obj.txtPersonalID);
			var PatCardNo = Common_GetValue("txtPersonalID");
			var Birthday=Common_GetValue("txtBirthday");
			if (trim(PatCardNo) != ""){
				if (!(/(^\d{15}$)|(^\d{17}([0-9]|X|x)$)/.test(PatCardNo))) {
					errStr += '<P>输入的身份证号长度不对，或者号码不符合规定！15位号码应全为数字，18位号码末位可以为数字或X。</P>';
				}
				var strPatDOB = "";
				var tmpYear,tmpMonth,tmpDay;
				// 如果身份证号是15位,例如：350424870506202
				if (PatCardNo.length == 15) {
					tmpYear = PatCardNo.substr(6,2);
					if (tmpYear != "19") {
						tmpMonth = PatCardNo.substr(8,2);
						tmpDay = PatCardNo.substr(10,2);
						strPatDOB = "19" + tmpYear + "-" + tmpMonth + "-" + tmpDay;
					}
				}
				// 如果身份证号是18位,例如：420536198109216301
				if (PatCardNo.length == 18) {
					tmpYear = PatCardNo.substr(6,4);
					tmpMonth = PatCardNo.substr(10,2);
					tmpDay = PatCardNo.substr(12,2);
					strPatDOB = tmpYear + "-" + tmpMonth + "-" + tmpDay;
				}
				if (strPatDOB != Birthday){
					//fix by maxiangping 190312 取消身份证号与病人出生日期验证 可填写监护人身份证号
					//errStr += '<P>身份证年龄和出生日期不符，请核对后提交!<P>'
				}
			}
			
			errStr += obj.ValidateControl(obj.cboDisease);
			errStr += obj.ValidateControl(obj.txtContactor);
			errStr += obj.ValidateControl(obj.txtContactorTel);
			var ContactorTel = Common_GetValue("txtContactorTel");	//联系人电话
			if (trim(ContactorTel) != ""){
				if (!(/(^\d{11}$)/.test(ContactorTel))) {
					errStr += '<P>输入的联系人电话号码长度不对，或者号码不符合规定！11位号码应全为数字，手机号或者座机加区号。</P>';
				}
			}
			var HomeTel = Common_GetValue("txtHomeTel");	//家庭电话
			if (trim(HomeTel) != ""){
				if (!(/(^\d{11}$)/.test(HomeTel))) {
					errStr += '<P>输入的家庭电话号码长度不对，或者号码不符合规定！11位号码应全为数字，手机号或者座机加区号。</P>';
				}
			}
			errStr += obj.ValidateControl(obj.cbgLocal);
			errStr += obj.ValidateControl(obj.cboRegProvince);
			errStr += obj.ValidateControl(obj.cboRegCity);
			errStr += obj.ValidateControl(obj.cboRegCounty);
			errStr += obj.ValidateControl(obj.cboRegVillage);	
			errStr += obj.ValidateControl(obj.txtRegRoad);
			errStr += obj.ValidateControl(obj.cboRegAddType);
			errStr += obj.ValidateControl(obj.cboCurrProvince);	
			errStr += obj.ValidateControl(obj.cboCurrCity);
			errStr += obj.ValidateControl(obj.cboCurrCounty);	
			errStr += obj.ValidateControl(obj.cboCurrVillage);	
			errStr += obj.ValidateControl(obj.txtCurrRoad);
			errStr += obj.ValidateControl(obj.cboCurrAddType);
			/*if (obj.CurrRepData.PatientObj.AdmType != "O")
			{
				errStr += obj.ValidateControl(obj.cboRegAddType);
				errStr += obj.ValidateControl(obj.cboCurrAddType);
			}*/
			errStr += obj.ValidateControl(obj.txtSickDate);	
			errStr += obj.ValidateControl(obj.txtDiagHospital);	
			errStr += obj.ValidateControl(obj.txtRepLocTel);	//科室电话
			var RepLocTel = Common_GetValue("txtRepLocTel");
			if (trim(RepLocTel) != ""){
				if (!(/(^\d{11}$)/.test(RepLocTel))) {
					errStr += '<P>输入的科室电话号码长度不对，或者号码不符合规定！11位号码应全为数字，手机号或者座机加区号。</P>';
				}
			}
			errStr += obj.ValidateControl(obj.txtDiagDate);	
			/*
			var ContactorTel = Common_GetValue("txtContactorTel");
			var RepLocTel = Common_GetValue("txtRepLocTel");
			var HomeTel = Common_GetValue("txtHomeTel");
			if (trim(ContactorTel) != ""){
				if (!(/(d+-)?(d{4}-?d{7}|d{3}-?d{8}|^d{7,8})(-d+)?/.test(ContactorTel))){
					errStr += "<P>你输入的联系人电话有误！</P>";
				}
			}
			if(trim(HomeTel) != ""){
				if (!(/(d+-)?(d{4}-?d{7}|d{3}-?d{8}|^d{7,8})(-d+)?/.test(HomeTel))){
					errStr += '<P>你输入家庭电话有误！</P>';
				}
			}
			if(trim(RepLocTel) != ""){
				if (!(/(d+-)?(d{4}-?d{7}|d{3}-?d{8}|^d{7,8})(-d+)?/.test(RepLocTel))){
					errStr += '<P>你输入的科室联系电话有误！</P>';
				}
			}
			*/
			errStr += obj.ValidateControl(obj.cbgOPTreatment);
			errStr += obj.ValidateControl(obj.txtFDTreatDate);
			errStr += obj.ValidateControl(obj.txtAdmitDate);
			if(obj.ValidateControl(obj.txtDischDate)!==""){
				errStr += "出院日期为空，不允许提交报卡，请先保存为草稿，待患者出院后再提交出院信息单！";
			}
			errStr += obj.ValidateControl(obj.cbgAdmitReason);
			errStr += obj.ValidateControl(obj.txtTreatTimes);   //不提示出日期，提示住院次数
			var IsFunding=Common_GetText("cbgIsFunding");
			if (IsFunding=="有"){
				errStr += obj.ValidateControl(obj.cbgFundsType);    //是否获得补助为"有"时，补助类型、补助来源必填
				errStr += obj.ValidateControl(obj.cbgFundsSource);  
			}
			errStr += obj.ValidateControl(obj.cboPrognosis);
			if(Common_GetValue("cbgTreatMeasure").length == 0){
				errStr += "<P>请选择“本次住院康复措施”！</P>";
			}else{
				var TreatMeasure = Ext.getCmp('cbgTreatMeasure').items;
				for(var i=0; i<TreatMeasure.length; i++){
					if(TreatMeasure.get(i).checked){
						var TreatMeasureTxt=Common_GetValue("txtTreatMeasureTxt");
						if ((TreatMeasure.get(i).boxLabel.indexOf("其他")> -1)&&(trim(TreatMeasureTxt)=="")) {
							errStr += "<P>请填写“本次住院康复措施”的“其他”！</P>";
						}
					}
				}
			}
			var FundsSource=Ext.getCmp('cbgFundsSource').items;
			for(var i = 0; i < FundsSource.length; i++){
				if(FundsSource.get(i).checked){
					
					var FundsSourceTxt=Common_GetValue("txtFundsSource");
					if ((FundsSource.get(i).boxLabel.indexOf("其他")> -1)&&(trim(FundsSourceTxt)=="")) {
						errStr += "<P>请填写“经费来源”的“其他”！</P>";
					}
				}
			}
			if(Common_GetValue("cbgRehabMeasure").length == 0){
				errStr += "<P>请选择“康复措施”！</P>";
			}else{
				var RehabMeasure=Ext.getCmp('cbgRehabMeasure').items;
				for(var i = 0; i < RehabMeasure.length; i++){
					if(RehabMeasure.get(i).checked){
						var RehabMeasureTxt=Common_GetValue("txtRehabMeasureTxt");
						if((RehabMeasure.get(i).boxLabel.indexOf("其他")> -1)&&(trim(RehabMeasureTxt)=="")) {
							errStr += "<P>请填写“康复措施”的“其他”！</P>";
						}
					}
				}
			}
			errStr += obj.ValidateControl(obj.cbgIsFunding);
			errStr += obj.ValidateControl(obj.cboPayment);
			errStr += obj.ValidateControl(obj.cboTreatDrug1);	//住院用药
			errStr += obj.ValidateControl(obj.cboRehabDrug1);	//康复用药
			//控制用药、用法、单位必须为下拉框中选项
			errStr += obj.DrugControl(obj.cboTreatDrug1);
			errStr += obj.cboControl(obj.cboTreatInst1);
			errStr += obj.cboControl(obj.cboTreatDoseUnit1);
			errStr += obj.DrugControl(obj.cboTreatDrug2);
			errStr += obj.cboControl(obj.cboTreatInst2);
			errStr += obj.cboControl(obj.cboTreatDoseUnit2);
			errStr += obj.DrugControl(obj.cboTreatDrug3);
			errStr += obj.cboControl(obj.cboTreatInst3);
			errStr += obj.cboControl(obj.cboTreatDoseUnit3);
			errStr += obj.DrugControl(obj.cboRehabDrug1);
			errStr += obj.cboControl(obj.cboRehabInst1);
			errStr += obj.cboControl(obj.cboRehabDoseUnit1);
			errStr += obj.DrugControl(obj.cboRehabDrug2);
			errStr += obj.cboControl(obj.cboRehabInst2);
			errStr += obj.cboControl(obj.cboRehabDoseUnit2);
			errStr += obj.DrugControl(obj.cboRehabDrug3);
			errStr += obj.cboControl(obj.cboRehabInst3);
			errStr += obj.cboControl(obj.cboRehabDoseUnit3);
			
			if(obj.SaveMentalSymptomToString().length == 0){
				errStr += "<P>请选择“精神症状”！</P>";
			}else{	//判断精神症状前6项是否填写
				for (var ind = 0; ind < 6; ind++){
					errStr += obj.ValidateControl(obj.cbgSymptoms[ind]);
				}
			}
			//时间逻辑判断   出生时间＜初次发病时间≤首次抗精神病药治疗时间≤本次入院时间≤本次确诊时间≤填卡时间
			var Birthday=Common_DateParse(Common_GetValue("txtBirthday"));
			var SickDate=Common_DateParse(Common_GetValue("txtSickDate"));
			var FDTreatDate=Common_DateParse(Common_GetValue("txtFDTreatDate"));
			var AdmitDate=Common_DateParse(Common_GetValue("txtAdmitDate"));
			var DiagDate=Common_DateParse(Common_GetValue("txtDiagDate"));
			var RepDate=Common_DateParse(Common_GetValue("txtRepDate"));
			if ((Birthday>=SickDate)||(SickDate>FDTreatDate)||(FDTreatDate>AdmitDate)||(AdmitDate>DiagDate)||(DiagDate>RepDate)){
				errStr += '时间逻辑有误，请确保<P>出生时间＜初次发病时间≤首次抗精神病药治疗时间≤本次入院时间≤本次确诊时间≤填卡时间</P>'
			}
		}else{
			errStr += obj.ValidateControl(obj.cbgPatType);	//患者类型
			errStr += obj.ValidateControl(obj.cbgAdmType);	//报卡类型
			errStr += obj.ValidateControl(obj.txtPatName);
			errStr += obj.ValidateControl(obj.txtSex);
			errStr += obj.ValidateControl(obj.txtBirthday);
			errStr += obj.ValidateControl(obj.txtPersonalID);
			var PatCardNo = Common_GetValue("txtPersonalID");
			var Birthday=Common_GetValue("txtBirthday");
			if (trim(PatCardNo) != ""){
				if (!(/(^\d{15}$)|(^\d{17}([0-9]|X|x)$)/.test(PatCardNo))) {
					errStr += '<P>输入的身份证号长度不对，或者号码不符合规定！15位号码应全为数字，18位号码末位可以为数字或X。</P>';
				}
				var strPatDOB = "";
				var tmpYear,tmpMonth,tmpDay;
				// 如果身份证号是15位,例如：350424870506202
				if (PatCardNo.length == 15) {
					tmpYear = PatCardNo.substr(6,2);
					if (tmpYear != "19") {
						tmpMonth = PatCardNo.substr(8,2);
						tmpDay = PatCardNo.substr(10,2);
						strPatDOB = "19" + tmpYear + "-" + tmpMonth + "-" + tmpDay;
					}
				}
				// 如果身份证号是18位,例如：420536198109216301
				if (PatCardNo.length == 18) {
					tmpYear = PatCardNo.substr(6,4);
					tmpMonth = PatCardNo.substr(10,2);
					tmpDay = PatCardNo.substr(12,2);
					strPatDOB = tmpYear + "-" + tmpMonth + "-" + tmpDay;
				}
				if (strPatDOB != Birthday){
					//fix by maxiangping 190312 取消身份证号与病人出生日期验证 可填写监护人身份证号
					//errStr += '<P>身份证年龄和出生日期不符，请核对后提交!<P>'
				}
			}
			errStr += obj.ValidateControl(obj.cboDisease);
			errStr += obj.ValidateControl(obj.txtContactor);
			errStr += obj.ValidateControl(obj.txtContactorTel);
			var ContactorTel = Common_GetValue("txtContactorTel");	//联系人电话
			if (trim(ContactorTel) != ""){
				if (!(/(^\d{11}$)/.test(ContactorTel))) {
					errStr += '<P>输入的联系人电话号码长度不对，或者号码不符合规定！11位号码应全为数字，手机号或者座机加区号。</P>';
				}
			}
			errStr += obj.ValidateControl(obj.cbgLocal);
			errStr += obj.ValidateControl(obj.cboRegProvince);
			errStr += obj.ValidateControl(obj.cboRegCity);
			errStr += obj.ValidateControl(obj.cboRegCounty);
			errStr += obj.ValidateControl(obj.cboRegVillage);	
			errStr += obj.ValidateControl(obj.txtRegRoad);
			errStr += obj.ValidateControl(obj.cboRegAddType);
			errStr += obj.ValidateControl(obj.cboCurrProvince);	
			errStr += obj.ValidateControl(obj.cboCurrCity);
			errStr += obj.ValidateControl(obj.cboCurrCounty);	
			errStr += obj.ValidateControl(obj.cboCurrVillage);	
			errStr += obj.ValidateControl(obj.txtCurrRoad);
			errStr += obj.ValidateControl(obj.cboCurrAddType);
			errStr += obj.ValidateControl(obj.cboOccupation);
			errStr += obj.ValidateControl(obj.txtSickDate);	
			errStr += obj.ValidateControl(obj.txtDiagHospital);	
			errStr += obj.ValidateControl(obj.txtRepLocTel);
			errStr += obj.ValidateControl(obj.txtDiagDate);	
			/*			
			var ContactorTel = Common_GetValue("txtContactorTel");
			var RepLocTel = Common_GetValue("txtRepLocTel");
			if (trim(ContactorTel) != ""){
				if (!(/(d+-)?(d{4}-?d{7}|d{3}-?d{8}|^d{7,8})(-d+)?/.test(ContactorTel))){
					errStr += '<P>你输入的联系人电话有误！</P>';
				}
			}
			if(trim(RepLocTel) != ""){
				if (!(/(d+-)?(d{4}-?d{7}|d{3}-?d{8}|^d{7,8})(-d+)?/.test(RepLocTel))){
					errStr += '<P>你输入的科室联系电话有误！</P>';
				}
			}
			*/
			errStr += obj.ValidateControl(obj.cbgIsComplete);			
			/*if (obj.CurrRepData.PatientObj.AdmType != "O")
			{
				errStr += obj.ValidateControl(obj.cboRegAddType);
				errStr += obj.ValidateControl(obj.cboCurrAddType);
			}*/
			if(Common_GetValue("cbgReferral").length == 0){
				errStr += "<P>请选择“送诊主体”！</P>";
			}else{	//增加判断送诊主体的其他备注不为空的判断
				var Referral=Ext.getCmp('cbgReferral').items;
				for(var i = 0; i < Referral.length; i++){
					if(Referral.get(i).checked){
						var ReferralTxt = Common_GetValue("txtReferralTxt");		
						if ((Referral.get(i).boxLabel.indexOf("其他")> -1)&&(trim(ReferralTxt)=="")) {

							errStr += "<P>请填写“送诊主体”的“其他备注”！</P>";
						}
					}
				}
			}
			//时间逻辑判断   出生时间＜初次发病时间≤本次入院时间≤本次确诊时间≤填卡时间
			var Birthday=Common_DateParse(Common_GetValue("txtBirthday"));
			var SickDate=Common_DateParse(Common_GetValue("txtSickDate"));
			var AdmitDate=Common_DateParse(Common_GetValue("txtAdmitDate"));
			var DiagDate=Common_DateParse(Common_GetValue("txtDiagDate"));
			var RepDate=Common_DateParse(Common_GetValue("txtRepDate"));
			if ((Birthday>=SickDate)||(SickDate>AdmitDate)||(AdmitDate>DiagDate)||(DiagDate>RepDate)){
				errStr += '时间逻辑有误，请确保<P>出生时间＜初次发病时间≤本次入院时间≤本次确诊时间≤填卡时间</P>'
			}
		}	
		if(errStr != "")
		{
			ExtTool.alert("提示", errStr, Ext.MessageBox.INFO);
			return false;
		}
		return true;
	}

	obj.ValidateControl = function(objCtl){
		var errStr = "";
		if((objCtl.getValue() == "") || (!objCtl.isValid(false)))
			errStr = "<P>“" + objCtl.initialConfig.fieldLabel + "”不能为空！</P>";
		return errStr;
	}
	
	//控制用药必须为下拉框中选项
	obj.DrugControl = function(objCtl){
		var errStr = "";
		var DrugID = objCtl.getValue();
		var DrugName = objCtl.getRawValue();
		if((DrugName != "")&&(DrugID != "")){
			var objDrug = ExtTool.RunServerMethod("DHCMed.SMD.PsychDrug","GetObjById",DrugID);
			var DicDrugName = objDrug.PDDesc+"["+objDrug.PDSpec+"]";
			if(DrugName != DicDrugName){
				errStr = "<P>“" + objCtl.initialConfig.fieldLabel + "”不能手动输入，需要选择下拉框内容！</P>";
			}
		}
		return errStr;
	}
	
	//控制用药方法和单位必须为下拉框中选项
	obj.cboControl = function(objCtl){
		var errStr = "";
		var cboID = objCtl.getValue();
		var cboName = objCtl.getRawValue();
		if((cboName != "")&&(cboID != "")){
			var objDic = ExtTool.RunServerMethod("DHCMed.SS.Dictionary","GetObjById",cboID);
			var DicName = objDic.Description;
			if(cboName != DicName){
				errStr = "<P>“" + objCtl.initialConfig.fieldLabel + "”不能手动输入，需要选择下拉框内容！</P>";
			}
		}
		return errStr;
	}
}
// 处理字符串两端的空白
function trim(obj) {
	return obj.toString().replace(/^\s+/, "").replace(/\s+$/, "");
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
//调用父窗体页面关闭
function ParrefWindowClose_Handler(){
	if (typeof window.opener != "undefined"){
		if (typeof window.opener.WindowClose_Handler != "undefined"){
			window.opener.WindowClose_Handler();
		}
	} else {
		if (window.parent) {
			if (typeof window.parent.WindowClose_Handler != "undefined"){
				window.parent.WindowClose_Handler();
			}
		}
	}
}


function Common_ComboToPsychDrug()
{
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.SMDService.PsychDrugSrv';
						param.QueryName = 'QryPsychDrug';
						param.Arg1      = tmpCombo.getRawValue();
						param.ArgCnt    = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'ID'
				}, 
				[
					{name: 'ID', mapping: 'ID'}
					,{name: 'Code', mapping: 'Code'}
					,{name: 'Desc', mapping: 'Desc'}
					,{name: 'Desc1', mapping: 'Desc1'}
					,{name: 'Spec', mapping: 'Spec'}
					,{name: 'PackUnit', mapping: 'PackUnit'}
					,{name: 'ArcimID', mapping: 'ArcimID'}
				]
			)
		})
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th>ID</th>',
					'<th>名称</th>',
					'<th>规格</th>',
					'<th>单位</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{ID}</td>',
					'<td>{Desc}</td>',
					'<td>{Spec}</td>',
					'<td>{PackUnit}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:100
		,valueField : 'ID'
		,displayField : 'Desc1'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((field.getValue()=='')||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(){
								field.setValue('');
							}
						});
					}
				}
			}
		}
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}
