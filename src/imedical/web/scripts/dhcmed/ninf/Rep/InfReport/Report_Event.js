var is=0;
function InitReportEvent(obj)
{
	//��ʼ��������
	obj.ClsInfReportSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.InfReport");
	obj.ClsInfReportSummSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.InfReportSumm");
	obj.ClsInfReportDiagSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.InfReportDiag");
	obj.ClsInfReportInfPosSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.InfReportInfPos");
	obj.ClsInfReportOprSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.InfReportOpr");
	obj.ClsInfReportLabSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.InfReportLab");
	obj.ClsInfReportAntiSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.InfReportAnti");
	obj.ClsInfReportICUSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.InfReportICU");
	
	obj.ClsInfPosition = ExtTool.StaticServerObject("DHCMed.NINF.Dic.InfPosition");
	obj.ClsInfDiagnose = ExtTool.StaticServerObject("DHCMed.NINF.Dic.InfDiagnose");
	obj.ClsBasePatientAdm = ExtTool.StaticServerObject("DHCMed.Base.PatientAdm");
	obj.ClsBasePatient = ExtTool.StaticServerObject("DHCMed.Base.Patient");
	obj.ClsSSDictionary = ExtTool.StaticServerObject("DHCMed.SS.Dictionary");
	obj.ClsBaseCtloc = ExtTool.StaticServerObject("DHCMed.Base.Ctloc");
	obj.ClsBaseSSUser = ExtTool.StaticServerObject("DHCMed.Base.SSUser");
	obj.ClsCommonCls = ExtTool.StaticServerObject("DHCMed.NINFService.Srv.CommonCls");
	obj.ClsCommonClsSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Srv.CommonSrv");
	
	obj.ButtonDisabled = function(){
		obj.btnSave.setVisible(false);
		obj.btnSubmit.setVisible(false);
		obj.btnCheck.setVisible(false);
		obj.btnUpdoCheck.setVisible(false);
		obj.btnReturn.setVisible(false);
		obj.btnDelete.setVisible(false);
		obj.btnExport.setVisible(false);
		
		obj.btnIsCheck.setVisible(false);
	}
	
	//��ʼ������ҳ��
	obj.InitReport = function(){
		
		//��ʼ��ģ�����
		if (typeof obj.BASE_InitView == 'function') obj.BASE_InitView();            //(��)������Ϣ
		if (typeof obj.INFPOS_InitView == 'function') obj.INFPOS_InitView();        //(��)��Ⱦ��λ
		if (typeof obj.NBINF_InitView == 'function') obj.NBINF_InitView();          //(��)��������Ⱦ��Ϣ
		if (typeof obj.OPR_InitView == 'function') obj.OPR_InitView();              //(��)�������
		if (typeof obj.LAB_InitView == 'function') obj.LAB_InitView();              //(��)��ԭѧ����
		if (typeof obj.ANTI_InitView == 'function') obj.ANTI_InitView();            //(��)����ҩ��
		if (typeof obj.IBASE_InitView == 'function') obj.IBASE_InitView();          //(Ŀ)ICUת����Ϣ
		if (typeof obj.IDIAG_InitView == 'function') obj.IDIAG_InitView();          //(Ŀ)ת��ICU���
		if (typeof obj.IPICC_InitView == 'function') obj.IPICC_InitView();          //(Ŀ)ICU���뵼��
		if (typeof obj.IVAP_InitView == 'function') obj.IVAP_InitView();            //(Ŀ)ICU������
		if (typeof obj.IUC_InitView == 'function') obj.IUC_InitView();              //(Ŀ)ICU�����
		if (typeof obj.NBASE_InitView == 'function') obj.NBASE_InitView();          //(Ŀ)NICUת����Ϣ
		if (typeof obj.NPICC_InitView == 'function') obj.NPICC_InitView();          //(Ŀ)NICU���뵼��
		if (typeof obj.NVNT_InitView == 'function') obj.NVNT_InitView();            //(Ŀ)NICU���ܲ��
		if (typeof obj.NUC_InitView == 'function') obj.NUC_InitView();              //(Ŀ)NICU�꾲��
		if (typeof obj.OBASE_InitView == 'function') obj.OBASE_InitView();          //(Ŀ)����������Ϣ
		if (typeof obj.OOPR_InitView == 'function') obj.OOPR_InitView();            //(Ŀ)�����п���Ϣ
		if (typeof obj.ADIAG_InitView == 'function') obj.ADIAG_InitView();          //(Ŀ)��������
		if (typeof obj.ALAB_InitView == 'function') obj.ALAB_InitView();            //(Ŀ)��ԭѧ����
		if (typeof obj.AANTI_InitView == 'function') obj.AANTI_InitView();          //(Ŀ)����ҩ��
		
		//��ʼ����ť����
		obj.btnSave.setVisible(false);
		obj.btnSubmit.setVisible(false);
		obj.btnCheck.setVisible(false);
		obj.btnUpdoCheck.setVisible(false);
		obj.btnReturn.setVisible(false);
		obj.btnDelete.setVisible(false);
		obj.btnExport.setVisible(false);
		obj.btnIsCheck.setVisible(false);
		
		var ReportStatus = (obj.CurrReport.ReportStatus ? obj.CurrReport.ReportStatus.Code : '');
		switch (ReportStatus) {
			case "1" :    //����
				obj.btnSave.setVisible(true);
				obj.btnSubmit.setVisible(true);
				obj.btnDelete.setVisible(true);
				break;
			case "2" :    //�ύ
				//obj.btnSubmit.setVisible(true);//FixBug:6250 ���������¼�-ҽԺ��Ⱦ����-����û���ύ�ɹ���ͨ����ɾ������ťɾ����¼�������ʱ����ʾ"���ύ"״̬�ı��治����ɾ�����ݡ�
				obj.btnCheck.setVisible((obj.AdminPower == 1));
				obj.btnReturn.setVisible((obj.AdminPower == 1));
				obj.btnDelete.setVisible(true);
				// update cpj 2014-12-20 �޸�tdbug ������������ģ�壬���ε�������ť
				if ((obj.CurrReport.ReportType.Code == "NICU")||(obj.CurrReport.ReportType.Code == "NCOM")) {
					obj.btnExport.setVisible(false);
				} else {
					obj.btnExport.setVisible(true);
				}
				break;
			case "3" :    //���
				obj.btnUpdoCheck.setVisible((obj.AdminPower == 1));
				// update cpj 2014-12-20 �޸�tdbug ������������ģ�壬���ε�������ť
				if ((obj.CurrReport.ReportType.Code == "NICU")||(obj.CurrReport.ReportType.Code == "NCOM")){
					obj.btnExport.setVisible(false);
				} else {
					obj.btnExport.setVisible(true);
				}
				obj.btnIsCheck.setVisible((obj.AdminPower == 1));
				break;
			case "4" :    //ȡ�����
				obj.btnSave.setVisible(true);
				obj.btnSubmit.setVisible(true);
				obj.btnCheck.setVisible((obj.AdminPower == 1));
				obj.btnReturn.setVisible((obj.AdminPower == 1));
				obj.btnDelete.setVisible(true);
				break;
			case "5" :    //�˻�
				obj.btnSave.setVisible(true);
				obj.btnSubmit.setVisible(true);
				//obj.btnCheck.setVisible((obj.AdminPower == 1));	//Add By Jeff 20141220  FixBug:1986 �޸��˻�״̬�ı����ֱ����˵�����
				obj.btnDelete.setVisible(true);
				break;
			case "0" :    //ɾ��
				break;
			default:
				obj.btnSave.setVisible(true);
				obj.btnSubmit.setVisible(true);
				break;
		}
		
		//���湦����ʱȡ��(���Ʋݸ幦��)
		obj.btnSave.setVisible(false);
	}
	
	//��ȡ��������
	obj.GetReport = function(ReportID){
		if (ReportID == '') {
			var objInfReport = obj.ClsInfReportSrv.GetRepObj('');
			if (!objInfReport) {
				ExtTool.alert("��ʾ","���������ʼ������!");
				return '';
			} else {
				//��������
				objInfReport.EpisodeID = EpisodeID;
				objInfReport.ObjectID = '';
				objInfReport.ReportType = obj.ClsSSDictionary.GetObjById(RepTypeID);
				if (!objInfReport.ReportType) {
					ExtTool.alert("��ʾ","��������ȡֵ����!Code=" + ReportType);
					return '';
				}
				objInfReport.ReportLoc = obj.ClsBaseCtloc.GetObjById(session['LOGON.CTLOCID']);
				objInfReport.ReportUser = obj.ClsBaseSSUser.GetObjById(session['LOGON.USERID']);
				//objInfReport.ReportDate = obj.ClsCommonClsSrv.ChangeDateFormat(objInfReport.ReportDate,3);
				objInfReport.ReportDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(objInfReport.ReportDate);
				objInfReport.ReportTime = obj.ClsCommonClsSrv.ChangeTimeFormat(objInfReport.ReportTime,2);
				if (objInfReport.ReportDate == '1840-12-31') {  //508 515�汾����������
					objInfReport.ReportDate ='';
					objInfReport.ReportTime ='';
				}
				//ժҪ��Ϣ
				objInfReport.ChildSumm = obj.ClsInfReportSummSrv.GetSubObj('');
				if (!objInfReport.ChildSumm) {
					ExtTool.alert("��ʾ","ժҪ��Ϣ��ʼ������!");
					return '';
				} else {
					objInfReport.ChildSumm.TransID = '';
					objInfReport.ChildSumm.TransLoc =  '';
					objInfReport.ChildSumm.InfFactors = new Array();
					objInfReport.ChildSumm.InvasiveOperation = new Array();
					objInfReport.ChildSumm.OutICUStatus = new Array();
					objInfReport.ChildSumm.OutICU48Status = new Array();
				}
				//�ӱ���Ϣ
				objInfReport.ChildDiag   = new Array();
				objInfReport.ChildInfPos = new Array();
				objInfReport.ChildOpr    = new Array();
				objInfReport.ChildLab    = new Array();
				objInfReport.ChildAnti   = new Array();
				objInfReport.ChildICU   = new Array();
				objInfReport.ChildLog    = new Array();
			}
		} else {
			var objInfReport = obj.ClsInfReportSrv.GetRepObj(ReportID);
			if (!objInfReport) {
				ExtTool.alert("��ʾ","��������ȡֵ����!ReportID=" + ReportID);
				return '';
			} else {
				//��������
				objInfReport.ReportType = obj.ClsSSDictionary.GetObjById(objInfReport.ReportType);
				objInfReport.ReportLoc = obj.ClsBaseCtloc.GetObjById(objInfReport.ReportLoc);
				objInfReport.ReportUser = obj.ClsBaseSSUser.GetObjById(objInfReport.ReportUser);
				//objInfReport.ReportDate = obj.ClsCommonClsSrv.ChangeDateFormat(objInfReport.ReportDate,3);
				objInfReport.ReportDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(objInfReport.ReportDate);
				objInfReport.ReportTime = obj.ClsCommonClsSrv.ChangeTimeFormat(objInfReport.ReportTime,2);
				objInfReport.ReportStatus = obj.ClsSSDictionary.GetObjById(objInfReport.ReportStatus);
				
				//ժҪ��Ϣ
				var strChild = obj.ClsInfReportSummSrv.GetSubRec(objInfReport.RowID);
				objInfReport.ChildSumm = obj.ClsInfReportSummSrv.GetSubObj(strChild);
				if (!objInfReport.ChildSumm) {
					ExtTool.alert("��ʾ","ժҪ��Ϣȡֵ����!ID=" + RecId);
					return '';
				} else {
					if (objInfReport.ChildSumm.DiseasePrognosis) objInfReport.ChildSumm.DiseasePrognosis = obj.ClsSSDictionary.GetObjById(objInfReport.ChildSumm.DiseasePrognosis);
					if (objInfReport.ChildSumm.DeathRelation) objInfReport.ChildSumm.DeathRelation = obj.ClsSSDictionary.GetObjById(objInfReport.ChildSumm.DeathRelation);
					if (objInfReport.ChildSumm.ICUBoolean) objInfReport.ChildSumm.ICUBoolean = obj.ClsSSDictionary.GetObjById(objInfReport.ChildSumm.ICUBoolean);
					if (objInfReport.ChildSumm.ICULocation) objInfReport.ChildSumm.ICULocation = obj.ClsSSDictionary.GetObjById(objInfReport.ChildSumm.ICULocation);
					if (objInfReport.ChildSumm.OprBoolean) objInfReport.ChildSumm.OprBoolean = obj.ClsSSDictionary.GetObjById(objInfReport.ChildSumm.OprBoolean);
					if (objInfReport.ChildSumm.LabBoolean) objInfReport.ChildSumm.LabBoolean = obj.ClsSSDictionary.GetObjById(objInfReport.ChildSumm.LabBoolean);
					if (objInfReport.ChildSumm.AntiBoolean) objInfReport.ChildSumm.AntiBoolean = obj.ClsSSDictionary.GetObjById(objInfReport.ChildSumm.AntiBoolean);
					if (objInfReport.ChildSumm.AdverseReaction) objInfReport.ChildSumm.AdverseReaction = obj.ClsSSDictionary.GetObjById(objInfReport.ChildSumm.AdverseReaction);
					if (objInfReport.ChildSumm.Superinfection) objInfReport.ChildSumm.Superinfection = obj.ClsSSDictionary.GetObjById(objInfReport.ChildSumm.Superinfection);
					if (objInfReport.ChildSumm.TransLoc) objInfReport.ChildSumm.TransLoc = obj.ClsBaseCtloc.GetObjById(objInfReport.ChildSumm.TransLoc);
					if (objInfReport.ChildSumm.TransFromLoc) objInfReport.ChildSumm.TransFromLoc = obj.ClsBaseCtloc.GetObjById(objInfReport.ChildSumm.TransFromLoc);
					if (objInfReport.ChildSumm.TransToLoc) objInfReport.ChildSumm.TransToLoc = obj.ClsBaseCtloc.GetObjById(objInfReport.ChildSumm.TransToLoc);
					//if (objInfReport.ChildSumm.TransInDate) objInfReport.ChildSumm.TransInDate = obj.ClsCommonClsSrv.ChangeDateFormat(objInfReport.ChildSumm.TransInDate,3);
					if (objInfReport.ChildSumm.TransInDate) objInfReport.ChildSumm.TransInDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(objInfReport.ChildSumm.TransInDate);
					//if (objInfReport.ChildSumm.TransOutDate) objInfReport.ChildSumm.TransOutDate = obj.ClsCommonClsSrv.ChangeDateFormat(objInfReport.ChildSumm.TransOutDate,3);
					if (objInfReport.ChildSumm.TransOutDate) objInfReport.ChildSumm.TransOutDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(objInfReport.ChildSumm.TransOutDate);
					if (objInfReport.ChildSumm.BornWeightCat) objInfReport.ChildSumm.BornWeightCat = obj.ClsSSDictionary.GetObjById(objInfReport.ChildSumm.BornWeightCat);
					if (objInfReport.ChildSumm.InfectionType) objInfReport.ChildSumm.InfectionType = obj.ClsSSDictionary.GetObjById(objInfReport.ChildSumm.InfectionType);
					
					var SummRowID = objInfReport.ChildSumm.RowID;
					objInfReport.ChildSumm.InfFactors = new Array();
					var strInfFactors = obj.ClsInfReportSummSrv.GetFieldById(SummRowID,"InfFactors");
					var arrInfFactors = strInfFactors.split(CHR_1);
					for (var ind = 0; ind < arrInfFactors.length; ind++) {
						if (arrInfFactors[ind] == '') continue;
						var objDic = obj.ClsSSDictionary.GetObjById(arrInfFactors[ind]);
						if (objDic) {
							objInfReport.ChildSumm.InfFactors.push(objDic);
						}
					}
					objInfReport.ChildSumm.InvasiveOperation = new Array();
					var strInvasiveOperation = obj.ClsInfReportSummSrv.GetFieldById(SummRowID,"InvasiveOperation");
					var arrInvasiveOperation = strInvasiveOperation.split(CHR_1);
					for (var ind = 0; ind < arrInvasiveOperation.length; ind++) {
						if (arrInvasiveOperation[ind] == '') continue;
						var objDic = obj.ClsSSDictionary.GetObjById(arrInvasiveOperation[ind]);
						if (objDic) {
							objInfReport.ChildSumm.InvasiveOperation.push(objDic);
						}
					}
					objInfReport.ChildSumm.OutICUStatus = new Array();
					var strOutICUStatus = obj.ClsInfReportSummSrv.GetFieldById(SummRowID,"OutICUStatus");
					var arrOutICUStatus = strOutICUStatus.split(CHR_1);
					for (var ind = 0; ind < arrOutICUStatus.length; ind++) {
						if (arrOutICUStatus[ind] == '') continue;
						var objDic = obj.ClsSSDictionary.GetObjById(arrOutICUStatus[ind]);
						if (objDic) {
							objInfReport.ChildSumm.OutICUStatus.push(objDic);
						}
					}
					objInfReport.ChildSumm.OutICU48Status = new Array();
					var strOutICU48Status = obj.ClsInfReportSummSrv.GetFieldById(SummRowID,"OutICU48Status");
					var arrOutICU48Status = strOutICU48Status.split(CHR_1);
					for (var ind = 0; ind < arrOutICU48Status.length; ind++) {
						if (arrOutICU48Status[ind] == '') continue;
						var objDic = obj.ClsSSDictionary.GetObjById(arrOutICU48Status[ind]);
						if (objDic) {
							objInfReport.ChildSumm.OutICU48Status.push(objDic);
						}
					}
				}
				
				//�������
				objInfReport.ChildDiag = new Array();
				var strChild = obj.ClsInfReportDiagSrv.GetSubRec(objInfReport.RowID);
				var arrChild = strChild.split(CHR_1);
				for (var indRec = 0; indRec < arrChild.length; indRec++) {
					if (arrChild[indRec] == '') continue;
					var objChild = obj.ClsInfReportDiagSrv.GetSubObj(arrChild[indRec]);
					if (objChild) {
						//if (objChild.DiagnosDate) objChild.DiagnosDate = obj.ClsCommonClsSrv.ChangeDateFormat(objChild.DiagnosDate,3);
						if (objChild.DiagnosDate) objChild.DiagnosDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(objChild.DiagnosDate);
						if (objChild.DiagnosTime) objChild.DiagnosTime = obj.ClsCommonClsSrv.ChangeTimeFormat(objChild.DiagnosTime,2);
						if (objChild.DiagnosType) objChild.DiagnosType = obj.ClsSSDictionary.GetObjById(objChild.DiagnosType);
						objInfReport.ChildDiag.push(objChild);
					}
				}
				
				//��Ⱦ��Ϣ
				objInfReport.ChildInfPos = new Array();
				var strChild = obj.ClsInfReportInfPosSrv.GetSubRec(objInfReport.RowID);
				var arrChild = strChild.split(CHR_1);
				for (var indRec = 0; indRec < arrChild.length; indRec++) {
					if (arrChild[indRec] == '') continue;
					var objChild = obj.ClsInfReportInfPosSrv.GetSubObj(arrChild[indRec]);
					if (objChild) {
						var ChildRowID = objChild.RowID;
						if (objChild.InfPos) objChild.InfPos = obj.ClsInfPosition.GetObjById(objChild.InfPos);
						//if (objChild.InfDate) objChild.InfDate = obj.ClsCommonClsSrv.ChangeDateFormat(objChild.InfDate,3);
						if (objChild.InfDate) objChild.InfDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(objChild.InfDate);
						//if (objChild.InfEndDate) objChild.InfEndDate = obj.ClsCommonClsSrv.ChangeDateFormat(objChild.InfEndDate,3); //Add By LiYang 2013-05-18 ��ȡ��Ⱦ��������
						if (objChild.InfEndDate) objChild.InfEndDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(objChild.InfEndDate);
						if (objChild.InfDiag) objChild.InfDiag = obj.ClsInfDiagnose.GetObjById(objChild.InfDiag);
						if (objChild.InfDiagCat) objChild.InfDiagCat = obj.ClsSSDictionary.GetObjById(objChild.InfDiagCat);
						
						objChild.InfPosOpr = new Array();
						var strInfPosOpr = obj.ClsInfReportInfPosSrv.GetFieldById(ChildRowID,"InfPosOpr");
						var arrInfPosOpr = strInfPosOpr.split(CHR_1);
						for (var ind = 0; ind < arrInfPosOpr.length; ind++) {
							if (arrInfPosOpr[ind] == '') continue;
							var strOprField = arrInfPosOpr[ind];
							if (strOprField) {
								var arrOprField = strOprField.split(CHR_2);
								if (arrOprField[0] == '') continue;
								var objInfOpr = new Object();
								objInfOpr.InvasiveOper = obj.ClsSSDictionary.GetObjById(arrOprField[0]);
								//objInfOpr.StartDate = obj.ClsCommonClsSrv.ChangeDateFormat(arrOprField[1],3);
								objInfOpr.StartDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(arrOprField[1]);
								objInfOpr.StartTime = obj.ClsCommonClsSrv.ChangeTimeFormat(arrOprField[2],2);
								//objInfOpr.EndDate = obj.ClsCommonClsSrv.ChangeDateFormat(arrOprField[3],3);
								objInfOpr.EndDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(arrOprField[3]);
								objInfOpr.EndTime = obj.ClsCommonClsSrv.ChangeTimeFormat(arrOprField[4],2);
								objChild.InfPosOpr.push(objInfOpr);
							}
						}
						
						objInfReport.ChildInfPos.push(objChild);
					}
				}
				
				//�������
				objInfReport.ChildOpr = new Array();
				var strChild = obj.ClsInfReportOprSrv.GetSubRec(objInfReport.RowID);
				var arrChild = strChild.split(CHR_1);
				for (var indRec = 0; indRec < arrChild.length; indRec++) {
					if (arrChild[indRec] == '') continue;
					var objChild = obj.ClsInfReportOprSrv.GetSubObj(arrChild[indRec]);
					if (objChild) {
						var ChildRowID = objChild.RowID;
						//if (objChild.OperStartDate) objChild.OperStartDate = obj.ClsCommonClsSrv.ChangeDateFormat(objChild.OperStartDate,3);
						if (objChild.OperStartDate) objChild.OperStartDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(objChild.OperStartDate);
						if (objChild.OperStartTime) objChild.OperStartTime = obj.ClsCommonClsSrv.ChangeTimeFormat(objChild.OperStartTime,2);
						//if (objChild.OperEndDate) objChild.OperEndDate = obj.ClsCommonClsSrv.ChangeDateFormat(objChild.OperEndDate,3);
						if (objChild.OperEndDate) objChild.OperEndDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(objChild.OperEndDate);
						if (objChild.OperEndTime) objChild.OperEndTime = obj.ClsCommonClsSrv.ChangeTimeFormat(objChild.OperEndTime,2);
						if (objChild.OperDoc) objChild.OperDoc = obj.ClsBaseSSUser.GetObjById(objChild.OperDoc);
						if (objChild.OperationType) objChild.OperationType = obj.ClsSSDictionary.GetObjById(objChild.OperationType);
						if (objChild.Anesthesia) objChild.Anesthesia = obj.ClsSSDictionary.GetObjById(objChild.Anesthesia);
						if (objChild.CuteType) objChild.CuteType = obj.ClsSSDictionary.GetObjById(objChild.CuteType);
						if (objChild.CuteHealing) objChild.CuteHealing = obj.ClsSSDictionary.GetObjById(objChild.CuteHealing);
						if (objChild.CuteInfFlag) objChild.CuteInfFlag = obj.ClsSSDictionary.GetObjById(objChild.CuteInfFlag);
						if (objChild.OperInfType) objChild.OperInfType = obj.ClsSSDictionary.GetObjById(objChild.OperInfType);
						if (objChild.InHospInfFlag) objChild.InHospInfFlag = obj.ClsSSDictionary.GetObjById(objChild.InHospInfFlag);
						if (objChild.ASAScore) objChild.ASAScore = obj.ClsSSDictionary.GetObjById(objChild.ASAScore);
						if (objChild.PreoperWBC) objChild.PreoperWBC = objChild.PreoperWBC;
						if (objChild.CuteNumber) objChild.CuteNumber = obj.ClsSSDictionary.GetObjById(objChild.CuteNumber);
						if (objChild.EndoscopeFlag) objChild.EndoscopeFlag = obj.ClsSSDictionary.GetObjById(objChild.EndoscopeFlag);
						if (objChild.ImplantFlag) objChild.ImplantFlag = obj.ClsSSDictionary.GetObjById(objChild.ImplantFlag);
						if (objChild.PreoperAntiFlag) objChild.PreoperAntiFlag = obj.ClsSSDictionary.GetObjById(objChild.PreoperAntiFlag);
						if (objChild.BloodLossFlag) objChild.BloodLossFlag = obj.ClsSSDictionary.GetObjById(objChild.BloodLossFlag);
						if (objChild.BloodLoss) objChild.BloodLoss = objChild.BloodLoss;
						if (objChild.BloodTransFlag) objChild.BloodTransFlag = obj.ClsSSDictionary.GetObjById(objChild.BloodTransFlag);
						if (objChild.BloodTrans) objChild.BloodTrans = objChild.BloodTrans;
						
						objChild.PostoperComps = new Array();
						var strPostoperComps = obj.ClsInfReportOprSrv.GetFieldById(ChildRowID,"PostoperComps");
						var arrPostoperComps = strPostoperComps.split(CHR_1);
						for (var ind = 0; ind < arrPostoperComps.length; ind++) {
							if (arrPostoperComps[ind] == '') continue;
							var objDic = obj.ClsSSDictionary.GetObjById(arrPostoperComps[ind]);
							if (objDic) {
								objChild.PostoperComps.push(objDic);
							}
						}
						
						objInfReport.ChildOpr.push(objChild);
					}
				}
				
				//��ԭѧ����
				objInfReport.ChildLab = new Array();
				var strChild = obj.ClsInfReportLabSrv.GetSubRec(objInfReport.RowID);
				var arrChild = strChild.split(CHR_1);
				for (var indRec = 0; indRec < arrChild.length; indRec++) {
					if (arrChild[indRec] == '') continue;
					var objChild = obj.ClsInfReportLabSrv.GetSubObj(arrChild[indRec]);
					if (objChild) {
						var ChildRowID = objChild.RowID;
						if (objChild.Specimen) objChild.Specimen = obj.ClsSSDictionary.GetObjById(objChild.Specimen);
						if (objChild.InfectionPos) objChild.InfectionPos = obj.ClsInfPosition.GetObjById(objChild.InfectionPos);
						//if (objChild.SubmissionDate) objChild.SubmissionDate = obj.ClsCommonClsSrv.ChangeDateFormat(objChild.SubmissionDate,3);
						if (objChild.SubmissionDate) objChild.SubmissionDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(objChild.SubmissionDate);
						if (objChild.AssayMethod) objChild.AssayMethod = obj.ClsSSDictionary.GetObjById(objChild.AssayMethod);
						if (objChild.PathogenTest) objChild.PathogenTest = obj.ClsSSDictionary.GetObjById(objChild.PathogenTest);
						
						objChild.TestResults = new Array();
						var strTestResults = obj.ClsInfReportLabSrv.GetFieldById(ChildRowID,"TestResults");
						var arrTestResults = strTestResults.split(CHR_1);
						for (var indPy = 0; indPy < arrTestResults.length; indPy++) {
							if (arrTestResults[indPy] == '') continue;
							var strPyField = arrTestResults[indPy];
							var arrPyField = strPyField.split(CHR_2);
							
							var arrDrugSenTest = new Array();
							var strAnti = arrPyField[2];
							var arrAnti = strAnti.split(CHR_3);
							for (var indAnti = 0; indAnti < arrAnti.length; indAnti++) {
								if (arrAnti[indAnti] == '') continue;
								var strAntiField = arrAnti[indAnti];
								if (strAntiField) {
									var arrAntiField = strAntiField.split(CHR_4);
									var objDrugSenTest = new Object();
									objDrugSenTest.AntibioticsID = arrAntiField[0];
									objDrugSenTest.AntibioticsDesc = arrAntiField[1];
									objDrugSenTest.SenTestRst = obj.ClsSSDictionary.GetObjById(arrAntiField[2]);
									arrDrugSenTest.push(objDrugSenTest);
								}
							}
							
							var objTestResults = new Object();
							objTestResults.PathogenyID = arrPyField[0];
							objTestResults.PathogenyDesc = arrPyField[1];
							objTestResults.DrugSenTest = arrDrugSenTest;
							objChild.TestResults.push(objTestResults);
						}
						
						objInfReport.ChildLab.push(objChild);
					}
				}
				
				//������ҩ
				objInfReport.ChildAnti = new Array();
				var strChild = obj.ClsInfReportAntiSrv.GetSubRec(objInfReport.RowID);
				var arrChild = strChild.split(CHR_1);
				for (var indRec = 0; indRec < arrChild.length; indRec++) {
					if (arrChild[indRec] == '') continue;
					var objChild = obj.ClsInfReportAntiSrv.GetSubObj(arrChild[indRec]);
					if (objChild) {
						//if (objChild.StartDate) objChild.StartDate = obj.ClsCommonClsSrv.ChangeDateFormat(objChild.StartDate,3);
						if (objChild.StartDate) objChild.StartDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(objChild.StartDate);
						if (objChild.StartTime) objChild.StartTime = obj.ClsCommonClsSrv.ChangeTimeFormat(objChild.StartTime,2);
						//if (objChild.EndDate) objChild.EndDate = obj.ClsCommonClsSrv.ChangeDateFormat(objChild.EndDate,3);
						if (objChild.EndDate) objChild.EndDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(objChild.EndDate);
						if (objChild.EndTime) objChild.EndTime = obj.ClsCommonClsSrv.ChangeTimeFormat(objChild.EndTime,2);
						if (objChild.MedUsePurpose) objChild.MedUsePurpose = obj.ClsSSDictionary.GetObjById(objChild.MedUsePurpose);
						if (objChild.AdminRoute) objChild.AdminRoute = obj.ClsSSDictionary.GetObjById(objChild.AdminRoute);
						if (objChild.MedPurpose) objChild.MedPurpose = obj.ClsSSDictionary.GetObjById(objChild.MedPurpose);
						if (objChild.TreatmentMode) objChild.TreatmentMode = obj.ClsSSDictionary.GetObjById(objChild.TreatmentMode);
						if (objChild.PreMedIndicat) objChild.PreMedIndicat = obj.ClsSSDictionary.GetObjById(objChild.PreMedIndicat);
						if (objChild.PreMedEffect) objChild.PreMedEffect = obj.ClsSSDictionary.GetObjById(objChild.PreMedEffect);
						if (objChild.CombinedMed) objChild.CombinedMed = obj.ClsSSDictionary.GetObjById(objChild.CombinedMed);
						if (objChild.SenAna) objChild.SenAna = obj.ClsSSDictionary.GetObjById(objChild.SenAna);
						objInfReport.ChildAnti.push(objChild);
					}
				}
				
				//��֢�໤��Ϣ
				objInfReport.ChildICU = new Array();
				var strChild = obj.ClsInfReportICUSrv.GetSubRec(objInfReport.RowID);
				var arrChild = strChild.split(CHR_1);
				for (var indRec = 0; indRec < arrChild.length; indRec++) {
					if (arrChild[indRec] == '') continue;
					var objChild = obj.ClsInfReportICUSrv.GetSubObj(arrChild[indRec]);
					if (objChild) {
						if (objChild.IntubateType) objChild.IntubateType = obj.ClsSSDictionary.GetObjById(objChild.IntubateType);
						//if (objChild.IntubateDate) objChild.IntubateDate = obj.ClsCommonClsSrv.ChangeDateFormat(objChild.IntubateDate,3);
						if (objChild.IntubateDate) objChild.IntubateDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(objChild.IntubateDate);
						if (objChild.IntubateTime) objChild.IntubateTime = obj.ClsCommonClsSrv.ChangeTimeFormat(objChild.IntubateTime,2);
						//if (objChild.ExtubateDate) objChild.ExtubateDate = obj.ClsCommonClsSrv.ChangeDateFormat(objChild.ExtubateDate,3);
						if (objChild.ExtubateDate) objChild.ExtubateDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(objChild.ExtubateDate);
						if (objChild.ExtubateTime) objChild.ExtubateTime = obj.ClsCommonClsSrv.ChangeTimeFormat(objChild.ExtubateTime,2);
						if (objChild.IntubatePlace) objChild.IntubatePlace = obj.ClsSSDictionary.GetObjById(objChild.IntubatePlace);
						if (objChild.IntubateUserType) objChild.IntubateUserType = obj.ClsSSDictionary.GetObjById(objChild.IntubateUserType);
						if (objChild.IntubateUser) objChild.IntubateUser = obj.ClsBaseSSUser.GetObjById(objChild.IntubateUser);
						//if (objChild.InfDate) objChild.InfDate = obj.ClsCommonClsSrv.ChangeDateFormat(objChild.InfDate,3);
						if (objChild.InfDate) objChild.InfDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(objChild.InfDate);
						
						objChild.InfPathogeny = new Array();
						var strInfPathogeny = obj.ClsInfReportICUSrv.GetFieldById(arrChild[indRec],"InfPathogeny");
						var arrInfPathogeny = strInfPathogeny.split(CHR_1);
						for (var ind = 0; ind < arrInfPathogeny.length; ind++) {
							var strInfPathogeny = arrInfPathogeny[ind];
							if (strInfPathogeny) {
								var arrInfPyField = strInfPathogeny.split(CHR_2);
								var objInfOpr = new Object();
								objInfPathogeny.PathogenyID = arrInfPyField[0];
								objInfPathogeny.PathogenyDesc = arrInfPyField[1];
								objChild.InfPosOpr.push(objInfPathogeny);
							}
						}
						
						if (objChild.PICCIntubatePos) objChild.PICCIntubatePos = obj.ClsSSDictionary.GetObjById(objChild.PICCIntubatePos);
						if (objChild.PICCIntubateSize) objChild.PICCIntubateSize = obj.ClsSSDictionary.GetObjById(objChild.PICCIntubateSize);
						if (objChild.PICCIntubateType) objChild.PICCIntubateType = obj.ClsSSDictionary.GetObjById(objChild.PICCIntubateType);
						if (objChild.PICCIntubateNum) objChild.PICCIntubateNum = obj.ClsSSDictionary.GetObjById(objChild.PICCIntubateNum);
						if (objChild.PICCIntubateRegion) objChild.PICCIntubateRegion = obj.ClsSSDictionary.GetObjById(objChild.PICCIntubateRegion);
						if (objChild.PICCExtubateReason) objChild.PICCExtubateReason = obj.ClsSSDictionary.GetObjById(objChild.PICCExtubateReason);
						if (objChild.UCUrineBagType) objChild.UCUrineBagType = obj.ClsSSDictionary.GetObjById(objChild.UCUrineBagType);
						if (objChild.VAPIntubateType) objChild.VAPIntubateType = obj.ClsSSDictionary.GetObjById(objChild.VAPIntubateType);
						objInfReport.ChildICU.push(objChild);
					}
				}
			}
		}
		return objInfReport;
	}
	
	//���汨��״̬(ֻ��״̬���в���,������������)
	obj.SaveRepStatus = function(){
		//���ñ������״̬
		obj.CurrReport.ReportStatus = obj.ClsSSDictionary.GetByTypeCode("NINFInfReportStatus",arguments[0],"");
		if (!obj.CurrReport.ReportStatus) {
			ExtTool.alert('������ʾ','����״̬����!');
			return false;
		}
		
		var logResume = '';
		if (arguments.length >= 2) {
			logResume = arguments[1];
		}
		
		//����״̬+��־��Ϣ
		var objRep = obj.CurrReport;
		var inputRepStatus = objRep.RowID;
		inputRepStatus = inputRepStatus + CHR_1 + session['LOGON.CTLOCID'];
		inputRepStatus = inputRepStatus + CHR_1 + session['LOGON.USERID'];
		inputRepStatus = inputRepStatus + CHR_1 + (objRep.ReportStatus ? objRep.ReportStatus.RowID : '');
		inputRepStatus = inputRepStatus + CHR_1 + logResume;
		var flg = obj.ClsInfReportSrv.SaveRepStatus(inputRepStatus, CHR_1);
		if (parseInt(flg) > 0) {
			var RepID = flg;
			obj.CurrReport.RowID = RepID;
		} else {
			ExtTool.alert('������ʾ','����״̬ �������!Error=' + flg);
			return false;
		}
		return true;
	}
	
	//���汨��
	obj.SaveReport = function(){
		//���ñ������״̬
		obj.CurrReport.ReportStatus = obj.ClsSSDictionary.GetByTypeCode("NINFInfReportStatus",arguments[0],"");
		if (!obj.CurrReport.ReportStatus) {
			ExtTool.alert('������ʾ','����״̬����!');
			return false;
		}
		
		obj.CurrReport.ChildDiag   = new Array();
		obj.CurrReport.ChildInfPos = new Array();
		obj.CurrReport.ChildOpr    = new Array();
		obj.CurrReport.ChildLab    = new Array();
		obj.CurrReport.ChildAnti   = new Array();
		obj.CurrReport.ChildICU   = new Array();
		
		//��ȡ��������(�洢��"obj.CurrReport"������)�����������������
		var errinfo = '';
		if (typeof obj.BASE_SaveData == 'function') {
			errinfo = errinfo + obj.BASE_SaveData();             //(��)������Ϣ
		}
		if (typeof obj.INFPOS_SaveData == 'function') {
			errinfo = errinfo + obj.INFPOS_SaveData();           //(��)��Ⱦ��λ
		}
		if (typeof obj.NBINF_SaveData == 'function') {
			errinfo = errinfo + obj.NBINF_SaveData();            //(��)��������Ⱦ��Ϣ
		}
		if (typeof obj.OPR_SaveData == 'function') {
			errinfo = errinfo + obj.OPR_SaveData();              //(��)�������
		}
		if (typeof obj.LAB_SaveData == 'function') {
			errinfo = errinfo + obj.LAB_SaveData();              //(��)��ԭѧ����
		}
		if (typeof obj.ANTI_SaveData == 'function') {
			errinfo = errinfo + obj.ANTI_SaveData();             //(��)����ҩ��
		}
		if (typeof obj.IBASE_SaveData == 'function') {
			errinfo = errinfo + obj.IBASE_SaveData();            //(Ŀ)ICUת����Ϣ
		}
		if (typeof obj.IDIAG_SaveData == 'function') {
			errinfo = errinfo + obj.IDIAG_SaveData();            //(Ŀ)ICUת��ICU���
		}
		if (typeof obj.IPICC_SaveData == 'function') {
			errinfo = errinfo + obj.IPICC_SaveData();            //(Ŀ)ICU���뵼��
		}
		if (typeof obj.IVAP_SaveData == 'function') {
			errinfo = errinfo + obj.IVAP_SaveData();             //(Ŀ)ICU������
		}
		if (typeof obj.IUC_SaveData == 'function') {
			errinfo = errinfo + obj.IUC_SaveData();              //(Ŀ)ICU�����
		}
		if (typeof obj.NBASE_SaveData == 'function') {
			errinfo = errinfo + obj.NBASE_SaveData();            //(Ŀ)NICUת����Ϣ
		}
		if (typeof obj.NPICC_SaveData == 'function') {
			errinfo = errinfo + obj.NPICC_SaveData();           //(Ŀ)NICU���뵼��
		}
		if (typeof obj.NVNT_SaveData == 'function') {
			errinfo = errinfo + obj.NVNT_SaveData();             //(Ŀ)NICU���ܲ��
		}
		if (typeof obj.NUC_SaveData == 'function') {
			errinfo = errinfo + obj.NUC_SaveData();             //(Ŀ)NICU�꾲��
		}
		if (typeof obj.OBASE_SaveData == 'function') {
			errinfo = errinfo + obj.OBASE_SaveData();            //(Ŀ)OPR������Ϣ
		}
		if (typeof obj.OOPR_SaveData == 'function') {
			errinfo = errinfo + obj.OOPR_SaveData();             //(Ŀ)OPR�����п�
		}
		if (typeof obj.ADIAG_SaveData == 'function') {
			errinfo = errinfo + obj.ADIAG_SaveData();             //(Ŀ)��������
		}
		if (typeof obj.ALAB_SaveData == 'function') {
			errinfo = errinfo + obj.ALAB_SaveData();             //(Ŀ)��ԭѧ����
		}
		if (typeof obj.AANTI_SaveData == 'function') {
			errinfo = errinfo + obj.AANTI_SaveData();            //(Ŀ)����ҩ��
		}
		//���棨�ݸ壩״̬�����������������
		if ((errinfo)&&(obj.CurrReport.ReportStatus.Code != '1')) {
			ExtTool.alert('��ʾ',errinfo);
			return false;
		}
		//add cpj 2014-12-20 �޸�tdbug��1710 icu,NICU �����ύʱ��û����д������Ϣ,�����ύ������Ϣ
		if ((obj.CurrReport.ReportType.Code == "NICU") || (obj.CurrReport.ReportType.Code == "ICU")) {
			if (obj.CurrReport.ChildICU.length < 1) {
				ExtTool.alert('��ʾ',"�����Ӳ����Ϣ");
				return false;
			}
		}
		
		//������������+��־��Ϣ
		var objRep = obj.CurrReport;
		//var inputRep =  objRep.RowID;
		var inputRep = ReportID; //Modified By LiYang 2014-07-02 Fix Bug #1591
		inputRep = inputRep + CHR_1 + objRep.EpisodeID;
		inputRep = inputRep + CHR_1 + (objRep.ReportType ? objRep.ReportType.RowID : '');
		inputRep = inputRep + CHR_1 + objRep.ObjectID;
		inputRep = inputRep + CHR_1 + (objRep.ReportLoc ? objRep.ReportLoc.Rowid : '');
		inputRep = inputRep + CHR_1 + (objRep.ReportUser ? objRep.ReportUser.Rowid : '');
		inputRep = inputRep + CHR_1 + objRep.ReportDate;
		inputRep = inputRep + CHR_1 + objRep.ReportTime;
		inputRep = inputRep + CHR_1 + (objRep.ReportStatus ? objRep.ReportStatus.RowID : '');
		inputRep = inputRep + CHR_1 + session['LOGON.CTLOCID'] + CHR_2 + session['LOGON.USERID'] + CHR_2 + (objRep.ReportStatus ? objRep.ReportStatus.RowID : '');
		var flg = obj.ClsInfReportSrv.SaveRepRec(inputRep, CHR_1 + ',' + CHR_2);
		if (parseInt(flg) > 0) {
			obj.CurrReport.RowID = flg;
			ReportID=flg;
		} else {
			ExtTool.alert('������ʾ','�������� �������!Error=' + flg);
			return false;
		}
		
		//ժҪ��Ϣ
		var objSumm = obj.CurrReport.ChildSumm;
		var InfFactors = '';  //�׸�����
		for (var ind = 0; ind < objSumm.InfFactors.length; ind++) {
			var objDic = objSumm.InfFactors[ind];
			if (!objDic) continue;
			InfFactors = InfFactors + CHR_2 +objDic.RowID;
		}
		if (InfFactors) InfFactors = InfFactors.substring(1,InfFactors.length);
		
		var InvasiveOper = '';   //�ֺ��Բ���
		for (var ind = 0; ind < objSumm.InvasiveOperation.length; ind++) {
			var objDic = objSumm.InvasiveOperation[ind];
			if (!objDic) continue;
			InvasiveOper = InvasiveOper + CHR_2 + objDic.RowID;
		}
		if (InvasiveOper) InvasiveOper = InvasiveOper.substring(1,InvasiveOper.length);
		
		var OutICUStatus = '';     //ת��ICUʱ״̬(�������)
		for (var ind = 0; ind < objSumm.OutICUStatus.length; ind++) {
			var objDic = objSumm.OutICUStatus[ind];
			if (!objDic) continue;
			OutICUStatus = OutICUStatus + CHR_2 + objDic.RowID;
		}
		if (OutICUStatus) OutICUStatus = OutICUStatus.substring(1,OutICUStatus.length);
		
		var OutICU48Status = '';   //ת��ICU48Сʱ��״̬(�������)
		for (var ind = 0; ind < objSumm.OutICU48Status.length; ind++) {
			var objDic = objSumm.OutICU48Status[ind];
			if (!objDic) continue;
			OutICU48Status = OutICU48Status + CHR_2 + objDic.RowID;
		}
		if (OutICU48Status) OutICU48Status = OutICU48Status.substring(1,OutICU48Status.length);
		
		var inputSumm = obj.CurrReport.RowID;
		inputSumm = inputSumm + CHR_1 + '';
		inputSumm = inputSumm + CHR_1 + (objSumm.DiseasePrognosis ? objSumm.DiseasePrognosis.RowID : '');
		inputSumm = inputSumm + CHR_1 + (objSumm.DeathRelation ? objSumm.DeathRelation.RowID : '');
		inputSumm = inputSumm + CHR_1 + objSumm.DiagnosisBasis;
		inputSumm = inputSumm + CHR_1 + objSumm.DiseaseCourse;
		inputSumm = inputSumm + CHR_1 + InfFactors;
		inputSumm = inputSumm + CHR_1 + InvasiveOper;
		inputSumm = inputSumm + CHR_1 + (objSumm.ICUBoolean ? objSumm.ICUBoolean.RowID : '');
		inputSumm = inputSumm + CHR_1 + (objSumm.ICULocation ? objSumm.ICULocation.RowID : '');
		inputSumm = inputSumm + CHR_1 + (objSumm.OprBoolean ? objSumm.OprBoolean.RowID : '');
		inputSumm = inputSumm + CHR_1 + (objSumm.LabBoolean ? objSumm.LabBoolean.RowID : '');
		inputSumm = inputSumm + CHR_1 + (objSumm.AntiBoolean ? objSumm.AntiBoolean.RowID : '');
		inputSumm = inputSumm + CHR_1 + (objSumm.AdverseReaction ? objSumm.AdverseReaction.RowID : '');
		inputSumm = inputSumm + CHR_1 + (objSumm.Superinfection ? objSumm.Superinfection.RowID : '');
		inputSumm = inputSumm + CHR_1 + objSumm.BornWeight;
		inputSumm = inputSumm + CHR_1 + objSumm.TransID;
		inputSumm = inputSumm + CHR_1 + (objSumm.TransLoc ? objSumm.TransLoc.Rowid : '');
		inputSumm = inputSumm + CHR_1 + (objSumm.TransFromLoc ? objSumm.TransFromLoc.Rowid : '');
		inputSumm = inputSumm + CHR_1 + (objSumm.TransToLoc ? objSumm.TransToLoc.Rowid : '');
		inputSumm = inputSumm + CHR_1 + objSumm.TransInDate;
		inputSumm = inputSumm + CHR_1 + objSumm.TransOutDate;
		inputSumm = inputSumm + CHR_1 + OutICUStatus;
		inputSumm = inputSumm + CHR_1 + OutICU48Status;
		inputSumm = inputSumm + CHR_1 + objSumm.SystemSymptom;
		inputSumm = inputSumm + CHR_1 + objSumm.LocalSymptom;
		inputSumm = inputSumm + CHR_1 + (objSumm.BornWeightCat ? objSumm.BornWeightCat.RowID : '');
		inputSumm = inputSumm + CHR_1 + (objSumm.InfectionType ? objSumm.InfectionType.RowID : '');
		//Add By LiYang 2014-04-09 ����ApacheII������Ŀ
		inputSumm = inputSumm + CHR_1 + objSumm.ApacheIIScore;
		
		//add by zf 2017-07-25 �����׸����غ��ֺ��Բ�����ע
		inputSumm = inputSumm + CHR_1 + objSumm.InfFactorsTxt;  //�׸����ر�ע
		inputSumm = inputSumm + CHR_1 + objSumm.InvasiveOperTxt;  //�ֺ��Բ�����ע

		var flg = obj.ClsInfReportSummSrv.SaveSubRec(inputSumm, CHR_1 + ',' + CHR_2);
		if (parseInt(flg) > 0) {
			//������ȷ
		} else {
			ExtTool.alert('������ʾ','ժҪ��Ϣ �������!Error=' + flg);
			return false;
		}
		
		//�������
		var inputDiag = '';
		var arrDiag = obj.CurrReport.ChildDiag;
		for (var indDiag = 0; indDiag < arrDiag.length; indDiag++) {
			var objDiag = arrDiag[indDiag];
			if (!objDiag) continue;
			
			var RowID = objDiag.RowID;
			var arrTmp = RowID.split("||");
			var SubID = (arrTmp.length == 2 ? arrTmp[1] : '');
			
			inputDiag = obj.CurrReport.RowID;
			inputDiag = inputDiag + CHR_1 + SubID;
			inputDiag = inputDiag + CHR_1 + objDiag.DataSource;
			inputDiag = inputDiag + CHR_1 + objDiag.DiagnosID;
			inputDiag = inputDiag + CHR_1 + objDiag.DiagnosDesc;
			inputDiag = inputDiag + CHR_1 + objDiag.DiagnosDate;
			inputDiag = inputDiag + CHR_1 + objDiag.DiagnosTime;
			inputDiag = inputDiag + CHR_1 + (objDiag.DiagnosType ? objDiag.DiagnosType.RowID : '');
			var flg = obj.ClsInfReportDiagSrv.SaveSubRec(inputDiag, CHR_1);
			if (parseInt(flg) > 0) {
				//������ȷ
			} else {
				ExtTool.alert('������ʾ','������� �������!Error=' + flg);
				return false;
			}
		}
		
		//��Ⱦ��Ϣ
		var inputInfPos = '';
		var arrInfPos = obj.CurrReport.ChildInfPos;
		for (var indPos = 0; indPos < arrInfPos.length; indPos++) {
			var objInfPos = arrInfPos[indPos];
			if (!objInfPos) continue;
			
			var RowID = objInfPos.RowID;
			var arrTmp = RowID.split("||");
			var SubID = (arrTmp.length == 2 ? arrTmp[1] : '');
			
			var InfPosOpr = '';
			for (var indInfPosOpr = 0; indInfPosOpr < objInfPos.InfPosOpr.length; indInfPosOpr++) {
				var objInfPosOpr = objInfPos.InfPosOpr[indInfPosOpr];
				if (!objInfPosOpr) continue;
				InfPosOpr = InfPosOpr  + CHR_2 + (objInfPosOpr.InvasiveOper ? objInfPosOpr.InvasiveOper.RowID : '');
				InfPosOpr = InfPosOpr  + CHR_3 + objInfPosOpr.StartDate;
				InfPosOpr = InfPosOpr  + CHR_3 + objInfPosOpr.StartTime;
				InfPosOpr = InfPosOpr  + CHR_3 + objInfPosOpr.EndDate;
				InfPosOpr = InfPosOpr  + CHR_3 + objInfPosOpr.EndTime;
			}
			if (InfPosOpr != '') InfPosOpr = InfPosOpr.substring(1,InfPosOpr.length);
			
			inputInfPos = obj.CurrReport.RowID;
			inputInfPos = inputInfPos + CHR_1 + SubID;
			inputInfPos = inputInfPos + CHR_1 + objInfPos.DataSource;
			inputInfPos = inputInfPos + CHR_1 + (objInfPos.InfPos ? objInfPos.InfPos.RowID : '');
			inputInfPos = inputInfPos + CHR_1 + objInfPos.InfDate;
			inputInfPos = inputInfPos + CHR_1 + (objInfPos.InfDiag ? objInfPos.InfDiag.RowID : '');
			inputInfPos = inputInfPos + CHR_1 + InfPosOpr;
			inputInfPos = inputInfPos + CHR_1 + objInfPos.InfEndDate;   //��Ⱦ����ʱ��
			inputInfPos = inputInfPos + CHR_1 + objInfPos.InfEndResult; //��Ⱦת��
			inputInfPos = inputInfPos + CHR_1 + objInfPos.DiagnosisBasis;
			inputInfPos = inputInfPos + CHR_1 + objInfPos.DiseaseCourse;
			inputInfPos = inputInfPos + CHR_1 + (objInfPos.InfDiagCat ? objInfPos.InfDiagCat.RowID : '');   //��Ⱦ����ӷ���
			
			var flg = obj.ClsInfReportInfPosSrv.SaveSubRec(inputInfPos, CHR_1 + ',' + CHR_2 + ',' + CHR_3);
			if (parseInt(flg) > 0) {
				//������ȷ
			} else {
				ExtTool.alert('������ʾ','��Ⱦ��Ϣ �������!���=' + indPos + ',Error=' + flg);
				return false;
			}
		}
		
		//������Ϣ
		var inputOpr = '';
		var arrOpr = obj.CurrReport.ChildOpr;
		for (var indOpr = 0; indOpr < arrOpr.length; indOpr++) {
			var objOpr = arrOpr[indOpr];
			if (!objOpr) continue;
			
			var RowID = objOpr.RowID;
			var arrTmp = RowID.split("||");
			var SubID = (arrTmp.length == 2 ? arrTmp[1] : '');
			
			var PostoperComps = '';   //�ֺ��Բ���
			for (var ind = 0; ind < objOpr.PostoperComps.length; ind++) {
				var objDic = objOpr.PostoperComps[ind];
				if (!objDic) continue;
				PostoperComps = PostoperComps + CHR_2 + objDic.RowID;
			}
			if (PostoperComps) PostoperComps = PostoperComps.substring(1,PostoperComps.length);
			
			inputOpr = obj.CurrReport.RowID;
			inputOpr = inputOpr + CHR_1 + SubID;
			inputOpr = inputOpr + CHR_1 + objOpr.DataSource;
			inputOpr = inputOpr + CHR_1 + objOpr.OperationID;
			inputOpr = inputOpr + CHR_1 + objOpr.OperationDesc;
			inputOpr = inputOpr + CHR_1 + objOpr.OperStartDate;
			inputOpr = inputOpr + CHR_1 + objOpr.OperStartTime;
			inputOpr = inputOpr + CHR_1 + objOpr.OperEndDate;
			inputOpr = inputOpr + CHR_1 + objOpr.OperEndTime;
			inputOpr = inputOpr + CHR_1 + (objOpr.OperDoc ? objOpr.OperDoc.Rowid : '');
			inputOpr = inputOpr + CHR_1 + (objOpr.OperationType ? objOpr.OperationType.RowID : '');
			inputOpr = inputOpr + CHR_1 + (objOpr.Anesthesia ? objOpr.Anesthesia.RowID : '');
			inputOpr = inputOpr + CHR_1 + (objOpr.CuteType ? objOpr.CuteType.RowID : '');
			inputOpr = inputOpr + CHR_1 + (objOpr.CuteHealing ? objOpr.CuteHealing.RowID : '');
			inputOpr = inputOpr + CHR_1 + (objOpr.CuteInfFlag ? objOpr.CuteInfFlag.RowID : '');
			inputOpr = inputOpr + CHR_1 + (objOpr.OperInfType ? objOpr.OperInfType.RowID : '');
			inputOpr = inputOpr + CHR_1 + (objOpr.InHospInfFlag ? objOpr.InHospInfFlag.RowID : '');
			inputOpr = inputOpr + CHR_1 + (objOpr.ASAScore ? objOpr.ASAScore.RowID : '');
			inputOpr = inputOpr + CHR_1 + objOpr.PreoperWBC;
			inputOpr = inputOpr + CHR_1 + (objOpr.CuteNumber ? objOpr.CuteNumber.RowID : '');
			inputOpr = inputOpr + CHR_1 + (objOpr.EndoscopeFlag ? objOpr.EndoscopeFlag.RowID : '');
			inputOpr = inputOpr + CHR_1 + (objOpr.ImplantFlag ? objOpr.ImplantFlag.RowID : '');
			inputOpr = inputOpr + CHR_1 + (objOpr.PreoperAntiFlag ? objOpr.PreoperAntiFlag.RowID : '');
			inputOpr = inputOpr + CHR_1 + (objOpr.BloodLossFlag ? objOpr.BloodLossFlag.RowID : '');
			inputOpr = inputOpr + CHR_1 + objOpr.BloodLoss;
			inputOpr = inputOpr + CHR_1 + (objOpr.BloodTransFlag ? objOpr.BloodTransFlag.RowID : '');
			inputOpr = inputOpr + CHR_1 + objOpr.BloodTrans;
			inputOpr = inputOpr + CHR_1 + PostoperComps;
			
			var flg = obj.ClsInfReportOprSrv.SaveSubRec(inputOpr, CHR_1 + ',' + CHR_2);
			if (parseInt(flg) > 0) {
				//������ȷ
			} else {
				ExtTool.alert('������ʾ','������Ϣ �������!���=' + indOpr + ',Error=' + flg);
				return false;
			}
		}
		
		//��ԭѧ����
		var inputLab = '';
		var arrLab = obj.CurrReport.ChildLab;
		for (var indLab = 0; indLab < arrLab.length; indLab++) {
			var objLab = arrLab[indLab];
			if (!objLab) continue;
			
			var RowID = objLab.RowID;
			var arrTmp = RowID.split("||");
			var SubID = (arrTmp.length == 2 ? arrTmp[1] : '');
			
			var TestResults = '';
			for (var indTestRst = 0; indTestRst < objLab.TestResults.length; indTestRst++) {
				var objTestRst = objLab.TestResults[indTestRst];
				if (!objTestRst) continue;
				
				var DrugSenTest = '';
				for (var indSenTest = 0; indSenTest < objTestRst.DrugSenTest.length; indSenTest++) {
					var objSenTest = objTestRst.DrugSenTest[indSenTest];
					if (!objSenTest) continue;
					DrugSenTest = DrugSenTest + CHR_4 + objSenTest.AntibioticsID;
					DrugSenTest = DrugSenTest + CHR_5 + objSenTest.AntibioticsDesc;
					DrugSenTest = DrugSenTest + CHR_5 + (objSenTest.SenTestRst ? objSenTest.SenTestRst.RowID : '');
				}
				if (DrugSenTest != '') DrugSenTest = DrugSenTest.substring(1,DrugSenTest.length);
				
				TestResults = TestResults  + CHR_2 + objTestRst.PathogenyID;
				TestResults = TestResults  + CHR_3 + objTestRst.PathogenyDesc;
				TestResults = TestResults  + CHR_3 + DrugSenTest;
			}
			if (TestResults != '') TestResults = TestResults.substring(1,TestResults.length);
			
			inputLab = obj.CurrReport.RowID;
			inputLab = inputLab + CHR_1 + SubID;
			inputLab = inputLab + CHR_1 + objLab.DataSource;
			inputLab = inputLab + CHR_1 + objLab.ArcimID;
			inputLab = inputLab + CHR_1 + objLab.ArcimDesc;
			inputLab = inputLab + CHR_1 + (objLab.Specimen ? objLab.Specimen.RowID : '');
			inputLab = inputLab + CHR_1 + (objLab.InfectionPos ? objLab.InfectionPos.RowID : '');
			inputLab = inputLab + CHR_1 + objLab.SubmissionDate;
			inputLab = inputLab + CHR_1 + (objLab.AssayMethod ? objLab.AssayMethod.RowID : '');
			inputLab = inputLab + CHR_1 + (objLab.PathogenTest ? objLab.PathogenTest.RowID : '');
			inputLab = inputLab + CHR_1 + TestResults;
			
			var flg = obj.ClsInfReportLabSrv.SaveSubRec(inputLab, CHR_1 + ',' + CHR_2 + ',' + CHR_3 + ',' + CHR_4 + ',' + CHR_5);
			if (parseInt(flg) > 0) {
				//������ȷ
			} else {
				ExtTool.alert('������ʾ','��ԭѧ���� �������!���=' + indLab + ',Error=' + flg);
				return false;
			}
		}
		
		//������ҩ
		var inputAnti = '';
		var arrAnti = obj.CurrReport.ChildAnti;
		for (var indAnti = 0; indAnti < arrAnti.length; indAnti++) {
			var objAnti = arrAnti[indAnti];
			if (!objAnti) continue;
			
			var RowID = objAnti.RowID;
			var arrTmp = RowID.split("||");
			var SubID = (arrTmp.length == 2 ? arrTmp[1] : '');
			
			inputAnti = obj.CurrReport.RowID;
			inputAnti = inputAnti + CHR_1 + SubID;
			inputAnti = inputAnti + CHR_1 + objAnti.DataSource;
			inputAnti = inputAnti + CHR_1 + objAnti.ArcimID;
			inputAnti = inputAnti + CHR_1 + objAnti.ArcimDesc;
			inputAnti = inputAnti + CHR_1 + objAnti.StartDate;
			inputAnti = inputAnti + CHR_1 + objAnti.StartTime;
			inputAnti = inputAnti + CHR_1 + objAnti.EndDate;
			inputAnti = inputAnti + CHR_1 + objAnti.EndTime;
			inputAnti = inputAnti + CHR_1 + objAnti.DoseQty;
			inputAnti = inputAnti + CHR_1 + (objAnti.DoseUnit ? objAnti.DoseUnit.RowID : '');
			inputAnti = inputAnti + CHR_1 + (objAnti.PhcFreq ? objAnti.PhcFreq.RowID : '');
			inputAnti = inputAnti + CHR_1 + (objAnti.MedUsePurpose ? objAnti.MedUsePurpose.RowID : '');
			inputAnti = inputAnti + CHR_1 + (objAnti.AdminRoute ? objAnti.AdminRoute.RowID : '');
			inputAnti = inputAnti + CHR_1 + (objAnti.MedPurpose ? objAnti.MedPurpose.RowID : '');
			inputAnti = inputAnti + CHR_1 + (objAnti.TreatmentMode ? objAnti.TreatmentMode.RowID : '');
			inputAnti = inputAnti + CHR_1 + (objAnti.PreMedIndicat ? objAnti.PreMedIndicat.RowID : '');
			inputAnti = inputAnti + CHR_1 + (objAnti.PreMedEffect ? objAnti.PreMedEffect.RowID : '');
			inputAnti = inputAnti + CHR_1 + (objAnti.CombinedMed ? objAnti.CombinedMed.RowID : '');
			inputAnti = inputAnti + CHR_1 + objAnti.PreMedTime;
			inputAnti = inputAnti + CHR_1 + objAnti.PostMedDays;
			inputAnti = inputAnti + CHR_1 + '';
			
			var flg = obj.ClsInfReportAntiSrv.SaveSubRec(inputAnti, CHR_1);
			if (parseInt(flg) > 0) {
				//������ȷ
			} else {
				ExtTool.alert('������ʾ','������ҩ �������!���=' + indAnti + ',Error=' + flg);
				return false;
			}
		}
		
		//��֢�໤��Ϣ
		var inputICU = '';
		var arrICU = obj.CurrReport.ChildICU;
		for (var indICU = 0; indICU < arrICU.length; indICU++) {
			var objICU = arrICU[indICU];
			if (!objICU) continue;
			
			var RowID = objICU.RowID;
			var arrTmp = RowID.split("||");
			var SubID = (arrTmp.length == 2 ? arrTmp[1] : '');
			
			var InfPathogeny = '';  //��ԭ��
			for (var indPy = 0; indPy < objICU.InfPathogeny.length; indPy++) {
				var objPy = objICU.InfPathogeny[indPy];
				if (!objPy) continue;
				InfPathogeny = InfPathogeny + CHR_2 +objPy.PathogenyID + CHR_3 +objPy.PathogenyDesc;
			}
			if (InfPathogeny) InfPathogeny = InfPathogeny.substring(1,InfPathogeny.length);
			
			inputICU = obj.CurrReport.RowID;
			inputICU = inputICU + CHR_1 + SubID;
			inputICU = inputICU + CHR_1 + (objICU.IntubateType ? objICU.IntubateType.RowID : '');
			inputICU = inputICU + CHR_1 + objICU.IntubateDate;
			inputICU = inputICU + CHR_1 + objICU.IntubateTime;
			inputICU = inputICU + CHR_1 + objICU.ExtubateDate;
			inputICU = inputICU + CHR_1 + objICU.ExtubateTime;
			inputICU = inputICU + CHR_1 + (objICU.IntubatePlace ? objICU.IntubatePlace.RowID : '');
			inputICU = inputICU + CHR_1 + (objICU.IntubateUserType ? objICU.IntubateUserType.RowID : '');
			inputICU = inputICU + CHR_1 + (objICU.IntubateUser ? objICU.IntubateUser.Rowid : '');
			inputICU = inputICU + CHR_1 + objICU.InfDate;
			inputICU = inputICU + CHR_1 + InfPathogeny;
			inputICU = inputICU + CHR_1 + (objICU.PICCIntubatePos ? objICU.PICCIntubatePos.RowID : '');
			inputICU = inputICU + CHR_1 + (objICU.PICCIntubateSize ? objICU.PICCIntubateSize.RowID : '');
			inputICU = inputICU + CHR_1 + (objICU.PICCIntubateType ? objICU.PICCIntubateType.RowID : '');
			inputICU = inputICU + CHR_1 + (objICU.PICCIntubateNum ? objICU.PICCIntubateNum.RowID : '');
			inputICU = inputICU + CHR_1 + (objICU.PICCIntubateRegion ? objICU.PICCIntubateRegion.RowID : '');
			inputICU = inputICU + CHR_1 + (objICU.PICCExtubateReason ? objICU.PICCExtubateReason.RowID : '');
			inputICU = inputICU + CHR_1 + (objICU.UCUrineBagType ? objICU.UCUrineBagType.RowID : '');
			inputICU = inputICU + CHR_1 + (objICU.VAPIntubateType ? objICU.VAPIntubateType.RowID : '');
			inputICU = inputICU + CHR_1 + objICU.DataSource;
			//Add BY LiYang 2014-04-11 ���Ӹ�Ⱦ֢״�ֶ�
			inputICU = inputICU + CHR_1 + objICU.INFSymptom.RowID;
			var flg = obj.ClsInfReportICUSrv.SaveSubRec(inputICU, CHR_1 + ',' + CHR_2 + ',' + CHR_3);
			if (parseInt(flg) > 0) {
				//������ȷ
			} else {
				ExtTool.alert('������ʾ','��֢�໤��Ϣ �������!���=' + indICU + ',Error=' + flg);
				return false;
			}
		}
		
		return true;
	}
	
	//���浼��
	obj.ExportReport = function(ReportID){
		//ȡ��������
		var objPrtReport = obj.GetReport(ReportID);
		if (!objPrtReport.RowID) {
			ExtTool.alert("������ʾ", "���治����!", Ext.MessageBox.ERROR, Ext.MessageBox.OK);
			return;
		}
		//����״̬�ж�
		if (!objPrtReport.ReportStatus) {
			ExtTool.alert("������ʾ", "����״̬����!", Ext.MessageBox.ERROR, Ext.MessageBox.OK);
			return;
		} else {
			var ReportStatusCode = objPrtReport.ReportStatus.Code;
			var ReportStatusDesc = objPrtReport.ReportStatus.Description;
			//ֻ�����ӡ�ύ����˵ı���
			if ((ReportStatusCode != '2')&&(ReportStatusCode != '3')) {
				ExtTool.alert("��ܰ��ʾ", "<b>" + ReportStatusDesc + "</b>״̬���治�����ӡ!", Ext.MessageBox.ERROR, Ext.MessageBox.OK);
				return;
			}
		}
		//���������ж�
		if (!objPrtReport.ReportType) {
			ExtTool.alert("������ʾ", "�������ʹ���!");
			return;
		}
		if ((typeof(IsSecret)!="undefined")&&(IsSecret==1)) {//����ҽԺ��ӡʱҪ��¼����־��
			var aEpisodeID = objPrtReport.EpisodeID
			var SecretStr = ExtTool.RunServerMethod("DHCMed.SSIO.FromSecSrv","GetSecInfoByEpisodeID",aEpisodeID);  //ȡ�ܼ���Ϣ
			var SecretCode=SecretStr.split('^')[2];
			var RepCode = obj.CurrReport.ReportType.Code;
			var ModelName=""
			if (RepCode == "COMP") {
				ModelName="DHCMedInfReport";     //��־ģ�������д���
			}else if (RepCode == "OPR") {
				ModelName="DHCMedOprReport";
			}
						   
			var CReportID=objPrtReport.RowID
			var CReportStatus=objPrtReport.ReportStatus.Code
			var Condition="{ReportID:" +CReportID+"}";
			var Content="{EpisodeID:"+ aEpisodeID+",ReportID:"+ CReportID+",ReportStatus:"+ CReportStatus+"}";
						 
			var ret= ExtTool.RunServerMethod("DHCMed.SSIO.FromSecSrv","EventLog",ModelName,Condition,Content,SecretCode);
		}
		obj.ExportWord(objPrtReport);
	}
	
	return obj;
}

//���ø�����ҳ��ˢ��
function ParrefWindowRefresh_Handler(){
	//Modified By LiYang 2014-11-01 �����ж�2�����
	if (PortalFlag != 1) {
		if (typeof window.opener != "undefined"){
			if (typeof window.opener.WindowRefresh_Handler != "undefined"){
				window.opener.WindowRefresh_Handler();
				return;
			}
		} 
		
			if (window.parent) {
				if (typeof window.parent.WindowRefresh_Handler != "undefined"){
					window.parent.WindowRefresh_Handler();
				return;
				}
			}
			
	}
}
