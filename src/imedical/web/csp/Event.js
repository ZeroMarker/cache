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
			ClassName:"DHCMed.FBD.Report",
			MethodName:"GetStringById",
			aID:aID
		},false);
		return objRep;
	}
	/**
	* 获取食源性疾病病人对象数据
	*/
	obj.GetPatStr = function (aReportID) {   
		var GetPatStr = $m({                  
			ClassName:"DHCMed.FBDService.ReportSrv",
			MethodName:"GetPatByRepID",
			aReportID:aReportID
		},false);
		
		return GetPatStr;
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
 		$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height }).appendTo("#FBDReport"); 
 		$("<div class=\"datagrid-mask-msg\"></div>").html("数据加载中,请稍候...").appendTo("#FBDReport").css({ display: "block", left: left, top: top }); 
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
	
	

	$('#txtCurrRoad').bind('change', function (e) {  //鼠标移动之后事件
		var cboProvince = $('#cboCurrProvince').combobox('getText');
		var cboCity = $('#cboCurrCity').combobox('getText');
		var cboCounty = $('#cboCurrCounty').combobox('getText');
		var cboVillage = $('#cboCurrVillage').combobox('getText');
		var txtRoad = $('#txtCurrRoad').val();
		$('#txtCurrAddress').val(cboProvince+cboCity+cboCounty+cboVillage+txtRoad);
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
			obj.gridFoodLoad(reportID);	// FoodInfo
		}
		if (statusCode==2 || statusCode==5 || statusCode==6) { check = true; }	// 已审、删除、外院已报不允许修改
        
        obj.LoadDicInfo();
		obj.clearFoodData();
		obj.DelListFood = "";
		obj.currGridFoodRowID = "";
		obj.setFormDisabled(check);
		obj.showReportButton(statusCode);
	}
	
	obj.gridFoodLoad = function(reportID){	
		$cm ({
			ClassName:"DHCMed.FBDService.ReportSrv",
			QueryName:"QryReportFood",		
			aReportID: reportID
		},function(rs){
			$('#gridFoodInfo').datagrid('loadData', rs);				
		});
    }
    
	obj.setFormDisabled = function(check) {
		var checkPatient = check, checkRepNo = check
		if (!check) {
			if (obj.IsUpdatePatInfo==0) { checkPatient = !check; }
			if (obj.IsUpdateReportNo==0) { checkRepNo = !check; }
			
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
		
		if (check) {
			$('#txtTelephone').attr('disabled','disabled');
			$('#txtCompany').attr('disabled','disabled');
			$('#tmSickTime').timespinner('disable');
			$('#dtSickDate').datebox('disable');
			$('#dtAdmitDate').datebox('disable');
			$('#tmAdmitTime').timespinner('disable');
			$('#dtDeathDate').datebox('disable');
			$('#tmDeathTime').timespinner('disable');
			$('#cboPatArea').combobox('disable');
			$('#cboOccupation').combobox('disable');
			$('#cboCurrProvince').combobox('disable');
			$('#cboCurrCity').combobox('disable');
			$('#cboCurrCounty').combobox('disable');
			$('#cboCurrVillage').combobox('disable');
			$('#txtCurrAddress').attr('disabled','disabled');
			$('#txtCurrRoad').attr('disabled','disabled');
			
			$('#IsInHosp-1').radio('disable');
			$('#IsInHosp-0').radio('disable');	
			
			$('#txtFoodName').attr('disabled','disabled');
			$('#cboFoodType').combobox('disable');
			$('#cboPacking').combobox('disable');
			$('#txtFoodBrand').attr('disabled','disabled');
			
			$('input[type=radio][name=radEatTypeList]').radio('disable');	
			$('#txtEatingPlaces').attr('disabled','disabled');
			$('input[type=radio][name=radBuyTypeList]').radio('disable');	
			$('#txtWhereToBuy').attr('disabled','disabled');
			$('#txtEatingPlaces').attr('disabled','disabled');
			$('#NumEatingNum').attr('disabled','disabled');
			$('#dtEatingDate').datebox('disable');
			$('#tmEatingTime').timespinner('disable');
			$('#IsIncidence-1').radio('disable');
			$('#IsIncidence-0').radio('disable');
			$('#btnSaveFood').linkbutton('disable');
			$('#btnDeleteFood').linkbutton('disable');
			
			
			
			var chkListSign = document.getElementsByName("chkList");
			if (chkListSign) {
				for (var i=0; i<chkListSign.length; i++) {
					$('#'+chkListSign[i].id).checkbox('disable');	
				}
			}
		}else {
			$('#txtTelephone').removeAttr('disabled');
			$('#txtCompany').removeAttr('disabled');
			$('#txtCurrAddress').removeAttr('disabled');
			$('#txtCurrRoad').removeAttr('disabled');
			$('#txtDisText').removeAttr('disabled');
			
			$('#tmSickTime').timespinner('enable');
			$('#dtSickDate').datebox('enable');
			$('#dtAdmitDate').datebox('enable');
			$('#tmAdmitTime').timespinner('enable');
			$('#dtDeathDate').datebox('enable');
			$('#tmDeathTime').timespinner('enable');
			$('#cboPatArea').combobox('enable');
			$('#cboOccupation').combobox('enable');
			$('#cboCurrProvince').combobox('enable');
			$('#cboCurrCity').combobox('enable');
			$('#cboCurrCounty').combobox('enable');
			$('#cboCurrVillage').combobox('enable');
			
			$('#IsInHosp-1').radio('enable');
			$('#IsInHosp-0').radio('enable');	
			
			
			$('#txtFoodName').removeAttr('disabled');
			$('#cboFoodType').combobox('enable');
			$('#cboPacking').combobox('enable');
			$('#txtFoodBrand').removeAttr('disabled');
			
			$('input[type=radio][name=radEatTypeList]').radio('enable');	
			$('#txtEatingPlaces').removeAttr('disabled');
			$('input[type=radio][name=radBuyTypeList]').radio('enable');	
			$('#txtWhereToBuy').removeAttr('disabled');
			$('#txtEatingPlaces').removeAttr('disabled');
			$('#NumEatingNum').removeAttr('disabled');
			$('#dtEatingDate').datebox('enable');
			$('#tmEatingTime').timespinner('enable');
			$('#IsIncidence-1').radio('enable');
			$('#IsIncidence-0').radio('enable');
			$('#btnSaveFood').linkbutton('enable');
			$('#btnDeleteFood').linkbutton('enable');
			
			var chkListSign = document.getElementsByName("chkList");
			if (chkListSign) {
				for (var i=0; i<chkListSign.length; i++) {
					$('#'+chkListSign[i].id).checkbox('enable');	
				}
			}
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
			obj.objCurrCtLoc  = obj.LoadLoc(arrCurrRep[28]);
			arrLocInfo = obj.objCurrCtLoc.split('^');
			obj.objCurrUser = obj.LoadUser(arrCurrRep[30]);
			arrUserInfo = obj.objCurrUser.split('^');
		} else {
			obj.objCurrCtLoc  = obj.LoadLoc(session['LOGON.CTLOCID']);
			arrLocInfo = obj.objCurrCtLoc.split('^');
			obj.objCurrUser = obj.LoadUser(session['LOGON.USERID']);
			arrUserInfo = obj.objCurrUser.split('^');
		}
		
		obj.objCurrPaadm = obj.objPaadmManage(EpisodeID);
		obj.objCurrPatient = obj.objPatientManage(PatientID);
		
		var DiseaseID = "", Disease = "", DisCateID = "",DisCate = "", DiseaseText = "", RepStatus = "", AreaID = "", Area = "", OccupationID = "", Occupation = "";
		var PatName="", Sex = "", Birthday = "", PersonalID = "", Nation = "", OPNo = "", IPNo = "";
		var CurrAddress = "", CurrProvinceID = "",  CurrProvince = "",CurrCityID = "", CurrCity = "",CurrCountyID = "", CurrCounty = "",CurrVillageID = "",CurrVillage = "",  CurrRoad = "";
		var SickDate = "", SickTime = "", AdmitDate = "", AdmitTime = "", DeathDate = "", DeathTime = "";
		var CardNo = "", IsInHosp = "", Contactor = "", Telephone = "", Company = "";
		var IsUseAnti = "", UseAntiDesc = "", PreDiagnosDrs = "", PreDiagnos = "",AnamnesisDrs = "", Anamnesis = "", ReportLoc = "", ReportUser = "";
		var RepPlace = "", Age = "", RepLoc = "", RepUser = "" ,AdmDoctor = "" , ExamResult = "";
		
		if (obj.objCurrReport) {	// 报告信息
			var strPatient = obj.GetPatStr(reportID);
			var arrPatient = strPatient.split("^")
			if (strPatient) {
				PatName = arrPatient[0]  						// 患者姓名
				Sex = arrPatient[1] 							// 性别
				Birthday = arrPatient[2] 					// 出生日期
			}
			
			var statusID = arrCurrRep[4].split(CHR_1)[0];	   // 报告状态
			var RepStatus = arrCurrRep[4].split(CHR_1)[1];

			var AreaID = arrCurrRep[11].split(CHR_1)[0];	    // 病人属于
			var Area = arrCurrRep[11].split(CHR_1)[1];	    
			var OccupationID = arrCurrRep[18].split(CHR_1)[0];	// 患者职业
			var Occupation = arrCurrRep[18].split(CHR_1)[1];	
			var DiseaseID = arrCurrRep[2].split(CHR_1)[0];	    // 疾病信息
		    var Disease = arrCurrRep[2].split(CHR_1)[2];
			if (DiseaseID) {
				var objDisease = obj.objDiseaseManage(DiseaseID);
				if (objDisease) { 
					DisCateID = objDisease.IDCateDr;
					objDic = obj.objDicManage(DisCateID);
					if (objDic) {
						DisCate = objDic.Description; 
					}					
				}
			}
			CardNo = arrCurrRep[5];				// 病例编号	// 提交时生成
			IsInHosp = arrCurrRep[7];			// 是否住院
			Telephone = arrCurrRep[9];			// 联系电话
			Company = arrCurrRep[10];			// 单位
			CurrAddress = arrCurrRep[12];		// 现住址
			CurrProvinceID = arrCurrRep[13].split(CHR_1)[0];	    // 省
			CurrProvince = arrCurrRep[13].split(CHR_1)[1];	    
			CurrCityID = arrCurrRep[14].split(CHR_1)[0];			// 市
			CurrCity = arrCurrRep[14].split(CHR_1)[1];			
			CurrCountyID = arrCurrRep[15].split(CHR_1)[0];		    // 县
			CurrCounty = arrCurrRep[15].split(CHR_1)[1];		
			CurrVillageID = arrCurrRep[16].split(CHR_1)[0];		    // 乡
			CurrVillage = arrCurrRep[16].split(CHR_1)[1];		    
			CurrRoad = arrCurrRep[17];			// 街道
			SickDate = arrCurrRep[19];			// 发病日期
			SickTime = arrCurrRep[20];			// 发病时间
			AdmitDate = arrCurrRep[21];			// 就诊日期
			AdmitTime = arrCurrRep[22];			// 就诊时间
			DeathDate = arrCurrRep[23];			// 死亡日期
			DeathTime = arrCurrRep[24];			// 死亡时间
			RepLoc = arrCurrRep[28];			// 报告科室
			RepUser = arrCurrRep[30];			// 报告人
			
			ExamResult = arrCurrRep[42];		// 检测结果
			AdmDoctor = arrCurrRep[43];			// 接诊医生
		} else {
			//存在临床诊断DiseaseID;
			if (obj.diseaseID) {
				DiseaseID = obj.diseaseID;
				var objDisease = obj.objDiseaseManage(DiseaseID);
				if (objDisease) {
					Disease  = objDisease.IDDesc;
					DisCateID = objDisease.IDCateDr;
					objDic = obj.objDicManage(DisCateID);
					if (objDic) {
						DisCate = objDic.Description; 
					}					
				}
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
			     OccupationID = OccupationInfo.split(",")[0];
			     Occupation = OccupationInfo.split(",")[2];
			}			
		}
		if (obj.objCurrPaadm) {	// 就诊信息
			if (AdmDoctor=="") {AdmDoctor = obj.objCurrPaadm.DoctorName}
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
			if (!Company) { Company = obj.objCurrPatient.WorkAddress; }				// 工作单位
		}
		
		RepLoc = arrLocInfo[2];	            // 报告科室
		RepUser = arrUserInfo[2];	        // 报告人
		$('#txtRepLoc').val(RepLoc);	   
		$('#txtRepUser').val(RepUser);	
		$('#txtRepDate').datebox('setValue',Common_GetDate(new Date()));	// 报告位置
		$('#RepStatus').val(RepStatus);	// 报告状态
	
		
		$('#txtCardNo').val(CardNo);	    // 报告编号
		if (IsInHosp) {
			$HUI.radio("#IsInHosp-"+IsInHosp).setValue(true); // 是否住院
		}
		$('#txtPatName').val(PatName);	    					// 姓名
		$('#txtSex').val(Sex);	            					// 性别
		$('#txtAge').val(Age);	            					// 年龄
		$('#dtBirthday').datebox('setValue',Birthday);			// 出生日期
		$('#txtContactor').val(Contactor);	    				// 监护人姓名
		$('#txtTelephone').val(Telephone);	    				// 联系方式
		
		$('#cboOccupation').combobox('setValue',OccupationID)	// 患者职业
		$('#cboOccupation').combobox('setText',Occupation)		// 患者职业
		$('#cboPatArea').combobox('setValue', AreaID)	        // 病人属于
		$('#cboPatArea').combobox('setText', Area)	        	// 病人属于
		$('#txtCompany').val(Company);	        				// 单位
		$('#dtSickDate').datebox('setValue',SickDate);			// 发病时间
		$('#tmSickTime').timespinner('setValue',SickTime);
		$('#dtAdmitDate').datebox('setValue',AdmitDate);		// 就诊时间
		$('#tmAdmitTime').timespinner('setValue',AdmitTime);
		$('#dtDeathDate').datebox('setValue',DeathDate);		// 死亡时间
		$('#tmDeathTime').timespinner('setValue',DeathTime);

		$('#ExamResult').val(ExamResult);	        			// 检测结果
		$('#DiagDoc').val(AdmDoctor);	        				// 接诊医生
		// 省市县乡
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
		$('#cboDisCate').combobox('setValue',DisCateID);    // 疾病分类
		$('#cboDisCate').combobox('setText',DisCate);    
		$('#cboDisDesc').combobox('setValue',DiseaseID);    // 疾病字典	
		$('#cboDisDesc').combobox('setText',Disease);  		
	
	}
	// ****************************** ↑↑↑ refresh
	
	// 按钮触发事件
	obj.RelationToEvents = function() {
		$('#btnSaveFood').on("click", function(){
			obj.btnSaveFood_click(); 
		});
		$('#btnDeleteFood').on("click", function(){
			obj.btnDeleteFood_click(); 
		});
		
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
			$.messager.confirm("提示", "请确认是否取消审核?", function (r) {
				if (r){
					obj.btnCancheck_click(); 
				}
			});
		});
		$('#btnReturn').on("click", function(){
			$.messager.prompt("退回", "请输入退回原因!", function (r) {
				if (r){
					obj.btnReturn_click(r); 
				}else{
					$.messager.alert("提示", "退回原因不能为空！", 'info');
				}		
			});
		});
		$('#btnDelete').on("click", function(){
			$.messager.confirm("提示", "请确认是否作废？", function (r) {
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
		
		// 食源性疾病所属与现住址强制关联
		if (ServerObj.FBDRegionRelateCurrAdd == '1' && ServerObj.FBDInitAddressByLocalHospital != '') {
			var InitAddrArray = ServerObj.FBDInitAddressByLocalHospital.split('`');
			$('#cboPatArea').combobox({
				onChange: function(newValue,oldValue) {
					setTimeout(function(){
						var PatAreaDesc = $('#cboPatArea').combobox('getText');
						if (PatAreaDesc == "本县区") {				//本县区
							$('#cboCurrProvince').combobox('setValue',InitAddrArray[0].split('^')[0]);
							$('#cboCurrProvince').combobox('setText',InitAddrArray[0].split('^')[1]);
							$('#cboCurrCity').combobox('setValue',InitAddrArray[1].split('^')[0]);
							$('#cboCurrCity').combobox('setText',InitAddrArray[1].split('^')[1]);
							$('#cboCurrCounty').combobox('setValue',InitAddrArray[2].split('^')[0]);
							$('#cboCurrCounty').combobox('setText',InitAddrArray[2].split('^')[1]);
							$('#cboCurrVillage').combobox('clear');
							$('#txtCurrRoad').val("");
							$('#txtCurrAddress').val("");
						}else if (PatAreaDesc == "本市其它县区") {		//本市其他县区
							$('#cboCurrProvince').combobox('setValue',InitAddrArray[0].split('^')[0]);
							$('#cboCurrProvince').combobox('setText',InitAddrArray[0].split('^')[1]);
							$('#cboCurrCity').combobox('setValue',InitAddrArray[1].split('^')[0]);
							$('#cboCurrCity').combobox('setText',InitAddrArray[1].split('^')[1]);
							$('#cboCurrCounty').combobox('clear');
							$('#cboCurrVillage').combobox('clear');
							$('#txtCurrRoad').val("");
							$('#txtCurrAddress').val("");
						}else if (PatAreaDesc == "本省其它城市") {		//本省其它地市
							$('#cboCurrProvince').combobox('setValue',InitAddrArray[0].split('^')[0]);
							$('#cboCurrProvince').combobox('setText',InitAddrArray[0].split('^')[1]);
							$('#cboCurrCity').combobox('clear');
							$('#cboCurrCounty').combobox('clear');
							$('#cboCurrVillage').combobox('clear');
							$('#txtCurrRoad').val("");
							$('#txtCurrsAddress').val("");
						}else{
							$('#cboCurrProvince').combobox('clear');
							$('#cboCurrCity').combobox('clear');
							$('#cboCurrCounty').combobox('clear');
							$('#cboCurrVillage').combobox('clear');
							$('#txtCurrRoad').val("");
							$('#txtCurrsAddress').val("");
						}
			        }, 200)
				}
			})
		}
	}
	
	// ****************************** ↓↓↓ food func
	obj.btnSaveFood_click = function() {
		var errorStr = "";
		var FoodName = $.trim($('#txtFoodName').val());
		var FoodTypeID = $.trim($('#cboFoodType').combobox('getValue'));
		var FoodType = $.trim($('#cboFoodType').combobox('getText'));
		var PackingID = $.trim($('#cboPacking').combobox('getValue'));
		var Packing = $.trim($('#cboPacking').combobox('getText'));
		var FoodBrand = $.trim($('#txtFoodBrand').val());
		
		
		var EatingType = Common_RadioValue('radEatTypeList');
		var EatingTypeDesc = Common_RadioLabel('radEatTypeList'); 
		var EatProvince = $.trim($('#cboEatProvince').combobox('getValue'));
		var EatProvinceDesc = $.trim($('#cboEatProvince').combobox('getText'));		
		var EatCity = $.trim($('#cboEatCity').combobox('getValue'));
		var EatCityDesc = $.trim($('#cboEatCity').combobox('getText'));		
		var EatCounty = $.trim($('#cboEatCounty').combobox('getValue'));
		var EatCountyDesc = $.trim($('#cboEatCounty').combobox('getText'));			
		var EatingPlaces = $.trim($('#txtEatingPlaces').val());
		var BuyType = Common_RadioValue('radBuyTypeList'); 
		var BuyTypeDesc = Common_RadioLabel('radBuyTypeList'); 	
		var BuyProvince = $.trim($('#cboBuyProvince').combobox('getValue'));
		var BuyProvinceDesc = $.trim($('#cboBuyProvince').combobox('getText'));		
		var BuyCity = $.trim($('#cboBuyCity').combobox('getValue'));
		var BuyCityDesc = $.trim($('#cboBuyCity').combobox('getText'));		
		var BuyCounty = $.trim($('#cboBuyCounty').combobox('getValue'));
		var BuyCountyDesc = $.trim($('#cboBuyCounty').combobox('getText'));		
		var WhereToBuy = $.trim($('#txtWhereToBuy').val());
		var EatingDate = $('#dtEatingDate').datebox('getValue');	
		var EatingTime = $('#tmEatingTime').timespinner('getValue');
		var EatingNum = $.trim($('#NumEatingNum').numberbox('getValue'));
		
		var IsIncidence = "", IsIncidenceDesc = "";
		var IsIncidence     = $("input[name='IsIncidence']:checked").val(); 
		var IsIncidenceDesc = $("input[name='IsIncidence']:checked").attr("label");
		
		if (FoodName=="") { errorStr = errorStr + "请填写食品名称!"; }
		if (FoodTypeID=="") { errorStr = errorStr + "请选择食品分类!"; }
		if (PackingID=="") { errorStr = errorStr + "请选择加工或包装方式!"; }
		
		if (EatingType=="") { errorStr = errorStr + "请填写进食地点类型!"; }
				if (EatingTypeDesc=="境内") {
			if ((EatProvince=="")||(EatCity=="")||(EatCounty=="")||(EatingPlaces=="")){ 
				errorStr = errorStr + "请填写进食地点!";
			}
		}else {
			if (EatingPlaces==""){ 
				errorStr = errorStr + "请填写进食地点!";
			}
		}
		if (BuyType=="") { errorStr = errorStr + "请选择购买地点类型!"; }
		if (BuyTypeDesc=="境内") {
			if ((BuyProvince=="")||(BuyCity=="")||(BuyCounty=="")||(WhereToBuy=="")){ 
				errorStr = errorStr + "请填写购买地点!";
			}
		}else {
			if (WhereToBuy==""){ 
				errorStr = errorStr + "请填写购买地点!";
			}
		}
		if (EatingDate=="" || EatingTime=="") { errorStr = errorStr + "请填写进食时间!"; }
		if (EatingNum=="") { errorStr = errorStr + "请填写进食人数!";}
		if ((!IsIncidence) || (!IsIncidenceDesc)) { errorStr = errorStr + "请选择其他人是否发病!"; }
	
		var thisNowDate = Common_GetDate(new Date());
		var thisNowTime = Common_GetTime(new Date());
		var SickDate = $('#dtSickDate').datebox('getValue');
		if (Common_CompareDate(EatingDate,thisNowDate)>0) {
			$.messager.alert("提示","抱歉，进食日期不能大于当前日期!", 'info');
			return false;
		}
		if ((EatingDate==thisNowDate)&&(Common_CompareTime(EatingTime,thisNowTime)>0)) {
			$.messager.alert("提示","抱歉，进食日期为今天进食时间不能大于当前时间!", 'info');
			return false;
		}
		if (Common_CompareDate(EatingDate,SickDate)>0) {
			$.messager.alert("提示","抱歉，进食日期不能大于发病日期!", 'info');
			return false;
		}
		
		if (errorStr!="") {
			$.messager.alert("提示", errorStr, 'info');
			return;
		}
		var ID = "";
		var selectObj = obj.gridFood.getSelected();
		if (selectObj) {
			var ind = obj.gridFood.getRowIndex(selectObj);  //获取当前选中行的行号(从0开始)
			obj.gridFood.updateRow({  //更新指定行
				index: ind,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
				row: {
					ID:selectObj.ID,
					FoodName: FoodName,
					FoodTypeID: FoodTypeID,
					FoodType: FoodType,
					PackingID: PackingID,
					Packing: Packing,
					FoodBrand:  FoodBrand,
					EatingTypeID: EatingType,
					EatingTypeDesc: EatingTypeDesc,
					EatProvince: EatProvince,
					EatProvinceDesc: EatProvinceDesc,
					EatCity: EatCity,
					EatCityDesc: EatCityDesc,
					EatCounty: EatCounty,
					EatCountyDesc: EatCountyDesc,
					EatingPlaces:  EatingPlaces,
					BuyTypeID: BuyType,
					BuyTypeDesc: BuyTypeDesc,
					BuyProvince: BuyProvince,
					BuyProvinceDesc: BuyProvinceDesc,
					BuyCity: BuyCity,
					BuyCityDesc: BuyCityDesc,
					BuyCounty: BuyCounty,
					BuyCountyDesc: BuyCountyDesc,
					WhereToBuy: WhereToBuy,
					EatingDate: EatingDate,
					EatingTime: EatingTime,
					EatingNum: EatingNum,
					IsIncidence: IsIncidence,
					IsIncidenceDesc: IsIncidenceDesc
				}
			});
		} else {
			obj.gridFood.appendRow({ //追加一个新行。新行将被添加到最后的位置。
				ID: '',
				FoodName: FoodName,
				FoodTypeID: FoodTypeID,
				FoodType: FoodType,
				PackingID: PackingID,
				Packing: Packing,
				FoodBrand: FoodBrand,
				EatingTypeID: EatingType,
				EatingTypeDesc: EatingTypeDesc,
				EatProvince: EatProvince,
				EatProvinceDesc: EatProvinceDesc,
				EatCity: EatCity,
				EatCityDesc: EatCityDesc,
				EatCounty: EatCounty,
				EatCountyDesc: EatCountyDesc,
				EatingPlaces:  EatingPlaces,
				BuyTypeID: BuyType,
				BuyTypeDesc: BuyTypeDesc,	
				BuyProvince: BuyProvince,
				BuyProvinceDesc: BuyProvinceDesc,
				BuyCity: BuyCity,
				BuyCityDesc: BuyCityDesc,
				BuyCounty: BuyCounty,
				BuyCountyDesc: BuyCountyDesc,
				WhereToBuy: WhereToBuy,
				EatingDate: EatingDate,
				EatingTime: EatingTime,
				EatingNum: EatingNum,
				IsIncidence: IsIncidence,
				IsIncidenceDesc: IsIncidenceDesc
			});
		}		

		obj.clearFoodData();
	}
	
	obj.btnDeleteFood_click = function() {
		var selectObj = obj.gridFood.getSelected(); 
		var index =obj.gridFood.getRowIndex(selectObj);  //获取当前选中行的行号(从0开始)
		
		if (!selectObj) {
			$.messager.alert("提示", "请选中一条记录!", 'info');
			return;
		}else {
			$.messager.confirm("提示", "确认要删除该条暴露信息数据?", function (r) {
				if (r){			
					if (selectObj.ID!="") {
						obj.DelListFood = obj.DelListFood + selectObj.ID + ",";
					}		
					obj.gridFood.deleteRow(index);
					obj.clearFoodData();
					//obj.gridFood.reload();
				}
			});
		}				
	}
	
	obj.gridFood_rowclick = function() {
		var objRec = obj.gridFood.getSelected();
		if (obj.currGridFoodRowID && obj.currGridFoodRowID==objRec.ID) {
			obj.clearFoodData();
		} else {
			obj.showFoodData(objRec);
		}
	}
	
	obj.clearFoodData = function() {
		obj.currGridFoodRowID = "";
		$('#txtFoodName').val('');
		$('#cboFoodType').combobox('clear');
		$('#cboPacking').combobox('clear');
		$('#txtFoodBrand').val('');
		$HUI.radio('input[type=radio][name=radEatTypeList]').uncheck();
		$('#cboEatProvince').combobox('clear');	
		$('#cboEatCity').combobox('clear');			
		$('#cboEatCounty').combobox('clear');	
		$('#txtEatingPlaces').val('');
		$HUI.radio('input[type=radio][name=radBuyTypeList]').uncheck();
		$('#cboBuyProvince').combobox('clear');			
		$('#cboBuyCity').combobox('clear');			
		$('#cboBuyCounty').combobox('clear');	
		$('#txtWhereToBuy').val('');
		$('#dtEatingDate').datebox('clear');
		$('#tmEatingTime').timespinner('clear'); 
		$('#NumEatingNum').numberbox('clear'); 
		$HUI.radio("#IsIncidence-1").uncheck();
		$HUI.radio("#IsIncidence-0").uncheck();
		obj.gridFood.clearSelections();  //清除选中行
	}
	
	obj.showFoodData = function(objRow) {
		obj.currGridFoodRowID = objRow.ID;
		$('#txtFoodName').val(objRow.FoodName);
		$('#cboFoodType').combobox('setValue',objRow.FoodTypeID);
		$('#cboFoodType').combobox('setText',objRow.FoodType);
		$('#cboPacking').combobox('setValue',objRow.PackingID);	
		$('#cboPacking').combobox('setText',objRow.Packing);			
		$('#txtFoodBrand').val(objRow.FoodBrand);
		
	
		if (objRow.EatingTypeID) {
			$HUI.radio('#radEatTypeList'+objRow.EatingTypeID).setValue(true); //进食地点
		}	
		$('#cboEatProvince').combobox('setValue',objRow.EatProvince);
		$('#cboEatProvince').combobox('setText',objRow.EatProvinceDesc);			
		$('#cboEatCity').combobox('setValue',objRow.EatCity);
		$('#cboEatCity').combobox('setText',objRow.EatCityDesc);		
		$('#cboEatCounty').combobox('setValue',objRow.EatCounty);	
		$('#cboEatCounty').combobox('setText',objRow.EatCountyDesc);	
		$('#txtEatingPlaces').val(objRow.EatingPlaces);
		if (objRow.BuyTypeID) {
			$HUI.radio('#radBuyTypeList'+objRow.BuyTypeID).setValue(true); //购买地点
		}	
		$('#cboBuyProvince').combobox('setValue',objRow.BuyProvince);
		$('#cboBuyProvince').combobox('setText',objRow.BuyProvinceDesc);		
		$('#cboBuyCity').combobox('setValue',objRow.BuyCity);
		$('#cboBuyCity').combobox('setText',objRow.BuyCityDesc);				
		$('#cboBuyCounty').combobox('setValue',objRow.BuyCounty);
		$('#cboBuyCounty').combobox('setText',objRow.BuyCountyDesc);	
		$('#txtWhereToBuy').val(objRow.WhereToBuy);
	
		$('#dtEatingDate').datebox('setValue',objRow.EatingDate);
		$('#tmEatingTime').timespinner('setValue',objRow.EatingTime); 
		$('#NumEatingNum').numberbox('setValue',objRow.EatingNum);
		$HUI.radio("#IsIncidence-"+objRow.IsIncidence).setValue(true);	
	}
	// ****************************** ↑↑↑ food func
	
  
	
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
	
	obj.btnReturn_click = function(r) {	// 退回
		obj.saveReportStatus(3, "^",r);
	}
	
	obj.btnDelete_click = function() {	// 作废
		obj.saveReportStatus(5, "^");
	}
	
	obj.btnReported_click = function() {	// 外院已报
		obj.saveReportInfo(6, "^");
	}
	
	obj.btnPrint_click = function() {	// 打印
		var fileName="DHCMed.FBD.Report.raq&aReportID="+obj.reportID;
		DHCCPM_RQPrint(fileName);
	}
	
	obj.btnClose_click = function() {
		 //关闭
		websys_showModal('close');
	}
	// ****************************** ↑↑↑ report func
	
	// ****************************** ↓↓↓ save
	obj.saveReportStatus = function(statusCode, separate,atext) {
	var statusID = "", checkUser = session['LOGON.USERID'];
		var objStatus = obj.IsExistDic("FBDREPORTSTATUS", statusCode);
		if (objStatus) { statusID = objStatus.ID; }
		if (obj.reportID=="" || statusID=="") {
			$.messager.alert("提示", "操作失败!", 'info');
			return;
		}
		var checkDate = "", checkTime = "", resume = "";
		var inputStr = obj.reportID;
		if(statusCode=="3"){var resume = atext;}
		inputStr = inputStr + separate + statusID;
		inputStr = inputStr + separate + checkUser;
		inputStr = inputStr + separate + checkDate;
		inputStr = inputStr + separate + checkTime;
		inputStr = inputStr + separate + resume;
		
		var ret = $m({                  
			ClassName:"DHCMed.FBD.Report",
			MethodName:"UpdateStatus",
			aInputStr:inputStr, 
			aSeparate:separate
		},false);
		if (ret>0) {
			$.messager.alert("提示", "操作成功!", 'info');
			obj.refreshFormInfo(ret);
		} else {
			$.messager.alert("提示", "操作失败!", 'info');
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
						$.messager.alert("提示", "如选发热 则体温必填，呕吐(腹泻) 则__次/天必填，其他 则其他项必填!", 'info');
						return;
					}
				}
				
			}
		}
		
		if (chkSignCount==0 && statusCode==1) {
			$.messager.alert("提示", "请至少选择一项主要症状与体征!", 'info');
			return;
		}
		var retRep = $m({                  
			ClassName:"DHCMed.FBD.Report",
			MethodName:"Update",
			aInputStr:inputStr, 
			aSeparate:separate,
			aSepObj:sepobj
		},false);
		console.log(inputStr);
		if (retRep>0) {
			var retSign = obj.saveSign(retRep, separate);
			var retFood = obj.saveFood(retRep, separate);
			if (retSign<0) { errorStr = errorStr + "体征信息保存失败!"; }
			if (retFood<0) { errorStr = errorStr + "暴露信息保存失败!"; }
		} else {
			errorStr = errorStr + "报告信息保存失败!";
		}
		if (errorStr=="") {
			errorStr = "保存成功!";
			obj.refreshFormInfo(retRep);
			//新建报告保存成功后不关闭窗口直接刷新时，界面显示空白问题处理
			if (typeof(history.pushState) === 'function') {
			  	var Url=window.location.href;
		        Url=rewriteUrl(Url, {
			        ReportID:retRep
		        });
		    	history.pushState("", "", Url);
		        //return;
			}
		}
		$.messager.alert("提示", errorStr, 'info');
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
					ClassName:"DHCMed.FBD.ReportSign",
					MethodName:"Update",
					aInputStr:inputStr,
					aSeparate:separate
				},false); 
				
				if (ret<=0) { signFlg = signFlg - 1; }
				$('#'+tmpSign.id).attr('value',ret);   //修改新建报告不关闭报告情况下直接修改，重复插入数据问题
	
			} else if (!tmpSign.checked && tmpSign.value!="") {	// 取消选中delete
				var ret = $m({       
					ClassName:"DHCMed.FBD.ReportSign",
					MethodName:"DeleteById",
					aID:tmpSign.value
				},false); 
				if (ret<=0) { signFlg = signFlg - 1; }
			}
		}
		return signFlg;
	}
	
	obj.saveFood = function(reportID, separate) {
		var foodFlg = 0;
	    var rows = obj.gridFood.getRows();  //返回当前页的所有行
		var foodLength = rows.length;
		
		for (var i=0; i< foodLength; i++) {	// Update
			var tmpFood = rows[i];
			var subID = "";
			if (tmpFood.ID!="") { subID = tmpFood.ID.split("||")[1]; }
			var FoodName 		= tmpFood.FoodName;
			var FoodTypeID 		= tmpFood.FoodTypeID;
			var PackingID 		= tmpFood.PackingID;
			var FoodBrand 		= tmpFood.FoodBrand;
			var Manufacturer 	= "";
			var EatingSiteCateID= "";
			var EatingSiteID 	= "";
			var BuySiteCateID 	= "";
			var BuySiteID 		= "";
			var EatingTypeID 	= tmpFood.EatingTypeID;
			var EatProvince 	= tmpFood.EatProvince;
			var EatCity 		= tmpFood.EatCity;
			var EatCounty 		= tmpFood.EatCounty;
			var EatingPlaces 	= tmpFood.EatingPlaces;
			var BuyTypeID 		= tmpFood.BuyTypeID;
			var BuyProvince 	= tmpFood.BuyProvince;
			var BuyCity 		= tmpFood.BuyCity;
			var BuyCounty 		= tmpFood.BuyCounty;
			var WhereToBuy 		= tmpFood.WhereToBuy;
			var EatingDate 		= tmpFood.EatingDate;
			var EatingTime 		= tmpFood.EatingTime;
			var EatingNum 		= tmpFood.EatingNum;
			var IsIncidence 	= tmpFood.IsIncidence;
			var IsSampling 		= "";
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
			
			inputStr = inputStr + separate + FoodTypeID;
			inputStr = inputStr + separate + PackingID;
			inputStr = inputStr + separate + EatingSiteCateID;
			inputStr = inputStr + separate + EatingSiteID;
			inputStr = inputStr + separate + BuySiteCateID;
			inputStr = inputStr + separate + BuySiteID;
			inputStr = inputStr + separate + EatingTypeID;
			inputStr = inputStr + separate + EatProvince;
			inputStr = inputStr + separate + EatCity;
			inputStr = inputStr + separate + EatCounty;
			inputStr = inputStr + separate + BuyTypeID;
			inputStr = inputStr + separate + BuyProvince;
			inputStr = inputStr + separate + BuyCity;
			inputStr = inputStr + separate + BuyCounty;
			var ret = $m({       
				ClassName:"DHCMed.FBD.ReportFood",
				MethodName:"Update",
				aInputStr:inputStr,
				aSeparate:separate
			},false); 
			
			if (ret<=0) { foodFlg = foodFlg - 1; }
		}
		if (obj.DelListFood!="") {	// Delete
			obj.DelListFood = obj.DelListFood.substring(0, obj.DelListFood.length-1);
			var objDelList = obj.DelListFood.split(",");
			for (var j=0; j<objDelList.length; j++) { 
				var ret = $m({       
					ClassName:"DHCMed.FBD.ReportFood",
					MethodName:"DeleteById",
					aID:objDelList[j]
				},false); 
				
				if (ret<=0) { foodFlg = foodFlg - 1; }
			}
		}
		
		return foodFlg;
	}
	
	
	obj.saveReportStr = function(statusCode, separate, sepobj) {
		var StatusID = "";
		var objStatus = obj.IsExistDic("FBDREPORTSTATUS", statusCode);
		if (objStatus) { StatusID = objStatus.ID; }

		var CardNo = $.trim($('#txtCardNo').val());	                    // 报告编号
	
		if (obj.IsUpdateReportNo==0 && CardNo=="") {	            // 报告编号自动生成
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
		var Birthday = $('#dtBirthday').datebox('getValue');			// 出生日期
		var Telephone = $.trim($('#txtTelephone').val());	            // 联系方式
		
		var OccupationID = $.trim($('#cboOccupation').combobox('getValue'));	// 患者职业
		var AreaID = $.trim($('#cboPatArea').combobox('getValue'));	   	// 病人属于
		var Company = $.trim($('#txtCompany').val());					// 单位
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
		
		var SickDate = $('#dtSickDate').datebox('getValue');	// 发病时间
		var SickTime = $('#tmSickTime').timespinner('getValue');
		var AdmitDate = $('#dtAdmitDate').datebox('getValue');	// 就诊时间
		var AdmitTime = $('#tmAdmitTime').timespinner('getValue');
		var DeathDate = $('#dtDeathDate').datebox('getValue');	// 死亡时间
		var DeathTime = $('#tmDeathTime').timespinner('getValue');
		
		var ExamResult = $.trim($('#ExamResult').val());		// 检测结果
		var DiagDoc = $.trim($('#DiagDoc').val());				// 接诊医生
		
		var EpisodeID = "", PatientID = "", ReportLoc = "";
		var ReportUser = "", ReportDate = "", ReportTime = "";
		var CheckUser = "", CheckDate = "", CheckTime = "", Resume = "";
		if (obj.objCurrPaadm) { EpisodeID = obj.objCurrPaadm.AdmRowID; }
		if (obj.objCurrPatient) { PatientID = obj.objCurrPatient.Papmi; }
		if (obj.objCurrCtLoc) { ReportLoc = obj.objCurrCtLoc.split('^')[0] }
		if (obj.objCurrUser) { ReportUser = obj.objCurrUser.split('^')[0]}
		
		if (statusCode==1 || statusCode==2) {
			var errorStr = "";
			if (StatusID=="") { errorStr = errorStr + "报告状态错误!<br>"; }
			if (CardNo=="") { errorStr = errorStr + "请填写病例编号!<br>"; }
			if (IsInHosp=="") { errorStr = errorStr + "请选择是否住院!<br>"; }
			if (PatName=="") { errorStr = errorStr + "请填写姓名!<br>"; }
			if (Sex=="") { errorStr = errorStr + "请填写性别!<br>"; }
			if (Age=="") { errorStr = errorStr + "请填写年龄!<br>"; }
			if (Birthday=="") { errorStr = errorStr + "请填写出生日期!<br>"; }
			if (Telephone=="") { errorStr = errorStr + "请填写联系方式!<br>"; }
			if (OccupationID=="") { errorStr = errorStr + "请选择患者职业!<br>"; }
			if (AreaID=="") { errorStr = errorStr + "请选择病人属于!<br>"; }
			if ((CurrProvinceID=="")||(CurrProvince=="")) { errorStr = errorStr + "请选择省!<br>"; }
			if ((CurrCityID=="")||(CurrCity=="")) { errorStr = errorStr + "请选择市!<br>"; }
			if ((CurrCountyID=="")||(CurrCounty=="")) { errorStr = errorStr + "请选择县!<br>"; }
			if ((CurrVillageID=="")||(CurrVillage=="")) { errorStr = errorStr + "请选择乡!<br>"; }
			if (CurrRoad=="") { errorStr = errorStr + "请填写街道!<br>"; }
			if (SickDate=="") { errorStr = errorStr + "请填写发病日期!<br>"; }
			if (SickTime=="") { errorStr = errorStr + "请填写发病时间!<br>"; }
			if (AdmitDate=="") { errorStr = errorStr + "请填写就诊日期!<br>"; }
			if (AdmitTime=="") { errorStr = errorStr + "请填写就诊时间!<br>"; }
			if (DiagDoc=="") { errorStr = errorStr + "请填写就诊医生!<br>"; }
			
			//电话号码格式验证 !(/^([0-9]{3,4}-)?[0-9]{7,8}$/.test(phone))
			if ($.trim($('#txtTelephone').val()) != ""){
				if (!(/^1[3456789]\d{9}$/.test($.trim($('#txtTelephone').val())))) {
					errorStr += '输入的电话号码格式不符合规定！请重新输入!<br>';
				}
			}
			var thisNowDate = Common_GetDate(new Date());
			var thisNowTime = Common_GetTime(new Date());
			if ((Common_CompareDate(AdmitDate,thisNowDate)>0)||((AdmitDate == thisNowDate)&&(AdmitTime >thisNowTime)))  {
				$.messager.alert("提示","抱歉，就诊时间不能大于当前日期!", 'info');
				return false;
			}
			if ((Common_CompareDate(AdmitDate,DeathDate)>0)||((AdmitDate == DeathDate)&&(AdmitTime >DeathTime)))  {
				$.messager.alert("提示","抱歉，就诊时间不能大于死亡时间!", 'info');
				return false;
			}
			if ((Common_CompareDate(SickDate,thisNowDate)>0)||((SickDate == thisNowDate)&&(SickTime >thisNowTime))) {
				$.messager.alert("提示","抱歉，发病时间不能大于当前日期!", 'info');
				return false;
			}
			if ((Common_CompareDate(SickDate,DeathDate)>0)||((SickDate == DeathDate)&&(SickTime >DeathTime))) {
				$.messager.alert("提示","抱歉，发病时间不能大于死亡时间!", 'info');
				return false;
			}
			if ((Common_CompareDate(DeathDate,thisNowDate)>0)||((DeathDate == thisNowDate)&&(DeathTime >thisNowTime)))  {
				$.messager.alert("提示","抱歉，死亡时间不能大于当前日期!", 'info');
				return false;
			}
			if (ExamResult=="") { errorStr = errorStr + "请填写检测结果!<br>"; }
			if (DisCateID=="") { errorStr = errorStr + "请选择诊断分类!<br>"; }
			if (DiseaseID=="") { errorStr = errorStr + "请选择诊断结论!<br>"; }
		
			if (errorStr!="") {
				$.messager.alert("提示", errorStr, 'info');
				return "";
			}
		}
		if (statusCode==6) {
			var errorStr = "";
			if (SickDate=="") { errorStr = errorStr + "请填写发病日期!<br>"; }
			if (SickTime=="") { errorStr = errorStr + "请填写发病时间!<br>"; }
			if (AdmitDate=="") { errorStr = errorStr + "请填写就诊日期!<br>"; }
			if (AdmitTime=="") { errorStr = errorStr + "请填写就诊时间!<br>"; }
			if (errorStr!="") {
				$.messager.alert("提示", errorStr, 'info');
				return "";
			}
		}
		var rows = obj.gridFood.getRows();  //返回当前页的所有行
		var foodLength = rows.length;
		var errorStr = "";
		if (foodLength<1) {
			errorStr = errorStr +"暴露信息至少填写一条!"; 
			if (errorStr!="") {
				$.messager.alert("提示", errorStr, 'info');
				return "";
			}
		}
		
		if (obj.IsUpdatePatInfo==0) {	// 基本信息不改变不存
			PatName = "";
			Sex = "";
			Birthday = "";
		}
		var objPatStr = PatName;
		objPatStr = objPatStr + sepobj + Sex;
		objPatStr = objPatStr + sepobj + Birthday;
		objPatStr = objPatStr + sepobj + "";
		objPatStr = objPatStr + sepobj + "";	// RPNation;	// 民族暂时不需要
		objPatStr = objPatStr + sepobj + "";
		objPatStr = objPatStr + sepobj + "";
		var objPatientData = objPatStr;
		var tmpStr = obj.reportID;	// inputStr
		tmpStr = tmpStr + separate + EpisodeID;
		tmpStr = tmpStr + separate + PatientID;
		tmpStr = tmpStr + separate + DiseaseID;
		tmpStr = tmpStr + separate + "";
		tmpStr = tmpStr + separate + StatusID;
		tmpStr = tmpStr + separate + CardNo;
		tmpStr = tmpStr + separate + objPatientData;	// PatientObj
		tmpStr = tmpStr + separate + IsInHosp;
		tmpStr = tmpStr + separate + "";
		tmpStr = tmpStr + separate + Telephone;
		tmpStr = tmpStr + separate + Company;
		tmpStr = tmpStr + separate + AreaID;
		tmpStr = tmpStr + separate + CurrAddress;
		tmpStr = tmpStr + separate + (CurrProvinceID ? CurrProvince:'');
		tmpStr = tmpStr + separate + (CurrCityID ? CurrCity:'');
		tmpStr = tmpStr + separate + (CurrCountyID ? CurrCounty:'');
		tmpStr = tmpStr + separate + (CurrVillageID ? CurrVillage:'');
		tmpStr = tmpStr + separate + CurrRoad;
		tmpStr = tmpStr + separate + OccupationID;
		tmpStr = tmpStr + separate + SickDate;
		tmpStr = tmpStr + separate + SickTime;
		tmpStr = tmpStr + separate + AdmitDate;
		tmpStr = tmpStr + separate + AdmitTime;
		tmpStr = tmpStr + separate + DeathDate;
		tmpStr = tmpStr + separate + DeathTime;
		tmpStr = tmpStr + separate + "";
		tmpStr = tmpStr + separate + "";
		tmpStr = tmpStr + separate + "";
		tmpStr = tmpStr + separate + ReportLoc;
		tmpStr = tmpStr + separate + ReportUser;
		tmpStr = tmpStr + separate + ReportDate;
		tmpStr = tmpStr + separate + ReportTime;
		tmpStr = tmpStr + separate + CheckUser;
		tmpStr = tmpStr + separate + CheckDate;
		tmpStr = tmpStr + separate + CheckTime;
		tmpStr = tmpStr + separate + "";
		tmpStr = tmpStr + separate + "";
		tmpStr = tmpStr + separate + "";
		tmpStr = tmpStr + separate + "";
		tmpStr = tmpStr + separate + ExamResult;
		tmpStr = tmpStr + separate + DiagDoc;
		console.log(tmpStr);
		return tmpStr;
	}
	// ****************************** ↑↑↑ save
	
}



