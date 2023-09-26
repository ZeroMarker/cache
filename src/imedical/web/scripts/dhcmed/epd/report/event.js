function InitviewScreenEvent(obj) {
	// ��ȡ�������ݶ���
	var objDicManage = ExtTool.StaticServerObject("DHCMed.SS.Dictionary");			// �����ֵ����
	var objInfectionManage = ExtTool.StaticServerObject("DHCMed.EPD.Infection");	// ��Ⱦ���ֵ����
	var objPatientManage = ExtTool.StaticServerObject("DHCMed.Base.Patient");		// ���˻�����Ϣ����
	var objPaadmManage = ExtTool.StaticServerObject("DHCMed.Base.PatientAdm");		// ���˾�����Ϣ����
	var objRepManage = ExtTool.StaticServerObject("DHCMed.EPD.Epidemic");			// ��Ⱦ���������
	var objEpdManage = ExtTool.StaticServerObject("DHCMed.EPDService.EpidemicSrv");
	var objCtlocManage = ExtTool.StaticServerObject("DHCMed.Base.Ctloc");			// ���Ҷ���
	var objSSUserManage = ExtTool.StaticServerObject("DHCMed.Base.SSUser");			// �û�����
	var objConfigManage = ExtTool.StaticServerObject("DHCMed.SSService.ConfigSrv");	// �ҳ�������ѡ����ʾ��Ϣ
	var objCommonSrv = ExtTool.StaticServerObject("DHCMed.EPDService.CommonSrv");
	var objReportExport = ExtTool.StaticServerObject("DHCMed.EPDService.EpidemicReportExport");
	
	// ��ȡ��ǰ���ﲡ�����ݶ���
	obj.objCurrPatient = objPatientManage.GetObjById(PatientID);	// ��ǰ���˶���
	obj.objCurrPaadm = objPaadmManage.GetObjById(EpisodeID);		// ��ǰ���˾������
	obj.objCurrRepCtloc = objCtlocManage.GetObjById(session['LOGON.CTLOCID']);	 // ��ǰ�ϱ����Ҷ���
	obj.objCurrRepUser = objSSUserManage.GetObjById(session['LOGON.USERID']);	 // ��ǰ�ϱ��û�����
	obj.objCurrRepWard = objCtlocManage.GetObjByWardId(obj.objCurrPaadm.WardID); // ��ǰ�ϱ���������
	var SecretStr = ExtTool.RunServerMethod("DHCMed.SSIO.FromSecSrv","GetPatEncryptLevel",PatientID,"");

	// ��ȡ��ǰ�ϱ�����������ò���
	obj.EpdRepPatRelNotice = objConfigManage.GetValueByKeyHosp("EpdRepPatRelNotice", "");	//�ҳ������ı���ʾ
	obj.EpdRepPatCompanyNotice = objConfigManage.GetValueByKeyHosp("EpdRepPatCompanyNotice", "");	//������λ�ı���ʾ
	
	obj.EpdRepCardNotice = objConfigManage.GetValueByKeyHosp("EpdRepCardNotice", "");	//��Ч֤�����ı���ʾ
	obj.EpdRepCardNotice = "����д�໤����Ч֤���ţ���ѡ��֤�����͡��໤��֤����";
	obj.EpdRepPatRelRequireMaxAge = objConfigManage.GetValueByKeyHosp("EpdRepPatRelRequireMaxAge", "");	//����С��14��,������д�ҳ�����
	obj.EpdOccupationToRelName = objConfigManage.GetValueByKeyHosp("EpdOccupationToRelName", "");  //ְҵTo�ҳ�����    ְҵΪ���ж�ͯ��ɢ�Ӷ�ͯ,������д�ҳ�����
	obj.EpdOccupationToCompany = objConfigManage.GetValueByKeyHosp("EpdOccupationToCompany", "");  //ְҵTo������λ  ְҵΪѧ��������Сѧ��,������λ��дѧУ�꼶�༶

	obj.EpdDiseaseToSickKind = objConfigManage.GetValueByKeyHosp("EpdDiseaseToSickKind", "");  //���To��������  ���Ϊ�Ҹ�\����\Ѫ���没,��������ѡ������(���͸��ס����͸��ס�Ѫ���没��д)
	obj.EpdDiseaseToDegree = objConfigManage.GetValueByKeyHosp("EpdDiseaseToDegree", "");  //���To��Ϸ���  ���Ϊ����\�ܲ�\÷��\���̲�\HIV\�ν��Ϳ��\�ν�˽�����,��Ϸ���ѡ��ʵ����ȷ�ﲡ��
	obj.EpdDiseaseToResume = objConfigManage.GetValueByKeyHosp("EpdDiseaseToResume", "");  //���To��ע��Ϣ  ���Ϊ����\HIV,��עΪ����Ѹ�֪����Ϣ���ܣ��ܾ�����,���Ϊ�ν��,��עΪ��������ϵת�����
	obj.EpdDiseaseToCardNo = objConfigManage.GetValueByKeyHosp("EpdDiseaseToCardNo", "");  //���To���֤��  ���Ϊ����\HIV,���֤�ű���
	obj.EpdInitAddressByLocalHospital = objConfigManage.GetValueByKeyHosp("EpdInitAddressByLocalHospital", "");  //��Ⱦ������Ĭ�ϳ�ʼ�����ص���ҽԺ���ڵ�ʡ���С�������
	obj.EpdInitIntimateKey = objConfigManage.GetValueByKeyHosp("EpdInitIntimateKey", "");  //��Ⱦ���ϱ��������нӴ����
	
	if (ReportID != "") {
		// �Ѵ��ڵı���
		obj.objCurrReport = objRepManage.GetObjById(ReportID);	// ��ǰ��Ⱦ���������
		obj.objCurrReportStatus = objDicManage.GetByTypeCode("EPIDEMICREPORTSTATUS", obj.objCurrReport.MEPDStatus, "1"); // ��ǰ����״̬����
		obj.objCurrRepPlace = objDicManage.GetByTypeCode("REPPLACE", obj.objCurrReport.MEPDRepPlace, "1"); // ��ǰ�ϱ�λ�ö���
	} else {
		//add by zf 20150402 �½�����Ĭ�ϡ��ݸ塱״̬
		obj.objCurrReportStatus = objDicManage.GetByTypeCode("EPIDEMICREPORTSTATUS", "6", "1");
		
		// �½��ı��棬ָ��Ĭ�ϵ��ϱ�λ��
		switch (obj.objCurrPaadm.AdmType) {
			case "O" :
				obj.objCurrRepPlace = objDicManage.GetByTypeCode("REPPLACE", "O", "1"); // ����
				break;
			case "I" :
				obj.objCurrRepPlace = objDicManage.GetByTypeCode("REPPLACE", "I", "1"); // ����
				break;
			case "E" :
				obj.objCurrRepPlace = objDicManage.GetByTypeCode("REPPLACE", "E", "1"); // ����
				break;
			default :
				obj.objCurrRepPlace = objDicManage.GetByTypeCode("REPPLACE", "O", "1"); // Ĭ��Ϊ����
				break;
		}
	}
	
	/**
	 * �ڿͻ��˲���ǰ���Զ���ʼ��ִ��������¼�
	 * @param {} args
	 */
	obj.LoadEvent = function(args) {
		// ����ҽ��վ���ݵĲ�����ȡ���˵Ļ�����Ϣ�����뵱ǰ�����Ӧ�ı���
		obj.loadPatientInfoForReport();
		
		// ����ȫ����������¼�
		obj.relationToEvents();
		
		// �жϵ�ǰ�����Ƿ����
		// �������ڣ����½�
		// �����ڣ�����ݱ���ID���ض�Ӧ�ı�����Ϣ
		if (!obj.objCurrReport) {
			// ��ʼ����������͸�����Ϣ
			obj.initReportInfo();
			// ���ݱ���״̬��Ȩ�����ֱ����ʾ�˱����Ӧ�Ĺ��ܰ�ť
			obj.DisplayButtonStatus(LocFlag,"","N");
		} else {
			// ���ݱ���ID���ض�Ӧ�ı�����Ϣ
			obj.DisplayReportInfo(ReportID);
			// ���ݱ���״̬��Ȩ�����ֱ����ʾ�˱����Ӧ�Ĺ��ܰ�ť
			if (obj.objCurrReport){
				obj.DisplayButtonStatus(LocFlag,obj.objCurrReport.MEPDStatus,obj.objCurrReport.MEPDIsUpload);
			}			
		}
		
		// ����ҽ��վ���ݵĲ�����ȡ���˵Ļ�����Ϣ�����������Ϣģ��
		obj.loadPatientInfoForTemplate();
	};
	
	/**
	 * ���������� - ����ҽ��վ���ݵĲ�����ȡ���˵Ļ�����Ϣ�����������Ϣģ��
	 */
	obj.loadPatientInfoForTemplate = function() {
		// ���岡�˻�����Ϣģ���������
		if (obj.objCurrReport){
			obj.objCurrReportStatus = objDicManage.GetByTypeCode("EPIDEMICREPORTSTATUS", obj.objCurrReport.MEPDStatus, ""); // ����״̬
			obj.objCurrRepPlace = objDicManage.GetByTypeCode("REPPLACE", obj.objCurrReport.MEPDRepPlace, ""); // �ϱ�λ��
			obj.objCurrRepCtloc = objCtlocManage.GetObjById(obj.objCurrReport.MEPDLocDR);	    // �ϱ�����
			obj.objCurrRepUser = objSSUserManage.GetObjById(obj.objCurrReport.MEPDRepUsrDR);	// �ϱ��û�
			if (obj.objCurrReport.MEPDText3!='') {
				obj.objCurrRepWard = objCtlocManage.GetObjById(obj.objCurrReport.MEPDText3);	    // �ϱ�����
			}
		}
		//*************************************************
		/*
		//update by zf 20111112 ������������
		var tmpPatientAge="";
		if (obj.objCurrPatient){
			if (obj.objCurrPatient.Age > 0){
				tmpPatientAge = obj.objCurrPatient.Age + "��";
			}else if (obj.objCurrPatient.AgeMonth > 0){
				tmpPatientAge = obj.objCurrPatient.AgeMonth + "��";
			}else{
				tmpPatientAge = obj.objCurrPatient.AgeDay + "��";
			}
		}
		*/
		//update by pylian 2015-07-17 �����ɽӿ�����ȡ,������ϱ��ı����ʱ����仯������
		var tmpPatientAge = ExtTool.RunServerMethod("DHCMed.SSIO.FromHisSrv","GetPapmiAge",obj.objCurrPatient.Papmi,obj.objCurrPaadm.AdmRowID, obj.objCurrPaadm.AdmitDate,obj.objCurrPaadm.AdmitTime);
		// update by mxp 201605-06 ���ݾ�������ȡ��Ӧ�Ĳ�����
		var PatientMrNo = ExtTool.RunServerMethod("DHCWMR.IO.OutService","IGetMrNoByEpisodeID",obj.objCurrPaadm.AdmRowID,obj.objCurrPaadm.AdmType);
		//*************************************************
		var tplBaseInfoData = {
			PapmiNo : (obj.objCurrPatient ? obj.objCurrPatient.PapmiNo : ''),
			//InPatientMrNo : (obj.objCurrPatient ? obj.objCurrPatient.InPatientMrNo : ''),
			InPatientMrNo : PatientMrNo,
			PatientName : (obj.objCurrPatient ? obj.objCurrPatient.PatientName : ''),
			Sex : (obj.objCurrPatient ? obj.objCurrPatient.Sex : ''),
			Age : (obj.objCurrPatient ? tmpPatientAge : ''),  //update by zf 20111112 ������������
			Birthday : (obj.objCurrPatient ? obj.objCurrPatient.Birthday : ''),
			RepUser : (obj.objCurrRepUser ? obj.objCurrRepUser.Name : ''),
			RepLoc : (obj.objCurrRepCtloc ? obj.objCurrRepCtloc.Descs + (obj.objCurrRepCtloc.Telephone!='' ? "( " + obj.objCurrRepCtloc.Telephone + ")" : '') : ''),
			RepWard : (obj.objCurrRepWard ? obj.objCurrRepWard.Descs + (obj.objCurrRepWard.Telephone!='' ? "( " + obj.objCurrRepWard.Telephone + ")" : '') : ''),
			RepPlace : (obj.objCurrRepPlace ? obj.objCurrRepPlace.Description : ''),
			RepStatus : (obj.objCurrReportStatus ? obj.objCurrReportStatus.Description : ''),
			EncryptLevel : (SecretStr!="" ? SecretStr.split("^")[0] : ""),
			PatLevel : (SecretStr!="" ? SecretStr.split("^")[1] : "")
		};
		obj.tplBaseInfo.compile();
		obj.tplBaseInfo.overwrite(obj.PanelRow0.body, tplBaseInfoData);
	};
	
	/**
	 * ���������� - ����ҽ��վ���ݵĲ�����ȡ���˵Ļ�����Ϣ�����뵱ǰ�����Ӧ�ı���
	 */
	obj.loadPatientInfoForReport = function() {
		document.title = "��Ⱦ������[��ǰ���ߣ�" + obj.objCurrPatient.PatientName + "]";
		obj.lblRelationNotice.setText(obj.EpdRepPatRelNotice);
		obj.lblCompanyNotice.setText(obj.EpdRepPatCompanyNotice);
		
		obj.lblCardNotice.setText(obj.EpdRepCardNotice);  //��Ч֤�����ı���ʾ
		
		// ����ҽ��վ���˽�����Ϣ���Զ���ȡ���ϱ�ҳ��Ķ�Ӧ����
		obj.txtTel.setValue(obj.objCurrPatient.RelativeTelephone);		//��ϵ�绰
		
		// ******************************************************************* //
		// ������λ
		// Modified By PanLei 2013-03-24
		// �������HIS�����Ĺ�����λΪ��,��Ĭ������Ϊ���ޡ�
		if (trim(obj.objCurrPatient.WorkAddress)) {
			obj.txtCompany.setValue(obj.objCurrPatient.WorkAddress);
		} else {
			obj.txtCompany.setValue("��");
		}
		// ******************************************************************* //
		
		// add by PanLei 20120208
		// ���������жϣ��������С�ڵ���14����Ҫ������������14��������Ϊ��
		if (obj.objCurrPatient.Age <= obj.EpdRepPatRelRequireMaxAge) {
			obj.txtRelationName.setValue(obj.objCurrPatient.RelativeName);	//�ҳ�����
		} else {
			obj.txtRelationName.setValue("");	//�ҳ�����
		}
		
		obj.txtPatCardNo.setValue(obj.objCurrPatient.PersonalID);		//���֤
		obj.txtAddress.setValue(obj.objCurrPatient.Address);			//��סַ
		/* update by pylian 2016���°洫Ⱦ��ȥ��������ַ
		// ���ػ�����ַ
		obj.txtIDAddress.setValue(obj.objCurrPatient.Address);
		//add by zf 20120114 ���ӵ�ַ����
		if ((trim(obj.txtIDAddress.getValue()) == "")&&(trim(obj.txtAddress.getValue()) != "")) {
			obj.txtIDAddress.setValue(obj.txtAddress.getValue());     //���������ַΪ��,����סַ���Ƶ�������ַ
		}
		*/
	};
	
	/**
	 * ���ô����� - ����ȫ����������¼�
	 */
	obj.relationToEvents = function() {
		
		// ʡ�����紥���¼�
		// �������б�չ��ʱ����
		obj.cboProvince.on("expand", obj.cboProvince_expand, obj);
		//obj.cboCity.on("expand", obj.cboCity_expand, obj);
		//obj.cboCounty.on("expand", obj.cboCounty_expand, obj);
		//obj.cboVillage.on("expand", obj.cboVillage_expand, obj);
		
		// ��һ���б���Ŀ��ѡ��ʱ����
		obj.cboProvince.on("select", obj.cboProvince_select, obj);
		obj.cboCity.on("select", obj.cboCity_select, obj);
		obj.cboCounty.on("select", obj.cboCounty_select, obj);
		obj.cboVillage.on("select", obj.cboVillage_select, obj);

		// ��ϴ����¼�
		obj.cboDisease.on("collapse", obj.cboDisease_collapse, obj);	//����������б�����ʱ����
		obj.cboDisease.on("expand", obj.cboDisease_expand, obj);	    //����������б�����ʱ����

		// �����༭�����¼�
		obj.AppendixGridPanel.on("beforeedit", obj.AppendixGridPanel_beforeedit, obj);
		obj.AppendixGridPanel.on("afteredit", obj.AppendixGridPanel_afteredit, obj);

		// ��ť�����¼�
		obj.btnSaveTmp.on("click", obj.btnSaveTmp_click, obj);		//����ݸ�
		obj.btnSave.on("click", obj.btnSave_click, obj);			//�ϱ�����
		obj.btnCheck.on("click", obj.btnCheck_click, obj);			//���
		obj.btnUpdoCheck.on("click", obj.btnUpdoCheck_click, obj);	//ȡ�����
		obj.btnCorrect.on("click", obj.btnCorrect_click, obj);		//����
		obj.btnReturn.on("click", obj.btnReturn_click, obj);		//�˻�
		obj.btnDelete.on("click", obj.btnDelete_click, obj);		//ɾ��
		obj.btnUpdateCDC.on("click", obj.btnUpdateCDC_click, obj);	//�ϱ�CDC
		obj.btnPrint.on("click", obj.btnPrint_click, obj);			//��ӡ
		obj.btnClose.on("click", obj.btnClose_click, obj);			//�رմ���
		obj.btnOutHospReport.on("click", obj.btnOutHospReport_click, obj);		//��Ժ�ѱ�
	};
	
	/**
	 * �½����� - ��ʼ����������͸�����Ϣ
	 */
	obj.initReportInfo = function() {
		//modify by mxp 2016-12-09 ֤�����ͼ�֤������
		var PatCardInfo=objCommonSrv.GetActiveCardNo(PatientID);
		if (PatCardInfo!="") {
			var arrPatCard=PatCardInfo.split("^");
			obj.cboCardTypeStore.load({
				callback : function() {
					obj.cboCardType.setValue(arrPatCard[0]);
				}
			});				
			obj.txtPatCardNo.setValue(arrPatCard[1]);
		}
		
		// ����ְҵ
		obj.cboOccupationStore.load({});
		
		// ��������
		obj.cboRegionStore.load({});

		// Add By PanLei 2012-03-10
		// ��Ⱦ������Ĭ�ϳ�ʼ�����ص���ҽԺ���ڵ�ʡ���С�������
		// 13294-�㽭ʡ,14671-̨����,14781-������
		var arrayEpdInitAddressByLocalHospital = obj.EpdInitAddressByLocalHospital.split("`");
		var initProvince = arrayEpdInitAddressByLocalHospital[0];
		var initCity = arrayEpdInitAddressByLocalHospital[1];
		var initCounty = arrayEpdInitAddressByLocalHospital[2];
		obj.DisplayArea(initProvince, initCity, initCounty, "", "");
		
		//***************************************************
		//update by zf 2012-11-13
		//store.load�����ظ�ˢ������,�Ѵ�����±��Ƶ��ϱ����Ϳ�����
		
		// ������Ϸ���
		obj.cboDegreeStore.load({});
		
		// ���ط����̶�
		obj.cboSickKindStore.load({});
		
		// ���ؽӴ����
		// Add By PanLei 2012-11-28
		// ��ʼ���ر������棬Ĭ�ϴ�Ⱦ�����ߵ����нӴ����Ϊ�������֢״��
		obj.cboIntimateStore.load({
			callback : function() {
				if (obj.cboIntimateStore.getCount() > 0) {
					obj.cboIntimate.setValue(obj.EpdInitIntimateKey);
				}
			}
		});
		
		// �����������Ĭ��Ϊ����
		obj.dtDiagnoseDate.setValue(new Date());
		//***************************************************
		
		// �������
		obj.cboDiseaseStore.load({
			callback : function() {
				if (obj.cboDiseaseStore.getCount() > 0) {
					if (IFRowID) {
						obj.cboDisease.setValue(IFRowID);
						obj.cboDisease_collapse();
					}
				}
			}
		});		
	};
	
	/**
	 * ���ķ��������ݱ���ID���ض�Ӧ�ı�����Ϣ
	 * @param {} ReportID
	 */
	obj.DisplayReportInfo = function(reportId) {
		
		objRepManage = ExtTool.StaticServerObject("DHCMed.EPD.Epidemic");
		var objReport = objRepManage.GetObjById(reportId);
		if (objReport == "") {
			return;
		}
		//�������ڸ�ʽ�ֶο�ֵת��1840-12-31������
		if (objReport.MEPDSickDate=="1840-12-31") {objReport.MEPDSickDate="";}
		if (objReport.MEPDDiagDate=="1840-12-31") {objReport.MEPDDiagDate="";}
		if (objReport.MEPDDeathDate=="1840-12-31") {objReport.MEPDDeathDate="";}
		if (objReport.MEPDRepDate=="1840-12-31") {objReport.MEPDRepDate="";}
		if (objReport.MEPDCheckDate=="1840-12-31") {objReport.MEPDCheckDate="";}
		obj.objCurrReport = objReport;
		
		objDicManage = ExtTool.StaticServerObject("DHCMed.SS.Dictionary");
		obj.objCurrRepPlace = objDicManage.GetByTypeCode("REPPLACE", obj.objCurrReport.MEPDRepPlace, "1"); // �ϱ�λ��
		obj.objCurrReportStatus = objDicManage.GetByTypeCode("EPIDEMICREPORTSTATUS", obj.objCurrReport.MEPDStatus, "1"); // ����״̬
		if (obj.objCurrReport.MEPDRepUsrDR != "") {
			var objUserManage = ExtTool.StaticServerObject("DHCMed.Base.SSUser");
			var objUser = objUserManage.GetObjById(obj.objCurrReport.MEPDRepUsrDR);
			obj.objCurrReport.RepUser = objUser;
		}
		if (obj.objCurrReport.MEPDLocDR != "") {
			var objLocManage = ExtTool.StaticServerObject("DHCMed.Base.Ctloc");
			obj.objCurrReport.RepDep = objLocManage.GetObjById(obj.objCurrReport.MEPDLocDR);
		}
		if (obj.objCurrReport.MEPDCheckUsrDR != "") {
			var objUserManage = ExtTool.StaticServerObject("DHCMed.Base.SSUser");
			var objUser = objUserManage.GetObjById(obj.objCurrReport.MEPDCheckUsrDR);
			if (objUser){
				obj.objCurrReport.CheckUserName = objUser.Name;
			}else{
				obj.objCurrReport.CheckUserName = "";
			}
		}else{
			obj.objCurrReport.CheckUserName = "";
		}
		
		obj.txtTel.setValue(obj.objCurrReport.MEPDTelPhone);		    //��ϵ�绰
		obj.txtCompany.setValue(obj.objCurrReport.MEPDCompany);		    //������λ
		obj.txtRelationName.setValue(obj.objCurrReport.MEPDFamName);	//�ҳ�����
		obj.txtAddress.setValue(obj.objCurrReport.MEPDAddress);			//��סַ
		
		// ����ְҵ
		obj.cboOccupationStore.load({
			callback : function() {
						obj.cboOccupation.setValue(obj.objCurrReport.MEPDOccupation);
					}
		});
		
		//���Ǹ��¾ɰ�ı�����֤������Ĭ����ʾΪ�������֤��
		if((trim(obj.objCurrReport.MEPDText4)=="")&&(trim(obj.objCurrReport.MEPDText5)=="")){
			var PatCardInfo=objCommonSrv.GetActiveCardNo(PatientID);
			if (PatCardInfo!="") {
				var arrPatCard=PatCardInfo.split("^");
				obj.cboCardTypeStore.load({
					callback : function() {
						obj.cboCardType.setValue(arrPatCard[0]);
					}
				});				
				obj.txtPatCardNo.setValue(arrPatCard[1]);
			}
		}else{
			// ����֤������
			obj.cboCardTypeStore.load({
				callback : function() {
						obj.cboCardType.setValue(obj.objCurrReport.MEPDText4);
				}
			});
			obj.txtPatCardNo.setValue(obj.objCurrReport.MEPDText5);
		}
		
		
		// ��������
		obj.cboRegionStore.load({
			callback : function() {
						obj.cboRegion.setValue(obj.objCurrReport.MEPDArea);
					}
		});
		/* update by pylian 2016���°洫Ⱦ��ȥ��������ַ
		// ���ػ�����ַ
		obj.txtIDAddress.setValue(obj.objCurrReport.MEPDIDAddress);
		//add by zf 20120114 ���ӵ�ַ����
		if ((trim(obj.txtIDAddress.getValue()) == "")&&(trim(obj.txtAddress.getValue()) != "")) {
			obj.txtIDAddress.setValue(obj.txtAddress.getValue());     //���������ַΪ��,����סַ���Ƶ�������ַ
		}
		*/
		// ʡ������
		obj.DisplayArea(obj.objCurrReport.MEPDProvince,
		obj.objCurrReport.MEPDCity,
		obj.objCurrReport.MEPDCounty,
		obj.objCurrReport.MEPDVillage,
		obj.objCurrReport.MEPDRoad);
		
		// �������
		obj.cboDiseaseStore.load({
			callback : function() {
				var ind = this.find("RowID",obj.objCurrReport.MEPDICDDR);
				if (ind > -1) {
					obj.cboDisease.setValue(obj.objCurrReport.MEPDICDDR);
				}
			},
			scope : obj.cboDiseaseStore,
			add : false
		});
		
		// ������Ϸ���
		obj.cboDegreeStore.load({
			callback : function() {
						obj.cboDegree.setValue(obj.objCurrReport.MEPDDiagDegree);
					}
		});
		
		// ���ط����̶�
		obj.cboSickKindStore.load({
			callback : function() {
						obj.cboSickKind.setValue(obj.objCurrReport.MEPDSickKind);
					}
		});
		
		// ��������
		obj.dtSickDate.setValue(obj.objCurrReport.MEPDSickDate);
		
		// �������
		obj.dtDiagnoseDate.setValue(obj.objCurrReport.MEPDDiagDateTime);  //�޸��������Ϊ�������ʱ��
		
		// ��������
		obj.dtDeadDate.setValue(obj.objCurrReport.MEPDDeathDate);
		
		// ���ؽӴ����
		obj.cboIntimateStore.load({
			callback : function() {
						obj.cboIntimate.setValue(obj.objCurrReport.MEPDIntimateCode);
					}
		});
		
		// ���ر�ע
		obj.txtResumeText.setValue(obj.objCurrReport.MEPDDemo);
		
		if (obj.objCurrReport.MEPDIsUpload=="N"){
			obj.btnUpdateCDC.setText("�ϱ�CDC");
		}else{
			obj.btnUpdateCDC.setText("ȡ���ϱ�CDC");
		}
		
		// �����ϴ��ڶ�Ӧ����������ء������Ƴ����������˳�
		var objInfDic = objInfectionManage.GetObjById(obj.objCurrReport.MEPDICDDR);
		if (objInfDic.MIFAppendix == "") {
			obj.AppendixGridPanelStore.removeAll();
			return;
		} else {
			obj.AppendixGridPanelStore.load({
				params : {
					ClassName : 'DHCMed.EPDService.EpidemicSubSrv',
					QueryName : 'QryEpidemicSub',
					Arg1 : (obj.objCurrReport != null ? obj.objCurrReport.RowID : ""),
					Arg2 : objInfDic.MIFAppendix,
					Arg3 : EpisodeID,
					Arg4 : 'Y',
					ArgCnt : 4
				}
			});
		}
		
		window.returnValue = true;
	};
	
	obj.DisplayComps = function(){
		obj.cboOccupation.setDisabled(true);	    // ְҵ
		obj.cboRegion.setDisabled(true);		    // ����
		obj.cboCardType.setDisabled(true);		    // ֤������
		obj.txtPatCardNo.setDisabled(true);		    // ��Ч֤����
		obj.txtTel.setDisabled(true);			    // ��ϵ�绰
		obj.txtRelationName.setDisabled(true);	    // �ҳ�����
		obj.txtCompany.setDisabled(true);		    // ������λ
		//obj.txtIDAddress.setDisabled(true);		    // ������ַ
		obj.txtAddress.setDisabled(true);		    // ��סַ
		obj.cboProvince.setDisabled(true);		    // ʡ
		obj.cboCity.setDisabled(true);			    // ��
		obj.cboCounty.setDisabled(true);		    // ��
		obj.cboVillage.setDisabled(true);		    // ��
		obj.txtRoad.setDisabled(true);			    // ���ƺ�
		obj.cboDisease.setDisabled(true);		    // ���
		obj.cboDegree.setDisabled(true);		    // ��Ϸ���
		obj.cboIntimate.setDisabled(true);		    // �Ӵ����
		obj.dtSickDate.setDisabled(true);		    // ��������
		obj.dtDiagnoseDate.setDisabled(true);	    // �������
		obj.dtDeadDate.setDisabled(true);		    // ��������
		obj.cboSickKind.setDisabled(true);		    // �����̶�
		obj.txtResumeText.setDisabled(true);	    // ��ע
		obj.AppendixGridPanel.setDisabled(true);	// ����
	}
	
	/**
	 * ���ݱ���״̬��Ȩ�����ֱ����ʾ�˱����Ӧ�Ĺ��ܰ�ť
	 */
	 obj.DisplayButtonStatus = function(LocFlag,RepStatus,UploadCode) {
		obj.btnSaveTmp.setVisible(false);   // ����ݸ尴ť
		obj.btnSave.setVisible(false);		// �ϱ���ť
		obj.btnCheck.setVisible(false);	    // ��˰�ť
		obj.btnUpdoCheck.setVisible(false);	// ȡ����˰�ť
		obj.btnCorrect.setVisible(false);   // ������ť
		obj.btnReturn.setVisible(false);	// �˻ذ�ť
		obj.btnDelete.setVisible(false);    // ɾ����ť
		obj.btnUpdateCDC.setVisible(false); //�ϱ�CDC��ť
		obj.btnPrint.setVisible(false);	    // ��ӡ��ť
		if (PortalFlag != 1) {
			obj.btnClose.setVisible(true);	    // �رմ��ڰ�ť 
		} else {
			obj.btnClose.setVisible(false);	    // �رմ��ڰ�ť 
		}
		obj.btnOutHospReport.setVisible(false); // ��Ժ�ѱ���ť
		
		// ���ư�ťȨ�ޣ���� LocFlag=1 ����Ժ�а�
		if (LocFlag != '0') {
			switch (RepStatus) {
				case "" : // �ޱ���
					obj.btnSaveTmp.setVisible(true);    // ����ݸ尴ť
					obj.btnSaveTmp.setText("�ݸ�");
					obj.btnSave.setVisible(true);		// �ϱ���ť
					obj.btnSave.setText("����");
					obj.btnOutHospReport.setVisible(true);    // ��Ժ�ѱ���ť
					break;
				case "6" : // �ݸ�
					obj.btnSaveTmp.setVisible(true);    // ����ݸ尴ť
					obj.btnSaveTmp.setText("�ݸ�");
					obj.btnSave.setVisible(true);		// �ϱ���ť
					obj.btnSave.setText("����");
					obj.btnDelete.setVisible(true);		// ɾ����ť
					obj.btnOutHospReport.setVisible(true);    // ��Ժ�ѱ���ť
					break;
				case "1" : // ����
					obj.btnSave.setVisible(true);		// �ϱ���ť
					obj.btnSave.setText("�޸ı���");
					obj.btnCheck.setVisible(true);		// ��˰�ť
					obj.btnReturn.setVisible(true);		// �˻ذ�ť
					obj.btnDelete.setVisible(true);		// ɾ����ť
					obj.btnPrint.setVisible(true);	    // ��ӡ��ť
					break;
				case "2" : // ����
					obj.btnUpdoCheck.setVisible(true);	// ȡ����˰�ť
					obj.btnCorrect.setVisible(true);    // ������ť
					obj.btnPrint.setVisible(true);	    // ��ӡ��ť
					obj.btnUpdateCDC.setVisible(true);  // �ϱ�CDC��ť
					break;
				case "3" : // ����
					obj.btnCheck.setVisible(true);		// ��˰�ť
					obj.btnCorrect.setVisible(true);    // ������ť
					obj.btnPrint.setVisible(true);	    // ��ӡ��ť
					break;
				case "4" : // ����
					obj.btnPrint.setVisible(true);	    // ��ӡ��ť
					break;
				case "5" : // �˻�
					obj.btnSave.setVisible(true);		// �ϱ���ť
					obj.btnSave.setText("�޸ı���");
					obj.btnDelete.setVisible(true);		// ɾ����ť
					break;
				case "7" : // ɾ��
					break;
				case "8" : // ��Ժ�ѱ�
					obj.btnDelete.setVisible(true);		// ɾ����ť
					break;
			}
		} else {
			// ҽ��վ
			switch (RepStatus) {
				case "" : // �ޱ���
					obj.btnSaveTmp.setVisible(true);    // ����ݸ尴ť
					obj.btnSaveTmp.setText("�ݸ�");
					obj.btnSave.setVisible(true);		// �ϱ���ť
					obj.btnSave.setText("����");
					obj.btnOutHospReport.setVisible(true);    // ��Ժ�ѱ���ť
					break;
				case "6" : // �ݸ�
					obj.btnSaveTmp.setVisible(true);    // ����ݸ尴ť
					obj.btnSaveTmp.setText("�ݸ�");
					obj.btnSave.setVisible(true);		// �ϱ���ť
					obj.btnSave.setText("����");
					obj.btnDelete.setVisible(true);		// ɾ����ť
					obj.btnOutHospReport.setVisible(true);    // ��Ժ�ѱ���ť
					break;
				case "1" : // ����
					obj.btnSave.setVisible(true);		// �ϱ���ť
					obj.btnSave.setText("�޸ı���");
					obj.btnDelete.setVisible(true);		// ɾ����ť
					obj.btnPrint.setVisible(true);	    // ��ӡ��ť
					break;
				case "2" : // ����
					obj.btnCorrect.setVisible(true);    // ������ť
					break;
				case "3" : // ����
					obj.btnCorrect.setVisible(true);    // ������ť
					obj.btnPrint.setVisible(true);	    // ��ӡ��ť
					break;
				case "4" : // ����
					break;
				case "5" : // �˻�
					obj.btnSave.setVisible(true);		// �ϱ���ť
					obj.btnSave.setText("�޸ı���");
					obj.btnDelete.setVisible(true);		// ɾ����ť
					break;
				case "7" : // ɾ��
					break;
				case "8" : // ��Ժ�ѱ�
					obj.btnDelete.setVisible(true);		// ɾ����ť
					break;
			}
		}
		
		//����״̬��ʾ
		if (objDicManage.GetByTypeCode("EPIDEMICREPORTSTATUS",6,"1")==''){
			obj.btnSaveTmp.setVisible(false);   // ����ݸ尴ť
		}
		if (objDicManage.GetByTypeCode("EPIDEMICREPORTSTATUS",3,"1")==''){
			obj.btnCorrect.setVisible(false);   // ������ť
		}
		
		if ((RepStatus=='4')||(RepStatus=='7')||(RepStatus=='8')){
			obj.DisplayComps();
		}
		
		if (UploadCode=="Y"){
			obj.btnSaveTmp.setVisible(false);   // ����ݸ尴ť
			obj.btnSave.setVisible(false);		// �ϱ���ť
			obj.btnCheck.setVisible(false);	    // ��˰�ť
			obj.btnUpdoCheck.setVisible(false);	// ȡ����˰�ť
			obj.btnCorrect.setVisible(false);   // ������ť
			obj.btnReturn.setVisible(false);	// �˻ذ�ť
			obj.btnDelete.setVisible(false);    // ɾ����ť
		}
	};
	
	// ҽ������ϴ������¼�����
	obj.cboDisease_expand = function() {
		obj.cboDiseaseStore.load({});
	}
	obj.cboDisease_collapse = function() {
		var DiseaseID = obj.cboDisease.getValue();
		if (DiseaseID == "") {
			return;
		}
		var objInfDic = objInfectionManage.GetObjById(DiseaseID);
		var DiseaseDesc = objInfDic.MIFDisease
		if (DiseaseDesc != "") {
			// ���������ڡ����̲���HIV������ע��ϢΪ������Ѹ�֪����Ϣ���ܣ��ܾ����ӡ���
			// ���������ڡ��ν��������𡱣���ע��ϢΪ����������ϵת���������
			// add by PanLei 2012-02-10 ���δ���ñ�ע������ձ�ע
			var blnClearResumeFlag = false;
			var arrayEpdDiseaseToResume=obj.EpdDiseaseToResume.split("///");
			for (var i = 0; i < arrayEpdDiseaseToResume.length; i++) {
				var arrsubEpdDiseaseToResume=arrayEpdDiseaseToResume[i].split("~");
				var arrchildEpdDiseaseToResume=arrsubEpdDiseaseToResume[0].split("`");
				for (var j = 0; j < arrchildEpdDiseaseToResume.length; j++){
					if (DiseaseDesc == arrchildEpdDiseaseToResume[j]) {
						var tmpResume = arrsubEpdDiseaseToResume[1];
						if (tmpResume.indexOf('ALT:')<0) {
							obj.txtResumeText.setValue(tmpResume);
						} else {
							var objLISResultSrv = ExtTool.StaticServerObject("DHCMed.EPDService.LISResultSrv");
							var tmpLabItems = tmpResume;
							var arrLabItems = tmpLabItems.split('ALT:');
							if (arrLabItems.length > 1) tmpLabItems = arrLabItems[1];
							var tmpResult = objLISResultSrv.GetLabRstByAdm(EpisodeID,tmpLabItems);
							obj.txtResumeText.setValue(tmpResult);
						}
						blnClearResumeFlag = true;
					}
				}
			}
			
			// add by PanLei 2012-02-10 ���δ���ñ�ע������ձ�ע
			if(!blnClearResumeFlag) {
				obj.txtResumeText.setValue("");
			}
			
			// ���������ڡ��ҸΡ����Ρ�Ѫ���桱���򡰷����̶ȡ���ѡ�����ԣ����͸��ס����͸��ס�Ѫ���没��д����
			var arrayEpdDiseaseToSickKind=obj.EpdDiseaseToSickKind.split("///");
			obj.cboSickKindStore.load({
				callback : function(){
					obj.cboSickKind.setValue();
					obj.cboSickKind.setDisabled(false);
					for (var i = 0; i < arrayEpdDiseaseToSickKind.length; i++) {
						var arrsubEpdDiseaseToSickKind=arrayEpdDiseaseToSickKind[i].split("~");
						var arrchildEpdDiseaseToSickKind=arrsubEpdDiseaseToSickKind[0].split("`");
						for (var j = 0; j < arrchildEpdDiseaseToSickKind.length; j++){
							if (DiseaseDesc == arrchildEpdDiseaseToSickKind[j]) {
								obj.cboSickKind.setValue(arrsubEpdDiseaseToSickKind[1]);
								obj.cboSickKind.setDisabled(true);
							}
						}
					}
				}
			});
			
			// ���������ڡ����и�������ܲ�������÷����𡢰��̲���HIV���ν��Ϳ�����ν�˽�������  ����Ϸ������Ϊ��ʵ����ȷ�ﲡ����
			var arrayEpdDiseaseToDegree=obj.EpdDiseaseToDegree.split("///");
			obj.cboDegreeStore.load({
				callback : function(){
					obj.cboDegree.setValue();
					obj.cboDegree.setDisabled(false);
					for (var i = 0; i < arrayEpdDiseaseToDegree.length; i++) {
						var arrsubEpdDiseaseToDegree=arrayEpdDiseaseToDegree[i].split("~");
						var arrchildEpdDiseaseToDegree=arrsubEpdDiseaseToDegree[0].split("`");
						for (var j = 0; j < arrchildEpdDiseaseToDegree.length; j++){
							if (DiseaseDesc == arrchildEpdDiseaseToDegree[j]) {
								obj.cboDegree.setValue(arrsubEpdDiseaseToDegree[1]);
								obj.cboDegree.setDisabled(true);
							}
						}
					}
				}
			});
			
			// �����ϴ��ڶ�Ӧ����������ء������Ƴ����������˳�
			if (objInfDic.MIFAppendix == "") {
				obj.AppendixGridPanelStore.removeAll();
				return;
			}
			obj.AppendixGridPanelStore.load({
				params : {
					ClassName : 'DHCMed.EPDService.EpidemicSubSrv',
					QueryName : 'QryEpidemicSub',
					Arg1 : (obj.objCurrReport != null ? obj.objCurrReport.RowID : ""),
					Arg2 : objInfDic.MIFAppendix,
					Arg3 : EpisodeID,
					Arg4 : 'Y',
					ArgCnt : 4
				}
			});
		}
	};
	
	// �رմ���
	obj.btnClose_click = function() {
		window.close();
		ParrefWindowClose_Handler();
	};
	
	//aStatusCodeΪ����Ҫ���޸�Ϊ��״̬
	//aOperationDescΪ����˵��
	obj.SaveReport = function(aStatusCode,aOperationDesc){
		var strMain = obj.SaveToString(obj.objCurrReport, aStatusCode);	// �����ַ���
		var strSub = obj.SaveSubToString();		                        // �ӿ��ַ���
		var strReportID = objEpdManage.SaveEpidemicReport(strMain, strSub);
		if (strReportID > 0) {
			ReportID=strReportID;
			ExtTool.alert("��ʾ", aOperationDesc + "�ɹ���");
			
			var DiseaseID = obj.cboDisease.getValue();
			var objInfDic = objInfectionManage.GetObjById(DiseaseID);
			var DiseaseDesc = objInfDic.MIFDisease;
			if (DiseaseDesc.indexOf("�ν��")>-1) {
				ExtTool.alert("��ʾ","���Ʒν�˲��ˡ��ν�˲�������дת�ﵥ!");
			}
			obj.DisplayReportInfo(strReportID);		// ���ݱ���ID��ʾ��Ӧ�ı�����Ϣ
			obj.loadPatientInfoForTemplate();		// �������ɵı�����ز��˻�����Ϣģ��
			// ��ʾ��ǰ����״̬�µĲ�����ť״̬
			if (obj.objCurrReport){
				obj.DisplayButtonStatus(LocFlag,obj.objCurrReport.MEPDStatus,obj.objCurrReport.MEPDIsUpload);
			}
			window.returnValue = true;
			ParrefWindowRefresh_Handler();
		} else {
			ExtTool.alert("��ʾ", aOperationDesc + "ʧ�ܣ�����ֵ��" + strReportID);
		}
	}
	
	//aStatusCodeΪ����Ҫ���޸�Ϊ��״̬
	//aOperationDescΪ����˵��
	obj.SaveReportAA = function(aStatusCode,aOperationDesc,aTXT){
		var strSysDateTime=objCommonSrv.GetSysDateTime();
		var tmpList=strSysDateTime.split(" ");
		var strReportID=objRepManage.UpdateCheckEPD(obj.objCurrReport.RowID, aStatusCode,session['LOGON.USERID'], tmpList[0], tmpList[1], aTXT)
		if (strReportID > 0) {
			ReportID=strReportID;
			ExtTool.alert("��ʾ", aOperationDesc + "�ɹ���");
			obj.DisplayReportInfo(strReportID);		// ���ݱ���ID��ʾ��Ӧ�ı�����Ϣ
			obj.loadPatientInfoForTemplate();		// �������ɵı�����ز��˻�����Ϣģ��
			// ��ʾ��ǰ����״̬�µĲ�����ť״̬
			if (obj.objCurrReport){
				obj.DisplayButtonStatus(LocFlag,obj.objCurrReport.MEPDStatus,obj.objCurrReport.MEPDIsUpload);
			}
			window.returnValue = true;
			ParrefWindowRefresh_Handler();
		} else {
			ExtTool.alert("��ʾ", aOperationDesc + "ʧ�ܣ�����ֵ��" + strReportID);
		}
	}
	
	// ����ݸ�
	obj.btnSaveTmp_click = function() {
		var strDescription=obj.btnSaveTmp.getText();
		obj.SaveReport(6,strDescription);
		var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",obj.objCurrReport.RowID,"5",obj.objCurrPaadm.AdmRowID);
	}; 
	
	obj.btnOutHospReport_click = function() {
		var InputError = '';
		if (obj.cboDisease.getValue() == "") {
			InputError = InputError + "��ѡ��Ⱦ�����!<br>";
		}
		if (InputError != '') {
			ExtTool.alert("��ʾ", "��Ժ�ѱ����� " + InputError);
			return;
		}
		var strDescription=obj.btnOutHospReport.getText();
		obj.SaveReport(8,strDescription);
	}; 
	
	// �ϱ�����
	obj.btnSave_click = function() {
		//�������������Ժ��߼���У��
		if (!obj.ValidateContents()) {
			return;
		}
		var strDescription=obj.btnSave.getText();
		obj.SaveReport(1,strDescription);
		var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",obj.objCurrReport.RowID,"1",obj.objCurrPaadm.AdmRowID);
		
		var result=ExtTool.RunServerMethod("DHCMed.EPDService.CasesXSrv","IsCasesXByReportID",obj.objCurrReport.RowID);
		var Flag = result.split('^')[0];
		var CaseXID=result.split('^')[1];
		if (Flag==1) {
			var Hisret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000040",CaseXID,"4",obj.objCurrPaadm.AdmRowID);		
		}
	};

	// �༭������Ϣ֮ǰ����
	obj.AppendixGridPanel_beforeedit = function(objEvent) {
		if (obj.IsDisableControl) {
			objEvent.cancel = true;
			return;
		}
		var objColModal = objEvent.grid.getColumnModel();
		switch (objEvent.record.get("ItemType")) {
			case "1" :
				objColModal.setEditor(1, new Ext.form.TextField({}));
				break;
			case "2" :
				objColModal.setEditor(1, new Ext.form.NumberField({}));
				break;
			case "3" :
				objColModal.setEditor(1, new Ext.form.DateField({
									format : 'Y-m-d'
								}));
				break;
			case "4" :
				var objConn = new Ext.data.Connection({
							url : ExtToolSetting.RunQueryPageURL
						});
				objConn.on('requestcomplete',
						function(conn, response, Options) {
							if (response.responseText.indexOf('<b>CSP Error</b>') > -1)
								ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
						});
				var objProxy = new Ext.data.HttpProxy(objConn);
				objProxy.on('beforeload', function(objProxy, param) {
							param.ClassName = 'DHCMed.SSService.DictionarySrv';
							param.QueryName = 'QrySSDictionary';
							param.Arg1 = objEvent.record.get("ItemDic");
							param.ArgCnt = 1;
						});
				var objStore = new Ext.data.Store({
							proxy : objProxy,
							reader : new Ext.data.JsonReader({
										root : 'record',
										totalProperty : 'total',
										idProperty : 'Code'
									}, [{
												name : 'checked',
												mapping : 'checked'
											}, {
												name : 'Code',
												mapping : 'Code'
											}, {
												name : 'Description',
												mapping : 'Description'
											}])
						});
				var objCombo = new Ext.form.ComboBox({
							id : 'objCombo'
							// ,width : 120
							// ,minChars : 1
							,
							displayField : 'Description',
							store : objStore,
							triggerAction : 'all',
							valueField : 'Code'
						});
				objStore.load({
							callback : function() {
								objCombo.setValue(objEvent.record.get("HiddenValue"))
							}
						});
				objColModal.setEditor(1, objCombo);
				break;
			case "5" :
				objColModal.setEditor(1, new Ext.form.Checkbox({
							checked : (objEvent.record.get("HiddenValue") == "Y")
						}));
				break;
			case "6" :
				var objConn = new Ext.data.Connection({
							url : ExtToolSetting.RunQueryPageURL
						});
				objConn.on('requestcomplete',
						function(conn, response, Options) {
							if (response.responseText.indexOf('<b>CSP Error</b>') > -1)
								ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
						});
				var objProxy = new Ext.data.HttpProxy(objConn);
				objProxy.on('beforeload', function(objProxy, param) {
							param.ClassName = 'DHCMed.SSService.DictionarySrv';
							param.QueryName = 'QrySSDictionary';
							param.Arg1 = objEvent.record.get("ItemDic");
							param.ArgCnt = 1;
						});
				var objStore = new Ext.data.Store({
							proxy : objProxy,
							reader : new Ext.data.JsonReader({
										root : 'record',
										totalProperty : 'total',
										idProperty : 'Code'
									}, [{
												name : 'checked',
												mapping : 'checked'
											}, {
												name : 'Code',
												mapping : 'Code'
											}, {
												name : 'Description',
												mapping : 'Description'
											}])
						});
				var objCombo =new Ext.ux.form.LovCombo({
							id : 'objCombo',
							name : 'objCombo',
							displayField : 'Description',
							store : objStore,
							valueField : 'Description',
							triggerAction : 'all',
							separator:',',
							hideOnSelect : false,
							//maxHeight : 300,
							editable:false
						});
				objStore.load({
							callback : function() {
								objCombo.setValue(objEvent.record.get("HiddenValue"))
							}
						});
				objColModal.setEditor(1, objCombo);
				break;
		}
	};
	
	// �༭������Ϣ֮�󴥷�
	obj.AppendixGridPanel_afteredit = function(objEvent) {
		var objEditor = objEvent.grid.getColumnModel().getCellEditor(1, objEvent.row).field;
		switch (objEvent.record.get("ItemType")) {
			case "3" :
				objEvent.record.set("HiddenValue", objEvent.value.format("Y-m-d"));
				objEvent.record.set("ItemValue", objEvent.value.format("Y-m-d"));
				break;
			case "4" :
				objEvent.record.set("HiddenValue", objEvent.value);
				var objStore = objEditor.getStore();
				var intRecIndex = objStore.findExact("Code", objEvent.value);
				if (intRecIndex != -1) {
					var objRec = objStore.getAt(intRecIndex);
					objEvent.record.set("ItemValue", objRec.get("Description"));
				}
				break;
			case "5" :
				objEvent.record.set("HiddenValue", (objEvent.value ? "Y" : "N"));
				objEvent.record.set("ItemValue", (objEvent.value ? "��" : "��"));
				break;
			default :
				objEvent.record.set("HiddenValue", objEvent.value);
				break;
		}
		objEvent.record.commit();
	};
    /* update by pylian 2016���°洫Ⱦ��ȥ��������ַ
	obj.txtIDAddress_focus = function() {
		var objFrm = new InitAreaPanel(obj.txtIDAddress);
		objFrm.win.show();
	};
	*/
	// ����У�麯��
	obj.ValidateContents = function() {
		var InputError = "";
		if (obj.cboOccupation.getValue() == "") {
			InputError = InputError + "��ѡ����Ⱥ����!<br>";
		}
		if (obj.cboRegion.getValue() == "") {
			InputError = InputError + "��ѡ������!<br>";
		}
		
		if (trim(obj.txtTel.getValue()) == "") {
			InputError = InputError + "����д��ϵ�绰!<br>";
		}
		if ((obj.txtRelationName.getValue() == "") && (obj.objCurrPatient.Age <= new Number(trim(obj.EpdRepPatRelRequireMaxAge)))) {
			InputError = InputError + "����С�ڵ���" + new Number(trim(obj.EpdRepPatRelRequireMaxAge)) + "��Ļ��߱�����д�ҳ�����!<br>";
		}
		/*
		//��׼��,25�����ϻ��߱�����д���֤��
		if ((obj.txtPatCardNo.getValue() == "")&&(obj.objCurrPatient.Age > 25)) {
			InputError = InputError + "����д���֤��!<br>";
		}*/
	
		
		//ְҵΪ���ж�ͯ,ɢ�Ӷ�ͯ,������д�ҳ�����
		var arrayEpdOccupationToRelName = obj.EpdOccupationToRelName.split("`");
		if (trim(obj.txtRelationName.getValue()) == "") {
			for (var i = 0; i < arrayEpdOccupationToRelName.length; i++) {
				if (obj.cboOccupation.getRawValue() == arrayEpdOccupationToRelName[i]) {
					InputError = InputError + "������Ⱥ�����ǣ�" + obj.cboOccupation.getRawValue() + "������д�ҳ�����!<br>";
				}
			}
		}

		// Add By LiKai 2013-01-10
		// ְҵΪ���ж�ͯ,ѧ��(����Сѧ��),������λ�������ޣ�������дѧУ(�׶�԰)���꼶���༶ 
		var arrayEpdOccupationToCompany = obj.EpdOccupationToCompany.split("`");
		if (trim(obj.txtCompany.getValue()) == "��") {
			for (var i = 0; i < arrayEpdOccupationToCompany.length; i++) {
				if (obj.cboOccupation.getRawValue() == arrayEpdOccupationToCompany[i]) {
					InputError = InputError + "������Ⱥ�����ǣ�" + obj.cboOccupation.getRawValue() + "������дѧУ(�׶�԰)���꼶���༶!<br>";
				}
			}
		}
		
		// ******************************************************** //
		// Modified By PanLei 2013-03-24
		// �ж����������λΪ�ջ���Ϊ�Ƿ��ַ���,�������ϱ�
		if ((trim(obj.txtCompany.getValue()) == "") || (trim(obj.txtCompany.getValue()) == "\\") || (trim(obj.txtCompany.getValue()) == "\/")) {
			InputError = InputError + "���߹�����λ(ѧУ)������д������λ��û�й�����λ����ޡ���ѧ������дѧУ���꼶���༶!<br>";
		}
		// ******************************************************** //
		
		if (trim(obj.txtAddress.getValue()) == "") {
			InputError = InputError + "����д��סַ!<br>";
		}
		/*
		if (obj.txtIDAddress.getValue() == "") {
			InputError = InputError + "����д������ַ!<br>";
		}
		*/
		
		
		if (obj.cboDisease.getValue() == "") {
			InputError = InputError + "��ѡ��Ⱦ�����!<br>";
		}
		
		var objInfDic = objInfectionManage.GetObjById(obj.cboDisease.getValue());
		
		var PatRegion = obj.cboRegion.getRawValue();
		if ((PatRegion.indexOf('�۰�̨') > -1)||(PatRegion.indexOf('�⼮') > -1)) {
			//����Ҫ��д���֤
		} else {
			// �ϱ�ʱ���Ȳ���д��סַ���� Ŀǰ��ǿ�п���,�ɴ�Ⱦ�Ʋ�¼
			//if (LocFlag > 0) {
				if ((obj.cboProvince.getValue() == "")
						|| (obj.cboCity.getValue() == "")
						|| (obj.cboCounty.getValue() == "")
						|| (obj.cboVillage.getValue() == "")
						|| (trim(obj.txtRoad.getValue()) == "")) {
					InputError = InputError + "����дʡ���С��ء��硢���ƺ�!<br>";
				}
			//}
			
			//if (LocFlag > 0) {
			    //��Ч֤���ű�������ﲻ��Ҫ��
				/*
				var PatCardNo = obj.txtPatCardNo.getValue();
				var DiseaseDesc = obj.cboDisease.getRawValue();
				
				if (obj.EpdDiseaseToCardNo != ''){
					var arrayEpdDiseaseToCardNo=obj.EpdDiseaseToCardNo.split("`");
					for (var i = 0; i < arrayEpdDiseaseToCardNo.length; i++){
						if (DiseaseDesc == arrayEpdDiseaseToCardNo[i]){
							if (trim(PatCardNo) == "") {
								InputError = InputError + "����д���֤��!<br>";
								break;
							}
						}
					}
				} else {
					if (trim(PatCardNo) == "") {
						InputError = InputError + "����д���֤��!<br>";
					}
				}			
			//}
			// ��֤���֤���Ƿ�Ϸ�(ͨ��������ʽ)
			var CardType=obj.cboCardType.getRawValue();
			if ((CardType.indexOf('���֤')>-1)&&(trim(PatCardNo) != "")){
				if (!(/(^\d{15}$)|(^\d{17}([0-9]|X|x)$)/.test(PatCardNo))) {
					InputError += '��������֤�ų��Ȳ��ԣ����ߺ��벻���Ϲ涨��15λ����ӦȫΪ���֣�18λ����ĩλ����Ϊ���ֻ�X(x)��';
				}
			}	*/
			
		}
        if (obj.cboCardType.getValue() == "") {
			InputError = InputError + "��ѡ��֤������!<br>";
		}
		if (obj.txtPatCardNo.getValue() == "") {
			InputError = InputError + "����д��Ч֤����!<br>";
		}
        // ��֤���֤���Ƿ�Ϸ�(ͨ��������ʽ)
        var PatCardNo = obj.txtPatCardNo.getValue();
		var CardType=obj.cboCardType.getRawValue();
		if ((CardType.indexOf('���֤')>-1)&&(trim(PatCardNo) != "")){
			if (!(/(^\d{15}$)|(^\d{17}([0-9]|X|x)$)/.test(PatCardNo))) {
				InputError += '��������֤�ų��Ȳ��ԣ����ߺ��벻���Ϲ涨��15λ����ӦȫΪ���֣�18λ����ĩλ����Ϊ���ֻ�X(x)��';
			}
		}

		if (obj.cboDegree.getValue() == "") {
			InputError = InputError + "��ѡ����Ϸ���!<br>";
		}
		
		if (obj.dtSickDate.getValue() == "") {
			InputError = InputError + "��ѡ�񷢲�����!<br>";
		}
		
		if (obj.dtDiagnoseDate.getValue() == "") {
			InputError = InputError + "��ѡ���������!<br>";
		}
		/* update by zf 20111014  �����̶ȡ��뻼�����нӴ������ʱ����Ϊ�Ǳ�����Ŀ
		if (obj.cboSickKind.getValue() == "") {
			InputError = InputError + "��ѡ�񷢲��̶�!<br>";
		}
		if (obj.cboIntimate.getValue() == "") {
			InputError = InputError + "��ѡ���뻼�����нӴ����!<br>";
		}
		*/
		
		// add by PanLei 20120208
		// �����������ҽԺ����ķ������ڲ��ܴ���������ڻ�ǰ����
		/*var dtSickDateStr = obj.dtSickDate.getRawValue();	//��������
		var dtDiagnoseDateStr = obj.dtDiagnoseDate.getRawValue();	//�������
		var dtDeadDateStr = obj.dtDeadDate.getRawValue();//��������
		var sickDate = new Date(Date.parse(dtSickDateStr.replace(/-/g,"/")));
		var diagnoseDate = new Date(Date.parse(dtDiagnoseDateStr.replace(/-/g,"/")));
		var DeadDate = new Date(Date.parse(dtDeadDateStr.replace(/-/g,"/")));
		var thisNowDate = new Date();
		if (sickDate > diagnoseDate) {
			alert("��Ǹ���������ڲ��ܴ����������!");
			return false;
		}
		if (sickDate > thisNowDate) {
			alert("��Ǹ���������ڲ��ܴ��ڵ�ǰ����!");
			return false;
		}
		if (DeadDate > thisNowDate) {
			alert("��Ǹ���������ڲ��ܴ��ڵ�ǰ����!");
			return false;
		}
		if (sickDate > DeadDate) {
			alert("��Ǹ���������ڲ��ܴ�����������!");
			return false;
		}
		//Modified By LiYang 2014-08-08 FixBug:1401 ��Ⱦ�������ѯ-˫��������ˡ��ı��棬����������ڡ�����Ϊ������ĳ��ʱ�䣬������˳ɹ�
		if (diagnoseDate > thisNowDate) {
			alert("��Ǹ��������ڲ��ܴ��ڵ�ǰ����!");
			return false;
		}*/
		
		if (obj.dtSickDate.getValue() != "") {
			if (Common_ComputeDays("dtSickDate")<0) {
				InputError = InputError + "�������ڲ��ܴ��ڵ�ǰ����!<br>";				
			}
			if ((obj.dtDiagnoseDate.getValue() != "")&&(Common_ComputeDays("dtSickDate","dtDiagnoseDate")<0)) {
				InputError = InputError + "�������ڲ��ܴ����������!<br>";
			}
		}
		
		if ((obj.dtDiagnoseDate.getValue() != "")&&(Common_ComputeDays("dtDiagnoseDate")<0)) {
			InputError = InputError + "������ڲ��ܴ��ڵ�ǰ����!<br>";
		}
		
		if (obj.dtDeadDate.getValue() != "") {
			if (Common_ComputeDays("dtDeadDate")<0) {
				InputError = InputError + "�������ڲ��ܴ��ڵ�ǰ����!<br>";
			}
			if ((obj.dtSickDate.getValue() != "")&&(Common_ComputeDays("dtSickDate","dtDeadDate")<0)) {
				InputError = InputError + "�������ڲ��ܴ�����������!<br>";
			}
		}
		
		
		// add by zf ��Ⱦ���������ӱ������ж�
		var objRec = null;
		var appInputError = "";
		for (var iAppItem = 0; iAppItem < obj.AppendixGridPanelStore.getCount(); iAppItem++) {
			objRec = obj.AppendixGridPanelStore.getAt(iAppItem);
			if (objRec.get("IsNecess")=="��") {
				if ((trim(objRec.get("HiddenValue"))=="")||(trim(objRec.get("ItemValue"))=="")) {
					appInputError = appInputError + objRec.get("ItemCaption") + " δ��д;"
				}
			}
		}
		if (appInputError!='') {
			InputError = InputError + " ����:" + appInputError;
		}
		
		if (trim(InputError)) {
			ExtTool.alert("��ʾ", InputError);
			return false;
		}
		
		return true;
	};

	// ��ȡ��Ⱦ���ϱ��������ַ���
	obj.SaveToString = function(objReport, RepStatus) {
		var strDelimiter = String.fromCharCode(1);
		var strTmp = "";
		/* update by pylian 2016���°洫Ⱦ��ȥ��������ַ
		//add by zf 20120114 ���ӵ�ַ����
		if ((trim(obj.txtIDAddress.getValue()) == "") && (trim(obj.txtAddress.getValue()) != "")) {
			obj.txtIDAddress.setValue(obj.txtAddress.getValue());     //���������ַΪ��,����סַ���Ƶ�������ַ
		}*/
		
		strTmp += (objReport != null ? objReport.RowID : "") + strDelimiter;
		strTmp += (objReport != null ? objReport.MEPDPapmiDR : PatientID) + strDelimiter;  // PatientID
		strTmp += obj.cboRegion.getValue() + strDelimiter;
		strTmp += obj.cboOccupation.getValue() + strDelimiter;
		strTmp += obj.txtRelationName.getValue() + strDelimiter;
		strTmp += obj.cboDisease.getValue() + strDelimiter;
		strTmp += obj.cboIntimate.getValue() + strDelimiter;
		var objInfDic = objInfectionManage.GetObjById(obj.cboDisease.getValue());
		strTmp += objInfDic.MIFKind + strDelimiter; // DiagnoseType
		strTmp += obj.dtSickDate.getRawValue() + strDelimiter;
		strTmp += obj.cboDegree.getValue() + strDelimiter;
		strTmp += obj.dtDiagnoseDate.getRawValue() + strDelimiter;
		strTmp += obj.cboSickKind.getValue() + strDelimiter;
		strTmp += obj.dtDeadDate.getRawValue() + strDelimiter;
		strTmp += (objReport != null ? objReport.MEPDLocDR : session['LOGON.CTLOCID']) + strDelimiter;    //�������
		strTmp += obj.objCurrRepPlace.Code + strDelimiter;
		strTmp += RepStatus + strDelimiter;
		strTmp += (objReport != null ? objReport.MEPDRepUsrDR : session['LOGON.USERID']) + strDelimiter;  //RepUser
		strTmp += (objReport != null ? objReport.MEPDRepDate : "") + strDelimiter;       // RepDate
		strTmp += (objReport != null ? objReport.MEPDRepTime : "") + strDelimiter;       // RepTime
		strTmp += (objReport != null ? objReport.MEPDCheckUsrDR : "") + strDelimiter;    //CheckUser
		strTmp += (objReport != null ? objReport.MEPDCheckDate : "") + strDelimiter;     // CheckDate
		strTmp += (objReport != null ? objReport.MEPDCheckTime : "") + strDelimiter;     // CheckTime
		strTmp += obj.txtResumeText.getValue() + strDelimiter;
		strTmp += (objReport != null ? objReport.MEPDDelReason : "") + strDelimiter;     // Del reason
		strTmp += (objReport != null ? objReport.MEPDMepdDR : "") + strDelimiter;        // MEPD_Mepd_DR ��������¼
		strTmp += obj.txtTel.getValue() + strDelimiter;
		strTmp += obj.txtAddress.getValue() + strDelimiter;
		strTmp += obj.txtCompany.getValue() + strDelimiter;
		//strTmp += obj.txtIDAddress.getValue() + strDelimiter;
		strTmp += '' + strDelimiter;
		strTmp += (objReport != null ? objReport.MEPDText1 : EpisodeID) + strDelimiter;  // �����
		strTmp += (objReport != null ? objReport.MEPDText2 : "") + strDelimiter;         // Text2,������
		strTmp += (objReport != null ? objReport.MEPDIsUpload : "N") + strDelimiter;     // �Ƿ��ϴ�CDC
		strTmp += obj.cboProvince.getValue() + strDelimiter; // ʡ
		strTmp += obj.cboCity.getValue() + strDelimiter;     // ��
		strTmp += obj.cboCounty.getValue() + strDelimiter;   // ��
		strTmp += obj.cboVillage.getValue() + strDelimiter;  // ��
		strTmp += obj.txtRoad.getValue() + strDelimiter;     // ���ƺ�
		strTmp += (objReport != null ? objReport.MEPDDiagDateTime : "") + strDelimiter;  // �������ʱ��
		strTmp += (objReport != null ? objReport.MEPDText3 : "") + strDelimiter;    // Text3,���没��
		//strTmp += (objReport != null ? objReport.MEPDText4 : "") + strDelimiter;    // Text4
		strTmp += obj.cboCardType.getValue() + strDelimiter;                // Text4
		 
		strTmp += obj.txtPatCardNo.getValue() + strDelimiter;        // Text5
		strTmp += (objReport != null ? objReport.MEPDText6 : "") + strDelimiter;    // Text6
		
		//*******************************************************//
		// Add By PanLei 2012-09-23
		// ����Ⱦ����ʱ��������д�����֤����Ĳ��ˣ�Ҫ���ϱ�ʱ�����֤Ϊ׼����д�����֤�š���������
		var PatCardNo = trim(obj.txtPatCardNo.getValue());
		var CardType=obj.cboCardType.getRawValue();
		if ((PatCardNo)&&(CardType.indexOf('���֤')>-1)){
			// ��д���֤��
			//var PapmiIDReturn = objCommonSrv.UpdatePapmiID(PatientID, PatCardNo);
			/* update by zf 20131029
			var strPatDOB = "";
			var tmpYear,tmpMonth,tmpDay;
			
			// ������֤����15λ,���磺350424870506202
			if (PatCardNo.length == 15) {
				tmpYear = PatCardNo.substr(6,2);
				if (tmpYear != "19") {
					tmpMonth = PatCardNo.substr(8,2);
					tmpDay = PatCardNo.substr(10,2);
					strPatDOB = "19" + tmpYear + "-" + tmpMonth + "-" + tmpDay;
				}
			}
			
			// ������֤����18λ,���磺420536198109216301
			if (PatCardNo.length == 18) {
				tmpYear = PatCardNo.substr(6,4);
				tmpMonth = PatCardNo.substr(10,2);
				tmpDay = PatCardNo.substr(12,2);
				strPatDOB = tmpYear + "-" + tmpMonth + "-" + tmpDay;
			}
			
			// ���³������ڵ����˻�����Ϣ
			if (strPatDOB) {
				var DOBReturn = objCommonSrv.UpdatePapmiDOB(PatientID, strPatDOB);
			}
			*/
		}
		//*******************************************************//
		
		return strTmp;
	};

	// ��ȡ��Ⱦ���ϱ����ӿ��ַ���
	obj.SaveSubToString = function() {
		var strDelimiter = String.fromCharCode(1);
		var strTmp = "";
		var strRow = "";
		var objRec = null;
		for (var i = 0; i < obj.AppendixGridPanelStore.getCount(); i++) {
			strRow = "";
			objRec = obj.AppendixGridPanelStore.getAt(i);
			strRow += strDelimiter; // Parref
			strRow += strDelimiter; // Rowid
			strRow += strDelimiter; // childsub
			strRow += objRec.get("HiddenValue") + strDelimiter; // value
			strRow += objRec.get("AppendixItemID") + strDelimiter; // AppendixItemID
			if (strTmp != "") {
				strTmp += String.fromCharCode(2);
			}
			strTmp += strRow;
		}
		return strTmp;
	};

	// ��ӡ
	obj.btnPrint_click = function() {
		if (!obj.objCurrReport) {
			ExtTool.alert("����", "���ȱ��洫Ⱦ�����棡", Ext.MessageBox.ERROR, Ext.MessageBox.OK);
			return;
		} else {
			var objCurrInfDic = objInfectionManage.GetObjById(obj.objCurrReport.MEPDICDDR);
			obj.objCurrReport.AppendixID = objCurrInfDic.MIFAppendix;
			//update by zf 20111014 ����AFP��ӡ����
			var objDic = objDicManage.GetByTypeCode("EPDEMICTYPE",objCurrInfDic.MIFKind, "");
			objCurrInfDic.MIFKindDesc = objDic.Description
			obj.objCurrReport.ICDObj = objCurrInfDic;
			//update by zf 20111014 �޸Ĵ�ӡ��ַ
			obj.objCurrReport.MEPDAddress = objReportExport.GetPrintAddress(obj.objCurrReport.RowID);
		}
		var reportStatus = obj.objCurrReport.MEPDStatus;
		if (reportStatus > 4) {
			ExtTool.alert("��ܰ��ʾ", "ֻ�ܴ�ӡ�����󡱡������󡰡�������������������״̬�Ĵ�Ⱦ������!", Ext.MessageBox.ERROR, Ext.MessageBox.OK);
			return;
		}
		
		if ((typeof(IsSecret)!="undefined")&&(IsSecret==1)) {//����ҽԺ��ӡʱҪ��¼����־��
			var SecretStr=ExtTool.RunServerMethod("DHCMed.SSIO.FromSecSrv","GetSecInfoByEpisodeID",EpisodeID);  //ȡ�ܼ���Ϣ
			var SecretCode=SecretStr.split('^')[2];
			var ModelName="DHCMedEpdReport";
			var Condition="{ReportID:" +obj.objCurrReport.RowID+"}";
			var Content="{EpisodeID:"+ EpisodeID+",ReportID:"+ obj.objCurrReport.RowID+",ReportStatus:"+ obj.objCurrReport.MEPDStatus+"}";

			var ret= ExtTool.RunServerMethod("DHCMed.SSIO.FromSecSrv","EventLog",ModelName,Condition,Content,SecretCode);
		}
		EpidemicExport.Init(obj);

		//���Ӵ�ӡ����ǩ������
		obj.objCurrReport.RepUser.SignID = "";
		var EpdPrintCASign = objConfigManage.GetValueByKeyHosp("EpdPrintCASign", "");
		if (EpdPrintCASign=='1'){
			var ret = EpidemicExport.GetDocSignGif(obj.objCurrReport.RepUser.Rowid);		//��ȡ����ǩ��ͼƬ
			if (ret) {
				obj.objCurrReport.RepUser.SignID = obj.objCurrReport.RepUser.Rowid;
			}else {
				ExtTool.alert("��ʾ", "��ȡ����ǩ��ʧ��!");
			}
		}
		EpidemicExport.ExportEpidemicToWord(obj.objCurrReport)
	};
	
	//ȡ�����
	obj.btnUpdoCheck_click = function() {
		ExtTool.confirm("ȡ�����", "��ȷ��Ҫȡ�������ݴ�Ⱦ������ô��", function(btn) {
			if (btn == "yes") {
				var strDescription=obj.btnUpdoCheck.getText();
				obj.SaveReportAA(1,strDescription,"");
				var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",obj.objCurrReport.RowID,"1",obj.objCurrPaadm.AdmRowID);
			}
		});
	};
	
	// ���
	obj.btnCheck_click = function() {
		ExtTool.confirm("���", "��ȷ��Ҫ�����ݴ�Ⱦ������ô��", function(btn) {
			if (btn == "yes") {
				//�������������Ժ��߼���У��
				if (!obj.ValidateContents()) {
					return;
				}
				var strDescription=obj.btnCheck.getText();
				var objReport=obj.objCurrReport;
				var strSysDateTime=objCommonSrv.GetSysDateTime();
				var tmpList=strSysDateTime.split(" ");
				objReport.MEPDCheckDate=tmpList[0];
				objReport.MEPDCheckTime=tmpList[1];
				objReport.MEPDCheckUsrDR=session['LOGON.USERID'];
				obj.objCurrReport=objReport;
				obj.SaveReport(2,strDescription);
				var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",obj.objCurrReport.RowID,"2",obj.objCurrPaadm.AdmRowID);
			}
		});
	};
	
	// ����
	obj.btnCorrect_click = function() {
		ExtTool.confirm("����", "��ȷ��Ҫ������ݴ�Ⱦ������ô��", function(btn) {
			if (btn == "yes") {
				//�������������Ժ��߼���У��
				if (!obj.ValidateContents()) {
					return;
				}
				//���汻���ı���
				var strSysDateTime=objCommonSrv.GetSysDateTime();
				var tmpList=strSysDateTime.split(" ");
				var strReportID=objRepManage.UpdateCheckEPD(obj.objCurrReport.RowID, 4,session['LOGON.USERID'], tmpList[0], tmpList[1], "")
				if (strReportID <= 0) {
					ExtTool.alert("��ʾ", "���汻������ʧ�ܣ�����ֵ��" + strReportID);
					return;
				}
				//���涩��������
				var strDescription=obj.btnCorrect.getText();
				var objReport=obj.objCurrReport;
				objReport.RowID='';
				objReport.MEPDLocDR=session['LOGON.CTLOCID'];
				objReport.MEPDRepUsrDR=session['LOGON.USERID'];
				objReport.MEPDRepDate=tmpList[0];
				objReport.MEPDRepTime=tmpList[1];
				objReport.MEPDCheckUsrDR='';
				objReport.MEPDCheckDate='';
				objReport.MEPDCheckTime='';
				objReport.MEPDDelReason='';
				objReport.MEPDMepdDR=strReportID;
				obj.objCurrReport=objReport;
				obj.SaveReport(3,strDescription);
				
				var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",strReportID,"6",obj.objCurrPaadm.AdmRowID); //����
				var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",obj.objCurrReport.RowID,"7",obj.objCurrPaadm.AdmRowID);  //����
			}
		});
	};
	
	// �˻�
	obj.btnReturn_click = function() {
		ExtTool.prompt("�˻�", "�������˻�ԭ��!", function(btn, txt) {
			if (btn == 'ok') {
			//Add By pylian 2015-03-27 FixBug��8315 ���˻�ԭ��Ϊ��ʱ�����Գɹ��˻ر���
				if(txt == "")
				{
					ExtTool.alert("��ʾ", "�������˻�ԭ��!");
					return;
				}
				var strDescription=obj.btnReturn.getText();
				obj.SaveReportAA(5,strDescription,txt);
				var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",obj.objCurrReport.RowID,"3",obj.objCurrPaadm.AdmRowID);
			}		
		});
	};
	
	// �ϱ�CDC
	obj.btnUpdateCDC_click = function() {
		if (obj.objCurrReport){
			var aOperationDesc=obj.btnUpdateCDC.getText();
			ExtTool.confirm(aOperationDesc, "���Ƿ�Ҫ���˱���"+aOperationDesc+"��", function(btn, txt) {
				if (btn == "yes") {
					var strReportID=objRepManage.UpdateUploadStatus(obj.objCurrReport.RowID,(obj.objCurrReport.MEPDIsUpload == "N" ? "Y" : "N"))
					if (strReportID > 0) {
						ReportID=strReportID;
						ExtTool.alert("��ʾ", aOperationDesc + "�ɹ���");
						obj.DisplayReportInfo(strReportID);		// ���ݱ���ID��ʾ��Ӧ�ı�����Ϣ
						obj.loadPatientInfoForTemplate();		// �������ɵı�����ز��˻�����Ϣģ��
						// ��ʾ��ǰ����״̬�µĲ�����ť״̬
						if (obj.objCurrReport){
							obj.DisplayButtonStatus(LocFlag,obj.objCurrReport.MEPDStatus,obj.objCurrReport.MEPDIsUpload);
						}
						window.returnValue = true;
						ParrefWindowRefresh_Handler();
						var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",obj.objCurrReport.RowID,"8",obj.objCurrPaadm.AdmRowID);
					} else {
						ExtTool.alert("��ʾ", aOperationDesc + "ʧ�ܣ�����ֵ��" + strReportID);
					}
				}
			});
		}
	};
	
	// ɾ��
	obj.btnDelete_click = function() {
		ExtTool.prompt("ɾ��", "������ɾ���˴�Ⱦ������ԭ��!", function(btn, txt) {
			if (btn == "ok") {
				var strDescription=obj.btnDelete.getText();
				if (txt == "") {
					ExtTool.alert("��ʾ", "����дɾ��ԭ��");
					return;
				}
				obj.SaveReportAA(7,strDescription,txt);
				var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000018",obj.objCurrReport.RowID,"4",obj.objCurrPaadm.AdmRowID);
			}
		});
	};
	
	// ʡ�����紥���¼�----------Start
	obj.cboProvince_expand = function() {
		obj.cboProvinceStore.removeAll();
		obj.cboProvinceStore.load({});
	};
	obj.cboProvince_select = function() {
		obj.cboCityStore.removeAll();
		obj.cboCityStore.load({});
		obj.cboCity.setValue('');
		obj.cboCounty.setValue('');
		obj.cboVillage.setValue('');
		obj.txtRoad.setValue('');
	};
	obj.cboCity_expand = function() {
		obj.cboCityStore.removeAll();
		obj.cboCityStore.load({});
	};
	obj.cboCity_select = function() {
		obj.cboCountyStore.removeAll();
		obj.cboCountyStore.load({});
		obj.cboCounty.setValue('');
		obj.cboVillage.setValue('');
		obj.txtRoad.setValue('');
	};
	obj.cboCounty_expand = function() {
		obj.cboCountyStore.removeAll();
		obj.cboCountyStore.load({});
	};
	obj.cboCounty_select = function() {
		obj.cboVillageStore.removeAll();
		obj.cboVillageStore.load({});
		obj.cboVillage.setValue('');
		obj.txtRoad.setValue('');
	};
	obj.cboVillage_expand = function() {
		obj.cboVillageStore.removeAll();
		obj.cboVillageStore.load({});
	};
	obj.cboVillage_select = function() {
		obj.txtRoad.setValue('');
		var StrAddress=obj.cboProvince.getRawValue()+obj.cboCity.getRawValue()+obj.cboCounty.getRawValue()+obj.cboVillage.getRawValue();
		obj.txtAddress.setValue(StrAddress);
	};
	// ʡ�����紥���¼�----------End
	
	//update by zf 20140714
	//�������ֵ������ϵ�����ʷ������ʾ��������
	obj.DisplayArea = function(Province, City, County, Village, Road) {
		var strArea = ExtTool.RunServerMethod("DHCMed.EPDService.AreaDicSrv","GetAreaDics",Province, City, County, Village);
		var arrArea = strArea.split(String.fromCharCode(1));
		if (arrArea.length==8){
			obj.cboProvince.setValue(arrArea[0]);
			obj.cboProvince.setRawValue(arrArea[1]);
			obj.cboCity.setValue(arrArea[2]);
			obj.cboCity.setRawValue(arrArea[3]);
			obj.cboCounty.setValue(arrArea[4]);
			obj.cboCounty.setRawValue(arrArea[5]);
			obj.cboVillage.setValue(arrArea[6]);
			obj.cboVillage.setRawValue(arrArea[7]);
		}
		obj.txtRoad.setValue(Road);
	};
}

// �����ַ������˵Ŀհ�
function trim(obj) {
	return obj.toString().replace(/^\s+/, "").replace(/\s+$/, "");
}

//���ø�����ҳ��ˢ��
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

//���ø�����ҳ��ر�
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
