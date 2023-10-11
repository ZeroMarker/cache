function InitReportWin(){
	var obj = new Object();
	obj.objRegRet="";
	obj.objCriticalReg=""; 
	
	/*var RegRet = $m({
		ClassName:"DHCMA.IMP.IP.IMPRegister",
		MethodName:"GetObjectByEpisodeID",
		aEpisodeID:EpisodeID,
		aRegType:"4"
	}, false);*/
	if(IMPOrdNo!=""&&"undefined"!=IMPOrdNo){
		obj.IMPOrdNo=IMPOrdNo;
		obj.RecordRet = $m({
			ClassName:"DHCMA.IMP.IP.IMPRecord",
			MethodName:"GetObjByEpisodeIDAndCategory",
			aEpisodeID:EpisodeID,
			aCategory:CategoryDR,
			aIMPOrdNo:IMPOrdNo
		}, false);
	}
	if(obj.RecordRet){
		obj.objRecordRet = JSON.parse(obj.RecordRet);
		var RegRet = $m({
			ClassName:"DHCMA.IMP.IP.IMPRegister",
			MethodName:"GetObjectByRecordDr",
			aIMPRecordDr:obj.objRecordRet.ID,
			aRegType:"4"
		}, false);
	}
	if (RegRet) {
		obj.objRegRet = JSON.parse(RegRet);
		var objRegRet = JSON.parse(RegRet);
		if(objRegRet){
			$cm({
				ClassName:"DHCMA.IMP.IP.CriticalIllReg",
				MethodName:"GetObjByRegisterDr",
				aRegisterDr:objRegRet.ID
			},function(objCriticalReg){
				obj.objCriticalReg=objCriticalReg
				var briefCaseRecord = objCriticalReg.BriefCaseRecord
				var assistInspect  = objCriticalReg.AssistInspect
				var clinicalDiagnosis = objCriticalReg.ClinicalDiagnosis
				var mainProblem = objCriticalReg.MainProblem
				var efficacyAssessment = objCriticalReg.EfficacyAssessment
				var compAndMeasures = objCriticalReg.CompAndMeasures
				var nursingPoint = objCriticalReg.NursingPoint
				var saveDate = objRegRet.RegDate
				var saveTime = objRegRet.RegTime
				
				var saveDateDesc=$m({                  
					ClassName:"DHCMed.SSService.CommonCls",
					MethodName:"DateLogicalToHtml",
					aDate:saveDate
				},false);
				var saveTimeDesc = $m({                  
					ClassName:"DHCMed.SSService.CommonCls",
					MethodName:'ChangeTimeFormat',
					aValue:saveTime
				},false);
				
				$('#briefCaseRecord').val(briefCaseRecord);
				$('#assistInspect').val(assistInspect);
				$('#clinicalDiagnosis').val(clinicalDiagnosis);
				$('#mainProblem').val(mainProblem);
				$('#efficacyAssessment').val(efficacyAssessment);
				$('#compAndMeasures').val(compAndMeasures);
				$('#nursingPoint').val(nursingPoint);
				$('#saveDate').val(saveDateDesc);
				$('#saveTime').val(saveTimeDesc);
				
				var ReportStatus = $m({
					ClassName:"DHCMA.Util.BT.Dictionary",
					MethodName:"GetObjById",
					aId:objRegRet.StatusDr
				}, false);
				
				var ReportStatusJson = JSON.parse(ReportStatus);
				var StatusDesc ="";
				if(ReportStatusJson){
						StatusDesc=$m({
								ClassName:"web.DHCBL.Authorize.BDPTranslation",
								MethodName:"GetTransDesc",
								TableName:"DHCMA.Util.BT.Dictionary",
								FieldName:"BTDesc",
								Languages:session['LOGON.LANGCODE'],
								FieldDesc:ReportStatusJson.BTDesc
							},false)
					}
				$('#statusFlag').val(StatusDesc);
				var user = session['LOGON.USERNAME'];
				
				
				if(ReportStatusJson.BTCode=="Submit"&tDHCMedMenuOper['Check']){
					$('#btnCheck').linkbutton("enable");
					$('#btnCheck').css("display","");
				}else if(ReportStatusJson.BTCode=="Check"){
					$('#btnCheck').css("display","none");
					$('#btnSave').css("display","none");
					$('#btnSave').linkbutton("disable");
					$('#btnCheck').linkbutton("disable");
					if(tDHCMedMenuOper['Check']){
						$('#btnCancelCheck').css("display","");
					}
				}
			});
		}
		
	}else{
		$('#saveDate').val(Common_GetDate(new Date()));
		$('#saveTime').val(Common_GetTime(new Date()));
	}
	
	$.parser.parse();        // 解析整个页面
	InitReportWinEvent(obj);       
	obj.LoadEvent();
	return obj;        
}
