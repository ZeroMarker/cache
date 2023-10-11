function InitReportWinEvent(obj) {
	/**
	*病人对象
	*/
	obj.objPatientManage = function () {   
		var objPatientManage = $cm({                  
			ClassName:"DHCMed.Base.Patient",
			MethodName:"GetObjById",
			PAPMIRowId:PatientID
		},false);
		
		return objPatientManage;
	}
	
	/**
	* 病人就诊信息对象
	*/
	obj.objPaadmManage = function () {   
		var objPaadmManage = $cm({                  
			ClassName:"DHCMed.Base.PatientAdm",
			MethodName:"GetObjById",
			paadm:EpisodeID
		},false);
		return objPaadmManage;
	}
	/**
	* 获取食源性疾病报告信息
	*/
	obj.objReportManage = function (aID) {   //本报告返回对象的方法有问题，使用返回字符串方法	
		var objRep = $m({                  
			ClassName:"DHCMed.FBD.SusAbRep",
			MethodName:"GetStringById",
			aID:aID
		},false);
		return objRep;
	}
	/**
	* 获取食源性疾病病人对象
	*/
	obj.objGetPatObject = function (aReportID) {   //返回为对象的方法需重新写	
		var PatInfo = $m({                  
			ClassName:"DHCMed.FBDService.SusAbRepSrv",
			MethodName:"GetPatObject",
			aReportID:aReportID
		},false);
		
		if (PatInfo==""){
			 return false;   //判断对象是否为空
		}else{
			var objGetPatObject=JSON.parse(PatInfo);
			return objGetPatObject;
		}
	}
    /**
	* 获取字典对象
	*/
	obj.objDicManage = function (aID) {   //返回为对象的方法需重新写	
		var objDicManage = $cm({                  
			ClassName:"DHCMed.SSService.DictionarySrv",
			MethodName:"GetObjById",
			aID:aID
		},false);
		
		if ($.isEmptyObject(objDicManage)) return false;   //判断对象是否为空
		
		return objDicManage;
	}
	/**
	* 获取疾病信息对象
	*/
	obj.objDiseaseManage = function (aID) {   //返回为对象的方法需重新写	
		var objDiseaseManage = $cm({                  
			ClassName:"DHCMed.SS.Disease",
			MethodName:"GetObjById",
			aId:aID
		},false);

		if ($.isEmptyObject(objDiseaseManage)) return false;   //判断对象是否为空
		
		return objDiseaseManage;
	}
	// 获取配置项目
	obj.objConfigManage	= function(aKeys,aHospID) {
		var ConfigInfo = $m({                  
			ClassName:"DHCMed.SSService.ConfigSrv",
			MethodName:"GetValueByKeyHosp",
			aKeys:aKeys,
			aHospitalID:aHospID
		},false);
		
		return ConfigInfo;
	}
	
	// 当前上报科室
	obj.LoadLoc  = function (aLocID) {  
		var LocInfo = $m({                  
			ClassName:"DHCMed.Base.Ctloc",
			MethodName:"GetStringById",
			ctloc:aLocID,
			separete:''
		},false);
		return LocInfo;
	}
	// 当前上报病区          
	obj.LoadWard  = function (aWardID) {  
		var WardInfo = $m({     		     
			ClassName:"DHCMed.Base.PacWard",
			MethodName:"GetStringById",
			id :aWardID,
			separete:''
		},false);
	
		return WardInfo;
	}
	 // 当前上报用户
	obj.LoadUser  = function (aUserID) { 
		var UserInfo = $m({                  
			ClassName:"DHCMed.Base.SSUser",
			MethodName:"GetStringById",
			id:aUserID,
			separete:''
		},false);
		return UserInfo;
	} 
	
	// 获取病人年龄
	obj.GetPatAge = function (aDate,aTime) {  
		var Age = $m({       
			ClassName:"DHCMed.SSIO.FromHisSrv",
			MethodName:"GetPapmiAge",
			aPatientID:PatientID,
			aEpisodeID:EpisodeID,
			aDate:aDate,
			aTime:aTime
		},false);
		return Age;
	}
	// 获取门诊号、住院号
	obj.GetIPOPNo = function (aDate,aTime) {  
		var IPOPNo = $m({       
			ClassName:"DHCMed.FBDService.ReportSrv",
			MethodName:"GetIPOPNo",
			aEpisodeID:EpisodeID
		},false);
		return IPOPNo;
	}

	//判断状态字典是否存在项目
	obj.IsExistDic = function (aType,aCode) {   //返回为对象的方法需重新写	
		var objDicManage = $cm({                  
			ClassName:"DHCMed.SSService.DictionarySrv",
			MethodName:"GetObjByCode",
			argType:aType,
			argCode:aCode,
			argIsActive:1
		},false);
		if ($.isEmptyObject(objDicManage)) return false;   //判断对象是否为空
		
		return objDicManage;
	}
	//弹出加载层
	function loadingWindow() {
	    var left = ($(window).outerWidth(true) - 190) / 2; 
		var top = ($(window).height() - 35) / 2; 
		var height = $(window).height() * 2; 
 		$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height }).appendTo("#SusAbFBDReport"); 
 		$("<div class=\"datagrid-mask-msg\"></div>").html("数据加载中,请稍候...").appendTo("#SusAbFBDReport").css({ display: "block", left: left, top: top }); 
	}
	 
	//取消加载层  
	function disLoadWindow() {
	    $(".datagrid-mask").remove();
	    $(".datagrid-mask-msg").remove();
	}
	obj.LoadEvent = function(){
		loadingWindow();
		window.setTimeout(function () { 
			obj.BuildSign();
			obj.LoadPatInfo();	
			obj.refreshFormInfo(obj.reportID);
			disLoadWindow(); 
		}, 100); 

		obj.RelationToEvents (); // 按钮监听事件
	}

	$('#txtRegRoad').keyup(function (e) {  //鼠标移动之后事件
		var RegRoad = $('#txtRegRoad').val();
		var RegAddress = $('#cboRegProvince').combobox('getText')+$('#cboRegCity').combobox('getText')+$('#cboRegCounty').combobox('getText')+$('#cboRegVillage').combobox('getText');
		$('#txtRegAddress').val(RegAddress+RegRoad);
	});
	$('#txtCurrRoad').keyup(function (e) {  //鼠标移动之后事件
		var CurrRoad = $('#txtCurrRoad').val();
		var CurrAddress = $('#cboCurrProvince').combobox('getText')+$('#cboCurrCity').combobox('getText')+$('#cboCurrCounty').combobox('getText')+$('#cboCurrVillage').combobox('getText');
		$('#txtCurrAddress').val(CurrAddress+CurrRoad);
	});
	
	
	// ****************************** ↓↓↓ refresh
	obj.refreshFormInfo = function(reportID) {
		obj.reportID = reportID;
		obj.showReportData(reportID);	    // RepInfo
        var check = false, statusCode = "";	// 1待审 2已审 3退回 4草稿 5删除 6外院已报
		if (reportID) {	
			var objReport = obj.objReportManage(reportID);
			var arrRep=objReport.split("^");
			if (objReport) {
				var statusID = arrRep[4].split(CHR_1)[0];
				var objStatus = obj.objDicManage(statusID);
				if (objStatus) { statusCode = objStatus.Code; }
			}	
		}
		if (statusCode==2 || statusCode==5 || statusCode==6) { check = true; }	// 已审、删除、外院已报不允许修改

		
		obj.setFormDisabled(check);
		obj.showReportButton(statusCode);

	}
	obj.setFormDisabled = function(check) {
		var checkPatient = check, checkRepNo = check, checkSamNo = check;
		if (!check) {	
			if (IsUpdatePatInfo==0) { checkPatient = !check; }
			if (IsUpdateReportNo==0) { checkRepNo = !check; }
			if (IsUpdateSampleNo==0) { checkSamNo = !check; }
		}
		if (checkPatient) {
			$('#txtPatName').attr('disabled','disabled');
			$('#txtSex').attr('disabled','disabled');
			$('#txtAge').attr('disabled','disabled');
			$('#dtBirthday').datebox('disable');
		}
		if (checkRepNo) {
			$('#txtCardNo').attr('disabled','disabled');
		}
		if (checkSamNo) {
			$('#txtSampleNo').attr('disabled','disabled');
		}
		if (check) {
			$('#txtOPNo').attr('disabled','disabled');
			$('#txtIPNo').attr('disabled','disabled');
			$('#txtContactor').attr('disabled','disabled');
			$('#txtPersonalID').attr('disabled','disabled');
			$('#txtTelephone').attr('disabled','disabled');
			$('#txtFixedTel').attr('disabled','disabled');
			$('#txtRegAddress').attr('disabled','disabled');
			$('#txtRegRoad').attr('disabled','disabled');
			$('#txtCurrAddress').attr('disabled','disabled');
			$('#txtCurrRoad').attr('disabled','disabled');
			$('#txtDisText').attr('disabled','disabled');
			$('#txtMainSym').attr('disabled','disabled');
			$('#txtOtherSym').attr('disabled','disabled');
			$('#txtMainSign').attr('disabled','disabled');
			$('#txtSusAbFood').attr('disabled','disabled');
			$('#txtTestResult').attr('disabled','disabled');
			$('#txtTestAssist').attr('disabled','disabled');
			$('#cboCardType').combobox('disable');
			$('#txtIdentify').attr('disabled','disabled');
			$('#chkPreDiagnosDrs').checkbox('disable');
			$('#txtPreDiagnos').attr('disabled','disabled');
			$('#chkSusAbCauseDrs').checkbox('disable');
			$('#txtSusAbCause').attr('disabled','disabled');
			$('#tmSickTime').timespinner('disable');
			$('#dtSickDate').datebox('disable');
			$('#dtAdmitDate').datebox('disable');
			$('#tmAdmitTime').timespinner('disable');
			$('#dtLurkTime').attr('disabled','disabled');
			$('#cboPatArea').combobox('disable');
			$('#cboOccupation').combobox('disable');

			$('#cboReason').combobox('disable');
			$('#cboCurrProvince').combobox('disable');
			$('#cboCurrCity').combobox('disable');
			$('#cboCurrCounty').combobox('disable');
			$('#cboCurrVillage').combobox('disable');
			$('#cboRegProvince').combobox('disable');
			$('#cboRegCity').combobox('disable');
			$('#cboRegCounty').combobox('disable');
			$('#cboRegVillage').combobox('disable');
			$('#cboDisCate').combobox('disable');
			$('#cboDisDesc').combobox('disable');
			$('#IsInHosp-1').radio('disable');
			$('#IsInHosp-0').radio('disable');	
			$("input[name=chkPreDiagnosDrs],input[name=chkSusAbCauseDrs],input[name=chkList]").each(function(){
			   $(this).checkbox('disable');	
		       });
		}else {
			$('#txtOPNo').removeAttr('disabled');
			$('#txtIPNo').removeAttr('disabled');
			$('#txtContactor').removeAttr('disabled');
			$('#txtPersonalID').removeAttr('disabled');
			$('#txtTelephone').removeAttr('disabled');
			$('#txtFixedTel').removeAttr('disabled');
			$('#txtRegAddress').removeAttr('disabled');
			$('#txtRegRoad').removeAttr('disabled');
			$('#txtCurrAddress').removeAttr('disabled');
			$('#txtCurrRoad').removeAttr('disabled');
			$('#txtDisText').removeAttr('disabled');
			$('#chkPreDiagnosDrs').checkbox('enable');
			$('#txtPreDiagnos').removeAttr('disabled');
			$('#chkSusAbCauseDrs').checkbox('enable');
			$('#txtSusAbCause').removeAttr('disabled');
			$('#tmSickTime').timespinner('enable');
			$('#dtSickDate').datebox('enable');
			$('#dtAdmitDate').datebox('enable');
			$('#tmAdmitTime').timespinner('enable');
			$('#dtLurkTime').removeAttr('disabled');
			$('#cboPatArea').combobox('enable');
			$('#cboOccupation').combobox('enable');
			$('#cboReason').combobox('enable');
			$('#cboCurrProvince').combobox('enable');
			$('#cboCurrCity').combobox('enable');
			$('#cboCurrCounty').combobox('enable');
			$('#cboCurrVillage').combobox('enable');
			$('#cboRegProvince').combobox('enable');
			$('#cboRegCity').combobox('enable');
			$('#cboRegCounty').combobox('enable');
			$('#cboRegVillage').combobox('enable');
			$('#cboDisCate').combobox('enable');
			$('#cboDisDesc').combobox('enable');
			$('#IsInHosp-1').radio('enable');
			$('#IsInHosp-0').radio('enable');
			$('#txtMainSym').removeAttr('disabled');
			$('#txtOtherSym').removeAttr('disabled');
			$('#txtMainSign').removeAttr('disabled');
			$('#txtSusAbFood').removeAttr('disabled');
			$('#txtTestResult').removeAttr('disabled');
			$('#txtTestAssist').removeAttr('disabled');
			$('#cboCardType').combobox('enable');
			$('#txtIdentify').removeAttr('disabled');
			$("input[name=chkPreDiagnosDrs],input[name=chkSusAbCauseDrs],input[name=chkList]").each(function(){
			   $(this).checkbox('enable');	
		   });
		}
		var txtListSign = document.getElementsByName("txtList");
		if (txtListSign) {
			for (var i=0; i<txtListSign.length; i++) {
				txtListSign[i].disabled = check;
			}
		}
	}
	
	obj.showReportButton = function(statusCode) {
		$('#btnSaveTmp').hide();	// 草稿
		$('#btnSaveRep').hide();	// 报卡
		$('#btnExecheck').hide();	// 审核
		$('#btnCancheck').hide();	// 取消审核
		$('#btnReturn').hide();	    // 退回
		$('#btnDelete').hide();	    // 删除
		$('#btnReported').hide();	// 外院已报
		$('#btnPrint').hide();		// 打印
		$('#btnClose').show();	    // 关闭
		// 1待审 2已审 3退回 4草稿 5删除 6外院已报
		if (LocFlag==0) {	// 医生站
			if (statusCode==1) {	  // 待审
				$('#btnSaveRep').show();	// 报卡
				$('#btnSaveRep').linkbutton({text:'修改报卡'});
				$('#btnDelete').show();	    // 删除
				$('#btnPrint').show();		// 打印
			} else if (statusCode==2) {	// 已审
				//
			} else if (statusCode==3) {	// 退回
				$('#btnSaveRep').show();	// 报卡
				$('#btnSaveRep').linkbutton({text:'修改报卡'});
				$('#btnDelete').show();	    // 删除
			} else if (statusCode==4) {	// 草稿
				$('#btnSaveTmp').show();	// 草稿
				$('#btnSaveRep').show();	// 报卡
				$('#btnDelete').show();		// 删除
				$('#btnReported').show();	// 外院已报
			} else if (statusCode==5) {	// 删除
				//
			} else if (statusCode==6) {	// 外院已报
				$('#btnDelete').show();	    // 删除
			} else {					// 无报告
				$('#btnSaveTmp').show();	// 草稿
				$('#btnSaveRep').show();	// 报卡
				$('#btnReported').show();	// 外院已报
			}
		} else if (LocFlag==1) {	// 管理科室
			if (statusCode==1) {			// 待审
				$('#btnSaveRep').show();	// 报卡
				$('#btnSaveRep').linkbutton({text:'修改报卡'});
				$('#btnExecheck').show();	// 审核
				$('#btnReturn').show();	    // 退回
				$('#btnDelete').show();	    // 删除
				$('#btnPrint').show();		// 打印
			} else if (statusCode==2) {	// 已审
				$('#btnCancheck').show();	// 取消审核
				$('#btnPrint').show();		// 打印
			} else if (statusCode==3) {	// 退回
				$('#btnSaveRep').show();	// 报卡
				$('#btnSaveRep').linkbutton({text:'修改报卡'});
				$('#btnDelete').show();	    // 删除
			} else if (statusCode==4) {	// 草稿
				$('#btnSaveTmp').show();	// 草稿
				$('#btnSaveRep').show();	// 报卡
				$('#btnDelete').show();		// 删除
				$('#btnReported').show();	// 外院已报
			} else if (statusCode==5) {	// 删除
				//
			} else if (statusCode==6) {	// 外院已报
				$('#btnDelete').show();	    // 删除
			} else {					// 无报告
				$('#btnSaveTmp').show();	// 草稿
				$('#btnSaveRep').show();	// 报卡
				$('#btnReported').show();	// 外院已报
			}
		}
	}
	
	obj.showReportData = function(reportID) {
		var arrLocInfo = '';
		var arrUserInfo = '';
		var arrCurrRep = '';
		if (reportID!="") { 
			obj.objCurrReport = obj.objReportManage(reportID); 
			arrCurrRep=obj.objCurrReport.split("^");
			
		}
		if (arrCurrRep) {
			obj.objCurrCtLoc  = obj.LoadLoc(arrCurrRep[34]);
			arrLocInfo = obj.objCurrCtLoc.split('^');
			obj.objCurrUser = obj.LoadUser(arrCurrRep[36]);
			arrUserInfo = obj.objCurrUser.split('^');
		} else {
			obj.objCurrCtLoc  = obj.LoadLoc(session['LOGON.CTLOCID']);
			arrLocInfo = obj.objCurrCtLoc.split('^');
			obj.objCurrUser = obj.LoadUser(session['LOGON.USERID']);
			arrUserInfo = obj.objCurrUser.split('^');
		}
		
		obj.objCurrPaadm = obj.objPaadmManage(EpisodeID);
		obj.objCurrPatient = obj.objPatientManage(PatientID);
		var DiseaseID = "", Disease = "", DisCateID = "",DisCate = "", DiseaseText = "", RepStatus = "", Area = "", OccupationID = "", Occupation = "";
		var PatName="", Sex = "", Birthday = "", PersonalID = "", Nation = "", OPNo = "", IPNo = "",CardTypeID = "", CardType = "",Identify="";
		var CurrAddress = "", CurrProvinceID = "",  CurrProvince = "",CurrCityID = "", CurrCity = "",CurrCountyID = "", CurrCounty = "",CurrVillageID = "",CurrVillage = "",  CurrRoad = "";
		var RegAddress = "", RegProvinceID = "",  RegProvince = "",RegCityID = "", RegCity = "",RegCountyID = "", RegCounty = "",RegVillageID = "",RegVillage = "",  RegRoad = "";
		var SickDate = "", SickTime = "", AdmitDate = "", AdmitTime = "", LurkTime = "",ReasonID="",Reason="";
		var CardNo = "", IsInHosp = "", Contactor = "", Telephone = "", FixedTel = "",MainSym = "",OtherSym = "", MainSign = "", SusAbFood = "", TestResult = "", TestAssist = "";
		var PreDiagnosDrs = "", PreDiagnos = "",SusAbCauseDrs = "", SusAbCause = "", ReportLoc = session['LOGON.CTLOCID'], ReportUser = "";
		var RepPlace = "", Age = "", RepLoc = "", RepUser = "";
		if (obj.objCurrReport) {	// 报告信息
			var PatientObj = obj.objGetPatObject(reportID);
			if (PatientObj) {
				PatName = PatientObj.RPPatName;			// 患者姓名
				Sex = PatientObj.RPSex;					// 性别
				Birthday = PatientObj.RPBirthday;		// 出生日期
				//PersonalID = PatientObj.RPPersonalID;	// 身份证号
				Nation = PatientObj.RPNation;			// 民族
				OPNo = PatientObj.RPOPNo;				// 门诊病案号
				IPNo = PatientObj.RPIPNo;				// 住院病案号
			}
			var statusID = arrCurrRep[4].split(CHR_1)[0];	   // 报告状态
			var RepStatus = arrCurrRep[4].split(CHR_1)[1];
			var OccupationID = arrCurrRep[25].split(CHR_1)[0];	// 患者职业
			var Occupation = arrCurrRep[25].split(CHR_1)[1];
			var CardTypeID = arrCurrRep[7].split(CHR_1)[0];	// 证件类型
			var CardType = arrCurrRep[7].split(CHR_1)[1];	
			var ReasonID = arrCurrRep[31].split(CHR_1)[0];	// 上报原因
			var Reason = arrCurrRep[31].split(CHR_1)[1];	
			var DiseaseID = arrCurrRep[2].split(CHR_1)[0];	    // 疾病信息
		    var Disease = arrCurrRep[2].split(CHR_1)[2];
			if (DiseaseID) {
				var objDisease = obj.objDiseaseManage(DiseaseID);
				if (objDisease) { 
					DisCateID = objDisease.IDCateDr;
					objDic = obj.objDicManage(DisCateID);
					if (objDic) {
						var DisCate = $m({                  
							ClassName:"web.DHCBL.Authorize.BDPTranslation",
							MethodName:"GetTransDesc",
							TableName:"DHCMed.SS.Dictionary",
							FieldName:"Description",
							Languages:session['LOGON.LANGCODE'],
							FieldDesc:objDic.Description
						},false);
					}					
				}
			}
			DiseaseText = arrCurrRep[3];
			CardNo = arrCurrRep[5];				// 病例编号	// 提交时生成
			Identify = arrCurrRep[8];			// 证件号码
			IsInHosp = arrCurrRep[9];			// 是否住院
			Contactor = arrCurrRep[10];			// 监护人
			Telephone = arrCurrRep[11];			// 联系电话
			FixedTel = arrCurrRep[12];			// 固定电话
		
			RegAddress = arrCurrRep[13];		// 现住址
			RegProvinceID = arrCurrRep[14].split(CHR_1)[0];	    // 省
			RegProvince = arrCurrRep[14].split(CHR_1)[1];	    
			RegCityID = arrCurrRep[15].split(CHR_1)[0];			// 市
			RegCity = arrCurrRep[15].split(CHR_1)[1];			
			RegCountyID = arrCurrRep[16].split(CHR_1)[0];		    // 县
			RegCounty = arrCurrRep[16].split(CHR_1)[1];		
			RegVillageID = arrCurrRep[17].split(CHR_1)[0];		    // 乡
			RegVillage = arrCurrRep[17].split(CHR_1)[1];		    
			RegRoad = arrCurrRep[18];			// 街道
			
			CurrAddress = arrCurrRep[19];		// 现住址
			CurrProvinceID = arrCurrRep[20].split(CHR_1)[0];	    // 省
			CurrProvince = arrCurrRep[20].split(CHR_1)[1];	    
			CurrCityID = arrCurrRep[21].split(CHR_1)[0];			// 市
			CurrCity = arrCurrRep[21].split(CHR_1)[1];			
			CurrCountyID = arrCurrRep[22].split(CHR_1)[0];		    // 县
			CurrCounty = arrCurrRep[22].split(CHR_1)[1];		
			CurrVillageID = arrCurrRep[23].split(CHR_1)[0];		    // 乡
			CurrVillage = arrCurrRep[23].split(CHR_1)[1];		    
			CurrRoad = arrCurrRep[24];			// 街道
			SickDate = arrCurrRep[26];			// 发病日期
			SickTime = arrCurrRep[27];			// 发病时间
			AdmitDate = arrCurrRep[28];			// 就诊日期
			AdmitTime = arrCurrRep[29];			// 就诊时间
			LurkTime = arrCurrRep[30];			// 潜伏时间
			PreDiagnosDrs = arrCurrRep[50];		// 初步诊断（多选）
			PreDiagnos = arrCurrRep[32];		// 初步诊断（其他）
			SusAbCauseDrs = arrCurrRep[51];		// 可疑病因（多选）
			SusAbCause = arrCurrRep[33];			// 可疑病因（其他）
			RepLoc = arrCurrRep[35];			// 报告科室
			RepUser = arrCurrRep[37];			// 报告人
			MainSym = arrCurrRep[44];			// 主要症状
			OtherSym = arrCurrRep[45];			// 其他症状
			MainSign = arrCurrRep[46];			// 主要体征
			SusAbFood = arrCurrRep[47];			// 可疑食品名称
			TestResult = arrCurrRep[48];			// 实验室检查结果
			TestAssist = arrCurrRep[49];			// 辅助检查结果
		} else {
			RepLoc = arrLocInfo[2];	            // 报告科室
			RepUser = arrUserInfo[2];	        // 报告人
			//存在临床诊断DiseaseID;
			if (obj.diseaseID) {
				DiseaseID = obj.diseaseID;
				var objDisease = obj.objDiseaseManage(DiseaseID);
				if (objDisease) {
					Disease  = objDisease.IDDesc;
					DisCateID = objDisease.IDCateDr;
					objDic = obj.objDicManage(DisCateID);
					if (objDic) {
						var DisCate = $m({                  
							ClassName:"web.DHCBL.Authorize.BDPTranslation",
							MethodName:"GetTransDesc",
							TableName:"DHCMed.SS.Dictionary",
							FieldName:"Description",
							Languages:session['LOGON.LANGCODE'],
							FieldDesc:objDic.Description
						},false);
					}					
				}
			}
			if (ServerObj.RegAddress) {
					
				RegAddress = ServerObj.PatRegAddress;		// 户籍地址
				RegProvinceID = ServerObj.RegAddress.split("^")[0];
                RegProvince   = ServerObj.RegAddress.split("^")[1];
                RegCityID     = ServerObj.RegAddress.split("^")[2];
                RegCity       = ServerObj.RegAddress.split("^")[3];
                RegCountyID   = ServerObj.RegAddress.split("^")[4];
                RegCounty     = ServerObj.RegAddress.split("^")[5];
                RegVillageID  = ServerObj.RegAddress.split("^")[6];
                RegVillage    = ServerObj.RegAddress.split("^")[7];
				RegRoad       = ServerObj.RegAddress.split("^")[8];
			}
			if (ServerObj.CurrAddress) {				
				CurrAddress = ServerObj.PatCurrAddress;		// 现住址
				CurrProvinceID = ServerObj.CurrAddress.split("^")[0];
                CurrProvince   = ServerObj.CurrAddress.split("^")[1];
                CurrCityID     = ServerObj.CurrAddress.split("^")[2];
                CurrCity       = ServerObj.CurrAddress.split("^")[3];
                CurrCountyID   = ServerObj.CurrAddress.split("^")[4];
                CurrCounty     = ServerObj.CurrAddress.split("^")[5];
                CurrVillageID  = ServerObj.CurrAddress.split("^")[6];
                CurrVillage    = ServerObj.CurrAddress.split("^")[7];
				CurrRoad       = ServerObj.CurrAddress.split("^")[8];
			}
			if (ServerObj.DicInfo) {// 字典赋值
			     var OccupationInfo = ServerObj.DicInfo.split("^")[3];
			     var CardTypeInfo = ServerObj.DicInfo.split("^")[8];
			     OccupationID = OccupationInfo.split(",")[0];
			     Occupation = OccupationInfo.split(",")[2];
			     CardTypeID= CardTypeInfo.split(",")[0];
			     CardType = CardTypeInfo.split(",")[2];
			     Identify = CardTypeInfo.split(",")[3];
			}		
		}
		if (obj.objCurrPaadm) {	// 就诊信息
			var RepPlace = "";
			if (ServerObj.AdmType=="O") {
				RepPlace = $g("门诊");
			} else if (ServerObj.AdmType=="I") {
				RepPlace = $g("病区");
				if (IsInHosp=="") { IsInHosp = 1; }	
			} else if (ServerObj.AdmType=="E") {
				RepPlace = $g("急诊");
			}
			if (AdmitDate=="") { AdmitDate = obj.objCurrPaadm.AdmitDate }
			if (AdmitTime=="") { AdmitTime = obj.objCurrPaadm.AdmitTime }
		}
		if (obj.objCurrPatient) {	// 病人信息	// 以报告为准	
			var Age = obj.GetPatAge(obj.objCurrPaadm.AdmitDate,obj.objCurrPaadm.AdmitTime);
			if (!PatName) { PatName = obj.objCurrPatient.PatientName; }
			if (!Sex) { Sex = obj.objCurrPatient.Sex; }
			if (!Birthday) { Birthday = obj.objCurrPatient.Birthday; }
			if (!PersonalID) { PersonalID = obj.objCurrPatient.PersonalID; }
			if (!Contactor) { Contactor = obj.objCurrPatient.RelativeName; }			// 监护人姓名
			if (!Telephone) { Telephone = obj.objCurrPatient.RelativeTelephone; }	// 联系方式
			if (!FixedTel) { FixedTel = obj.objCurrPatient.FixedTel; }				// 工作单位
			if (!CardTypeID) { CardTypeID = obj.objCurrPatient.PersonalIDCode; }	
			if (!CardType) { CardType = obj.objCurrPatient.PersonalIDType; }		
			if (!Identify) { Identify = obj.objCurrPatient.PAPMIDVAnumber; }
		}
		

		$('#txtRepLoc').val(RepLoc);	   
		$('#txtRepUser').val(RepUser);	
		$('#txtRepPlace').val(RepPlace);	// 报告位置
		$('#txtRepStatus').val(RepStatus);	// 报告状态
	
		var IPOPNo = ServerObj.IPOPNo;	    // 门诊号、住院号
		if (IPOPNo!="") {
			IPOPNo = IPOPNo.split("^");
			if (IPNo=="") { IPNo = IPOPNo[0]; }
			if (OPNo=="") { OPNo = IPOPNo[1]; }
		}
		
		$('#txtOPNo').val(OPNo);	        // 门诊号
		$('#txtIPNo').val(IPNo);	        // 住院号
		$('#txtCardNo').val(CardNo);	    // 报告编号
		if (IsInHosp) {
			$HUI.radio("#IsInHosp-"+IsInHosp).setValue(true); // 是否住院
		}
		$('#txtPatName').val(PatName);	    // 姓名
		$('#txtSex').val(Sex);	            // 性别
		$('#txtAge').val(Age);	            // 年龄
		$('#dtBirthday').datebox('setValue',Birthday);	// 出生日期
		$('#cboCardType').combobox('setValue',CardTypeID)	// 证件类型ID
		$('#cboCardType').combobox('setText',CardType)	// 证件类型
		$('#txtIdentify').val(Identify);	// 身份证号
		$('#txtContactor').val(Contactor);	    // 监护人姓名
		$('#txtTelephone').val(Telephone);	    // 联系方式
		$('#txtFixedTel').val(FixedTel);	        // 固定电话
		$('#cboOccupation').combobox('setValue',OccupationID)	// 患者职业
		$('#cboOccupation').combobox('setText',Occupation)	// 患者职业
		$('#txtMainSym').val(MainSym);	    // 主要症状
		$('#txtOtherSym').val(OtherSym);	    // 其他症状
		$('#txtMainSign').val(MainSign);	    // 主要体征
		$('#txtSusAbFood').val(SusAbFood);	    // 可疑食品名称
		$('#txtTestResult').val(TestResult);	    // 实验室检查结果
		$('#txtTestAssist').val(TestAssist);	    // 辅助检查结果
	
		$('#dtSickDate').datebox('setValue',SickDate);	// 发病时间
		$('#tmSickTime').timespinner('setValue',SickTime);
		$('#dtAdmitDate').datebox('setValue',AdmitDate);	// 就诊时间
		$('#tmAdmitTime').timespinner('setValue',AdmitTime);
		$('#dtLurkTime').val(LurkTime);	    // 潜伏时间
		$('#cboReason').combobox('setValue',ReasonID)	// 上报原因
		$('#cboReason').combobox('setText',Reason)	// 上报原因
		
		for (var len=0; len < PreDiagnosDrs.length;len++) {  // 初步诊断（多选）        
			var value = PreDiagnosDrs.split(',')[len];
			$('#chkPreDiagnosDrs'+value).checkbox('setValue', (value!="" ? true:false));                
		}     
		$('#txtPreDiagnos').val(PreDiagnos);	// 初步诊断
		for (var len=0; len < SusAbCauseDrs.length;len++) {  // 可疑病因（多选）       
			var value = SusAbCauseDrs.split(',')[len];
			$('#chkSusAbCauseDrs'+value).checkbox('setValue', (value!="" ? true:false));                
		}     
		$('#txtSusAbCause').val(SusAbCause);	    // 可疑病因(其他)
	
		//户籍地址
		$('#cboRegProvince').combobox('setValue',RegProvinceID);
		$('#cboRegProvince').combobox('setText',RegProvince);
		$('#cboRegCity').combobox('setValue',RegCityID);
		$('#cboRegCity').combobox('setText',RegCity);
		$('#cboRegCounty').combobox('setValue',RegCountyID);
		$('#cboRegCounty').combobox('setText',RegCounty);
		$('#cboRegVillage').combobox('setValue',RegVillageID);
		$('#cboRegVillage').combobox('setText',RegVillage);
		$('#txtRegRoad').val(RegRoad);	                // 街道
		$('#txtRegAddress').val(RegAddress);	// 现住址
		
		//现住址 省市县乡
		$('#cboCurrProvince').combobox('setValue',CurrProvinceID);
		$('#cboCurrProvince').combobox('setText',CurrProvince);
		$('#cboCurrCity').combobox('setValue',CurrCityID);
		$('#cboCurrCity').combobox('setText',CurrCity);
		$('#cboCurrCounty').combobox('setValue',CurrCountyID);
		$('#cboCurrCounty').combobox('setText',CurrCounty);
		$('#cboCurrVillage').combobox('setValue',CurrVillageID);
		$('#cboCurrVillage').combobox('setText',CurrVillage);
		$('#txtCurrRoad').val(CurrRoad);	                // 街道
		$('#txtCurrAddress').val(CurrAddress);	// 现住址
		if (session['LOGON.LANGCODE']=="EN"){
			$('#txtCurrAddress').val(CurrProvince+CurrCity+CurrCounty+CurrVillage);    
		}
		$('#cboDisCate').combobox('setValue',DisCateID);    // 疾病分类
		$('#cboDisCate').combobox('setText',DisCate);    
		$('#cboDisDesc').combobox('setValue',DiseaseID);    // 疾病字典	
		$('#cboDisDesc').combobox('setText',Disease);  		
		$('#txtDisText').val(DiseaseText);	                // 疾病备注
	
	}
	// ****************************** ↑↑↑ refresh
	
	// 按钮触发事件
	obj.RelationToEvents = function() {
		$('#btnSaveTmp').on("click", function(){
			obj.btnSaveTmp_click(); 
		});
		$('#btnSaveRep').on("click", function(){
			obj.btnSaveRep_click(); 
		});
		$('#btnExecheck').on("click", function(){
			obj.btnExecheck_click(); 	
		});
		$('#btnCancheck').on("click", function(){
			$.messager.confirm($g("提示"), $g("请确认是否取消审核?"), function (r) {
				if (r){
					obj.btnCancheck_click(); 
				}
			});
		});
		$('#btnReturn').on("click", function(){
			$.messager.confirm($g("提示"), $g("请确认是否退回?"), function (r) {
				if (r){
					obj.btnReturn_click(); 
				}
			});
		});
		$('#btnDelete').on("click", function(){
			$.messager.confirm($g("提示"), $g("请确认是否作废？"), function (r) {
				if (r){
					obj.btnDelete_click(); 
				}
			});
		});
		$('#btnPrint').on("click", function(){
			obj.btnPrint_click(); 
		});
		$('#btnClose').on("click", function(){
			obj.btnClose_click(); 
		});
		$('#btnReported').on("click", function(){
			obj.btnReported_click(); 
		});
	}
		
	// ****************************** ↓↓↓ report func	// 1待审 2已审 3退回 4草稿 5作废 6外院已报
	obj.btnSaveTmp_click = function() {	// 草稿
		obj.saveReportInfo(4, "^");
	}
	
	obj.btnSaveRep_click = function() {	// 报卡
		obj.saveReportInfo(1, "^");
	}
	
	obj.btnExecheck_click = function() {	// 审核
		obj.saveReportStatus(2, "^");
	}
	
	obj.btnCancheck_click = function() {	// 取消审核
		obj.saveReportStatus(1, "^");
	}
	
	obj.btnReturn_click = function() {	// 退回
		obj.saveReportStatus(3, "^");
	}
	
	obj.btnDelete_click = function() {	// 作废
		obj.saveReportStatus(5, "^");
	}
	
	obj.btnReported_click = function() {	// 外院已报
		obj.saveReportInfo(6, "^");
	}
	
	obj.btnPrint_click = function() {	// 打印	
		//var fileName="{DHCMed.FBD.SusAbRep.raq(aReportID="+obj.reportID+"&aType=1)}";
		var fileName="DHCMed.FBD.SusAbRep.raq&aReportID="+obj.reportID+"&aType=1";
		DHCCPM_RQPrint(fileName)
		//DHCCPM_RQDirectPrint(fileName);
	}
	
	obj.btnClose_click = function() {
		 //关闭
		websys_showModal('close');
	}
	// ****************************** ↑↑↑ report func
	
	// ****************************** ↓↓↓ save
	obj.saveReportStatus = function(statusCode, separate) {
		var statusID = "", checkUser = session['LOGON.USERID'];
		var objStatus = obj.IsExistDic("FBDREPORTSTATUS", statusCode);
		if (objStatus) { statusID = objStatus.ID; }
		if (obj.reportID=="" || statusID=="") {
			$.messager.alert($g("提示"), $g("操作失败!"), 'info');
			return;
		}
		var checkDate = "", checkTime = "", resume = "";
		var inputStr = obj.reportID;
		inputStr = inputStr + separate + statusID;
		inputStr = inputStr + separate + checkUser;
		inputStr = inputStr + separate + checkDate;
		inputStr = inputStr + separate + checkTime;
		
		var ret = $m({                  
			ClassName:"DHCMed.FBD.SusAbRep",
			MethodName:"UpdateStatus",
			aInputStr:inputStr, 
			aSeparate:separate
		},false);
		
		if (ret>0) {
			$.messager.alert($g("提示"), $g("操作成功!"), 'info');
			obj.refreshFormInfo(ret);
		} else {
			$.messager.alert($g("提示"), $g("操作失败!"), 'info');
		}
	}
	
	obj.saveReportInfo = function(statusCode, separate) {
		var errorStr = "", sepobj = "#";
		var inputStr = obj.saveReportStr(statusCode, separate, sepobj);
        if ((inputStr=="")||((typeof inputStr == 'undefined'))) { return; } 
		
		var signList = document.getElementsByName("chkList"), chkSignCount = 0;
		for (var i=0; i<signList.length; i++) {
			if (signList[i].checked) {
				chkSignCount = chkSignCount + 1;
				var signDr = "", subID = "", ExtraID = "", ExtraText = "";
				if (signList[i].value!="") { subID = signList[i].value.split("||")[1]; }
				if (signList[i].id!="") {
					signDr = signList[i].id.substring(3, signList[i].id.length);
					ExtraID = "txt" + signDr;
				}
				
				if (ExtraID!="") {
					var objExtra = document.getElementById(ExtraID);
					if (objExtra) { ExtraText = objExtra.value; }
					if ((objExtra) && (ExtraText=="")) {
						$.messager.alert($g("提示"), $g("如选发热 则体温必填，呕吐(腹泻) 则__次/天必填，其他 则其他项必填!"), 'info');
						return;
					}
				}
			}
		}
		
		if (chkSignCount==0 && statusCode==1) {
			$.messager.alert($g("提示"), $g("请至少选择一项主要症状!"), 'info');
			return;
		}
		var retRep = $m({                  
			ClassName:"DHCMed.FBD.SusAbRep",
			MethodName:"Update",
			aInputStr:inputStr, 
			aSeparate:separate,
			aSepObj:sepobj
		},false);
	
		if (retRep>0) {
			var retSign = obj.saveSign(retRep, separate);
			if (retSign<0) { errorStr = errorStr + $g("体征信息保存失败!"); }
		} else {
			errorStr = errorStr + $g("报告信息保存失败!");
		}
		if (errorStr=="") {
			errorStr = $g("保存成功!");
			obj.refreshFormInfo(retRep);
			//新建报告保存成功后不关闭窗口直接刷新时，界面显示空白问题处理
			if (typeof(history.pushState) === 'function') {
			  	var Url=window.location.href;
		        Url=rewriteUrl(Url, {
			        ReportID:retRep
		        });
		    	history.pushState("", "", Url);
			}
		}
		$.messager.alert($g("提示"), errorStr, 'info');
	}
	
	obj.saveSign = function(reportID, separate) {	// 保存主要体征
		var signFlg = 0;
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
				var ret = $m({       
					ClassName:"DHCMed.FBD.SusAbRepSign",
					MethodName:"Update",
					aInputStr:inputStr,
					aSeparate:separate
				},false); 
				if (ret<=0) { signFlg = signFlg - 1; }
				$('#'+tmpSign.id).attr('value',ret);   //修改新建报告不关闭报告情况下直接修改，重复插入数据问题
	
			} else if (!tmpSign.checked && tmpSign.value!="") {	// 取消选中delete
				var ret = $m({       
					ClassName:"DHCMed.FBD.SusAbRepSign",
					MethodName:"DeleteById",
					aID:tmpSign.value
				},false); 
				if (ret<=0) { signFlg = signFlg - 1; }
			}
		}
		
		return signFlg;
	}
	
	obj.saveReportStr = function(statusCode, separate, sepobj) {		
		var StatusID = "";
		var objStatus = obj.IsExistDic("FBDREPORTSTATUS", statusCode);
		if (objStatus) { StatusID = objStatus.ID; }
		var OPNo = $.trim($('#txtOPNo').val());	                        // 门诊号
		var IPNo = $.trim($('#txtIPNo').val());	                        // 住院号
		var CardNo = $.trim($('#txtCardNo').val());	                    // 报告编号
	
		if (IsUpdateReportNo==0 && CardNo=="") {	            // 报告编号自动生成
			CardNo = $m({                  
				ClassName:"DHCMed.FBDService.ReportSrv",
				MethodName:"GetFBDNo",
				aNoType:1
			},false);
		}
		var IsInHosp = $("input[name=IsInHosp]:checked").val();	// 是否住院
		if (!IsInHosp){
			IsInHosp="";
		}
		var PatName = $.trim($('#txtPatName').val());	                // 姓名
		var Sex = $.trim($('#txtSex').val());	                        // 性别
		var Age = $.trim($('#txtAge').val());	                        // 年龄
		var Birthday = $('#dtBirthday').datebox('getValue');	// 出生日期
		var CardTypeID = $.trim($('#cboCardType').combobox('getValue'));          //证件类型ID
		var CardType = $.trim($('#cboCardType').combobox('getText'));          //证件类型
		var Identify = $.trim($('#txtIdentify').val());                         //证件号码
		var Contactor = $.trim($('#txtContactor').val());	            // 监护人姓名
		var Telephone = $.trim($('#txtTelephone').val());	            // 联系方式
		var FixedTel = $.trim($('#txtFixedTel').val());	            // 固定电话
		var OccupationID = $.trim($('#cboOccupation').combobox('getValue'));	// 患者职业
		var ReasonID = $.trim($('#cboReason').combobox('getValue')); //上报原因
		var RegAddress = $.trim($('#txtRegAddress').val());			// 户籍地址
		var RegProvinceID = $.trim($('#cboRegProvince').combobox('getValue'));	//户籍 省   
		var RegProvince = $.trim($('#cboRegProvince').combobox('getText'));	// 户籍省   
		var RegCityID = $.trim($('#cboRegCity').combobox('getValue'));			// 户籍市
		var RegCity = $.trim($('#cboRegCity').combobox('getText'));			// 户籍市
		var RegCountyID = $.trim($('#cboRegCounty').combobox('getValue'));		// 户籍县
		var RegCounty = $.trim($('#cboRegCounty').combobox('getText'));		// 户籍县
		var RegVillageID = $.trim($('#cboRegVillage').combobox('getValue'));	// 户籍乡
		var RegVillage = $.trim($('#cboRegVillage').combobox('getText'));		// 户籍乡
		var RegRoad = $.trim($('#txtRegRoad').val());					// 户籍街道
		var CurrAddress = $.trim($('#txtCurrAddress').val());			// 现住址
		var CurrProvinceID = $.trim($('#cboCurrProvince').combobox('getValue'));	// 省   //省市县乡的存储方式沿用之前的方式存描述
		var CurrProvince = $.trim($('#cboCurrProvince').combobox('getText'));	// 省   //省市县乡的存储方式沿用之前的方式存描述
		var CurrCityID = $.trim($('#cboCurrCity').combobox('getValue'));			// 市
		var CurrCity = $.trim($('#cboCurrCity').combobox('getText'));			// 市
		var CurrCountyID = $.trim($('#cboCurrCounty').combobox('getValue'));		// 县
		var CurrCounty = $.trim($('#cboCurrCounty').combobox('getText'));		// 县
		var CurrVillageID = $.trim($('#cboCurrVillage').combobox('getValue'));	// 乡
		var CurrVillage = $.trim($('#cboCurrVillage').combobox('getText'));	// 乡
		var CurrRoad = $.trim($('#txtCurrRoad').val());					// 街道
		var DisCateID = $.trim($('#cboDisCate').combobox('getValue'));	// 疾病分类
		var DiseaseID = $.trim($('#cboDisDesc').combobox('getValue'));	// 疾病ID
		var DiseaseText = $.trim($('#txtDisText').val());				// 疾病备注
		var SickDate = $('#dtSickDate').datebox('getValue');	// 发病时间
		var SickTime = $('#tmSickTime').timespinner('getValue');
		var AdmitDate = $('#dtAdmitDate').datebox('getValue');	// 就诊日期
		var AdmitTime = $('#tmAdmitTime').timespinner('getValue');	// 就诊时间
		var LurkTime = $.trim($('#dtLurkTime').val());			//潜伏时间
		var MainSym = $.trim($('#txtMainSym').val());			//主要症状
		var OtherSym = $.trim($('#txtOtherSym').val());			//其他症状
		var MainSign = $.trim($('#txtMainSign').val());			//主要体征
		var SusAbFood = $.trim($('#txtSusAbFood').val());			//可疑食品名称
		var TestResult = $.trim($('#txtTestResult').val());			//实验室检查结果
		var TestAssist = $.trim($('#txtTestAssist').val());			//辅助检查结果
		var PreDiagnosDrs = Common_CheckboxValue('chkPreDiagnosDrs');	// 初步诊断
		var PreDiagnos = $.trim($('#txtPreDiagnos').val());				// 初步诊断(其他)
		var SusAbCauseDrs =  Common_CheckboxValue('chkSusAbCauseDrs');	// 可疑病因
		var SusAbCause = $.trim($('#txtSusAbCause').val());				// 可疑病因(其他)
		
		var EpisodeID = "", PatientID = "", ReportLoc = session['LOGON.CTLOCID'];
		var ReportUser = "", ReportDate = "", ReportTime = "";
		var CheckUser = "", CheckDate = "", CheckTime = "";
		if (obj.objCurrPaadm) { EpisodeID = obj.objCurrPaadm.AdmRowID; }
		if (obj.objCurrPatient) { PatientID = obj.objCurrPatient.Papmi; }
		if (obj.objCurrCtLoc) { ReportLoc = obj.objCurrCtLoc.split('^')[0] }
		if (obj.objCurrUser) { ReportUser = obj.objCurrUser.split('^')[0]}
		
		if (statusCode==1 || statusCode==2) {
			var errorStr = "";
			if (StatusID=="") { errorStr = errorStr + $g("报告状态错误")+"!<br>"; }
			if (CardNo=="") { errorStr = errorStr + $g("请填写病例编号")+"!<br>"; }
			if (IsInHosp=="") { errorStr = errorStr + $g("请选择是否住院")+"!<br>"; }
			if (PatName=="") { errorStr = errorStr + $g("请填写姓名")+"!<br>"; }
			if (Sex=="") { errorStr = errorStr + $g("请填写性别")+"!<br>"; }
			if (Age=="") { errorStr = errorStr + $g("请填写年龄")+"!<br>"; }
			if (Birthday=="") { errorStr = errorStr + $g("请填写出生日期")+"!<br>"; }
			if (Telephone=="") { errorStr = errorStr + $g("请填写联系方式")+"!<br>"; }
			//if (FixedTel=="") { errorStr = errorStr + "请填写固定电话!"; }
			if ($.trim($('#txtTelephone').val()) != ""){
				if (!(/^1[3456789]\d{9}$/.test($.trim($('#txtTelephone').val())))) {
					errorStr += $g('输入的电话号码格式不符合规定！请重新输入!')+'<br>';
				}
			}
			if (OccupationID=="") { errorStr = errorStr + $g("请选择患者职业")+"!<br>"; }
			if (CardTypeID=="") { errorStr = errorStr + $g("请选择证件类型")+"!<br>"; }
			if (Identify=="") { errorStr = errorStr + $g("请填写证件号")+"!<br>"; }
			if ((RegProvinceID=="")||(CurrProvince=="")) { errorStr = errorStr + $g("请选择户籍所在省")+"!<br>"; }
			if ((RegCityID=="")||(CurrCity=="")) { errorStr = errorStr + $g("请选择户籍所在市")+"!<br>"; }
			if ((RegCountyID=="")||(CurrCounty=="")) { errorStr = errorStr + $g("请选择户籍所在县")+"!<br>"; }
			if ((RegVillageID=="")||(CurrVillage=="")) { errorStr = errorStr + $g("请选择户籍所在乡")+"!<br>"; }
			if (RegRoad=="") { errorStr = errorStr + $g("请填写户籍所在街道")+"!<br>"; }
			if ((CurrProvinceID=="")||(CurrProvince=="")) { errorStr = errorStr + $g("请选择现住省")+"!<br>"; }
			if ((CurrCityID=="")||(CurrCity=="")) { errorStr = errorStr + $g("请选择现住市")+"!<br>"; }
			if ((CurrCountyID=="")||(CurrCounty=="")) { errorStr = errorStr + $g("请选择现住县")+"!<br>"; }
			if ((CurrVillageID=="")||(CurrVillage=="")) { errorStr = errorStr + $g("请选择现住乡")+"!<br>"; }
			if (CurrRoad=="") { errorStr = errorStr + $g("请填写现住街道")+"!<br>"; }
			if (DisCateID=="") { errorStr = errorStr + $g("请选择疾病分类")+"!<br>"; }
			if (DiseaseID=="") { errorStr = errorStr + $g("请选择疾病名称")+"!<br>"; }
			if (SickDate=="") { errorStr = errorStr + $g("请填写发病日期")+"!<br>"; }
			if (SickTime=="") { errorStr = errorStr + $g("请填写发病时间")+"!<br>"; }
			if (AdmitDate=="") { errorStr = errorStr + $g("请填写就诊日期")+"!<br>"; }
			if (AdmitTime=="") { errorStr = errorStr + $g("请填写就诊时间")+"!<br>"; }
			if (PreDiagnosDrs=="") { errorStr = errorStr + $g("请填写初步诊断")+"!<br>"; }
			if (SusAbCauseDrs=="") { errorStr = errorStr + $g("请填写可疑病因")+"!<br>"; }
			if (LurkTime=="") { errorStr = errorStr + $g("请填写潜伏时间")+"!<br>"; }
			if (ReasonID=="") { errorStr = errorStr + $g("请填写上报原因")+"!<br>"; }
			if (MainSym=="") { errorStr = errorStr + $g("请填写主要症状")+"!<br>"; }
			if (OtherSym=="") { errorStr = errorStr + $g("请填写其他症状")+"!<br>";}
			if (MainSign=="") { errorStr = errorStr + $g("请填写主要体征")+"!<br>"; }
			if (SusAbFood=="") { errorStr = errorStr + $g("请填写可疑食品名称")+"!<br>"; }
			if (TestResult=="") { errorStr = errorStr + $g("请填写实验室检查结果")+"!<br>"; }
			if (TestAssist=="") { errorStr = errorStr + $g("请填写辅助检查结果")+"!<br>"; }
			if ($("input[name='chkPreDiagnosDrs'][label='其他']").is(':checked')) { 
				if (PreDiagnos==""){
					errorStr = errorStr + $g("请填写其他初步诊断！"); 
				}
			}
			var OtherInfo = $g("其他");
			if ($("input[name='chkSusAbCauseDrs'][label="+OtherInfo+"]").is(':checked')) { 
				if (SusAbCause==""){
					errorStr = errorStr + $g("请填写其他可疑发病原因！"); 
				}
			}
			// 身份证格式验证
			if(CardType == $g("身份证"))	{
				if ($.trim(Identify) != ""){
					if (!(/(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)|(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$)/.test(Identify))) {
					errorStr += '<P>'+$g('输入的身份证号格式不符合规定！请重新输入!');
				}
			}
			}
			
			var thisNowDate = Common_GetDate(new Date());
			var thisNowTime = Common_GetTime(new Date());
			if ((Common_CompareDate(AdmitDate,thisNowDate)>0)||((AdmitDate == thisNowDate)&&(AdmitTime >thisNowTime)))  {
				$.messager.alert($g("提示"),$g("抱歉，就诊时间不能大于当前日期!"), 'info');
				return false;
			}
			if ((Common_CompareDate(SickDate,AdmitDate)>0)||((SickDate == thisNowDate)&&(SickTime >AdmitTime)))  {
				$.messager.alert($g("提示"),$g("抱歉，发病时间不能大于就诊时间!"), 'info');
				return false;
			}
			if ((Common_CompareDate(SickDate,thisNowDate)>0)||((SickDate == thisNowDate)&&(SickTime >thisNowTime)))  {
				$.messager.alert($g("提示"),$g("抱歉，发病时间不能大于当前日期!"), 'info');
				return false;
			}
			if (errorStr!="") {
				$.messager.alert("提示",'<div style="min-height:20px;max-height:480px;overflow:auto">' + errorStr + '</div>', 'info');
				return;	
			}
		}
		if (statusCode==6) {
			var errorStr = "";
			if (DisCateID=="") { errorStr = errorStr + $g("请选择疾病分类")+"!<br>"; }
			if (DiseaseID=="") { errorStr = errorStr + $g("请选择疾病名称")+"!<br>"; }
			if (SickDate=="") { errorStr = errorStr + $g("请填写发病日期")+"!<br>"; }
			if (SickTime=="") { errorStr = errorStr + $g("请填写发病时间")+"!<br>"; }
			if (AdmitDate=="") { errorStr = errorStr + $g("请填写就诊日期")+"!<br>"; }
			if (AdmitTime=="") { errorStr = errorStr + $g("请填写就诊时间")+"!<br>"; }
			if (errorStr!="") {
				$.messager.alert("提示",'<div style="min-height:20px;max-height:480px;overflow:auto">' + errorStr + '</div>', 'info');
				return;	
			}
		}

		if (IsUpdatePatInfo==0) {	// 基本信息不改变不存
			PatName = "";
			Sex = "";
			Birthday = "";
		}
		var objPatStr = PatName;
		objPatStr = objPatStr + sepobj + Sex;
		objPatStr = objPatStr + sepobj + Birthday;
		objPatStr = objPatStr + sepobj + "" ;   //PersonalID;
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
		tmpStr = tmpStr + separate + CardTypeID;
		tmpStr = tmpStr + separate + Identify;
		tmpStr = tmpStr + separate + IsInHosp;
		tmpStr = tmpStr + separate + Contactor;
		tmpStr = tmpStr + separate + Telephone;
		tmpStr = tmpStr + separate + FixedTel;
		tmpStr = tmpStr + separate + RegAddress;		//户籍地址
		tmpStr = tmpStr + separate + RegProvinceID
		tmpStr = tmpStr + separate + RegCityID
		tmpStr = tmpStr + separate + RegCountyID
		tmpStr = tmpStr + separate + RegVillageID
		tmpStr = tmpStr + separate + RegRoad;
		tmpStr = tmpStr + separate + CurrAddress;		//现住址
		tmpStr = tmpStr + separate + CurrProvinceID
		tmpStr = tmpStr + separate + CurrCityID
		tmpStr = tmpStr + separate + CurrCountyID
		tmpStr = tmpStr + separate + CurrVillageID
		tmpStr = tmpStr + separate + CurrRoad;
		tmpStr = tmpStr + separate + OccupationID;		//职业
		tmpStr = tmpStr + separate + SickDate;
		tmpStr = tmpStr + separate + SickTime;
		tmpStr = tmpStr + separate + AdmitDate;
		tmpStr = tmpStr + separate + AdmitTime;
		tmpStr = tmpStr + separate + LurkTime;		//潜伏时间
		tmpStr = tmpStr + separate + ReasonID;		//上报原因
		tmpStr = tmpStr + separate + PreDiagnosDrs;	//初步诊断
		tmpStr = tmpStr + separate + SusAbCauseDrs;		//可疑病因
		tmpStr = tmpStr + separate + ReportLoc;
		tmpStr = tmpStr + separate + ReportUser;
		tmpStr = tmpStr + separate + ReportDate;
		tmpStr = tmpStr + separate + ReportTime;
		tmpStr = tmpStr + separate + CheckUser;
		tmpStr = tmpStr + separate + CheckDate;
		tmpStr = tmpStr + separate + CheckTime;
		tmpStr = tmpStr + separate + MainSym;		//主要症状
		tmpStr = tmpStr + separate + OtherSym;		//其他症状
		tmpStr = tmpStr + separate + MainSign;		//主要体征
		tmpStr = tmpStr + separate + SusAbFood;		//可疑食品名称
		tmpStr = tmpStr + separate + TestResult;	//实验室检查结果
		tmpStr = tmpStr + separate + TestAssist;	//辅助检查结果
		tmpStr = tmpStr + separate + PreDiagnos;	//初步诊断（其他）
		tmpStr = tmpStr + separate + SusAbCause;	//可疑病因（其他）
		return tmpStr;
	}
	// ****************************** ↑↑↑ save
	
}

