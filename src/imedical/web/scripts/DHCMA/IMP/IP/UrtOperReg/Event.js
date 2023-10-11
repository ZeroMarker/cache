function InitReportWinEvent(obj) {
	//alert(obj.OperID);
	obj.ActLoc="";
	obj.Ward="";
	obj.ActDoc="";
	obj.LoadEvent = function(){
		obj.DisplayRepInfo();
		obj.RelationToEvents(); // 按钮监听事件 
	}	
	//显示数据
	obj.DisplayRepInfo = function(){
		if(EpisodeID!=""){
			var PatientAdmCls = $cm({
				ClassName:"DHCMed.Base.PatientAdm",
				MethodName:"GetObjById",
				paadm:EpisodeID
			},false);
			
			$('#txtPatientNo').text(PatientAdmCls.MrNo);             //病案号
			$('#txtLoc').text(PatientAdmCls.Department);		  		//科室
			$('#txtWard').text(PatientAdmCls.Ward);					//病房
			$("#txtIndih").text(PatientAdmCls.AdmitDate);
			/*$HUI.datebox("#txtIndih",{
				value:PatientAdmCls.AdmitDate
			});*/
			obj.ActLoc=PatientAdmCls.DepartmentID; //科室ID
			obj.Ward=PatientAdmCls.WardID;         //病房ID
			obj.ActDoc=PatientAdmCls.DoctorID;     //主管医生ID
			var aPatientID = PatientAdmCls.PatientID
			if(aPatientID!=""){
				
				var PatientCls = $cm({
					ClassName:"DHCMed.Base.Patient",
					MethodName:"GetObjById",
					PAPMIRowId:aPatientID
				},false);
					
				$('#txtPatName').text(PatientCls.PatientName);           //姓名
				$('#txtPatSex').text(PatientCls.Sex);                    //性别
				/*if (PatientCls.Sex == '女') {
					$('#Sex').removeClass('man').addClass('woman');		
				} else if(Sex == '男')  {
					$('#Sex').removeClass('woman').addClass('man');
				} else{
					$('#Sex').removeClass('man').removeClass('woman').addClass('unknowgender');;
				}*/
				var AgeY=PatientCls.Age;
				var AgeM=PatientCls.AgeMonth;
				var AgeD=PatientCls.AgeDay;
				if (AgeY>0){
					$('#txtPatAge').text(PatientCls.Age);
					$('#cboPatAgeDW').text($g('岁'));
				}else if(AgeM>0){
					$('#txtPatAge').text(PatientCls.AgeMonth);
					$('#cboPatAgeDW').text($g('月'));
				}else {
					$('#txtPatAge').text(PatientCls.AgeDay);
					$('#cboPatAgeDW').text($g('天'));
				}
				
			}
			var AdmDiagnosStr = $m({
				ClassName:"DHCMA.IMP.IPS.OperCompRegSrv",
				MethodName:"GetAdmDiagnos",
				aEpisodeID:EpisodeID
			},false);
			if(AdmDiagnosStr!=""){
				var arrDiagnos=AdmDiagnosStr.split("^");
				$('#txtAdmDiagnos').text(arrDiagnos[2]);
			}
		}
	};
	
	// 按钮触发事件
	obj.RelationToEvents = function() {
		$('#btnSave').on("click", function(){
			obj.btnSave_click(); 
		});
		$('#btnCancle').on("click", function(){
			obj.btnCancle_click(); 
		});
		$('#btnCheck').on("click",function(){
			obj.btnCheck_click();
		});
		$('#btnCancelCheck').on("click",function(){
			obj.btnCancelCheck_click();
		});
		$HUI.combobox('#cboFirstSurgery',{
			onChange:function(e,value){
				var OperID = $("#cboFirstSurgery").combobox("getValue");
				var aEpisodeID = EpisodeID;
				obj.load_OperDate(aEpisodeID,OperID,"firstSurgerylDate","firstSurDiagnos","firstSurgeryLvl",
								"firstSurAnesMethod","firstSurOpertorName","firstSurAssistant1","firstSurAssistant2");
            }
		});
		$HUI.combobox('#cboAgainSurgery',{
			onChange:function(e,value){
				var OperID = $("#cboAgainSurgery").combobox("getValue");
				var aEpisodeID = EpisodeID;
				obj.load_OperDate(aEpisodeID,OperID,"againSurgerylDate","againSurDiagnos","againtSurgeryLvl",
								"againSurAnesMethod","againSurOpertorName","againSurAssistant1","againSurAssistant2");
            }
		});
		
	}	
	obj.load_OperDate = function(aEpisodeID,OperID,dateId,diagnosId,lvlId,AnesId,OperNameId,ass1Id,ass2Id){
		var ret = $m({
			ClassName:"DHCMA.IMP.IPS.OperCompRegSrv",
			MethodName:"GetOperDate",
			"aEpisodeID":aEpisodeID,
			"aOperID":OperID
		},false);
		if(ret){
			var OperArr = ret.split("^");
			$HUI.datebox("#"+dateId,{
				value:OperArr[0]
			});
			$("#"+diagnosId).val(OperArr[2]);
			$("#"+lvlId).val(OperArr[1]);
			$('#'+AnesId).val(OperArr[3]);
			$('#'+OperNameId).val(OperArr[4]);
			$('#'+ass1Id).val(OperArr[5]);
			$('#'+ass2Id).val(OperArr[6]);	
		}

	}
	//保存
	obj.btnSave_click = function(){
		var IMPRegID="";
		var aEpisodeID=EpisodeID;
		var aRegId="";
		var RegUser = session['LOGON.USERID'];
		var RegDate ="";
		var RegTime ="";
		var FirstSurID = $('#cboFirstSurgery').combobox("getValue");
		var FirstSurState = $('#firstSurState').val();
		var AgainSurID  = $('#cboAgainSurgery').combobox("getValue");
		var AgainSurReason = $('#againSurReason').combobox("getValue");
		var AgainSurEstState = $('#againSurEstState').val();
		var AgainSurReasonAnalysis = $('#againSurReasonAnalysis').val();
		var AgainSurImprovement = $('#againSurImprovement').val();
		var ReportStatus = "Submit";
		if(typeof FirstSurID=="undefined"||FirstSurID==""){
			$.messager.popover({msg: $g('首次手术不能为空！'),type:'error'});
			return false;
		}else if(typeof FirstSurState=="undefined"||FirstSurState==""){
			$.messager.popover({msg: $g('首次手术术中及术后情况不能为空！'),type:'error'});
			return false;
		}else if(typeof AgainSurID=="undefined"||AgainSurID==""){
			$.messager.popover({msg: $g('再次手术不能为空！'),type:'error'});
			return false;
		}else if(FirstSurID==AgainSurID){
			$.messager.popover({msg: $g('再次手术不能与首次手术相同！'),type:'error'});
			return false;
		}else if(typeof AgainSurReason=="undefined"||""==AgainSurReason){
			$.messager.popover({msg: $g('再次手术原因不能为空！'),type:'error'});
			return false;
		}else if(typeof AgainSurEstState=="undefined"||""==AgainSurEstState){
			$.messager.popover({msg: $g('再次手术后患者情况不能为空！'),type:'error'});
			return false;
		}else if(typeof AgainSurReasonAnalysis=="undefined"||""==AgainSurReasonAnalysis){
			$.messager.popover({msg: $g('再次手术原因分析不能为空！'),type:'error'});
			return false;
		}else if(typeof AgainSurImprovement=="undefined"||""==AgainSurImprovement){
			$.messager.popover({msg: $g('持续改进措施不能为空！'),type:'error'});
			return false;
		}
		
		
		var IMPRegID="";
		var IMPRecordID="";
		if(obj.objRegRet){
			//var IMPRegisterJson = JSON.parse(obj.objRegRet)
      		IMPRegID=obj.objRegRet.ID;
      		IMPRecordID=obj.objRegRet.IMPRecordDr
      		
		}
		//筛查记录表
		var LnkEpisInfo=obj.objRecordRet.LnkEpisInfo;
		var LnkOperInfo=obj.objRecordRet.LnkOperInfo;
		var IMPCateDr=obj.objRecordRet.IMPCateDr;
		var IMPOrdNo=obj.IMPOrdNo;
		var IMPKeywords="";
		var IMPReasonDr=obj.objRecordRet.IMPReasonDr;
		var OccuLocID=obj.ActLoc;
		var OccuWardID=obj.Ward;
		var OccuDocID=obj.ActDoc;
		var HappenDate="";
		var HappenTime="";
		var Status=obj.objRecordRet.StatusDr;
		var Opinion="";
		var ActDate="";
		var ActTime="";
		var ActUserID=session['LOGON.USERID'];
		
		
		if(IMPCateDr==""||"undefined"==IMPCateDr){
			var IMPCateRet =$m({
				ClassName:"DHCMA.IMP.BT.IMPCategory",
				MethodName:"GetObjByCode",
				aCode:"02"
			}, false);
			if(IMPCateRet){
				var IMPCateRetJson=JSON.parse(IMPCateRet);
				IMPCateDr=IMPCateRetJson.ID;
			}
		}
		if(IMPOrdNo==""||IMPOrdNo=="undefined"){
			var  IMPOrdNoRet =$m({
				ClassName:"DHCMA.IMP.Task.IMPScreeningSrv",
				MethodName:"getOrdNo",
				aEpisodeID:aEpisodeID,
				aCateDr:IMPCateDr
			}, false);
			if(IMPOrdNoRet){
				IMPOrdNo=IMPOrdNoRet;
			}
		}
		if(IMPRecordID==""){
			var retRecord = $m({
				ClassName:"DHCMA.IMP.IP.IMPRecord",
				MethodName:"GetObjByEpisodeIDAndCategory",
				"aEpisodeID":aEpisodeID,
				"aCategory":IMPCateDr,
				"aIMPOrdNo":IMPOrdNo
			},false);
			if(retRecord){
				retJson = JSON.parse(retRecord);
				IMPRecordID=retJson.ID;
			};
		}
		if(Status==""||"undefined"==Status){
			var IMPStatus = $m({
				ClassName:"DHCMA.Util.BT.Dictionary",
				MethodName:"GetObjByPCodeItemDesc",
				PCode:"IMPStatus",
				Alias:"手动标记"
			}, false);
			if(IMPStatus){
				var IMPStatusJson = JSON.parse(IMPStatus);
				Status= IMPStatusJson.ID;
			}
		}
		var HappenDateAndTime = $m({
			ClassName:"DHCMA.IMP.Task.IMPScreeningSrv",
			MethodName:"getHappenDateAndTime",
			aEpisodeID:EpisodeID,
			aCateDr:IMPCateDr
		}, false);
		if(HappenDateAndTime){
			var index=HappenDateAndTime.indexOf(",");
			var end=HappenDateAndTime.length;
			var HappenDate = HappenDateAndTime.substring(0,index);
			var HappenTime = HappenDateAndTime.substring(index+1,end);
		}
		
		var InputStr = IMPRecordID+"^";
		InputStr=InputStr+EpisodeID+"^";
		InputStr=InputStr+LnkEpisInfo+"^";
		InputStr=InputStr+LnkOperInfo+"^"
		InputStr=InputStr+IMPCateDr+"^";
		InputStr=InputStr+IMPOrdNo+"^";
		InputStr=InputStr+IMPKeywords+"^";
		InputStr=InputStr+IMPReasonDr+"^";
		InputStr=InputStr+OccuLocID+"^";
		InputStr=InputStr+OccuWardID+"^";
		InputStr=InputStr+OccuDocID+"^";
		InputStr=InputStr+HappenDate+"^";
		InputStr=InputStr+HappenTime+"^";
		InputStr=InputStr+Status+"^";
		InputStr=InputStr+Opinion+"^";
		InputStr=InputStr+ActDate+"^";
		InputStr=InputStr+ActTime+"^";
		InputStr=InputStr+ActUserID;
		InputStr=InputStr+0;		//是否自动标记
		var IMPRecordRet =$m({
			ClassName:"DHCMA.IMP.IP.IMPRecord",
			MethodName:"Update",
			aInputStr:InputStr
		}, false);
		//登记主表
		if(IMPRecordRet>0){
			var RegStatusID="";
      var RegStatusCode="";
			var Opinion="";
			var RegDate="";
			var RegTime="";
			var RegUserID=session['LOGON.USERID'];
			var CheckDate="";
			var CheckTime="";
			var CheckUserID="";
			var IMPRecordDr=IMPRecordRet;
			
			var RegStatus =$m({
				ClassName:"DHCMA.Util.BT.Dictionary",
				MethodName:"GetObjByPCodeItemDesc",
				PCode:"IMPRegStatus",
				Alias:"提交"
			}, false);
			if(RegStatus!=""){
				RegStatusID=JSON.parse(RegStatus).ID
        RegStatusCode = JSON.parse(RegStatus).BTCode;
			}
			
			var InputStr = IMPRegID+"^";
			InputStr=InputStr+EpisodeID+"^";
			InputStr=InputStr+"2"+"^";
			InputStr=InputStr+RegStatusID+"^"
			InputStr=InputStr+Opinion+"^";
			InputStr=InputStr+RegDate+"^";
			InputStr=InputStr+RegTime+"^";
			InputStr=InputStr+RegUserID+"^";
			InputStr=InputStr+CheckDate+"^";
			InputStr=InputStr+CheckTime+"^";
			InputStr=InputStr+CheckUserID+"^";
			InputStr=InputStr+IMPRecordDr+"^";
			var IMPRegRet =$m({
				ClassName:"DHCMA.IMP.IP.IMPRegister",
				MethodName:"Update",
				aInputStr:InputStr
			}, false);
			if(IMPRegRet>0){
				var LogInputStr = IMPRegRet+"^";
					LogInputStr = LogInputStr+"^";
					LogInputStr = LogInputStr+RegStatusID+"^";
					LogInputStr = LogInputStr+Opinion+"^";
					LogInputStr = LogInputStr+"^";
					LogInputStr = LogInputStr+"^";
					LogInputStr = LogInputStr+session['LOGON.USERID'];
				var retLog =$m({
					ClassName:"DHCMA.IMP.IP.IMPRegisterLog",
					MethodName:"Update",
					aInputStr:LogInputStr
				}, false);				
				//更新记录并发症登记表
				var URTOperRegID="";
				if(obj.objUnplanSur){
					//var OperCompJson = JSON.parse(obj.OperCompl);
					URTOperRegID=obj.objUnplanSur.ID;
				}
				var RegisterDr=IMPRegRet;
				var FirstOperID=FirstSurID;
				var FirstOperState=FirstSurState;
				var ReoperID=AgainSurID;
				var ReoperReason=AgainSurReason;
				var ReoperState=AgainSurEstState;
				var ReoperCause=AgainSurReasonAnalysis;
				var Improvement =AgainSurImprovement;
				
				var InputStr = URTOperRegID+"^";
				InputStr=InputStr+RegisterDr+"^";
				InputStr=InputStr+FirstOperID+"^";
				InputStr=InputStr+FirstOperState+"^";
				InputStr=InputStr+ReoperID+"^";
				InputStr=InputStr+ReoperReason+"^";
				InputStr=InputStr+ReoperState+"^";
				InputStr=InputStr+ReoperCause+"^";
				InputStr=InputStr+Improvement;
				var ret =$m({
					ClassName:"DHCMA.IMP.IP.URTOperReg",
					MethodName:"Update",
					aInputStr:InputStr
				}, false);
				if(ret>0){
					$.messager.popover({msg: $g('登记提交成功！'),type:'success'});
					obj.ActLoc="";
					obj.Ward="";
					obj.ActDoc="";
					setTimeout(function(){
						window.location.reload();
					},1000);
				}else{
					$.messager.popover({msg: $g('登记提交失败！'),type:'error'});
				}
			}else{
				$.messager.popover({msg: $g('登记提交失败！'),type:'error'});
			}
		}else{
			$.messager.popover({msg: $g('登记提交失败！'),type:'error'});
		}
	};
	
	//审核
	obj.btnCheck_click=function(){
		
		//var CheckOpinion = $('#CheckOpinion').val();
		//var CheckUser = session['LOGON.USERID'];
		//var CheckDate = $('#CheckDate').datebox('getValue');
		//alert(CheckDate);
		//var CheckTime = $('#CheckTime').timespinner('getValue');
		//alert(CheckTime);
		/*if(typeof CheckOpinion =="undefined"||CheckOpinion==""){
			$.messager.popover({msg: '审核意见不能为空！',type:'error'});
			return false;
		}*/
		
		var IMPRegID="";
		var IMPRecordID="";
		if(obj.objRegRet){
			//var IMPRegisterJson = JSON.parse(obj.objRegRet)
      		IMPRegID=obj.objRegRet.ID;
      		IMPRecordID=obj.objRegRet.IMPRecordDr
      		
		}
		var RegStatusID="";
    var RegStatusCode="";
		var Opinion="";
		var RegDate="";
		var RegTime="";
		var RegUserID="";
		var CheckDate="";
		var CheckTime="";
		var CheckUserID=session['LOGON.USERID'];
		var IMPRecordDr=IMPRecordID;
		
		var RegStatus =$m({
			ClassName:"DHCMA.Util.BT.Dictionary",
			MethodName:"GetObjByPCodeItemDesc",
			PCode:"IMPRegStatus",
			Alias:"审核"
		}, false);
		if(RegStatus!=""){
			RegStatusID=JSON.parse(RegStatus).ID
      RegStatusCode = JSON.parse(RegStatus).BTCode;
		}
		
		var InputStr = IMPRegID+"^";
		InputStr=InputStr+EpisodeID+"^";
		InputStr=InputStr+"2"+"^";
		InputStr=InputStr+RegStatusID+"^"
		InputStr=InputStr+Opinion+"^";
		InputStr=InputStr+RegDate+"^";
		InputStr=InputStr+RegTime+"^";
		InputStr=InputStr+RegUserID+"^";
		InputStr=InputStr+CheckDate+"^";
		InputStr=InputStr+CheckTime+"^";
		InputStr=InputStr+CheckUserID+"^";
		InputStr=InputStr+IMPRecordDr+"^";
		
		websys_getTop().$.messager.confirm($g("审核确认提醒！"), $g("审核后不允许再提交，是否确认？"), function (r) {
			if (r) {
				var IMPRegCheckRet =$m({
					ClassName:"DHCMA.IMP.IP.IMPRegister",
					MethodName:"Check",
					aInputStr:InputStr
				}, false);
				if(IMPRegCheckRet>0){
					var LogInputStr = IMPRegCheckRet+"^";
						LogInputStr = LogInputStr+"^";
						LogInputStr = LogInputStr+RegStatusID+"^";
						LogInputStr = LogInputStr+Opinion+"^";
						LogInputStr = LogInputStr+"^";
						LogInputStr = LogInputStr+"^";
						LogInputStr = LogInputStr+session['LOGON.USERID'];
					var retLog =$m({
						ClassName:"DHCMA.IMP.IP.IMPRegisterLog",
						MethodName:"Update",
						aInputStr:LogInputStr
					}, false);	
					$.messager.popover({msg: $g('登记审核成功！'),type:'success'});
					setTimeout(function(){
						window.location.reload();
					},1000);
				}else{
					$.messager.popover({msg: $g('登记审核失败！'),type:'error'});
				}
			} else {
				return;
			}
		});
		
	}
	obj.btnCancelCheck_click=function(){		
		var IMPRegID="";
		var IMPRecordID="";
		if(obj.objRegRet){
			//var IMPRegisterJson = JSON.parse(obj.objRegRet)
      		IMPRegID=obj.objRegRet.ID;
      		IMPRecordID=obj.objRegRet.IMPRecordDr
      		
		}
		var RegStatusID="";
    	var RegStatusCode="";
		var Opinion="";
		var RegDate="";
		var RegTime="";
		var RegUserID="";
		var CheckDate="";
		var CheckTime="";
		var CheckUserID=session['LOGON.USERID'];
		var IMPRecordDr=IMPRecordID;
		
		var RegStatus =$m({
			ClassName:"DHCMA.Util.BT.Dictionary",
			MethodName:"GetObjByPCodeItemDesc",
			PCode:"IMPRegStatus",
			Alias:"提交"
		}, false);
		if(RegStatus!=""){
			RegStatusID=JSON.parse(RegStatus).ID
      RegStatusCode = JSON.parse(RegStatus).BTCode;
		}
		
		var InputStr = IMPRegID+"^";
		InputStr=InputStr+EpisodeID+"^";
		InputStr=InputStr+"2"+"^";
		InputStr=InputStr+RegStatusID+"^"
		InputStr=InputStr+Opinion+"^";
		InputStr=InputStr+RegDate+"^";
		InputStr=InputStr+RegTime+"^";
		InputStr=InputStr+RegUserID+"^";
		InputStr=InputStr+CheckDate+"^";
		InputStr=InputStr+CheckTime+"^";
		InputStr=InputStr+CheckUserID+"^";
		InputStr=InputStr+IMPRecordDr+"^";
		
		websys_getTop().$.messager.confirm($g("取消审核确认提醒！"), $g("取消审核，是否确认？"), function (r) {
			if (r) {
				var IMPRegCheckRet =$m({
					ClassName:"DHCMA.IMP.IP.IMPRegister",
					MethodName:"Check",
					aInputStr:InputStr
				}, false);
				if(IMPRegCheckRet>0){
					var LogInputStr = IMPRegCheckRet+"^";
						LogInputStr = LogInputStr+"^";
						LogInputStr = LogInputStr+RegStatusID+"^";
						LogInputStr = LogInputStr+Opinion+"^";
						LogInputStr = LogInputStr+"^";
						LogInputStr = LogInputStr+"^";
						LogInputStr = LogInputStr+session['LOGON.USERID'];
					var retLog =$m({
						ClassName:"DHCMA.IMP.IP.IMPRegisterLog",
						MethodName:"Update",
						aInputStr:LogInputStr
					}, false);	
					$.messager.popover({msg: $g('取消审核成功！'),type:'success'});
					setTimeout(function(){
						window.location.reload();
					},1000);
				}else{
					$.messager.popover({msg: $g('取消审核失败！'),type:'error'});
				}
			} else {
				return;
			}
		});
	}
	
	obj.btnCancle_click = function(){
		//if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");  //关闭
		//websys_showModal支持多层弹出，使用websys_showModel('close')关闭最近一次界面 ,websys_showModel('options') 拿到最近一次界面的配置
		websys_showModal('close');
		//window.close();

	};
	
}


