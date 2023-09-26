var is=0;
function InitReportEvent(obj)
{
	//初始化调用类
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
	
	//初始化报告页面
	obj.InitReport = function(){
		
		//初始化模块界面
		if (typeof obj.BASE_InitView == 'function') obj.BASE_InitView();            //(感)基本信息
		if (typeof obj.INFPOS_InitView == 'function') obj.INFPOS_InitView();        //(感)感染部位
		if (typeof obj.NBINF_InitView == 'function') obj.NBINF_InitView();          //(感)新生儿感染信息
		if (typeof obj.OPR_InitView == 'function') obj.OPR_InitView();              //(感)手术相关
		if (typeof obj.LAB_InitView == 'function') obj.LAB_InitView();              //(感)病原学检验
		if (typeof obj.ANTI_InitView == 'function') obj.ANTI_InitView();            //(感)抗菌药物
		if (typeof obj.IBASE_InitView == 'function') obj.IBASE_InitView();          //(目)ICU转科信息
		if (typeof obj.IDIAG_InitView == 'function') obj.IDIAG_InitView();          //(目)转入ICU诊断
		if (typeof obj.IPICC_InitView == 'function') obj.IPICC_InitView();          //(目)ICU中央导管
		if (typeof obj.IVAP_InitView == 'function') obj.IVAP_InitView();            //(目)ICU呼吸机
		if (typeof obj.IUC_InitView == 'function') obj.IUC_InitView();              //(目)ICU导尿管
		if (typeof obj.NBASE_InitView == 'function') obj.NBASE_InitView();          //(目)NICU转科信息
		if (typeof obj.NPICC_InitView == 'function') obj.NPICC_InitView();          //(目)NICU中央导管
		if (typeof obj.NVNT_InitView == 'function') obj.NVNT_InitView();            //(目)NICU气管插管
		if (typeof obj.NUC_InitView == 'function') obj.NUC_InitView();              //(目)NICU脐静脉
		if (typeof obj.OBASE_InitView == 'function') obj.OBASE_InitView();          //(目)手术基本信息
		if (typeof obj.OOPR_InitView == 'function') obj.OOPR_InitView();            //(目)手术切口信息
		if (typeof obj.ADIAG_InitView == 'function') obj.ADIAG_InitView();          //(目)基础疾病
		if (typeof obj.ALAB_InitView == 'function') obj.ALAB_InitView();            //(目)病原学检验
		if (typeof obj.AANTI_InitView == 'function') obj.AANTI_InitView();          //(目)抗菌药物
		
		//初始化按钮功能
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
			case "1" :    //保存
				obj.btnSave.setVisible(true);
				obj.btnSubmit.setVisible(true);
				obj.btnDelete.setVisible(true);
				break;
			case "2" :    //提交
				//obj.btnSubmit.setVisible(true);//FixBug:6250 公共卫生事件-医院感染报告-报告没有提交成功，通过【删除】按钮删除已录入的数据时，提示"“提交"状态的报告不能再删除数据”
				obj.btnCheck.setVisible((obj.AdminPower == 1));
				obj.btnReturn.setVisible((obj.AdminPower == 1));
				obj.btnDelete.setVisible(true);
				// update cpj 2014-12-20 修改tdbug 新生儿报告无模板，屏蔽掉导出按钮
				if ((obj.CurrReport.ReportType.Code == "NICU")||(obj.CurrReport.ReportType.Code == "NCOM")) {
					obj.btnExport.setVisible(false);
				} else {
					obj.btnExport.setVisible(true);
				}
				break;
			case "3" :    //审核
				obj.btnUpdoCheck.setVisible((obj.AdminPower == 1));
				// update cpj 2014-12-20 修改tdbug 新生儿报告无模板，屏蔽掉导出按钮
				if ((obj.CurrReport.ReportType.Code == "NICU")||(obj.CurrReport.ReportType.Code == "NCOM")){
					obj.btnExport.setVisible(false);
				} else {
					obj.btnExport.setVisible(true);
				}
				obj.btnIsCheck.setVisible((obj.AdminPower == 1));
				break;
			case "4" :    //取消审核
				obj.btnSave.setVisible(true);
				obj.btnSubmit.setVisible(true);
				obj.btnCheck.setVisible((obj.AdminPower == 1));
				obj.btnReturn.setVisible((obj.AdminPower == 1));
				obj.btnDelete.setVisible(true);
				break;
			case "5" :    //退回
				obj.btnSave.setVisible(true);
				obj.btnSubmit.setVisible(true);
				//obj.btnCheck.setVisible((obj.AdminPower == 1));	//Add By Jeff 20141220  FixBug:1986 修改退回状态的报告可直接审核的问题
				obj.btnDelete.setVisible(true);
				break;
			case "0" :    //删除
				break;
			default:
				obj.btnSave.setVisible(true);
				obj.btnSubmit.setVisible(true);
				break;
		}
		
		//保存功能暂时取消(类似草稿功能)
		obj.btnSave.setVisible(false);
	}
	
	//获取报告数据
	obj.GetReport = function(ReportID){
		if (ReportID == '') {
			var objInfReport = obj.ClsInfReportSrv.GetRepObj('');
			if (!objInfReport) {
				ExtTool.alert("提示","报告主表初始化错误!");
				return '';
			} else {
				//报告主表
				objInfReport.EpisodeID = EpisodeID;
				objInfReport.ObjectID = '';
				objInfReport.ReportType = obj.ClsSSDictionary.GetObjById(RepTypeID);
				if (!objInfReport.ReportType) {
					ExtTool.alert("提示","报告类型取值错误!Code=" + ReportType);
					return '';
				}
				objInfReport.ReportLoc = obj.ClsBaseCtloc.GetObjById(session['LOGON.CTLOCID']);
				objInfReport.ReportUser = obj.ClsBaseSSUser.GetObjById(session['LOGON.USERID']);
				//objInfReport.ReportDate = obj.ClsCommonClsSrv.ChangeDateFormat(objInfReport.ReportDate,3);
				objInfReport.ReportDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(objInfReport.ReportDate);
				objInfReport.ReportTime = obj.ClsCommonClsSrv.ChangeTimeFormat(objInfReport.ReportTime,2);
				if (objInfReport.ReportDate == '1840-12-31') {  //508 515版本存在这问题
					objInfReport.ReportDate ='';
					objInfReport.ReportTime ='';
				}
				//摘要信息
				objInfReport.ChildSumm = obj.ClsInfReportSummSrv.GetSubObj('');
				if (!objInfReport.ChildSumm) {
					ExtTool.alert("提示","摘要信息初始化错误!");
					return '';
				} else {
					objInfReport.ChildSumm.TransID = '';
					objInfReport.ChildSumm.TransLoc =  '';
					objInfReport.ChildSumm.InfFactors = new Array();
					objInfReport.ChildSumm.InvasiveOperation = new Array();
					objInfReport.ChildSumm.OutICUStatus = new Array();
					objInfReport.ChildSumm.OutICU48Status = new Array();
				}
				//子表信息
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
				ExtTool.alert("提示","报告主表取值错误!ReportID=" + ReportID);
				return '';
			} else {
				//报告主表
				objInfReport.ReportType = obj.ClsSSDictionary.GetObjById(objInfReport.ReportType);
				objInfReport.ReportLoc = obj.ClsBaseCtloc.GetObjById(objInfReport.ReportLoc);
				objInfReport.ReportUser = obj.ClsBaseSSUser.GetObjById(objInfReport.ReportUser);
				//objInfReport.ReportDate = obj.ClsCommonClsSrv.ChangeDateFormat(objInfReport.ReportDate,3);
				objInfReport.ReportDate = obj.ClsCommonClsSrv.ChangeDateFormatToHtml(objInfReport.ReportDate);
				objInfReport.ReportTime = obj.ClsCommonClsSrv.ChangeTimeFormat(objInfReport.ReportTime,2);
				objInfReport.ReportStatus = obj.ClsSSDictionary.GetObjById(objInfReport.ReportStatus);
				
				//摘要信息
				var strChild = obj.ClsInfReportSummSrv.GetSubRec(objInfReport.RowID);
				objInfReport.ChildSumm = obj.ClsInfReportSummSrv.GetSubObj(strChild);
				if (!objInfReport.ChildSumm) {
					ExtTool.alert("提示","摘要信息取值错误!ID=" + RecId);
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
				
				//疾病诊断
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
				
				//感染信息
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
						//if (objChild.InfEndDate) objChild.InfEndDate = obj.ClsCommonClsSrv.ChangeDateFormat(objChild.InfEndDate,3); //Add By LiYang 2013-05-18 获取感染结束日期
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
				
				//手术相关
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
				
				//病原学检验
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
				
				//抗菌用药
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
				
				//重症监护信息
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
	
	//保存报告状态(只对状态进行操作,不做其他处理)
	obj.SaveRepStatus = function(){
		//设置报告操作状态
		obj.CurrReport.ReportStatus = obj.ClsSSDictionary.GetByTypeCode("NINFInfReportStatus",arguments[0],"");
		if (!obj.CurrReport.ReportStatus) {
			ExtTool.alert('错误提示','报告状态错误!');
			return false;
		}
		
		var logResume = '';
		if (arguments.length >= 2) {
			logResume = arguments[1];
		}
		
		//报告状态+日志信息
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
			ExtTool.alert('错误提示','报告状态 保存错误!Error=' + flg);
			return false;
		}
		return true;
	}
	
	//保存报告
	obj.SaveReport = function(){
		//设置报告操作状态
		obj.CurrReport.ReportStatus = obj.ClsSSDictionary.GetByTypeCode("NINFInfReportStatus",arguments[0],"");
		if (!obj.CurrReport.ReportStatus) {
			ExtTool.alert('错误提示','报告状态错误!');
			return false;
		}
		
		obj.CurrReport.ChildDiag   = new Array();
		obj.CurrReport.ChildInfPos = new Array();
		obj.CurrReport.ChildOpr    = new Array();
		obj.CurrReport.ChildLab    = new Array();
		obj.CurrReport.ChildAnti   = new Array();
		obj.CurrReport.ChildICU   = new Array();
		
		//获取报告数据(存储到"obj.CurrReport"对象中)，并检查数据完整性
		var errinfo = '';
		if (typeof obj.BASE_SaveData == 'function') {
			errinfo = errinfo + obj.BASE_SaveData();             //(感)基本信息
		}
		if (typeof obj.INFPOS_SaveData == 'function') {
			errinfo = errinfo + obj.INFPOS_SaveData();           //(感)感染部位
		}
		if (typeof obj.NBINF_SaveData == 'function') {
			errinfo = errinfo + obj.NBINF_SaveData();            //(感)新生儿感染信息
		}
		if (typeof obj.OPR_SaveData == 'function') {
			errinfo = errinfo + obj.OPR_SaveData();              //(感)手术相关
		}
		if (typeof obj.LAB_SaveData == 'function') {
			errinfo = errinfo + obj.LAB_SaveData();              //(感)病原学检验
		}
		if (typeof obj.ANTI_SaveData == 'function') {
			errinfo = errinfo + obj.ANTI_SaveData();             //(感)抗菌药物
		}
		if (typeof obj.IBASE_SaveData == 'function') {
			errinfo = errinfo + obj.IBASE_SaveData();            //(目)ICU转科信息
		}
		if (typeof obj.IDIAG_SaveData == 'function') {
			errinfo = errinfo + obj.IDIAG_SaveData();            //(目)ICU转入ICU诊断
		}
		if (typeof obj.IPICC_SaveData == 'function') {
			errinfo = errinfo + obj.IPICC_SaveData();            //(目)ICU中央导管
		}
		if (typeof obj.IVAP_SaveData == 'function') {
			errinfo = errinfo + obj.IVAP_SaveData();             //(目)ICU呼吸机
		}
		if (typeof obj.IUC_SaveData == 'function') {
			errinfo = errinfo + obj.IUC_SaveData();              //(目)ICU导尿管
		}
		if (typeof obj.NBASE_SaveData == 'function') {
			errinfo = errinfo + obj.NBASE_SaveData();            //(目)NICU转科信息
		}
		if (typeof obj.NPICC_SaveData == 'function') {
			errinfo = errinfo + obj.NPICC_SaveData();           //(目)NICU中央导管
		}
		if (typeof obj.NVNT_SaveData == 'function') {
			errinfo = errinfo + obj.NVNT_SaveData();             //(目)NICU气管插管
		}
		if (typeof obj.NUC_SaveData == 'function') {
			errinfo = errinfo + obj.NUC_SaveData();             //(目)NICU脐静脉
		}
		if (typeof obj.OBASE_SaveData == 'function') {
			errinfo = errinfo + obj.OBASE_SaveData();            //(目)OPR基本信息
		}
		if (typeof obj.OOPR_SaveData == 'function') {
			errinfo = errinfo + obj.OOPR_SaveData();             //(目)OPR手术切口
		}
		if (typeof obj.ADIAG_SaveData == 'function') {
			errinfo = errinfo + obj.ADIAG_SaveData();             //(目)基础疾病
		}
		if (typeof obj.ALAB_SaveData == 'function') {
			errinfo = errinfo + obj.ALAB_SaveData();             //(目)病原学检验
		}
		if (typeof obj.AANTI_SaveData == 'function') {
			errinfo = errinfo + obj.AANTI_SaveData();            //(目)抗菌药物
		}
		//保存（草稿）状态，不检查数据完整性
		if ((errinfo)&&(obj.CurrReport.ReportStatus.Code != '1')) {
			ExtTool.alert('提示',errinfo);
			return false;
		}
		//add cpj 2014-12-20 修改tdbug：1710 icu,NICU 报告提交时若没有填写三管信息,不能提交三管信息
		if ((obj.CurrReport.ReportType.Code == "NICU") || (obj.CurrReport.ReportType.Code == "ICU")) {
			if (obj.CurrReport.ChildICU.length < 1) {
				ExtTool.alert('提示',"请增加插管信息");
				return false;
			}
		}
		
		//报告主表内容+日志信息
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
			ExtTool.alert('错误提示','报告主表 保存错误!Error=' + flg);
			return false;
		}
		
		//摘要信息
		var objSumm = obj.CurrReport.ChildSumm;
		var InfFactors = '';  //易感因素
		for (var ind = 0; ind < objSumm.InfFactors.length; ind++) {
			var objDic = objSumm.InfFactors[ind];
			if (!objDic) continue;
			InfFactors = InfFactors + CHR_2 +objDic.RowID;
		}
		if (InfFactors) InfFactors = InfFactors.substring(1,InfFactors.length);
		
		var InvasiveOper = '';   //侵害性操作
		for (var ind = 0; ind < objSumm.InvasiveOperation.length; ind++) {
			var objDic = objSumm.InvasiveOperation[ind];
			if (!objDic) continue;
			InvasiveOper = InvasiveOper + CHR_2 + objDic.RowID;
		}
		if (InvasiveOper) InvasiveOper = InvasiveOper.substring(1,InvasiveOper.length);
		
		var OutICUStatus = '';     //转出ICU时状态(带管情况)
		for (var ind = 0; ind < objSumm.OutICUStatus.length; ind++) {
			var objDic = objSumm.OutICUStatus[ind];
			if (!objDic) continue;
			OutICUStatus = OutICUStatus + CHR_2 + objDic.RowID;
		}
		if (OutICUStatus) OutICUStatus = OutICUStatus.substring(1,OutICUStatus.length);
		
		var OutICU48Status = '';   //转出ICU48小时内状态(带管情况)
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
		//Add By LiYang 2014-04-09 增加ApacheII评分项目
		inputSumm = inputSumm + CHR_1 + objSumm.ApacheIIScore;
		
		//add by zf 2017-07-25 增加易感因素和侵害性操作备注
		inputSumm = inputSumm + CHR_1 + objSumm.InfFactorsTxt;  //易感因素备注
		inputSumm = inputSumm + CHR_1 + objSumm.InvasiveOperTxt;  //侵害性操作备注

		var flg = obj.ClsInfReportSummSrv.SaveSubRec(inputSumm, CHR_1 + ',' + CHR_2);
		if (parseInt(flg) > 0) {
			//保存正确
		} else {
			ExtTool.alert('错误提示','摘要信息 保存错误!Error=' + flg);
			return false;
		}
		
		//疾病诊断
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
				//保存正确
			} else {
				ExtTool.alert('错误提示','疾病诊断 保存错误!Error=' + flg);
				return false;
			}
		}
		
		//感染信息
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
			inputInfPos = inputInfPos + CHR_1 + objInfPos.InfEndDate;   //感染结束时间
			inputInfPos = inputInfPos + CHR_1 + objInfPos.InfEndResult; //感染转归
			inputInfPos = inputInfPos + CHR_1 + objInfPos.DiagnosisBasis;
			inputInfPos = inputInfPos + CHR_1 + objInfPos.DiseaseCourse;
			inputInfPos = inputInfPos + CHR_1 + (objInfPos.InfDiagCat ? objInfPos.InfDiagCat.RowID : '');   //感染诊断子分类
			
			var flg = obj.ClsInfReportInfPosSrv.SaveSubRec(inputInfPos, CHR_1 + ',' + CHR_2 + ',' + CHR_3);
			if (parseInt(flg) > 0) {
				//保存正确
			} else {
				ExtTool.alert('错误提示','感染信息 保存错误!序号=' + indPos + ',Error=' + flg);
				return false;
			}
		}
		
		//手术信息
		var inputOpr = '';
		var arrOpr = obj.CurrReport.ChildOpr;
		for (var indOpr = 0; indOpr < arrOpr.length; indOpr++) {
			var objOpr = arrOpr[indOpr];
			if (!objOpr) continue;
			
			var RowID = objOpr.RowID;
			var arrTmp = RowID.split("||");
			var SubID = (arrTmp.length == 2 ? arrTmp[1] : '');
			
			var PostoperComps = '';   //侵害性操作
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
				//保存正确
			} else {
				ExtTool.alert('错误提示','手术信息 保存错误!序号=' + indOpr + ',Error=' + flg);
				return false;
			}
		}
		
		//病原学检验
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
				//保存正确
			} else {
				ExtTool.alert('错误提示','病原学检验 保存错误!序号=' + indLab + ',Error=' + flg);
				return false;
			}
		}
		
		//抗菌用药
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
				//保存正确
			} else {
				ExtTool.alert('错误提示','抗菌用药 保存错误!序号=' + indAnti + ',Error=' + flg);
				return false;
			}
		}
		
		//重症监护信息
		var inputICU = '';
		var arrICU = obj.CurrReport.ChildICU;
		for (var indICU = 0; indICU < arrICU.length; indICU++) {
			var objICU = arrICU[indICU];
			if (!objICU) continue;
			
			var RowID = objICU.RowID;
			var arrTmp = RowID.split("||");
			var SubID = (arrTmp.length == 2 ? arrTmp[1] : '');
			
			var InfPathogeny = '';  //病原体
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
			//Add BY LiYang 2014-04-11 增加感染症状字段
			inputICU = inputICU + CHR_1 + objICU.INFSymptom.RowID;
			var flg = obj.ClsInfReportICUSrv.SaveSubRec(inputICU, CHR_1 + ',' + CHR_2 + ',' + CHR_3);
			if (parseInt(flg) > 0) {
				//保存正确
			} else {
				ExtTool.alert('错误提示','重症监护信息 保存错误!序号=' + indICU + ',Error=' + flg);
				return false;
			}
		}
		
		return true;
	}
	
	//报告导出
	obj.ExportReport = function(ReportID){
		//取报告数据
		var objPrtReport = obj.GetReport(ReportID);
		if (!objPrtReport.RowID) {
			ExtTool.alert("错误提示", "报告不存在!", Ext.MessageBox.ERROR, Ext.MessageBox.OK);
			return;
		}
		//报告状态判断
		if (!objPrtReport.ReportStatus) {
			ExtTool.alert("错误提示", "报告状态错误!", Ext.MessageBox.ERROR, Ext.MessageBox.OK);
			return;
		} else {
			var ReportStatusCode = objPrtReport.ReportStatus.Code;
			var ReportStatusDesc = objPrtReport.ReportStatus.Description;
			//只允许打印提交或审核的报告
			if ((ReportStatusCode != '2')&&(ReportStatusCode != '3')) {
				ExtTool.alert("温馨提示", "<b>" + ReportStatusDesc + "</b>状态报告不允许打印!", Ext.MessageBox.ERROR, Ext.MessageBox.OK);
				return;
			}
		}
		//报告类型判断
		if (!objPrtReport.ReportType) {
			ExtTool.alert("错误提示", "报告类型错误!");
			return;
		}
		if ((typeof(IsSecret)!="undefined")&&(IsSecret==1)) {//涉密医院打印时要记录到日志里
			var aEpisodeID = objPrtReport.EpisodeID
			var SecretStr = ExtTool.RunServerMethod("DHCMed.SSIO.FromSecSrv","GetSecInfoByEpisodeID",aEpisodeID);  //取密级信息
			var SecretCode=SecretStr.split('^')[2];
			var RepCode = obj.CurrReport.ReportType.Code;
			var ModelName=""
			if (RepCode == "COMP") {
				ModelName="DHCMedInfReport";     //日志模块配置中代码
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

//调用父窗体页面刷新
function ParrefWindowRefresh_Handler(){
	//Modified By LiYang 2014-11-01 依次判断2种情况
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
