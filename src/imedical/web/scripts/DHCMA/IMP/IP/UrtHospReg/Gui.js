function InitReportWin(){
	var obj = new Object();
	obj.OperID="";
	obj.objRegRet="";
	obj.objURTHosp="";
	obj.aEpisodeID=EpisodeID;
		
	/*var RegRet = $m({
		ClassName:"DHCMA.IMP.IP.IMPRegister",
		MethodName:"GetObjectByEpisodeID",
		aEpisodeID:EpisodeID,
		aRegType:"3"
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
			aRegType:"3"
		}, false);
	}
	if (RegRet) {
		obj.objRegRet = JSON.parse(RegRet);
		var objRegRet = JSON.parse(RegRet);
		if(objRegRet){
			obj.aEpisodeID=objRegRet.EpisodeID;
			$cm({
				ClassName:"DHCMA.IMP.IP.URTHospReg",
				MethodName:"GetObjByRegisterDr",
				aRegisterDr:objRegRet.ID
			},function(objURTHosp){
				obj.objURTHosp=objURTHosp
				var reInHospDate = objURTHosp.ReInHospDate
				var readmissionWay = objURTHosp.ReadmissionWay
				var firstHospSituation = objURTHosp.FirstHospSituation
				var firstDischSituation = objURTHosp.FirstDischSituation
				var saveDate = objRegRet.RegDate
				var saveTime = objRegRet.RegTime
				var readmissionReason = objURTHosp.ReadmissionReason
				var preventionMeasures = objURTHosp.PreventionMeasures
				
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
				
				$('#firstHospSituation').val(firstHospSituation);
				$('#firstDischSituation').val(firstDischSituation);
				$('#readmissionReason').val(readmissionReason);
				$('#preventionMeasures').val(preventionMeasures);
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
				if(ReportStatusJson.BTCode=="Submit"&tDHCMedMenuOper['Check']){	
					
					$('#btnCheck').css("display","");
					$('#btnCheck').linkbutton("enable");
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
