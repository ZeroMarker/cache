// dhcmed.fbd.report.csp
function InitviewScreenEvent(obj) {
	//alert("event:"+obj.reportID+":"+EpisodeID+":"+PatientID+":"+LocFlag);
	obj.objDicManage = ExtTool.StaticServerObject("DHCMed.SS.Dictionary");
	obj.objDiseaseManage = ExtTool.StaticServerObject("DHCMed.SS.Disease");
	obj.objConfigManage = ExtTool.StaticServerObject("DHCMed.SSService.ConfigSrv");
	obj.objPaadmManage = ExtTool.StaticServerObject("DHCMed.Base.PatientAdm");
	obj.objPatientManage = ExtTool.StaticServerObject("DHCMed.Base.Patient");
	obj.objReportManage = ExtTool.StaticServerObject("DHCMed.FBD.Report");
	obj.objReportSrvManage = ExtTool.StaticServerObject("DHCMed.FBDService.ReportSrv");
	obj.objCtLocManage = ExtTool.StaticServerObject("DHCMed.Base.Ctloc");
	obj.objSSUserManage = ExtTool.StaticServerObject("DHCMed.Base.SSUser");
	
	obj.LoadEvent = function(args) {
		obj.cboCurrProvince.on('select', obj.cboCurrProvince_select, obj);
		obj.cboCurrCity.on('select', obj.cboCurrCity_select, obj);
		obj.cboCurrCounty.on('select', obj.cboCurrCounty_select, obj);
		obj.cboCurrVillage.on('select', obj.cboCurrVillage_select, obj);
		obj.cboDisCate.on('select', obj.cboDisCate_select, obj);
		obj.refreshFormInfo(obj.reportID);
		obj.btnSaveFood_click();
		obj.btnDeleteFood_click();
		obj.btnSaveSample_click();
		obj.btnDeleteSample_click();
		obj.gridFood.on('rowclick', obj.gridFood_rowclick, obj);
		obj.gridSample.on('rowclick', obj.gridSample_rowclick, obj);
		obj.btnSaveTmp.on('click', obj.btnSaveTmp_click, obj);
		obj.btnSaveRep.on('click', obj.btnSaveRep_click, obj);
		obj.btnExecheck.on('click', obj.btnExecheck_click, obj);
		obj.btnCancheck.on('click', obj.btnCancheck_click, obj);
		obj.btnReturn.on('click', obj.btnReturn_click, obj);
		obj.btnDelete.on('click', obj.btnDelete_click, obj);
		obj.btnPrint.on('click', obj.btnPrint_click, obj);
		obj.btnClose.on('click', obj.btnClose_click, obj);
		obj.btnReported.on('click', obj.btnReported_click, obj);
	}
	
	// ****************************** ↓↓↓ cbo select
	obj.cboCurrProvince_select = function() {
		obj.cboCurrCityStore.removeAll();
		obj.cboCurrCountyStore.removeAll();
		obj.cboCurrVillageStore.removeAll();
		obj.cboCurrCity.setValue('');
		obj.cboCurrCounty.setValue('');
		obj.cboCurrVillage.setValue('');
		obj.cboCurrCityStore.load({});
		//obj.txtCurrRoad.setValue('');
	}
	
	obj.cboCurrCity_select = function() {
		obj.cboCurrCountyStore.removeAll();
		obj.cboCurrVillageStore.removeAll();
		obj.cboCurrCounty.setValue('');
		obj.cboCurrVillage.setValue('');
		obj.cboCurrCountyStore.load({});
		//obj.txtCurrRoad.setValue('');
	}
	
	obj.cboCurrCounty_select = function() {
		obj.cboCurrVillageStore.removeAll();
		obj.cboCurrVillage.setValue('');
		obj.cboCurrVillageStore.load({});
		//obj.txtCurrRoad.setValue('');
	}
	
	//*****************************
	//add by pylian  20160127 fix bug  171276 对现地址赋值
	obj.cboCurrVillage_Select = function(){
		var CurrAddress=obj.cboCurrProvince.getRawValue()+obj.cboCurrCity.getRawValue()+obj.cboCurrCounty.getRawValue()+obj.cboCurrVillage.getRawValue();
		obj.txtCurrAddress.setValue(CurrAddress);

	}	
	obj.txtCurrRoad.on('change', function(field, e){   
		var CurrAddress=obj.cboCurrProvince.getRawValue()+obj.cboCurrCity.getRawValue()+obj.cboCurrCounty.getRawValue()+obj.cboCurrVillage.getRawValue()+obj.txtCurrRoad.getValue();
		obj.txtCurrAddress.setValue(CurrAddress);
        
     });  
	//*******************************
	obj.cboDisCate_select = function() {
		obj.cboDisDescStore.removeAll();
		obj.cboDisDesc.setValue('');
		obj.cboDisDescStore.load({});
	}
	// ****************************** ↑↑↑ cbo select
	
	// ****************************** ↓↓↓ refresh
	obj.refreshFormInfo = function(reportID) {
		var check = false, statusCode = "";	// 1待审 2已审 3退回 4草稿 5删除 6外院已报
		if (reportID) {
			var objReport = obj.objReportManage.GetObjById(reportID);
			if (objReport) {
				var statusID = objReport.FRStatusDr;
				var objStatus = obj.objDicManage.GetObjById(statusID);
				if (objStatus) { statusCode = objStatus.Code; }
			}
		}
		if (statusCode==2 || statusCode==5 || statusCode==6) { check = true; }	// 已审、删除、外院已报不允许修改
		obj.reportID = reportID;
		obj.showReportData(reportID);	// RepInfo
		IsUseAnti_Click();
		obj.renderSign("divSign", reportID, check);	// SignInfo
		obj.gridFoodStore.load({});	// FoodInfo
		obj.gridSampleStore.load({});	// SampleInfo
		obj.clearFoodData();
		obj.clearSampleData();
		obj.DelListFood = "";
		obj.DelListSample = "";
		obj.currGridFoodRowID = "";
		obj.currGridSampleRowID = "";
		obj.setFormDisabled(check);
		obj.showReportButton(statusCode);
	}
	
	obj.setFormDisabled = function(check) {
		var checkPatient = check, checkRepNo = check, checkSamNo = check;
		if (!check) {
			var IsUpdatePatInfo = obj.objConfigManage.GetValueByKeyHosp("FBD-IsUpdatePatInfo", "");
			var IsUpdateReportNo = obj.objConfigManage.GetValueByKeyHosp("FBD-IsUpdateReportNo", "");
			var IsUpdateSampleNo = obj.objConfigManage.GetValueByKeyHosp("FBD-IsUpdateSampleNo", "");
			if (IsUpdatePatInfo==0) { checkPatient = !check; }
			if (IsUpdateReportNo==0) { checkRepNo = !check; }
			if (IsUpdateSampleNo==0) { checkSamNo = !check; }
		}
		obj.txtPatName.setDisabled(checkPatient);
		obj.txtSex.setDisabled(checkPatient);
		obj.txtAge.setDisabled(checkPatient);
		obj.dtBirthday.setDisabled(checkPatient);
		obj.txtCardNo.setDisabled(checkSamNo);	// No
		obj.txtPatLevel.setDisabled(true);
		obj.txtEncryptLevel.setDisabled(true);
		obj.txtOPNo.setDisabled(check);
		obj.txtIPNo.setDisabled(check);
		obj.txtContactor.setDisabled(check);
		obj.txtPersonalID.setDisabled(check);
		obj.txtTelephone.setDisabled(check);
		obj.txtCompany.setDisabled(check);
		obj.txtCurrAddress.setDisabled(check);
		obj.txtCurrRoad.setDisabled(check);
		obj.txtDisText.setDisabled(check);
		obj.txtPreDiagnos.setDisabled(check);
		obj.txtAnamnesis.setDisabled(check);
		obj.tmSickTime.setDisabled(check);
		obj.dtSickDate.setDisabled(check);
		obj.dtAdmitDate.setDisabled(check);
		obj.tmAdmitTime.setDisabled(check);
		obj.dtDeathDate.setDisabled(check);
		obj.tmDeathTime.setDisabled(check);
		obj.cboPatArea.setDisabled(check);
		obj.cboOccupation.setDisabled(check);
		obj.cboCurrProvince.setDisabled(check);
		obj.cboCurrCity.setDisabled(check);
		obj.cboCurrCounty.setDisabled(check);
		obj.cboCurrVillage.setDisabled(check);
		obj.cboDisCate.setDisabled(check);
		obj.cboDisDesc.setDisabled(check);
		var radioIsInHosp = document.getElementsByName("IsInHosp");
		if (radioIsInHosp) {
			for (var i=0; i<radioIsInHosp.length; i++) {
				radioIsInHosp[i].disabled = check;
			}
		}
		var radioIsUseAnti = document.getElementsByName("IsUseAnti");
		if (radioIsUseAnti) {
			for (var j=0; j<radioIsUseAnti.length; j++) {
				radioIsUseAnti[j].disabled = check;
			}
		}
		if (check) {
			obj.txtUseAntiDesc.setDisabled(check);
		}
		obj.txtFoodName.setDisabled(check);
		obj.txtFoodBrand.setDisabled(check);
		obj.txtManufacturer.setDisabled(check);
		obj.txtWhereToBuy.setDisabled(check);
		obj.txtEatingPlaces.setDisabled(check);
		obj.txtEatingNum.setDisabled(check);
		obj.dtEatingDate.setDisabled(check);
		obj.tmEatingTime.setDisabled(check);
		var IsIncidence = document.getElementsByName("IsIncidence");
		if (IsIncidence) {
			for (var i=0; i<IsIncidence.length; i++) {
				IsIncidence[i].disabled = check;
			}
		}
		var IsSampling = document.getElementsByName("IsSampling");
		if (IsSampling) {
			for (var i=0; i<IsSampling.length; i++) {
				IsSampling[i].disabled = check;
			}
		}
		var btnSaveFood = document.getElementById("btnSaveFood");
		if (btnSaveFood) { btnSaveFood.disabled = check; }
		var btnDeleteFood = document.getElementById("btnDeleteFood");
		if (btnDeleteFood) { btnDeleteFood.disabled = check; }
		obj.txtSampleNo.setDisabled(checkSamNo);	// No
		obj.txtSampleNumber.setDisabled(check);
		obj.txtSampleResume.setDisabled(check);
		obj.dtSampleDate.setDisabled(check);
		obj.cboSampleType.setDisabled(check);
		obj.cboSampleUnit.setDisabled(check);
		var btnSaveSample = document.getElementById("btnSaveSample");
		if (btnSaveSample) { btnSaveSample.disabled = check; }
		var btnDeleteSample = document.getElementById("btnDeleteSample");
		if (btnDeleteSample) { btnDeleteSample.disabled = check; }
	}
	
	obj.showReportButton = function(statusCode) {
		obj.btnSaveTmp.setVisible(false);	// 草稿
		obj.btnSaveRep.setVisible(false);	// 报卡
		obj.btnExecheck.setVisible(false);	// 审核
		obj.btnCancheck.setVisible(false);	// 取消审核
		obj.btnReturn.setVisible(false);	// 退回
		obj.btnDelete.setVisible(false);	// 删除
		obj.btnReported.setVisible(false);	// 外院已报
		obj.btnPrint.setVisible(false);		// 打印
		obj.btnClose.setVisible(true);	// 关闭
		// 1待审 2已审 3退回 4草稿 5删除 6外院已报
		if (LocFlag==0) {	// 医生站
			if (statusCode==1) {			// 待审
				obj.btnSaveRep.setVisible(true);	// 报卡
				obj.btnSaveRep.setText("修改报卡");
				obj.btnDelete.setVisible(true);	// 删除
				obj.btnPrint.setVisible(true);		// 打印
			} else if (statusCode==2) {	// 已审
				//
			} else if (statusCode==3) {	// 退回
				obj.btnSaveRep.setVisible(true);	// 报卡
				obj.btnSaveRep.setText("修改报卡");
				obj.btnDelete.setVisible(true);	// 删除
			} else if (statusCode==4) {	// 草稿
				obj.btnSaveTmp.setVisible(true);	// 草稿
				obj.btnSaveRep.setVisible(true);	// 报卡
				obj.btnDelete.setVisible(true);		// 删除
				obj.btnReported.setVisible(true);	// 外院已报
			} else if (statusCode==5) {	// 删除
				//
			} else if (statusCode==6) {	// 外院已报
				obj.btnDelete.setVisible(true);	// 删除
			} else {					// 无报告
				obj.btnSaveTmp.setVisible(true);	// 草稿
				obj.btnSaveRep.setVisible(true);	// 报卡
				obj.btnReported.setVisible(true);	// 外院已报
			}
		} else if (LocFlag==1) {	// 管理科室
			if (statusCode==1) {			// 待审
				obj.btnSaveRep.setVisible(true);	// 报卡
				obj.btnSaveRep.setText("修改报卡");
				obj.btnExecheck.setVisible(true);	// 审核
				obj.btnReturn.setVisible(true);	// 退回
				obj.btnDelete.setVisible(true);	// 删除
				obj.btnPrint.setVisible(true);		// 打印
			} else if (statusCode==2) {	// 已审
				obj.btnCancheck.setVisible(true);	// 取消审核
				obj.btnPrint.setVisible(true);		// 打印
			} else if (statusCode==3) {	// 退回
				obj.btnSaveRep.setVisible(true);	// 报卡
				obj.btnSaveRep.setText("修改报卡");
				obj.btnDelete.setVisible(true);	// 删除
			} else if (statusCode==4) {	// 草稿
				obj.btnSaveTmp.setVisible(true);	// 草稿
				obj.btnSaveRep.setVisible(true);	// 报卡
				obj.btnDelete.setVisible(true);		// 删除
				obj.btnReported.setVisible(true);	// 外院已报
			} else if (statusCode==5) {	// 删除
				//
			} else if (statusCode==6) {	// 外院已报
				obj.btnDelete.setVisible(true);	// 删除
			} else {					// 无报告
				obj.btnSaveTmp.setVisible(true);	// 草稿
				obj.btnSaveRep.setVisible(true);	// 报卡
				obj.btnReported.setVisible(true);	// 外院已报
			}
		}
	}
	
	obj.showReportData = function(reportID) {
		if (reportID!="") { obj.objCurrReport = obj.objReportManage.GetObjById(reportID); }
		if (obj.objCurrReport) {
			obj.objCurrCtLoc = obj.objCtLocManage.GetObjById(obj.objCurrReport.FRReportLoc);
			obj.objCurrUser = obj.objSSUserManage.GetObjById(obj.objCurrReport.FRReportUser);
		} else {
			obj.objCurrCtLoc = obj.objCtLocManage.GetObjById(session['LOGON.CTLOCID']);
			obj.objCurrUser = obj.objSSUserManage.GetObjById(session['LOGON.USERID']);
		}
		obj.objCurrPaadm = obj.objPaadmManage.GetObjById(EpisodeID);
		obj.objCurrPatient = obj.objPatientManage.GetObjById(PatientID);
		var DiseaseID = "", DisCateID = "", DiseaseText = "", RepStatus = "", AreaID = "", OccupationID = "";
		var PatName="", Sex = "", Birthday = "", PersonalID = "", Nation = "", OPNo = "", IPNo = "";
		var CurrAddress = "", CurrProvince = "", CurrCity = "", CurrCounty = "", CurrVillage = "", CurrRoad = "";
		var SickDate = "", SickTime = "", AdmitDate = "", AdmitTime = "", DeathDate = "", DeathTime = "";
		var CardNo = "", IsInHosp = "", Contactor = "", Telephone = "", Company = "";
		var IsUseAnti = "", UseAntiDesc = "", PreDiagnos = "", Anamnesis = "", ReportLoc = "", ReportUser = "";
		var RepPlace = "", Age = "", RepLoc = "", RepUser = "";
		var SecretStr = ExtTool.RunServerMethod("DHCMed.SSIO.FromSecSrv","GetPatEncryptLevel",PatientID,"");
		obj.txtPatLevel.setValue(SecretStr.split('^')[1]);
		obj.txtEncryptLevel.setValue(SecretStr.split('^')[0]);
		if (obj.objCurrReport) {	// 报告信息
			var PatientObj = obj.objReportSrvManage.GetPatientObj(reportID);
			if (PatientObj) {
				PatName = PatientObj.RPPatName;			// 患者姓名
				Sex = PatientObj.RPSex;					// 性别
				Birthday = PatientObj.RPBirthday;		// 出生日期
				PersonalID = PatientObj.RPPersonalID;	// 身份证号
				Nation = PatientObj.RPNation;			// 民族
				OPNo = PatientObj.RPOPNo;				// 门诊病案号
				IPNo = PatientObj.RPIPNo;				// 住院病案号
			}
			var statusID = obj.objCurrReport.FRStatusDr;	// 报告状态
			var objStatus = obj.objDicManage.GetObjById(statusID);
			if (objStatus) { RepStatus = objStatus.Description; }
			var AreaID = obj.objCurrReport.FRAreaDr;	// 病人属于
			var OccupationID = obj.objCurrReport.FROccupationDr;	// 患者职业
			var DiseaseID = obj.objCurrReport.FRDiseaseDr;	// 疾病信息
			var objDisease = obj.objDiseaseManage.GetObjById(DiseaseID);
			if (objDisease) { DisCateID = objDisease.IDCateDr; }
			DiseaseText = obj.objCurrReport.FRDiseaseText;
			CardNo = obj.objCurrReport.FRCardNo;				// 病例编号	// 提交时生成
			IsInHosp = obj.objCurrReport.FRIsInHosp;			// 是否住院
			Contactor = obj.objCurrReport.FRContactor;			// 监护人
			Telephone = obj.objCurrReport.FRTelephone;			// 联系电话
			Company = obj.objCurrReport.FRCompany;				// 单位
			CurrAddress = obj.objCurrReport.FRCurrAddress;		// 现住址
			CurrProvince = obj.objCurrReport.FRCurrProvince;	// 省
			CurrCity = obj.objCurrReport.FRCurrCity;			// 市
			CurrCounty = obj.objCurrReport.FRCurrCounty;		// 县
			CurrVillage = obj.objCurrReport.FRCurrVillage;		// 乡
			CurrRoad = obj.objCurrReport.FRCurrRoad;			// 街道
			SickDate = obj.objCurrReport.FRSickDate;			// 发病日期
			SickTime = obj.objCurrReport.FRSickTime;			// 发病时间
			AdmitDate = obj.objCurrReport.FRAdmitDate;			// 就诊日期
			AdmitTime = obj.objCurrReport.FRAdmitTime;			// 就诊时间
			DeathDate = obj.objCurrReport.FRDeathDate;			// 死亡日期
			DeathTime = obj.objCurrReport.FRDeathTime;			// 死亡时间
			if (DeathDate=="1840-12-31") { DeathDate = "", DeathTime = ""; }
			IsUseAnti = obj.objCurrReport.FRIsUseAnti;			// 就诊前是否使用抗生素
			UseAntiDesc = obj.objCurrReport.FRUseAntiDesc;		// 就诊前使用抗生素名称
			PreDiagnos = obj.objCurrReport.FRPreDiagnos;		// 初步诊断
			Anamnesis = obj.objCurrReport.FRAnamnesis;			// 既往病史
			RepLoc = obj.objCurrReport.FRReportLoc;				// 报告科室
			RepUser = obj.objCurrReport.FRReportUser;			// 报告人
		}
		if (obj.objCurrPaadm) {	// 就诊信息
			var RepPlace = "";
			if (obj.objCurrPaadm.AdmType=="O") {
				RepPlace = "门诊";
			} else if (obj.objCurrPaadm.AdmType=="I") {
				RepPlace = "病房";
				if (IsInHosp=="") { IsInHosp = 1; }	// ？？？
			} else if (obj.objCurrPaadm.AdmType=="E") {
				RepPlace = "急诊";
			}
			if (AdmitDate=="") { AdmitDate = obj.objCurrPaadm.AdmitDate }
			if (AdmitTime=="") { AdmitTime = obj.objCurrPaadm.AdmitTime }
		}
		if (obj.objCurrPatient) {	// 病人信息	// 以报告为准
			/*
			if (obj.objCurrPatient.Age>0) {
				Age = obj.objCurrPatient.Age + "岁";
			} else if (obj.objCurrPatient.AgeMonth>0) {
				Age = obj.objCurrPatient.AgeMonth + "月";
			} else {
				Age = obj.objCurrPatient.AgeDay + "天";
			}*/
			//update by pylian 2015-07-17 年龄由接口来获取,解决已上报的报告打开时年龄变化的问题
			var Age = ExtTool.RunServerMethod("DHCMed.SSIO.FromHisSrv","GetPapmiAge",PatientID,EpisodeID, obj.objCurrPaadm.AdmitDate,obj.objCurrPaadm.AdmitTime);
	     
			if (PatName=="") { PatName = obj.objCurrPatient.PatientName; }
			if (Sex=="") { Sex = obj.objCurrPatient.Sex; }
			if (Birthday=="") { Birthday = obj.objCurrPatient.Birthday; }
			if (PersonalID=="") { PersonalID = obj.objCurrPatient.PersonalID; }
			if (Contactor=="") { Contactor = obj.objCurrPatient.RelativeName; }			// 监护人姓名
			if (Telephone=="") { Telephone = obj.objCurrPatient.RelativeTelephone; }	// 联系方式
			if (Company=="") { Company = obj.objCurrPatient.WorkAddress; }				// 工作单位
			if (CurrAddress=="") { CurrAddress = obj.objCurrPatient.Address; }			// 住址
		}
		if (obj.objCurrCtLoc) {
			RepLoc = obj.objCurrCtLoc.Descs;	// 报告科室
		}
		if (obj.objCurrUser) {
			RepUser = obj.objCurrUser.Name;	// 报告人
		}
		var IPOPNo = obj.objReportSrvManage.GetIPOPNo(EpisodeID);	// 门诊号、住院号
		if (IPOPNo!="") {
			IPOPNo = IPOPNo.split("^");
			if (IPNo=="") { IPNo = IPOPNo[0]; }
			if (OPNo=="") { OPNo = IPOPNo[1]; }
		}
		// ******************************
		document.getElementById("divRepLoc").innerHTML = RepLoc;	// 报告科室
		document.getElementById("divRepUser").innerHTML = RepUser;	// 报告人
		document.getElementById("divRepPlace").innerHTML = RepPlace;	// 报告位置
		document.getElementById("divRepStatus").innerHTML = '<b><font color="blue">'+RepStatus+'</font></b>';	// 报告状态
		obj.txtOPNo.setValue(OPNo);	// 门诊号
		obj.txtIPNo.setValue(IPNo);	// 住院号
		obj.txtCardNo.setValue(CardNo);	// 报告编号
		var radioIsInHosp = document.getElementById("IsInHosp-"+IsInHosp);	// 是否住院
		if (radioIsInHosp) { radioIsInHosp.checked = true; }
		obj.txtPatName.setValue(PatName);	// 姓名
		obj.txtSex.setValue(Sex);	// 性别
		obj.txtAge.setValue(Age);	// 年龄
		obj.dtBirthday.setValue(Birthday);	// 出生日期
		obj.txtPersonalID.setValue(PersonalID);	// 身份证号
		obj.txtContactor.setValue(Contactor);	// 监护人姓名
		obj.txtTelephone.setValue(Telephone);	// 联系方式
		var radioIsUseAnti = document.getElementById("IsUseAnti-"+IsUseAnti);	// 是否抗生素
		if (radioIsUseAnti) { radioIsUseAnti.checked = true; }
		obj.txtUseAntiDesc.setValue(UseAntiDesc);	//就诊前使用抗生素名称
		obj.cboOccupationStore.load({callback : function() {	// 患者职业
			obj.cboOccupation.setValue(OccupationID);
		}});
		obj.cboPatAreaStore.load({callback : function() {	// 病人属于
			obj.cboPatArea.setValue(AreaID);
		}});
		obj.txtCompany.setValue(Company);	// 单位
		obj.txtCurrAddress.setValue(CurrAddress);	// 现住址
		obj.dtSickDate.setValue(SickDate);	// 发病时间
		obj.tmSickTime.setValue(SickTime);
		obj.dtAdmitDate.setValue(AdmitDate);	// 就诊时间
		obj.tmAdmitTime.setValue(AdmitTime);
		obj.dtDeathDate.setValue(DeathDate);	// 死亡时间
		obj.tmDeathTime.setValue(DeathTime);
		obj.txtPreDiagnos.setValue(PreDiagnos);	// 初步诊断
		obj.txtAnamnesis.setValue(Anamnesis);	// 既往病史
		obj.cboCurrProvinceStore.load({callback : function() {	//	省市县乡
			if (CurrProvince=="") { return; }
			var lengthProvince = obj.cboCurrProvinceStore.getCount();
			for (var i=0; i<lengthProvince; i++) {
				var tmpProvince = obj.cboCurrProvinceStore.getAt(i);
				if (tmpProvince.get("ShortDesc")==CurrProvince) {
					obj.cboCurrProvince.setValue(tmpProvince.get("RowID"));
					obj.cboCurrCityStore.load({callback : function() {
						if (CurrCity=="") { return; }
						var lengthCity = obj.cboCurrCityStore.getCount();
						for (var i=0; i<lengthCity; i++) {
							var tmpCity = obj.cboCurrCityStore.getAt(i);
							if (tmpCity.get("ShortDesc")==CurrCity) {
								obj.cboCurrCity.setValue(tmpCity.get("RowID"));
								obj.cboCurrCountyStore.load({callback : function() {
									if (CurrCounty=="") { return; }
									var lengthCounty = obj.cboCurrCountyStore.getCount();
									for (var i=0; i<lengthCounty; i++) {
										var tmpCounty = obj.cboCurrCountyStore.getAt(i);
										if (tmpCounty.get("ShortDesc")==CurrCounty) {
											obj.cboCurrCounty.setValue(tmpCounty.get("RowID"));
											obj.cboCurrVillageStore.load({callback : function() {
												if (CurrVillage=="") { return; }
												var lengthVillage = obj.cboCurrVillageStore.getCount();
												for (var i=0; i<lengthVillage; i++) {
													var tmpVillage = obj.cboCurrVillageStore.getAt(i);
													if (tmpVillage.get("ShortDesc")==CurrVillage) {
														obj.cboCurrVillage.setValue(tmpVillage.get("RowID"));
														return;
													}
												}
											}});
											return;
										}
									}
								}});
								return;
							}
						}
					}});
					return;
				}
			}
		}});
		obj.txtCurrRoad.setValue(CurrRoad);	// 街道
		obj.cboDisCateStore.load({callback : function() {	// 疾病分类、字典
			obj.cboDisCate.setValue(DisCateID);
			obj.cboDisDescStore.load({callback : function() {
				obj.cboDisDesc.setValue(DiseaseID);
			}});
		}});
		obj.txtDisText.setValue(DiseaseText);	// 疾病备注
	}
	// ****************************** ↑↑↑ refresh
	
	// ****************************** ↓↓↓ food func
	obj.btnSaveFood_click = function() {
		var objButton = document.getElementById("btnSaveFood");
		if (!objButton) { return; }
		objButton.onclick = function() {
			var errorStr = "";
			var FoodName = obj.txtFoodName.getValue();
			var FoodBrand = obj.txtFoodBrand.getValue();
			var Manufacturer = obj.txtManufacturer.getValue();
			var WhereToBuy = obj.txtWhereToBuy.getValue();
			var EatingPlaces = obj.txtEatingPlaces.getValue();
			var EatingDate = obj.dtEatingDate.getRawValue();	// Raw
			var EatingTime = obj.tmEatingTime.getValue();
			var EatingNum = obj.txtEatingNum.getValue();
			var IsIncidence = "", IsIncidenceDesc = "";
			var radioIsIncidence = document.getElementsByName("IsIncidence");
			if (radioIsIncidence) {
				for (var i=0; i<radioIsIncidence.length; i++) {
					var tmpIsIncidence = radioIsIncidence[i];
					if (tmpIsIncidence.checked) {
						IsIncidence = tmpIsIncidence.id;
						IsIncidence = IsIncidence.substring(IsIncidence.length-1, IsIncidence.length);
						IsIncidenceDesc = tmpIsIncidence.value;
					}
				}
			}
			var IsSampling = "", IsSamplingDesc = "";
			var radioIsSampling = document.getElementsByName("IsSampling");
			if (radioIsSampling) {
				for (var j=0; j<radioIsSampling.length; j++) {
					var tmpIsSampling = radioIsSampling[j];
					if (tmpIsSampling.checked) {
						IsSampling = tmpIsSampling.id;
						IsSampling = IsSampling.substring(IsSampling.length-1, IsSampling.length);
						IsSamplingDesc = tmpIsSampling.value;
					}
				}
			}
			if (FoodName=="") { errorStr = errorStr + "请填写食品名称!"; }
			if (WhereToBuy=="") { errorStr = errorStr + "请填写购买地点!"; }
			if (EatingPlaces=="") { errorStr = errorStr + "请填写进食场所!"; }
			if (EatingDate=="" || EatingTime=="") { errorStr = errorStr + "请填写进食时间!"; }
			if (EatingNum=="") { errorStr = errorStr + "请填写进食人数!";}
			if (IsIncidence=="" || IsIncidenceDesc=="") { errorStr = errorStr + "请选择其他人是否发病!"; }
			if (IsSampling=="" || IsSamplingDesc=="") { errorStr = errorStr + "请选择是否采样!"; }
			if (errorStr!="") {
				ExtTool.alert("提示", errorStr);
				return;
			}
			var ID = "";
			var selectObj = obj.gridFood.getSelectionModel().getSelected();
			if (selectObj) {
				ID = selectObj.get("ID");
				selectObj.set("FoodName", FoodName);
				selectObj.set("FoodBrand", FoodBrand);
				selectObj.set("Manufacturer", Manufacturer);
				selectObj.set("WhereToBuy", WhereToBuy);
				selectObj.set("EatingPlaces", EatingPlaces);
				selectObj.set("EatingDate", EatingDate);
				selectObj.set("EatingTime", EatingTime);
				selectObj.set("EatingNum", EatingNum);
				selectObj.set("IsIncidence", IsIncidence);
				selectObj.set("IsIncidenceDesc", IsIncidenceDesc);
				selectObj.set("IsSampling", IsSampling);
				selectObj.set("IsSamplingDesc", IsSamplingDesc);
			} else {
				var objRec = new Ext.data.Record({
					ID : ''
					,FoodName : FoodName
					,FoodBrand : FoodBrand
					,Manufacturer : Manufacturer
					,WhereToBuy : WhereToBuy
					,EatingPlaces : EatingPlaces
					,EatingDate : EatingDate
					,EatingTime : EatingTime
					,EatingNum : EatingNum
					,IsIncidence : IsIncidence
					,IsIncidenceDesc : IsIncidenceDesc
					,IsSampling : IsSampling
					,IsSamplingDesc : IsSamplingDesc
				});
				obj.gridFoodStore.add([objRec]);
			}
			obj.clearFoodData();
		}
	}
	
	obj.btnDeleteFood_click = function() {
		var objButton = document.getElementById("btnDeleteFood");
		if (!objButton) { return; }
		objButton.onclick = function() {
			var selectObj = obj.gridFood.getSelectionModel().getSelected();
			if (!selectObj) {
				ExtTool.alert("提示", "请选中一条记录!");
				return;
			}
			if (selectObj.get("ID")!="") {
				obj.DelListFood = obj.DelListFood + selectObj.get("ID") + ",";
			}
			obj.gridFoodStore.remove(selectObj);
			obj.clearFoodData();
		}
	}
	
	obj.gridFood_rowclick = function() {
		var objRec = obj.gridFood.getSelectionModel().getSelected();
		if (obj.currGridFoodRowID && obj.currGridFoodRowID==objRec.id) {
			obj.clearFoodData();
		} else {
			obj.showFoodData(objRec);
		}
	}
	
	obj.clearFoodData = function() {
		obj.currGridFoodRowID = "";
		obj.txtFoodName.setValue("");
		obj.txtFoodBrand.setValue("");
		obj.txtManufacturer.setValue("");
		obj.txtWhereToBuy.setValue("");
		obj.txtEatingPlaces.setValue("");
		obj.dtEatingDate.setValue("");
		obj.tmEatingTime.setValue("");
		obj.txtEatingNum.setValue("");
		var radioIsIncidence = document.getElementsByName("IsIncidence");
		if (radioIsIncidence) {
			for (var i=0; i<radioIsIncidence.length; i++) {
				radioIsIncidence[i].checked = false;
			}
		}
		var radioIsSampling = document.getElementsByName("IsSampling");
		if (radioIsSampling) {
			for (var j=0; j<radioIsSampling.length; j++) {
				radioIsSampling[j].checked = false;
			}
		}
		obj.gridFood.getSelectionModel().clearSelections();
		//obj.gridFood.getView().refresh();
	}
	
	obj.showFoodData = function(objRow) {
		obj.currGridFoodRowID = objRow.id;
		obj.txtFoodName.setValue(objRow.get("FoodName"));
		obj.txtFoodBrand.setValue(objRow.get("FoodBrand"));
		obj.txtManufacturer.setValue(objRow.get("Manufacturer"));
		obj.txtWhereToBuy.setValue(objRow.get("WhereToBuy"));
		obj.txtEatingPlaces.setValue(objRow.get("EatingPlaces"));
		obj.dtEatingDate.setValue(objRow.get("EatingDate"));
		obj.tmEatingTime.setValue(objRow.get("EatingTime"));
		obj.txtEatingNum.setValue(objRow.get("EatingNum"));
		var radioIsIncidence = document.getElementById("IsIncidence-"+objRow.get("IsIncidence"));
		if (radioIsIncidence) { radioIsIncidence.checked = true; }
		var radioIsSampling = document.getElementById("IsSampling-"+objRow.get("IsSampling"));
		if (radioIsSampling) { radioIsSampling.checked = true; }
	}
	// ****************************** ↑↑↑ food func
	
	// ****************************** ↓↓↓ sample func
	obj.btnSaveSample_click = function() {
		var objButton = document.getElementById("btnSaveSample");
		if (!objButton) { return; }
		objButton.onclick = function() {
			var errorStr = "";
			var SampleNo = obj.txtSampleNo.getValue();
			var SampleNumber = obj.txtSampleNumber.getValue();
			var Resume = obj.txtSampleResume.getValue();
			var SampleDate = obj.dtSampleDate.getRawValue();	// Raw
			var SampleTypeID = obj.cboSampleType.getValue();
			var SampleTypeDesc = obj.cboSampleType.getRawValue();
			var SampleUnitID = obj.cboSampleUnit.getValue();
			var SampleUnitDesc = obj.cboSampleUnit.getRawValue();
			var IsUpdateSampleNo = obj.objConfigManage.GetValueByKeyHosp("FBD-IsUpdateSampleNo", "");
			if (SampleNo=="" && IsUpdateSampleNo==1) { errorStr = errorStr + "请填写样本编号!"; }	// 编号自动生成
			if (SampleNumber=="") { errorStr = errorStr + "请填写样本数量!"; }
			if (SampleDate=="") { errorStr = errorStr + "请填写采样日期!"; }
			if (SampleTypeID=="") { errorStr = errorStr + "请选择样本类型!"; }
			if (SampleUnitID=="") { errorStr = errorStr + "请选择单位!"; }
			if (errorStr!="") {
				ExtTool.alert("提示", errorStr);
				return;
			}
			var ID = "";
			var selectObj = obj.gridSample.getSelectionModel().getSelected();
			if (selectObj) {
				ID = selectObj.get("ID");
				selectObj.set("SampleNo", SampleNo);
				selectObj.set("SampleNumber", SampleNumber);
				selectObj.set("Resume", Resume);
				selectObj.set("SampleDate", SampleDate);
				selectObj.set("SampleTypeID", SampleTypeID);
				selectObj.set("SampleTypeDesc", SampleTypeDesc);
				selectObj.set("SampleUnitID", SampleUnitID);
				selectObj.set("SampleUnitDesc", SampleUnitDesc);
			} else {
				var objRec = new Ext.data.Record({
					ID : ''
					,SampleNo : SampleNo
					,SampleNumber : SampleNumber
					,Resume : Resume
					,SampleDate : SampleDate
					,SampleTypeID : SampleTypeID
					,SampleTypeDesc : SampleTypeDesc
					,SampleUnitID : SampleUnitID
					,SampleUnitDesc : SampleUnitDesc
				});
				obj.gridSampleStore.add([objRec]);
			}
			obj.clearSampleData();
		}
	}
	
	obj.btnDeleteSample_click = function() {
		var objButton = document.getElementById("btnDeleteSample");
		if (!objButton) { return; }
		objButton.onclick = function() {
			var selectObj = obj.gridSample.getSelectionModel().getSelected();
			if (!selectObj) {
				ExtTool.alert("提示", "请选中一条记录!");
				return;
			}
			if (selectObj.get("ID")!="") {
				obj.DelListSample = obj.DelListSample + selectObj.get("ID") + ",";
			}
			obj.gridSampleStore.remove(selectObj);
			obj.clearSampleData();
		}
	}
	
	obj.gridSample_rowclick = function() {
		var objRec = obj.gridSample.getSelectionModel().getSelected();
		if (obj.currGridSampleRowID && obj.currGridSampleRowID==objRec.id) {
			obj.clearSampleData();
		} else {
			obj.showSampleData(objRec);
		}
	}
	
	obj.clearSampleData = function() {
		obj.currGridSampleRowID = "";
		obj.txtSampleNo.setValue("");
		obj.txtSampleNumber.setValue("");
		obj.txtSampleResume.setValue("");
		obj.dtSampleDate.setValue("");
		obj.cboSampleType.setValue("");
		obj.cboSampleUnit.setValue("");
		obj.gridSample.getSelectionModel().clearSelections();
		//obj.gridSample.getView().refresh();
	}
	
	obj.showSampleData = function(objRow) {
		obj.currGridSampleRowID = objRow.id;
		obj.txtSampleNo.setValue(objRow.get("SampleNo"));
		obj.txtSampleNumber.setValue(objRow.get("SampleNumber"));
		obj.txtSampleResume.setValue(objRow.get("Resume"));
		obj.dtSampleDate.setValue(objRow.get("SampleDate"));
		obj.cboSampleTypeStore.load({callback : function() {
			obj.cboSampleType.setValue(objRow.get("SampleTypeID"));
		}});
		obj.cboSampleUnitStore.load({callback : function() {
			obj.cboSampleUnit.setValue(objRow.get("SampleUnitID"));
		}});
	}
	// ****************************** ↑↑↑ sample func
	
	// ****************************** ↓↓↓ report func	// 1待审 2已审 3退回 4草稿 5删除 6外院已报
	obj.btnSaveTmp_click = function() {	// 草稿
		obj.saveReportInfo(4, "^");
	}
	
	obj.btnSaveRep_click = function() {	// 报卡
		obj.saveReportInfo(1, "^");
	}
	
	obj.btnExecheck_click = function() {	// 审核
		//obj.saveReportInfo(2, "^");
		obj.saveReportStatus(2, "^");
	}
	
	obj.btnCancheck_click = function() {	// 取消审核
		obj.saveReportStatus(1, "^");
	}
	
	obj.btnReturn_click = function() {	// 退回
		obj.saveReportStatus(3, "^");
	}
	
	obj.btnDelete_click = function() {	// 删除
		obj.saveReportStatus(5, "^");
	}
	
	obj.btnReported_click = function() {	// 外院已报
		obj.saveReportInfo(6, "^");
	}
	
	obj.btnPrint_click = function() {	// 打印
		ExportReportToExcel(obj.reportID);
	}
	
	obj.btnClose_click = function() {
		window.close();
	}
	// ****************************** ↑↑↑ report func
	
	// ****************************** ↓↓↓ save
	obj.saveReportStatus = function(statusCode, separate) {
		var statusID = "", checkUser = session['LOGON.USERID'];
		var objStatus = obj.objDicManage.GetByTypeCode("FBDREPORTSTATUS", statusCode, "");
		if (objStatus) { statusID = objStatus.RowID; }
		if (obj.reportID=="" || statusID=="") {
			ExtTool.alert("提示", "操作失败!");
			return;
		}
		var checkDate = "", checkTime = "", resume = "";
		var inputStr = obj.reportID;
		inputStr = inputStr + separate + statusID;
		inputStr = inputStr + separate + checkUser;
		inputStr = inputStr + separate + checkDate;
		inputStr = inputStr + separate + checkTime;
		inputStr = inputStr + separate + resume;
		var ret = obj.objReportManage.UpdateStatus(inputStr, separate);
		if (ret>0) {
			ExtTool.alert("提示", "操作成功!");
			obj.refreshFormInfo(ret);
			window.returnValue="true"; //操作成功 添加返回值 刷新查询结果列表
		} else {
			ExtTool.alert("提示", "操作失败!");
		}
	}
	
	obj.saveReportInfo = function(statusCode, separate) {
		var errorStr = "", sepobj = "#";
		var inputStr = obj.saveReportStr(statusCode, separate, sepobj);
		if (inputStr=="") { return; }
		var signList = document.getElementsByName("chkList"), chkSignCount = 0;
		for (var i=0; i<signList.length; i++) {
			if (signList[i].checked) {
				chkSignCount = chkSignCount + 1;
			}
		}
		if (chkSignCount==0 && statusCode==1) {
			ExtTool.alert("提示", "请至少选择一项主要症状与体征!");
			return;
		}
		var retRep = obj.objReportManage.Update(inputStr, separate, sepobj);
		if (retRep>0) {
			var retSign = obj.saveSign(retRep, separate);
			var retFood = obj.saveFood(retRep, separate);
			var retSample = obj.saveSample(retRep, separate);
			if (retSign<0) { errorStr = errorStr + "体征信息保存失败!"; }
			if (retFood<0) { errorStr = errorStr + "暴露信息保存失败!"; }
			if (retSample<0) { errorStr = errorStr + "样本信息保存失败!"; }
			//obj.refreshFormInfo(retRep);
		} else {
			errorStr = errorStr + "报告信息保存失败!";
		}
		if (errorStr=="") {
			errorStr = "保存成功!";
			obj.refreshFormInfo(retRep);
		}
		ExtTool.alert("提示", errorStr);
	}
	
	obj.saveSign = function(reportID, separate) {	// 保存主要体征
		var signFlg = 0;
		var objSignManage = ExtTool.StaticServerObject("DHCMed.FBD.ReportSign");
		var signList = document.getElementsByName("chkList");
		for (var i=0; i<signList.length; i++) {
			var tmpSign = signList[i];
			if (tmpSign.checked) {	// 选中update
				var signDr = "", subID = "", ExtraID = "", ExtraText = "";
				if (tmpSign.value!="") { subID = tmpSign.value.split("||")[1]; }
				if (tmpSign.id!="") {
					signDr = tmpSign.id.substring(3, tmpSign.id.length);
					ExtraID = "txt" + signDr;
				}
				if (ExtraID!="") {
					var objExtra = document.getElementById(ExtraID);
					if (objExtra) { ExtraText = objExtra.value; }
				}
				var inputStr = reportID + separate + subID + separate + signDr + separate + ExtraText;
				var ret = objSignManage.Update(inputStr, separate);
				if (ret<=0) { signFlg = signFlg - 1; }
			} else if (!tmpSign.checked && tmpSign.value!="") {	// 取消选中delete
				var ret = objSignManage.DeleteById(tmpSign.value);
				if (ret<=0) { signFlg = signFlg - 1; }
			}
		}
		return signFlg;
	}
	
	obj.saveFood = function(reportID, separate) {
		var foodFlg = 0;
		var objFoodManage = ExtTool.StaticServerObject("DHCMed.FBD.ReportFood");
		var foodLength = obj.gridFoodStore.getCount();
		for (var i=0; i<foodLength; i++) {	// Update
			var tmpFood = obj.gridFoodStore.getAt(i);
			var subID = "";
			if (tmpFood.get("ID")!="") { subID = tmpFood.get("ID").split("||")[1]; }
			var FoodName = tmpFood.get("FoodName");
			var FoodBrand = tmpFood.get("FoodBrand");
			var Manufacturer = tmpFood.get("Manufacturer");
			var WhereToBuy = tmpFood.get("WhereToBuy");
			var EatingPlaces = tmpFood.get("EatingPlaces");
			var EatingDate = tmpFood.get("EatingDate");
			var EatingTime = tmpFood.get("EatingTime");
			var EatingNum = tmpFood.get("EatingNum");
			var IsIncidence = tmpFood.get("IsIncidence");
			var IsSampling = tmpFood.get("IsSampling");
			var inputStr = reportID;	// input
			inputStr = inputStr + separate + subID;
			inputStr = inputStr + separate + FoodName;
			inputStr = inputStr + separate + FoodBrand;
			inputStr = inputStr + separate + Manufacturer;
			inputStr = inputStr + separate + WhereToBuy;
			inputStr = inputStr + separate + EatingPlaces;
			inputStr = inputStr + separate + EatingDate;
			inputStr = inputStr + separate + EatingTime;
			inputStr = inputStr + separate + EatingNum;
			inputStr = inputStr + separate + IsIncidence;
			inputStr = inputStr + separate + IsSampling;
			var ret = objFoodManage.Update(inputStr, separate);
			if (ret<=0) { foodFlg = foodFlg - 1; }
		}
		if (obj.DelListFood!="") {	// Delete
			obj.DelListFood = obj.DelListFood.substring(0, obj.DelListFood.length-1);
			var objDelList = obj.DelListFood.split(",");
			for (var j=0; j<objDelList.length; j++) {
				var ret = objFoodManage.DeleteById(objDelList[j]);
				if (ret<=0) { foodFlg = foodFlg - 1; }
			}
		}
		return foodFlg;
	}
	
	obj.saveSample = function(reportID, separate) {
		var sampleFlg = "";
		var objSampleManage = ExtTool.StaticServerObject("DHCMed.FBD.ReportSample");
		var sampleLength = obj.gridSampleStore.getCount();
		for (var i=0; i<sampleLength; i++) {	// Update
			var tmpSample = obj.gridSampleStore.getAt(i);
			var subID = "";
			if (tmpSample.get("ID")!="") { subID = tmpSample.get("ID").split("||")[1]; }
			var SampleNo = tmpSample.get("SampleNo");
			var IsUpdateSampleNo = obj.objConfigManage.GetValueByKeyHosp("FBD-IsUpdateSampleNo", "");
			if (IsUpdateSampleNo==0 && SampleNo=="") {	// 样本编号自动生成
				var SampleTypeDesc = tmpSample.get("SampleTypeDesc");
				SampleNo = obj.objReportSrvManage.GetFBDNo("", "2", SampleTypeDesc);
			}
			var SampleTypeID = tmpSample.get("SampleTypeID");
			var SampleNumber = tmpSample.get("SampleNumber");
			var SampleUnitID = tmpSample.get("SampleUnitID");
			var SampleDate = tmpSample.get("SampleDate");
			var Resume = tmpSample.get("Resume");
			var inputStr = reportID;	// input
			inputStr = inputStr + separate + subID;
			inputStr = inputStr + separate + SampleNo;
			inputStr = inputStr + separate + SampleTypeID;
			inputStr = inputStr + separate + SampleNumber;
			inputStr = inputStr + separate + SampleUnitID;
			inputStr = inputStr + separate + SampleDate;
			inputStr = inputStr + separate + Resume;
			var ret = objSampleManage.Update(inputStr, separate);
			if (ret<=0) { sampleFlg = sampleFlg - 1; }
		}
		if (obj.DelListSample!="") {	// Delete
			obj.DelListSample = obj.DelListSample.substring(0, obj.DelListSample.length-1);
			var objDelList = obj.DelListSample.split(",");
			for (var j=0; j<objDelList.length; j++) {
				var ret = objSampleManage.DeleteById(objDelList[j]);
				if (ret<=0) { sampleFlg = sampleFlg - 1; }
			}
		}
		return sampleFlg;
	}
	
	obj.saveReportStr = function(statusCode, separate, sepobj) {
		var StatusID = "";
		var objStatus = obj.objDicManage.GetByTypeCode("FBDREPORTSTATUS", statusCode, "");
		if (objStatus) { StatusID = objStatus.RowID; }
		var OPNo = obj.txtOPNo.getValue();	// 门诊号
		var IPNo = obj.txtIPNo.getValue();	// 住院号
		var CardNo = obj.txtCardNo.getValue();	// 报告编号
		var IsUpdateReportNo = obj.objConfigManage.GetValueByKeyHosp("FBD-IsUpdateReportNo", "")
		if (IsUpdateReportNo==0 && CardNo=="") {	// 报告编号自动生成
			CardNo = obj.objReportSrvManage.GetFBDNo("", "1", "");
		}
		var IsInHosp = "";	// 是否住院
		var radioIsInHosp = document.getElementsByName("IsInHosp");
		if (radioIsInHosp) {
			for (var i=0; i<radioIsInHosp.length; i++) {
				var tmpIsInHosp = radioIsInHosp[i];
				if (tmpIsInHosp.checked) {
					IsInHosp = tmpIsInHosp.id;
					IsInHosp = IsInHosp.substring(IsInHosp.length-1, IsInHosp.length);
				}
			}
		}
		var PatName = obj.txtPatName.getValue();	// 姓名
		var Sex = obj.txtSex.getValue();	// 性别
		var Age = obj.txtAge.getValue();	// 年龄
		var Birthday = obj.dtBirthday.getRawValue();	// 出生日期
		var PersonalID = obj.txtPersonalID.getValue();	// 身份证号
		var Contactor = obj.txtContactor.getValue();	// 监护人姓名
		var Telephone = obj.txtTelephone.getValue();	// 联系方式
		var IsUseAnti = "";	// 是否抗生素
		var radioIsUseAnti = document.getElementsByName("IsUseAnti");
		if (radioIsUseAnti) {
			for (var j=0; j<radioIsUseAnti.length; j++) {
				var tmpIsUseAnti = radioIsUseAnti[j];
				if (tmpIsUseAnti.checked) {
					IsUseAnti = tmpIsUseAnti.id;
					IsUseAnti = IsUseAnti.substring(IsUseAnti.length-1, IsUseAnti.length);
				}
			}
		}
		
		var UseAntiDesc = obj.txtUseAntiDesc.getValue();	//就诊前使用抗生素名称
		var OccupationID = obj.cboOccupation.getValue();	// 患者职业
		var AreaID = obj.cboPatArea.getValue();	// 病人属于
		var Company = obj.txtCompany.getValue();	// 单位
		var CurrAddress = obj.txtCurrAddress.getValue();	// 现住址
		var CurrProvince = obj.cboCurrProvince.getRawValue();	// 省
		var CurrCity = obj.cboCurrCity.getRawValue();	// 市
		var CurrCounty = obj.cboCurrCounty.getRawValue();	// 县
		var CurrVillage = obj.cboCurrVillage.getRawValue();	// 乡
		var CurrRoad = obj.txtCurrRoad.getValue();	// 街道
		var DisCateID = obj.cboDisCate.getValue();	// 疾病分类
		var DiseaseID = obj.cboDisDesc.getValue();	// 疾病ID
		var DiseaseText = obj.txtDisText.getValue();	// 疾病备注
		var SickDate = obj.dtSickDate.getRawValue();	// 发病时间
		var SickTime = obj.tmSickTime.getValue();
		var AdmitDate = obj.dtAdmitDate.getRawValue();	// 就诊时间
		var AdmitTime = obj.tmAdmitTime.getValue();
		var DeathDate = obj.dtDeathDate.getRawValue();	// 死亡时间
		var DeathTime = obj.tmDeathTime.getValue();
		var PreDiagnos = obj.txtPreDiagnos.getValue();	// 初步诊断
		var Anamnesis = obj.txtAnamnesis.getValue();	// 既往病史
		var EpisodeID = "", PatientID = "", ReportLoc = "";
		var ReportUser = "", ReportDate = "", ReportTime = "";
		var CheckUser = "", CheckDate = "", CheckTime = "", Resume = "";
		if (obj.objCurrPaadm) { EpisodeID = obj.objCurrPaadm.AdmRowID; }
		if (obj.objCurrPatient) { PatientID = obj.objCurrPatient.Papmi; }
		if (obj.objCurrCtLoc) { ReportLoc = obj.objCurrCtLoc.Rowid }
		if (obj.objCurrUser) { ReportUser = obj.objCurrUser.Rowid }
		if (statusCode==1 || statusCode==2) {
			var errorStr = "";
			if (StatusID=="") { errorStr = errorStr + "报告状态错误!"; }
			if (CardNo=="") { errorStr = errorStr + "请填写病例编号!"; }
			//if (OPNo=="") { errorStr = errorStr + "请填写门诊号!"; }
			if (IsInHosp=="") { errorStr = errorStr + "请选择是否住院!"; }
			if (PatName=="") { errorStr = errorStr + "请填写姓名!"; }
			if (Sex=="") { errorStr = errorStr + "请填写性别!"; }
			if (Age=="") { errorStr = errorStr + "请填写年龄!"; }
			if (Birthday=="") { errorStr = errorStr + "请填写出生日期!"; }
			if (Telephone=="") { errorStr = errorStr + "请填写联系方式!"; }
			if (IsUseAnti=="") { errorStr = errorStr + "请选择就诊前是否使用抗生素!"; }
			if ((IsUseAnti=='1')&&(UseAntiDesc=="")) { errorStr = errorStr + "请填写就诊前使用抗生素名称!"; }
			if (OccupationID=="") { errorStr = errorStr + "请选择患者职业!"; }
			if (AreaID=="") { errorStr = errorStr + "请选择病人属于!"; }
			if (CurrProvince=="") { errorStr = errorStr + "请选择省!"; }
			if (CurrCity=="") { errorStr = errorStr + "请选择市!"; }
			if (CurrCounty=="") { errorStr = errorStr + "请选择县!"; }
			if (CurrVillage=="") { errorStr = errorStr + "请选择乡!"; }
			if (CurrRoad=="") { errorStr = errorStr + "请填写街道!"; }
			if (DisCateID=="") { errorStr = errorStr + "请选择疾病分类!"; }
			if (DiseaseID=="") { errorStr = errorStr + "请选择疾病名称!"; }
			if (SickDate=="") { errorStr = errorStr + "请填写发病日期!"; }
			if (SickTime=="") { errorStr = errorStr + "请填写发病时间!"; }
			if (AdmitDate=="") { errorStr = errorStr + "请填写就诊日期!"; }
			if (AdmitTime=="") { errorStr = errorStr + "请填写就诊时间!"; }
			if (PreDiagnos=="") { errorStr = errorStr + "请填写初步诊断!"; }
			//fix bug 7382 2015-02-14 身份证格式验证
			if (trim(PersonalID) != ""){
				if (!(/(^\d{15}$)|(^\d{17}([0-9]|X|x)$)/.test(PersonalID))) {
					errorStr += '<P>输入的身份证号长度不对，或者号码不符合规定！15位号码应全为数字，18位号码末位可以为数字或X。</P>';
				}
			}
			if (errorStr!="") {
				ExtTool.alert("提示", errorStr);
				return "";
			}
		}
		var IsUpdatePatInfo = obj.objConfigManage.GetValueByKeyHosp("FBD-IsUpdatePatInfo", "");
		if (IsUpdatePatInfo==0) {	// 基本信息不改变不存
			PatName = "";
			Sex = "";
			Birthday = "";
		}
		var objPatStr = PatName;
		objPatStr = objPatStr + sepobj + Sex;
		objPatStr = objPatStr + sepobj + Birthday;
		objPatStr = objPatStr + sepobj + PersonalID;
		objPatStr = objPatStr + sepobj + "";	// RPNation;	// 民族暂时不需要
		objPatStr = objPatStr + sepobj + OPNo;
		objPatStr = objPatStr + sepobj + IPNo;
		var objPatientData = objPatStr;
		var tmpStr = obj.reportID;	// inputStr
		tmpStr = tmpStr + separate + EpisodeID;
		tmpStr = tmpStr + separate + PatientID;
		tmpStr = tmpStr + separate + DiseaseID;
		tmpStr = tmpStr + separate + DiseaseText;
		tmpStr = tmpStr + separate + StatusID;
		tmpStr = tmpStr + separate + CardNo;
		tmpStr = tmpStr + separate + objPatientData;	// PatientObj
		tmpStr = tmpStr + separate + IsInHosp;
		tmpStr = tmpStr + separate + Contactor;
		tmpStr = tmpStr + separate + Telephone;
		tmpStr = tmpStr + separate + Company;
		tmpStr = tmpStr + separate + AreaID;
		tmpStr = tmpStr + separate + CurrAddress;
		tmpStr = tmpStr + separate + CurrProvince;
		tmpStr = tmpStr + separate + CurrCity;
		tmpStr = tmpStr + separate + CurrCounty;
		tmpStr = tmpStr + separate + CurrVillage;
		tmpStr = tmpStr + separate + CurrRoad;
		tmpStr = tmpStr + separate + OccupationID;
		tmpStr = tmpStr + separate + SickDate;
		tmpStr = tmpStr + separate + SickTime;
		tmpStr = tmpStr + separate + AdmitDate;
		tmpStr = tmpStr + separate + AdmitTime;
		tmpStr = tmpStr + separate + DeathDate;
		tmpStr = tmpStr + separate + DeathTime;
		tmpStr = tmpStr + separate + IsUseAnti;
		tmpStr = tmpStr + separate + PreDiagnos;
		tmpStr = tmpStr + separate + Anamnesis;
		tmpStr = tmpStr + separate + ReportLoc;
		tmpStr = tmpStr + separate + ReportUser;
		tmpStr = tmpStr + separate + ReportDate;
		tmpStr = tmpStr + separate + ReportTime;
		tmpStr = tmpStr + separate + CheckUser;
		tmpStr = tmpStr + separate + CheckDate;
		tmpStr = tmpStr + separate + CheckTime;
		tmpStr = tmpStr + separate + Resume;
		tmpStr = tmpStr + separate + UseAntiDesc;
		return tmpStr;
	}
	// ****************************** ↑↑↑ save
}
// 处理字符串两端的空白
function trim(obj) {
	return obj.toString().replace(/^\s+/, "").replace(/\s+$/, "");
}

function IsUseAnti_Click() {
	var IsUseAnti = "";
	var radioIsUseAnti = document.getElementsByName("IsUseAnti");
		if (radioIsUseAnti) {
			for (var j=0; j<radioIsUseAnti.length; j++) {
				var tmpIsUseAnti = radioIsUseAnti[j];
				if (tmpIsUseAnti.checked) {
					IsUseAnti = tmpIsUseAnti.id;
					IsUseAnti = IsUseAnti.substring(IsUseAnti.length-1, IsUseAnti.length);
				}
			}
		}
	var txtUseAntiDesc = Ext.getCmp("txtUseAntiDesc");
	
	if (IsUseAnti=='1') {	
		txtUseAntiDesc.setDisabled(false);
	}
	else{
		txtUseAntiDesc.setDisabled(true);
		txtUseAntiDesc.setValue("");
	}
}
