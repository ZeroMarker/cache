function InitReportWin(){
	var obj = new Object();
	obj.OperID="";
	obj.objRegRet="";
	obj.objUnplanSur="";
	obj.cboSurgery = $HUI.combobox('#cboFirstSurgery', {
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'OperID',
		textField: 'OperDesc',
		//defaultFilter:"4",
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.IMP.IPS.OperCompRegSrv';
			param.QueryName = 'GetAnOpListForM';
			param.ResultSetType = 'array';
			param.EpisodeId=EpisodeID;
		}
	});  
	obj.cboSurgery = $HUI.combobox('#cboAgainSurgery', {
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'OperID',
		textField: 'OperDesc',
		//defaultFilter:"4",
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.IMP.IPS.OperCompRegSrv';
			param.QueryName = 'GetAnOpListForM';
			param.ResultSetType = 'array';
			param.EpisodeId=EpisodeID;
		}
	}); 
	obj.cboSurgery = $HUI.combobox('#againSurReason', {
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		//defaultFilter:"4",
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.BTS.DictionarySrv';
			param.QueryName = 'QryDictByType';
			param.aTypeCode= 'URTOperReason';
			param.aIsActive='1';
			param.ResultSetType = 'array';
		}
	}); 
	/*var RegRet = $m({
		ClassName:"DHCMA.IMP.IP.IMPRegister",
		MethodName:"GetObjectByEpisodeID",
		aEpisodeID:EpisodeID,
		aRegType:"2"
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
			aRegType:"2"
		}, false);
	}
	if (RegRet) {
		obj.objRegRet = JSON.parse(RegRet);
		var objRegRet = JSON.parse(RegRet);
		if(objRegRet){
			$cm({
				ClassName:"DHCMA.IMP.IP.URTOperReg",
				MethodName:"GetObjByRegisterDr",
				aRegisterDr:objRegRet.ID
			},function(objUnplanSur){
				obj.objUnplanSur=objUnplanSur
				var firstOperID = objUnplanSur.FirstOperID;
				var againOperID = objUnplanSur.ReoperID;
				$('#cboAgainSurgery').combobox("setValue",againOperID);	
				$('#cboFirstSurgery').combobox("setValue",firstOperID);
				obj.load_OperDate(EpisodeID,firstOperID,"firstSurgerylDate","firstSurDiagnos","firstSurgeryLvl","firstSurAnesMethod","firstSurOpertorName","firstSurAssistant1","firstSurAssistant2");
				obj.load_OperDate(EpisodeID,againOperID,"againSurgerylDate","againSurDiagnos","againtSurgeryLvl","againSurAnesMethod","againSurOpertorName","againSurAssistant1","againSurAssistant2");
				$('#firstSurState').val(objUnplanSur.FirstOperState);
				$('#againSurReason').combobox("setValue",objUnplanSur.ReoperReason);
				$('#againSurEstState').val(objUnplanSur.ReoperState);
				$('#againSurReasonAnalysis').val(objUnplanSur.ReoperCause);
				$('#againSurImprovement').val(objUnplanSur.Improvement);
				var ReportStatus = $m({
					ClassName:"DHCMA.Util.BT.Dictionary",
					MethodName:"GetObjById",
					aId:objRegRet.StatusDr
				}, false);
				var ReportStatusJson = JSON.parse(ReportStatus);
				
				if(ReportStatusJson.BTCode=="Submit"&tDHCMedMenuOper['Check']) {
					//$('#CheckInfo').css("display","");
					$('#btnCheck').css("display","");
					//var user = session['LOGON.USERNAME'];
					//$('#CheckDate').datebox('setValue', Common_GetDate(new Date()));
					//$('#CheckTime').timespinner('setValue',Common_GetTime(new Date()));
					//$('#CheckUser').val(user);
					$('#btnCheck').linkbutton("enable");
				}else if(ReportStatusJson.BTCode=="Check"){
					//$('#CheckInfo').css("display","");
					$('#btnCheck').css("display","none");
					$('#btnSave').css("display","none");
					$('#btnSave').linkbutton("disable");
					$('#btnCheck').linkbutton("disable");
					if(tDHCMedMenuOper['Check']){
						$('#btnCancelCheck').css("display","");
					}
					//$('#CheckOpinion').val(objRegRet.Opinion);
					/*var CheckDate=$m({                  
						ClassName:"DHCMed.SSService.CommonCls",
						MethodName:"DateLogicalToHtml",
						aDate:objRegRet.CheckDate
					},false);
					$('#CheckDate').datebox('setValue', CheckDate);
					var CheckTime=$m({
						ClassName:'DHCMed.SSService.CommonCls',
						MethodName:'ChangeTimeFormat',
						aValue:objRegRet.CheckTime
					},false);
					$('#CheckTime').timespinner('setValue',CheckTime);
					var userId = objRegRet.CheckUserID+"!!1";
					$cm({
						ClassName:'DHCMA.Util.EP.SSUser',
						MethodName:'GetObjByOID',
						aOID:userId
					},function(ret){
						var checkUser=ret.BTDesc
						$('#CheckUser').val(checkUser);
					});*/
				}
			});
		}
		
	}
	$.parser.parse();        // 解析整个页面
	InitReportWinEvent(obj);       
	obj.LoadEvent();
	return obj;        
}
