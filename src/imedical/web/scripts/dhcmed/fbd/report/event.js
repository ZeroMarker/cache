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
	
	// ****************************** ������ cbo select
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
	//add by pylian  20160127 fix bug  171276 ���ֵ�ַ��ֵ
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
	// ****************************** ������ cbo select
	
	// ****************************** ������ refresh
	obj.refreshFormInfo = function(reportID) {
		var check = false, statusCode = "";	// 1���� 2���� 3�˻� 4�ݸ� 5ɾ�� 6��Ժ�ѱ�
		if (reportID) {
			var objReport = obj.objReportManage.GetObjById(reportID);
			if (objReport) {
				var statusID = objReport.FRStatusDr;
				var objStatus = obj.objDicManage.GetObjById(statusID);
				if (objStatus) { statusCode = objStatus.Code; }
			}
		}
		if (statusCode==2 || statusCode==5 || statusCode==6) { check = true; }	// ����ɾ������Ժ�ѱ��������޸�
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
		obj.btnSaveTmp.setVisible(false);	// �ݸ�
		obj.btnSaveRep.setVisible(false);	// ����
		obj.btnExecheck.setVisible(false);	// ���
		obj.btnCancheck.setVisible(false);	// ȡ�����
		obj.btnReturn.setVisible(false);	// �˻�
		obj.btnDelete.setVisible(false);	// ɾ��
		obj.btnReported.setVisible(false);	// ��Ժ�ѱ�
		obj.btnPrint.setVisible(false);		// ��ӡ
		obj.btnClose.setVisible(true);	// �ر�
		// 1���� 2���� 3�˻� 4�ݸ� 5ɾ�� 6��Ժ�ѱ�
		if (LocFlag==0) {	// ҽ��վ
			if (statusCode==1) {			// ����
				obj.btnSaveRep.setVisible(true);	// ����
				obj.btnSaveRep.setText("�޸ı���");
				obj.btnDelete.setVisible(true);	// ɾ��
				obj.btnPrint.setVisible(true);		// ��ӡ
			} else if (statusCode==2) {	// ����
				//
			} else if (statusCode==3) {	// �˻�
				obj.btnSaveRep.setVisible(true);	// ����
				obj.btnSaveRep.setText("�޸ı���");
				obj.btnDelete.setVisible(true);	// ɾ��
			} else if (statusCode==4) {	// �ݸ�
				obj.btnSaveTmp.setVisible(true);	// �ݸ�
				obj.btnSaveRep.setVisible(true);	// ����
				obj.btnDelete.setVisible(true);		// ɾ��
				obj.btnReported.setVisible(true);	// ��Ժ�ѱ�
			} else if (statusCode==5) {	// ɾ��
				//
			} else if (statusCode==6) {	// ��Ժ�ѱ�
				obj.btnDelete.setVisible(true);	// ɾ��
			} else {					// �ޱ���
				obj.btnSaveTmp.setVisible(true);	// �ݸ�
				obj.btnSaveRep.setVisible(true);	// ����
				obj.btnReported.setVisible(true);	// ��Ժ�ѱ�
			}
		} else if (LocFlag==1) {	// �������
			if (statusCode==1) {			// ����
				obj.btnSaveRep.setVisible(true);	// ����
				obj.btnSaveRep.setText("�޸ı���");
				obj.btnExecheck.setVisible(true);	// ���
				obj.btnReturn.setVisible(true);	// �˻�
				obj.btnDelete.setVisible(true);	// ɾ��
				obj.btnPrint.setVisible(true);		// ��ӡ
			} else if (statusCode==2) {	// ����
				obj.btnCancheck.setVisible(true);	// ȡ�����
				obj.btnPrint.setVisible(true);		// ��ӡ
			} else if (statusCode==3) {	// �˻�
				obj.btnSaveRep.setVisible(true);	// ����
				obj.btnSaveRep.setText("�޸ı���");
				obj.btnDelete.setVisible(true);	// ɾ��
			} else if (statusCode==4) {	// �ݸ�
				obj.btnSaveTmp.setVisible(true);	// �ݸ�
				obj.btnSaveRep.setVisible(true);	// ����
				obj.btnDelete.setVisible(true);		// ɾ��
				obj.btnReported.setVisible(true);	// ��Ժ�ѱ�
			} else if (statusCode==5) {	// ɾ��
				//
			} else if (statusCode==6) {	// ��Ժ�ѱ�
				obj.btnDelete.setVisible(true);	// ɾ��
			} else {					// �ޱ���
				obj.btnSaveTmp.setVisible(true);	// �ݸ�
				obj.btnSaveRep.setVisible(true);	// ����
				obj.btnReported.setVisible(true);	// ��Ժ�ѱ�
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
		if (obj.objCurrReport) {	// ������Ϣ
			var PatientObj = obj.objReportSrvManage.GetPatientObj(reportID);
			if (PatientObj) {
				PatName = PatientObj.RPPatName;			// ��������
				Sex = PatientObj.RPSex;					// �Ա�
				Birthday = PatientObj.RPBirthday;		// ��������
				PersonalID = PatientObj.RPPersonalID;	// ���֤��
				Nation = PatientObj.RPNation;			// ����
				OPNo = PatientObj.RPOPNo;				// ���ﲡ����
				IPNo = PatientObj.RPIPNo;				// סԺ������
			}
			var statusID = obj.objCurrReport.FRStatusDr;	// ����״̬
			var objStatus = obj.objDicManage.GetObjById(statusID);
			if (objStatus) { RepStatus = objStatus.Description; }
			var AreaID = obj.objCurrReport.FRAreaDr;	// ��������
			var OccupationID = obj.objCurrReport.FROccupationDr;	// ����ְҵ
			var DiseaseID = obj.objCurrReport.FRDiseaseDr;	// ������Ϣ
			var objDisease = obj.objDiseaseManage.GetObjById(DiseaseID);
			if (objDisease) { DisCateID = objDisease.IDCateDr; }
			DiseaseText = obj.objCurrReport.FRDiseaseText;
			CardNo = obj.objCurrReport.FRCardNo;				// �������	// �ύʱ����
			IsInHosp = obj.objCurrReport.FRIsInHosp;			// �Ƿ�סԺ
			Contactor = obj.objCurrReport.FRContactor;			// �໤��
			Telephone = obj.objCurrReport.FRTelephone;			// ��ϵ�绰
			Company = obj.objCurrReport.FRCompany;				// ��λ
			CurrAddress = obj.objCurrReport.FRCurrAddress;		// ��סַ
			CurrProvince = obj.objCurrReport.FRCurrProvince;	// ʡ
			CurrCity = obj.objCurrReport.FRCurrCity;			// ��
			CurrCounty = obj.objCurrReport.FRCurrCounty;		// ��
			CurrVillage = obj.objCurrReport.FRCurrVillage;		// ��
			CurrRoad = obj.objCurrReport.FRCurrRoad;			// �ֵ�
			SickDate = obj.objCurrReport.FRSickDate;			// ��������
			SickTime = obj.objCurrReport.FRSickTime;			// ����ʱ��
			AdmitDate = obj.objCurrReport.FRAdmitDate;			// ��������
			AdmitTime = obj.objCurrReport.FRAdmitTime;			// ����ʱ��
			DeathDate = obj.objCurrReport.FRDeathDate;			// ��������
			DeathTime = obj.objCurrReport.FRDeathTime;			// ����ʱ��
			if (DeathDate=="1840-12-31") { DeathDate = "", DeathTime = ""; }
			IsUseAnti = obj.objCurrReport.FRIsUseAnti;			// ����ǰ�Ƿ�ʹ�ÿ�����
			UseAntiDesc = obj.objCurrReport.FRUseAntiDesc;		// ����ǰʹ�ÿ���������
			PreDiagnos = obj.objCurrReport.FRPreDiagnos;		// �������
			Anamnesis = obj.objCurrReport.FRAnamnesis;			// ������ʷ
			RepLoc = obj.objCurrReport.FRReportLoc;				// �������
			RepUser = obj.objCurrReport.FRReportUser;			// ������
		}
		if (obj.objCurrPaadm) {	// ������Ϣ
			var RepPlace = "";
			if (obj.objCurrPaadm.AdmType=="O") {
				RepPlace = "����";
			} else if (obj.objCurrPaadm.AdmType=="I") {
				RepPlace = "����";
				if (IsInHosp=="") { IsInHosp = 1; }	// ������
			} else if (obj.objCurrPaadm.AdmType=="E") {
				RepPlace = "����";
			}
			if (AdmitDate=="") { AdmitDate = obj.objCurrPaadm.AdmitDate }
			if (AdmitTime=="") { AdmitTime = obj.objCurrPaadm.AdmitTime }
		}
		if (obj.objCurrPatient) {	// ������Ϣ	// �Ա���Ϊ׼
			/*
			if (obj.objCurrPatient.Age>0) {
				Age = obj.objCurrPatient.Age + "��";
			} else if (obj.objCurrPatient.AgeMonth>0) {
				Age = obj.objCurrPatient.AgeMonth + "��";
			} else {
				Age = obj.objCurrPatient.AgeDay + "��";
			}*/
			//update by pylian 2015-07-17 �����ɽӿ�����ȡ,������ϱ��ı����ʱ����仯������
			var Age = ExtTool.RunServerMethod("DHCMed.SSIO.FromHisSrv","GetPapmiAge",PatientID,EpisodeID, obj.objCurrPaadm.AdmitDate,obj.objCurrPaadm.AdmitTime);
	     
			if (PatName=="") { PatName = obj.objCurrPatient.PatientName; }
			if (Sex=="") { Sex = obj.objCurrPatient.Sex; }
			if (Birthday=="") { Birthday = obj.objCurrPatient.Birthday; }
			if (PersonalID=="") { PersonalID = obj.objCurrPatient.PersonalID; }
			if (Contactor=="") { Contactor = obj.objCurrPatient.RelativeName; }			// �໤������
			if (Telephone=="") { Telephone = obj.objCurrPatient.RelativeTelephone; }	// ��ϵ��ʽ
			if (Company=="") { Company = obj.objCurrPatient.WorkAddress; }				// ������λ
			if (CurrAddress=="") { CurrAddress = obj.objCurrPatient.Address; }			// סַ
		}
		if (obj.objCurrCtLoc) {
			RepLoc = obj.objCurrCtLoc.Descs;	// �������
		}
		if (obj.objCurrUser) {
			RepUser = obj.objCurrUser.Name;	// ������
		}
		var IPOPNo = obj.objReportSrvManage.GetIPOPNo(EpisodeID);	// ����š�סԺ��
		if (IPOPNo!="") {
			IPOPNo = IPOPNo.split("^");
			if (IPNo=="") { IPNo = IPOPNo[0]; }
			if (OPNo=="") { OPNo = IPOPNo[1]; }
		}
		// ******************************
		document.getElementById("divRepLoc").innerHTML = RepLoc;	// �������
		document.getElementById("divRepUser").innerHTML = RepUser;	// ������
		document.getElementById("divRepPlace").innerHTML = RepPlace;	// ����λ��
		document.getElementById("divRepStatus").innerHTML = '<b><font color="blue">'+RepStatus+'</font></b>';	// ����״̬
		obj.txtOPNo.setValue(OPNo);	// �����
		obj.txtIPNo.setValue(IPNo);	// סԺ��
		obj.txtCardNo.setValue(CardNo);	// ������
		var radioIsInHosp = document.getElementById("IsInHosp-"+IsInHosp);	// �Ƿ�סԺ
		if (radioIsInHosp) { radioIsInHosp.checked = true; }
		obj.txtPatName.setValue(PatName);	// ����
		obj.txtSex.setValue(Sex);	// �Ա�
		obj.txtAge.setValue(Age);	// ����
		obj.dtBirthday.setValue(Birthday);	// ��������
		obj.txtPersonalID.setValue(PersonalID);	// ���֤��
		obj.txtContactor.setValue(Contactor);	// �໤������
		obj.txtTelephone.setValue(Telephone);	// ��ϵ��ʽ
		var radioIsUseAnti = document.getElementById("IsUseAnti-"+IsUseAnti);	// �Ƿ�����
		if (radioIsUseAnti) { radioIsUseAnti.checked = true; }
		obj.txtUseAntiDesc.setValue(UseAntiDesc);	//����ǰʹ�ÿ���������
		obj.cboOccupationStore.load({callback : function() {	// ����ְҵ
			obj.cboOccupation.setValue(OccupationID);
		}});
		obj.cboPatAreaStore.load({callback : function() {	// ��������
			obj.cboPatArea.setValue(AreaID);
		}});
		obj.txtCompany.setValue(Company);	// ��λ
		obj.txtCurrAddress.setValue(CurrAddress);	// ��סַ
		obj.dtSickDate.setValue(SickDate);	// ����ʱ��
		obj.tmSickTime.setValue(SickTime);
		obj.dtAdmitDate.setValue(AdmitDate);	// ����ʱ��
		obj.tmAdmitTime.setValue(AdmitTime);
		obj.dtDeathDate.setValue(DeathDate);	// ����ʱ��
		obj.tmDeathTime.setValue(DeathTime);
		obj.txtPreDiagnos.setValue(PreDiagnos);	// �������
		obj.txtAnamnesis.setValue(Anamnesis);	// ������ʷ
		obj.cboCurrProvinceStore.load({callback : function() {	//	ʡ������
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
		obj.txtCurrRoad.setValue(CurrRoad);	// �ֵ�
		obj.cboDisCateStore.load({callback : function() {	// �������ࡢ�ֵ�
			obj.cboDisCate.setValue(DisCateID);
			obj.cboDisDescStore.load({callback : function() {
				obj.cboDisDesc.setValue(DiseaseID);
			}});
		}});
		obj.txtDisText.setValue(DiseaseText);	// ������ע
	}
	// ****************************** ������ refresh
	
	// ****************************** ������ food func
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
			if (FoodName=="") { errorStr = errorStr + "����дʳƷ����!"; }
			if (WhereToBuy=="") { errorStr = errorStr + "����д����ص�!"; }
			if (EatingPlaces=="") { errorStr = errorStr + "����д��ʳ����!"; }
			if (EatingDate=="" || EatingTime=="") { errorStr = errorStr + "����д��ʳʱ��!"; }
			if (EatingNum=="") { errorStr = errorStr + "����д��ʳ����!";}
			if (IsIncidence=="" || IsIncidenceDesc=="") { errorStr = errorStr + "��ѡ���������Ƿ񷢲�!"; }
			if (IsSampling=="" || IsSamplingDesc=="") { errorStr = errorStr + "��ѡ���Ƿ����!"; }
			if (errorStr!="") {
				ExtTool.alert("��ʾ", errorStr);
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
				ExtTool.alert("��ʾ", "��ѡ��һ����¼!");
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
	// ****************************** ������ food func
	
	// ****************************** ������ sample func
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
			if (SampleNo=="" && IsUpdateSampleNo==1) { errorStr = errorStr + "����д�������!"; }	// ����Զ�����
			if (SampleNumber=="") { errorStr = errorStr + "����д��������!"; }
			if (SampleDate=="") { errorStr = errorStr + "����д��������!"; }
			if (SampleTypeID=="") { errorStr = errorStr + "��ѡ����������!"; }
			if (SampleUnitID=="") { errorStr = errorStr + "��ѡ��λ!"; }
			if (errorStr!="") {
				ExtTool.alert("��ʾ", errorStr);
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
				ExtTool.alert("��ʾ", "��ѡ��һ����¼!");
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
	// ****************************** ������ sample func
	
	// ****************************** ������ report func	// 1���� 2���� 3�˻� 4�ݸ� 5ɾ�� 6��Ժ�ѱ�
	obj.btnSaveTmp_click = function() {	// �ݸ�
		obj.saveReportInfo(4, "^");
	}
	
	obj.btnSaveRep_click = function() {	// ����
		obj.saveReportInfo(1, "^");
	}
	
	obj.btnExecheck_click = function() {	// ���
		//obj.saveReportInfo(2, "^");
		obj.saveReportStatus(2, "^");
	}
	
	obj.btnCancheck_click = function() {	// ȡ�����
		obj.saveReportStatus(1, "^");
	}
	
	obj.btnReturn_click = function() {	// �˻�
		obj.saveReportStatus(3, "^");
	}
	
	obj.btnDelete_click = function() {	// ɾ��
		obj.saveReportStatus(5, "^");
	}
	
	obj.btnReported_click = function() {	// ��Ժ�ѱ�
		obj.saveReportInfo(6, "^");
	}
	
	obj.btnPrint_click = function() {	// ��ӡ
		ExportReportToExcel(obj.reportID);
	}
	
	obj.btnClose_click = function() {
		window.close();
	}
	// ****************************** ������ report func
	
	// ****************************** ������ save
	obj.saveReportStatus = function(statusCode, separate) {
		var statusID = "", checkUser = session['LOGON.USERID'];
		var objStatus = obj.objDicManage.GetByTypeCode("FBDREPORTSTATUS", statusCode, "");
		if (objStatus) { statusID = objStatus.RowID; }
		if (obj.reportID=="" || statusID=="") {
			ExtTool.alert("��ʾ", "����ʧ��!");
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
			ExtTool.alert("��ʾ", "�����ɹ�!");
			obj.refreshFormInfo(ret);
			window.returnValue="true"; //�����ɹ� ��ӷ���ֵ ˢ�²�ѯ����б�
		} else {
			ExtTool.alert("��ʾ", "����ʧ��!");
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
			ExtTool.alert("��ʾ", "������ѡ��һ����Ҫ֢״������!");
			return;
		}
		var retRep = obj.objReportManage.Update(inputStr, separate, sepobj);
		if (retRep>0) {
			var retSign = obj.saveSign(retRep, separate);
			var retFood = obj.saveFood(retRep, separate);
			var retSample = obj.saveSample(retRep, separate);
			if (retSign<0) { errorStr = errorStr + "������Ϣ����ʧ��!"; }
			if (retFood<0) { errorStr = errorStr + "��¶��Ϣ����ʧ��!"; }
			if (retSample<0) { errorStr = errorStr + "������Ϣ����ʧ��!"; }
			//obj.refreshFormInfo(retRep);
		} else {
			errorStr = errorStr + "������Ϣ����ʧ��!";
		}
		if (errorStr=="") {
			errorStr = "����ɹ�!";
			obj.refreshFormInfo(retRep);
		}
		ExtTool.alert("��ʾ", errorStr);
	}
	
	obj.saveSign = function(reportID, separate) {	// ������Ҫ����
		var signFlg = 0;
		var objSignManage = ExtTool.StaticServerObject("DHCMed.FBD.ReportSign");
		var signList = document.getElementsByName("chkList");
		for (var i=0; i<signList.length; i++) {
			var tmpSign = signList[i];
			if (tmpSign.checked) {	// ѡ��update
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
			} else if (!tmpSign.checked && tmpSign.value!="") {	// ȡ��ѡ��delete
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
			if (IsUpdateSampleNo==0 && SampleNo=="") {	// ��������Զ�����
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
		var OPNo = obj.txtOPNo.getValue();	// �����
		var IPNo = obj.txtIPNo.getValue();	// סԺ��
		var CardNo = obj.txtCardNo.getValue();	// ������
		var IsUpdateReportNo = obj.objConfigManage.GetValueByKeyHosp("FBD-IsUpdateReportNo", "")
		if (IsUpdateReportNo==0 && CardNo=="") {	// �������Զ�����
			CardNo = obj.objReportSrvManage.GetFBDNo("", "1", "");
		}
		var IsInHosp = "";	// �Ƿ�סԺ
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
		var PatName = obj.txtPatName.getValue();	// ����
		var Sex = obj.txtSex.getValue();	// �Ա�
		var Age = obj.txtAge.getValue();	// ����
		var Birthday = obj.dtBirthday.getRawValue();	// ��������
		var PersonalID = obj.txtPersonalID.getValue();	// ���֤��
		var Contactor = obj.txtContactor.getValue();	// �໤������
		var Telephone = obj.txtTelephone.getValue();	// ��ϵ��ʽ
		var IsUseAnti = "";	// �Ƿ�����
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
		
		var UseAntiDesc = obj.txtUseAntiDesc.getValue();	//����ǰʹ�ÿ���������
		var OccupationID = obj.cboOccupation.getValue();	// ����ְҵ
		var AreaID = obj.cboPatArea.getValue();	// ��������
		var Company = obj.txtCompany.getValue();	// ��λ
		var CurrAddress = obj.txtCurrAddress.getValue();	// ��סַ
		var CurrProvince = obj.cboCurrProvince.getRawValue();	// ʡ
		var CurrCity = obj.cboCurrCity.getRawValue();	// ��
		var CurrCounty = obj.cboCurrCounty.getRawValue();	// ��
		var CurrVillage = obj.cboCurrVillage.getRawValue();	// ��
		var CurrRoad = obj.txtCurrRoad.getValue();	// �ֵ�
		var DisCateID = obj.cboDisCate.getValue();	// ��������
		var DiseaseID = obj.cboDisDesc.getValue();	// ����ID
		var DiseaseText = obj.txtDisText.getValue();	// ������ע
		var SickDate = obj.dtSickDate.getRawValue();	// ����ʱ��
		var SickTime = obj.tmSickTime.getValue();
		var AdmitDate = obj.dtAdmitDate.getRawValue();	// ����ʱ��
		var AdmitTime = obj.tmAdmitTime.getValue();
		var DeathDate = obj.dtDeathDate.getRawValue();	// ����ʱ��
		var DeathTime = obj.tmDeathTime.getValue();
		var PreDiagnos = obj.txtPreDiagnos.getValue();	// �������
		var Anamnesis = obj.txtAnamnesis.getValue();	// ������ʷ
		var EpisodeID = "", PatientID = "", ReportLoc = "";
		var ReportUser = "", ReportDate = "", ReportTime = "";
		var CheckUser = "", CheckDate = "", CheckTime = "", Resume = "";
		if (obj.objCurrPaadm) { EpisodeID = obj.objCurrPaadm.AdmRowID; }
		if (obj.objCurrPatient) { PatientID = obj.objCurrPatient.Papmi; }
		if (obj.objCurrCtLoc) { ReportLoc = obj.objCurrCtLoc.Rowid }
		if (obj.objCurrUser) { ReportUser = obj.objCurrUser.Rowid }
		if (statusCode==1 || statusCode==2) {
			var errorStr = "";
			if (StatusID=="") { errorStr = errorStr + "����״̬����!"; }
			if (CardNo=="") { errorStr = errorStr + "����д�������!"; }
			//if (OPNo=="") { errorStr = errorStr + "����д�����!"; }
			if (IsInHosp=="") { errorStr = errorStr + "��ѡ���Ƿ�סԺ!"; }
			if (PatName=="") { errorStr = errorStr + "����д����!"; }
			if (Sex=="") { errorStr = errorStr + "����д�Ա�!"; }
			if (Age=="") { errorStr = errorStr + "����д����!"; }
			if (Birthday=="") { errorStr = errorStr + "����д��������!"; }
			if (Telephone=="") { errorStr = errorStr + "����д��ϵ��ʽ!"; }
			if (IsUseAnti=="") { errorStr = errorStr + "��ѡ�����ǰ�Ƿ�ʹ�ÿ�����!"; }
			if ((IsUseAnti=='1')&&(UseAntiDesc=="")) { errorStr = errorStr + "����д����ǰʹ�ÿ���������!"; }
			if (OccupationID=="") { errorStr = errorStr + "��ѡ����ְҵ!"; }
			if (AreaID=="") { errorStr = errorStr + "��ѡ��������!"; }
			if (CurrProvince=="") { errorStr = errorStr + "��ѡ��ʡ!"; }
			if (CurrCity=="") { errorStr = errorStr + "��ѡ����!"; }
			if (CurrCounty=="") { errorStr = errorStr + "��ѡ����!"; }
			if (CurrVillage=="") { errorStr = errorStr + "��ѡ����!"; }
			if (CurrRoad=="") { errorStr = errorStr + "����д�ֵ�!"; }
			if (DisCateID=="") { errorStr = errorStr + "��ѡ�񼲲�����!"; }
			if (DiseaseID=="") { errorStr = errorStr + "��ѡ�񼲲�����!"; }
			if (SickDate=="") { errorStr = errorStr + "����д��������!"; }
			if (SickTime=="") { errorStr = errorStr + "����д����ʱ��!"; }
			if (AdmitDate=="") { errorStr = errorStr + "����д��������!"; }
			if (AdmitTime=="") { errorStr = errorStr + "����д����ʱ��!"; }
			if (PreDiagnos=="") { errorStr = errorStr + "����д�������!"; }
			//fix bug 7382 2015-02-14 ���֤��ʽ��֤
			if (trim(PersonalID) != ""){
				if (!(/(^\d{15}$)|(^\d{17}([0-9]|X|x)$)/.test(PersonalID))) {
					errorStr += '<P>��������֤�ų��Ȳ��ԣ����ߺ��벻���Ϲ涨��15λ����ӦȫΪ���֣�18λ����ĩλ����Ϊ���ֻ�X��</P>';
				}
			}
			if (errorStr!="") {
				ExtTool.alert("��ʾ", errorStr);
				return "";
			}
		}
		var IsUpdatePatInfo = obj.objConfigManage.GetValueByKeyHosp("FBD-IsUpdatePatInfo", "");
		if (IsUpdatePatInfo==0) {	// ������Ϣ���ı䲻��
			PatName = "";
			Sex = "";
			Birthday = "";
		}
		var objPatStr = PatName;
		objPatStr = objPatStr + sepobj + Sex;
		objPatStr = objPatStr + sepobj + Birthday;
		objPatStr = objPatStr + sepobj + PersonalID;
		objPatStr = objPatStr + sepobj + "";	// RPNation;	// ������ʱ����Ҫ
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
	// ****************************** ������ save
}
// �����ַ������˵Ŀհ�
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
